#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
export HOME="$tmp/home"
mkdir -p -- "$HOME"
: > "$HOME/.bashrc"
unset VIRTUAL_ENV CONDA_PREFIX CONDA_DEFAULT_ENV || true

bash "$repo/install.sh"
bash "$repo/install.sh"
[[ "$(grep -Fc '# >>> saveenv >>>' "$HOME/.bashrc")" == 1 ]] || { echo 'install not idempotent'; exit 1; }
# shellcheck disable=SC1090
source "$HOME/.bashrc"

dir="$tmp/project with spaces"
mkdir -p -- "$dir/.venv/bin"
cat > "$dir/.venv/bin/activate" <<'ACT'
export SAVEENV_VENV_ACTIVATED=yes
ACT
export VIRTUAL_ENV="$dir/.venv"
cd "$dir"
saveenv rag
[[ "$(type -t rag)" == 'function' ]] || exit 1
[[ "$(saveenv list)" == 'rag' ]] || exit 1
saveenv show rag | grep -Fq 'builtin cd'
cd /tmp
rag
[[ "$PWD" == "$dir" && "$SAVEENV_VENV_ACTIVATED" == yes ]] || { echo 'venv activation failed'; exit 1; }

# A newly opened Bash shell restores registered shortcuts.
bash -c 'source "$HOME/.bashrc"; cd /tmp; rag; [[ "$PWD" == *"project with spaces" && "$SAVEENV_VENV_ACTIVATED" == yes ]]'

if saveenv rag >/dev/null 2>&1; then echo 'duplicate accepted'; exit 1; fi
if saveenv 'invalid-name' >/dev/null 2>&1; then echo 'bad name accepted'; exit 1; fi

# Test Conda support without depending on a real Conda installation.
unset VIRTUAL_ENV
export CONDA_PREFIX="$tmp/conda/envs/agent-env"
mkdir -p -- "$CONDA_PREFIX"
conda() {
    [[ "$1" == activate ]] || return 1
    export SAVEENV_CONDA_ACTIVE="$2"
}
cd "$tmp"
saveenv agent
cd /tmp
agent
[[ "$PWD" == "$tmp" && "$SAVEENV_CONDA_ACTIVE" == "$CONDA_PREFIX" ]] || { echo 'conda activation failed'; exit 1; }

saveenv remove rag
[[ "$(type -t rag || true)" != function ]] || { echo 'remove failed'; exit 1; }
[[ "$(saveenv list)" == 'agent' ]] || exit 1

bash "$repo/uninstall.sh"
[[ ! -e "$HOME/.local/share/saveenv/saveenv.bash" ]] || exit 1
[[ "$(grep -Fc '# >>> saveenv >>>' "$HOME/.bashrc" || true)" == 0 ]] || exit 1
[[ -e "$HOME/.config/saveenv/entries/agent.bash" ]] || exit 1

bash "$repo/install.sh" >/dev/null
bash "$repo/uninstall.sh" --purge
[[ ! -d "$HOME/.config/saveenv" ]] || exit 1
printf 'All SaveEnv tests passed.\n'
