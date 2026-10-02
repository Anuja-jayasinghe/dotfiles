# Work Mac inventory

Collected on 2026-10-02. This is an inventory of candidates, not an instruction to copy everything into the repository.

## Current machine

- Operating system: macOS
- Git: installed
- GitHub CLI: installed and authenticated
- Homebrew: installed
- Lazygit: installed
- tmux: installed
- T3 Code CLI: not found
- chezmoi: not installed
- Starship: not installed
- VS Code command-line launcher: not found

## Existing configuration candidates

| Path | Status | Initial decision |
|---|---|---|
| `~/.zshrc` | Exists, 446 bytes | Inspect and selectively manage |
| `~/.gitconfig` | Exists, 192 bytes | Inspect and selectively manage |
| `~/.ssh/config` | Not found | Create only if SSH aliases are needed |
| `~/.config/git/ignore` | Not found | Consider creating a global ignore file |
| `~/.config/lazygit/config.yml` | Not found | Add after Lazygit preferences are chosen |
| `~/Library/Application Support/Code/User/settings.json` | Exists, 5,678 bytes | Inspect and selectively manage |
| `~/Library/Application Support/Code/User/keybindings.json` | Not found | Add only if customized |
| T3 Code state/configuration | Not found in checked locations | Defer to personal Windows machine |

## Safe work-Mac tasks for today

1. Inspect `.zshrc`, `.gitconfig`, and VS Code settings for portable preferences.
2. Remove or template work-specific values before committing anything.
3. Add a portable Git configuration and global ignore file.
4. Add a minimal Zsh configuration only after reviewing the existing one.
5. Add VS Code settings, keybindings, snippets, and extension recommendations where useful.
6. Add an SSH configuration template if work-server or GitHub aliases are needed.
7. Add a Homebrew package manifest containing only intentionally maintained tools.
8. Add macOS preference scripts only for harmless, user-level settings.
9. Add agent guidance that is general enough to use on both work and personal machines.
10. Add validation and documentation before applying configuration automatically.

## Defer until the personal Windows machine

- T3 Code as the primary personal setup
- Personal wallpapers and wallpaper rotation
- Personal applications and package manifest
- Personal SSH keys and provider authentication
- Windows preferences, PowerShell profile, and Windows Terminal
- WSL bootstrap and Linux packages
- Personal-only agent providers, prompts, and skills

## Do not copy blindly

- Work credentials or company-specific secrets
- Complete application state directories
- Browser profiles, cookies, and login sessions
- T3 databases, logs, attachments, or provider sessions
- Large personal data directories
- macOS settings that require administrator access or conflict with company management

