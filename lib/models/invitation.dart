import 'package:timezone/timezone.dart' as tz;

/// All editable invitation content, independent of the UI.
class Invitation {
  const Invitation({
    required this.groom,
    required this.bride,
    required this.message,
    required this.eventDate,
    required this.venueName,
    required this.mapUrl,
    this.photoAssets = const [],
    this.verse,
  });

  final String groom;
  final String bride;
  final String message;

  /// An absolute instant so the countdown is correct in every guest's timezone.
  final tz.TZDateTime eventDate;
  final String venueName;
  final Uri mapUrl;
  final List<String> photoAssets;

  final String? verse;
}
