@echo off
set oldnum=NO
set _pause=false
set _l=false
set _loop=false
set _pauseloop=false
set _visible=false
setlocal EnableDelayedExpansion
pushd "%TEMP%"
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
set "DEL=%%a"
)
rem Prepare a file "X" with only one dot
<nul > X set /p ".=."
rem Find parameters
if "%~1"=="/?" goto help
if "%~1"=="/h" goto help
if "%~1"=="-?" goto help
if "%~1"=="-h" goto help
if "%~1"=="--help" goto help
if "%~1"=="-help" goto help
if /i "%~1"=="/S" tasklist /fi "imagename eq cmd.exe" /fo list /v & exit /b
echo "{%~1} {%~2} {%~3} {%~4} {%~5} {%~6} {%~7}" | find /i "/TS" >nul 2>nul
if %errorlevel%==0 goto loopforts
echo "{%~1} {%~2} {%~3} {%~4} {%~5} {%~6} {%~7}" | find /i "/TK" >nul 2>nul
if %errorlevel%==0 goto loopfortk
echo "{%~1} {%~2} {%~3} {%~4} {%~5} {%~6} {%~7}" | find /i "/s" >nul 2>nul
if %errorlevel%==0 set _silent=true
echo "{%~1} {%~2} {%~3} {%~4} {%~5} {%~6} {%~7}" | find /i "/p" >nul 2>nul
if %errorlevel%==0 set _pause=true
echo "{%~1} {%~2} {%~3} {%~4} {%~5} {%~6} {%~7}" | find /i "/w" >nul 2>nul
if %errorlevel%==0 set _loop=true
echo "{%~1} {%~2} {%~3} {%~4} {%~5} {%~6} {%~7}" | find /i "/v" >nul 2>nul
if %errorlevel%==0 set _visible=true
echo "{%~1} {%~2} {%~3} {%~4} {%~5} {%~6} {%~7}" | find /i "/g" >nul 2>nul
if %errorlevel%==0 goto get
echo "{%~1} {%~2} {%~3} {%~4} {%~5} {%~6} {%~7}" | find /i "/k" >nul 2>nul
if %errorlevel%==0 goto lkill
echo "{%~1} {%~2} {%~3} {%~4} {%~5} {%~6} {%~7}" | find /i "/l" >nul 2>nul
if %errorlevel%==0 set _pauseloop=true & cls
goto nxt



:lkill
if /i "%~1"=="/k" (
	set _gv=%~2
) Else (
	shift
	goto lkill
)
if "%_gv%"=="" (
	echo Error: Syntax incorrect. Provide a value for /k.
	exit /b 2
)

if "%_visible%"=="true" (
	echo Error: Cannot use with /v.
	exit /b 2
)

:: ===================== PID ========================
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "PID:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set PID!num!=%%A
)
if "%_loop%"=="true" goto lloop
set num=0

if "!PID%_gv%!"=="" (
	echo Error: Entry %_gv% not found.
	exit /b 1
)
set output=!PID%_gv%: =!
set output=%output:~4,100%
taskkill /f /pid "%output%"
exit /b 0




:get
if /i "%~1"=="/g" (
	set _gv=%~2
) Else (
	shift
	goto get
)
if "%_gv%"=="" (
	echo Error: Syntax incorrect. Provide a value for /g.
	exit /b 2
)

if "%_visible%"=="true" (
	echo Error: Cannot use with /v.
	exit /b 2
)

:: ===================== PID ========================
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "PID:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set PID!num!=%%A
)
if "%_loop%"=="true" goto lloop
set num=0

if "!PID%_gv%!"=="" (
	echo Error: Entry %_gv% not found.
	exit /b 1
)
set output=!PID%_gv%: =!
set output=%output:~4,100%
echo | set /p="%output%"|clip
exit /b 0





:loopfortk
if /i "%~1"=="/TK" goto endfortkloop
if "%~1"=="" echo Error. Could not find tk. & exit /b
shift
goto loopfortk
:endfortkloop
shift
set _ts=%~1
goto taskkill


:taskkill
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "Window Title:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set Title!num!=%%A
set totalnum=!num!
)
:: ===================== Memory =======================
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "Mem Usage:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set Mem!num!=%%A
)

:: ===================== PID ========================
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "PID:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set PID!num!=%%A
)
setlocal EnabledelayedExpansion
set num=0
:tkloop
set /a num+=1
if "!Title%num%!"=="Window Title: %_ts%" goto isritetk
if %num%==%totalnum% exit /b 1
goto tkloop
:isritetk
::window was found
set str=!PID%num%!
set "result=%str::=" & set "result=%"
set result=%result: =%
popd
taskkill /f /im %result%
exit /b

:loopforts
if /i "%~1"=="/TS" goto endfortsloop
if "%~1"=="" echo Error. Could not find ts. & exit /b
shift
goto loopforts
:endfortsloop
shift
set _ts=%~1
goto ts

:nxt
::Setlocal EnableDelayedExpansion
:: ===================== Window Title =================
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "Window Title:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set Title!num!=%%A
set totalnum=!num!
)



:: ===================== Memory =======================
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "Mem Usage:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set Mem!num!=%%A
)

:: ===================== PID ========================
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "PID:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set PID!num!=%%A
)
if "%_loop%"=="true" goto lloop
rem if /i "%1"=="/w" goto lloop
:Display
echo [92mCMDS by IT Command       (use /? for help)     %totalnum% Windows Open[0m
echo =====================================================================================
set num=0
setlocal EnableDelayedExpansion
:tpds
set /a num+=1
if "%_visible%"=="true" (
	echo !Title%num%! | find /i "Window Title: C:\Windows\System32\cmd.exe" >nul 2>nul
	if !errorlevel!==0 goto detstop
	echo !Title%num%! | find /i "Window Title: Select C:\Windows\System32\cmd.exe" >nul 2>nul
	if !errorlevel!==0 goto detstop
)
if %num% LSS 10 call :Colorecho21 08 "%num% ]   "
if %num% GTR 9 call :Colorecho21 08 "%num%]   "

set str=!PID%num%!
set "result=%str::=" & set "result=%"
set result=%result: =%
call :Colorecho21 0b "PID:  %result%  "
if %result% LSS 10000 call :Colorecho21 0f " "
call :Colorecho21 0e "!Mem%num%!  "
echo [92m!Title%num%![0m
:detstop
if %num%==%totalnum% goto stops11
goto tpds
:stops11
echo =====================================================================================
endlocal
if "%_pause%"=="true" pause

if "%1"=="/l" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
if "%1"=="/L" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
if "%2"=="/l" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
if "%2"=="/L" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
if "%3"=="/l" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
if "%3"=="/L" echo Press any key to continue or CTRL+C to quit . . . & pause>nul & cls & goto nxt
goto exit


:Displayl1
echo [92mCMDS by IT Command       (use /? for help)     %totalnum% Windows Open[0m
echo =====================================================================================
set num=0
setlocal EnableDelayedExpansion
:tpdsl1
set /a num+=1

if "%_visible%"=="true" (
	echo !Title%num%! | find /i "Window Title: C:\Windows\System32\cmd.exe" >nul 2>nul
	if !errorlevel!==0 goto detstop11
	echo !Title%num%! | find /i "Window Title: Select C:\Windows\System32\cmd.exe" >nul 2>nul
	if !errorlevel!==0 goto detstop11
)

if %num% LSS 10 call :Colorecho21 08 "%num% ]   "
if %num% GTR 9 call :Colorecho21 08 "%num%]   "

set str=!PID%num%!
set "result=%str::=" & set "result=%"
set result=%result: =%
call :Colorecho21 0b "PID:  %result%  "
if %result% LSS 10000 call :Colorecho21 0f " "
call :Colorecho21 0e "!Mem%num%!  "
echo [92m!Title%num%![0m
:detstop11
if %num%==%totalnum% goto stops11l11
goto tpdsl1
:stops11l11
echo =====================================================================================
:stops11l1
(
endlocal
set oldnum=%num%
)
timeout /t 3 >nul
Setlocal EnableDelayedExpansion
goto nxt


:lloop
if %oldnum%==NOT goto displayl1
if %num%==%oldnum% goto stops11l1
cls
goto displayl1





:help
call :Colorecho21 0f "CMDS Command Prompt Window Lister by IT Command"
echo.
echo.
echo CMDS [/S] [/P] [/L] [/W] [/V] [/G Num] [/K Num] [/TK String] [/TS String]
echo.
echo  /S         Displays the simple but high information version (fast)
echo  /P         Pauses Before Exiting. Usefull if using from Run.
echo  /L         Pauses and refreshes on press of key. Use CTRL+C to quit.
echo  /W         Refreshes only when a new cmd instance starts (new PID).
echo             Note: This will not refresh if an old window closes
echo                   and a new one opens at the same time.
echo  /G         For use when listing entries. Copies an entry from a
echo             displayed list to clipboard.
echo  /K         For use when listing entries. Kills an entry from
echo             displayed list.
echo  Num        The number of the entry to copy to clipboard or kill.
echo  /V         Ignores unnamed windows.
echo  /TS        Use within a batch file to search for a Window Title.
echo  /TK        Use within a batch file to kill a matching Window Title.
echo  String     The Window Title to search for with /TS or /TK
echo.
echo.
echo  with /TS the errorlevel will be set to 1 if the title was not found.
echo  If it is found, the errorlevel will be set to the PID of the cmd instance.
echo.
pause
echo.
echo Example:
echo.
echo    CMDS /TS "My Window"
echo.
echo     The Above Command Will set the errorlevel to the PID of the cmd instance
echo     with the title "My Window" (set with the title command). If the instance
echo     is not found (there is no running window) the errorlevel will be 1.
echo     if the Syntax was incorrect, errorlevel will be set to 2.
echo.
echo.
call :Colorecho21 07 " Created by Lucas Elliott with IT Command"
call :Colorecho21 0b "  www.ITCommand.net"
echo.
echo.
goto exit

:ts
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "Window Title:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set Title!num!=%%A
set totalnum=!num!
)
:: ===================== Memory =======================
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "Mem Usage:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set Mem!num!=%%A
)

:: ===================== PID ========================
set num=0
tasklist /fi "imagename eq cmd.exe" /fo list /v | find /I "PID:" >System
for /F "tokens=*" %%A in  (System) do  (
set /a num+=1
set PID!num!=%%A
)
setlocal EnabledelayedExpansion
set num=0
:tsloop
set /a num+=1
if "!Title%num%!"=="Window Title: %_ts%" goto isrite
if %num%==%totalnum% goto nonets
goto tsloop
:isrite
::window was found
set str=!PID%num%!
set "result=%str::=" & set "result=%"
set result=%result: =%
popd
exit /b %result%

:nonets
popd
endlocal
exit /b 1

:colorEcho21
set "param=^%~2" !
set "param=!param:"=\"!"
findstr /p /A:%1 "." "!param!\..\X" nul
<nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
exit /b


:exit
popd
endlocal
exit /b



