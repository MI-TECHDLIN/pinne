import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/features/planner/planner_format.dart';

void main() {
  final now = DateTime.utc(2026, 10, 7, 18);

  CalendarCoverage coverage(String name, CoverageState state, int minutesAgo) =>
      CalendarCoverage(
        selectionId: const Uuid().v4obj(),
        calendarName: name,
        route: CalendarRoute.androidDevice,
        state: state,
        checkedAt: now.subtract(Duration(minutes: minutesAgo)),
      );

  test('says when busy times were checked, using the oldest reading', () {
    expect(
      coverageLine(
        coverage: [
          coverage('Work', CoverageState.checked, 1),
          coverage('Family', CoverageState.checked, 2),
        ],
        verified: true,
        now: now,
      ),
      'Checked your busy times 2 minutes ago.',
    );
  });

  test('never claims a check that did not happen', () {
    expect(
      coverageLine(coverage: const [], verified: false, now: now),
      startsWith('Not checked'),
    );
    expect(
      coverageLine(
        coverage: [
          coverage('Work', CoverageState.checked, 1),
          coverage('Family', CoverageState.stale, 90),
        ],
        verified: false,
        now: now,
      ),
      'Not fully checked: Family could not be confirmed.',
    );
  });

  test('shows times on the planning time zone wall clock', () {
    final start = DateTime.utc(2026, 10, 7, 17);
    final end = start.add(const Duration(minutes: 15));
    expect(timeRange(start, end, 'Africa/Lagos'), '18:00 – 18:15');
    expect(timeRange(start, end, 'UTC'), '17:00 – 17:15');
  });

  test('reads freshness in plain words', () {
    expect(checkedAgo(now, now), 'just now');
    expect(
      checkedAgo(now.subtract(const Duration(minutes: 1)), now),
      '1 minute ago',
    );
    expect(
      checkedAgo(now.subtract(const Duration(hours: 3)), now),
      '3 hours ago',
    );
  });
}
