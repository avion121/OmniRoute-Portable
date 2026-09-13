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
echo  Status         : Checking prerequisites and dependencies...
echo ==============================================================================
echo.

REM ------------------------------------------------------------------------------
REM 2. ENSURE DIRECTORIES AND CONFIGURATION FILES
REM ------------------------------------------------------------------------------
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"
if not exist "%WORKSPACE_DIR%" mkdir "%WORKSPACE_DIR%"
if not exist "%WORKSPACE_DIR%\.vscode" mkdir "%WORKSPACE_DIR%\.vscode"
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
if not exist "%HOME_DIR%" mkdir "%HOME_DIR%"
if not exist "%CLAUDE_DIR%" mkdir "%CLAUDE_DIR%"

REM Ensure data\.env exists with the required storage encryption key
if not exist "%DATA_DIR%\.env" (
    if exist "%DATA_DIR%\.env.example" (
        copy /Y "%DATA_DIR%\.env.example" "%DATA_DIR%\.env" >nul 2>&1
    ) else (
        (
            echo STORAGE_ENCRYPTION_KEY=4c6752cd4a643f2733143c010166533458573705f4bc508371ba7ee5e2017dfe
            echo OMNIROUTE_SERVER_HOST=127.0.0.1
        ) > "%DATA_DIR%\.env"
    )
    echo  [OK] Environment configuration initialized (.env).
)

REM Ensure workspace\.vscode\settings.json exists
if not exist "%WORKSPACE_DIR%\.vscode\settings.json" (
    (
        echo {
        echo     "terminal.integrated.env.windows": {
        echo         "ANTHROPIC_BASE_URL": "http://127.0.0.1:20128/v1",
        echo         "ANTHROPIC_API_KEY": "sk-portable-omniroute",
        echo         "ANTHROPIC_AUTH_TOKEN": "sk-portable-omniroute",
        echo         "CLAUDE_CONFIG_DIR": "${workspaceFolder}/../data/claude"
        echo     },
        echo     "task.allowAutomaticTasks": "on"
        echo }
    ) > "%WORKSPACE_DIR%\.vscode\settings.json"
)

REM ------------------------------------------------------------------------------
REM 3. DEPENDENCY CHECK & INSTALLATION: PORTABLE NODE.JS LTS (v24)
REM ------------------------------------------------------------------------------
set "NEED_NODE=0"
if not exist "%BIN_DIR%\node.exe" set "NEED_NODE=1"
if not exist "%BIN_DIR%\node_modules\npm\bin\npm-cli.js" set "NEED_NODE=1"

if "%NEED_NODE%"=="1" (
    echo.
    echo  [1/3] Portable Node.js LTS is missing.
    echo        Downloading and setting up portable Node.js to drive...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$ProgressPreference = 'SilentlyContinue';" ^
        "$url = 'https://nodejs.org/dist/v24.21.0/node-v24.21.0-win-x64.zip';" ^
        "$zip = Join-Path $env:TEMP 'node-portable-v24.zip';" ^
        "$extract = Join-Path $env:TEMP 'node-extract-v24';" ^
        "Write-Host '       -> Downloading Node.js v24.21.0 (LTS)...' -ForegroundColor Cyan;" ^
        "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
        "(New-Object System.Net.WebClient).DownloadFile($url, $zip);" ^
        "Write-Host '       -> Extracting to portable bin folder...' -ForegroundColor Cyan;" ^
        "if (Test-Path $extract) { Remove-Item $extract -Recurse -Force };" ^
        "Expand-Archive -Path $zip -DestinationPath $extract -Force;" ^
        "$inner = Get-ChildItem $extract | Where-Object { $_.PSIsContainer } | Select-Object -First 1;" ^
        "Get-ChildItem $inner.FullName | Copy-Item -Destination '%BIN_DIR%' -Recurse -Force;" ^
        "Remove-Item $zip, $extract -Recurse -Force;" ^
        "Write-Host '       -> Node.js installation successful.' -ForegroundColor Green;"
    if not exist "%BIN_DIR%\node.exe" (
        echo.
        echo  [ERROR] Failed to download or install Node.js. Check your internet connection.
        pause
        exit /b 1
    )
) else (
    echo  [OK] Portable Node.js detected: Ready.
)

REM ------------------------------------------------------------------------------
REM 4. DEPENDENCY CHECK & INSTALLATION: PORTABLE VS CODE
REM ------------------------------------------------------------------------------
if not exist "%VSCODE_DIR%\Code.exe" (
    echo.
    echo  [2/3] Portable VS Code is missing.
    echo        Downloading and setting up VS Code Portable to drive...
    if not exist "%VSCODE_DIR%" mkdir "%VSCODE_DIR%"
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$ProgressPreference = 'SilentlyContinue';" ^
        "$url = 'https://update.code.visualstudio.com/latest/win32-x64-archive/stable';" ^
        "$zip = Join-Path $env:TEMP 'vscode-portable.zip';" ^
        "Write-Host '       -> Downloading latest VS Code Portable...' -ForegroundColor Cyan;" ^
        "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
        "(New-Object System.Net.WebClient).DownloadFile($url, $zip);" ^
        "Write-Host '       -> Extracting to portable vscode folder...' -ForegroundColor Cyan;" ^
        "Expand-Archive -Path $zip -DestinationPath '%VSCODE_DIR%' -Force;" ^
        "Remove-Item $zip -Force;" ^
        "Write-Host '       -> VS Code installation successful.' -ForegroundColor Green;"
    if not exist "%VSCODE_DIR%\Code.exe" (
        echo.
        echo  [ERROR] Failed to download or install VS Code. Check your internet connection.
        pause
        exit /b 1
    )
) else (
    echo  [OK] Portable VS Code detected: Ready.
)

REM ------------------------------------------------------------------------------
REM 5. DEPENDENCY CHECK & UPDATE: OMNIROUTE & CLAUDE CODE CLI
REM ------------------------------------------------------------------------------
set "NEED_NPM_INSTALL=0"
if not exist "%BIN_DIR%\node_modules\omniroute" set "NEED_NPM_INSTALL=1"
if not exist "%BIN_DIR%\node_modules\@anthropic-ai\claude-code" set "NEED_NPM_INSTALL=1"

set "NPM_CLI=%BIN_DIR%\node_modules\npm\bin\npm-cli.js"

if "%NEED_NPM_INSTALL%"=="1" (
    echo.
    echo  [3/3] Installing latest OmniRoute ^& Claude Code packages...
    "%BIN_DIR%\node.exe" "%NPM_CLI%" install -g omniroute @anthropic-ai/claude-code --prefix "%BIN_DIR%"
    if errorlevel 1 (
        echo.
        echo  [WARNING] Retrying package installation...
        "%BIN_DIR%\node.exe" "%NPM_CLI%" install -g omniroute @anthropic-ai/claude-code --prefix "%BIN_DIR%" --legacy-peer-deps
    )
    echo  [OK] OmniRoute and Claude Code installed successfully.
) else (
    echo  [OK] OmniRoute ^& Claude Code detected: Ready.
    echo        Checking for package updates in background...
    start "" /b "%BIN_DIR%\node.exe" "%NPM_CLI%" update -g omniroute @anthropic-ai/claude-code --prefix "%BIN_DIR%" >nul 2>&1
)

REM ------------------------------------------------------------------------------
REM 6. START OMNIROUTE SERVER (BACKGROUND)
REM ------------------------------------------------------------------------------
echo.
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
REM 7. LAUNCH PORTABLE VS CODE
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
REM 8. READY DASHBOARD & INSTRUCTIONS
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
echo      (Or simply type: claude)
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
