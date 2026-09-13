@echo off
setlocal EnableExtensions

REM ============================================================
REM PORTABLE CLAUDE CODE
REM OMNIROUTE LAUNCHER
REM ============================================================

pushd "%~dp0.."
set "USB_ROOT=%CD%"
popd

set "PATH=%USB_ROOT%\bin;%PATH%"

set "USERPROFILE=%USB_ROOT%\home"
set "HOME=%USB_ROOT%\home"
set "HOMEDRIVE=%~d0"
set "HOMEPATH=\home"

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
