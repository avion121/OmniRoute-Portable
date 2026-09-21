@echo off
setlocal EnableExtensions

REM ============================================================
REM PORTABLE OMNIROUTE SERVER
REM ============================================================

pushd "%~dp0.."
set "USB_ROOT=%CD%"
popd

set "PATH=%USB_ROOT%\bin;%USB_ROOT%\python;%USB_ROOT%\python\Scripts;%USB_ROOT%\tools\git\cmd;%PATH%"

set "USERPROFILE=%USB_ROOT%\home"
set "HOME=%USB_ROOT%\home"
set "HOMEDRIVE=%~d0"
set "HOMEPATH=\home"
set "APPDATA=%USB_ROOT%\home\AppData\Roaming"
set "LOCALAPPDATA=%USB_ROOT%\home\AppData\Local"
set "TEMP=%USB_ROOT%\data\temp"
set "TMP=%USB_ROOT%\data\temp"
set "npm_config_cache=%USB_ROOT%\data\npm-cache"
set "npm_config_prefix=%USB_ROOT%\bin"
set "npm_config_userconfig=%USB_ROOT%\home\.npmrc"
set "PIP_CACHE_DIR=%USB_ROOT%\data\pip-cache"
set "PYTHONNOUSERSITE=1"
set "PYTHONPYCACHEPREFIX=%USB_ROOT%\data\pycache"
set "GIT_CONFIG_NOSYSTEM=1"
set "GIT_CONFIG_GLOBAL=%USB_ROOT%\home\.gitconfig"
set "DISABLE_AUTO_UPDATER=1"
set "CLAUDE_AUTO_UPDATER=disabled"
set "CLAUDE_CODE_DISABLE_UPDATE_CHECK=1"

set "OMNIROUTE_DATA_DIR=%USB_ROOT%\data"
set "OMNIROUTE_SERVER_HOST=127.0.0.1"

echo.
echo ============================================================
echo             PORTABLE OMNIROUTE SERVER
echo ============================================================
echo.
echo Data:
echo %OMNIROUTE_DATA_DIR%
echo.
echo Starting Multi-Gateway Bridge...
start /b "" node "%USB_ROOT%\data\gateway-bridge.js" > "%USB_ROOT%\data\logs\gateway-bridge.log" 2>&1
echo.
echo Server:
echo http://127.0.0.1:20128
echo.
omniroute

endlocal
