@ECHO OFF
REM Source found on https://github.com/DieterDePaepe/windows-scripts
REM Please share any improvements made!

REM Prevent environment variable pollution
setlocal

REM Folder where all links will end up
set WARP_REPO=%USERPROFILE%\.warp
set WARP_CURRENT=%WARP_REPO%\__CURRENT__
REM Needed to calculate substring on command later on
set WARP_COMMAND_ISSUED=%1

IF [%1]==[/?] GOTO :help
IF [%1]==[/help] GOTO :help
IF [%1]==[--help] GOTO :help
IF [%1]==[] GOTO :current
IF [%1]==[/create] GOTO :create
IF [%1]==[/list] GOTO :list
IF [%1]==[/remove] GOTO :remove
IF [%1]==[/window] GOTO :explorer
IF [%WARP_COMMAND_ISSUED:~0,1%]==[/] GOTO :unknowncommand

REM Command: warp <bookmark>
set /p WARP_DIR=<%WARP_REPO%\%1
endlocal && pushd %WARP_DIR% && echo %WARP_DIR% > %WARP_CURRENT% && GOTO :end

:current
set /p WARP_DIR=<%WARP_CURRENT%
endlocal && pushd %WARP_DIR% && GOTO :end

:explorer
IF [%2]==[] (
  ECHO Missing name
  GOTO :EOF
)
set /p WARP_DIR=<%WARP_REPO%\%2
START explorer %WARP_DIR%
GOTO :end

:create
IF [%2]==[] (
  ECHO Missing name for bookmark
  GOTO :EOF
)

if not exist %WARP_REPO%\NUL mkdir %WARP_REPO%
ECHO %cd% > %WARP_REPO%\%2
ECHO Created bookmark "%2"
GOTO :end

:list
REM Delayed expansion needed to change variable inside the loop.
setlocal enabledelayedexpansion
for %%f in (%WARP_REPO%\*) do (
    set /p LOCATION=<%%f
	REM %%~nf = filename of loop variable %%f
    echo %%~nf: !LOCATION!
)
setlocal disabledelayedexpansion
GOTO :end

:unknowncommand
ECHO Unknown Warp command: %1
GOTO :end

:remove
IF [%2]==[] (
  ECHO Missing name for bookmark
  GOTO :EOF
)
if not exist %WARP_REPO%\%2 (
  ECHO Bookmark does not exist: %2
  GOTO :EOF
)
del %WARP_REPO%\%2
GOTO :end

:help
ECHO Create or navigate to folder bookmarks.
ECHO.
ECHO   warp /?			Display this help
ECHO   warp [bookmark]		Navigate to existing bookmark
ECHO   warp				Navigate to last visited bookmark
ECHO   warp /create [bookmark]	Navigate to existing bookmark
ECHO   warp /list			List existing bookmarks
ECHO   warp /remove [bookmark]	Remove an existing bookmark
ECHO   warp /window [bookmark]	Open an existing bookmark in explorer
ECHO.

:end