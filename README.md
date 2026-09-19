# 🚀 OmniRoute Portable AI Developer Drive

A complete, zero-setup, fully portable development environment bundling **OmniRoute**, **Claude Code CLI**, **Portable Python 3.12 (with Pip)**, **Portable Git for Windows**, **Portable Hoppscotch (Desktop & CLI)**, and **Portable VS Code**.

Everything runs completely isolated from your host system — settings, extensions, API keys, cache, and workspace are all contained within this portable directory.

---

## ✨ Features

- **⚡ 100% Zero Configuration / 1-Click Launch**: Clone the repository and double-click `Start-OmniRoute.bat`.
- **🛡️ Strict 15-Point Pre-Launch Integrity Verification**: Before any background services or VS Code are started, a strict integrity suite actively validates the health of all 15 subsystems:
  1. `Node.js LTS & npm` runtime integrity
  2. `Python 3.12+ & Pip` environment with activated `Lib/site-packages` & media packages
  3. `Git for Windows (MinGit)` binary & global configuration
  4. `Hoppscotch Desktop` application binary
  5. `Portable VS Code` IDE executable & portable user profile
  6. `OmniRoute Engine & CLI` proxy router
  7. `Claude Code CLI` agentic developer assistant
  8. `Hoppscotch CLI` API test runner
  9. `Open Agent Skills CLI (skills)` package manager & command interface
  10. `Skill: watch (claude-video)` video/audio frame & transcription toolchain
  11. `Skill: last30days (last30days-skill)` real-time 30-day web & community research
  12. `Skill: humanizer` anti-AI writing validator & natural prose refactoring
  13. `Skill: ponytail suite` minimal architecture & anti-overengineering suite
  14. `Skill: find-skills` open agent skills ecosystem registry discovery
  15. `Storage Encryption & Sandbox` isolation configuration (.env & workspace settings)
- **🔒 Gated Startup Protection**: If any subsystem fails the verification check or auto-update, the launch process halts immediately with a clear diagnostics report — zero background processes or IDE windows are spawned until everything is 100% verified.
- **🔄 Dynamic Auto-Update Engine**: Automatically queries official APIs and git remotes on every launch to check for and install the latest releases:
  - **Node.js LTS** (via `nodejs.org` release index)
  - **Python & Pip** (via `python.org` & `pypa.io`)
  - **Git for Windows** (via GitHub releases API)
  - **Hoppscotch Desktop** (via GitHub releases API)
  - **Portable VS Code** (via Microsoft stable release API)
  - **OmniRoute, Claude Code CLI, Hoppscotch CLI, & Skills CLI** (via npm registry `@latest`)
  - **Open Agent Skills Repositories** (via Git shallow fetch/pull for `claude-video`, `last30days-skill`, `humanizer`, `ponytail`, and `skills`)
- **🤖 Built-in Open Agent Skills Suite**: Pre-installed and automatically active across Claude Code sessions:
  - **`ponytail` suite**: Enforces minimalist, clean, YAGNI-driven senior engineering.
  - **`humanizer`**: Strips AI tells, stock filler, and buzzwords to deliver natural developer prose.
  - **`last30days`**: Real-time crawling of Reddit, GitHub, X, and arXiv for up-to-date solutions.
  - **`watch`**: Processes videos, demo screencasts, and audio transcripts via local FFmpeg & `yt-dlp`.
  - **`find-skills` & `skills` CLI**: Connects to the 1,500+ verified agent skills directory (`skills.sh`).
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
│   ├── git/                   # Portable Git (MinGit)
│   │   └── cmd/git.exe        # Git CLI executable
│   └── skills-sources/        # Cloned source repositories for auto-updates
│       ├── claude-video/      # watch skill source
│       ├── last30days-skill/  # last30days research skill source
│       ├── humanizer/         # humanizer natural writing skill source
│       ├── ponytail/          # ponytail minimal dev suite source
│       └── skills/            # open agent skills CLI source
│
├── hoppscotch/                # Portable Hoppscotch Desktop App
│   └── Hoppscotch.exe         # Hoppscotch Desktop executable
│
├── data/                      # Sandboxed application data & configuration
│   ├── .env.example           # Storage encryption key & host template
│   ├── storage.sqlite         # SQLite database with combos, providers, and settings
│   ├── claude/                # Claude Code configuration & active skills
│   │   └── skills/            # Active sandboxed skills directory
│   ├── launch-claude-omniroute.cmd
│   ├── start-omniroute.cmd
│   └── start-hoppscotch.cmd   # Standalone Hoppscotch Desktop launcher
│
├── vscode/                    # Portable VS Code installation directory
│
├── workspace/                 # Your project working directory
│   ├── CLAUDE.md              # Project agent guidelines
│   └── .vscode/
│       ├── settings.json      # Pre-configured environment variables & tool paths
│       └── tasks.json         # Automated startup tasks
│
└── home/                      # Sandboxed USERPROFILE & HOME directory
```

---

## 🤖 Built-in Open Agent Skills & Ecosystem

The environment comes pre-loaded with over **220+ Open Agent Skills** across 5 core suites and official vendor categories:

| Skill Suite | Description | Commands & Examples |
|---|---|---|
| **Ponytail Suite** | Minimalist, clean senior developer guidelines. Enforces YAGNI, standard library first, and zero dependency bloat. | `/ponytail`, `/ponytail-review`, `/ponytail-audit`, `/ponytail-debt`, `/ponytail-gain`, `/ponytail-help` |
| **Humanizer** | Removes AI writing tells, staged openers, forced triads, and buzzwords to deliver authentic human copy. | `/humanizer` |
| **Last30Days** | Crawls recent 30-day discussions on Reddit, GitHub, X, and arXiv for up-to-date solutions and breaking changes. | `/last30days <topic>` |
| **Claude Video** | Video/audio inspection, frame extraction, and subtitle transcription. | `/watch <url-or-path> [question]` |
| **Skills Ecosystem CLI** | Discovers and installs skills from the 1,500+ open agent skills ecosystem at [skills.sh](https://skills.sh/). | `/find-skills <topic>`, `skills find`, `skills add <vendor/skill>`, `skills update` |
| **Vercel Agent Skills** | Official React/Next.js optimizations, composition patterns, view transitions, and deployment workflows. | `react-best-practices`, `composition-patterns`, `react-native-skills`, `deploy-to-vercel` |
| **Anthropic Skills** | Frontend design, theme factory, canvas design, doc coauthoring, MCP builders, and webapp testing. | `frontend-design`, `theme-factory`, `canvas-design`, `mcp-builder`, `webapp-testing` |
| **System Architecture & Cloud** | Microservices, API design, event sourcing, multi-cloud Terraform, cost optimization, and RAG. | `architecture-patterns`, `api-design-principles`, `rag-implementation`, `terraform-module-library` |

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
