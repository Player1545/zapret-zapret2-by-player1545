@echo off
chcp 65001 > nul
:: 65001 - UTF-8

cd /d "%~dp0"
::call service.bat status_zapret
call service.bat check_updates
call service.bat load_game_filter
call service.bat load_user_lists
echo:

set "BIN=%~dp0bin\"
set "LISTS=%~dp0lists\"
set "LUA=%~dp0lua\"
set "WdFilter=%~dp0windivert.filter\"

cd /d %BIN%

start "zapret2: %~n0" /min "%BIN%winws2.exe" --debug=0 --ctrack-disable=0 --ipcache-lifetime=8400 --ipcache-hostname=1 --wf-tcp-out=80,443,2053,2083,2087,2096,8443,%GameFilter% --wf-udp-out=443,19294-19344,50000-50100,%GameFilter% --wf-raw-part=@"%WdFilter%windivert_part.discord_media.txt" --wf-raw-part=@"%WdFilter%windivert_part.stun.txt" --wf-raw-part=@"%WdFilter%windivert_part.wireguard.txt" ^

--lua-init=@"%LUA%zapret-lib.lua" ^
--lua-init=@"%LUA%zapret-antidpi.lua" ^
--lua-init=@"%LUA%zapret-auto.lua" ^
--lua-init=@"%LUA%zapret-multishake.lua" ^

--blob=tls_google:@"%BIN%tls_clienthello_www_google_com.bin" ^
--blob=tls_4pda:@"%BIN%tls_clienthello_4pda_to.bin" ^
--blob=tls_max:@"%BIN%tls_clienthello_max_ru.bin" ^
--blob=quic_dbankcloud:@"%BIN%quic_initial_dbankcloud_ru.bin" ^
--blob=quic_3:@"%BIN%quic_3.bin" ^
--blob=stun:@"%BIN%stun.bin" ^
--blob=tls_14:@"%BIN%tls_clienthello_14.bin" ^

--template=tcp --lua-desync=fake:blob=tls_14:blob=stun:repeats=6:tcp_ts=-600000:payload=tls_client_hello --lua-desync=fake:blob=tls_14:repeats=6:tcp_ts=-600000:payload=http_req --new ^
--template=udp --payload=quic_initial --lua-desync=fake:blob=quic_3:repeats=6 --new ^
--template=udp_fake --lua-desync=fake:blob=quic_3:repeats=6 --new ^
--template=tcp_twitch --lua-desync=send:repeats=2:ip_id=zero --lua-desync=syndata:ip_id=zero --lua-desync=pktmod:ip_id=zero --new ^
--filter-udp=443 --hostlist="%LISTS%list-general.txt" --hostlist="%LISTS%list-general-user.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --hostlist-exclude="%LISTS%list-exclude-user.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude-user.txt" --import=udp --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --import=udp_fake --new ^
--filter-tcp=443,2053,2083,2087,2096,8443 --hostlist-domains=discord.media --import=tcp --new ^
--filter-tcp=80,443 --hostlist="%LISTS%list-google.txt" --import=tcp --new ^
--filter-udp=443 --hostlist="%LISTS%list-google.txt" --import=udp --new ^
--filter-tcp=80,443,8080,8443 --hostlist="%LISTS%list-twitch.txt" --import=tcp_twitch --new ^
--filter-udp=443 --hostlist="%LISTS%list-twitch.txt" --import=udp --new ^
--filter-tcp=80,443 --hostlist="%LISTS%list-general.txt" --hostlist="%LISTS%list-general-user.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --hostlist-exclude="%LISTS%list-exclude-user.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude-user.txt" --import=tcp --new ^
--filter-udp=443 --ipset="%LISTS%ipset-all.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --hostlist-exclude="%LISTS%list-exclude-user.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude-user.txt" --import=udp --new ^
--filter-tcp=80,443,8443 --ipset="%LISTS%ipset-all.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --hostlist-exclude="%LISTS%list-exclude-user.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude-user.txt" --import=tcp --new ^
--filter-tcp=%GameFilterTCP% --ipset="%LISTS%ipset-all.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude-user.txt" --out-range=-n5 --payload=all --lua-desync=fake:blob=tls_14:repeats=6:tcp_ts=-1000:payload=all --new ^
--filter-udp=%GameFilterUDP% --ipset="%LISTS%ipset-all.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude-user.txt" --payload=all --lua-desync=fake:blob=quic_3:repeats=6:payload=all