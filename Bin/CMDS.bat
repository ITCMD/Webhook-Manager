@echo off
set oldnum=NO
setlocal EnableDelayedExpansion
pushd "%TEMP%"
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
set "DEL=%%a"
)
rem Prepare a file "X" with only one dot
<nul > X set /p ".=."


if /i "%1"=="/TS" goto ts
if /i "%1"=="/S" tasklist /fi "imagename eq cmd.exe" /fo list /v & exit /b
if "%1"=="/?" goto help
goto nxt
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
if "%1"=="/w" goto lloop
if "%1"=="/W" goto lloop
:Display
echo [92mCMDS by IT Command       (use /? for help)     %totalnum% Windows Open[0m
echo =====================================================================================
set num=0
setlocal EnableDelayedExpansion
:tpds
set /a num+=1
if %num% LSS 10 call :Colorecho21 08 "%num% ]   "
if %num% GTR 9 call :Colorecho21 08 "%num%]   "

set str=!PID%num%!
set "result=%str::=" & set "result=%"
set result=%result: =%
call :Colorecho21 0b "PID:  %result%  "
if %result% LSS 10000 call :Colorecho21 0f " "
call :Colorecho21 0e "!Mem%num%!  "
echo [92m!Title%num%![0m
if %num%==%totalnum% goto stops11
goto tpds
:stops11
echo =====================================================================================
endlocal
if "%1"=="/p" pause
if "%1"=="/P" pause
if "%2"=="/P" pause
if "%2"=="/p" pause
if "%3"=="/P" pause
if "%3"=="/p" pause

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
if %num% LSS 10 call :Colorecho21 08 "%num% ]   "
if %num% GTR 9 call :Colorecho21 08 "%num%]   "

set str=!PID%num%!
set "result=%str::=" & set "result=%"
set result=%result: =%
call :Colorecho21 0b "PID:  %result%  "
if %result% LSS 10000 call :Colorecho21 0f " "
call :Colorecho21 0e "!Mem%num%!  "
echo [92m!Title%num%![0m
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
echo CMDS [/S] [/P] [/L] [/W] [/TS String]
echo.
echo  /S         Displays the simple but high information version (fast)
echo  /P         Pauses Before Exiting. Usefull if using from Run.
echo  /L         Pauses and refreshes on press of key. Use CTRL+C to quit.
echo  /W         Refreshes only when a new cmd instance starts (new PID).
echo             Note: This will not refresh if an old window closes
echo                   and a new one opens at the same time.
echo  /TS        Use within a batch file to search for a Window Title
echo  String     The Window Title to search for with /TS 
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
call :Colorecho21 0b "  www.ITCommand.tech"
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
if "%~2"=="" exit /b 2
if "!Title%num%!"=="Window Title: %~2" goto isrite
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



