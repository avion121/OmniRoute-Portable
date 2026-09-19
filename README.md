# 🚀 OmniRoute Portable AI Developer Drive

A complete, zero-setup, fully portable development environment bundling **OmniRoute**, **Claude Code CLI**, **Portable Python 3.12 (with Pip)**, **Portable Git**, **Portable Hoppscotch (Desktop & CLI)**, and **Portable VS Code**.

**Cross-Platform Ready**: 100% portable on **Windows**, **macOS (Apple Silicon & Intel)**, and **Linux (x86_64 & ARM64)**.

Everything runs completely isolated from your host system — settings, extensions, API keys, cache, and workspace are all contained within this portable directory.

---

## ✨ Features

- **⚡ 100% Zero Configuration / 1-Click Launch**:
  - **Windows**: Double-click `Start-OmniRoute.bat`
  - **macOS & Linux**: Run `./Start-OmniRoute.sh`
- **🛡️ Strict 11-Point Pre-Launch Integrity Verification**: Before any background services or VS Code are started, a strict integrity suite actively validates the health of all 11 subsystems:
  1. `Node.js LTS & npm` runtime integrity
  2. `Python 3.12+ & Pip` environment with activated `Lib/site-packages`
  3. `Git` version control binary & global configuration isolation
  4. `Hoppscotch Desktop` application binary / ecosystem
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
  - **Git** (MinGit / native portable toolchain)
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

### 2. Run the 1-Click Launcher

#### On Windows:
Double-click:
```bat
Start-OmniRoute.bat
```

#### On macOS / Linux:
Make executable and run:
```bash
chmod +x *.sh data/*.sh
./Start-OmniRoute.sh
```

> **Automated Setup on First Run**: If portable binaries (Node.js, Python, Git, Hoppscotch, and VS Code) are not yet on the drive, the bootstrapper will automatically download, extract, and configure everything in ~1-2 minutes. On subsequent runs, it starts instantly in under 2 seconds!

### 3. Update Everything Anytime

#### On Windows:
Double-click:
```bat
Update-All-Components.bat
```

#### On macOS / Linux:
```bash
./Update-All-Components.sh
```

### 4. Start Coding with Claude Code
1. VS Code will open automatically focused on the `workspace/` folder.
2. Open the integrated terminal in VS Code:
   - Shortcut: `Ctrl + ~` (or ``Ctrl + ` `` / `Cmd + ` `)
3. Run Claude Code connected to OmniRoute:
   ```bash
   omniroute launch --model free-stack
   ```

---

## 📁 Directory Structure

```
OmniRoute-Portable/
├── Start-OmniRoute.bat        # Windows 1-click launcher
├── Start-OmniRoute.sh         # macOS & Linux 1-click launcher
├── Update-All-Components.bat  # Windows 1-click component updater
├── Update-All-Components.sh   # macOS & Linux 1-click component updater
├── bootstrap.ps1              # Windows automated installer & updater engine
├── bootstrap.sh               # macOS & Linux automated installer & updater engine
├── CLAUDE.md                  # Global Open Agent Skills developer guidelines
├── README.md                  # Documentation
├── .gitignore                 # Git ignore configuration
│
├── bin/                       # Portable Node.js, npm, omniroute, claude, hopp & skills binaries
│   ├── omniroute              # OmniRoute CLI (POSIX)
│   ├── omniroute.cmd          # OmniRoute CLI (Windows)
│   ├── claude                 # Claude Code CLI (POSIX)
│   ├── claude.cmd             # Claude Code CLI (Windows)
│   ├── hopp                   # Hoppscotch CLI (POSIX)
│   ├── hopp.cmd               # Hoppscotch CLI (Windows)
│   ├── skills                 # Open Agent Skills CLI (POSIX)
│   ├── skills.cmd             # Open Agent Skills CLI (Windows)
│   └── npm.cmd / npm          # Portable NPM
│
├── python/                    # Portable Python 3.12 & Pip
│   ├── python.exe / python3   # Python interpreter
│   ├── Lib/site-packages/     # Installed Python packages (yt-dlp, requests, bs4)
│   └── Scripts/ / bin/        # pip, pip3, and CLI package executables
│
├── tools/
│   └── git/                   # Portable Git
│       └── cmd/git.exe / bin  # Git CLI executable
│
├── hoppscotch/                # Portable Hoppscotch Desktop App & Data
│
├── data/                      # Sandboxed application data & configuration
│   ├── .env.example           # Storage encryption key & host template
│   ├── storage.sqlite         # SQLite database with combos, providers, and settings
│   ├── claude/                # Claude Code configuration
│   │   └── skills/            # Dynamic skills directory (find-skills meta-skill)
│   ├── launch-claude-omniroute.bat / .sh
│   ├── start-omniroute.bat / .sh
│   └── start-hoppscotch.bat / .sh
│
├── vscode/                    # Portable VS Code installation directory
│
├── workspace/                 # Your project working directory
│   ├── CLAUDE.md              # Progressive disclosure & dynamic skills guidelines
│   └── .vscode/
│       ├── settings.json      # Cross-platform environment variables (Win/Mac/Linux)
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
When `Start-OmniRoute` is running, the OmniRoute web dashboard is accessible at:
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
1. **Desktop App**: Launch `data/start-hoppscotch.bat` (or `data/start-hoppscotch.sh` on Unix) to open the full UI.
2. **CLI**: Run collections and tests directly from terminal:
   ```bash
   hopp test collection.json
   ```

### Python & Pip Usage
The terminal in VS Code is automatically pre-configured with Python and Pip in its PATH across Windows, macOS, and Linux:
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
- **First-run download issues**: Ensure you have an active internet connection so the bootstrapper can download portable Node.js, Python, Git, Hoppscotch, and VS Code archives.
- **Database / Encryption**: The `data/.env` file contains the `STORAGE_ENCRYPTION_KEY` matching the included `data/storage.sqlite` database. The launcher automatically creates `.env` on first launch.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
