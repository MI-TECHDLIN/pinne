import 'package:pinne_calendar/pinne_calendar.dart';
import 'package:pinne_server/src/generated/protocol.dart';
import 'package:test/test.dart';

/// The shared calendar routes map to the generated enum by name. A new value
/// on one side must be added on the other.
void main() {
  test('every calendar route kind has a calendar route', () {
    expect(
      CalendarRoute.values.map((r) => r.name),
      unorderedEquals(CalendarRouteKind.values.map((k) => k.name)),
    );
  });
}
