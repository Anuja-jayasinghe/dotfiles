# Shows what is installed and applied, and what is missing. Read-only.
$root = Split-Path $PSScriptRoot -Parent
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$bad = 0
function Check($label, [bool]$ok, $hint = '') {
    if ($ok) { Write-Host ("  [ok]   " + $label) -ForegroundColor Green }
    else { Write-Host ("  [MISS] " + $label + $(if ($hint) { "  -> $hint" })) -ForegroundColor Red; $script:bad++ }
}

Write-Host "Commands"
foreach ($c in 'git','gh','pwsh','code','chezmoi','zoxide','oh-my-posh','fzf','rg','bat','lazygit','node') {
    Check $c ([bool](Get-Command $c -ErrorAction SilentlyContinue)) 'windows\install.ps1'
}

Write-Host "Config"
$docs = [Environment]::GetFolderPath('MyDocuments')
Check 'PowerShell 7 profile'   ((Test-Path "$docs\PowerShell\Microsoft.PowerShell_profile.ps1") -and (Get-Content "$docs\PowerShell\Microsoft.PowerShell_profile.ps1" -Raw) -match 'dotfiles') 'windows\install.ps1'
Check 'Windows Terminal settings match repo' ((Get-FileHash "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -ErrorAction SilentlyContinue).Hash -eq (Get-FileHash "$root\windows\terminal\settings.json").Hash) 'windows\install.ps1 (or the repo copy is newer than the applied one)'
Check 'lazygit config'         (Test-Path "$env:APPDATA\lazygit\config.yml")
Check 'VS Code settings match repo' ((Get-FileHash "$env:APPDATA\Code\User\settings.json" -ErrorAction SilentlyContinue).Hash -eq (Get-FileHash "$root\vscode\settings.json").Hash)
Check 'Nerd Font'              ([bool](Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Windows\Fonts" -Filter 'CaskaydiaCove*' -ErrorAction SilentlyContinue)) 'oh-my-posh font install CascadiaCode'
Check 'Git includes shared config' ([bool](git config --global --get-all include.path | Select-String -SimpleMatch 'dotfiles/git/gitconfig'))
Check 'Git credential helper is not "store"' ((git config --get credential.helper) -ne 'store')
Check 'Claude CLAUDE.md -> AGENTS.md' ((Test-Path "$HOME\.claude\CLAUDE.md") -and (Get-Content "$HOME\.claude\CLAUDE.md" -Raw) -match 'AGENTS.md')
foreach ($s in Get-ChildItem "$root\agents\skills" -Directory) { Check "skill $($s.Name)" (Test-Path "$HOME\.claude\skills\$($s.Name)") }
Check '~/.ssh/config'          (Test-Path "$HOME\.ssh\config")

Write-Host "Accounts and keys (manual)"
gh auth status *> $null; Check 'gh logged in' ($LASTEXITCODE -eq 0) 'gh auth login'
Check 'SSH key id_ed25519'     (Test-Path "$HOME\.ssh\id_ed25519") 'ssh-keygen -t ed25519 (optional; HTTPS + credential manager works without it)'

Write-Host "Repo"
$st = git -C $root status -sb
Check 'dotfiles repo clean and pushed' (($st | Measure-Object).Count -eq 1 -and $st -notmatch 'ahead|behind') ($st -join ' | ')

if ($bad) { Write-Host "`n$bad item(s) need attention." -ForegroundColor Yellow } else { Write-Host "`nAll good." -ForegroundColor Green }
