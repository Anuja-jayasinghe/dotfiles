# Cross-platform dotfiles

Personal configuration for:

- Personal Windows computer — primary machine
- WSL — Linux-like development environment
- Work macOS computer
- Future Linux machines, where practical

## Quick start

**Windows, fresh install** — everything lives under `C:\gitprojects` (all git projects are cloned there). In Windows PowerShell:

```powershell
winget install --id Git.Git --exact; winget install --id GitHub.cli --exact
# open a new PowerShell window, then:
gh auth login
gh repo clone Anuja-jayasinghe/dotfiles C:\gitprojects\dotfiles
C:\gitprojects\dotfiles\windows\bootstrap.ps1
```

`bootstrap.ps1` clones dotfiles and [toolnest](https://github.com/Anuja-jayasinghe/toolnest) (all utility scripts, run with `just`), installs the core tools, applies every config, asks about the optional apps / preferences / wallpaper, then runs the doctor. (Once the repo is public, the first four lines become one `irm ... | iex`; see the script header.)

**Windows, already set up** — `windows\install.ps1` (`-Apps` for optional apps, `-SkipPackages` to skip winget) re-applies configs, `windows\doctor.ps1` shows what is applied or missing.

`chezmoi` is wired to the repo (`.chezmoiroot` → `home/`, `~/.config/chezmoi/chezmoi.toml` sets `sourceDir`). After editing files in the repo, `chezmoi diff` then `chezmoi apply` re-runs the installer when the files it depends on change. Details in [windows/README.md](windows/README.md).

**macOS / Linux** — `packages/Brewfile` + `macos/install.sh` (untested on a Mac; read it first).

## Layout and sharing

One folder per tool, so any single config can be shared as a link to its folder or file (for example `terminal/settings.json`) without the rest of the repo. Each folder has a short README on how to use it.

`terminal/` `powershell/` `vscode/` `lazygit/` `git/` `ssh/` `agents/` — configs. `packages/` — what gets installed. `windows/` `macos/` — setup scripts (bootstrap, install, doctor). `assets/` — wallpapers. `home/` — chezmoi hooks. Utility scripts live in the toolnest repo, not here.

## Status

- Done: Windows terminal, PowerShell profile, Git, lazygit, VS Code, agent instructions + skills, SSH aliases, package lists, doctor, chezmoi hooks.
- Phase 4: T3 Code installed (`t3code/`), wallpaper collection in `assets/wallpapers/`. The preferences, wallpaper and WSL scripts moved to toolnest (`just windows-preferences`, `just wallpaper`, `just wsl-setup`).
- Not yet: tracked T3 keybindings/themes, a wallpaper gallery, tmux, Mac-side verification.

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
