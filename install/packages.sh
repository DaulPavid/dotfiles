#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
    echo "This installer targets Debian/Ubuntu (apt). Aborting." >&2
    exit 1
fi

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

. /etc/os-release 2>/dev/null || true
echo ">> Detected: ${PRETTY_NAME:-unknown}"

# bat installs as 'batcat', fd-find as 'fdfind' -- the dotfiles alias these.
CORE=(git tmux ripgrep jq fzf fd-find bat tree curl ca-certificates)

# present in newer releases but may be missing on older ones; installed one by
# one so a single miss doesn't abort. install/extras.sh covers the rest.
OPTIONAL=(eza zoxide git-delta)

echo ">> apt-get update"
$SUDO apt-get update -y

echo ">> installing core packages"
$SUDO apt-get install -y "${CORE[@]}"

echo ">> installing optional packages (skipping any not in your apt repos)"
for pkg in "${OPTIONAL[@]}"; do
    if apt-cache show "$pkg" >/dev/null 2>&1; then
        $SUDO apt-get install -y "$pkg" || echo "   ! failed: $pkg (skipped)"
    else
        echo "   - not in apt on this release: $pkg  (run install/extras.sh)"
    fi
done

echo ">> done. For tools missing from apt, run: install/extras.sh"
