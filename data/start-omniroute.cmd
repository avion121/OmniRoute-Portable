@echo off
setlocal EnableExtensions

REM ============================================================
REM PORTABLE OMNIROUTE SERVER
REM ============================================================

pushd "%~dp0.."
set "USB_ROOT=%CD%"
popd

set "PATH=%USB_ROOT%\bin;%PATH%"

set "USERPROFILE=%USB_ROOT%\home"
set "HOME=%USB_ROOT%\home"
set "HOMEDRIVE=%~d0"
set "HOMEPATH=\home"

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
echo Server:
echo http://127.0.0.1:20128
echo.
omniroute

endlocal
