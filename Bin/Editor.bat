@echo off
rem I decided not to comment this program because whotf cares.
if exist "*.removebrak" del /f /q "*.removebrak"
if exist "*.out" del /f /q "*.out"
if exist "tempwebmaneditor.txt" del /f /q "tempwebmaneditor.txt"
setlocal EnableDelayedExpansion
set "hooks=%~1"
if not exist "%~1" (
	echo hooks file not found or not set.
	echo Launching from webman is recommended.
	set /p hooks="Hooks file[32m} [36m"
)
:topmen
cls
color 0f
type "Logo2.ascii"
echo.
echo.
echo [36m1] Add Webhook
echo 2] Remove Webhook
echo 3] View JSON
echo [90mX] Exit[0m
choice /c 123x /n
if %errorlevel%==1 goto addweb
if %errorlevel%==2 goto removeweb
if %errorlevel%==3 goto json
if %errorlevel%==4 exit /b 0
exit /b

:addweb
cls
echo [36mStep 1: What would you like the webhook ID to be?[0m
echo [90mThis is the unique name that will go on your url[0m
set /p newid=">"
echo.
echo [36mStep 2: What type of webhook do you want?[0m
echo [32m1] Launch a program [90m(optionally wait for response)[0m
echo [32m2] Pass parameters to a program [90m(using parameters in the url)[0m
echo [32m3] Read a text file [90m(pretty straight forward)[0m
echo [31mX] Cancel[0m
choice /c 123x
if %errorlevel%==1 goto program
if %errorlevel%==2 goto parameters
if %errorlevel%==3 goto reader
if %errorlevel%==4 goto topmen

:json
cls
if not exist "C:\Program Files\Notepad++\notepad++.exe" (
	start notepad "%hooks%"
	goto endjs
)
echo.
echo [36m1] Notepad++ (GNU)
echo 2] Notepad (MSWin)[90m
echo X] Cancel[0m
choice /c 12x
if "%errorlevel%"=="2" start notepad "%hooks%"
if "%errorlevel%"=="1" start "C:\Program Files\Notepad++\notepad++.exe" "%hooks%"
:endjs
echo Would you like to open the webhook json file guides?
choice /c YN
if %errorlevel%==1 (
	start https://github.com/adnanh/webhook/blob/master/docs/Hook-Examples.md
	start https://github.com/adnanh/webhook/blob/master/docs/Hook-Definition.md
)
goto topmen
	


:reader
cls
echo Enter which file you wish to read
set /p file=">"
set file=%file:"=%
if not exist "%file%" (
	echo File was not found yet.
	echo continue?
	choice
	if !errorlevel!==2 goto tompen
)
echo Compiling code . . .
If Not Exist "%hooks%" Exit /B
copy /Y "%hooks%" "hooks.bak" >nul
echo. 2>"%hooks%" 1>nul
for /f "tokens=* usebackq" %%A in ("hooks.bak") do (
	set tempvar=%%A
	set tempvar=!tempvar:"=!
	if not "!tempvar!"=="]" (
		echo %%A
	)>>"%hooks%.removebrak"
)
copy /Y "%hooks%.removebrak" "%hooks%" >nul
( echo {
echo "id": "%newid%",
echo "execute-command": "Reader.bat",
set tcd=%cd:\=\\%
echo "command-working-directory": "!tcd:"=!",
echo "include-command-output-in-response": true
echo "pass-arguments-to-command": [
echo {
echo "source": "string",
echo "name": "%file%"
echo }
echo ],
echo },)>>"%hooks%"
echo ]>>"%hooks%"
del /f /q "%hooks%.removebrak"
echo [32mComplete?[0m
pause
goto topmen

:parameters
cls
echo [32mLaunch a program with parameters[0m
echo.
echo [36mEnter program to run[90m or drag and drop it onto this window[90m X to cancel[0m
set /p program=">"
set program=%program:"=%
if /i "%program%"=="x" goto topmen
if not exist "%program%" (
	echo [31mProgram was not found. Please check your input and try again.[0m
	pause
	goto parameters
)
for /f "tokens=*" %%A in ('echo "%program%"') do (
	
	set runname=%%~nA%%~xA
	set ppath=%%~pA
	set ddrive=%%~dA
)
set ppath=%ppath:\=\\%
echo.
echo [36mPlease Enter the name of the first parameter[0m
echo [90mThis will be what is put in the url.[0m
set parn=0
:paramloop
set /a parn+=1
set /p param%parn%=">"
set param%parn%=!param%parn%: =!
echo Would you like to add another?
choice
if %errorlevel%==1 goto paramloop
cls
echo [36mWould you like to wait for a response from the program? [90m(This will output it to the user who triggers it.)[0m
echo.
choice
if %errorlevel%==1 set outputline="include-command-output-in-response": true,
if %errorlevel%==2 goto setparamresponse
goto finishprogramparam
:setparamresponse
echo [36mwould you like a custom response message?[0m
choice
if %errorlevel%==2 goto finishprogramparam
echo [32mEnter custom response message:[0m
set /p cusrep=">"
set cusrep=%cusrep:"=%
set cusrep=%cusrep:}=%
set cusrep=%cusrep:{=%
set cusrep=%cusrep:[=%
set cusrep=%cusrep:]=%
set cusrep=%cusrep:,=%
set outputline="response-message": "%cusrep%",
:finishprogramparam
echo.
echo Compiling code . . .
If Not Exist "%hooks%" Exit /B
copy /Y "%hooks%" "hooks.bak" >nul
echo. 2>"%hooks%" 1>nul
for /f "tokens=* usebackq" %%A in ("hooks.bak") do (
	set tempvar=%%A
	set tempvar=!tempvar:"=!
	if not "!tempvar!"=="]" (
		echo %%A
	)>>"%hooks%.removebrak"
)
copy /Y "%hooks%.removebrak" "%hooks%" >nul
( echo {
echo "id": "%newid%",
echo "execute-command": "%runname%",
echo "command-working-directory": "%ddrive%%ppath%",
if defined outputline echo %outputline%
echo "pass-arguments-to-command": [)>>"%hooks%"
set lpn=0
:printparamloop
set /a lpn+=1
( echo {
echo "source": "url",
echo "name": "!param%lpn%!"
if %lpn%==%parn% goto exitparamloop
echo },)>>"%hooks%"
goto printparamloop
:exitparamloop
echo }>>"%hooks%"
echo ],>>"%hooks%"
echo },>>"%hooks%"
echo ]>>"%hooks%"
del /f /q "%hooks%.removebrak"
echo.
echo [32mComplete.[0m
echo.
echo [90mTip: If using a custom program, for spaces, use a character like # or + and replace those with spaces within your program[0m
pause
goto topmen


:program
cls
echo [32mLaunch a program[0m
echo.
echo [36mEnter program to run[90m or drag and drop it onto this window[90m X to cancel[0m
set /p program=">"
set program=%program:"=%
if /i "%program%"=="x" goto topmen
if not exist "%program%" (
	echo [31mProgram was not found. Please check your input and try again.[0m
	pause
	goto program
)
for /f "tokens=*" %%A in ('echo "%program%"') do (
	set runname=%%~nA%%~xA
	set ppath=%%~pA
	set ddrive=%%~dA
)
set ppath=%ppath:\=\\%
echo [36mWould you like to wait for a response from the program? [90m(This will output it to the user who triggers it.)[0m
echo.
choice
if %errorlevel%==1 set outputline="include-command-output-in-response": true,
if %errorlevel%==2 goto setresponse
goto finishprogramsimple
:setresponse
echo [36mwould you like a custom response message?[0m
choice
if %errorlevel%==2 goto finishprogramsimple
echo [32mEnter custom response message:[0m
set /p cusrep=">"
set cusrep=%cusrep:"=%
set cusrep=%cusrep:}=%
set cusrep=%cusrep:{=%
set cusrep=%cusrep:[=%
set cusrep=%cusrep:]=%
set cusrep=%cusrep:,=%
set outputline="response-message": "%cusrep%",
:finishprogramsimple
echo Compiling code . . .
If Not Exist "%hooks%" Exit /B
copy /Y "%hooks%" "hooks.bak" >nul
echo. 2>"%hooks%" 1>nul
for /f "tokens=* usebackq" %%A in ("hooks.bak") do (
	set tempvar=%%A
	set tempvar=!tempvar:"=!
	if not "!tempvar!"=="]" (
		echo %%A
	)>>"%hooks%.removebrak"
)
copy /Y "%hooks%.removebrak" "%hooks%" >nul
( echo {
echo "id": "%newid%",
echo "execute-command": "%runname%",
echo "command-working-directory": "%ddrive%%ppath%",
if defined outputline echo %outputline%
echo },)>>"%hooks%"
echo ]>>"%hooks%"
del /f /q "%hooks%.removebrak"
echo.
echo [32mComplete?[0m
pause
goto topmen




:removeweb
cls
echo [96mCurrent webhooks are:[0m
echo. 2>tempwebmaneditor.txt >nul
for /f "tokens=* usebackq" %%A in ("%hooks%") do (
	echo %%A | find /i """id""" >nul 2>nul
	if !errorlevel!==0 (
		set text=%%~A
		if not "!text:~6,-2!"=="Internal-Ping" echo    [!text:~6,-2!]
		echo !text:~6,-2! >>tempwebmaneditor.txt
	)
)
echo.
echo.
echo Enter name of webhook to remove. [90m-X to exit[0m
set /p remove=">"
if /i "%remove:"=%"=="-X" goto topmen
if /i "%remove:"=%"=="Internal-Ping" (
	echo Cannot remove Internal-Ping Function.
	echo This webhook is required for the program.
	pause
	goto removeweb
)
find "%remove%" "tempwebmaneditor.txt" >nul 2>nul
if not %errorlevel%==0 (
	echo Webhook not found tho.
	echo try harder bro.
	pause
	goto topmen
)
del /f /q tempwebmaneditor.txt
set id=%remove%
set num=0
for /f "tokens=* usebackq" %%A in ("%hooks%") do (
	echo %%A | find /i """id"": ""%ID%""," >nul 2>nul
	if !errorlevel!==0 goto endsearch1
	set /a num+=1
	rem echo [%%~A]
)
echo Error: Could not find id %id% in json file %hooks%
pause

:endsearch1
set firstline=%num%
set /a num+=1
for /f "tokens=* usebackq skip=%firstline%" %%A in ("%hooks%") do (
	echo "%%A" | find /i "}," >nul 2>nul
	if !errorlevel!==0 goto endsearch2
	set /a num+=1
)
echo ERROR: could not find end of block in json file %hooks%
pause
:endsearch2
set lastline=%num%
::removenow
echo Block found. Creating new file . . .
if exist newfile.json del /f /q newfile.json
set /a num=0
for /f "tokens=* usebackq" %%A in ("%hooks%") do (
	set /a num+=1
	if not "%%~A"=="" (
		if !num! GTR %lastline% (echo %%A)>>newfile.json
		if !num! LSS %firstline% (echo %%A)>>newfile.json
	)
)
echo Are you sure you want to remove the webhook %id%?
choice
if %errorlevel%==2 exit /b 0
echo Applying changes . . .
copy /Y "newfile.json" "%hooks%" >nul
del /f /q newfile.json
echo Completed.
pause
exit goto topmen