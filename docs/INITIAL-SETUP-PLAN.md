# Initial setup plan

## Target environments

- Personal Windows computer — primary machine
- WSL — Linux-like development environment
- Work macOS computer
- Future Linux machines, where practical

## First-class areas

- Agents: shared `AGENTS.md`, portable skills, and non-secret guidance
- Git: aliases, identities, global ignore, and optional commit signing
- Lazygit: portable preferences and keybindings
- T3 Code: primary personal-machine setup, with curated settings only
- VS Code: settings, keybindings, snippets, and extension list
- SSH: host aliases and key filenames, never private keys
- Shells and terminals: PowerShell, Zsh, Bash, Windows Terminal, and tmux
- Wallpapers: curated gallery, selected wallpaper, and OS-specific apply scripts
- Packages: Windows, macOS, and WSL manifests

## Configuration layers

```text
shared       portable preferences
windows      Windows and PowerShell settings
wsl          Linux environment inside Windows
macos        work-Mac settings
machine      hostname or role-specific choices
secrets      password manager or encrypted storage only
```

## Safety rules

- Review with `chezmoi diff` before applying.
- Scripts must be idempotent.
- Keep work and personal machine identities separate.
- Do not commit private keys, tokens, passwords, browser sessions, databases, logs, or agent history.
- Keep large wallpaper collections outside the main configuration repository.

## Implementation order

1. Establish GitHub repository and chezmoi source state.
2. Capture portable work-Mac Git, Zsh, and VS Code configuration.
3. Add SSH aliases, global Git ignore, and editor conventions.
4. Add agent guidance and validation scripts.
5. Configure T3 Code and personal Windows from the primary machine.
6. Add Windows, WSL, and macOS package manifests.
7. Add wallpapers and carefully selected OS preferences.
8. Test recovery on a fresh WSL environment and a clean machine/user profile.

