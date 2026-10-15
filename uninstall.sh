#!/usr/bin/env bash
set -euo pipefail

if [[ $# -gt 1 || ( $# -eq 1 && "$1" != '--purge' ) ]]; then
    printf 'Usage: bash uninstall.sh [--purge]\n' >&2
    exit 2
fi
bashrc="$HOME/.bashrc"
if [[ -f "$bashrc" ]]; then
    sed -i '/^# >>> saveenv >>>$/,/^# <<< saveenv <<<$/{d;}' "$bashrc"
fi
rm -f -- "$HOME/.local/share/saveenv/saveenv.bash"
if [[ "${1:-}" == '--purge' ]]; then
    rm -rf -- "$HOME/.config/saveenv"
    printf 'Removed SaveEnv and all registered shortcuts.\n'
else
    printf 'Removed SaveEnv; saved shortcuts kept in ~/.config/saveenv/entries.\n'
fi
printf 'Open a fresh terminal to finish unloading SaveEnv.\n'
