# 🚀 OmniRoute Portable AI Developer Drive

A complete, zero-setup, fully portable development environment bundling **OmniRoute**, **Claude Code CLI**, and **Portable VS Code**.

Everything runs completely isolated from your host system — settings, extensions, API keys, cache, and workspace are all contained within this portable directory.

---

## ✨ Features

- **⚡ Zero Configuration / 1-Click Launch**: Clone the repository and double-click `Start-OmniRoute.bat`. The script automatically handles downloading portable components if missing and boots up OmniRoute + VS Code immediately.
- **🔄 OmniRoute AI Proxy & Router**: Pre-configured with the `free-stack` model combo with intelligent routing and automatic fallback chains across multiple top-tier models.
- **💻 Claude Code CLI**: Anthropic's interactive agentic coding assistant ready to pair-program directly in your terminal.
- **📦 100% Portable**: No global Node.js or VS Code installation required on the host computer. Works from any folder or USB drive.
- **🔒 Isolated Workspace**: User profile, VS Code extensions, user data, and Claude configuration are sandboxed in the local `data/` and `home/` folders.

---

## 🏁 Quick Start

### 1. Clone the Repository
```bash
git clone <YOUR-REPO-URL>
cd OmniRoute-Portable-With-VS-CODE-TUI_CLAUDE-CODE
```

### 2. Run the Launcher
Double-click:
```bat
Start-OmniRoute.bat
```

> **Note on First Run**: If portable binaries (Node.js and VS Code) are not present, `Start-OmniRoute.bat` will automatically download and set them up in ~1-2 minutes. On subsequent runs, it starts instantly in under 2 seconds!

### 3. Start Coding with Claude Code
1. VS Code will open automatically focused on the `workspace/` folder.
2. Open the integrated terminal in VS Code:
   - Shortcut: `Ctrl + ~` (or ``Ctrl + ` ``)
3. Run Claude Code connected to OmniRoute:
   ```bash
   omniroute launch --model free-stack
   ```
   *(or simply type `claude`)*

---

## 📁 Directory Structure

```
OmniRoute-Portable/
├── Start-OmniRoute.bat        # Main 1-click launcher & auto-bootstrapper
├── README.md                  # Documentation
├── .gitignore                 # Git ignore configuration
│
├── bin/                       # Portable Node.js, npm, omniroute & claude binaries
│   ├── omniroute.cmd          # OmniRoute CLI command
│   ├── claude.cmd             # Claude Code CLI command
│   └── npm.cmd                # Portable NPM
│
├── data/                      # Sandboxed application data & configuration
│   ├── .env                   # Storage encryption key & host config
│   ├── storage.sqlite         # SQLite database with combos, providers, and settings
│   ├── claude/                # Claude Code configuration directory
│   ├── launch-claude-omniroute.cmd
│   └── start-omniroute.cmd
│
├── vscode/                    # Portable VS Code installation directory
│
├── workspace/                 # Your project working directory
│   └── .vscode/
│       ├── settings.json      # Pre-configured environment variables
│       └── tasks.json         # Automated startup tasks
│
└── home/                      # Sandboxed USERPROFILE & HOME directory
```

---

## ⚙️ Configuration & Customization

### OmniRoute Web UI
When `Start-OmniRoute.bat` is running, OmniRoute web dashboard is accessible at:
- **URL**: [http://127.0.0.1:20128](http://127.0.0.1:20128)

From the dashboard you can:
- Add or modify API keys and provider connections.
- Customize the `free-stack` combo or create new custom model combos.
- Monitor request logs, token usage, and latency.

### Adding Your Own Project
To work on your existing code:
1. Copy your project folder into the `workspace/` directory, or
2. Use **File -> Open Folder** in VS Code to open your desired project folder.
3. Open the terminal and launch `omniroute launch --model free-stack`.

---

## 🛠️ Troubleshooting

- **OmniRoute port conflict (20128)**: Ensure no other instance of OmniRoute or proxy is running on port `20128`.
- **First-run download issues**: Ensure you have an active internet connection so PowerShell can download portable Node.js and VS Code archives.
- **Database / Encryption**: The `data/.env` file contains the `STORAGE_ENCRYPTION_KEY` matching the included `data/storage.sqlite` database. Keep both files paired.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
