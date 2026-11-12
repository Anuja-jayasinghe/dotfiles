# Bitwarden

Bitwarden is the only password manager: Chrome on Windows and the iPhone both save and fill from it. Chrome's and Apple's own password saving are turned off.

## What the setup does

- `windows/install.ps1` installs the desktop app (`Bitwarden.Bitwarden` in `packages/windows.txt`) and opens the Chrome extension's Web Store page if no Chrome profile has it.
- `windows/doctor.ps1` checks that both are installed.

Nothing else is stored here: the vault, sign-in and settings live in the Bitwarden account, never in this repo.

## Manual steps on a new Windows PC

1. Chrome extension: click **Add to Chrome**, pin it, log in.
2. Desktop app: log in, then Settings: **Unlock with Windows Hello** and **Allow browser integration**.
3. Extension settings: **Unlock with biometrics**, and under autofill **Make Bitwarden your default password manager**.
4. `chrome://password-manager/settings`: make sure **Offer to save passwords** is off.

## iPhone

1. Install Bitwarden from the App Store and log in.
2. Settings > General > **AutoFill & Passwords**: Bitwarden on; Passwords and Chrome off.

## Moving passwords in

- **Chrome:** `chrome://password-manager/settings` > Export passwords, then vault.bitwarden.com > Tools > Import data > **Chrome (csv)**. Save the export outside OneDrive-synced folders and delete it straight after.
- **Apple Passwords (iOS 26+):** Passwords app > Export Data to Another App > Bitwarden. This carries passkeys too.

Bitwarden has no duplicate cleanup, so logins that were in both end up twice.

## Notes

- Keep 2FA codes in an authenticator app, not in Bitwarden, so one vault never holds both factors.
- Keep the master password and the account's recovery code offline; Bitwarden can't reset the master password.
