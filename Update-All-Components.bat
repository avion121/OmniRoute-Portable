@echo off
setlocal EnableExtensions EnableDelayedExpansion

TITLE Update All Components - OmniRoute Portable Drive
COLOR 0B

REM ==============================================================================
REM           OMNIROUTE PORTABLE DRIVE - 1-CLICK ALL COMPONENT UPDATER
REM ==============================================================================

set "USB_ROOT=%~dp0"
if "%USB_ROOT:~-1%"=="\" set "USB_ROOT=%USB_ROOT:~0,-1%"

set "BIN_DIR=%USB_ROOT%\bin"
set "PYTHON_DIR=%USB_ROOT%\python"
set "TOOLS_DIR=%USB_ROOT%\tools"
set "PORTABLE_GIT_DIR=%TOOLS_DIR%\git"
set "DATA_DIR=%USB_ROOT%\data"
set "HOME_DIR=%USB_ROOT%\home"
set "TEMP_DIR=%DATA_DIR%\temp"

set "USERPROFILE=%HOME_DIR%"
set "HOME=%HOME_DIR%"
set "HOMEDRIVE=%~d0"
set "HOMEPATH=\home"
set "APPDATA=%HOME_DIR%\AppData\Roaming"
set "LOCALAPPDATA=%HOME_DIR%\AppData\Local"
set "TEMP=%TEMP_DIR%"
set "TMP=%TEMP_DIR%"
set "npm_config_cache=%DATA_DIR%\npm-cache"
set "npm_config_prefix=%BIN_DIR%"
set "npm_config_userconfig=%HOME_DIR%\.npmrc"
set "PIP_CACHE_DIR=%DATA_DIR%\pip-cache"
set "PYTHONNOUSERSITE=1"
set "PYTHONPYCACHEPREFIX=%DATA_DIR%\pycache"
set "GIT_CONFIG_NOSYSTEM=1"
set "GIT_CONFIG_GLOBAL=%HOME_DIR%\.gitconfig"
set "WEBVIEW2_USER_DATA_FOLDER=%DATA_DIR%\hoppscotch-data"
set "DISABLE_AUTO_UPDATER=1"
set "CLAUDE_AUTO_UPDATER=disabled"
set "CLAUDE_CODE_DISABLE_UPDATE_CHECK=1"

set "PATH=%BIN_DIR%;%PYTHON_DIR%;%PYTHON_DIR%\Scripts;%PORTABLE_GIT_DIR%\cmd;%PATH%"

cls
echo ==============================================================================
echo             OMNIROUTE PORTABLE DRIVE - FULL COMPONENT UPDATE
echo ==============================================================================
echo  Root Directory : %USB_ROOT%
echo  Portability    : 100%% Isolated (Zero Host Modification)
echo ==============================================================================
echo.
echo  This will check and update all components to their latest versions:
echo    - Portable Node.js LTS
echo    - Portable Python 3.12, Pip, Setuptools, Wheel
echo    - Portable Git for Windows (MinGit)
echo    - Portable Hoppscotch Desktop
echo    - Portable VS Code
echo    - OmniRoute, Claude Code CLI, Hoppscotch CLI (@latest)
echo.
echo ==============================================================================
echo  Starting update process...
echo.

powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File "%USB_ROOT%\bootstrap.ps1" -RootPath "%USB_ROOT%" -ForceUpdate

if errorlevel 1 (
    echo.
    echo  [ERROR] Update process encountered an error.
    echo  Please check your internet connection and try again.
    echo.
) else (
    echo.
    echo ==============================================================================
    echo  [SUCCESS] All components and packages are up to date!
    echo ==============================================================================
    echo.
)

pause
endlocal
exit /b 0
