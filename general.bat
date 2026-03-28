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

--blob=quic_google:@"%BIN%quic_initial_www_google_com.bin" ^
--blob=quic_vk:@"%BIN%quic_initial_vk_com.bin" ^

--filter-udp=443 --hostlist="%LISTS%list-general.txt" --hostlist="%LISTS%list-general-user.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --hostlist-exclude="%LISTS%list-exclude-user.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude-user.txt" --lua-desync=fake:blob=quic_vk:repeats=6 --new ^
--filter-tcp=80,443 --hostlist="%LISTS%list-general.txt" --hostlist="%LISTS%list-general-user.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --hostlist-exclude="%LISTS%list-exclude-user.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude-user.txt" --lua-desync=hostfakesplit:repeats=4:tcp_ts_up:tcp_md5:host=ozon.ru --new ^
--filter-udp=443 --filter-l7=quic --ipset="%LISTS%ipset-all.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude-user.txt" --lua-desync=fake:blob=quic_vk:repeats=6 --new ^
--filter-tcp=80,443,%GameFilterTCP% --ipset="%LISTS%ipset-all.txt" --hostlist-exclude="%LISTS%list-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --lua-desync=hostfakesplit:repeats=4:tcp_ts_up:tcp_md5:host=ozon.ru --new ^
--filter-tcp=80,443 --hostlist="%LISTS%list-google.txt" --hostlist-domains=googlevideo.com --lua-desync=multidisorder:pos=1,host+2,sld+2,sld+5,sniext+1,sniext+2,endhost-2:seqovl=1 --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --payload=stun,discord_ip_discovery --lua-desync=fake:blob=quic_google:repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --lua-desync=hostfakesplit:repeats=4:tcp_ts_up:tcp_md5:host=google.com --new ^
--filter-udp=%GameFilterUDP% --ipset="%LISTS%ipset-all.txt" --ipset-exclude="%LISTS%ipset-exclude.txt" --ipset-exclude="%LISTS%ipset-exclude-user.txt" --out-range=-n2 --payload=all --lua-desync=fake:blob=quic_google:repeats=10:payload=all