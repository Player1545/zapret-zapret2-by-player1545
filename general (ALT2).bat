@echo off
chcp 65001 > nul
:: 65001 - UTF-8

cd /d "%~dp0"

call service.bat load_game_filter
echo:

set "BIN=%~dp0bin\"
set "LISTS=%~dp0lists\"
set "LUA=%~dp0lua\"
cd /d %BIN%

start "zapret: %~n0" /min "%BIN%winws.exe" --debug=0 --wf-tcp=80,443,2053,2083,2087,2096,8443,%GameFilter% --wf-udp=443,19294-19344,50000-50100,%GameFilter% ^
--filter-tcp=80,443,%GameFilter% --ipset="%LISTS%ipset-all.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --dpi-desync=multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_www_google_com.bin" --new ^
--filter-udp=%GameFilter% --ipset="%LISTS%ipset-all.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=12 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp="%BIN%quic_initial_www_google_com.bin" --dpi-desync-cutoff=n2 --new ^
--filter-udp=443 --hostlist-auto="%LISTS%list-auto.txt" --hostlist-auto-fail-threshold=2 --hostlist-auto-fail-time=60 --hostlist-auto-retrans-threshold=2 --hostlist-auto-debug="%BIN%list-auto-logs.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --dpi-desync=hostfakesplit --dpi-desync-hostfakesplit-mod=altorder=1 --dpi-desync-hostfakesplit-midhost=2 --dpi-desync-repeats=11 --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --dpi-desync-ttl=5 --new ^
--filter-tcp=80,443 --hostlist-auto="%LISTS%list-auto.txt" --hostlist-auto-fail-threshold=2 --hostlist-auto-fail-time=60 --hostlist-auto-retrans-threshold=2 --hostlist-auto-debug="%BIN%list-auto-logs.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --dpi-desync=multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_www_google_com.bin"

start "zapret2: %~n0" /min "%BIN%winws2.exe" --debug=0 --wf-tcp-out=80,443,2053,2083,2087,2096,8443,%GameFilter% --wf-udp-out=443,19294-19344,50000-50100,%GameFilter% --wf-tcp-in=80,443,2053,2083,2087,2096,8443,%GameFilter% --wf-udp-in=443,19294-19344,50000-50100,%GameFilter% ^

--lua-init=@"%LUA%zapret-lib.lua" --lua-init=@"%LUA%zapret-antidpi.lua" ^
--lua-init="fake_default_tls = tls_mod(fake_default_tls,'rnd,rndsni')" ^

--blob=quic_google:@"%BIN%quic_initial_www_google_com.bin" ^
--blob=tls_google:@"%BIN%tls_clienthello_www_google_com.bin" ^
--blob=tls_4pda:@"%BIN%tls_clienthello_4pda_to.bin" ^

--filter-udp=443 --filter-l7=quic --hostlist="%LISTS%list-general.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=quic_google:repeats=8:ip_ttl=5 --new ^
--filter-tcp=443 --filter-l7=tls,http --hostlist="%LISTS%list-google.txt" --lua-desync=multisplit:pos=1:seqovl=681:seqovl_pattern=tls_google --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --payload=stun,discord_ip_discovery --lua-desync=fake:blob=quic_google:repeats=8:ip_ttl=5 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --filter-l7=tls,http --hostlist-domains=discord.media --lua-desync=multisplit:pos=1:seqovl=568:seqovl_pattern=tls_google --new ^
--filter-tcp=80,443 --filter-l7=tls,http --hostlist="%LISTS%list-general.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=multisplit:pos=1:seqovl=681:seqovl_pattern=tls_google --new ^
--filter-udp=443 --filter-l7=quic --ipset="%LISTS%ipset-all.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=fake_default_quic:repeats=8:ip_ttl=5 --new ^
--filter-udp=443 --filter-l7=quic --hostlist="%LISTS%list-telegram.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=fake_default_quic:repeats=11 --new ^
--filter-udp=443 --filter-l7=quic --ipset="%LISTS%ipset-telegram.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=fake:blob=fake_default_quic:repeats=11 --new ^
--filter-tcp=80,443 --filter-l7=tls,http --hostlist="%LISTS%list-telegram.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=multisplit:pos=1:seqovl=681:seqovl_pattern=tls_google --new ^
--filter-tcp=80,443 --filter-l7=tls,http --ipset="%LISTS%ipset-telegram.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=multisplit:pos=1:seqovl=681:seqovl_pattern=tls_google --new ^
--filter-udp=590-1400,3478,32000-32010,49224,50000-50100 --filter-l7=stun --ipset="%LISTS%ipset-telegram.txt" --payload=stun --lua-desync=fake:blob=0x00000000000000000000000000000000:repeats=11:ip_ttl=7 --new ^
--filter-udp=* --filter-l7=mtproto --payload=all --lua-desync=fake:blob=0x00000000000000000000000000000000:repeats=11:ip_ttl=7 --new ^
--filter-tcp=* --filter-l7=mtproto --payload=all --lua-desync=multisplit:pos=1:seqovl=681:seqovl_pattern=tls_google --new ^