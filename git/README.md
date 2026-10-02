# Git configuration

This directory contains the shared Git layer for all supported machines.

## Shared settings

`gitconfig` contains portable defaults and aliases. It deliberately does not contain:

- `user.name`
- `user.email`
- Credential helpers
- Private keys
- Access tokens
- Work or personal account-specific settings

Those settings remain machine-specific and will be handled later with chezmoi templates or local include files.

`ignore` contains global noise and secret-file patterns. It is not a replacement for a project's `.gitignore`.

## Current work-Mac activation

The shared layer is currently included from the local checkout with:

```text
[include]
    path = /Users/anujaj/dotfiles/git/gitconfig
```

The global ignore file is also active from this checkout. This is intentionally a temporary work-Mac arrangement. Once chezmoi is configured, the include and target files will become portable across Windows, WSL, and macOS.

## Work/personal identities

The intended future design is:

```text
shared Git settings
├── personal identity on the Windows machine
├── work identity on the Mac
└── optional directory-based includes for work repositories
```

Do not put a work email into the shared configuration before the identity strategy is finalized.
