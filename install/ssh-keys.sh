#!/usr/bin/env bash
# Generate any IdentityFile keys from the ssh config that don't exist yet.
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
CONFIG="$ROOT/ssh/.ssh/config"

[ -f "$CONFIG" ] && command -v ssh-keygen >/dev/null 2>&1 || exit 0

grep -iE '^[[:space:]]*IdentityFile' "$CONFIG" | awk '{print $2}' | sort -u | while read -r key; do
    key="${key/#\~/$HOME}"
    [ -n "$key" ] && [ ! -f "$key" ] || continue
    mkdir -p "$( dirname "$key" )"
    ssh-keygen -t ed25519 -f "$key" -N "" -C "$(basename "$key")"
    cat "$key.pub"
done
