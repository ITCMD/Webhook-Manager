@echo off
title Webhook.exe Log Window (DNC)
mode con:cols=90 lines=30
if not exist "webhook.exe" (
	if exist Bin\*.* cd bin
)
if exist log.txt (
	type log.txt >>OldLogs.txt
)
if not exist "param.temp" (
	echo No parameters file was found.
	echo Unable to launch without launcher.
)
set /p Parameters=<"param.temp"
del /f /q "param.temp"
echo %date% %time% >log.txt
echo [Started] >>log.txt
echo [92mStarting Webhooks Reader . . .[0m
echo [90mKeep this window open or webhooks will stop listening.[0m
echo call webhook.exe %parameters%
call webhook.exe %parameters% 2>&1| tee.bat log.txt /A
echo [Stopped] >>log.txt
echo [31mWebhooks has stopped listening.[90m
exit /b