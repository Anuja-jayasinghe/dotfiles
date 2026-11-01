# PowerShell

PowerShell 7 profile (`profile.ps1`) and Oh My Posh prompt theme (`theme.omp.json`). Needs: zoxide, Oh My Posh, fzf, PSFzf, and a Nerd Font.

To borrow it: copy `profile.ps1` and `theme.omp.json` into the same folder, then add `. 'path\to\profile.ps1'` to your own `$PROFILE`.

## Daily commands

| Command | Does |
|---|---|
| `cd <part of folder>` | jump to the best-matching folder you've been in, from anywhere (zoxide; `z` does the same) |
| `Tab` / `Shift+Tab` | fill in the first match, press again to cycle forward / back; grey inline suggestions come from history, `Right Arrow` accepts |
| `Up` / `Down` | history search by what you've typed |
| `Ctrl+R` / `Ctrl+T` | fzf history / file search |
| `clone user/repo` | clone into your projects folder (`$env:GITPROJECTS`, default `C:\gitprojects`) and cd into it |
