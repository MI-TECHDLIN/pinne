import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/features/progress/progress_providers.dart';

/// An in-memory progress server for widget tests.
class FakeProgressApi implements ProgressApi {
  FakeProgressApi(this.reports);

  /// The report returned for each period.
  final Map<ProgressPeriod, ProgressReport> reports;
  final queries = <ProgressQuery>[];
  final celebrated = <List<String>>[];
  var settingsValue = ProgressSettings(
    ownerId: owner,
    streakEnabled: false,
    weeklyGoalDays: 3,
  );

  static final owner = UuidValue.fromString(
    '00000000-0000-4000-8000-000000000001',
  );

  @override
  Future<ProgressReport> report(ProgressQuery query) async {
    queries.add(query);
    return reports[query.period]!;
  }

  @override
  Future<void> markCelebrated(List<String> keys) async => celebrated.add(keys);

  @override
  Future<ProgressSettings> settings() async => settingsValue;

  @override
  Future<ProgressSettings> updateSettings(ProgressSettingsDraft draft) async =>
      settingsValue = settingsValue.copyWith(
        streakEnabled: draft.streakEnabled,
        weeklyGoalDays: draft.weeklyGoalDays,
      );
}

ProgressDay _day(
  String date,
  int count,
  double? rate, {
  String today = '2026-10-07',
}) => ProgressDay(
  date: date,
  reviewedCount: date.compareTo(today) > 0 ? 0 : count,
  cohortRate: date.compareTo(today) > 0 ? null : rate,
  isToday: date == today,
  isFuture: date.compareTo(today) > 0,
);

/// A lively week: Wednesday 7 October 2026 is today.
ProgressReport sampleReport({
  ProgressPeriod period = ProgressPeriod.thisWeek,
  List<ProgressMilestone> milestones = const [],
}) {
  final week = [
    _day('2026-10-05', 2, 0.25),
    _day('2026-10-06', 3, 0.5),
    _day('2026-10-07', 2, 7 / 12),
    _day('2026-10-08', 0, null),
    _day('2026-10-09', 0, null),
    _day('2026-10-10', 0, null),
    _day('2026-10-11', 0, null),
  ];
  final lastWeek = period == ProgressPeriod.lastWeek;
  return ProgressReport(
    period: period,
    startDate: lastWeek ? '2026-09-28' : '2026-10-05',
    endDate: lastWeek ? '2026-10-05' : '2026-10-12',
    today: '2026-10-07',
    savedCount: lastWeek ? 9 : 12,
    reviewedCount: lastWeek ? 6 : 7,
    firstReviewedTodayCount: 2,
    remainingCount: lastWeek ? 3 : 5,
    appliedCount: 2,
    reviewRate: lastWeek ? 6 / 9 : 7 / 12,
    reviewedInPeriodCount: lastWeek ? 4 : 7,
    totalReviewedCount: 31,
    days: lastWeek
        ? [
            for (final (i, n) in [1, 0, 2, 0, 1, 0, 0].indexed)
              ProgressDay(
                date: _key(DateTime(2026, 9, 28 + i)),
                reviewedCount: n,
                cohortRate: 0.2 + i * 0.07,
                isToday: false,
                isFuture: false,
              ),
          ]
        : week,
    bestDayDate: lastWeek ? '2026-09-30' : '2026-10-06',
    collections: [
      CollectionProgress(
        collectionId: UuidValue.fromString(
          '00000000-0000-4000-8000-0000000000c1',
        ),
        name: 'Design inspiration',
        paletteIndex: 0,
        cohortCount: 4,
        reviewedCount: 3,
        reviewRate: 0.75,
      ),
      CollectionProgress(
        collectionId: UuidValue.fromString(
          '00000000-0000-4000-8000-0000000000c2',
        ),
        name: 'Flutter tips',
        paletteIndex: 2,
        cohortCount: 5,
        reviewedCount: 2,
        reviewRate: 0.4,
      ),
      CollectionProgress(
        collectionId: UuidValue.fromString(
          '00000000-0000-4000-8000-0000000000c3',
        ),
        name: 'Weeknight recipes',
        paletteIndex: 1,
        cohortCount: 3,
        reviewedCount: 2,
        reviewRate: 2 / 3,
      ),
    ],
    weeklyGoal: WeeklyGoalProgress(
      weekStartDate: '2026-10-05',
      goalDays: 5,
      reviewDayCount: 3,
      reached: false,
      days: week,
    ),
    streakEnabled: true,
    currentStreakDays: 3,
    milestones: milestones,
  );
}

String _key(DateTime day) =>
    '${day.year}-${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

/// Nothing saved or reviewed, ever.
ProgressReport emptyReport() => sampleReport().copyWith(
  days: [
    for (var i = 0; i < 7; i++) _day(_key(DateTime(2026, 10, 5 + i)), 0, null),
  ],
  savedCount: 0,
  reviewedCount: 0,
  firstReviewedTodayCount: 0,
  remainingCount: 0,
  appliedCount: 0,
  reviewRate: null,
  reviewedInPeriodCount: 0,
  totalReviewedCount: 0,
  collections: [],
  bestDayDate: null,
  currentStreakDays: null,
  streakEnabled: false,
);
