# Cross-platform dotfiles

Personal configuration for:

- Personal Windows computer — primary machine
- WSL — Linux-like development environment
- Work macOS computer
- Future Linux machines, where practical

## Current status

This repository starts from the work Mac. The first pass will capture portable configuration only. Personal Windows and T3 Code configuration will be added later from the personal machine.

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

- Agents and shared `AGENTS.md` guidance
- Git and global Git ignore
- Lazygit
- T3 Code settings for the personal Windows machine
- VS Code settings, keybindings, snippets, and extension list
- SSH host aliases
- PowerShell, Zsh, Bash, Windows Terminal, and tmux
- Wallpapers and selected personal preferences
- Per-platform package manifests
