#!/usr/bin/env bash
# ==============================================================================
#           OMNIROUTE PORTABLE DRIVE - 1-CLICK ALL COMPONENT UPDATER
#                    (macOS & Linux Cross-Platform Edition)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
USB_ROOT="$SCRIPT_DIR"

BIN_DIR="$USB_ROOT/bin"
PYTHON_DIR="$USB_ROOT/python"
TOOLS_DIR="$USB_ROOT/tools"
PORTABLE_GIT_DIR="$TOOLS_DIR/git"
DATA_DIR="$USB_ROOT/data"
HOME_DIR="$USB_ROOT/home"
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

export PATH="$BIN_DIR:$BIN_DIR/bin:$PYTHON_DIR/bin:$PORTABLE_GIT_DIR/bin:$PATH"

CLR_RESET="\033[0m"
CLR_GREEN="\033[0;32m"
CLR_CYAN="\033[0;36m"
CLR_YELLOW="\033[1;33m"
CLR_RED="\033[0;31m"

clear 2>/dev/null || true
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo -e "${CLR_CYAN}             OMNIROUTE PORTABLE DRIVE - FULL COMPONENT UPDATE${CLR_RESET}"
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo -e "  Root Directory : $USB_ROOT"
echo -e "  Portability    : 100% Isolated (Zero Host Modification)"
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo ""
echo -e "  This will check and update all components to their latest versions:"
echo -e "    - Portable Node.js LTS"
echo -e "    - Portable Python 3.12, Pip, Setuptools, Wheel"
echo -e "    - Portable Git"
echo -e "    - Portable Hoppscotch Desktop & CLI"
echo -e "    - Portable VS Code"
echo -e "    - OmniRoute, Claude Code CLI, Hoppscotch CLI, Skills CLI (@latest)"
echo ""
echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
echo -e "  Starting update process..."
echo ""

if [[ -f "$USB_ROOT/bootstrap.sh" ]]; then
    chmod +x "$USB_ROOT/bootstrap.sh"
    if bash "$USB_ROOT/bootstrap.sh" --root-path "$USB_ROOT" --force-update; then
        echo ""
        echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
        echo -e "${CLR_GREEN} [SUCCESS] All components and packages are up to date!${CLR_RESET}"
        echo -e "${CLR_GREEN}==============================================================================${CLR_RESET}"
        echo ""
    else
        echo ""
        echo -e "${CLR_RED} [ERROR] Update process encountered an error.${CLR_RESET}"
        echo -e " Please check your internet connection and try again."
        echo ""
        exit 1
    fi
else
    echo -e "${CLR_RED}[ERROR] bootstrap.sh not found in $USB_ROOT${CLR_RESET}"
    exit 1
fi
