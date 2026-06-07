#!/usr/bin/env bash
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ">>> [1/3] installing apt packages"
"$ROOT/install/packages.sh"

echo ">>> [2/3] installing extras (tools missing from apt)"
"$ROOT/install/extras.sh"

echo ">>> [3/3] linking dotfiles into \$HOME"
"$ROOT/link"

echo ">>> all done. Restart your shell (or: source ~/.bashrc) to pick up changes."
