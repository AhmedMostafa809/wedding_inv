import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Bundled IANA rules include Cairo's daylight-saving transitions.
final cairoTimeZone = _loadCairoTimeZone();

tz.Location _loadCairoTimeZone() {
  tz_data.initializeTimeZones();
  return tz.getLocation('Africa/Cairo');
}
