@echo off
REM Appleify Script v1.1 - Haniasita, 2021

:SETUP
REM Console setup
cls
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do set "DEL=%%a"
REM Script setup
set /a "_totalFiles=0"
set /a "_flacFiles=0"
set /a "_wmaFiles=0"
set /a "_totalOriginalFiles=0"
set "_workingFile=None"
set "_outputFile=None"
set "_targetFolder=None"

REM Run once
title Appleify Script v1.1
call :COLORECHO 5b "Appleify Script - Converts your music library for iTunes support!"
REM Delayed Expansion needs to be enabled AFTER this message so that "!" isn't interpreted as a variable
setlocal EnableDelayedExpansion
echo.

:MENU
echo.
echo - %time%, %date% -
echo.
if "%_targetFolder%" == "None" (
	call :COLORECHO 0c "No folder currently selected"
	echo.
	) else (
	call :COLORECHO 0a "Selected folder"
	echo  : %_targetFolder%
	)
echo.
echo [S]elect directory, [L]ist applicable files, [C]onvert files, [E]xit script
choice /C SLCE /n
echo.
echo - %time%, %date% -
echo.
if %ERRORLEVEL% == 1 call :DIRSELECT
if %ERRORLEVEL% == 2 call :LISTFILES
if %ERRORLEVEL% == 3 (
	call :COLORECHO 07 "This will convert, then"
	call :COLORECHO 0c " replace" 
	echo  files eligible for conversion in your collection.
	call :COLORECHO 07 "Original versions of affected files will be"
	call :COLORECHO 0a " moved" 
	echo  to a folder located where this script resides.
	echo.
	echo Proceed^? [Y/N]
	choice /c YN /n
	if !ERRORLEVEL! == 1 call :CONVFILES
	)
if %ERRORLEVEL% == 4 exit /B
goto :MENU

:DIRSELECT
REM Get user input : Music library path
echo Absolute path of music library :
echo EXAMPLE : D:\Music
set /p "_targetFolder=>"
echo.
REM Check for trailing backslash and truncate if needed
if %_targetFolder:~-1%==\ set "_targetFolder=%_targetFolder:~0,-1%"
REM Check user input and list files if successful
REM Otherwise, reset target folder to default value
if EXIST "%_targetFolder%" (
	call :COLORECHO 0a "Folder found"
	echo.
	echo.
	call :LISTFILES
	goto :MENU
	) else (
	call :COLORECHO 0c "Invalid folder"
	echo.
	set "_targetFolder=None"
	goto :MENU
	)
exit /B

:LISTFILES
REM Exit early if no folder is selected
if %_targetFolder% == None (
	call :COLORECHO 0c "No folder provided"
	echo.
	exit /B
	)
REM Reset counters
set /a "_totalFiles=0"
set /a "_flacFiles=0"
set /a "_wmaFiles=0"
REM Count and display total file count
for /R %_targetFolder% %%F in (*.*) do set /a "_totalFiles=!_totalFiles!+1"
call :COLORECHO 0a "%_totalFiles%"
echo  total files in library
echo.
REM Count files eligible for FLAC conversion, showing path
for /R %_targetFolder% %%F in (*.flac) do (
	set /a "_flacFiles=!_flacFiles!+1"
	call :COLORECHO 0a "Found FLAC file"
	echo  : %%F
	)
echo.
REM Count files eligible for WMA conversion, showing path
for /R %_targetFolder% %%F in (*.wma) do (
	set /a "_wmaFiles=!_wmaFiles!+1"
	call :COLORECHO 0a "Found WMA file"
	echo  : %%F
	)
echo.
REM Display results
call :COLORECHO 0a "%_flacFiles%"
echo  FLAC files eligible for conversion
echo.
call :COLORECHO 0a "%_wmaFiles%"
echo  WMA files eligible for conversion
exit /B

:CONVFILES
REM Exit early if no folder is selected
if %_targetFolder% == None (
	call :COLORECHO 0c "No folder provided"
	echo.
	exit /B
	)
REM Make sure backup folder exists in script folder
if NOT EXIST Originals\ mkdir Originals
REM Perform FLAC to ALAC conversion with FFMPEG
for /R %_targetFolder% %%F in (*.flac) do (
	REM Output current file
	call :COLORECHO 0a "Opening FLAC file"
	echo  : %%F
	REM Process filenames
	set "_workingFile=%%F"
	set "_outputFile=!_workingFile:~0,-5!.m4a"
	REM Convert file using FFMPEG
	call ffmpeg -i "!_workingFile!" -acodec alac -vcodec copy "!_outputFile!" -loglevel quiet
	REM Move original file out of music library
	move "!_workingFile!" Originals\
	)
REM Perform WMA to MP3 conversion with FFMPEG
for /R %_targetFolder% %%F in (*.wma) do (
	REM Output current file
	call :COLORECHO 0a "Opening WMA file"
	echo  : %%F
	REM Process filenames
	set "_workingFile=%%F"
	set "_outputFile=!_workingFile:~0,-4!.mp3"
	REM Convert file using FFMPEG
	call ffmpeg -i "!_workingFile!" -b:a 192k -vcodec copy "!_outputFile!" -loglevel quiet
	REM Move original file out of music library
	move "!_workingFile!" Originals\
	)
echo.
call :COLORECHO 0a "Conversion complete"
echo.
REM Display files moved to Originals
echo.
set /a "_totalOriginalFiles=0"
for /R Originals\ %%F in (*.*) do set /a "_totalOriginalFiles=!_totalOriginalFiles!+1"
call :COLORECHO 0a %_totalOriginalFiles%
echo  files inside Originals folder
echo.
exit /B

:COLORECHO
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i