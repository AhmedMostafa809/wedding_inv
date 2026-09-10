import 'package:intl/intl.dart';

import '../models/invitation.dart';

class InvitationController {
  const InvitationController({required this.invitation});

  final Invitation invitation;

  DateTime get venueDate => invitation.eventDate;

  String get namesLabel => '${invitation.groom}, ${invitation.bride}';

  String get dateLabel =>
      DateFormat('EEEE, d MMMM yyyy', 'en').format(venueDate);
  String get timeLabel => DateFormat('h:mm a', 'en').format(venueDate);
  String get shortDate => DateFormat('dd . MM . yyyy', 'en').format(venueDate);

  Duration remainingAt(DateTime now) {
    final remaining = invitation.eventDate.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }
}
