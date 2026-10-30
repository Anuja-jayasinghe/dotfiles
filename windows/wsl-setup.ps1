# WSL setup. Needs an elevated PowerShell for the first step and a reboot afterwards. Not run automatically.
#   1) elevated:  .\windows\wsl-setup.ps1 -Install      (installs WSL + Ubuntu, then reboot and finish the Ubuntu user prompt)
#   2) normal:    .\windows\wsl-setup.ps1               (configures the distro)
param([switch]$Install, [string]$Distro = 'Ubuntu')
if ($Install) {
    wsl --install -d $Distro
    "Reboot, open Ubuntu once to create your Linux user, then re-run this script without -Install."
    return
}
$win = Split-Path $PSScriptRoot -Parent
$root = '/mnt/' + $win.Substring(0,1).ToLower() + ($win.Substring(2) -replace '\\', '/')
$script = @"
set -e
sudo apt-get update -y
sudo apt-get install -y git curl zsh ripgrep fzf bat zoxide tmux
git config --global credential.helper '/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe'
git config --global user.name '$(git config --global user.name)'
git config --global user.email '$(git config --global user.email)'
git config --global --get-all include.path | grep -q dotfiles/git/gitconfig || git config --global --add include.path '$root/git/gitconfig'
mkdir -p ~/.claude && [ -e ~/.claude/CLAUDE.md ] || echo '@$root/agents/AGENTS.md' > ~/.claude/CLAUDE.md
echo wsl configured
"@
wsl -d $Distro -- bash -lc $script.Replace("`r", '')
