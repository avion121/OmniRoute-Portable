# OmniRoute Portable Developer Environment — Agent Guidelines

This environment is a 100% isolated, portable AI developer workstation with dynamic on-demand skills architecture and progressive disclosure.

## Progressive Disclosure & Dynamic Skills Architecture

**Core Principle**: Never assume skills exist. Inspect project files first, and fetch tools dynamically via `skills find` only when a task demands it.

### 1. Workspace Inspection & Project-First Analysis
- Always inspect the target `workspace/` and analyze project manifests (`package.json`, `tsconfig.json`, `pyproject.toml`, `requirements.txt`, `Cargo.toml`, `go.mod`, etc.) before executing domain tasks.
- Detect exact languages, frameworks, linters, test harnesses, and project conventions directly from source.

### 2. On-Demand Dynamic Skill Discovery & Installation
- The environment ships with a lean core featuring the `find-skills` discovery meta-skill and the portable `skills` CLI.
- When a task requires specialized domain expertise or vendor conventions (e.g., Next.js App Router patterns, Tailwind design systems, Playwright E2E testing, FastAPI best practices):
  1. **Discover**: Search the open agent skills registry using `/find-skills <topic>` or `skills find <query>`.
  2. **Select Top Vendor**: Identify the official, top-installed vendor skill (e.g., `vercel-labs/agent-skills@react-best-practices`).
  3. **Install On-Demand**: Install strictly what is needed:
     ```bash
     skills add <owner/repo@skill> -y
     ```
  4. **Execute & Apply**: Follow the installed skill guidelines for the task.

### 3. Lean & Minimal Footprint
- Never pre-load or bundle speculative skills.
- Zero extra skills installed when the workspace does not require them.
- Prefer standard library, existing dependencies, and clean native platform capabilities over external bloat.
