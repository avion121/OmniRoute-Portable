@echo off
setlocal EnableExtensions EnableDelayedExpansion

TITLE Portable AI Developer Drive - OmniRoute ^& Claude Code
COLOR 0A

REM ==============================================================================
REM           PORTABLE AI DEVELOPER DRIVE (OMNIROUTE + CLAUDE CODE)
REM ==============================================================================
REM
REM Automated Lifecycle:
REM   1. Validates all prerequisites, directories, and configuration.
REM   2. Auto-downloads and installs Portable Node.js LTS if missing.
REM   3. Auto-downloads and installs Portable Python 3.12 & Pip if missing.
REM   4. Auto-downloads and installs Portable Git for Windows if missing.
REM   5. Auto-downloads and installs Portable Hoppscotch Desktop if missing.
REM   6. Auto-downloads and installs Portable VS Code if missing.
REM   7. Auto-installs and updates OmniRoute, Claude Code & Hoppscotch CLI.
REM   8. Starts OmniRoute AI proxy server in the background and verifies health.
REM   9. Launches Portable VS Code pointing to the isolated workspace.
REM  10. Ready for instant use with: omniroute launch --model free-stack
REM
REM ==============================================================================

REM ------------------------------------------------------------------------------
REM 1. INITIALIZE PORTABLE PATHS & ENVIRONMENT
REM ------------------------------------------------------------------------------
set "USB_ROOT=%~dp0"
if "%USB_ROOT:~-1%"=="\" set "USB_ROOT=%USB_ROOT:~0,-1%"

set "BIN_DIR=%USB_ROOT%\bin"
set "PYTHON_DIR=%USB_ROOT%\python"
set "TOOLS_DIR=%USB_ROOT%\tools"
set "PORTABLE_GIT_DIR=%TOOLS_DIR%\git"
set "HOPPSCOTCH_DIR=%USB_ROOT%\hoppscotch"
set "VSCODE_DIR=%USB_ROOT%\vscode"
set "WORKSPACE_DIR=%USB_ROOT%\workspace"
set "DATA_DIR=%USB_ROOT%\data"
set "HOME_DIR=%USB_ROOT%\home"
set "CLAUDE_DIR=%DATA_DIR%\claude"
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

REM Ensure base portable directories exist
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"
if not exist "%PYTHON_DIR%" mkdir "%PYTHON_DIR%"
if not exist "%TOOLS_DIR%" mkdir "%TOOLS_DIR%"
if not exist "%PORTABLE_GIT_DIR%" mkdir "%PORTABLE_GIT_DIR%"
if not exist "%HOPPSCOTCH_DIR%" mkdir "%HOPPSCOTCH_DIR%"
if not exist "%WORKSPACE_DIR%" mkdir "%WORKSPACE_DIR%"
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
if not exist "%HOME_DIR%" mkdir "%HOME_DIR%"
if not exist "%CLAUDE_DIR%" mkdir "%CLAUDE_DIR%"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
if not exist "%DATA_DIR%\npm-cache" mkdir "%DATA_DIR%\npm-cache"
if not exist "%DATA_DIR%\pip-cache" mkdir "%DATA_DIR%\pip-cache"
if not exist "%DATA_DIR%\pycache" mkdir "%DATA_DIR%\pycache"
if not exist "%HOME_DIR%\AppData\Roaming" mkdir "%HOME_DIR%\AppData\Roaming"
if not exist "%HOME_DIR%\AppData\Local" mkdir "%HOME_DIR%\AppData\Local"

REM Create portable Windows user profile folders (prevents VS Code 'Desktop is unavailable' dialog error)
if not exist "%HOME_DIR%\Desktop" mkdir "%HOME_DIR%\Desktop"
if not exist "%HOME_DIR%\Documents" mkdir "%HOME_DIR%\Documents"
if not exist "%HOME_DIR%\Downloads" mkdir "%HOME_DIR%\Downloads"
if not exist "%HOME_DIR%\Pictures" mkdir "%HOME_DIR%\Pictures"
if not exist "%HOME_DIR%\Music" mkdir "%HOME_DIR%\Music"
if not exist "%HOME_DIR%\Videos" mkdir "%HOME_DIR%\Videos"

set "OMNIROUTE_DATA_DIR=%DATA_DIR%"
set "OMNIROUTE_SERVER_HOST=127.0.0.1"
set "CLAUDE_CONFIG_DIR=%CLAUDE_DIR%"

REM Clear any direct Anthropic API keys so Claude Code routes through OmniRoute
set "ANTHROPIC_API_KEY="
set "ANTHROPIC_AUTH_TOKEN="
set "ANTHROPIC_BASE_URL="
set "ANTHROPIC_MODEL="

set "PATH=%BIN_DIR%;%PYTHON_DIR%;%PYTHON_DIR%\Scripts;%PORTABLE_GIT_DIR%\cmd;%PATH%"

cls
echo ==============================================================================
echo              OMNIROUTE PORTABLE AI DEVELOPER DRIVE
echo ==============================================================================
echo  Root Directory : %USB_ROOT%
echo  Status         : Validating prerequisites and environment...
echo ==============================================================================
echo.

REM ------------------------------------------------------------------------------
REM 2. RUN BOOTSTRAP ENGINE (DYNAMIC AUTO-UPDATE & FULL SYSTEM VERIFICATION)
REM ------------------------------------------------------------------------------
if exist "%USB_ROOT%\bootstrap.ps1" (
    powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File "%USB_ROOT%\bootstrap.ps1" -RootPath "%USB_ROOT%"
    if errorlevel 1 (
        echo.
        echo ==============================================================================
        echo  [ERROR] Component update or system integrity verification failed.
        echo  No background services or applications have been started.
        echo  Please inspect the log messages above and try again.
        echo ==============================================================================
        echo.
        pause
        exit /b 1
    )
) else (
    echo  [WARNING] bootstrap.ps1 not found. Proceeding with existing binaries...
)

REM ------------------------------------------------------------------------------
REM 3. START OMNIROUTE SERVER (BACKGROUND) - ONLY AFTER VERIFICATION PASSES
REM ------------------------------------------------------------------------------
echo ==============================================================================
echo  Starting OmniRoute Proxy Server...
echo ==============================================================================

curl.exe -s http://127.0.0.1:20128/api/monitoring/health >nul 2>&1
if not errorlevel 1 (
    echo  OmniRoute server is already running on http://127.0.0.1:20128
    set "OMNIREADY=1"
    goto SERVER_READY
)

start "" /b omniroute > "%DATA_DIR%\omniroute.log" 2>&1

echo  Waiting for server to become healthy...
set "OMNIREADY="
for /L %%A in (1,1,20) do (
    curl.exe -s http://127.0.0.1:20128/api/monitoring/health >nul 2>&1
    if not errorlevel 1 (
        set "OMNIREADY=1"
        goto SERVER_READY
    )
    timeout /t 1 /nobreak >nul
)

:SERVER_READY
if not defined OMNIREADY (
    echo.
    echo ==============================================================================
    echo  [ERROR] OmniRoute proxy server failed to respond on http://127.0.0.1:20128
    echo  VS Code startup aborted. Check log file: %DATA_DIR%\omniroute.log
    echo ==============================================================================
    echo.
    pause
    exit /b 1
)
echo  OmniRoute Status : ACTIVE ^& READY

REM ------------------------------------------------------------------------------
REM 4. LAUNCH PORTABLE VS CODE - ONLY AFTER SERVER IS HEALTHY
REM ------------------------------------------------------------------------------
echo.
echo  Starting Portable VS Code...
start "" "%VSCODE_DIR%\Code.exe" ^
    --user-data-dir "%DATA_DIR%\vscode-user-data" ^
    --extensions-dir "%DATA_DIR%\vscode-extensions" ^
    "%WORKSPACE_DIR%" ^
    >nul 2>&1

echo  VS Code Status    : STARTED

REM ------------------------------------------------------------------------------
REM 5. READY DASHBOARD & INSTRUCTIONS
REM ------------------------------------------------------------------------------
cls
echo ==============================================================================
echo                   OMNIROUTE PORTABLE DRIVE IS READY!
echo ==============================================================================
echo.
echo   * OmniRoute Proxy   : http://127.0.0.1:20128
echo   * Workspace Folder  : %WORKSPACE_DIR%
echo   * Model Combo       : free-stack (Multi-provider fallback)
echo   * Hoppscotch App    : %HOPPSCOTCH_DIR%
echo.
echo ==============================================================================
echo                               HOW TO USE
echo ==============================================================================
echo.
echo   1. Portable VS Code is now open with your workspace.
echo.
echo   2. Open the integrated terminal in VS Code:
echo      Shortcut: Ctrl + ` (backtick)
echo.
echo   3. Launch Claude Code with free-stack:
echo.
echo         omniroute launch --model free-stack
echo.
echo   4. Test APIs with Hoppscotch CLI or Desktop:
echo.
echo         hopp --help
echo.
echo ==============================================================================
echo.
echo  OmniRoute is running in the background.
echo  Keep this terminal window open while you work.
echo.
echo  Press any key to stop OmniRoute and exit...
pause >nul

endlocal
exit /b 0
