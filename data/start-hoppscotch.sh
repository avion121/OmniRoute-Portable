#!/usr/bin/env bash
# ==============================================================================
#           PORTABLE HOPPSCOTCH LAUNCHER (macOS & Linux Edition)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
USB_ROOT="$SCRIPT_DIR"

BIN_DIR="$USB_ROOT/bin"
HOPPSCOTCH_DIR="$USB_ROOT/hoppscotch"
DATA_DIR="$USB_ROOT/data"
HOME_DIR="$USB_ROOT/home"
TEMP_DIR="$DATA_DIR/temp"

export USERPROFILE="$HOME_DIR"
export HOME="$HOME_DIR"
export XDG_CONFIG_HOME="$HOME_DIR/.config"
export XDG_DATA_HOME="$HOME_DIR/.local/share"
export XDG_CACHE_HOME="$DATA_DIR/cache"
export TEMP="$TEMP_DIR"
export TMP="$TEMP_DIR"
export TMPDIR="$TEMP_DIR"

mkdir -p "$DATA_DIR/hoppscotch-data" "$TEMP_DIR"

# Check for Hoppscotch Desktop AppImage (Linux) or .app (macOS)
HOPP_DESKTOP="$(find "$HOPPSCOTCH_DIR" -maxdepth 2 \( -name "*.AppImage" -o -name "Hoppscotch.app" -o -name "hoppscotch" \) 2>/dev/null | head -n 1 || true)"

if [[ -n "$HOPP_DESKTOP" && -e "$HOPP_DESKTOP" ]]; then
    if [[ "$HOPP_DESKTOP" == *.app ]]; then
        open "$HOPP_DESKTOP"
    elif [[ -x "$HOPP_DESKTOP" ]]; then
        "$HOPP_DESKTOP" &
    fi
    exit 0
fi

# Fallback to Hoppscotch CLI
HOPP_CLI="$BIN_DIR/hopp"
if [[ -x "$HOPP_CLI" || -f "$BIN_DIR/node_modules/@hoppscotch/cli/bin/hopp.js" ]]; then
    echo "Hoppscotch CLI available:"
    "$HOPP_CLI" --help || true
    exit 0
fi

echo ""
echo "[ERROR] Hoppscotch Desktop or CLI not found."
echo "Please run ./Start-OmniRoute.sh to bootstrap all components."
echo ""
exit 1
