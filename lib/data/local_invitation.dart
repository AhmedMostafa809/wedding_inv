import 'package:timezone/timezone.dart' as tz;

import '../models/invitation.dart';
import 'event_timezone.dart';

/// Engagement: 30 October 2026. Time assumes 6:30 PM Cairo.
/// See DESIGN_NOTES.md for decisions that still need confirmation.
final localInvitation = Invitation(
  groom: 'Ahmed',
  bride: 'Habiba',
  message: 'Two hearts, one beautiful beginning. Join us as we celebrate our engagement with the people we love.',
  eventDate: tz.TZDateTime(cairoTimeZone, 2026, 10, 30, 18, 30),
  venueName: 'Golden Gate Villa',
  mapUrl: Uri.parse('https://maps.app.goo.gl/3EtqrExiB2uALCbb7?g_st=ic'),
);
