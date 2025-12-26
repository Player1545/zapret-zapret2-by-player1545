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
--filter-tcp=80,443,%GameFilter% --ipset="%LISTS%ipset-all.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=654 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_vk_com.bin" --dpi-desync-fake-tls="%BIN%tls_clienthello_vk_com.bin" --new ^
--filter-udp=%GameFilter% --ipset="%LISTS%ipset-all.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=12 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp="%BIN%quic_initial_vk_com.bin" --dpi-desync-cutoff=n2

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

--filter-udp=443 --filter-l7=quic --hostlist="%LISTS%list-general.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=quic_facebook:repeats=11:ip_ttl=5 --lua-desync=dht_dn --new ^
--filter-tcp=443 --filter-l7=tls,http --hostlist="%LISTS%list-google.txt" --lua-desync=multisplit:pos=1:seqovl=681:seqovl_pattern=tls_google --lua-desync=dht_dn --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --payload=stun,discord_ip_discovery --lua-desync=fake:blob=0x00000000000000000000000000000000:repeats=6:ip_ttl=5 --lua-desync=dht_dn --new ^
--filter-tcp=2053,2083,2087,2096,8443 --filter-l7=tls,http --hostlist-domains=discord.media --lua-desync=multisplit:pos=1:seqovl=654:seqovl_pattern=tls_max --lua-desync=fake:blob=quic_facebook:repeats=11:ip_ttl=5 --lua-desync=dht_dn --new ^
--filter-tcp=80,443 --filter-l7=tls,http --hostlist="%LISTS%list-general.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=multisplit:pos=1:seqovl=681:seqovl_pattern=tls_max --lua-desync=dht_dn --new ^
--filter-udp=443 --filter-l7=quic --ipset="%LISTS%ipset-all.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=quic_facebook:repeats=11:ip_ttl=5 --lua-desync=dht_dn --new ^
--filter-udp=443 --filter-l7=quic --hostlist="%LISTS%list-telegram.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=quic_facebook:repeats=11 --lua-desync=dht_dn --new ^
--filter-udp=443 --filter-l7=quic --ipset="%LISTS%ipset-telegram.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=quic_facebook:repeats=11 --lua-desync=dht_dn --new ^
--filter-tcp=80,443 --filter-l7=tls,http --hostlist="%LISTS%list-telegram.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=multisplit:pos=1:seqovl=681:seqovl_pattern=tls_max --lua-desync=dht_dn --new ^
--filter-tcp=80,443 --filter-l7=tls,http --ipset="%LISTS%ipset-telegram.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=multisplit:pos=1:seqovl=681:seqovl_pattern=tls_max --lua-desync=dht_dn --new ^
--filter-udp=590-1400,3478,32000-32010,49224,50000-50100 --filter-l7=stun --ipset="%LISTS%ipset-telegram.txt" --payload=stun --lua-desync=fake:blob=0x00000000000000000000000000000000:repeats=11:ip_ttl=7 --lua-desync=dht_dn --new ^
--filter-udp=* --filter-l7=mtproto --payload=all --lua-desync=fake:blob=0x00000000000000000000000000000000:repeats=11:ip_ttl=7 --lua-desync=dht_dn --new ^
--filter-tcp=* --filter-l7=mtproto --payload=all --lua-desync=multisplit:pos=1:seqovl=681:seqovl_pattern=tls_max --lua-desync=dht_dn --new ^