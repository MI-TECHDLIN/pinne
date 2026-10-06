import 'package:pinne_calendar/pinne_calendar.dart';
import 'package:test/test.dart';

const _everyDay = {1, 2, 3, 4, 5, 6, 7};

PlanningPolicy _policy({
  String timezone = 'UTC',
  Set<int> weekdays = _everyDay,
  int windowStart = 18 * 60,
  int windowEnd = 20 * 60,
  int sessionMinutes = 15,
  int maxSessions = 7,
  int bufferMinutes = 0,
  int minLeadMinutes = 0,
}) => PlanningPolicy(
  timezone: timezone,
  weekdays: weekdays,
  windowStartMinute: windowStart,
  windowEndMinute: windowEnd,
  sessionMinutes: sessionMinutes,
  maxSessions: maxSessions,
  bufferMinutes: bufferMinutes,
  minLeadMinutes: minLeadMinutes,
);

/// Monday 2026-10-05 to Monday 2026-10-12, UTC.
final _week = TimeInterval(
  DateTime.utc(2026, 10, 5),
  DateTime.utc(2026, 10, 12),
);
final _mondayMorning = DateTime.utc(2026, 10, 5, 8);

TimeInterval _utc(int day, int h, int m, int minutes) {
  final start = DateTime.utc(2026, 10, day, h, m);
  return TimeInterval(start, start.add(Duration(minutes: minutes)));
}

void main() {
  test('places one session per eligible day at the window start', () {
    final plan = planSlots(
      policy: _policy(),
      horizon: _week,
      now: _mondayMorning,
      busy: const [],
    );
    expect(plan.slots, hasLength(7));
    expect(plan.slots.first, _utc(5, 18, 0, 15));
    expect(plan.slots.last, _utc(11, 18, 0, 15));
    expect(plan.shortfall, isNull);
  });

  test('never overlaps a busy interval from overlapping calendars', () {
    final busy = [
      _utc(5, 17, 30, 60), // work, to 18:30
      _utc(5, 18, 15, 30), // family, overlaps, to 18:45
    ];
    final plan = planSlots(
      policy: _policy(maxSessions: 1),
      horizon: _week,
      now: _mondayMorning,
      busy: busy,
    );
    expect(plan.slots.single, _utc(5, 18, 45, 15));
    for (final slot in plan.slots) {
      expect(busy.any(slot.overlaps), isFalse);
    }
  });

  test('keeps the buffer on both sides of a busy interval', () {
    final plan = planSlots(
      policy: _policy(maxSessions: 1, bufferMinutes: 10, windowEnd: 19 * 60),
      horizon: _week,
      now: _mondayMorning,
      busy: [_utc(5, 18, 0, 20)], // to 18:20, buffer to 18:30
    );
    expect(plan.slots.single, _utc(5, 18, 30, 15));
  });

  test('rounds a start up to the 15 minute grid', () {
    final plan = planSlots(
      policy: _policy(maxSessions: 1),
      horizon: _week,
      now: _mondayMorning,
      busy: [_utc(5, 18, 0, 7)],
    );
    expect(plan.slots.single, _utc(5, 18, 15, 15));
  });

  test('honours lead time and the chosen weekdays', () {
    final plan = planSlots(
      // Weekdays only, at least a day ahead.
      policy: _policy(weekdays: {1, 2, 3, 4, 5}, minLeadMinutes: 24 * 60),
      horizon: _week,
      now: DateTime.utc(2026, 10, 5, 18, 30),
      busy: const [],
    );
    expect(plan.slots.map((s) => s.start.day), [6, 7, 8, 9]);
  });

  test('spreads a bounded number of sessions across the horizon', () {
    final plan = planSlots(
      policy: _policy(maxSessions: 3),
      horizon: _week,
      now: _mondayMorning,
      busy: const [],
    );
    expect(plan.slots.map((s) => s.start.day), [5, 7, 9]);
    expect(plan.daysWithRoom, 7);
  });

  test('explains when every window is busy', () {
    final plan = planSlots(
      policy: _policy(),
      horizon: _week,
      now: _mondayMorning,
      busy: [
        TimeInterval(DateTime.utc(2026, 10, 1), DateTime.utc(2026, 10, 20)),
      ],
    );
    expect(plan.slots, isEmpty);
    expect(plan.shortfall, ShortfallReason.noFreeWindow);
    expect(plan.eligibleDays, 7);
  });

  test('explains when no chosen day falls in the horizon', () {
    final plan = planSlots(
      policy: _policy(weekdays: {6}),
      horizon: TimeInterval(
        DateTime.utc(2026, 10, 5),
        DateTime.utc(2026, 10, 8),
      ),
      now: _mondayMorning,
      busy: const [],
    );
    expect(plan.shortfall, ShortfallReason.noEligibleDays);
  });

  test('is deterministic', () {
    List<TimeInterval> run() => planSlots(
      policy: _policy(maxSessions: 4, bufferMinutes: 5),
      horizon: _week,
      now: _mondayMorning,
      busy: [_utc(6, 18, 0, 30), _utc(8, 17, 0, 200)],
    ).slots;
    expect(run(), run());
  });

  test('refuses an invalid policy', () {
    expect(
      () => planSlots(
        policy: _policy(windowStart: 20 * 60, windowEnd: 18 * 60),
        horizon: _week,
        now: _mondayMorning,
        busy: const [],
      ),
      throwsArgumentError,
    );
    expect(_policy(timezone: 'Mars/Olympus').problem(), contains('time zone'));
  });

  group('across daylight-saving changes', () {
    test('keeps the local window when clocks go back', () {
      // Europe/London: BST (UTC+1) until Sunday 2026-10-25 02:00 local.
      final plan = planSlots(
        policy: _policy(timezone: 'Europe/London'),
        horizon: TimeInterval(
          DateTime.utc(2026, 10, 23),
          DateTime.utc(2026, 10, 27),
        ),
        now: DateTime.utc(2026, 10, 23),
        busy: const [],
      );
      final starts = plan.slots.map((s) => s.start).toList();
      expect(starts, contains(DateTime.utc(2026, 10, 24, 17))); // 18:00 BST
      expect(starts, contains(DateTime.utc(2026, 10, 25, 18))); // 18:00 GMT
      for (final slot in plan.slots) {
        expect(slot.duration, const Duration(minutes: 15));
      }
    });

    test('a session spanning the skipped hour keeps its real length', () {
      // Clocks go forward at 01:00 GMT on 2026-03-29 to 02:00 BST.
      final plan = planSlots(
        policy: _policy(
          timezone: 'Europe/London',
          windowStart: 0,
          windowEnd: 3 * 60,
          sessionMinutes: 90,
          maxSessions: 1,
        ),
        horizon: TimeInterval(
          DateTime.utc(2026, 3, 29),
          DateTime.utc(2026, 3, 30),
        ),
        now: DateTime.utc(2026, 3, 28),
        busy: [
          TimeInterval(
            DateTime.utc(2026, 3, 29, 0),
            DateTime.utc(2026, 3, 29, 0, 30),
          ),
        ],
      );
      final slot = plan.slots.single;
      expect(slot.duration, const Duration(minutes: 90));
      expect(slot.start, DateTime.utc(2026, 3, 29, 0, 30));
      // The local window 00:00-03:00 is only two real hours long that night.
      expect(slot.end.isAfter(DateTime.utc(2026, 3, 29, 2)), isFalse);
    });
  });
}
