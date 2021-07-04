@echo off
setlocal EnableDelayedExpansion
if "%~1"=="firewall_admin" goto :preapplyfirewall
mode con:cols=122 lines=35
title Webhook Manager by SetLucas
color 0f
cls
type "Bin\Logo1.ascii"
timeout /t 1 /NOBREAK >nul
set WMver=1.8.8
set update=No
rem Set defaults and check if parameters are set
set F=
set verbose= -verbose
set hooks=hooks.json
set port=9444
set hot=
set security=
set HTTPSpem=
if exist "Bin\Paramsfile.cmd" call "Bin\Paramsfile.cmd"
set parameters=-hooks "%hooks%"%verbose% -port %port%%hot%%security%%HTTPSpem%
rem Check for updates
call "Bin\Winhttpjs.bat" "https://raw.githubusercontent.com/ITCMD/Webhook-Manager/master/version.latest" -saveto "%temp%\wbmngr.latest" >nul 2>nul
if not "%errorlevel%"=="200" (
	echo [91mCould not check for updates. Error %errorlevel%.
	timeout /t 2 >nul
	goto menu
)
set update=yes
find "{%WMver%}" "%temp%\wbmngr.latest" >nul
if "%errorlevel%"=="0" set update=No
:menu
if "%~1"=="/startup" goto :launch
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Webman.lnk" (
	find "%~dpnx0" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Webman.lnk" >nul 2>nul
	if !errorlevel!==0 set Startup=True
)
call "Bin\CMDS.bat" /TS "Webhook.exe Log Window (DNC)"
set PID=%errorlevel%
tasklist | find /i "webhook.exe" >nul 2>nul
if %errorlevel%==0 (
	if "%PID%"=="1" (
		call :error nolog
	)
) ELSE (
	if not "%PID%"=="1" (
		call :error nowbh
	)
)
set handlednoweb=false
set handlednolog=false
:menu2
color 07
cls
type "Bin\Logo1.ascii"
echo.
echo [47;30mWebhook manager powered by Adnanh/webhook                
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if "%PID%"=="1" (
	echo 1] Launch [[31mStopped[47;30m]                                      
) ELSE (
	echo 1] Status [[92mRunning[47;30m]                                      
)
echo 2] Edit Parameters                                       
echo 3] Edit Webhooks                                         
if "%startup%"=="True" (
	echo S] Launch on startup [[32mEnabled[47;30m]                           
) ELSE (
	echo S] Launch on startup [[31mNot Enabled[47;30m]                       
)	
if not "%PID%"=="1" set IFPID=45
if not "%PID%"=="1" echo 4] [31mStop Webhooks[47;30m                                         
if not "%PID%"=="1" echo 5] Run external test                                     
if "%update%"=="yes" echo U] [31mDownload Update[47;30m                                       
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:menuloop
choice /c 123quS%IFPID% /n /t 15 /D q >nul
if %errorlevel%==1 goto interract
if %errorlevel%==2 goto parameters 
if %errorlevel%==3 goto edit
if %errorlevel%==5 goto update
if %errorlevel%==6 goto startup
if %errorlevel%==7 goto stop
if %errorlevel%==8 goto exttest
call "Bin\CMDS.bat" /TS "Webhook.exe Log Window (DNC)"
set nPID=%errorlevel%
if not "%nPID%"=="%PID%" (
	set PID=%nPID%
	goto :menu2
)
goto :menuloop




:error
if "%~1"=="nolog" goto nologerror
if "%handlednoweb%"=="true" goto noweb_fail
cls
echo [91mERROR DETECTED[0m
echo.
echo The Webhook Manager log window is running,
echo however the Webhook.exe service is not running.
echo.
echo Please note that if you have any other programs with
echo a service name "webhook.exe" the programs will interfere
echo with each other when webhook manager is running. If you
echo don't understand what this means it is likely not an issue.
echo.
echo This error can also occur if webhook.exe took a second to stop.
echo This is common on low-spec machines. If this is the case,
echo simply press [Y] and go on with your life.
echo.
echo Did you just attempt to stop the Webhooks program?
choice
if %errorlevel%==1 (
	echo.
	echo Resolving issue by closing the log window.
	if exist "Bin\pid.out" (
		set /p pidtk=<Bin\pid.out
		taskkill /f /pid !pidtk!
		del /f /im Bin\pid.out
	) ELSE (
		call CMDS /tk "Webhook.exe Log Window (DNC)"
	)
	pause
	set handlednoweb=true
	goto menu
) ELSE (
	echo.
	echo The Webhook.exe service may have crashed.
	echo If this was expected, you may continue and
	echo ignore this message. Otherwise, you should
	echo inspect the log file and see if an error
	echo occurred internally.
	echo.
	echo Ending issue by closing log window now
	call CMDS /tk "Webhook.exe Log Window (DNC)"
	echo.
	echo Would you like to open the log file now?
	choice
	if !errorlevel!==1 start "" "log.txt"
	set handlednoweb=true
	goto menu
)

:nologerror
if "%handlednolog%"=="true" goto nolog_fail
taskkill /f /im webhook.exe
set handlednolog=true
goto menu

:noweb_fail
cls
echo [91mERROR DETECTED[0m
echo.
echo The Webhook Manager log window is running,
echo however the Webhook.exe service is not running.
echo.
echo It appears the system just detected this issue a
echo moment ago but was unable to resolve it.
echo.
echo This indicates an issue with this program or an
echo issue with system permissions. If you do not know
echo what could be causing permission issues it is
echo likely the former.
echo.
echo.
echo Please submit the bin\log.txt file and an explain
echo the issue on https://github.com/ITCMD/CMDS/issues
echo for further assistance.
pause
exit

:nolog_fail
cls
echo [91mERROR DETECTED[0m
echo.
echo The Webhook service is running, however the log
echo window (normally minimized) is not running.
echo.
echo The system recently detected this issue and
echo attempted to resolve it but could not.
echo.
echo This implies that you attempted to close the
echo webhook program but the system could not complete
echo this action.
echo.
echo This is likely a permissions issue or a Windows
echo system error.
echo.
echo Please note that [93mThe service is still running
echo and will therefor still accept webhook requests until
echo the task webhook.exe is closed.[0m
echo.
echo If you are not sure how to end the task, restarting
echo your machine should resolve the issue. If this issue
echo continues to happen frequently, please submit your
echo Bin\log.txt file and an explaination to the page
echo https://github.com/ITCMD/CMDS/issues for further
echo assistance. Thank you for your patience.
pause
pause
exit




:text
echo %~2[%~1m%~3[0m%~4
exit /b



:startup
if "%Startup%"=="True" (
	del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Webman.lnk"
	set Startup=
	goto menu
)
cls
echo Adding to startup . . .
timeout /t 2 >nul
@echo off
echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Webman.lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.Arguments = "/startup" >>CreateShortcut.vbs
echo oLink.WorkingDirectory = "%~dp0" >>CreateShortcut.vbs
echo oLink.TargetPath = "%~dpnx0" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs
cscript CreateShortcut.vbs >nul
del CreateShortcut.vbs
echo [92mDone![47;30m  
pause
goto menu



:update
cls
if not "%update%"=="yes" (
	echo [92mYou are already on the latest version.[0m
	pause
	goto :menu
)
echo Downloading and running updator . . .
call "Bin\Winhttpjs.bat" "https://raw.githubusercontent.com/ITCMD/Webhook-Manager/master/UpdateScript.latest" -saveto "%temp%\wbmngr.cmd" >nul 2>nul
if not "%errorlevel%"=="200" (
	echo Could not download updator script.
	echo It is recommended that you install the latest release from
	echo [96;4mhttps://github.com/ITCMD/Webhook-Manager/releases[0m
	pause
	goto menu
)
echo Running updator . . .
"%temp%\wbmngr.cmd" "%cd%"
echo [91mUpdate failed.[0m
pause
exit


:edit
pushd Bin
if not exist Editor.bat (
	echo Editor was not found. Make sure you are up to date!
	popd
	pause
	goto menu
)
call "Editor.bat" "%hooks%"
popd
goto menu

:exttest
set ext=
set extPORT=
set extr=
set extdummy=
set web=
set webr=
set webd=
set webdummy=
color 0f
cls
echo [4mPreparing for External test . . .[0m
echo.
echo Is the external port the same as the internal one (%PORT%)?
choice
if %errorlevel%==2 (
	echo Enter External Port
	set /p extPORT=">"
) ELSE (
	set extPORT=%Port%
)
@Echo off
for /f "tokens=1* delims=: " %%A in (
  'nslookup myip.opendns.com. resolver1.opendns.com 2^>NUL^|find "Address:"'
) Do set ExtIP=%%B
echo Would you like to check a web-address as well as your external IP (%ExtIP%)?
choice
if %errorlevel%==1 (
	echo Enter Web address [include http:// or https://]:
	echo [Do not include the webhook]
	set /p webd=">"
	echo Does the external web address require a port?
	choice
	if !errorlevel!==1 (
		echo Enter web address port:
		set /p WEBextPORT=">"
	)
)
echo.
echo [96mRunning External test on (%ExtIP%)[0m
if exist "Bin\dummy.temp" del /f /q "Bin\dummy.temp" >nul
if "%secure%"=="" (
	call "Bin\Winhttpjs.bat" "http://%ExtIP%:%extPORT%/hooks/Internal-Ping"
) ELSE (
	call "Bin\Winhttpjs.bat" "https://%ExtIP%:%extPORT%/hooks/Internal-Ping"
)
if not "%errorlevel%"=="200" (
	echo The External connection to %ExtIP% on port %extPORT% failed with error %errorlevel%.
	set extr=%errorlevel%
	set ext=failed
)
timeout /t 4 >nul
if not "%ext%"=="failed" (
	if not exist "Bin\dummy.temp" (
		echo On external test, the webhook program responded to the trigger OK,
		echo however the webhook program did not run the trigger. Check the log 
		echo for more details.
		set extdummy=failed
	)
)
if "%webd%"=="" goto handletestresults
echo [96mRunning External test on (%webd%)[0m
if exist "Bin\dummy.temp" del /f /q "Bin\dummy.temp" >nul
if "%WEBextPORT%"=="" (
	set url=%webd%/hooks/Internal-Ping
	call "Bin\Winhttpjs.bat" "%webd%/hooks/Internal-Ping"
) ELSE (
	set url=%webd%:%WEBextPORT%/hooks/Internal-Ping
	call "Bin\Winhttpjs.bat" "%webd%:%WEBextPORT%/hooks/Internal-Ping"
)
if not "%errorlevel%"=="200" (
	set webr=%errorlevel%
	echo The External connection to %url% failed with error %errorlevel%.
	set Web=failed
)
timeout /t 4 >nul
if not "%Web%"=="failed" (
	if not exist "Bin\dummy.temp" (
		set webr=%errorlevel%
		echo.
		echo On external Web test, the webhook program responded to the trigger OK,
		echo however the webhook program did not run the trigger. Check the log 
		echo for more details.
		set webdummy=failed
	)
)
:handletestresults
echo =================================================================================
timeout /t 2 >nul
echo [96mResults:[0m
echo.
echo [4mExternal IP Test on %extIP%:%extPORT%:[0m
if "%ext%"=="failed" (
	call :Failedtext 
	if "%extr%"=="404" (
		echo Connected to Webhook Manager, however the Internal-Ping
		echo webhook was not found. Make sure you are using the webhook
		echo file included with the program, or add the webhook in.
	) ELSE (
		if "%extr%"=="666" (
		echo The Webhook Manager could not be reached.
		echo Connection request was denied. Make sure you
		echo have the correct ports!
		set router=yes
		) ELSE (
			echo Error: %extr%
		)
	)
) ELSE (
	if "%extdummy%"=="failed" (
		call :Failedtext 
		echo Connected to Webhook Manager and recieved a correct
		echo response, however the webhook manager did not perform
		echo the expected trigger.
	) ELSE (
		call :Successtext
	)
)
echo.
if "%webd%"=="" goto NoWebTest
echo [4mExternal Website Test on %url%:[0m
if "%web%"=="failed" (
	call :Failedtext
	if "%webr%"=="404" (
		echo Connected to Webhook Manager, however the Internal-Ping
		echo webhook was not found. Make sure you are using the webhook
		echo file included with the program, or add the webhook in.
		set router=no
	) ELSE (
		if "%webr%"=="666" (
		echo The Webhook Manager could not be reached.
		echo Connection request was denied. Make sure you
		echo have the correct ports and DNS forwarding!
		set router=yes
		) ELSE (
			echo Error: %webr%
		)
	)
) ELSE (
	if "%extdummy%"=="failed" (
		call :Failedtext 
		echo Connected to Webhook Manager and recieved a correct
		echo response, however the webhook manager did not perform
		echo the expected trigger.
		set router=no
	) ELSE (
		call :Successtext
		set router=no
	)
)
:NoWebTest
echo =================================================================================
pause
if "%router%"=="yesWeb" goto router
goto menu


:router
for /f "tokens=1,2* delims=:" %%A in ('ipconfig ^| find "Default Gateway"') do (
	set "tempip=%%~B"
	set "tempip=!tempip: =!"
	ping !tempip! -n 1 -w 50
	if !errorlevel!==0 (
		set routerip=!tempip!
		goto foundrouter
	)
)
:foundrouter
for /f "tokens=1,2* delims=:" %%A in ('ipconfig ^| find "IPv4 Address"') do (
	set "tempip=%%~B"
	set "tempip=!tempip: =!"
	ping !tempip! -n 1 -w 50
	if !errorlevel!==0 (
		set localip=!tempip!
		goto foundlocal
	)
)
:foundlocal
call "Bin\Winhttpjs.bat" "http://%routerip%" -saveto "%temp%\RouterDownload.html" >nul 2>nul
if not "%errorlevel%"=="200" goto genaricrouter
find /I "fios" "%temp%\RouterDownload.html" >nul
if %errorlevel%==0 (
	set Routername=Fios
	set url=https://www.verizonwireless.com/support/knowledge-base-87064/
)
find /I "netgear" "%temp%\RouterDownload.html" >nul
if %errorlevel%==0 (
	set Routername=Netgear
	set url=https://kb.netgear.com/24290/How-do-I-add-a-custom-port-forwarding-service-on-my-Nighthawk-router
)
find /I "TP-Link" "%temp%\RouterDownload.html" >nul
if %errorlevel%==0 (
	set Routername=TP-Link
	set url=https://www.tp-link.com/us/support/faq/134/
)
find /I "Google" "%temp%\RouterDownload.html" >nul
if %errorlevel%==0 (
	set Routername=Google Wifi
	set url=https://support.google.com/wifi/answer/6274503?hl=en
)
find /I "Linksys" "%temp%\RouterDownload.html" >nul
if %errorlevel%==0 (
	set Routername=Linksys
	set url=https://www.linksys.com/us/support-article?articleNum=136711
)
find /I "Belkin" "%temp%\RouterDownload.html" >nul
if %errorlevel%==0 (
	set Routername=Belkin
	set url=https://www.belkin.com/us/support-article?articleNum=10790
)
find /I "Tomato" "%temp%\RouterDownload.html" >nul
if %errorlevel%==0 (
	set Routername=Belkin
	set url=https://www.linksysinfo.org/index.php?threads/help-forwarding-port-using-tomato-firmware.68941/
)
find /I "DD-WRT" "%temp%\RouterDownload.html" >nul
if %errorlevel%==0 (
	set Routername=Belkin
	set url=https://wiki.dd-wrt.com/wiki/index.php/Port_Forwarding
)
if "%Routername%"="" goto :genaricrouter
cls
echo The error you experienced was most likely due to not configuring ports on your Router.
echo We have identified that you have a %Routername% router on %routerip%.
echo You must configure the port %PORT% to be redirected to %localip%
for /f "tokens=*" %%A in ('hostname') do (set hostname=%%~A)
echo or whatever IP is assigned to %hostname%.
echo Press Y to open your router's page and instructions for your router.
echo Press N to exit to menu.
choice
if %errorlevel%==1 (
	start %url%
	start http://%routerip%
)
goto menu

:genaricrouter
cls
echo The error you experienced was most likely due to not configuring ports on your Router.
echo We have identified that you have a router on %routerip%.
echo You must configure the port %PORT% to be redirected to %localip%
for /f "tokens=*" %%A in ('hostname') do (set hostname=%%~A)
echo or whatever IP is assigned to %hostname%.
echo Press Y to open your router's page.
echo Press N to exit to menu.
choice
if %errorlevel%==1 (
	start http://%routerip%
)


:Successtext
echo [92mSuccess. All checks passed with flying colors![0m
exit /b
:Failedtext
echo [91mFailed.[0m
echo.
exit /b
:parameters
color 07
cls
echo Hooks file [Webhooks]    [96m%hooks%[0m  Press 1
if "%security%"==" -secure" (
	echo HTTPS   [over http]      [92mTrue[0m  Press 2
) ELSE (
	echo HTTPS   [over http]      [91mFalse[0m Press 2
)
if "%HTTPSpem%"=="" (
	echo HTTPS Key File           [91mNone  [0mPress 3
) ELSE (
	echo HTTPS Key File           [96m%HTTPSpem% [0m Press 3
)
echo Port [listening]         [96m%port%[0m Press 4
if "%Hot%"=="" (
	echo Hot Reload [auto apply]  [91mFalse[0m Press 5
) ELSE (
	echo Hot Reload [auto apply]  [92mTrue[0m Press 5
)
echo.
netsh firewall show state | find "%port%" >nul
if not %errorlevel%==0 (
	echo [41;97mWARNING:[40;91m Port %port% is not open. Press F to open in firewall.[0m
	set F=F
)
echo [90mwebhook.exe %parameters%[0m
echo [90mPress X to go back
echo [90mPress R to reset to defaults[0m
choice /c 12345XR%F%
if %errorlevel%==1 (
	echo Drag and drop the json Hooks config here and press enter.
	set /p hook=">"
	for /f "tokens=1,2* delims=#" %%A in ('echo Dequote#!Hook!') do (set Hook=%%~B)
	if not exist "!Hook!" (
		echo File not found. Be sure you are dropping a json file or
		echo are entering the full path to the file.
		pause
		goto :parameters
	)
	set Hooks=%Hook%
)
if %errorlevel%==2 (
	if "%security%"==" -secure" (
		set security=
	) ELSE (
		set security= -secure
	)
)
if %errorlevel%==3 (
	echo Drag and drop HTTPS Certificate PRivate Key PEM file here and press enter.
	set /p HTTPSpem=">"
)
if %errorlevel%==4 (
	echo Enter new port:
	set /p port=">"
)
if %errorlevel%==5 (
	if "%HOT%"=="" (
		set Hot= -hotreload
	) ELSE (
		set Hot=
	)
)
if %errorlevel%==6 goto :menu
if %errorlevel%==7 (
	set verbose= -verbose
	set hooks=hooks.json
	set port=9444
	set hot=
	set security=
	set HTTPSpem=
	del /f /q "Bin\Paramsfile.cmd" >nul 2>nul
	goto parameters
)
if %errorlevel%==8 goto firewall
:ApplyCurrentParameters
echo. 2>"Bin\Paramsfile.cmd"
(echo set hooks=%hooks%
echo set verbose=%verbose%
echo set port=%port%
echo set hot=%Hot%
echo set security=%security%
echo set HTTPSpem=%HTTPSpem%
)>>"Bin\Paramsfile.cmd"
set parameters=-hooks "%hooks%"%verbose% -port %port%%hot%%security%%HTTPSpem%
goto parameters


:Firewall
cls
net session >nul 2>nul
if not %errorlevel%==2 goto applyfirewall
echo Admin access is required to run port change
pause
cd>"%temp%\webmancd.data"
powershell start -verb runas '%0' firewall_admin
echo Changes will be applied in a new window.
echo Press any key once finished . . .
pause >nul
goto :parameters
:--------------------------------------    
:preapplyfirewall
title Webhook Manager by ITCMD (Rule Applier)
set /p cdd=<"%temp%\webmancd.data"
for /f "tokens=*" %%A in ('echo %cdd%') do (
	if not "%%~dA"=="%systemdrive%" (%%~dA)
)
cd "%CDD%"
net session >nul 2>nul
if %errorlevel%==2 (
	echo Admin access is required and failed to apply.
	pause
	goto menu
)
if exist "Bin\Paramsfile.cmd" call "Bin\Paramsfile.cmd"
:applyfirewall
set firewallname=Webman-Ports
netsh advfirewall firewall show rule name="%firewallname%" >nul 2>nul
if %errorlevel%==0 (
	echo [92mDeleting old firewall rules . . .[0m
	netsh advfirewall firewall delete rule name="%firewallname%"
	
)
echo [92mAdding two new firewall rules . . .[0m
netsh advfirewall firewall add rule name="%firewallname%" dir=in action=allow protocol=TCP localport=%port%
netsh advfirewall firewall add rule name="%firewallname%" dir=out action=allow protocol=TCP localport=%port%
echo [97mPress any key to exit program . . .[0m
pause>nul
exit /b


:interract
setlocal EnableDelayedExpansion
color 0f
if "%PID%"=="1" goto launch
cls
echo Retrieving Status . . .
find "[Stopped]" "Bin\log.txt" >nul 2>nul
if %errorlevel%==0 (
	echo [91mScript failed and stopped.[0m
	taskkill /f /im webhook.exe
	taskkill /f /PID %PID% >nul 2>nul 
	pause
	goto :menu
)
tasklist | find "webhook.exe" >nul 2>nul
if not "%errorlevel%"=="0" (
	echo [91m Webhook not listening, webhook.exe is not running![0m
	pause
	goto :menu
)
rem add check webhooks json file for local-ping
if "%secure%"=="" (
	call "Bin\Winhttpjs.bat" "http://localhost:%port%/hooks/Internal-Ping" >nul 2>nul
) ELSE (
	call "Bin\Winhttpjs.bat" "https://localhost:%port%/hooks/Internal-Ping" >nul 2>nul
)
if not "%errorlevel%"=="200" (
	echo http[s] status failed, response: %errorlevel%
	echo from url: http[s]://localhost:%port%/hooks/Internal-Ping
	set _err=yea
)
timeout /t 2 >nul
find "Internal-Ping hook triggered successfully" "Bin\Log.txt" >nul 2>nul
if not "%errorlevel%"=="0" (
	echo [91mService failed to respond to internal ping.[0m
	echo View log for further details
) ELSE (
	echo [92mResponded to internal ping successfuly.[0m
)
for /f "tokens=1,2* delims=:" %%A in ('find /c "unable" "Bin\log.txt"') do (
	if "%%~B"==" 0" (
		echo No Errors were found.
	) ELSE (
		call :ErrorsFound "%%~B"
		set _err=yea
	)
)
for /f "tokens=1*" %%A in ('find "got matched" "Bin\log.txt" ^| find /V /C "Internal-Ping"') do (
	set /a Webhookcount=%%~A-2
	echo Webhooks triggered: !Webhookcount!
)
if "%_err%"=="yea" (
	pause
) ELSE (
	timeout /t 2 /NOBREAK
)
echo.[90m++
type "Bin\Log.txt" | more /E
echo.++[0m
echo [92mPress [4mS[92m to stop. Press [4mX[92m to exit to menu.[0m
choice /c SX /n
if %errorlevel%==1 (
	echo [91mStopping Webhooks . . .[0m
	taskkill /F /PID %PID%
	taskkill /F /im webhook.exe
	echo [Stopped by User]>>"Bin\Log.txt"
	call :stopped
	pause
)
endlocal
goto :menu


:stop
echo [91mConfirm immediate stop of webhook program (Y/N)
choice
if %errorlevel%==2 goto menu
echo [91mStopping Webhooks . . .[0m
taskkill /F /im webhook.exe
call CMDS /TK "Webhook.exe Log Window (DNC)"
echo [Stopped by User]>>"Bin\Log.txt"
call :stopped
pause
goto menu

:stopped
echo [92mStopped successfuly.
exit /b

:ErrorsFound
echo [91mFound%~1 Errors.[0m
timeout /t 2 >nul
find "unable" "Bin\log.txt"
exit /b


:nojson
cls
echo Could not start.
echo You do not have any webhooks set.
echo Go into parameter settings and set the
echo path for your webhook file. Not sure where
echo to start? Check out the example file and
echo visit the github page for more info
echo https://github.com/ITCMD/Webhook-Manager
echo.
pause
goto menu

Rem this is here because batch is stupid and cant find launch without it

:launch
if "%~1"=="/startup" SHIFT & set Startup=True
color 0f
set hooker=%hooks:"=%
if not exist "%hooker%" (
	if not exist "Bin\%hooker%" (
		goto nojson
	)
)
cls
find "Internal-Ping" "%hooker%" >nul 2>nul
if not "%errorlevel%"=="0" (
	echo [41;97mWARNING:[40;91m Could not find Internal-Ping in webhooks file.
	echo This may cause the system to fail.
)
echo [92mLaunching system . . .[0m
echo %parameters%>"Bin\param.temp"
start /MIN "" "Bin\Run.bat"
timeout /t 5 /Nobreak >nul
type "Bin\Log.txt"
find "[Stopped]" "Bin\Log.txt" >nul 2>nul
if %errorlevel%==0 goto failed
echo [97mStarted (no longer displaying log on this screen)[0m
echo [90mRunning test in 5 seconds . . .[0m
timeout /t 5 >nul 2>nul
if exist "Bin\dummy.temp" del /f /q "Bin\dummy.temp"
if "%secure%"=="" (
	call "Bin\Winhttpjs.bat" "http://localhost:%port%/hooks/Internal-Ping" >nul 2>nul
) ELSE (
	call "Bin\Winhttpjs.bat" "https://localhost:%port%/hooks/Internal-Ping" >nul 2>nul
)
if not "%errorlevel%"=="200" (
	echo System may not have started successfuly.
	echo http[s] status failed, response: %errorlevel%
	echo from url: http[s]://localhost:%port%/hooks/Internal-Ping
)
timeout /t 2 >nul
call "Bin\CMDS.bat" /TS "Webhook.exe Log Window (DNC)"
set PID=%errorlevel%
find "Internal-Ping hook triggered successfully" "Bin\Log.txt" >nul 2>nul
if not "%errorlevel%"=="0" (
	echo [91mService failed to respond to internal ping.[0m
	echo Please attempt to launch again.
	echo If this continues to happen please restart your computer.
	taskkill /f /im webhook.exe >nul 2>nul
	taskkill /f /PID %PID% >nul 2>nul 
) ELSE (
	echo [92mResponded to internal ping successfuly. System ready.[0m
)
pause
goto :menu


:failed
echo [91mWebhook System failed to start.[0m
pause
goto menu
