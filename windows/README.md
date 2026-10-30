# Windows setup

Windows Terminal + PowerShell 7 + zoxide + Oh My Posh + PSReadLine + fzf, with the repo cloned to `C:\gitprojects\dotfiles`.

## Apply

```powershell
git clone https://github.com/Anuja-jayasinghe/dotfiles.git C:\gitprojects\dotfiles
powershell -ExecutionPolicy Bypass -File C:\gitprojects\dotfiles\windows\install.ps1
```

Open a new terminal tab afterwards. The script installs packages with winget, the Cascadia Nerd Font, writes the `$PROFILE` files (they just dot-source `windows/powershell/profile.ps1`), and copies `windows/terminal/settings.json` into Windows Terminal (the old file is kept as `settings.json.bak`).

## Daily commands

| Command | Does |
|---|---|
| `z <part of folder>` | jump to a frequently used folder (zoxide) |
| `Tab` | completion menu; the grey/list suggestions come from history, `Right Arrow` accepts |
| `Ctrl+R` / `Ctrl+T` | fzf history / file search |
| `gp`, `dots` | go to `C:\gitprojects` / the dotfiles repo |
| `clone user/repo` | clone into `C:\gitprojects` and cd into it |
| `g`, `gs`, `gl`, `lg` | git, status, log graph, lazygit |
| `mkcd dir`, `ll`, `..` | make+enter dir, list all, up one |

Editing the profile or theme in the repo takes effect in new shells; commit and push to keep it.
