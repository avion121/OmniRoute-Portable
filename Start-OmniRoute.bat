@echo off
setlocal EnableExtensions EnableDelayedExpansion

TITLE Portable AI Developer Drive - OmniRoute ^& Claude Code
COLOR 0A

REM ============================================================
REM PORTABLE AI DEVELOPER DRIVE
REM OmniRoute + Claude Code + Portable VS Code
REM
REM Automatically:
REM   - Detects and bootstraps portable environment if needed
REM   - Starts OmniRoute background server
REM   - Starts portable VS Code
REM ============================================================

REM ------------------------------------------------------------
REM ROOT DIRECTORY
REM ------------------------------------------------------------
set "USB_ROOT=%~dp0"
if "%USB_ROOT:~-1%"=="\" set "USB_ROOT=%USB_ROOT:~0,-1%"

REM ------------------------------------------------------------
REM PORTABLE PATHS
REM ------------------------------------------------------------
set "BIN_DIR=%USB_ROOT%\bin"
set "VSCODE_DIR=%USB_ROOT%\vscode"
set "WORKSPACE_DIR=%USB_ROOT%\workspace"
set "DATA_DIR=%USB_ROOT%\data"
set "HOME_DIR=%USB_ROOT%\home"
set "CLAUDE_DIR=%DATA_DIR%\claude"

REM ------------------------------------------------------------
REM PORTABLE ENVIRONMENT VARIABLES
REM ------------------------------------------------------------
set "USERPROFILE=%HOME_DIR%"
set "HOME=%HOME_DIR%"
set "HOMEDRIVE=%~d0"
set "HOMEPATH=\home"

set "OMNIROUTE_DATA_DIR=%DATA_DIR%"
set "OMNIROUTE_SERVER_HOST=127.0.0.1"
set "CLAUDE_CONFIG_DIR=%CLAUDE_DIR%"

REM Do NOT point Claude directly to Anthropic. OmniRoute handles routing.
set "ANTHROPIC_API_KEY="
set "ANTHROPIC_AUTH_TOKEN="
set "ANTHROPIC_BASE_URL="
set "ANTHROPIC_MODEL="

set "PATH=%BIN_DIR%;%PATH%"

REM ------------------------------------------------------------
REM CREATE NECESSARY DIRECTORIES
REM ------------------------------------------------------------
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"
if not exist "%WORKSPACE_DIR%" mkdir "%WORKSPACE_DIR%"
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
if not exist "%HOME_DIR%" mkdir "%HOME_DIR%"
if not exist "%CLAUDE_DIR%" mkdir "%CLAUDE_DIR%"

if not exist "%DATA_DIR%\.env" (
    echo STORAGE_ENCRYPTION_KEY=4c6752cd4a643f2733143c010166533458573705f4bc508371ba7ee5e2017dfe> "%DATA_DIR%\.env"
    echo OMNIROUTE_SERVER_HOST=127.0.0.1>> "%DATA_DIR%\.env"
)

cls
echo.
echo ============================================================
echo          PORTABLE AI DEVELOPER DRIVE - AUTO-BOOTSTRAP
echo ============================================================
echo.
echo USB Root: %USB_ROOT%
echo.

REM ------------------------------------------------------------
REM AUTO-BOOTSTRAP STEP 1: PORTABLE NODE.JS
REM ------------------------------------------------------------
if not exist "%BIN_DIR%\node.exe" (
    echo [1/3] Portable Node.js not detected. Downloading portable Node.js LTS...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$ProgressPreference = 'SilentlyContinue';" ^
        "$url = 'https://nodejs.org/dist/v20.18.0/node-v20.18.0-win-x64.zip';" ^
        "$zip = Join-Path $env:TEMP 'node-portable.zip';" ^
        "$extract = Join-Path $env:TEMP 'node-extract';" ^
        "Write-Host 'Downloading Node.js (v20.18.0)...';" ^
        "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
        "(New-Object System.Net.WebClient).DownloadFile($url, $zip);" ^
        "Write-Host 'Extracting Node.js...';" ^
        "Expand-Archive -Path $zip -DestinationPath $extract -Force;" ^
        "Get-ChildItem (Join-Path $extract 'node-v20.18.0-win-x64') | Copy-Item -Destination '%BIN_DIR%' -Recurse -Force;" ^
        "Remove-Item $zip, $extract -Recurse -Force;" ^
        "Write-Host 'Node.js setup completed.'"
    if not exist "%BIN_DIR%\node.exe" (
        echo.
        echo [ERROR] Failed to download or extract Node.js. Please check your internet connection.
        pause
        exit /b 1
    )
)

REM ------------------------------------------------------------
REM AUTO-BOOTSTRAP STEP 2: PORTABLE VS CODE
REM ------------------------------------------------------------
if not exist "%VSCODE_DIR%\Code.exe" (
    echo.
    echo [2/3] Portable VS Code not detected. Downloading VS Code Portable...
    if not exist "%VSCODE_DIR%" mkdir "%VSCODE_DIR%"
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$ProgressPreference = 'SilentlyContinue';" ^
        "$url = 'https://update.code.visualstudio.com/latest/win32-x64-archive/stable';" ^
        "$zip = Join-Path $env:TEMP 'vscode-portable.zip';" ^
        "Write-Host 'Downloading VS Code Portable...';" ^
        "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
        "(New-Object System.Net.WebClient).DownloadFile($url, $zip);" ^
        "Write-Host 'Extracting VS Code Portable...';" ^
        "Expand-Archive -Path $zip -DestinationPath '%VSCODE_DIR%' -Force;" ^
        "Remove-Item $zip -Force;" ^
        "Write-Host 'VS Code setup completed.'"
    if not exist "%VSCODE_DIR%\Code.exe" (
        echo.
        echo [ERROR] Failed to download or extract VS Code. Please check your internet connection.
        pause
        exit /b 1
    )
)

REM ------------------------------------------------------------
REM AUTO-BOOTSTRAP STEP 3: OMNIROUTE & CLAUDE CODE NPM PACKAGES
REM ------------------------------------------------------------
where omniroute >nul 2>&1
if errorlevel 1 (
    echo.
    echo [3/3] Installing OmniRoute and Claude Code packages...
    call "%BIN_DIR%\npm.cmd" install -g omniroute @anthropic-ai/claude-code --prefix "%BIN_DIR%"
)

where omniroute >nul 2>&1
if errorlevel 1 (
    echo.
    echo ============================================================
    echo ERROR: OmniRoute executable was not found.
    echo ============================================================
    echo Expected inside: %BIN_DIR%
    pause
    exit /b 1
)

REM ------------------------------------------------------------
REM START OMNIROUTE SERVER (BACKGROUND)
REM ------------------------------------------------------------
cls
echo.
echo ============================================================
echo          PORTABLE AI DEVELOPER DRIVE
echo ============================================================
echo.
echo Root: %USB_ROOT%
echo.
echo Starting OmniRoute server in background...

start "" /b omniroute > "%DATA_DIR%\omniroute.log" 2>&1

REM ------------------------------------------------------------
REM WAIT FOR OMNIROUTE SERVER TO BE READY
REM ------------------------------------------------------------
echo Waiting for OmniRoute server...

set "OMNI_READY="
for /L %%A in (1,1,15) do (
    curl.exe -s http://127.0.0.1:20128/api/monitoring/health >nul 2>&1
    if not errorlevel 1 (
        set "OMNI_READY=1"
        goto OMNI_READY
    )
    timeout /t 1 /nobreak >nul
)

:OMNI_READY

if defined OMNI_READY (
    echo OmniRoute: RUNNING (http://127.0.0.1:20128)
) else (
    echo OmniRoute: STARTING (Check log at %DATA_DIR%\omniroute.log if needed)
)

echo.

REM ------------------------------------------------------------
REM START PORTABLE VS CODE
REM ------------------------------------------------------------
echo Starting Portable VS Code...

start "" "%VSCODE_DIR%\Code.exe" ^
    --user-data-dir "%DATA_DIR%\vscode-user-data" ^
    --extensions-dir "%DATA_DIR%\vscode-extensions" ^
    "%WORKSPACE_DIR%" ^
    >nul 2>&1

echo VS Code: STARTED

echo.
echo ============================================================
echo                         READY!
echo ============================================================
echo.
echo 1. VS Code has opened your workspace folder.
echo.
echo 2. Open the integrated terminal in VS Code:
echo    Shortcut: Ctrl + ` (backtick)
echo.
echo 3. Run Claude Code connected to OmniRoute:
echo.
echo    omniroute launch --model free-stack
echo.
echo    (or run: claude)
echo.
echo ============================================================
echo.
echo OmniRoute is running in the background.
echo Keep this launcher window open while working.
echo.
echo Press any key to stop OmniRoute and close launcher...
pause >nul

endlocal
exit /b 0
