#!/bin/bash
# macOS / Linux applier. Idempotent. UNTESTED on a Mac: run `chezmoi diff` / read before applying.
# Skips Homebrew bundle with SKIP_PACKAGES=1.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "${SKIP_PACKAGES:-}" ] && command -v brew >/dev/null; then
  brew bundle --file "$root/packages/Brewfile"
fi

# Git: include shared config once; identity and credential helper stay machine-local.
if ! git config --global --get-all include.path | grep -q 'dotfiles/git/gitconfig'; then
  git config --global --add include.path "$root/git/gitconfig"
  git config --global core.excludesfile "$root/git/ignore"
  git config --global "includeIf.gitdir:~/gitprojects/work/.path" "~/.gitconfig-work"
fi

# lazygit (macOS reads ~/Library/Application Support/lazygit; XDG-style works with LG_CONFIG_FILE or ~/.config on Linux)
lg_dir="$HOME/Library/Application Support/lazygit"; [ "$(uname)" = Darwin ] || lg_dir="$HOME/.config/lazygit"
mkdir -p "$lg_dir"; cp "$root/lazygit/config.yml" "$lg_dir/config.yml"

# Agents
mkdir -p "$HOME/.claude/skills"
[ -e "$HOME/.claude/CLAUDE.md" ] || echo "@$root/agents/AGENTS.md" > "$HOME/.claude/CLAUDE.md"
for s in "$root"/agents/skills/*/; do
  n="$(basename "$s")"; [ -e "$HOME/.claude/skills/$n" ] || ln -s "${s%/}" "$HOME/.claude/skills/$n"
done

# SSH aliases (never overwrites)
mkdir -p "$HOME/.ssh"; chmod 700 "$HOME/.ssh"
[ -e "$HOME/.ssh/config" ] || cp "$root/ssh/config" "$HOME/.ssh/config"
echo "done"
