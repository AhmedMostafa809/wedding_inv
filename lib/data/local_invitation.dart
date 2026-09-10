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
  photoAssets: const [
    'assets/photos/PXL_20250405_203617885.jpg',
    'assets/photos/IMG-20250406-WA0163.jpg',
    'assets/photos/IMG-20250406-WA0169.jpg',
    'assets/photos/IMG-20250419-WA0002.jpg',
    'assets/photos/IMG-20250427-WA0007.jpg',
    'assets/photos/PXL_20250509_172015442.MP.jpg',
    'assets/photos/IMG-20250523-WA0024.jpg',
    'assets/photos/PXL_20250905_140244624.jpg',
    'assets/photos/PXL_20251031_145716077.PORTRAIT.jpg',
    'assets/photos/PXL_20251031_181523579.jpg',
    'assets/photos/IMG-20251213-WA0070.jpg',
    'assets/photos/PXL_20260116_175221701.jpg',
    'assets/photos/PXL_20260116_181122428.jpg',
    'assets/photos/PXL_20260808_160148990.MP.jpg',
    'assets/photos/PXL_20260808_160153543.MP.jpg',
    'assets/photos/PXL_20260808_160207565.MP.jpg',
    'assets/photos/PXL_20260808_160218141.MP.jpg',
    'assets/photos/PXL_20260815_092931546.MP.jpg',
  ],
);
