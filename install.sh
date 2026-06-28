#!/usr/bin/env bash
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ">>> [1/4] installing apt packages"
"$ROOT/install/packages.sh"

echo ">>> [2/4] installing extras (tools missing from apt)"
"$ROOT/install/extras.sh"

echo ">>> [3/4] linking dotfiles into \$HOME"
"$ROOT/link"

echo ">>> [4/4] generating missing ssh keys"
"$ROOT/install/ssh-keys.sh"

echo ">>> all done. Restart your shell (or: source ~/.bashrc) to pick up changes."
