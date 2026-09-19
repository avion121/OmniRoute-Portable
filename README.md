# 🚀 OmniRoute Portable AI Developer Drive

A complete, zero-setup, fully portable development environment bundling **OmniRoute**, **Claude Code CLI**, **Portable Python 3.12 (with Pip)**, **Portable Git for Windows**, **Portable Hoppscotch (Desktop & CLI)**, and **Portable VS Code**.

Everything runs completely isolated from your host system — settings, extensions, API keys, cache, and workspace are all contained within this portable directory.

---

## ✨ Features

- **⚡ 100% Zero Configuration / 1-Click Launch**: Clone the repository and double-click `Start-OmniRoute.bat`.
- **🛡️ Strict 11-Point Pre-Launch Integrity Verification**: Before any background services or VS Code are started, a strict integrity suite actively validates the health of all 11 subsystems:
  1. `Node.js LTS & npm` runtime integrity
  2. `Python 3.12+ & Pip` environment with activated `Lib/site-packages`
  3. `Git for Windows (MinGit)` binary & global configuration
  4. `Hoppscotch Desktop` application binary
  5. `Portable VS Code` IDE executable & portable user profile
  6. `OmniRoute Engine & CLI` proxy router
  7. `Claude Code CLI` agentic developer assistant
  8. `Hoppscotch CLI` API test runner
  9. `Open Agent Skills CLI (skills)` package manager & command interface
  10. `Skill: find-skills` dynamic open agent skills registry discovery meta-skill
  11. `Storage Encryption & Sandbox` isolation configuration (.env & workspace settings)
- **🔒 Gated Startup Protection**: If any subsystem fails the verification check or auto-update, the launch process halts immediately with a clear diagnostics report — zero background processes or IDE windows are spawned until everything is 100% verified.
- **🔄 Dynamic Auto-Update Engine**: Automatically queries official APIs on every launch to check for and install the latest releases:
  - **Node.js LTS** (via `nodejs.org` release index)
  - **Python & Pip** (via `python.org` & `pypa.io`)
  - **Git for Windows** (via GitHub releases API)
  - **Hoppscotch Desktop** (via GitHub releases API)
  - **Portable VS Code** (via Microsoft stable release API)
  - **OmniRoute, Claude Code CLI, Hoppscotch CLI, & Skills CLI** (via npm registry `@latest`)
- **🤖 Dynamic On-Demand Agent Skills & Progressive Disclosure**:
  - **Lean Core**: Ships with zero pre-loaded skill bloat for instant startup and lightning performance.
  - **Progressive Disclosure**: Agents inspect project manifests (`package.json`, `tsconfig.json`, `requirements.txt`, etc.) and dynamically discover skills using `find-skills` and the portable `skills` CLI on demand.
  - **1,500+ Skills Access**: Search and install official vendor skills on-the-fly (`skills find <query>`, `skills add <vendor/skill>`).
- **🔇 Prompt-Free & Uninterrupted**: Background auto-updater prompts and telemetry popups are silenced (`DISABLE_AUTO_UPDATER=1`, workspace trust disabled) for a distraction-free experience.
- **🔄 OmniRoute AI Proxy & Router**: Pre-configured with the `free-stack` model combo with intelligent routing and automatic fallback chains across 30 free providers and 298 models.
- **💻 Claude Code CLI**: Anthropic's interactive agentic coding assistant ready to pair-program directly in your terminal with zero login prompts or token friction.
- **🎯 Hoppscotch API Ecosystem**: Test REST, GraphQL, and WebSocket endpoints via the **Hoppscotch Desktop App** or run automated collections with the `hopp` CLI.
- **🐍 Full Python & Git Toolchain**: Run Python scripts, install Python libraries via `pip`, and execute `git` version control commands out of the box.
- **📦 100% Portable**: No global Node.js, Python, Git, Hoppscotch, or VS Code installation required on the host computer. Works from any folder or USB drive.
- **🔒 Sandboxed & Isolated Workspace**: User profile, VS Code extensions, user data, and Claude configuration are strictly isolated in `data/`, `home/`, and `workspace/`.

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
├── CLAUDE.md                  # Global Open Agent Skills developer guidelines
├── README.md                  # Documentation
├── .gitignore                 # Git ignore configuration
│
├── bin/                       # Portable Node.js, npm, omniroute, claude, hopp & skills binaries
│   ├── omniroute.cmd          # OmniRoute CLI command
│   ├── claude.cmd             # Claude Code CLI command
│   ├── hopp.cmd               # Hoppscotch CLI command
│   ├── skills.cmd             # Open Agent Skills CLI command
│   └── npm.cmd                # Portable NPM
│
├── python/                    # Portable Python 3.12 & Pip
│   ├── python.exe             # Python interpreter
│   ├── python3.exe            # Python3 alias
│   ├── Lib/site-packages/     # Installed Python packages (yt-dlp, requests, bs4)
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
│   ├── claude/                # Claude Code configuration
│   │   └── skills/            # Dynamic skills directory (find-skills meta-skill)
│   ├── launch-claude-omniroute.cmd
│   ├── start-omniroute.cmd
│   └── start-hoppscotch.cmd   # Standalone Hoppscotch Desktop launcher
│
├── vscode/                    # Portable VS Code installation directory
│
├── workspace/                 # Your project working directory
│   ├── CLAUDE.md              # Progressive disclosure & dynamic skills guidelines
│   └── .vscode/
│       ├── settings.json      # Pre-configured environment variables & tool paths
│       └── tasks.json         # Automated startup tasks
│
└── home/                      # Sandboxed USERPROFILE & HOME directory
```

---

## 🤖 Dynamic On-Demand Skills & Progressive Disclosure

The environment implements a lean on-demand architecture powered by the open agent skills ecosystem:

- **Progressive Disclosure Reflex**: Never assume skills exist. Inspect project files first, and fetch tools dynamically via `skills find` only when a task demands it.
- **`find-skills` Discovery Meta-Skill**: Pre-installed meta-skill for discovering relevant tools across 1,500+ agent skills at [skills.sh](https://skills.sh/).
- **Portable `skills` CLI**: Full command-line interface ready to search, install, and update vendor skills on the fly:
  ```bash
  # Search for specialized skills
  skills find react
  skills find playwright
  skills find fast-api

  # Add top official vendor skill to project
  skills add vercel-labs/agent-skills@react-best-practices -y

  # Update installed skills
  skills update
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
