Future<void> submitRsvp({
  required String name,
  required bool attending,
  required int? total,
  required String attendeeNames,
  required String message,
}) async {
  throw UnsupportedError('RSVP submission is available on web only.');
}
