@ECHO OFF
REM Source found on https://github.com/DieterDePaepe/windows-scripts
REM Please share any improvements made!

IF [%1]==[/?] GOTO :help
IF [%1]==[/help] GOTO :help
IF [%1]==[--help] GOTO :help
IF [%1]==[] GOTO :addCurrentFolder

REM Default behaviour: %1 is a folder to be added to PATH.

REM Explanation for the variables used in the IF construct:
REM Quoting is needed, because %1 may contain a ")", which would interupt parsing of the IF
REM %f1 expands the filename, so relative paths become absolute in PATH
REM %~1 removes any quotes from %1
REM \* does a folder check that is compatible with symlinked folders
REM    source: http://stackoverflow.com/questions/138981/how-do-i-test-if-a-file-is-a-directory-in-a-batch-script 

REM Check if %1 is a folder and if so: add it to the PATH.
IF EXIST "%~f1\*" (
	SET "PATH=%~f1;%PATH%"
	ECHO Path updated!
	GOTO :eof
) ELSE (
	ECHO Error: "%~1" does not appear to be a directory.
	exit /b 1
)

:addCurrentFolder
SET PATH=%cd%;%PATH%
ECHO Path updated!
GOTO :eof

:help
ECHO Add a folder to the PATH of this console.
ECHO.
ECHO   addToPath /?			Display this help.
ECHO   addToPath [folder]		Add the specified folder to the PATH.
ECHO   addToPath			Add the current folder to the PATH.
ECHO.