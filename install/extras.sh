#!/usr/bin/env bash
# Installs tools that may be missing from older apt repos (fetches upstream binaries).
set -euo pipefail

SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

arch=$(dpkg --print-architecture 2>/dev/null || uname -m)

if ! command -v zoxide >/dev/null 2>&1; then
    echo ">> installing zoxide"
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh \
        | sh -s -- --bin-dir "$LOCAL_BIN"
fi

if ! command -v eza >/dev/null 2>&1; then
    echo ">> installing eza (gierens repo)"
    $SUDO mkdir -p /etc/apt/keyrings
    curl -sSfL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
        | $SUDO gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
        | $SUDO tee /etc/apt/sources.list.d/gierens.list >/dev/null
    $SUDO apt-get update -y && $SUDO apt-get install -y eza
fi

if ! command -v delta >/dev/null 2>&1; then
    echo ">> installing git-delta"
    ver=$(curl -sSfL https://api.github.com/repos/dandavison/delta/releases/latest \
          | grep -oP '"tag_name":\s*"\K[^"]+')
    tmp=$(mktemp --suffix=.deb)
    curl -sSfL "https://github.com/dandavison/delta/releases/download/${ver}/git-delta_${ver}_${arch}.deb" -o "$tmp"
    $SUDO dpkg -i "$tmp"; rm -f "$tmp"
fi

if ! command -v yq >/dev/null 2>&1; then
    echo ">> installing yq (mikefarah)"
    case "$arch" in
        arm64|aarch64) y=yq_linux_arm64 ;;
        *)             y=yq_linux_amd64 ;;
    esac
    curl -sSfL "https://github.com/mikefarah/yq/releases/latest/download/${y}" -o "$LOCAL_BIN/yq"
    chmod +x "$LOCAL_BIN/yq"
fi

echo ">> extras done. Make sure ~/.local/bin is on PATH (the dotfiles init.sh handles it)."
