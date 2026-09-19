# OmniRoute Portable Developer Environment — Agent Guidelines

This environment is a 100% isolated, portable AI developer workstation with built-in Open Agent Skills.

## Core Agent Skills Integration

When developing, reviewing, researching, or writing in this environment, automatically apply the active agent skills:

### 1. Minimal Engineering & Code Simplicity (Ponytail Suite)
- **Automatic Reflex**: Always follow the Ponytail ladder when designing, writing, or refactoring code:
  1. *YAGNI*: Speculative need = skip it.
  2. *Reuse*: Check for existing utilities/patterns in the codebase before adding new code.
  3. *Standard Library*: Prefer language standard library over external dependencies.
  4. *Native Platform*: Use HTML/CSS/browser/OS capabilities before library bloat.
  5. *Existing Deps*: Use already-installed libraries rather than pulling new ones.
  6. *Minimal Footprint*: Write the simplest, shortest, most robust code that works.
- **Commands**: `/ponytail` (lite/full/ultra), `/ponytail-review`, `/ponytail-audit`, `/ponytail-debt`, `/ponytail-gain`, `/ponytail-help`.

### 2. Natural Human Prose & Anti-AI-Tells (Humanizer)
- **Automatic Reflex**: When writing documentation, READMEs, commit messages, UI copy, or user explanations:
  - Remove AI boilerplate, staged openers ("In today's fast-paced world..."), not-X-but-Y contrasts, forced triads, and buzzword inflation ("delve", "robust", "testament").
  - Match real human developer voice: concise, factual, direct, and conversational.
- **Commands**: `/humanizer` (rewrite text or file in-place to remove AI writing tells).

### 3. Real-Time Research & Community Insight (Last30Days)
- **Automatic Reflex**: When researching new libraries, breaking changes, framework updates, or modern best practices:
  - Query recent discussions across Reddit, GitHub, X, Hacker News, and arXiv for verified solutions from the past 30 days.
- **Commands**: `/last30days <query>` (gather fresh community discussions and consensus).

### 4. Video & Media Analysis (Claude Video)
- **Automatic Reflex**: When working with screen recordings, bug repro videos, product demos, or audio:
  - Extract frames, inspect visual state, and transcribe audio using the local portable media toolchain (`yt-dlp` + `ffmpeg`).
- **Commands**: `/watch <url-or-path> [question]`.

### 5. Open Agent Skills Discovery & Management (Skills CLI)
- **Automatic Reflex**: When users seek specialized domain capabilities (e.g. Next.js optimizations, Figma extraction, Playwright QA, E2E testing):
  - Discover and install from the 1,500+ verified skills directory (`skills.sh`) using the pre-installed `skills` CLI.
- **Commands**: `/find-skills <topic>`, `skills find <query>`, `skills add <vendor/skill>`, `skills update`.
