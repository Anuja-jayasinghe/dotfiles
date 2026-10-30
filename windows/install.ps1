# Applies the Windows terminal setup. Safe to re-run. Works from Windows PowerShell 5.1 or pwsh.
# Usage: .\windows\install.ps1   (use -SkipPackages to skip winget)
param([switch]$SkipPackages)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent

if (-not $SkipPackages) {
    $ids = 'Microsoft.PowerShell','twpayne.chezmoi','ajeetdsouza.zoxide','JanDeDobbeleer.OhMyPosh',
           'junegunn.fzf','BurntSushi.ripgrep.MSVC','sharkdp.bat','JesseDuffield.lazygit','Git.Git','GitHub.cli'
    foreach ($id in $ids) {
        winget install --id $id --exact --source winget --silent --accept-package-agreements --accept-source-agreements
    }
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
"Done. Open a new Windows Terminal tab."
