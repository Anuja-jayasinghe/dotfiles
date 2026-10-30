# T3 Code

Installed with `winget install T3Tools.T3Code` (listed in `packages/windows.txt`).

Tracked here, copied by `windows/install.ps1` only if the file exists in this folder:

- `keybindings.json` → `~/.t3/userdata/keybindings.json`
- `themes/*.json` → `~/.t3/userdata/themes/`

T3 Code creates its own defaults on first launch, so to start tracking: launch it once, edit keybindings or export a theme, then copy the file from `~/.t3/userdata/` into this folder and commit it. Never commit provider logins or tokens; sign in to Claude/Codex on each machine.

To run agents in WSL, choose the distro in T3 Code under Settings → Connections and install the provider CLIs inside that distro.
