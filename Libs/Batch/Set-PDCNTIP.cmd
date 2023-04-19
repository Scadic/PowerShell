@ECHO OFF
echo Setup PDC TimeZone and Remote NTP Server
tzutil /l
echo.
tzutil /g
echo Select a timezone from the ones listed above: 
set /p tz=
tzutil /s "%tz%"
w32tm.exe /config /syncfromflags:manual /manualpeerlist:"ntp.uib.no,0x8 ntp-public.uit.no,0x8 ntp.uio.no,0x8 0.no.pool.ntp.org,0x8 1.no.pool.ntp.org,0x8 2.no.pool.ntp.org,0x8 3.no.pool.ntp.org,0x8" /reliable:yes /update
w32tm /resync /rediscover
net stop w32time && net start w32time
w32tm /query /status
@ECHO ON