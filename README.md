# Cross-platform dotfiles

Personal configuration for:

- Personal Windows computer — primary machine
- WSL — Linux-like development environment
- Work macOS computer
- Future Linux machines, where practical

## Quick start

**Windows (main machine)** — repo lives in `C:\gitprojects\dotfiles`:

```powershell
git clone https://github.com/Anuja-jayasinghe/dotfiles.git C:\gitprojects\dotfiles
C:\gitprojects\dotfiles\windows\install.ps1          # add -Apps for optional apps, -SkipPackages to skip winget
C:\gitprojects\dotfiles\windows\doctor.ps1           # what is applied / missing
```

`chezmoi` is wired to the repo (`.chezmoiroot` → `home/`, `~/.config/chezmoi/chezmoi.toml` sets `sourceDir`). After editing files in the repo, `chezmoi diff` then `chezmoi apply` re-runs the installer when the files it depends on change. Details in [windows/README.md](windows/README.md).

**macOS / Linux** — `packages/Brewfile` + `macos/install.sh` (untested on a Mac; read it first).

Layout: `windows/` `macos/` `git/` `lazygit/` `vscode/` `ssh/` `agents/` `packages/` `home/` (chezmoi hooks).

## Status

- Done: Windows terminal, PowerShell profile, Git, lazygit, VS Code, agent instructions + skills, SSH aliases, package lists, doctor, chezmoi hooks.
- Not yet: T3 Code, wallpapers/Windows preferences, WSL, tmux, Mac-side verification.

See:

- [Work Mac inventory](docs/WORK-MAC-INVENTORY.md)
- [Initial setup plan](docs/INITIAL-SETUP-PLAN.md)

## Principles

- Review changes with `chezmoi diff` before applying them.
- Keep personal and work machine configuration separate.
- Prefer portable configuration over machine-specific state.
- Never commit private keys, tokens, passwords, login sessions, or application databases.
- Keep installation and preference scripts idempotent and safe to run repeatedly.

## Planned managed areas

- Agent guidance and personal skills under `agents/` (including shared `AGENTS.md` guidance)
- Git and global Git ignore
- Lazygit
- T3 Code settings for the personal Windows machine
- VS Code settings, keybindings, snippets, and extension list
- SSH host aliases
- PowerShell, Zsh, Bash, Windows Terminal, and tmux
- Wallpapers and selected personal preferences
- Per-platform package manifests
