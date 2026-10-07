import 'package:pinne_calendar/pinne_calendar.dart';
import 'package:test/test.dart';

TimeInterval _at(int startHour, int startMinute, int endHour, int endMinute) =>
    TimeInterval(
      DateTime.utc(2026, 10, 7, startHour, startMinute),
      DateTime.utc(2026, 10, 7, endHour, endMinute),
    );

void main() {
  group('TimeInterval', () {
    test('is start-inclusive and end-exclusive', () {
      final meeting = _at(9, 0, 10, 0);
      expect(meeting.overlaps(_at(10, 0, 10, 30)), isFalse);
      expect(meeting.overlaps(_at(9, 59, 10, 30)), isTrue);
      expect(meeting.overlaps(_at(8, 0, 9, 0)), isFalse);
    });

    test('refuses an empty or inverted interval', () {
      final t = DateTime.utc(2026, 10, 7, 9);
      expect(() => TimeInterval(t, t), throwsArgumentError);
      expect(TimeInterval.tryCreate(t, t), isNull);
    });

    test('normalizes local times to UTC', () {
      final interval = TimeInterval(
        DateTime.utc(2026, 10, 7, 9).toLocal(),
        DateTime.utc(2026, 10, 7, 10).toLocal(),
      );
      expect(interval.start.isUtc, isTrue);
      expect(interval.start, DateTime.utc(2026, 10, 7, 9));
    });
  });

  group('mergeIntervals', () {
    test('joins overlapping events from several calendars', () {
      final merged = mergeIntervals([
        _at(13, 0, 14, 0), // work calendar
        _at(9, 0, 10, 0),
        _at(9, 30, 11, 0), // family calendar, overlapping
        _at(10, 30, 10, 45), // inside the merged block
      ]);
      expect(merged, [_at(9, 0, 11, 0), _at(13, 0, 14, 0)]);
    });

    test('joins touching intervals so no zero-length gap is left', () {
      expect(mergeIntervals([_at(9, 0, 10, 0), _at(10, 0, 11, 0)]), [
        _at(9, 0, 11, 0),
      ]);
    });
  });

  group('freeWithin', () {
    test('returns the gaps between busy blocks', () {
      final free = freeWithin(_at(8, 0, 18, 0), [
        _at(9, 0, 10, 0),
        _at(7, 0, 8, 30), // starts before the window
        _at(17, 0, 19, 0), // ends after it
      ]);
      expect(free, [_at(8, 30, 9, 0), _at(10, 0, 17, 0)]);
    });

    test('buffers widen busy time on both sides', () {
      final busy =
          _at(
            12,
            0,
            13,
            0,
          ).padded(
            before: const Duration(minutes: 10),
            after: const Duration(minutes: 10),
          );
      expect(freeWithin(_at(11, 0, 14, 0), [busy]), [
        _at(11, 0, 11, 50),
        _at(13, 10, 14, 0),
      ]);
    });

    test('a fully busy window has no free time', () {
      expect(freeWithin(_at(9, 0, 10, 0), [_at(8, 0, 11, 0)]), isEmpty);
    });
  });

  group('LocalDate', () {
    test(
      'an all-day date spans the local day, 25 hours when clocks go back',
      () {
        // Europe/London leaves BST on Sunday 2026-10-25.
        final day = const LocalDate(2026, 10, 25).wholeDay('Europe/London');
        expect(day.start, DateTime.utc(2026, 10, 24, 23));
        expect(day.end, DateTime.utc(2026, 10, 26, 0));
        expect(day.duration, const Duration(hours: 25));
      },
    );

    test('is 23 hours long when clocks go forward', () {
      final day = const LocalDate(2026, 3, 29).wholeDay('Europe/London');
      expect(day.duration, const Duration(hours: 23));
    });

    test('finds the local date of an instant', () {
      final instant = DateTime.utc(2026, 10, 6, 23, 30);
      expect(LocalDate.inZone(instant, 'UTC'), const LocalDate(2026, 10, 6));
      expect(
        LocalDate.inZone(instant, 'Africa/Lagos'),
        const LocalDate(2026, 10, 7),
      );
      expect(LocalDate.parse('2026-10-07'), const LocalDate(2026, 10, 7));
      expect(const LocalDate(2026, 10, 7).toString(), '2026-10-07');
    });
  });

  group('SessionMarker', () {
    test('round-trips a uid inside free text', () {
      final text = 'Review time.\n\n${SessionMarker.line('abc-123')}\nmore';
      expect(SessionMarker.read(text), 'abc-123');
      expect(SessionMarker.read('A meeting'), isNull);
      expect(SessionMarker.read(null), isNull);
    });
  });
}
