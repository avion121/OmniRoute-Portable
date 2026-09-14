@echo off
setlocal EnableExtensions

REM ============================================================
REM PORTABLE CLAUDE CODE
REM OMNIROUTE LAUNCHER
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

set "CLAUDE_CONFIG_DIR=%USB_ROOT%\data\claude"

set "OMNIROUTE_DATA_DIR=%USB_ROOT%\data"
set "OMNIROUTE_SERVER_HOST=127.0.0.1"

REM ============================================================
REM USE EXISTING OMNIROUTE COMBO
REM ============================================================

set "ANTHROPIC_MODEL=free-stack"

REM Do NOT use direct Anthropic credentials.
set "ANTHROPIC_API_KEY="
set "ANTHROPIC_AUTH_TOKEN="
set "ANTHROPIC_BASE_URL="

cd /d "%USB_ROOT%\workspace"

echo.
echo ============================================================
echo        CLAUDE CODE -^> OMNIROUTE -^> FREE-STACK
echo ============================================================
echo.
echo OmniRoute: http://127.0.0.1:20128
echo Combo: free-stack
echo.
omniroute launch

endlocal
