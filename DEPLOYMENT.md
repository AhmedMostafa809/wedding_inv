# Vercel release

Deploy only a verified release folder, never the project root: the root contains
private original photos and the organizer's local Excel workbook.

Prepare a fresh release from PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tool/prepare_vercel.ps1
```

The script builds Flutter for web and reports a timestamped folder under `build`.
It rejects photo directories, JPGs, spreadsheets, environment files and source
maps. The folder contains the compiled public invitation, fonts, launcher icons,
Flutter runtime files and the static Vercel configuration.

Sign in and deploy from that reported folder:

```powershell
npx --yes vercel@59.16.0 login
cd build/vercel-release-YYYYMMDD-HHMMSS
npx --yes vercel@59.16.0 link --project ahmed-asmaa-invitation
npx --yes vercel@59.16.0 deploy --prod
```

Choose the intended personal account or team during linking. The deploy command
returns the public production URL after a successful upload. No custom domain
is required.

RSVP currently submits to the configured Google Form from the guest's browser.
The UI does not receive a verified acknowledgement from Google; hosting alone
does not verify that responses reached the spreadsheet.
