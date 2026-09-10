# Ahmed, Asmaa — Wedding Invitation

An English-led Flutter MVC invitation with a warm editorial wedding theme,
wax-seal envelope opening, torn-paper transitions, scroll reveals, an automatic
tilted photo reel, countdown and location link. The Arabic verse and venue remain
in Arabic.
Desktop keeps the same 480-pixel maximum width as the mobile layout.

## Run locally

```sh
flutter pub get
flutter run -d chrome
```

To view on a phone on the same network:

```sh
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Open `http://<your-computer-local-ip>:8080` in the phone browser.
The computer's firewall must allow that port.

## Structure

- `lib/models/`: invitation content.
- `lib/data/local_invitation.dart`: editable local values.
- `lib/controllers/`: date formatting and countdown calculations.
- `lib/views/`: screen and animated widgets.
- `lib/theme/`: colors and bundled Arabic typography.
- `assets/`: local Amiri font, its license and the photos folder.
- `documents/RSVP_Ahmed_Asmaa.xlsx`: private local guest-list template with totals;
  not connected to live RSVP responses or included in the public website.

Animation lifecycles live in their widgets; event calculations live
in the controller. No backend or guest data storage is connected.
Event dates use Africa/Cairo with daylight-saving rules. Music is removed for now.

**Read [DESIGN_NOTES.md](DESIGN_NOTES.md) for assumptions and decisions to revisit.**
The RSVP button currently opens a coming-soon sheet and does not submit responses.
The year, time and copy are provisional. The venue is confirmed in DESIGN_NOTES.md.

## Validation

```sh
flutter analyze
flutter test
flutter build web --no-web-resources-cdn
```

Optional visual previews from widget tests:

```sh
flutter test --dart-define=CAPTURE_PREVIEWS=true test/widget_test.dart
```

PNGs are written under `build/previews/`.


