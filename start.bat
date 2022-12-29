@echo off
@echo off
color 0c
echo -
echo limpando pasta cache, aguarde......
echo -
rd /s /q "cache"
timeout 5
echo ===-------------------------------===
echo ===-------------------------------===
echo     Himalaia Season 1)
echo     Developed by: Equipe Himalaia
echo     Discord: ===================
echo     Contact: ====================
echo ===-------------------------------===


start build/FXServer.exe +exec server.cfg +set onesync on +set onesync_population false
exit