#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${BASH_VERSION:-}" ]]; then
    printf 'SaveEnv requires Bash.\n' >&2
    exit 1
fi

src_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
src="${src_dir}/src/saveenv.bash"
dst="${HOME}/.local/share/saveenv/saveenv.bash"
bashrc="${HOME}/.bashrc"

if [[ ! -f "$src" ]]; then
    printf 'Cannot find: %s\n' "$src" >&2
    exit 1
fi

mkdir -p -- "$(dirname -- "$dst")"
install -m 644 -- "$src" "$dst"
touch -- "$bashrc"

if ! grep -Fqx '# >>> saveenv >>>' "$bashrc"; then
    cat >> "$bashrc" <<'BLOCK'

# >>> saveenv >>>
if [[ -f "$HOME/.local/share/saveenv/saveenv.bash" ]]; then
    source "$HOME/.local/share/saveenv/saveenv.bash"
fi
# <<< saveenv <<<
BLOCK
fi

printf 'SaveEnv installed to: %s\n' "$dst"
printf 'Activate in this terminal: source ~/.bashrc\n'
printf 'Or open a fresh WSL/Bash terminal.\n'
