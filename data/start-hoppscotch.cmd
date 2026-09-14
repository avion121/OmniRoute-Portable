@echo off
setlocal EnableExtensions

REM ============================================================
REM PORTABLE HOPPSCOTCH LAUNCHER
REM ============================================================

pushd "%~dp0.."
set "USB_ROOT=%CD%"
popd

set "HOPPSCOTCH_DIR=%USB_ROOT%\hoppscotch"
set "DATA_DIR=%USB_ROOT%\data"
set "HOME_DIR=%USB_ROOT%\home"

set "USERPROFILE=%HOME_DIR%"
set "HOME=%HOME_DIR%"
set "APPDATA=%HOME_DIR%\AppData\Roaming"
set "LOCALAPPDATA=%HOME_DIR%\AppData\Local"
set "TEMP=%DATA_DIR%\temp"
set "TMP=%DATA_DIR%\temp"
set "WEBVIEW2_USER_DATA_FOLDER=%DATA_DIR%\hoppscotch-data"

if not exist "%DATA_DIR%\hoppscotch-data" mkdir "%DATA_DIR%\hoppscotch-data"
if not exist "%DATA_DIR%\temp" mkdir "%DATA_DIR%\temp"

for %%F in ("%HOPPSCOTCH_DIR%\*.exe") do (
    start "" "%%F"
    exit /b 0
)

echo.
echo [ERROR] Hoppscotch executable not found in %HOPPSCOTCH_DIR%
echo Please run Start-OmniRoute.bat to automatically bootstrap Hoppscotch.
echo.
pause

endlocal
