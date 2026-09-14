# 🚀 OmniRoute Portable AI Developer Drive

A complete, zero-setup, fully portable development environment bundling **OmniRoute**, **Claude Code CLI**, **Portable Python 3.12 (with Pip)**, **Portable Git for Windows**, **Portable Hoppscotch (Desktop & CLI)**, and **Portable VS Code**.

Everything runs completely isolated from your host system — settings, extensions, API keys, cache, and workspace are all contained within this portable directory.

---

## ✨ Features

- **⚡ 100% Zero Configuration / 1-Click Launch**: Clone the repository and double-click `Start-OmniRoute.bat`.
- **🔄 Always Up-to-Date**: Automatically checks and updates packages (`omniroute@latest`, `@anthropic-ai/claude-code@latest`, `@hoppscotch/cli@latest`, and `pip`) on startup (with 24-hour smart cadence) or manually via `Update-All-Components.bat`.
- **🛠️ Self-Checking & Auto-Bootstrapping Engine**: The script automatically checks all prerequisites and dependencies:
  - If **Portable Node.js LTS** is missing, it downloads and sets it up automatically.
  - If **Portable Python 3.12 & Pip** are missing, it downloads embeddable Python, enables `site-packages`, and bootstraps `pip` automatically.
  - If **Portable Git (MinGit x64)** is missing, it downloads and extracts Git for Windows automatically.
  - If **Portable Hoppscotch Desktop** is missing, it downloads the standalone desktop app automatically.
  - If **Portable VS Code** is missing, it downloads and extracts it to the drive.
  - If **OmniRoute**, **Claude Code**, or **Hoppscotch CLI** are missing, it installs them via portable npm.
- **🔄 OmniRoute AI Proxy & Router**: Pre-configured with the `free-stack` model combo with intelligent routing and automatic fallback chains across multiple top-tier models.
- **💻 Claude Code CLI**: Anthropic's interactive agentic coding assistant ready to pair-program directly in your terminal.
- **🎯 Hoppscotch API Ecosystem**: Test REST, GraphQL, and WebSocket endpoints via the **Hoppscotch Desktop App** or run automated collections with the `hopp` CLI.
- **🐍 Full Python & Git Toolchain**: Run Python scripts, install Python libraries via `pip`, and execute `git` version control commands out of the box.
- **📦 100% Portable**: No global Node.js, Python, Git, Hoppscotch, or VS Code installation required on the host computer. Works from any folder or USB drive.
- **🔒 Sandboxed & Isolated Workspace**: User profile, VS Code extensions, user data, and Claude configuration are contained in `data/`, `home/`, and `workspace/`.

---

## 🏁 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/avion121/OmniRoute-Portable.git
cd OmniRoute-Portable
```

### 2. Run the Launcher
Double-click:
```bat
Start-OmniRoute.bat
```

> **Automated Setup on First Run**: If portable binaries (Node.js, Python, Git, Hoppscotch, and VS Code) are not yet on the drive, `Start-OmniRoute.bat` will automatically download and install everything via PowerShell in ~1-2 minutes. On subsequent runs, it starts instantly in under 2 seconds!

### 3. Update Everything Anytime
To manually trigger a complete check and update for all components and tools, double-click:
```bat
Update-All-Components.bat
```

### 4. Start Coding with Claude Code
1. VS Code will open automatically focused on the `workspace/` folder.
2. Open the integrated terminal in VS Code:
   - Shortcut: `Ctrl + ~` (or ``Ctrl + ` ``)
3. Run Claude Code connected to OmniRoute:
   ```bash
   omniroute launch --model free-stack
   ```

---

## 📁 Directory Structure

```
OmniRoute-Portable/
├── Start-OmniRoute.bat        # Main 1-click launcher
├── Update-All-Components.bat  # 1-click update engine for all tools & packages
├── bootstrap.ps1              # Automated dependency installer & updater engine
├── README.md                  # Documentation
├── .gitignore                 # Git ignore configuration
│
├── bin/                       # Portable Node.js, npm, omniroute, claude & hopp binaries
│   ├── omniroute.cmd          # OmniRoute CLI command
│   ├── claude.cmd             # Claude Code CLI command
│   ├── hopp.cmd               # Hoppscotch CLI command
│   └── npm.cmd                # Portable NPM
│
├── python/                    # Portable Python 3.12 & Pip
│   ├── python.exe             # Python interpreter
│   ├── python3.exe            # Python3 alias
│   ├── Lib/site-packages/     # Installed Python packages
│   └── Scripts/               # pip, pip3, and CLI package executables
│
├── tools/
│   └── git/                   # Portable Git (MinGit)
│       └── cmd/git.exe        # Git CLI executable
│
├── hoppscotch/                # Portable Hoppscotch Desktop App
│   └── Hoppscotch.exe         # Hoppscotch Desktop executable
│
├── data/                      # Sandboxed application data & configuration
│   ├── .env.example           # Storage encryption key & host template
│   ├── storage.sqlite         # SQLite database with combos, providers, and settings
│   ├── claude/                # Claude Code configuration directory
│   ├── launch-claude-omniroute.cmd
│   ├── start-omniroute.cmd
│   └── start-hoppscotch.cmd   # Standalone Hoppscotch Desktop launcher
│
├── vscode/                    # Portable VS Code installation directory
│
├── workspace/                 # Your project working directory
│   └── .vscode/
│       ├── settings.json      # Pre-configured environment variables & tool paths
│       └── tasks.json         # Automated startup tasks
│
└── home/                      # Sandboxed USERPROFILE & HOME directory
```

---

## ⚙️ Configuration & Customization

### OmniRoute Web UI
When `Start-OmniRoute.bat` is running, the OmniRoute web dashboard is accessible at:
- **URL**: [http://127.0.0.1:20128](http://127.0.0.1:20128)

From the dashboard you can:
- Add or modify API keys and provider connections.
- Customize the `free-stack` combo or create new custom model combos.
- Monitor request logs, token usage, and latency.

### Working on Any Project
To work on your existing code:
1. Copy your project folder into the `workspace/` directory, or
2. Use **File -> Open Folder** in VS Code to open your desired project folder.
3. Open the terminal and launch `omniroute launch --model free-stack`.

### Hoppscotch API Testing
You can use Hoppscotch in two ways:
1. **Desktop App**: Double-click `data/start-hoppscotch.cmd` or launch `hoppscotch/Hoppscotch.exe` to open the full UI.
2. **CLI**: Run collections and tests directly from terminal:
   ```bash
   hopp test collection.json
   ```

### Python & Pip Usage
The terminal in VS Code is automatically pre-configured with Python and Pip in its PATH:
```bash
# Check Python and Pip versions
python --version
pip --version

# Install any package
pip install requests fastapi uvicorn
```

### Git Usage
Portable Git is ready out of the box for both CLI and VS Code Source Control panel:
```bash
git status
git add .
git commit -m "Initial commit"
```

---

## 🛠️ Troubleshooting

- **OmniRoute port conflict (20128)**: Ensure no other instance of OmniRoute or proxy is running on port `20128`.
- **First-run download issues**: Ensure you have an active internet connection so PowerShell can download portable Node.js, Python, Git, Hoppscotch, and VS Code archives.
- **Database / Encryption**: The `data/.env` file contains the `STORAGE_ENCRYPTION_KEY` matching the included `data/storage.sqlite` database. The launcher automatically creates `.env` on first launch.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
