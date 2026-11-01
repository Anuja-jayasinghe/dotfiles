# Applies the Windows terminal setup. Safe to re-run. Works from Windows PowerShell 5.1 or pwsh.
# Usage: .\windows\install.ps1   (use -SkipPackages to skip winget)
param([switch]$SkipPackages, [switch]$Apps)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent

if (-not $SkipPackages) {
    # packages/windows.txt = core tools; -Apps adds packages/windows-apps.txt. Already-installed ids are skipped by winget.
    $lists = @('windows.txt'); if ($Apps) { $lists += 'windows-apps.txt' }
    $ids = $lists | ForEach-Object { Get-Content "$root\packages\$_" } | Where-Object { $_ -and $_ -notmatch '^\s*#' }
    foreach ($id in $ids) {
        winget list --id $id --exact --source winget *> $null
        if ($LASTEXITCODE -ne 0) {
            winget install --id $id --exact --source winget --silent --accept-package-agreements --accept-source-agreements
        }
    }
    $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
    if (-not (Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Windows\Fonts" -Filter 'CaskaydiaCove*' -ErrorAction SilentlyContinue)) {
        oh-my-posh font install CascadiaCode
    }
}

# Profiles for PowerShell 7 and 5.1 just dot-source the one in this repo.
$stub = ". '$root\windows\powershell\profile.ps1'"
$docs = [Environment]::GetFolderPath('MyDocuments')
foreach ($p in "$docs\PowerShell\Microsoft.PowerShell_profile.ps1", "$docs\WindowsPowerShell\Microsoft.PowerShell_profile.ps1") {
    New-Item -ItemType Directory -Force (Split-Path $p) | Out-Null
    Set-Content -Path $p -Value $stub -Encoding utf8
    "profile -> $p"
}

# Windows Terminal settings (previous file is backed up once).
$ts = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if ((Test-Path $ts) -and -not (Test-Path "$ts.bak")) { Copy-Item $ts "$ts.bak" }
Copy-Item "$root\windows\terminal\settings.json" $ts -Force
"terminal -> $ts"

# PowerShell modules (run in pwsh if available).
$mods = 'Install-Module PSFzf -Scope CurrentUser -Force -AcceptLicense -ErrorAction SilentlyContinue'
$pw = Get-Command pwsh -ErrorAction SilentlyContinue
if ($pw) { & $pw.Source -NoProfile -Command $mods } else { powershell -NoProfile -Command $mods }
# Git: include the shared config once (identity + credential helper stay machine-local).
$gc = "$HOME\.gitconfig"
if (-not (git config --global --get-all include.path | Select-String -SimpleMatch 'dotfiles/git/gitconfig')) {
    git config --global --add include.path "$($root -replace '\\','/')/git/gitconfig"
    git config --global core.excludesfile "$($root -replace '\\','/')/git/ignore"
    "git -> $gc"
}

# lazygit
$lgDir = (lazygit --print-config-dir).Trim()   # %LOCALAPPDATA%\lazygit on Windows
New-Item -ItemType Directory -Force $lgDir | Out-Null
Copy-Item "$root\lazygit\config.yml" "$lgDir\config.yml" -Force
"lazygit -> $lgDir"

# VS Code settings (backed up once) and extensions
$vs = "$env:APPDATA\Code\User\settings.json"
if ((Test-Path $vs) -and -not (Test-Path "$vs.bak")) { Copy-Item $vs "$vs.bak" }
New-Item -ItemType Directory -Force (Split-Path $vs) | Out-Null
Copy-Item "$root\vscode\settings.json" $vs -Force
if (Get-Command code -ErrorAction SilentlyContinue) {
    Get-Content "$root\vscode\extensions.txt" | Where-Object { $_ -and $_ -notmatch '^#' } | ForEach-Object { code --install-extension $_ --force | Out-Null }
}
"vscode -> $vs"

# T3 Code: copy tracked keybindings/themes if present in the repo
$t3 = "$HOME\.t3\userdata"
if (Test-Path "$root\t3code\keybindings.json") { New-Item -ItemType Directory -Force $t3 | Out-Null; Copy-Item "$root\t3code\keybindings.json" "$t3\keybindings.json" -Force; "t3 keybindings -> $t3" }
if (Test-Path "$root\t3code\themes") { New-Item -ItemType Directory -Force "$t3\themes" | Out-Null; Copy-Item "$root\t3code\themes\*.json" "$t3\themes" -Force; "t3 themes -> $t3\themes" }

# Agents: Claude Code reads ~/.claude/CLAUDE.md and ~/.claude/skills/. Skills are linked as junctions (no admin needed).
$cl = "$HOME\.claude"
New-Item -ItemType Directory -Force "$cl\skills" | Out-Null
if (-not (Test-Path "$cl\CLAUDE.md")) { Set-Content "$cl\CLAUDE.md" "@$root\agents\AGENTS.md" -Encoding utf8; "agents -> $cl\CLAUDE.md" }
# Skills in agents\skills are stored in the repo but deliberately not linked into ~\.claude\skills.

# Codex reads ~/.codex/AGENTS.md (it has no @-import like Claude), so the shared file is copied; the repo copy is the master.
New-Item -ItemType Directory -Force "$HOME\.codex" | Out-Null
$cx = "$HOME\.codex\AGENTS.md"
if ((Test-Path $cx) -and (Get-FileHash $cx).Hash -ne (Get-FileHash "$root\agents\AGENTS.md").Hash -and -not (Test-Path "$cx.bak")) { Copy-Item $cx "$cx.bak" }
Copy-Item "$root\agents\AGENTS.md" $cx -Force; "agents -> $cx"

# SSH aliases (never overwrites an existing config; no keys are managed here)
New-Item -ItemType Directory -Force "$HOME\.ssh" | Out-Null
if (-not (Test-Path "$HOME\.ssh\config")) { Copy-Item "$root\ssh\config" "$HOME\.ssh\config"; "ssh -> $HOME\.ssh\config" }

"Done. Open a new Windows Terminal tab."
