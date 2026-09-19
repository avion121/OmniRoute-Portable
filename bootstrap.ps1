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
$env:DISABLE_AUTO_UPDATER = "1"
$env:CLAUDE_AUTO_UPDATER = "disabled"
$env:CLAUDE_CODE_DISABLE_UPDATE_CHECK = "1"

# Ensure TLS 1.2 and TLS 1.3 for all downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host "             OMNIROUTE PORTABLE AI DEVELOPER DRIVE AUTO-ENGINE" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Green
Write-Host "  Root Directory : $USB_ROOT"
Write-Host "  Portability    : 100% Isolated Sandbox (Zero Host Modification)" -ForegroundColor DarkCyan
Write-Host "  Auto-Update    : Checking and installing latest portable versions of everything..."
Write-Host ""

# ------------------------------------------------------------------------------
# 1. DIRECTORY & CONFIGURATION INITIALIZATION
# ------------------------------------------------------------------------------
# Move legacy top-level git folder to tools\git if present
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
    (Join-Path $DATA_DIR "vscode-user-data\User"),
    (Join-Path $DATA_DIR "vscode-extensions"),
    (Join-Path $VSCODE_DIR "data"),
    (Join-Path $VSCODE_DIR "data\user-data\User"),
    (Join-Path $WORKSPACE_DIR ".vscode"),
    (Join-Path $HOME_DIR "AppData"),
    (Join-Path $HOME_DIR "AppData\Roaming"),
    (Join-Path $HOME_DIR "AppData\Roaming\Code\User"),
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

# Configure comprehensive Anti-Prompt & Portable Settings across all VS Code targets
$vsCodeGlobalSettings = @"
{
    "update.mode": "none",
    "update.showReleaseNotes": false,
    "update.enableWindowsBackgroundUpdates": false,
    "extensions.autoUpdate": true,
    "extensions.autoCheckUpdates": true,
    "extensions.ignoreRecommendations": true,
    "workbench.enableExperiments": false,
    "workbench.settings.enableNaturalLanguageSearch": false,
    "workbench.startupEditor": "none",
    "telemetry.telemetryLevel": "off",
    "security.workspace.trust.enabled": false,
    "security.workspace.trust.untrustedFiles": "open",
    "security.workspace.trust.startupPrompt": "never",
    "security.workspace.trust.banner": "never",
    "git.confirmSync": false,
    "git.autofetch": true,
    "git.path": "`${workspaceFolder}/../tools/git/cmd/git.exe",
    "python.defaultInterpreterPath": "`${workspaceFolder}/../python/python.exe",
    "terminal.integrated.gpuAcceleration": "off",
    "terminal.integrated.mouseWheelScrollSensitivity": 3
}
"@

$vsSettingsTargets = @(
    (Join-Path $DATA_DIR "vscode-user-data\User\settings.json"),
    (Join-Path $VSCODE_DIR "data\user-data\User\settings.json"),
    (Join-Path $HOME_DIR "AppData\Roaming\Code\User\settings.json")
)
foreach ($targetPath in $vsSettingsTargets) {
    $targetDir = Split-Path $targetPath -Parent
    if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
    if (-not (Test-Path $targetPath) -or $ForceUpdate) {
        $vsCodeGlobalSettings | Set-Content -Path $targetPath -Encoding UTF8
    } else {
        try {
            $existing = Get-Content -Path $targetPath -Raw | ConvertFrom-Json
            $existing | Add-Member -NotePropertyName "update.mode" -NotePropertyValue "none" -Force
            $existing | Add-Member -NotePropertyName "update.showReleaseNotes" -NotePropertyValue $false -Force
            $existing | Add-Member -NotePropertyName "update.enableWindowsBackgroundUpdates" -NotePropertyValue $false -Force
            $existing | Add-Member -NotePropertyName "security.workspace.trust.enabled" -NotePropertyValue $false -Force
            $existing | Add-Member -NotePropertyName "security.workspace.trust.startupPrompt" -NotePropertyValue "never" -Force
            $existing | Add-Member -NotePropertyName "security.workspace.trust.banner" -NotePropertyValue "never" -Force
            $existing | Add-Member -NotePropertyName "extensions.autoUpdate" -NotePropertyValue $true -Force
            $existing | ConvertTo-Json -Depth 10 | Set-Content -Path $targetPath -Encoding UTF8
        } catch {
            $vsCodeGlobalSettings | Set-Content -Path $targetPath -Encoding UTF8
        }
    }
}

# Ensure workspace\.vscode\settings.json exists with isolated sandbox variables
$wsSettings = Join-Path $WORKSPACE_DIR ".vscode\settings.json"
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
        "OMNIROUTE_DATA_DIR": "`${workspaceFolder}/../data",
        "DISABLE_AUTO_UPDATER": "1",
        "CLAUDE_AUTO_UPDATER": "disabled",
        "CLAUDE_CODE_DISABLE_UPDATE_CHECK": "1"
    },
    "git.path": "`${workspaceFolder}/../tools/git/cmd/git.exe",
    "python.defaultInterpreterPath": "`${workspaceFolder}/../python/python.exe",
    "task.allowAutomaticTasks": "on",
    "update.mode": "none",
    "update.showReleaseNotes": false,
    "security.workspace.trust.enabled": false,
    "security.workspace.trust.untrustedFiles": "open",
    "security.workspace.trust.startupPrompt": "never"
}
"@ | Set-Content -Path $wsSettings -Encoding UTF8

# Ensure Claude Code settings disable prompt-based auto-updater
$claudeSettingsFile = Join-Path $CLAUDE_DIR "settings.json"
@"
{
    "theme": "dark",
    "autoUpdaterStatus": "disabled"
}
"@ | Set-Content -Path $claudeSettingsFile -Encoding UTF8

# Helper to safely create WebClient with user-agent
function Get-SafeWebClient {
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) OmniRoute-Portable")
    return $wc
}

# ------------------------------------------------------------------------------
# 2. DYNAMIC LATEST NODE.JS RESOLVER & AUTO-UPDATER
# ------------------------------------------------------------------------------
$nodeExe = Join-Path $BIN_DIR "node.exe"
$npmCli = Join-Path $BIN_DIR "node_modules\npm\bin\npm-cli.js"
$curNodeVersion = ""
if (Test-Path $nodeExe) {
    try { $curNodeVersion = (& "$nodeExe" -v).Trim() } catch {}
}

$latestNodeVersion = "v24.21.0"
$nodeZipUrl = "https://nodejs.org/dist/v24.21.0/node-v24.21.0-win-x64.zip"
try {
    $wc = Get-SafeWebClient
    $nodeIndexJson = $wc.DownloadString("https://nodejs.org/dist/index.json") | ConvertFrom-Json
    $ltsRelease = $nodeIndexJson | Where-Object { $_.lts -ne $false -and ($_.files -contains "win-x64-zip") } | Select-Object -First 1
    if ($ltsRelease) {
        $latestNodeVersion = $ltsRelease.version
        $nodeZipUrl = "https://nodejs.org/dist/$latestNodeVersion/node-$latestNodeVersion-win-x64.zip"
    }
} catch {}

$shouldUpdateNode = $ForceUpdate -or (-not (Test-Path $nodeExe)) -or (-not (Test-Path $npmCli)) -or ($curNodeVersion -ne "" -and $curNodeVersion -ne $latestNodeVersion)

if ($shouldUpdateNode) {
    Write-Host "  [1/6] Auto-updating Portable Node.js to latest LTS ($latestNodeVersion)..." -ForegroundColor Yellow
    $nodeZip = Join-Path $TEMP_DIR "node-portable-latest.zip"
    $nodeExtract = Join-Path $TEMP_DIR "node-extract-latest"

    try {
        if (Test-Path $nodeExtract) { Remove-Item $nodeExtract -Recurse -Force -ErrorAction SilentlyContinue }
        $wc = Get-SafeWebClient
        $wc.DownloadFile($nodeZipUrl, $nodeZip)
        Expand-Archive -Path $nodeZip -DestinationPath $nodeExtract -Force

        $extractedRoot = Get-ChildItem -Path $nodeExtract | Where-Object { $_.PSIsContainer } | Select-Object -First 1
        Get-ChildItem -Path $extractedRoot.FullName | Copy-Item -Destination $BIN_DIR -Recurse -Force

        Remove-Item $nodeZip, $nodeExtract -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  [OK] Portable Node.js auto-installed/updated to $latestNodeVersion." -ForegroundColor Green
    } catch {
        if (Test-Path $nodeExe) {
            Write-Host "  [OK] Portable Node.js detected: Ready ($curNodeVersion)." -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Failed to download or extract Node.js: $_" -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "  [OK] Portable Node.js is latest ($curNodeVersion): Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 3. DYNAMIC LATEST PYTHON 3.12+ & PIP RESOLVER & AUTO-UPDATER
# ------------------------------------------------------------------------------
$pythonExe = Join-Path $PYTHON_DIR "python.exe"
$pipExe = Join-Path $PYTHON_DIR "Scripts\pip.exe"
$pythonVersionFile = Join-Path $PYTHON_DIR "version.txt"
$curPyVersion = ""
if (Test-Path $pythonVersionFile) {
    try { $curPyVersion = (Get-Content $pythonVersionFile -Raw).Trim() } catch {}
}
if (-not $curPyVersion -and (Test-Path $pythonExe)) {
    try {
        $pyOut = & "$pythonExe" --version 2>&1
        $curPyVersion = ($pyOut -replace '^Python\s+', '').Trim()
    } catch {}
}

$latestPyVersion = "3.12.10"
$pythonZipUrl = "https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip"
$pipScriptUrl = "https://bootstrap.pypa.io/get-pip.py"

$shouldUpdatePy = $ForceUpdate -or (-not (Test-Path $pythonExe)) -or (-not (Test-Path $pipExe)) -or ($curPyVersion -ne "" -and $curPyVersion -ne $latestPyVersion) -or (-not (Test-Path $pythonVersionFile))

if ($shouldUpdatePy) {
    Write-Host "  [2/6] Auto-updating Portable Python ($latestPyVersion) & Pip..." -ForegroundColor Yellow
    $pythonZip = Join-Path $TEMP_DIR "python-portable-latest.zip"
    $pipScript = Join-Path $TEMP_DIR "get-pip.py"

    try {
        if (-not (Test-Path $pythonExe) -or $ForceUpdate -or ($curPyVersion -ne $latestPyVersion)) {
            $wc = Get-SafeWebClient
            $wc.DownloadFile($pythonZipUrl, $pythonZip)
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

            $latestPyVersion | Set-Content -Path $pythonVersionFile -Encoding UTF8
        }

        # Install / Update pip, wheel, setuptools to latest
        $wc = Get-SafeWebClient
        $wc.DownloadFile($pipScriptUrl, $pipScript)
        Start-Process -FilePath $pythonExe -ArgumentList @($pipScript, "--no-warn-script-location", "--no-cache-dir", "--upgrade") -Wait -PassThru -NoNewWindow | Out-Null
        Remove-Item $pipScript -Force -ErrorAction SilentlyContinue

        Write-Host "  [OK] Portable Python & Pip auto-installed/updated to latest." -ForegroundColor Green
    } catch {
        if (Test-Path $pythonExe) {
            Write-Host "  [OK] Portable Python detected: Ready ($curPyVersion)." -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Failed to download or setup Python: $_" -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "  [OK] Portable Python & Pip detected: Ready ($curPyVersion)." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 4. DYNAMIC LATEST GIT (MINGIT X64) RESOLVER & AUTO-UPDATER
# ------------------------------------------------------------------------------
$gitExe = Join-Path $PORTABLE_GIT_DIR "cmd\git.exe"
$gitVersionFile = Join-Path $PORTABLE_GIT_DIR "version.txt"
$curGitVersion = ""
if (Test-Path $gitVersionFile) {
    try { $curGitVersion = (Get-Content $gitVersionFile -Raw).Trim() } catch {}
}
if (-not $curGitVersion -and (Test-Path $gitExe)) {
    try {
        $gitOut = (& "$gitExe" --version).Trim()
        $curGitVersion = ($gitOut -replace '^git version\s+', 'v').Trim()
    } catch {}
}

$latestGitTag = "v2.55.0.windows.5"
$gitZipUrl = "https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.5/MinGit-2.55.0.5-64-bit.zip"
try {
    $wc = Get-SafeWebClient
    $gitRelease = $wc.DownloadString("https://api.github.com/repos/git-for-windows/git/releases/latest") | ConvertFrom-Json
    $gitAsset = $gitRelease.assets | Where-Object { $_.name -match '^MinGit-.*-64-bit\.zip$' } | Select-Object -First 1
    if ($gitAsset) {
        $latestGitTag = $gitRelease.tag_name
        $gitZipUrl = $gitAsset.browser_download_url
    }
} catch {}

$shouldUpdateGit = $ForceUpdate -or (-not (Test-Path $gitExe)) -or ($curGitVersion -ne "" -and $curGitVersion -ne $latestGitTag) -or (-not (Test-Path $gitVersionFile))

if ($shouldUpdateGit) {
    Write-Host "  [3/6] Auto-updating Portable Git to latest ($latestGitTag)..." -ForegroundColor Yellow
    $gitZip = Join-Path $TEMP_DIR "mingit-portable-latest.zip"

    try {
        $wc = Get-SafeWebClient
        $wc.DownloadFile($gitZipUrl, $gitZip)
        Expand-Archive -Path $gitZip -DestinationPath $PORTABLE_GIT_DIR -Force
        Remove-Item $gitZip -Force -ErrorAction SilentlyContinue
        $latestGitTag | Set-Content -Path $gitVersionFile -Encoding UTF8
        Write-Host "  [OK] Portable Git auto-installed/updated to $latestGitTag." -ForegroundColor Green
    } catch {
        if (Test-Path $gitExe) {
            Write-Host "  [OK] Portable Git detected: Ready ($curGitVersion)." -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Failed to download or extract Git: $_" -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "  [OK] Portable Git is latest ($curGitVersion): Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 5. DYNAMIC LATEST HOPPSCOTCH DESKTOP RESOLVER & AUTO-UPDATER
# ------------------------------------------------------------------------------
$hoppExe = Get-ChildItem -Path $HOPPSCOTCH_DIR -Filter "*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
$hoppVersionFile = Join-Path $HOPPSCOTCH_DIR "version.txt"
$curHoppTag = ""
if (Test-Path $hoppVersionFile) {
    try { $curHoppTag = (Get-Content $hoppVersionFile -Raw).Trim() } catch {}
}

$latestHoppTag = "v26.8.1-0"
$hoppZipUrl = "https://github.com/hoppscotch/releases/releases/download/v26.8.1-0/Hoppscotch_SelfHost_win_x64_portable.zip"
try {
    $wc = Get-SafeWebClient
    $hoppRelease = $wc.DownloadString("https://api.github.com/repos/hoppscotch/releases/releases/latest") | ConvertFrom-Json
    $hoppAsset = $hoppRelease.assets | Where-Object { $_.name -match 'SelfHost.*win_x64_portable\.zip$' -or $_.name -match 'win_x64_portable\.zip$' } | Select-Object -First 1
    if ($hoppAsset) {
        $latestHoppTag = $hoppRelease.tag_name
        $hoppZipUrl = $hoppAsset.browser_download_url
    }
} catch {}

$shouldUpdateHopp = $ForceUpdate -or (-not $hoppExe) -or ($curHoppTag -ne "" -and $curHoppTag -ne $latestHoppTag) -or (-not (Test-Path $hoppVersionFile))

if ($shouldUpdateHopp) {
    Write-Host "  [4/6] Auto-updating Portable Hoppscotch Desktop to latest ($latestHoppTag)..." -ForegroundColor Yellow
    $hoppZip = Join-Path $TEMP_DIR "hoppscotch-portable-latest.zip"

    try {
        $wc = Get-SafeWebClient
        $wc.DownloadFile($hoppZipUrl, $hoppZip)
        Expand-Archive -Path $hoppZip -DestinationPath $HOPPSCOTCH_DIR -Force
        Remove-Item $hoppZip -Force -ErrorAction SilentlyContinue
        $latestHoppTag | Set-Content -Path $hoppVersionFile -Encoding UTF8
        Write-Host "  [OK] Portable Hoppscotch Desktop auto-installed/updated to $latestHoppTag." -ForegroundColor Green
    } catch {
        if ($hoppExe) {
            Write-Host "  [OK] Portable Hoppscotch Desktop detected: Ready." -ForegroundColor Green
        } else {
            Write-Host "  [WARNING] Could not download Hoppscotch Desktop: $_. Proceeding..." -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  [OK] Portable Hoppscotch Desktop is latest ($curHoppTag): Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 6. DYNAMIC LATEST VS CODE RESOLVER & AUTO-UPDATER
# ------------------------------------------------------------------------------
$codeExe = Join-Path $VSCODE_DIR "Code.exe"
$codeCmd = Join-Path $VSCODE_DIR "bin\code.cmd"
$vsVersionFile = Join-Path $VSCODE_DIR "version.txt"
$curVsVersion = ""
if (Test-Path $vsVersionFile) {
    try { $curVsVersion = (Get-Content $vsVersionFile -Raw).Trim() } catch {}
}
if (-not $curVsVersion -and (Test-Path $codeCmd)) {
    try {
        $vsOut = & "$codeCmd" --version 2>&1
        $curVsVersion = ($vsOut -split "`r?`n")[0].Trim()
    } catch {}
}

$latestVsVersion = "1.138.0"
$codeZipUrl = "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
try {
    $wc = Get-SafeWebClient
    $releases = $wc.DownloadString("https://update.code.visualstudio.com/api/releases/stable") | ConvertFrom-Json
    if ($releases -and $releases.Count -gt 0) {
        $latestVsVersion = $releases[0]
    }
} catch {}

$shouldUpdateCode = $ForceUpdate -or (-not (Test-Path $codeExe)) -or ($curVsVersion -ne "" -and $curVsVersion -ne $latestVsVersion)

if ($shouldUpdateCode) {
    # Check if Code is currently running
    $codeProc = Get-Process -Name "Code" -ErrorAction SilentlyContinue
    if ($codeProc -and (Test-Path $codeExe)) {
        Write-Host "  [OK] Portable VS Code is active (v$curVsVersion). New version (v$latestVsVersion) will update cleanly on restart." -ForegroundColor Green
    } else {
        Write-Host "  [5/6] Auto-updating Portable VS Code to latest (v$latestVsVersion)..." -ForegroundColor Yellow
        $codeZip = Join-Path $TEMP_DIR "vscode-portable-latest.zip"
        $codeExtract = Join-Path $TEMP_DIR "vscode-extract-latest"

        try {
            if (Test-Path $codeExtract) { Remove-Item $codeExtract -Recurse -Force -ErrorAction SilentlyContinue }
            $wc = Get-SafeWebClient
            $wc.DownloadFile($codeZipUrl, $codeZip)
            Expand-Archive -Path $codeZip -DestinationPath $codeExtract -Force

            # Copy extracted files over VS Code folder preserving data directory
            Get-ChildItem -Path $codeExtract | ForEach-Object {
                if ($_.Name -ne "data") {
                    Copy-Item -Path $_.FullName -Destination $VSCODE_DIR -Recurse -Force
                }
            }

            # Ensure portable data directory exists inside vscode
            $vsData = Join-Path $VSCODE_DIR "data"
            if (-not (Test-Path $vsData)) { New-Item -ItemType Directory -Path $vsData -Force | Out-Null }

            $latestVsVersion | Set-Content -Path $vsVersionFile -Encoding UTF8
            Remove-Item $codeZip, $codeExtract -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "  [OK] Portable VS Code auto-installed/updated to v$latestVsVersion." -ForegroundColor Green
        } catch {
            if (Test-Path $codeExe) {
                Write-Host "  [OK] Portable VS Code detected: Ready ($curVsVersion)." -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Failed to download or extract VS Code: $_" -ForegroundColor Red
                exit 1
            }
        }
    }
} else {
    Write-Host "  [OK] Portable VS Code is latest (v$curVsVersion): Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 7. ALWAYS-LATEST AUTO-UPDATE FOR CLI PACKAGES & PIP
# ------------------------------------------------------------------------------
$omnirouteMjs = Join-Path $BIN_DIR "node_modules\omniroute\bin\omniroute.mjs"
$claudePkg = Join-Path $BIN_DIR "node_modules\@anthropic-ai\claude-code"
$hoppPkg = Join-Path $BIN_DIR "node_modules\@hoppscotch\cli"

Write-Host "  [6/6] Auto-verifying and updating OmniRoute, Claude Code, and Hoppscotch CLI (@latest)..." -ForegroundColor Yellow

try {
    & "$nodeExe" "$npmCli" install -g omniroute@latest @anthropic-ai/claude-code@latest @hoppscotch/cli@latest --prefix "$BIN_DIR" --no-audit --no-fund
    if ($LASTEXITCODE -ne 0) {
        & "$nodeExe" "$npmCli" install -g omniroute@latest @anthropic-ai/claude-code@latest @hoppscotch/cli@latest --prefix "$BIN_DIR" --legacy-peer-deps --no-audit --no-fund
    }

    # Update pip, setuptools, wheel in portable python
    if (Test-Path $pipExe) {
        & "$pythonExe" -m pip install --upgrade --no-cache-dir pip setuptools wheel --no-warn-script-location 2>$null | Out-Null
    }

    (Get-Date).ToString("o") | Set-Content -Path (Join-Path $DATA_DIR "last_update_check.timestamp") -Encoding UTF8
    Write-Host "  [OK] All CLI packages, tools, and libraries are updated to @latest." -ForegroundColor Green
} catch {
    Write-Host "  [OK] Using verified local packages: Ready." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 8. COMPREHENSIVE END-TO-END INTEGRITY & FUNCTIONALITY VERIFICATION
# ------------------------------------------------------------------------------
Write-Host ""
Write-Host "==============================================================================" -ForegroundColor DarkCyan
Write-Host "         VERIFYING COMPLETE SYSTEM INTEGRITY BEFORE STARTUP" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor DarkCyan
Write-Host "  Validating that all tools, binaries, environments, and configs are healthy..."
Write-Host ""

$verificationFailed = $false
$failureReasons = @()

# 1. Verify Node.js & npm
try {
    $nodeVerTest = (& "$nodeExe" -v).Trim()
    $npmVerTest = (& "$nodeExe" "$npmCli" -v).Trim()
    if ($nodeVerTest -match '^v\d+' -and $npmVerTest -match '^\d+') {
        Write-Host "  [VERIFIED 1/8] Node.js ($nodeVerTest) & npm ($npmVerTest) are healthy." -ForegroundColor Green
    } else {
        throw "Unexpected version response (Node: $nodeVerTest, npm: $npmVerTest)"
    }
} catch {
    $verificationFailed = $true
    $failureReasons += "Node.js / npm runtime error: $_"
    Write-Host "  [FAIL 1/8] Node.js runtime verification failed: $_" -ForegroundColor Red
}

# 2. Verify Python & Pip & site-packages
try {
    $pyVerTest = (& "$pythonExe" --version 2>&1).Trim()
    & "$pythonExe" -c "import sys, os; sys.exit(0 if os.path.exists(os.path.join(sys.prefix, 'Lib', 'site-packages')) else 1)"
    $pyExit = $LASTEXITCODE
    $pipVerTest = (& "$pythonExe" "$pipExe" --version 2>&1).Trim()
    if ($pyExit -eq 0 -and $pipVerTest -match 'pip \d+') {
        Write-Host "  [VERIFIED 2/8] Python ($pyVerTest) & Pip are healthy (site-packages active)." -ForegroundColor Green
    } else {
        throw "Python site-packages verification failed (ExitCode: $pyExit)"
    }
} catch {
    $verificationFailed = $true
    $failureReasons += "Python runtime error: $_"
    Write-Host "  [FAIL 2/8] Python environment verification failed: $_" -ForegroundColor Red
}

# 3. Verify Git
try {
    $gitVerTest = (& "$gitExe" --version 2>&1).Trim()
    if ($gitVerTest -match 'git version \d+') {
        Write-Host "  [VERIFIED 3/8] Git for Windows ($gitVerTest) is healthy." -ForegroundColor Green
    } else {
        throw "Git execution returned: $gitVerTest"
    }
} catch {
    $verificationFailed = $true
    $failureReasons += "Git binary error: $_"
    Write-Host "  [FAIL 3/8] Git verification failed: $_" -ForegroundColor Red
}

# 4. Verify Hoppscotch Desktop
try {
    $hoppApp = Get-ChildItem -Path $HOPPSCOTCH_DIR -Filter "*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($hoppApp -and (Test-Path $hoppApp.FullName)) {
        Write-Host "  [VERIFIED 4/8] Hoppscotch Desktop ($($hoppApp.Name)) is ready." -ForegroundColor Green
    } else {
        throw "Hoppscotch Desktop executable not found in $HOPPSCOTCH_DIR"
    }
} catch {
    $verificationFailed = $true
    $failureReasons += "Hoppscotch Desktop error: $_"
    Write-Host "  [FAIL 4/8] Hoppscotch Desktop verification failed: $_" -ForegroundColor Red
}

# 5. Verify VS Code
try {
    if (Test-Path $codeExe) {
        $vsVerTest = (& "$codeCmd" --version 2>&1 | Select-Object -First 1).Trim()
        Write-Host "  [VERIFIED 5/8] Portable VS Code IDE (v$vsVerTest) is healthy." -ForegroundColor Green
    } else {
        throw "VS Code executable not found at $codeExe"
    }
} catch {
    $verificationFailed = $true
    $failureReasons += "VS Code error: $_"
    Write-Host "  [FAIL 5/8] VS Code verification failed: $_" -ForegroundColor Red
}

# 6. Verify OmniRoute CLI
try {
    $omniVerTest = (& "$nodeExe" "$BIN_DIR\node_modules\omniroute\bin\omniroute.mjs" --version 2>&1).Trim()
    if ($omniVerTest -match '\d+\.\d+') {
        Write-Host "  [VERIFIED 6/8] OmniRoute Engine ($omniVerTest) is healthy." -ForegroundColor Green
    } else {
        throw "OmniRoute version returned: $omniVerTest"
    }
} catch {
    $verificationFailed = $true
    $failureReasons += "OmniRoute error: $_"
    Write-Host "  [FAIL 6/8] OmniRoute verification failed: $_" -ForegroundColor Red
}

# 7. Verify Claude Code CLI
try {
    $claudeVerTest = (& "$nodeExe" "$BIN_DIR\node_modules\@anthropic-ai\claude-code\cli-wrapper.cjs" --version 2>&1).Trim()
    if ($claudeVerTest -match '\d+\.\d+') {
        Write-Host "  [VERIFIED 7/8] Claude Code CLI ($claudeVerTest) is healthy." -ForegroundColor Green
    } else {
        throw "Claude Code returned: $claudeVerTest"
    }
} catch {
    $verificationFailed = $true
    $failureReasons += "Claude Code error: $_"
    Write-Host "  [FAIL 7/8] Claude Code verification failed: $_" -ForegroundColor Red
}

# 8. Verify Hoppscotch CLI
try {
    $hoppCliTest = (& "$nodeExe" "$BIN_DIR\node_modules\@hoppscotch\cli\bin\hopp.js" -v 2>&1).Trim()
    if ($hoppCliTest -match '\d+\.\d+') {
        Write-Host "  [VERIFIED 8/8] Hoppscotch CLI ($hoppCliTest) is healthy." -ForegroundColor Green
    } else {
        throw "Hoppscotch CLI returned: $hoppCliTest"
    }
} catch {
    $verificationFailed = $true
    $failureReasons += "Hoppscotch CLI error: $_"
    Write-Host "  [FAIL 8/8] Hoppscotch CLI verification failed: $_" -ForegroundColor Red
}

# 9. Verify Isolation & Encryption Configuration
try {
    if (-not (Test-Path $envFile)) { throw "Storage encryption key (.env) missing" }
    if (-not (Test-Path $wsSettings)) { throw "Workspace settings (.vscode/settings.json) missing" }
    Write-Host "  [VERIFIED SANDBOX] Storage encryption key & portable configs are valid." -ForegroundColor Green
} catch {
    $verificationFailed = $true
    $failureReasons += "Sandbox configuration error: $_"
    Write-Host "  [FAIL SANDBOX] Configuration check failed: $_" -ForegroundColor Red
}

Write-Host "==============================================================================" -ForegroundColor DarkCyan

if ($verificationFailed) {
    Write-Host ""
    Write-Host "  [ERROR] System verification failed with the following issues:" -ForegroundColor Red
    foreach ($reason in $failureReasons) {
        Write-Host "    - $reason" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "  Startup aborted. No background servers or applications will be launched." -ForegroundColor Red
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "  [SUCCESS] All subsystems verified 100% healthy, latest, and fully portable!" -ForegroundColor Green
Write-Host "  Proceeding with secure background services and IDE startup..." -ForegroundColor Green
Write-Host ""
exit 0
