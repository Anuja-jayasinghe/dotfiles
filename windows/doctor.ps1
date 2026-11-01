# Shows what is installed and applied, and what is missing. Read-only.
$root = Split-Path $PSScriptRoot -Parent
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$bad = 0
function Check($label, [bool]$ok, $hint = '') {
    if ($ok) { Write-Host ("  [ok]   " + $label) -ForegroundColor Green }
    else { Write-Host ("  [MISS] " + $label + $(if ($hint) { "  -> $hint" })) -ForegroundColor Red; $script:bad++ }
}

Write-Host "Commands"
foreach ($c in 'git','gh','pwsh','code','chezmoi','zoxide','oh-my-posh','fzf','rg','bat','lazygit','node','just') {
    Check $c ([bool](Get-Command $c -ErrorAction SilentlyContinue)) 'windows\install.ps1'
}

Write-Host "Projects folder"
Check 'GITPROJECTS points at the parent of this repo' ([Environment]::GetEnvironmentVariable('GITPROJECTS','User') -eq (Split-Path $root -Parent)) 'windows\install.ps1'
Check 'toolnest cloned next to dotfiles' (Test-Path "$(Split-Path $root -Parent)\toolnest\justfile") 'git clone https://github.com/Anuja-jayasinghe/toolnest.git'

Check 'T3 Code' ([bool](Get-ChildItem "$env:LOCALAPPDATA\Programs" -Directory -ErrorAction SilentlyContinue | Where-Object Name -match 'T3')) 'winget install T3Tools.T3Code'
$null = wsl -l -q 2>&1; Check 'WSL installed (optional)' ($LASTEXITCODE -eq 0) 'just wsl-setup -Install (in toolnest, elevated)'

Write-Host "Config"
$docs = [Environment]::GetFolderPath('MyDocuments')
Check 'PowerShell 7 profile'   ((Test-Path "$docs\PowerShell\Microsoft.PowerShell_profile.ps1") -and (Get-Content "$docs\PowerShell\Microsoft.PowerShell_profile.ps1" -Raw) -match 'dotfiles') 'windows\install.ps1'
Check 'Windows Terminal settings match repo' ((Get-FileHash "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -ErrorAction SilentlyContinue).Hash -eq (Get-FileHash "$root\terminal\settings.json").Hash) 'windows\install.ps1 (or the repo copy is newer than the applied one)'
$lgDir = (lazygit --print-config-dir 2>$null)
Check 'lazygit config matches repo' ($lgDir -and ((Get-FileHash "$($lgDir.Trim())\config.yml" -ErrorAction SilentlyContinue).Hash -eq (Get-FileHash "$root\lazygit\config.yml").Hash)) 'windows\install.ps1'
Check 'VS Code settings match repo' ((Get-FileHash "$env:APPDATA\Code\User\settings.json" -ErrorAction SilentlyContinue).Hash -eq (Get-FileHash "$root\vscode\settings.json").Hash)
Check 'Nerd Font'              ([bool](Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Windows\Fonts" -Filter 'CaskaydiaCove*' -ErrorAction SilentlyContinue)) 'oh-my-posh font install CascadiaCode'
Check 'Git includes shared config' ([bool](git config --global --get-all include.path | Select-String -SimpleMatch 'dotfiles/git/gitconfig'))
Check 'Git credential helper is not "store"' ((git config --get credential.helper) -ne 'store')
Check 'Claude CLAUDE.md -> AGENTS.md' ((Test-Path "$HOME\.claude\CLAUDE.md") -and (Get-Content "$HOME\.claude\CLAUDE.md" -Raw) -match 'AGENTS.md')
Check 'Codex AGENTS.md matches repo' ((Get-FileHash "$HOME\.codex\AGENTS.md" -ErrorAction SilentlyContinue).Hash -eq (Get-FileHash "$root\agents\AGENTS.md").Hash) 'windows\install.ps1'
Check '~/.ssh/config'          (Test-Path "$HOME\.ssh\config")

Write-Host "Accounts and keys (manual)"
gh auth status *> $null; Check 'gh logged in' ($LASTEXITCODE -eq 0) 'gh auth login'
Check 'SSH key id_ed25519'     (Test-Path "$HOME\.ssh\id_ed25519") 'ssh-keygen -t ed25519 (optional; HTTPS + credential manager works without it)'

Write-Host "Repo"
$st = git -C $root status -sb
Check 'dotfiles repo clean and pushed' (($st | Measure-Object).Count -eq 1 -and $st -notmatch 'ahead|behind') ($st -join ' | ')

if ($bad) { Write-Host "`n$bad item(s) need attention." -ForegroundColor Yellow } else { Write-Host "`nAll good." -ForegroundColor Green }
