# Global agent instructions

Shared by every coding agent on every machine (Claude Code reads it through `~/.claude/CLAUDE.md`).

## Environment
- Windows is the main machine; the work Mac and WSL are secondary. Prefer commands that work in PowerShell 7, and mention when something is OS-specific.
- All git projects live in `C:\gitprojects` (`~/gitprojects` elsewhere). Clone there.
- Dotfiles repo: `C:\gitprojects\dotfiles`. Change config there, not in the applied copy, then re-run `windows\install.ps1` if needed.

## Working style
- Keep answers short and direct; lead with the result.
- Look at the target before deleting or overwriting anything; back up first when replacing config.
- Match the surrounding code's style; don't add comments or abstractions that weren't asked for.
- Prefer small commits with clear messages. Don't push or open PRs unless asked.

## Safety
- Never commit secrets: private keys, `.env*`, tokens, cloud credentials, shell history.
- Don't use `credential.helper = store`; use Git Credential Manager.
- Ask before installing system-wide software, changing OS/security settings or sending anything externally.
