import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../reviews/review_queue_service.dart';

class ReviewDigestService {
  const ReviewDigestService();

  Future<List<ReviewDigest>> recomputeAll(
    Session session, {
    DateTime? now,
  }) async {
    final items = await Item.db.find(
      session,
      where: (t) => t.lifecycle.equals(ItemLifecycle.active),
    );
    final owners = items.map((item) => item.ownerId).toSet();
    final created = <ReviewDigest>[];
    for (final owner in owners) {
      final digest = await recomputeOwner(session, owner, now: now);
      if (digest != null) created.add(digest);
    }
    return created;
  }

  Future<ReviewDigest?> recomputeOwner(
    Session session,
    UuidValue ownerId, {
    DateTime? now,
  }) async {
    final at = (now ?? DateTime.now()).toUtc();
    const queueService = ReviewQueueService();
    final settings = await queueService.getSettings(session, ownerId);
    if (settings.remindersPaused || settings.dailyCap == 0) return null;
    final local = at.add(Duration(minutes: settings.timezoneOffsetMinutes));
    final minute = local.hour * 60 + local.minute;
    if (_inQuietHours(minute, settings)) return null;
    final localDate = _date(local);
    final accountRule = await ReminderRule.db.findFirstRow(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.collectionId.equals(null),
    );
    final windowKey = _allowedWindowKey(local, accountRule?.deliveryWindows);
    if (windowKey == null) return null;
    final digestKey = '${ownerId.uuid}:$windowKey';
    final existing = await ReviewDigest.db.findFirstRow(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.digestKey.equals(digestKey),
    );
    if (existing != null) return existing;
    final todayCount = await ReviewDigest.db.count(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.localDate.equals(localDate),
    );
    if (todayCount >= settings.dailyCap) return null;

    final latest = await ReviewDigest.db.findFirstRow(
      session,
      where: (t) => t.ownerId.equals(ownerId),
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
    );
    var queue = await queueService.build(
      session,
      ownerId: ownerId,
      timeBudgetMinutes: 10,
      now: at,
    );
    if (queue.eligibleCount == 0) return null;
    if (latest != null &&
        !(queue.latestDueAt?.isAfter(latest.createdAt) ?? false)) {
      return null;
    }

    // Recheck immediately before committing the durable attempt.
    queue = await queueService.build(
      session,
      ownerId: ownerId,
      timeBudgetMinutes: 10,
      now: at,
    );
    if (queue.eligibleCount == 0) return null;
    final dueCount = queue.eligibleCount;
    final body =
        'You have ${_number(dueCount)} saved '
        '${dueCount == 1 ? 'idea' : 'ideas'} ready. Have a few minutes to '
        'revisit ${_number(mathMin(2, dueCount))}?';
    final inserted = await ReviewDigest.db.insert(
      session,
      [
        ReviewDigest(
          ownerId: ownerId,
          digestKey: digestKey,
          localDate: localDate,
          body: body,
          itemCount: dueCount,
          createdAt: at,
        ),
      ],
      ignoreConflicts: true,
    );
    if (inserted.isNotEmpty) return inserted.single;
    return ReviewDigest.db.findFirstRow(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.digestKey.equals(digestKey),
    );
  }

  static bool _inQuietHours(int minute, ReminderSettings settings) {
    final start = settings.quietStartMinute;
    final end = settings.quietEndMinute;
    if (start == null || end == null || start == end) return false;
    return start < end
        ? minute >= start && minute < end
        : minute >= start || minute < end;
  }

  static String? _allowedWindowKey(
    DateTime local,
    List<ReminderWindow>? windows,
  ) {
    final minute = local.hour * 60 + local.minute;
    if (windows == null || windows.isEmpty) {
      return '${_date(local)}:${local.hour.toString().padLeft(2, '0')}';
    }
    for (var index = 0; index < windows.length; index++) {
      final window = windows[index];
      final wraps = window.startMinute > window.endMinute;
      final inWindow =
          window.startMinute == window.endMinute ||
          (wraps
              ? minute >= window.startMinute || minute < window.endMinute
              : minute >= window.startMinute && minute < window.endMinute);
      if (!inWindow) continue;
      final startedYesterday = wraps && minute < window.endMinute;
      final windowDate = startedYesterday
          ? local.subtract(const Duration(days: 1))
          : local;
      final startWeekday = windowDate.weekday;
      if (window.weekdays.isNotEmpty &&
          !window.weekdays.contains(startWeekday)) {
        continue;
      }
      return '${_date(windowDate)}:window-$index-'
          '${window.startMinute}-${window.endMinute}';
    }
    return null;
  }

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';

  static int mathMin(int a, int b) => a < b ? a : b;

  static String _number(int value) => switch (value) {
    0 => 'no',
    1 => 'one',
    2 => 'two',
    3 => 'three',
    4 => 'four',
    5 => 'five',
    6 => 'six',
    7 => 'seven',
    8 => 'eight',
    9 => 'nine',
    10 => 'ten',
    _ => value.toString(),
  };
}
