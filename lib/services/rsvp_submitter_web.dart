import 'dart:html' as html;

const _formResponseUrl =
    'https://docs.google.com/forms/d/e/'
    '1FAIpQLSfz_LKUQhjVyhcPkeIgOlSPnxxMsQkPo7BcLaDY7bHb19vdAQ/'
    'formResponse';

Future<void> submitRsvp({
  required String name,
  required bool attending,
  required int? total,
  required String attendeeNames,
  required String message,
}) async {
  final targetName =
      'rsvp_submit_${DateTime.now().microsecondsSinceEpoch}';

  final iframe = html.IFrameElement()
    ..name = targetName
    ..style.display = 'none';

  final form = html.FormElement()
    ..method = 'POST'
    ..action = _formResponseUrl
    ..target = targetName
    ..style.display = 'none';

  void addField(String entryId, String value) {
    form.append(
      html.InputElement()
        ..type = 'hidden'
        ..name = 'entry.$entryId'
        ..value = value,
    );
  }

  addField('734057358', name.trim());

  // This must match the existing Google Form answer exactly.
  addField(
    '1091241699',
    attending ? 'Yes' : 'NO (not an option)',
  );

  addField('986094804', total?.toString() ?? '');
  addField('451605181', attendeeNames.trim());
  addField('1871091505', message.trim());

  final body = html.document.body;

  if (body == null) {
    throw StateError('The browser document is not ready.');
  }

  body.append(iframe);
  body.append(form);

  try {
    form.submit();

    await Future<void>.delayed(
      const Duration(milliseconds: 900),
    );
  } finally {
    form.remove();
    iframe.remove();
  }
}