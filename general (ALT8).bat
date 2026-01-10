@echo off
chcp 65001 > nul
:: 65001 - UTF-8

cd /d "%~dp0"
::call service.bat status_zapret
call service.bat check_updates
call service.bat load_game_filter
echo:

set "BIN=%~dp0bin\"
set "LISTS=%~dp0lists\"
set "LUA=%~dp0lua\"

cd /d %BIN%

start "zapret: %~n0" /min "%BIN%winws.exe" --debug=0 --wf-tcp=80,443,2053,2083,2087,2096,8443,%GameFilter% --wf-udp=443,19294-19344,50000-50100,%GameFilter% ^
--filter-udp=%GameFilter% --ipset="%LISTS%ipset-all.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=10 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp="%BIN%quic_initial_www_google_com.bin" --dpi-desync-cutoff=n2

start "zapret2: %~n0" /min "%BIN%winws2.exe" --debug=0 --wf-tcp-out=80,443,2053,2083,2087,2096,8443,%GameFilter% --wf-udp-out=443,19294-19344,50000-50100,%GameFilter% --wf-tcp-in=80,443,2053,2083,2087,2096,8443,%GameFilter% --wf-udp-in=443,19294-19344,50000-50100,%GameFilter% ^

--lua-init=@"%LUA%zapret-lib.lua" --lua-init=@"%LUA%zapret-antidpi.lua" ^
--lua-init="fake_default_tls = tls_mod(fake_default_tls,'rnd,rndsni')" ^

--blob=quic_google:@"%BIN%quic_initial_www_google_com.bin" ^
--blob=quic_facebook:@"%BIN%quic_initial_facebook_com.bin" ^
--blob=tls_google:@"%BIN%tls_clienthello_www_google_com.bin" ^
--blob=tls_4pda:@"%BIN%tls_clienthello_4pda_to.bin" ^
--blob=tls_max:@"%BIN%tls_clienthello_max_ru.bin" ^
--blob=tls_vk:@"%BIN%tls_clienthello_vk_com.bin" ^
--blob=tls_sberbank:@"%BIN%tls_clienthello_sberbank_ru.bin" ^

--filter-udp=443 --hostlist="%LISTS%list-general.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=quic_google:repeats=6 --new ^
--filter-l3=ipv4 --filter-tcp=80,443,%GameFilter% --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=hostfakesplit:repeats=4:tcp_ts_up:tcp_md5:host=ozon.ru --new ^
--filter-udp=32000-32010 --filter-l7=stun --ipset="%LISTS%ipset-telegram.txt" --payload=stun --lua-desync=fake:blob=0x00000000000000000000000000000000:repeats=11:ip_ttl=7 --new ^
--filter-udp=* --filter-l7=mtproto --payload=all --lua-desync=fake:blob=0x00000000000000000000000000000000:repeats=11:ip_ttl=7 --new ^
--filter-tcp=* --filter-l7=mtproto --payload=all --lua-desync=hostfakesplit:repeats=4:tcp_ts_up:tcp_md5:host=ozon.ru --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --payload=stun,discord_ip_discovery --lua-desync=fake:blob=quic_google:repeats=6 --new ^
--filter-tcp=443,2053,2083,2087,2096,8443 --hostlist-domains=discord.media --lua-desync=hostfakesplit:repeats=4:tcp_ts_up:host=ozon.ru --new ^
