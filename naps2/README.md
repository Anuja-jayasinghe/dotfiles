# NAPS2

[NAPS2](https://www.naps2.com/) is the scanning app, set up for the HP Scanjet 200 flatbed (USB).

- `profiles.xml`: scan profiles, shown as buttons on the profiles toolbar.

  | Profile | Settings |
  |---|---|
  | Color documents (default, Ctrl+Enter) | A4, 300 dpi, color |
  | Photos | full scan bed (216 × 297 mm), 600 dpi, color, lossless |
  | Quick B&W | A4, 200 dpi, black and white |

- `settings.xml`: save dialogs start in `Documents\Scans` with names like `Scan_2026-11-23_1430.pdf`, English OCR runs after each scan so saved PDFs are searchable, and the profiles toolbar is shown.

## What the setup does

`windows\install.ps1 -Apps` installs NAPS2 (`Cyanfish.NAPS2` in `packages/windows-apps.txt`). Then, whenever NAPS2 is installed, `windows\install.ps1` copies `profiles.xml`, merges `settings.xml` into `%APPDATA%\NAPS2\config.xml`, creates `Documents\Scans`, and downloads the English OCR data (checked against NAPS2's published SHA-256). It skips NAPS2 while the app is open, because NAPS2 rewrites its config when it closes. The old `profiles.xml` is kept once as `profiles.xml.bak`.

`windows\doctor.ps1` checks the profiles match the repo and the OCR data is there.

After changing a profile in NAPS2, copy `%APPDATA%\NAPS2\profiles.xml` back here to keep it.

## Scanner driver (manual, once per PC)

HP retired the Scanjet 200 and removed its downloads, and Windows Update doesn't offer a driver, so a fresh PC shows it in Device Manager with error code 28. HP's driver (`hp200.inf`, version 1.0.48, Windows 7 era, works on Windows 11) is still on the Microsoft Update Catalog:

1. Search [catalog.update.microsoft.com](https://www.catalog.update.microsoft.com/Search.aspx?q=Scanjet%20200) for `Scanjet 200` and download **Hewlett-Packard - Imaging - HP Scanjet 200** (1.9 MB `.cab`).
2. Extract it: `expand.exe <file>.cab -F:* <folder>`
3. In an elevated shell: `pnputil /add-driver <folder>\hp200.inf /install`

The profiles point at the first WIA scanner (`{6BDD1FC6-...}\0000`). If NAPS2 can't find it on another PC, pick the scanner once under Profiles > Edit > Choose device.

Put the page face-down in the arrow corner of the glass; the profiles align scans to that corner.
