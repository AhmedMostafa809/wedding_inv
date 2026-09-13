import 'package:timezone/timezone.dart' as tz;

import '../models/invitation.dart';
import 'event_timezone.dart';

/// Year, time and wording are provisional.
/// See DESIGN_NOTES.md for decisions that still need confirmation.
final localInvitation = Invitation(
  groom: 'Ahmed',
  bride: 'Asmaa',
  message: 'With joyful hearts, we invite you to celebrate the beginning of our forever.',
  verse: '﴿ وَمِنْ آيَاتِهِ أَنْ خَلَقَ لَكُم مِّنْ أَنفُسِكُمْ أَزْوَاجًا لِّتَسْكُنُوا إِلَيْهَا وَجَعَلَ بَيْنَكُم مَّوَدَّةً وَرَحْمَةً ﴾',
  eventDate: tz.TZDateTime(cairoTimeZone, 2026, 10, 16, 20),
  venueName: 'قاعة الفتح - مسجد المشير طنطاوي',
  mapUrl: Uri.parse('https://maps.app.goo.gl/SFXt7nQe3FEbsSR2A'),
);
