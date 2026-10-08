import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../reviews/review_queue_service.dart';
import '../reviews/review_service.dart';

/// Honest progress, derived from items and valid review events.
///
/// A save cohort is every item the owner saved from the start date
/// (inclusive) to the end date (exclusive), local to the query's offset.
/// Archived items stay in it. An item counts as reviewed once, by its first
/// valid reviewed, completed or applied event; opens and undone events never
/// count. Local review days come from each event's effective local date.
///
/// The query's current offset applies to the whole period, so a DST change
/// inside a month can move a save made within an hour of midnight by a day.
class ProgressService {
  const ProgressService();

  /// Total distinct reviews that unlock a milestone.
  static const reviewCountMilestones = [10, 25, 50, 100];

  static const maxCustomDays = 366;
  static const defaultWeeklyGoalDays = 3;

  static final _milestoneKey = RegExp(
    r'^(first-review|reviews-\d{1,5}|'
    r'(weekly-goal|queue-cleared)-\d{4}-\d{2}-\d{2})$',
  );

  Future<ProgressReport> report(
    Session session,
    UuidValue ownerId,
    ProgressQuery query, {
    DateTime? now,
  }) async {
    _validateOffset(query.timezoneOffsetMinutes);
    final offset = Duration(minutes: query.timezoneOffsetMinutes);
    final at = (now ?? DateTime.now()).toUtc();
    final today = _localDate(at, offset);
    final (start, end) = _range(query, today);

    final settings = await getSettings(session, ownerId);
    final cohort = await Item.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(ownerId) &
          (t.savedAt >= _utcMidnight(start, offset)) &
          (t.savedAt < _utcMidnight(end, offset)),
    );
    final events = await ReviewEvent.db.find(
      session,
      where: (t) => t.ownerId.equals(ownerId),
      orderByList: (t) => [t.occurredAt, t.id],
    );

    // First qualifying local date per item, distinct items per local day,
    // and the applied set, all from events that still stand.
    final firstReviewDate = <UuidValue, String>{};
    final reviewedOn = <String, Set<UuidValue>>{};
    final applied = <UuidValue>{};
    for (final event in ReviewService.validEvents(events)) {
      if (!ReviewService.qualifies(event.eventType)) continue;
      firstReviewDate.putIfAbsent(event.itemId, () => event.effectiveLocalDate);
      reviewedOn
          .putIfAbsent(event.effectiveLocalDate, () => {})
          .add(
            event.itemId,
          );
      if (event.eventType == ReviewEventType.applied) applied.add(event.itemId);
    }

    final todayKey = _key(today);
    final cohortIds = {for (final item in cohort) item.id!};
    final savedDate = {
      for (final item in cohort)
        item.id!: _key(_localDate(item.savedAt, offset)),
    };
    final reviewed = cohortIds.where(firstReviewDate.containsKey).length;

    final days = <ProgressDay>[];
    for (var day = start; day.isBefore(end); day = _addDays(day, 1)) {
      final dayKey = _key(day);
      final future = dayKey.compareTo(todayKey) > 0;
      double? rate;
      if (!future) {
        final savedBy = cohortIds.where(
          (id) => savedDate[id]!.compareTo(dayKey) <= 0,
        );
        final reviewedBy = savedBy.where(
          (id) => (firstReviewDate[id]?.compareTo(dayKey) ?? 1) <= 0,
        );
        rate = _rate(reviewedBy.length, savedBy.length);
      }
      days.add(
        ProgressDay(
          date: dayKey,
          reviewedCount: future ? 0 : reviewedOn[dayKey]?.length ?? 0,
          cohortRate: rate,
          isToday: dayKey == todayKey,
          isFuture: future,
        ),
      );
    }
    ProgressDay? best;
    for (final day in days) {
      if (day.reviewedCount > (best?.reviewedCount ?? 0)) best = day;
    }

    final reviewedInPeriod = <UuidValue>{
      for (final day in days) ...?reviewedOn[day.date],
    };

    final weekly = _weeklyGoal(
      today,
      todayKey,
      reviewedOn,
      settings.weeklyGoalDays,
    );
    final streak = settings.streakEnabled ? _streak(today, reviewedOn) : null;

    final collections = await _collections(
      session,
      ownerId,
      cohortIds,
      firstReviewDate,
    );
    final milestones = await _milestones(
      session,
      ownerId,
      at: at,
      todayKey: todayKey,
      totalReviewed: firstReviewDate.length,
      reviewedToday: reviewedOn[todayKey]?.length ?? 0,
      weekly: weekly,
    );

    return ProgressReport(
      period: query.period,
      startDate: _key(start),
      endDate: _key(end),
      today: todayKey,
      savedCount: cohort.length,
      reviewedCount: reviewed,
      firstReviewedTodayCount: cohortIds
          .where((id) => firstReviewDate[id] == todayKey)
          .length,
      remainingCount: cohort.length - reviewed,
      appliedCount: cohortIds.where(applied.contains).length,
      reviewRate: _rate(reviewed, cohort.length),
      reviewedInPeriodCount: reviewedInPeriod.length,
      totalReviewedCount: firstReviewDate.length,
      days: days,
      bestDayDate: best?.date,
      collections: collections,
      weeklyGoal: weekly,
      streakEnabled: settings.streakEnabled,
      currentStreakDays: streak,
      milestones: milestones,
    );
  }

  /// Records that the owner saw these celebrations. Safe to repeat.
  Future<void> markCelebrated(
    Session session,
    UuidValue ownerId,
    List<String> keys,
  ) async {
    if (keys.isEmpty || keys.length > 20) {
      throw ValidationException(message: 'Send between 1 and 20 milestones.');
    }
    for (final key in keys) {
      if (!_milestoneKey.hasMatch(key)) {
        throw ValidationException(message: 'Unknown milestone.');
      }
    }
    await session.db.transaction((transaction) async {
      for (final key in keys.toSet()) {
        await session.db.unsafeExecute(
          '''
INSERT INTO "celebration_seen" ("ownerId", "milestoneKey", "seenAt")
VALUES (CAST(\$1 AS uuid), \$2, \$3)
ON CONFLICT ("ownerId", "milestoneKey") DO NOTHING
''',
          parameters: QueryParameters.positional([
            ownerId.toString(),
            key,
            DateTime.now().toUtc(),
          ]),
          transaction: transaction,
        );
      }
    });
  }

  Future<ProgressSettings> getSettings(
    Session session,
    UuidValue ownerId,
  ) async =>
      await ProgressSettings.db.findFirstRow(
        session,
        where: (t) => t.ownerId.equals(ownerId),
      ) ??
      ProgressSettings(ownerId: ownerId);

  Future<ProgressSettings> saveSettings(
    Session session,
    UuidValue ownerId,
    ProgressSettingsDraft draft,
  ) async {
    if (draft.weeklyGoalDays < 1 || draft.weeklyGoalDays > 7) {
      throw ValidationException(message: 'Choose a goal of 1 to 7 days.');
    }
    await session.db.unsafeExecute(
      '''
INSERT INTO "progress_settings" ("ownerId", "streakEnabled", "weeklyGoalDays")
VALUES (CAST(\$1 AS uuid), \$2, \$3)
ON CONFLICT ("ownerId") DO UPDATE
SET "streakEnabled" = EXCLUDED."streakEnabled",
    "weeklyGoalDays" = EXCLUDED."weeklyGoalDays"
''',
      parameters: QueryParameters.positional([
        ownerId.toString(),
        draft.streakEnabled,
        draft.weeklyGoalDays,
      ]),
    );
    return getSettings(session, ownerId);
  }

  WeeklyGoalProgress _weeklyGoal(
    DateTime today,
    String todayKey,
    Map<String, Set<UuidValue>> reviewedOn,
    int goalDays,
  ) {
    final monday = _addDays(today, 1 - today.weekday);
    final days = [
      for (var i = 0; i < 7; i++)
        () {
          final key = _key(_addDays(monday, i));
          final future = key.compareTo(todayKey) > 0;
          return ProgressDay(
            date: key,
            reviewedCount: future ? 0 : reviewedOn[key]?.length ?? 0,
            isToday: key == todayKey,
            isFuture: future,
          );
        }(),
    ];
    final count = days.where((day) => day.reviewedCount > 0).length;
    return WeeklyGoalProgress(
      weekStartDate: _key(monday),
      goalDays: goalDays,
      reviewDayCount: count,
      reached: count >= goalDays,
      days: days,
    );
  }

  int _streak(DateTime today, Map<String, Set<UuidValue>> reviewedOn) {
    bool active(DateTime day) => reviewedOn[_key(day)]?.isNotEmpty ?? false;
    var day = active(today) ? today : _addDays(today, -1);
    var streak = 0;
    while (active(day)) {
      streak++;
      day = _addDays(day, -1);
    }
    return streak;
  }

  Future<List<CollectionProgress>> _collections(
    Session session,
    UuidValue ownerId,
    Set<UuidValue> cohortIds,
    Map<UuidValue, String> firstReviewDate,
  ) async {
    if (cohortIds.isEmpty) return [];
    final memberships = await ItemCollection.db.find(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.itemId.inSet(cohortIds),
    );
    if (memberships.isEmpty) return [];
    final collections = await Collection.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(ownerId) &
          t.id.inSet(memberships.map((m) => m.collectionId).toSet()),
    );
    final result = <CollectionProgress>[];
    for (final collection in collections) {
      final items = memberships
          .where((m) => m.collectionId == collection.id)
          .map((m) => m.itemId)
          .toSet();
      final reviewed = items.where(firstReviewDate.containsKey).length;
      result.add(
        CollectionProgress(
          collectionId: collection.id!,
          name: collection.name,
          paletteIndex: collection.paletteIndex,
          cohortCount: items.length,
          reviewedCount: reviewed,
          reviewRate: _rate(reviewed, items.length),
        ),
      );
    }
    result.sort((a, b) {
      final size = b.cohortCount.compareTo(a.cohortCount);
      return size != 0 ? size : a.name.compareTo(b.name);
    });
    return result;
  }

  Future<List<ProgressMilestone>> _milestones(
    Session session,
    UuidValue ownerId, {
    required DateTime at,
    required String todayKey,
    required int totalReviewed,
    required int reviewedToday,
    required WeeklyGoalProgress weekly,
  }) async {
    final reached = <(String, MilestoneKind, int)>[
      if (totalReviewed >= 1) ('first-review', MilestoneKind.firstReview, 1),
      for (final count in reviewCountMilestones)
        if (totalReviewed >= count)
          ('reviews-$count', MilestoneKind.reviewCount, count),
      if (weekly.reached)
        (
          'weekly-goal-${weekly.weekStartDate}',
          MilestoneKind.weeklyGoal,
          weekly.goalDays,
        ),
    ];
    if (reviewedToday > 0) {
      // Cleared means the queue had nothing left once reviews happened today,
      // not that reminders were paused.
      const queue = ReviewQueueService();
      final reminders = await queue.getSettings(session, ownerId);
      if (!reminders.remindersPaused) {
        final now = await queue.build(
          session,
          ownerId: ownerId,
          timeBudgetMinutes: 5,
          now: at,
        );
        if (now.eligibleCount == 0) {
          reached.add((
            'queue-cleared-$todayKey',
            MilestoneKind.queueCleared,
            reviewedToday,
          ));
        }
      }
    }
    if (reached.isEmpty) return [];
    final seen = await CelebrationSeen.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(ownerId) &
          t.milestoneKey.inSet(reached.map((m) => m.$1).toSet()),
    );
    final seenKeys = {for (final row in seen) row.milestoneKey};
    return [
      for (final (key, kind, value) in reached)
        ProgressMilestone(
          key: key,
          kind: kind,
          value: value,
          celebrated: seenKeys.contains(key),
        ),
    ];
  }

  static (DateTime, DateTime) _range(ProgressQuery query, DateTime today) {
    switch (query.period) {
      case ProgressPeriod.thisWeek:
        final monday = _addDays(today, 1 - today.weekday);
        return (monday, _addDays(monday, 7));
      case ProgressPeriod.lastWeek:
        final monday = _addDays(today, 1 - today.weekday);
        return (_addDays(monday, -7), monday);
      case ProgressPeriod.thisMonth:
        return (
          DateTime.utc(today.year, today.month),
          DateTime.utc(today.year, today.month + 1),
        );
      case ProgressPeriod.custom:
        final start = _parse(query.customStartDate);
        final end = _parse(query.customEndDate);
        if (!start.isBefore(end) ||
            end.difference(start).inDays > maxCustomDays) {
          throw ValidationException(
            message: 'Choose an end after the start, within a year.',
          );
        }
        return (start, end);
    }
  }

  static DateTime _parse(String? value) {
    final match = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})$',
    ).firstMatch(value?.trim() ?? '');
    if (match == null) {
      throw ValidationException(message: 'Dates must be yyyy-MM-dd.');
    }
    final date = DateTime.utc(
      int.parse(match[1]!),
      int.parse(match[2]!),
      int.parse(match[3]!),
    );
    if (_key(date) != value!.trim()) {
      throw ValidationException(message: 'That date does not exist.');
    }
    return date;
  }

  static void _validateOffset(int minutes) {
    if (minutes < -840 || minutes > 840) {
      throw ValidationException(message: 'Timezone offset is out of range.');
    }
  }

  static double? _rate(int part, int whole) => whole == 0 ? null : part / whole;

  /// Local calendar dates are carried as UTC midnights so arithmetic never
  /// meets a DST gap.
  static DateTime _localDate(DateTime instant, Duration offset) {
    final local = instant.toUtc().add(offset);
    return DateTime.utc(local.year, local.month, local.day);
  }

  static DateTime _utcMidnight(DateTime date, Duration offset) =>
      date.subtract(offset);

  static DateTime _addDays(DateTime date, int days) =>
      DateTime.utc(date.year, date.month, date.day + days);

  static String _key(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
