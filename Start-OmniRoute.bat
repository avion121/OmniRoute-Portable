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
REM   3. Auto-downloads and installs Portable VS Code if missing.
REM   4. Auto-installs and updates OmniRoute & Claude Code to the latest versions.
REM   5. Starts OmniRoute AI proxy server in the background and verifies health.
REM   6. Launches Portable VS Code pointing to the isolated workspace.
REM   7. Ready for instant use with: omniroute launch --model free-stack
REM
REM ==============================================================================

REM ------------------------------------------------------------------------------
REM 1. INITIALIZE PORTABLE PATHS & ENVIRONMENT
REM ------------------------------------------------------------------------------
set "USB_ROOT=%~dp0"
if "%USB_ROOT:~-1%"=="\" set "USB_ROOT=%USB_ROOT:~0,-1%"

set "BIN_DIR=%USB_ROOT%\bin"
set "VSCODE_DIR=%USB_ROOT%\vscode"
set "WORKSPACE_DIR=%USB_ROOT%\workspace"
set "DATA_DIR=%USB_ROOT%\data"
set "HOME_DIR=%USB_ROOT%\home"
set "CLAUDE_DIR=%DATA_DIR%\claude"

set "USERPROFILE=%HOME_DIR%"
set "HOME=%HOME_DIR%"
set "HOMEDRIVE=%~d0"
set "HOMEPATH=\home"

REM Ensure base portable directories exist
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"
if not exist "%WORKSPACE_DIR%" mkdir "%WORKSPACE_DIR%"
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
if not exist "%HOME_DIR%" mkdir "%HOME_DIR%"
if not exist "%CLAUDE_DIR%" mkdir "%CLAUDE_DIR%"

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

set "PATH=%BIN_DIR%;%PATH%"

cls
echo ==============================================================================
echo              OMNIROUTE PORTABLE AI DEVELOPER DRIVE
echo ==============================================================================
echo  Root Directory : %USB_ROOT%
echo  Status         : Validating prerequisites and environment...
echo ==============================================================================
echo.

REM ------------------------------------------------------------------------------
REM 2. RUN BOOTSTRAP ENGINE (DOWNLOAD & SETUP PREREQUISITES IF MISSING)
REM ------------------------------------------------------------------------------
if exist "%USB_ROOT%\bootstrap.ps1" (
    powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File "%USB_ROOT%\bootstrap.ps1" -RootPath "%USB_ROOT%"
    if errorlevel 1 (
        echo.
        echo  [ERROR] Setup bootstrap failed. Please check your internet connection.
        echo.
        pause
        exit /b 1
    )
) else (
    echo  [WARNING] bootstrap.ps1 not found. Proceeding with existing binaries...
)

REM ------------------------------------------------------------------------------
REM 3. START OMNIROUTE SERVER (BACKGROUND)
REM ------------------------------------------------------------------------------
echo ==============================================================================
echo  Starting OmniRoute Proxy Server...
echo ==============================================================================

curl.exe -s http://127.0.0.1:20128/api/monitoring/health >nul 2>&1
if not errorlevel 1 (
    echo  OmniRoute server is already running on http://127.0.0.1:20128
    set "OMNI_READY=1"
    goto SERVER_READY
)

start "" /b omniroute > "%DATA_DIR%\omniroute.log" 2>&1

echo  Waiting for server to become healthy...
set "OMNI_READY="
for /L %%A in (1,1,20) do (
    curl.exe -s http://127.0.0.1:20128/api/monitoring/health >nul 2>&1
    if not errorlevel 1 (
        set "OMNI_READY=1"
        goto SERVER_READY
    )
    timeout /t 1 /nobreak >nul
)

:SERVER_READY
if defined OMNI_READY (
    echo  OmniRoute Status : ACTIVE ^& READY
) else (
    echo  OmniRoute Status : STARTING (Log: %DATA_DIR%\omniroute.log)
)

REM ------------------------------------------------------------------------------
REM 4. LAUNCH PORTABLE VS CODE
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
echo ==============================================================================
echo.
echo  OmniRoute is running in the background.
echo  Keep this terminal window open while you work.
echo.
echo  Press any key to stop OmniRoute and exit...
pause >nul

endlocal
exit /b 0
