# Fresh-PC entry point: turns a new Windows install into your environment.
# Creates C:\gitprojects, clones dotfiles + toolnest into it, applies everything, then asks about the optional parts.
#
# Repo is private for now, so on a new PC (Windows PowerShell):
#   winget install --id Git.Git --exact; winget install --id GitHub.cli --exact
#   (open a new window)  gh auth login
#   gh repo clone Anuja-jayasinghe/dotfiles C:\gitprojects\dotfiles
#   C:\gitprojects\dotfiles\windows\bootstrap.ps1
# Once the repo is public this works as a single line:
#   irm https://raw.githubusercontent.com/Anuja-jayasinghe/dotfiles/main/windows/bootstrap.ps1 | iex
$ErrorActionPreference = 'Stop'
$projects = if ($env:GITPROJECTS) { $env:GITPROJECTS } else { 'C:\gitprojects' }
function Refresh-Path { $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User') }
function Ask($q) { (Read-Host "$q [y/N]") -match '^(y|yes)$' }

Write-Host "== 1/5 Git and the projects folder"
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    winget install --id Git.Git --exact --source winget --silent --accept-package-agreements --accept-source-agreements
    Refresh-Path
}
New-Item -ItemType Directory -Force $projects | Out-Null
[Environment]::SetEnvironmentVariable('GITPROJECTS', $projects, 'User')
$env:GITPROJECTS = $projects

Write-Host "== 2/5 Clone dotfiles and toolnest into $projects"
foreach ($r in 'dotfiles', 'toolnest') {
    if (-not (Test-Path "$projects\$r\.git")) { git clone "https://github.com/Anuja-jayasinghe/$r.git" "$projects\$r" }
    else { "$r already cloned" }
}

Write-Host "== 3/5 Core tools and configs"
& "$projects\dotfiles\windows\install.ps1"
Refresh-Path

Write-Host "== 4/5 Optional parts"
if (Ask 'Install the everyday apps (Chrome, Spotify, VLC, Steam, ...)?') { & "$projects\dotfiles\windows\install.ps1" -Apps }
if (Ask 'Apply Windows preferences (dark mode, file extensions, hidden files)?') {
    pwsh -NoProfile -File "$projects\toolnest\windows_preferences\windows_preferences.ps1"
}
if (Ask 'Set the wallpaper?') { pwsh -NoProfile -File "$projects\toolnest\set_wallpaper\set_wallpaper.ps1" }

Write-Host "== 5/5 GitHub login"
gh auth status *> $null
if ($LASTEXITCODE -ne 0) { gh auth login }

Write-Host "`nChecking the result:"
& "$projects\dotfiles\windows\doctor.ps1"
"Open a new Windows Terminal tab to see the new prompt. WSL is separate: `just wsl-setup` in $projects\toolnest."
