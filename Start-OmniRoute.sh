#!/usr/bin/env bash
# ==============================================================================
#           PORTABLE AI DEVELOPER DRIVE (OMNIROUTE + CLAUDE CODE)
#                    (macOS & Linux 1-Click Launcher)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
USB_ROOT="$SCRIPT_DIR"

BIN_DIR="$USB_ROOT/bin"
PYTHON_DIR="$USB_ROOT/python"
TOOLS_DIR="$USB_ROOT/tools"
PORTABLE_GIT_DIR="$TOOLS_DIR/git"
HOPPSCOTCH_DIR="$USB_ROOT/hoppscotch"
VSCODE_DIR="$USB_ROOT/vscode"
WORKSPACE_DIR="$USB_ROOT/workspace"
DATA_DIR="$USB_ROOT/data"
HOME_DIR="$USB_ROOT/home"
CLAUDE_DIR="$DATA_DIR/claude"
TEMP_DIR="$DATA_DIR/temp"

# Strict portable sandbox environment redirection
export TEMP="$TEMP_DIR"
export TMP="$TEMP_DIR"
export TMPDIR="$TEMP_DIR"
export USERPROFILE="$HOME_DIR"
export HOME="$HOME_DIR"
export XDG_CONFIG_HOME="$HOME_DIR/.config"
export XDG_DATA_HOME="$HOME_DIR/.local/share"
export XDG_CACHE_HOME="$DATA_DIR/cache"
export npm_config_cache="$DATA_DIR/npm-cache"
export npm_config_prefix="$BIN_DIR"
export npm_config_userconfig="$HOME_DIR/.npmrc"
export PIP_CACHE_DIR="$DATA_DIR/pip-cache"
export PYTHONNOUSERSITE="1"
export PYTHONPYCACHEPREFIX="$DATA_DIR/pycache"
export GIT_CONFIG_NOSYSTEM="1"
export GIT_CONFIG_GLOBAL="$HOME_DIR/.gitconfig"
export DISABLE_AUTO_UPDATER="1"
export CLAUDE_AUTO_UPDATER="disabled"
export CLAUDE_CODE_DISABLE_UPDATE_CHECK="1"
export OMNIROUTE_DATA_DIR="$DATA_DIR"
export OMNIROUTE_SERVER_HOST="127.0.0.1"
export CLAUDE_CONFIG_DIR="$CLAUDE_DIR"

# Clear any direct Anthropic API keys so Claude Code routes through OmniRoute
export ANTHROPIC_API_KEY=""
export ANTHROPIC_AUTH_TOKEN=""
export ANTHROPIC_BASE_URL=""
export ANTHROPIC_MODEL=""

export PATH="$BIN_DIR:$BIN_DIR/bin:$PYTHON_DIR/bin:$PORTABLE_GIT_DIR/bin:$PATH"

CLR_RESET="\033[0m"
CLR_GREEN="\033[0;32m"
CLR_CYAN="\033[0;36m"
CLR_YELLOW="\033[1;33m"
CLR_RED="\033[0;31m"

clear 2>/dev/null || true
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo -e "${CLR_CYAN}              OMNIROUTE PORTABLE AI DEVELOPER DRIVE${CLR_RESET}"
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo -e "  Root Directory : $USB_ROOT"
echo -e "  Status         : Validating prerequisites and environment..."
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo ""

# ------------------------------------------------------------------------------
# 1. RUN BOOTSTRAP ENGINE (DYNAMIC AUTO-UPDATE & FULL SYSTEM VERIFICATION)
# ------------------------------------------------------------------------------
if [[ -f "$USB_ROOT/bootstrap.sh" ]]; then
    chmod +x "$USB_ROOT/bootstrap.sh"
    if ! bash "$USB_ROOT/bootstrap.sh" --root-path "$USB_ROOT"; then
        echo ""
        echo -e "${CLR_RED}==============================================================================${CLR_RESET}"
        echo -e "${CLR_RED} [ERROR] Component update or system integrity verification failed.${CLR_RESET}"
        echo -e "${CLR_RED} No background services or applications have been started.${CLR_RESET}"
        echo -e "${CLR_RED} Please inspect the log messages above and try again.${CLR_RESET}"
        echo -e "${CLR_RED}==============================================================================${CLR_RESET}"
        echo ""
        exit 1
    fi
else
    echo -e "  ${CLR_YELLOW}[WARNING] bootstrap.sh not found. Proceeding with existing binaries...${CLR_RESET}"
fi

# ------------------------------------------------------------------------------
# 2. START OMNIROUTE SERVER (BACKGROUND) - ONLY AFTER VERIFICATION PASSES
# ------------------------------------------------------------------------------
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo -e "  Starting OmniRoute Proxy Server..."
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"

OMNI_PID=""
cleanup() {
    echo ""
    echo -e "  Stopping OmniRoute background server..."
    if [[ -n "$OMNI_PID" ]]; then
        kill "$OMNI_PID" 2>/dev/null || true
    fi
    pkill -f "omniroute" 2>/dev/null || true
    echo -e "  ${CLR_GREEN}Shutdown complete.${CLR_RESET}"
}
trap cleanup EXIT INT TERM

if curl -s "http://127.0.0.1:20128/api/monitoring/health" >/dev/null 2>&1; then
    echo -e "  OmniRoute server is already running on http://127.0.0.1:20128"
else
    # Find omniroute launcher
    OMNI_RUN="$BIN_DIR/omniroute"
    if [[ ! -x "$OMNI_RUN" ]]; then
        OMNI_RUN="omniroute"
    fi
    "$OMNI_RUN" > "$DATA_DIR/omniroute.log" 2>&1 &
    OMNI_PID=$!

    echo -e "  Waiting for server to become healthy..."
    OMNIREADY=0
    for i in {1..20}; do
        if curl -s "http://127.0.0.1:20128/api/monitoring/health" >/dev/null 2>&1; then
            OMNIREADY=1
            break
        fi
        sleep 1
    done

    if [[ $OMNIREADY -ne 1 ]]; then
        echo ""
        echo -e "${CLR_RED}==============================================================================${CLR_RESET}"
        echo -e "${CLR_RED} [ERROR] OmniRoute proxy server failed to respond on http://127.0.0.1:20128${CLR_RESET}"
        echo -e "${CLR_RED} VS Code startup aborted. Check log file: $DATA_DIR/omniroute.log${CLR_RESET}"
        echo -e "${CLR_RED}==============================================================================${CLR_RESET}"
        echo ""
        exit 1
    fi
fi
echo -e "  OmniRoute Status : ${CLR_GREEN}ACTIVE & READY${CLR_RESET}"

# ------------------------------------------------------------------------------
# 3. LAUNCH PORTABLE VS CODE - ONLY AFTER SERVER IS HEALTHY
# ------------------------------------------------------------------------------
echo ""
echo -e "  Starting Portable VS Code..."
CODE_LAUNCHER="$VSCODE_DIR/bin/code"
if [[ ! -x "$CODE_LAUNCHER" ]]; then
    CODE_LAUNCHER="$(command -v code 2>/dev/null || true)"
fi

if [[ -n "$CODE_LAUNCHER" ]]; then
    "$CODE_LAUNCHER" \
        --user-data-dir "$DATA_DIR/vscode-user-data" \
        --extensions-dir "$DATA_DIR/vscode-extensions" \
        "$WORKSPACE_DIR" >/dev/null 2>&1 &
    echo -e "  VS Code Status    : ${CLR_GREEN}STARTED${CLR_RESET}"
else
    echo -e "  ${CLR_YELLOW}VS Code executable not found. You can open $WORKSPACE_DIR in your editor.${CLR_RESET}"
fi

# ------------------------------------------------------------------------------
# 4. READY DASHBOARD & INSTRUCTIONS
# ------------------------------------------------------------------------------
echo ""
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo -e "${CLR_CYAN}                   OMNIROUTE PORTABLE DRIVE IS READY!${CLR_RESET}"
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo ""
echo -e "   * OmniRoute Proxy   : http://127.0.0.1:20128"
echo -e "   * Workspace Folder  : $WORKSPACE_DIR"
echo -e "   * Model Combo       : free-stack (Multi-provider fallback)"
echo -e "   * Hoppscotch App    : $HOPPSCOTCH_DIR"
echo ""
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo -e "${CLR_CYAN}                               HOW TO USE${CLR_RESET}"
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo ""
echo -e "   1. Portable VS Code is now open with your workspace."
echo ""
echo -e "   2. Open the integrated terminal in VS Code:"
echo -e "      Shortcut: Ctrl + \` (backtick) or Cmd + \`"
echo ""
echo -e "   3. Launch Claude Code with free-stack:"
echo ""
echo -e "         ${CLR_CYAN}omniroute launch --model free-stack${CLR_RESET}"
echo ""
echo -e "   4. Test APIs with Hoppscotch CLI or Desktop:"
echo ""
echo -e "         ${CLR_CYAN}hopp --help${CLR_RESET}"
echo ""
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo ""
echo -e "  OmniRoute is running in the background."
echo -e "  Keep this terminal window open while you work."
echo ""
echo -e "  Press [Ctrl+C] to stop OmniRoute and exit..."
wait
