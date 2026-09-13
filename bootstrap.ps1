# ==============================================================================
#           OMNIROUTE PORTABLE DRIVE - AUTO-BOOTSTRAP ENGINE
# ==============================================================================

param(
    [string]$RootPath = $PSScriptRoot
)

$ErrorActionPreference = "Stop"
$USB_ROOT = (Resolve-Path $RootPath).Path

$BIN_DIR = Join-Path $USB_ROOT "bin"
$VSCODE_DIR = Join-Path $USB_ROOT "vscode"
$DATA_DIR = Join-Path $USB_ROOT "data"
$HOME_DIR = Join-Path $USB_ROOT "home"
$WORKSPACE_DIR = Join-Path $USB_ROOT "workspace"
$CLAUDE_DIR = Join-Path $DATA_DIR "claude"

# Ensure TLS 1.2 for all downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host "             OMNIROUTE PORTABLE AI DEVELOPER DRIVE BOOTSTRAP" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Green
Write-Host "  Root Directory : $USB_ROOT"
Write-Host "  Status         : Validating prerequisites and components..."
Write-Host ""

# ------------------------------------------------------------------------------
# 1. DIRECTORY INITIALIZATION
# ------------------------------------------------------------------------------
$dirs = @(
    $BIN_DIR,
    $VSCODE_DIR,
    $DATA_DIR,
    $HOME_DIR,
    $WORKSPACE_DIR,
    $CLAUDE_DIR,
    (Join-Path $WORKSPACE_DIR ".vscode"),
    (Join-Path $HOME_DIR "Desktop"),
    (Join-Path $HOME_DIR "Documents"),
    (Join-Path $HOME_DIR "Downloads"),
    (Join-Path $HOME_DIR "Pictures"),
    (Join-Path $HOME_DIR "Music"),
    (Join-Path $HOME_DIR "Videos")
)
foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

# Ensure data\.env exists with a secure unique random key
$envFile = Join-Path $DATA_DIR ".env"
if (-not (Test-Path $envFile)) {
    $bytes = New-Object byte[] 32
    [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
    $generatedKey = ($bytes | ForEach-Object { $_.ToString("x2") }) -join ""
    @"
STORAGE_ENCRYPTION_KEY=$generatedKey
OMNIROUTE_SERVER_HOST=127.0.0.1
"@ | Set-Content -Path $envFile -Encoding UTF8
    Write-Host "  [OK] Secure environment configuration generated (.env)." -ForegroundColor Green
}

# Ensure workspace\.vscode\settings.json exists
$vsSettings = Join-Path $WORKSPACE_DIR ".vscode\settings.json"
if (-not (Test-Path $vsSettings)) {
    @"
{
    "terminal.integrated.env.windows": {
        "PATH": "`${workspaceFolder}/../bin;`${env:PATH}",
        "ANTHROPIC_BASE_URL": "http://127.0.0.1:20128/v1",
        "ANTHROPIC_API_KEY": "sk-portable-omniroute",
        "ANTHROPIC_AUTH_TOKEN": "sk-portable-omniroute",
        "CLAUDE_CONFIG_DIR": "`${workspaceFolder}/../data/claude",
        "OMNIROUTE_DATA_DIR": "`${workspaceFolder}/../data"
    },
    "task.allowAutomaticTasks": "on"
}
"@ | Set-Content -Path $vsSettings -Encoding UTF8
}

# ------------------------------------------------------------------------------
# 2. PORTABLE NODE.JS LTS (v24.21.0)
# ------------------------------------------------------------------------------
$nodeExe = Join-Path $BIN_DIR "node.exe"
$npmCli = Join-Path $BIN_DIR "node_modules\npm\bin\npm-cli.js"

if (-not (Test-Path $nodeExe) -or -not (Test-Path $npmCli)) {
    Write-Host "  [1/3] Portable Node.js is missing. Downloading Node.js v24 LTS..." -ForegroundColor Yellow
    $nodeZipUrl = "https://nodejs.org/dist/v24.21.0/node-v24.21.0-win-x64.zip"
    $nodeZip = Join-Path $env:TEMP "node-portable-v24.zip"
    $nodeExtract = Join-Path $env:TEMP "node-extract-v24"

    try {
        if (Test-Path $nodeExtract) { Remove-Item $nodeExtract -Recurse -Force }
        Write-Host "        Downloading Node.js archive (~30 MB)..." -ForegroundColor Cyan
        (New-Object System.Net.WebClient).DownloadFile($nodeZipUrl, $nodeZip)

        Write-Host "        Extracting Node.js to bin directory..." -ForegroundColor Cyan
        Expand-Archive -Path $nodeZip -DestinationPath $nodeExtract -Force

        $extractedRoot = Get-ChildItem -Path $nodeExtract | Where-Object { $_.PSIsContainer } | Select-Object -First 1
        Get-ChildItem -Path $extractedRoot.FullName | Copy-Item -Destination $BIN_DIR -Recurse -Force

        Remove-Item $nodeZip, $nodeExtract -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  [OK] Portable Node.js installed successfully." -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] Failed to download or extract Node.js: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "  [OK] Portable Node.js detected: Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 3. PORTABLE VS CODE
# ------------------------------------------------------------------------------
$codeExe = Join-Path $VSCODE_DIR "Code.exe"

if (-not (Test-Path $codeExe)) {
    Write-Host "  [2/3] Portable VS Code is missing. Downloading latest VS Code Portable..." -ForegroundColor Yellow
    $codeZipUrl = "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
    $codeZip = Join-Path $env:TEMP "vscode-portable.zip"

    try {
        Write-Host "        Downloading VS Code archive (~100 MB)..." -ForegroundColor Cyan
        (New-Object System.Net.WebClient).DownloadFile($codeZipUrl, $codeZip)

        Write-Host "        Extracting VS Code to portable directory..." -ForegroundColor Cyan
        Expand-Archive -Path $codeZip -DestinationPath $VSCODE_DIR -Force

        # Create portable data directory inside vscode for strict isolation
        $vsData = Join-Path $VSCODE_DIR "data"
        if (-not (Test-Path $vsData)) { New-Item -ItemType Directory -Path $vsData -Force | Out-Null }

        Remove-Item $codeZip -Force -ErrorAction SilentlyContinue
        Write-Host "  [OK] Portable VS Code installed successfully." -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] Failed to download or extract VS Code: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "  [OK] Portable VS Code detected: Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 4. OMNIROUTE & CLAUDE CODE CLI PACKAGES
# ------------------------------------------------------------------------------
$omnirouteMjs = Join-Path $BIN_DIR "node_modules\omniroute\bin\omniroute.mjs"
$claudePkg = Join-Path $BIN_DIR "node_modules\@anthropic-ai\claude-code"

if (-not (Test-Path $omnirouteMjs) -or -not (Test-Path $claudePkg)) {
    Write-Host "  [3/3] Installing OmniRoute and Claude Code CLI packages..." -ForegroundColor Yellow
    Write-Host "        Installing via portable npm (this may take 1-2 minutes)..." -ForegroundColor Cyan

    & "$nodeExe" "$npmCli" install -g omniroute@latest @anthropic-ai/claude-code@latest --prefix "$BIN_DIR"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "        Retrying with --legacy-peer-deps..." -ForegroundColor Yellow
        & "$nodeExe" "$npmCli" install -g omniroute@latest @anthropic-ai/claude-code@latest --prefix "$BIN_DIR" --legacy-peer-deps
    }

    # Verify installation
    if (-not (Test-Path $omnirouteMjs)) {
        Write-Host "  [ERROR] OmniRoute module was not found at expected path: $omnirouteMjs" -ForegroundColor Red
        Write-Host "  Please check network connectivity and rerun." -ForegroundColor Yellow
        exit 1
    }

    Write-Host "  [OK] OmniRoute and Claude Code CLI installed successfully." -ForegroundColor Green
} else {
    Write-Host "  [OK] OmniRoute and Claude Code CLI detected: Ready." -ForegroundColor Green
}

Write-Host ""
Write-Host "  All prerequisites and dependencies are verified!" -ForegroundColor Green
Write-Host ""
exit 0
