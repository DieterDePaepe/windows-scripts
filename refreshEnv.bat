@ECHO OFF
REM Source found on https://github.com/DieterDePaepe/windows-scripts
REM Please share any improvements made!

REM Code inspired by http://stackoverflow.com/questions/171588/is-there-a-command-to-refresh-environment-variables-from-the-command-prompt-in-w

IF [%1]==[/?] GOTO :help
IF [%1]==[/help] GOTO :help
IF [%1]==[--help] GOTO :help
IF [%1]==[] GOTO :main

ECHO Unknown command: %1
EXIT /b 1 

:help
ECHO Refresh the environment variables in the console.
ECHO.
ECHO   refreshEnv		Refresh all environment variables.
ECHO   refreshEnv /?		Display this help.
GOTO :EOF

:main
REM Because the environment variables may refer to other variables, we need a 2-step approach.
REM One option is to use delayed variable evaluation, but this forces use of SETLOCAL and
REM may pose problems for files with an '!' in the name.
REM The option used here is to create a temporary batch file that will define all the variables.

REM Check to make sure we don't overwrite an actual file.
IF EXIST %TEMP%\__refreshEnvironment.bat (
  ECHO Environment refresh failed!
  ECHO.
  ECHO This script uses a temporary file "%TEMP%\__refreshEnvironment.bat", which already exists. The script was aborted in order to prevent accidental data loss. Delete this file to enable this script.
  EXIT /b 1
)

REM Read the system environment variables from the registry except PATH (see below) and USERNAME (to avoid the value 'SYSTEM' replacing the real USERNAME)
FOR /F "usebackq tokens=1,2,* skip=2" %%I IN (`REG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"`) DO (
  REM /I -> ignore casing, since PATH may also be called Path
  IF /I NOT [%%I]==[PATH] IF /I NOT [%%I]==[USERNAME] (
    ECHO SET %%I=%%K>>%TEMP%\__refreshEnvironment.bat
  )
)

REM Read the user environment variables from the registry except PATH (see below).
FOR /F "usebackq tokens=1,2,* skip=2" %%I IN (`REG QUERY "HKCU\Environment"`) DO (
  REM /I -> ignore casing, since PATH may also be called Path
  IF /I NOT [%%I]==[PATH] (
    ECHO SET %%I=%%K>>%TEMP%\__refreshEnvironment.bat
  )
)

REM PATH is a special variable: it is automatically merged based on the values in the
REM system and user variables.
REM Read the PATH variable from the system environment variables.
FOR /F "usebackq tokens=1,2,* skip=2" %%I IN (`REG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "PATH"`) DO (
  ECHO SET PATH=%%K>>%TEMP%\__refreshEnvironment.bat
)

REM Read the PATH variable from the user environment variables.
REM Testing the result of the query to avoid error message (the variable PATH for CURRENT USER may not be present).
REG QUERY "HKCU\Environment" /v "PATH" >NUL 2>&1
if "%errorlevel%"=="0" (
	FOR /F "usebackq tokens=1,2,* skip=2" %%I IN (`REG QUERY "HKCU\Environment" /v "PATH"`) DO (
		ECHO SET PATH=%%PATH%%;%%K>>%TEMP%\__refreshEnvironment.bat
	)
)

REM Load the variable definitions from our temporary file.
CALL %TEMP%\__refreshEnvironment.bat

REM Clean up after ourselves.
DEL /F /Q %TEMP%\__refreshEnvironment.bat >NUL 2>&1

ECHO Environment successfully refreshed.
