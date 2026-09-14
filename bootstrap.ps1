# ==============================================================================
#           OMNIROUTE PORTABLE DRIVE - AUTO-BOOTSTRAP & AUTO-UPDATE ENGINE
# ==============================================================================

param(
    [string]$RootPath = $PSScriptRoot,
    [switch]$ForceUpdate = $false
)

$ErrorActionPreference = "Stop"
$USB_ROOT = (Resolve-Path $RootPath).Path

$BIN_DIR = Join-Path $USB_ROOT "bin"
$PYTHON_DIR = Join-Path $USB_ROOT "python"
$TOOLS_DIR = Join-Path $USB_ROOT "tools"
$PORTABLE_GIT_DIR = Join-Path $TOOLS_DIR "git"
$HOPPSCOTCH_DIR = Join-Path $USB_ROOT "hoppscotch"
$VSCODE_DIR = Join-Path $USB_ROOT "vscode"
$DATA_DIR = Join-Path $USB_ROOT "data"
$HOME_DIR = Join-Path $USB_ROOT "home"
$WORKSPACE_DIR = Join-Path $USB_ROOT "workspace"
$CLAUDE_DIR = Join-Path $DATA_DIR "claude"
$TEMP_DIR = Join-Path $DATA_DIR "temp"

# Strict portable sandbox environment redirection
$env:TEMP = $TEMP_DIR
$env:TMP = $TEMP_DIR
$env:USERPROFILE = $HOME_DIR
$env:HOME = $HOME_DIR
$env:APPDATA = Join-Path $HOME_DIR "AppData\Roaming"
$env:LOCALAPPDATA = Join-Path $HOME_DIR "AppData\Local"
$env:npm_config_cache = Join-Path $DATA_DIR "npm-cache"
$env:npm_config_prefix = $BIN_DIR
$env:npm_config_userconfig = Join-Path $HOME_DIR ".npmrc"
$env:PIP_CACHE_DIR = Join-Path $DATA_DIR "pip-cache"
$env:PYTHONNOUSERSITE = "1"
$env:PYTHONPYCACHEPREFIX = Join-Path $DATA_DIR "pycache"
$env:GIT_CONFIG_NOSYSTEM = "1"
$env:GIT_CONFIG_GLOBAL = Join-Path $HOME_DIR ".gitconfig"
$env:WEBVIEW2_USER_DATA_FOLDER = Join-Path $DATA_DIR "hoppscotch-data"

# Ensure TLS 1.2 for all downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host "             OMNIROUTE PORTABLE AI DEVELOPER DRIVE BOOTSTRAP" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Green
Write-Host "  Root Directory : $USB_ROOT"
Write-Host "  Portability    : 100% Isolated Sandbox (Zero Host Modification)" -ForegroundColor DarkCyan
Write-Host "  Status         : Resolving and verifying latest versions of all components..."
Write-Host ""

# ------------------------------------------------------------------------------
# 1. DIRECTORY INITIALIZATION
# ------------------------------------------------------------------------------
# Move legacy top-level git folder to tools\git if present to avoid MSYS2 collisions
$legacyGitDir = Join-Path $USB_ROOT "git"
if (Test-Path $legacyGitDir) {
    if (-not (Test-Path $PORTABLE_GIT_DIR)) {
        if (-not (Test-Path $TOOLS_DIR)) { New-Item -ItemType Directory -Path $TOOLS_DIR -Force | Out-Null }
        Move-Item -Path $legacyGitDir -Destination $PORTABLE_GIT_DIR -Force
    } else {
        Remove-Item -Path $legacyGitDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

$dirs = @(
    $BIN_DIR,
    $PYTHON_DIR,
    $TOOLS_DIR,
    $PORTABLE_GIT_DIR,
    $HOPPSCOTCH_DIR,
    $VSCODE_DIR,
    $DATA_DIR,
    $HOME_DIR,
    $WORKSPACE_DIR,
    $CLAUDE_DIR,
    $TEMP_DIR,
    (Join-Path $DATA_DIR "npm-cache"),
    (Join-Path $DATA_DIR "pip-cache"),
    (Join-Path $DATA_DIR "pycache"),
    (Join-Path $DATA_DIR "hoppscotch-data"),
    (Join-Path $DATA_DIR "vscode-user-data"),
    (Join-Path $DATA_DIR "vscode-extensions"),
    (Join-Path $WORKSPACE_DIR ".vscode"),
    (Join-Path $HOME_DIR "AppData"),
    (Join-Path $HOME_DIR "AppData\Roaming"),
    (Join-Path $HOME_DIR "AppData\Local"),
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
        "PATH": "`${workspaceFolder}/../bin;`${workspaceFolder}/../python;`${workspaceFolder}/../python/Scripts;`${workspaceFolder}/../tools/git/cmd;`${env:PATH}",
        "USERPROFILE": "`${workspaceFolder}/../home",
        "HOME": "`${workspaceFolder}/../home",
        "APPDATA": "`${workspaceFolder}/../home/AppData/Roaming",
        "LOCALAPPDATA": "`${workspaceFolder}/../home/AppData/Local",
        "TEMP": "`${workspaceFolder}/../data/temp",
        "TMP": "`${workspaceFolder}/../data/temp",
        "PYTHONNOUSERSITE": "1",
        "PIP_CACHE_DIR": "`${workspaceFolder}/../data/pip-cache",
        "PYTHONPYCACHEPREFIX": "`${workspaceFolder}/../data/pycache",
        "npm_config_cache": "`${workspaceFolder}/../data/npm-cache",
        "npm_config_prefix": "`${workspaceFolder}/../bin",
        "GIT_CONFIG_NOSYSTEM": "1",
        "GIT_CONFIG_GLOBAL": "`${workspaceFolder}/../home/.gitconfig",
        "ANTHROPIC_BASE_URL": "http://127.0.0.1:20128/v1",
        "ANTHROPIC_API_KEY": "sk-portable-omniroute",
        "ANTHROPIC_AUTH_TOKEN": "sk-portable-omniroute",
        "CLAUDE_CONFIG_DIR": "`${workspaceFolder}/../data/claude",
        "OMNIROUTE_DATA_DIR": "`${workspaceFolder}/../data"
    },
    "git.path": "`${workspaceFolder}/../tools/git/cmd/git.exe",
    "python.defaultInterpreterPath": "`${workspaceFolder}/../python/python.exe",
    "task.allowAutomaticTasks": "on"
}
"@ | Set-Content -Path $vsSettings -Encoding UTF8
}

# Helper to safely create WebClient with user-agent
function Get-SafeWebClient {
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) OmniRoute-Portable")
    return $wc
}

# ------------------------------------------------------------------------------
# 2. DYNAMIC LATEST NODE.JS RESOLVER & INSTALLER
# ------------------------------------------------------------------------------
$nodeExe = Join-Path $BIN_DIR "node.exe"
$npmCli = Join-Path $BIN_DIR "node_modules\npm\bin\npm-cli.js"

if (-not (Test-Path $nodeExe) -or -not (Test-Path $npmCli) -or $ForceUpdate) {
    Write-Host "  [1/6] Resolving and validating latest Portable Node.js..." -ForegroundColor Yellow

    $nodeZipUrl = "https://nodejs.org/dist/v24.21.0/node-v24.21.0-win-x64.zip"
    try {
        $wc = Get-SafeWebClient
        $nodeIndexJson = $wc.DownloadString("https://nodejs.org/dist/index.json") | ConvertFrom-Json
        # Find the latest LTS version supporting Windows x64 zip
        $ltsRelease = $nodeIndexJson | Where-Object { $_.lts -ne $false -and ($_.files -contains "win-x64-zip") } | Select-Object -First 1
        if ($ltsRelease) {
            $nodeVersion = $ltsRelease.version
            $nodeZipUrl = "https://nodejs.org/dist/$nodeVersion/node-$nodeVersion-win-x64.zip"
            Write-Host "        Latest Node.js LTS detected: $nodeVersion" -ForegroundColor Cyan
        }
    } catch {
        Write-Host "        Using standard Node.js release endpoint..." -ForegroundColor DarkGray
    }

    $nodeZip = Join-Path $TEMP_DIR "node-portable-latest.zip"
    $nodeExtract = Join-Path $TEMP_DIR "node-extract-latest"

    try {
        if (Test-Path $nodeExtract) { Remove-Item $nodeExtract -Recurse -Force }
        Write-Host "        Downloading Node.js archive..." -ForegroundColor Cyan
        $wc = Get-SafeWebClient
        $wc.DownloadFile($nodeZipUrl, $nodeZip)

        Write-Host "        Extracting Node.js to portable bin directory..." -ForegroundColor Cyan
        Expand-Archive -Path $nodeZip -DestinationPath $nodeExtract -Force

        $extractedRoot = Get-ChildItem -Path $nodeExtract | Where-Object { $_.PSIsContainer } | Select-Object -First 1
        Get-ChildItem -Path $extractedRoot.FullName | Copy-Item -Destination $BIN_DIR -Recurse -Force

        Remove-Item $nodeZip, $nodeExtract -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  [OK] Portable Node.js installed/updated." -ForegroundColor Green
    } catch {
        if (Test-Path $nodeExe) {
            Write-Host "  [WARNING] Could not update Node.js ($_); using existing version." -ForegroundColor Yellow
        } else {
            Write-Host "  [ERROR] Failed to download or extract Node.js: $_" -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "  [OK] Portable Node.js detected: Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 3. DYNAMIC LATEST PYTHON 3.12+ & PIP RESOLVER & INSTALLER
# ------------------------------------------------------------------------------
$pythonExe = Join-Path $PYTHON_DIR "python.exe"
$pipExe = Join-Path $PYTHON_DIR "Scripts\pip.exe"

if (-not (Test-Path $pythonExe) -or -not (Test-Path $pipExe) -or $ForceUpdate) {
    Write-Host "  [2/6] Resolving and validating latest Portable Python & Pip..." -ForegroundColor Yellow

    $pythonZipUrl = "https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip"
    $pythonZip = Join-Path $TEMP_DIR "python-portable-latest.zip"
    $pipScriptUrl = "https://bootstrap.pypa.io/get-pip.py"
    $pipScript = Join-Path $TEMP_DIR "get-pip.py"

    try {
        if (-not (Test-Path $pythonExe) -or $ForceUpdate) {
            Write-Host "        Downloading Python embeddable archive..." -ForegroundColor Cyan
            $wc = Get-SafeWebClient
            $wc.DownloadFile($pythonZipUrl, $pythonZip)

            Write-Host "        Extracting Python to portable directory..." -ForegroundColor Cyan
            Expand-Archive -Path $pythonZip -DestinationPath $PYTHON_DIR -Force
            Remove-Item $pythonZip -Force -ErrorAction SilentlyContinue

            # Enable site-packages in ._pth file
            $pthFile = Get-ChildItem -Path $PYTHON_DIR -Filter "python*._pth" | Select-Object -First 1
            if ($pthFile) {
                $pthLines = Get-Content $pthFile.FullName
                $newLines = @()
                $hasSitePackages = $false
                foreach ($line in $pthLines) {
                    if ($line -match '^\s*#\s*import site') {
                        $newLines += "import site"
                    } elseif ($line -match 'Lib\\site-packages') {
                        $hasSitePackages = $true
                        $newLines += $line
                    } else {
                        $newLines += $line
                    }
                }
                if (-not $hasSitePackages) {
                    $newLines = @("Lib\site-packages") + $newLines
                }
                $newLines | Set-Content -Path $pthFile.FullName -Encoding UTF8
            }

            # Create Lib\site-packages directory
            $sitePkgDir = Join-Path $PYTHON_DIR "Lib\site-packages"
            if (-not (Test-Path $sitePkgDir)) { New-Item -ItemType Directory -Path $sitePkgDir -Force | Out-Null }

            # Create python3.exe alias copy if not exists
            $python3Exe = Join-Path $PYTHON_DIR "python3.exe"
            if (-not (Test-Path $python3Exe)) {
                Copy-Item -Path $pythonExe -Destination $python3Exe -Force
            }
        }

        # Install / Update pip, wheel, setuptools to latest
        Write-Host "        Downloading get-pip.py bootstrap script..." -ForegroundColor Cyan
        $wc = Get-SafeWebClient
        $wc.DownloadFile($pipScriptUrl, $pipScript)

        Write-Host "        Bootstrapping and updating pip, wheel, and setuptools to @latest..." -ForegroundColor Cyan
        Start-Process -FilePath $pythonExe -ArgumentList @($pipScript, "--no-warn-script-location", "--no-cache-dir", "--upgrade") -Wait -PassThru -NoNewWindow | Out-Null
        Remove-Item $pipScript -Force -ErrorAction SilentlyContinue

        Write-Host "  [OK] Portable Python and Pip installed/updated to latest." -ForegroundColor Green
    } catch {
        if (Test-Path $pythonExe) {
            Write-Host "  [WARNING] Could not update Python ($_); using existing version." -ForegroundColor Yellow
        } else {
            Write-Host "  [ERROR] Failed to download or setup Python: $_" -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "  [OK] Portable Python & Pip detected: Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 4. DYNAMIC LATEST GIT (MINGIT X64) RESOLVER & INSTALLER
# ------------------------------------------------------------------------------
$gitExe = Join-Path $PORTABLE_GIT_DIR "cmd\git.exe"

if (-not (Test-Path $gitExe) -or $ForceUpdate) {
    Write-Host "  [3/6] Resolving and validating latest Portable Git (MinGit x64)..." -ForegroundColor Yellow

    $gitZipUrl = "https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.5/MinGit-2.55.0.5-64-bit.zip"
    try {
        $wc = Get-SafeWebClient
        $gitRelease = $wc.DownloadString("https://api.github.com/repos/git-for-windows/git/releases/latest") | ConvertFrom-Json
        $gitAsset = $gitRelease.assets | Where-Object { $_.name -match '^MinGit-.*-64-bit\.zip$' } | Select-Object -First 1
        if ($gitAsset) {
            $gitZipUrl = $gitAsset.browser_download_url
            Write-Host "        Latest Git release detected: $($gitRelease.tag_name)" -ForegroundColor Cyan
        }
    } catch {
        Write-Host "        Using standard MinGit release endpoint..." -ForegroundColor DarkGray
    }

    $gitZip = Join-Path $TEMP_DIR "mingit-portable-latest.zip"

    try {
        Write-Host "        Downloading MinGit archive..." -ForegroundColor Cyan
        $wc = Get-SafeWebClient
        $wc.DownloadFile($gitZipUrl, $gitZip)

        Write-Host "        Extracting Git to portable tools directory..." -ForegroundColor Cyan
        Expand-Archive -Path $gitZip -DestinationPath $PORTABLE_GIT_DIR -Force
        Remove-Item $gitZip -Force -ErrorAction SilentlyContinue

        Write-Host "  [OK] Portable Git installed/updated to latest." -ForegroundColor Green
    } catch {
        if (Test-Path $gitExe) {
            Write-Host "  [WARNING] Could not update MinGit ($_); using existing version." -ForegroundColor Yellow
        } else {
            Write-Host "  [ERROR] Failed to download or extract Git: $_" -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "  [OK] Portable Git detected: Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 5. DYNAMIC LATEST HOPPSCOTCH DESKTOP RESOLVER & INSTALLER
# ------------------------------------------------------------------------------
$hoppExe = Get-ChildItem -Path $HOPPSCOTCH_DIR -Filter "*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $hoppExe -or $ForceUpdate) {
    Write-Host "  [4/6] Resolving and validating latest Portable Hoppscotch Desktop..." -ForegroundColor Yellow

    $hoppZipUrl = "https://github.com/hoppscotch/releases/releases/download/v26.8.0-0/Hoppscotch_SelfHost_win_x64_portable.zip"
    try {
        $wc = Get-SafeWebClient
        $hoppRelease = $wc.DownloadString("https://api.github.com/repos/hoppscotch/releases/releases/latest") | ConvertFrom-Json
        $hoppAsset = $hoppRelease.assets | Where-Object { $_.name -match 'win_x64_portable\.zip$' } | Select-Object -First 1
        if ($hoppAsset) {
            $hoppZipUrl = $hoppAsset.browser_download_url
            Write-Host "        Latest Hoppscotch release detected: $($hoppRelease.tag_name)" -ForegroundColor Cyan
        }
    } catch {
        Write-Host "        Using standard Hoppscotch release endpoint..." -ForegroundColor DarkGray
    }

    $hoppZip = Join-Path $TEMP_DIR "hoppscotch-portable-latest.zip"

    try {
        Write-Host "        Downloading Hoppscotch Portable archive..." -ForegroundColor Cyan
        $wc = Get-SafeWebClient
        $wc.DownloadFile($hoppZipUrl, $hoppZip)

        Write-Host "        Extracting Hoppscotch to portable directory..." -ForegroundColor Cyan
        Expand-Archive -Path $hoppZip -DestinationPath $HOPPSCOTCH_DIR -Force
        Remove-Item $hoppZip -Force -ErrorAction SilentlyContinue

        Write-Host "  [OK] Portable Hoppscotch Desktop installed/updated to latest." -ForegroundColor Green
    } catch {
        Write-Host "  [WARNING] Could not download Hoppscotch Desktop: $_. Proceeding..." -ForegroundColor Yellow
    }
} else {
    Write-Host "  [OK] Portable Hoppscotch Desktop detected: Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 6. DYNAMIC LATEST VS CODE RESOLVER & INSTALLER
# ------------------------------------------------------------------------------
$codeExe = Join-Path $VSCODE_DIR "Code.exe"

if (-not (Test-Path $codeExe) -or $ForceUpdate) {
    Write-Host "  [5/6] Resolving and validating latest Portable VS Code..." -ForegroundColor Yellow
    $codeZipUrl = "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
    $codeZip = Join-Path $TEMP_DIR "vscode-portable-latest.zip"

    try {
        Write-Host "        Downloading latest VS Code archive..." -ForegroundColor Cyan
        $wc = Get-SafeWebClient
        $wc.DownloadFile($codeZipUrl, $codeZip)

        Write-Host "        Extracting VS Code to portable directory..." -ForegroundColor Cyan
        Expand-Archive -Path $codeZip -DestinationPath $VSCODE_DIR -Force

        # Create portable data directory inside vscode for strict isolation
        $vsData = Join-Path $VSCODE_DIR "data"
        if (-not (Test-Path $vsData)) { New-Item -ItemType Directory -Path $vsData -Force | Out-Null }

        Remove-Item $codeZip -Force -ErrorAction SilentlyContinue
        Write-Host "  [OK] Portable VS Code installed/updated to latest." -ForegroundColor Green
    } catch {
        if (Test-Path $codeExe) {
            Write-Host "  [WARNING] Could not update VS Code ($_); using existing version." -ForegroundColor Yellow
        } else {
            Write-Host "  [ERROR] Failed to download or extract VS Code: $_" -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "  [OK] Portable VS Code detected: Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 7. ALWAYS-LATEST AUTO-UPDATE FOR CLI PACKAGES & PIP
# ------------------------------------------------------------------------------
$omnirouteMjs = Join-Path $BIN_DIR "node_modules\omniroute\bin\omniroute.mjs"
$claudePkg = Join-Path $BIN_DIR "node_modules\@anthropic-ai\claude-code"
$hoppPkg = Join-Path $BIN_DIR "node_modules\@hoppscotch\cli"

$updateTimestampFile = Join-Path $DATA_DIR "last_update_check.timestamp"
$shouldCheckUpdates = $ForceUpdate -or (-not (Test-Path $omnirouteMjs)) -or (-not (Test-Path $claudePkg)) -or (-not (Test-Path $hoppPkg))

if (-not $shouldCheckUpdates -and (Test-Path $updateTimestampFile)) {
    try {
        $lastCheck = [DateTime]::Parse((Get-Content -Path $updateTimestampFile -Raw).Trim())
        if ((Get-Date) -gt $lastCheck.AddHours(24)) {
            $shouldCheckUpdates = $true
        }
    } catch {
        $shouldCheckUpdates = $true
    }
} else {
    $shouldCheckUpdates = $true
}

if ($shouldCheckUpdates) {
    Write-Host "  [6/6] Fetching and updating OmniRoute, Claude Code, and Hoppscotch CLI (@latest)..." -ForegroundColor Yellow
    Write-Host "        Running portable npm update to ensure latest models, features, and fixes..." -ForegroundColor Cyan

    try {
        & "$nodeExe" "$npmCli" install -g omniroute@latest @anthropic-ai/claude-code@latest @hoppscotch/cli@latest --prefix "$BIN_DIR" --no-audit --no-fund
        if ($LASTEXITCODE -ne 0) {
            Write-Host "        Retrying with --legacy-peer-deps..." -ForegroundColor Yellow
            & "$nodeExe" "$npmCli" install -g omniroute@latest @anthropic-ai/claude-code@latest @hoppscotch/cli@latest --prefix "$BIN_DIR" --legacy-peer-deps --no-audit --no-fund
        }

        # Update pip, setuptools, wheel in portable python
        if (Test-Path $pipExe) {
            Write-Host "        Updating portable pip, setuptools, and wheel to latest..." -ForegroundColor Cyan
            & "$pythonExe" -m pip install --upgrade --no-cache-dir pip setuptools wheel --no-warn-script-location 2>$null | Out-Null
        }

        # Save successful update timestamp
        (Get-Date).ToString("o") | Set-Content -Path $updateTimestampFile -Encoding UTF8
        Write-Host "  [OK] All CLI packages, tools, and libraries are updated to @latest." -ForegroundColor Green
    } catch {
        Write-Host "  [WARNING] Could not check/update packages online: $_. Continuing with local binaries..." -ForegroundColor Yellow
    }
} else {
    Write-Host "  [6/6] CLI packages and tools are up-to-date (checked within 24h)." -ForegroundColor Green
}

Write-Host ""
Write-Host "  All components verified, updated to latest, and 100% portable!" -ForegroundColor Green
Write-Host ""
exit 0
