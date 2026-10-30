# Shared PowerShell 7 profile. Loaded from $PROFILE (see windows/install.ps1).

# --- Line editing: predictions, history search, Tab menu ---
if (Get-Module -ListAvailable PSReadLine) {
    Import-Module PSReadLine
    # Windows PowerShell 5.1 ships an old PSReadLine without predictions; ignore that there.
    try { Set-PSReadLineOption -PredictionSource HistoryAndPlugin -PredictionViewStyle InlineView -ErrorAction Stop } catch {}
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd -EditMode Windows
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# --- Prompt ---
$ompTheme = 'C:\gitprojects\dotfiles\windows\powershell\theme.omp.json'
if ((Get-Command oh-my-posh -ErrorAction SilentlyContinue) -and (Test-Path $ompTheme)) {
    oh-my-posh init pwsh --config $ompTheme | Invoke-Expression
}

# --- Fast navigation: z <partial name> jumps to frequent folders ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# --- fzf: Ctrl+R history, Ctrl+T files ---
if ((Get-Command fzf -ErrorAction SilentlyContinue) -and (Get-Module -ListAvailable PSFzf)) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# --- Aliases and helpers ---
# Clone into C:\gitprojects: `clone user/repo` or `clone <url>`
function clone($Repo) {
    $url = if ($Repo -match '^(https?://|git@)') { $Repo } else { "https://github.com/$Repo.git" }
    $name = [IO.Path]::GetFileNameWithoutExtension($url.TrimEnd('/'))
    git clone $url "C:\gitprojects\$name"
    if ($?) { Set-Location "C:\gitprojects\$name" }
}
