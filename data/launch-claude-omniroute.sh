#!/usr/bin/env bash
# ==============================================================================
#           PORTABLE CLAUDE CODE OMNIROUTE LAUNCHER (macOS & Linux Edition)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
USB_ROOT="$SCRIPT_DIR"

BIN_DIR="$USB_ROOT/bin"
PYTHON_DIR="$USB_ROOT/python"
TOOLS_DIR="$USB_ROOT/tools"
DATA_DIR="$USB_ROOT/data"
HOME_DIR="$USB_ROOT/home"
WORKSPACE_DIR="$USB_ROOT/workspace"
TEMP_DIR="$DATA_DIR/temp"

export PATH="$BIN_DIR:$BIN_DIR/bin:$PYTHON_DIR/bin:$TOOLS_DIR/git/bin:$PATH"

export USERPROFILE="$HOME_DIR"
export HOME="$HOME_DIR"
export XDG_CONFIG_HOME="$HOME_DIR/.config"
export XDG_DATA_HOME="$HOME_DIR/.local/share"
export XDG_CACHE_HOME="$DATA_DIR/cache"
export TEMP="$TEMP_DIR"
export TMP="$TEMP_DIR"
export TMPDIR="$TEMP_DIR"
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

export CLAUDE_CONFIG_DIR="$DATA_DIR/claude"
export OMNIROUTE_DATA_DIR="$DATA_DIR"
export OMNIROUTE_SERVER_HOST="127.0.0.1"

# Use existing OmniRoute Combo
export ANTHROPIC_MODEL="free-stack"

# Do NOT use direct Anthropic credentials
export ANTHROPIC_API_KEY=""
export ANTHROPIC_AUTH_TOKEN=""
export ANTHROPIC_BASE_URL=""

cd "$WORKSPACE_DIR"

echo ""
echo "============================================================"
echo "       CLAUDE CODE -> OMNIROUTE -> FREE-STACK"
echo "============================================================"
echo ""
echo "OmniRoute : http://127.0.0.1:20128"
echo "Combo     : free-stack"
echo ""

OMNI_CMD="$BIN_DIR/omniroute"
if [[ ! -x "$OMNI_CMD" ]]; then
    OMNI_CMD="omniroute"
fi

exec "$OMNI_CMD" launch --model free-stack
