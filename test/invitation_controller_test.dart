import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_inv/controllers/invitation_controller.dart';
import 'package:wedding_inv/data/local_invitation.dart';
import 'package:wedding_inv/data/event_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  final controller = InvitationController(invitation: localInvitation);

  test('Countdown uses an absolute instant and clamps after the event', () {
    expect(
      controller.remainingAt(DateTime.parse('2026-10-16T19:00:00+03:00')),
      const Duration(hours: 1),
    );
    expect(
      controller.remainingAt(DateTime.parse('2026-10-16T17:00:00Z')),
      Duration.zero,
    );
    expect(controller.remainingAt(DateTime.utc(2026, 10, 17)), Duration.zero);
  });

  test('Event display uses venue time regardless of device timezone', () {
    expect(controller.venueDate.hour, 20);
    expect(controller.venueDate.day, 16);
    expect(controller.venueDate.timeZoneOffset, const Duration(hours: 3));
    expect(localInvitation.eventDate.location.name, 'Africa/Cairo');
  });

  test('Cairo rules switch offsets between winter and summer', () {
    expect(
      tz.TZDateTime(cairoTimeZone, 2026, 1, 16, 20).timeZoneOffset,
      const Duration(hours: 2),
    );
    expect(
      tz.TZDateTime(cairoTimeZone, 2026, 7, 16, 20).timeZoneOffset,
      const Duration(hours: 3),
    );
  });
}
