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
| `cd <part of folder>` | jump to the best-matching folder you've been in, from anywhere (zoxide; `z` does the same) |
| `Tab` / `Shift+Tab` | fill in the first match, press again to cycle forward / back; grey inline suggestions come from history, `Right Arrow` accepts |
| `Up` / `Down` | history search by what you've typed |
| `Ctrl+R` / `Ctrl+T` | fzf history / file search |
| `clone user/repo` | clone into `C:\gitprojects` and cd into it |

Editing the profile or theme in the repo takes effect in new shells; commit and push to keep it.
