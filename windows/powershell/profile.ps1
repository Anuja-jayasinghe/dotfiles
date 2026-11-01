# Shared PowerShell 7 profile. Loaded from $PROFILE (see windows/install.ps1).

# --- Line editing: predictions, history search, Tab menu ---
if (Get-Module -ListAvailable PSReadLine) {
    Import-Module PSReadLine
    # Windows PowerShell 5.1 ships an old PSReadLine without predictions; ignore that there.
    try { Set-PSReadLineOption -PredictionSource HistoryAndPlugin -PredictionViewStyle InlineView -ErrorAction Stop } catch {}
    # The default suggestion colour is almost black; use the terminal's bright black (Dracula #6272A4) so it is readable.
    try { Set-PSReadLineOption -Colors @{ InlineView = "$([char]27)[90m" } -ErrorAction Stop } catch {}
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd -EditMode Windows
    # Tab accepts the grey history suggestion if there is one; otherwise it fills in the first completion
    # and pressing Tab again cycles to the next one (Shift+Tab goes back).
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock {
        $line = $null; $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        if ($line.Length -gt 0 -and $cursor -eq $line.Length) {
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
            $after = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$after, [ref]$cursor)
            if ($after -ne $line) { return }
        }
        [Microsoft.PowerShell.PSConsoleReadLine]::TabCompleteNext()
    }
    Set-PSReadLineKeyHandler -Key Shift+Tab -Function TabCompletePrevious
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# --- Prompt ---
$ompTheme = Join-Path $PSScriptRoot 'theme.omp.json'
if ((Get-Command oh-my-posh -ErrorAction SilentlyContinue) -and (Test-Path $ompTheme)) {
    oh-my-posh init pwsh --config $ompTheme | Invoke-Expression
}

# --- Fast navigation: z <partial name> jumps to frequent folders ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    # --cmd cd makes plain `cd` smart: `cd movies` jumps to the best-matching folder you've been in, from anywhere.
    # Real paths still win (`cd ..`, `cd C:\x`, `cd .\sub`), and `cd -` goes back.
    Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
}

# --- fzf: Ctrl+R history, Ctrl+T files ---
if ((Get-Command fzf -ErrorAction SilentlyContinue) -and (Get-Module -ListAvailable PSFzf)) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# --- Aliases and helpers ---
# Clone into your projects folder (default C:\gitprojects, override with $env:GITPROJECTS):
# `clone user/repo` or `clone <url>`
function clone($Repo) {
    $base = if ($env:GITPROJECTS) { $env:GITPROJECTS } else { 'C:\gitprojects' }
    $url = if ($Repo -match '^(https?://|git@)') { $Repo } else { "https://github.com/$Repo.git" }
    $name = [IO.Path]::GetFileNameWithoutExtension($url.TrimEnd('/'))
    git clone $url "$base\$name"
    if ($?) { Set-Location "$base\$name" }
}
