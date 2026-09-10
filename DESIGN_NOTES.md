# Invitation decisions and follow-up

## Agreed
- Arabic invitation with the couple's names written in English: Ahmed, Asmaa.
- Editorial wedding-site theme based on the supplied reference: warm stone,
  pale paper, espresso text, calligraphic headings and irregular torn-paper
  dividers. A textured taupe folded envelope has a satin band and ivory seal;
  opening lifts the seal, unfolds the sides, and reveals the letter.
- October 16; countdown, location and RSVP sections.
- Cairo time zone: Africa/Cairo, using bundled IANA rules including daylight saving.
- Venue: قاعة الفتح - مسجد المشير طنطاوي.
- Map: https://maps.app.goo.gl/SFXt7nQe3FEbsSR2A
- Mobile first; desktop keeps the same narrow layout (maximum 480 logical pixels).
- Music removed for now, including its control, asset and audio dependency.
- No guest personalization is needed; use a shared invitation.
- Reduced-motion settings skip the opening animation and scroll reveals.
- RSVP responses must be usable in an Excel sheet.

## Confirm or provide later
- **Year and time:** still assumed October 16, 2026 at 8:00 PM Cairo time.
  Edit the local Cairo wall-clock date in local_invitation.dart.
  The countdown compares absolute instants so it is consistent for guests worldwide.
- **Language:** the primary interface and headings are English. The Qur’anic
  verse and Arabic venue name remain Arabic.
- **Typography:** Great Vibes for calligraphic headings, Cormorant Garamond for display text,
  Montserrat for English body copy and labels, and Amiri for Arabic content.
- **Wording and verses:** the user supplied a verse; English invitation wording
  is provisional and can be edited in local_invitation.dart.
- **RSVP implementation:** not connected yet. The button shows a coming-soon sheet.
  Choose a Microsoft Forms link with Excel response access, or a custom invitation
  form with private server storage and Excel export. A continuously updated Excel
  workbook requires an online integration; a local file alone cannot collect
  responses from guests on different devices.
- **Suggested RSVP fields:** name, attending/declining, total party size including
  the respondent, optional phone number and note, plus automatic submission time.
  Confirm fields, party-size limits, and whether replies can be edited.
- **Photos:** all 18 unique JPGs appear only in one compact horizontal reel,
  sourced from local_invitation.dart and shuffled for display. The gallery is the
  final content section and preserves the latest 20% viewport-height edit.
  Clear, naturally colored photos overlap at varied angles, sizes and heights,
  moving continuously as a compact collage without tap, zoom or pause controls.
  Blur and color filters are removed; the composition gives fleeting glimpses.
  Motion pauses for reduced-motion settings and when the app is in the background.
  One exact duplicate is omitted; original files are preserved. Images are loaded
  lazily as the reel reaches them.
- **Excel workbook:** documents/RSVP_Ahmed_Asmaa.xlsx is created locally with
  Guest List, Summary and Instructions tabs, attendance dropdowns and calculated
  totals. It has no real responses and no online URL or RSVP connection yet.
  Uploading it to OneDrive would make it accessible online, but an RSVP integration
  is still needed. It is intentionally outside public web assets.
- **Guest list proposal:** a private organizer page showing RSVP names,
  attending/declining status, total party size, notes and submission time, with
  attendance totals and Excel export. This page is proposed, not implemented.
  Without an invited-guest roster, it can show replies but cannot identify
  everyone who has not replied.

## Editing
Content: lib/data/local_invitation.dart.
Model: lib/models/invitation.dart.
Cairo zone initialization: lib/data/event_timezone.dart.
Palette and typography: lib/theme/invitation_theme.dart.
The Amiri font is bundled under its SIL Open Font License in assets/fonts/OFL.txt.

## RSVP reference
Microsoft Forms supports viewing responses in Excel:
https://support.microsoft.com/en-us/forms/microsoft-forms-and-excel-workbooks
Live workbook connection availability depends on account and form creation method:
https://support.microsoft.com/en-us/forms/can-i-get-real-time-updates-in-my-excel-workbook

