# Fresh-PC entry point. Run in Windows PowerShell:
#   Set-ExecutionPolicy -Scope Process Bypass -Force
#   irm https://raw.githubusercontent.com/Anuja-jayasinghe/dotfiles/main/windows/bootstrap.ps1 | iex
# (the repo is private: if irm fails, install Git, `gh auth login`, clone manually, then run windows\install.ps1)
$ErrorActionPreference = 'Stop'
$repoDir = 'C:\gitprojects\dotfiles'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    winget install --id Git.Git --exact --source winget --silent --accept-package-agreements --accept-source-agreements
    $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
}
if (-not (Test-Path "$repoDir\.git")) {
    New-Item -ItemType Directory -Force (Split-Path $repoDir) | Out-Null
    git clone https://github.com/Anuja-jayasinghe/dotfiles.git $repoDir
}
& "$repoDir\windows\install.ps1"
"Next: gh auth login, then run windows\doctor.ps1"
