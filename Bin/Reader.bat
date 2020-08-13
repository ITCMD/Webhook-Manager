@echo off
if "%~1"=="" (
	echo An error occured. No type file was given.
	echo This is an internal error unrelated to the url.
	exit /b
)
type "%~1"
exit /b