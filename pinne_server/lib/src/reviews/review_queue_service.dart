import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class ReviewQueueService {
  const ReviewQueueService();

  static const allowedBudgets = {5, 10, 20};

  Future<ReviewQueueResult> build(
    Session session, {
    required UuidValue ownerId,
    required int timeBudgetMinutes,
    DateTime? now,
  }) async {
    if (!allowedBudgets.contains(timeBudgetMinutes)) {
      throw ValidationException(message: 'Choose a 5, 10 or 20 minute budget.');
    }
    final at = (now ?? DateTime.now()).toUtc();
    final settings = await getSettings(session, ownerId);
    final latestDigest = await ReviewDigest.db.findFirstRow(
      session,
      where: (t) => t.ownerId.equals(ownerId),
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
    );
    if (settings.remindersPaused) {
      return ReviewQueueResult(
        entries: [],
        timeBudgetMinutes: timeBudgetMinutes,
        eligibleCount: 0,
        digestText: latestDigest?.body,
      );
    }

    final items = await Item.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(ownerId) & t.lifecycle.equals(ItemLifecycle.active),
    );
    final controls = await ItemReviewControl.db.find(
      session,
      where: (t) => t.ownerId.equals(ownerId),
    );
    final controlByItem = {for (final c in controls) c.itemId: c};
    final progress = await ItemProgress.db.find(
      session,
      where: (t) => t.ownerId.equals(ownerId),
    );
    final progressByItem = {for (final p in progress) p.itemId: p};
    final rules = await ReminderRule.db.find(
      session,
      where: (t) => t.ownerId.equals(ownerId),
    );
    final accountRule = rules
        .where((rule) => rule.collectionId == null)
        .firstOrNull;
    final collectionRules = {
      for (final rule in rules.where((rule) => rule.collectionId != null))
        rule.collectionId!: rule,
    };
    final memberships = await ItemCollection.db.find(
      session,
      where: (t) => t.ownerId.equals(ownerId),
    );
    final collectionsByItem = <UuidValue, List<UuidValue>>{};
    for (final membership in memberships) {
      collectionsByItem
          .putIfAbsent(membership.itemId, () => [])
          .add(membership.collectionId);
    }

    final candidates = <ReviewQueueEntry>[];
    for (final item in items) {
      if (progressByItem[item.id]?.firstReviewedAt != null) continue;
      final control = controlByItem[item.id];
      if (control?.remindersPaused ?? false) continue;
      if (control?.snoozedUntil?.isAfter(at) ?? false) continue;
      final cooldownUntil = control?.lastDismissedAt?.add(
        Duration(minutes: settings.dismissCooldownMinutes),
      );
      if (cooldownUntil?.isAfter(at) ?? false) continue;

      final itemRules =
          (collectionsByItem[item.id] ?? const <UuidValue>[])
              .map((id) => collectionRules[id])
              .whereType<ReminderRule>()
              .toList()
            ..sort((a, b) {
              final delay = b.delayHours.compareTo(a.delayHours);
              if (delay != 0) return delay;
              return a.id.toString().compareTo(b.id.toString());
            });
      if (itemRules.any((rule) => !rule.enabled)) continue;
      final effectiveRule = itemRules.firstOrNull ?? accountRule;
      if (effectiveRule != null && !effectiveRule.enabled) continue;
      final delayHours = effectiveRule?.delayHours ?? settings.delayHours;
      var dueAt = item.savedAt.toUtc().add(Duration(hours: delayHours));
      if (control?.snoozedUntil case final snoozed?) {
        if (snoozed.isAfter(dueAt)) dueAt = snoozed.toUtc();
      }
      if (dueAt.isAfter(at)) continue;
      final estimate = estimateMinutes(item.contentType);
      candidates.add(
        ReviewQueueEntry(
          item: item,
          dueAt: dueAt,
          overdueMinutes: math.max(0, at.difference(dueAt).inMinutes),
          estimatedMinutes: estimate,
          selectionReason: item.priority > 0
              ? 'High priority · about $estimate min (estimate)'
              : 'Due for review · about $estimate min (estimate)',
        ),
      );
    }
    candidates.sort((a, b) {
      final priority = b.item.priority.compareTo(a.item.priority);
      if (priority != 0) return priority;
      final overdue = b.overdueMinutes.compareTo(a.overdueMinutes);
      if (overdue != 0) return overdue;
      final aFit = a.estimatedMinutes <= timeBudgetMinutes ? 0 : 1;
      final bFit = b.estimatedMinutes <= timeBudgetMinutes ? 0 : 1;
      final fit = aFit.compareTo(bFit);
      if (fit != 0) return fit;
      final distance = (a.estimatedMinutes - timeBudgetMinutes).abs().compareTo(
        (b.estimatedMinutes - timeBudgetMinutes).abs(),
      );
      if (distance != 0) return distance;
      final saved = a.item.savedAt.compareTo(b.item.savedAt);
      if (saved != 0) return saved;
      return a.item.id.toString().compareTo(b.item.id.toString());
    });

    final selected = <ReviewQueueEntry>[];
    var remaining = timeBudgetMinutes;
    for (final entry in candidates) {
      if (selected.length >= settings.queueLimit) break;
      if (selected.isEmpty || entry.estimatedMinutes <= remaining) {
        selected.add(entry);
        remaining = math.max(0, remaining - entry.estimatedMinutes);
      }
    }
    return ReviewQueueResult(
      entries: selected,
      timeBudgetMinutes: timeBudgetMinutes,
      eligibleCount: candidates.length,
      latestDueAt: candidates
          .map((entry) => entry.dueAt)
          .fold<DateTime?>(
            null,
            (latest, dueAt) =>
                latest == null || dueAt.isAfter(latest) ? dueAt : latest,
          ),
      digestText: latestDigest?.body,
    );
  }

  Future<ReminderSettings> getSettings(
    Session session,
    UuidValue ownerId,
  ) async =>
      await ReminderSettings.db.findFirstRow(
        session,
        where: (t) => t.ownerId.equals(ownerId),
      ) ??
      ReminderSettings(ownerId: ownerId);

  Future<ReminderSettings> saveSettings(
    Session session,
    UuidValue ownerId,
    ReminderSettingsDraft draft,
  ) async {
    _validateSettings(draft);
    final existing = await ReminderSettings.db.findFirstRow(
      session,
      where: (t) => t.ownerId.equals(ownerId),
    );
    if (existing == null) {
      return ReminderSettings.db.insertRow(
        session,
        ReminderSettings(
          ownerId: ownerId,
          delayHours: draft.delayHours,
          timezone: draft.timezone.trim(),
          timezoneOffsetMinutes: draft.timezoneOffsetMinutes,
          quietStartMinute: draft.quietStartMinute,
          quietEndMinute: draft.quietEndMinute,
          dailyCap: draft.dailyCap,
          remindersPaused: draft.remindersPaused,
          queueLimit: draft.queueLimit,
          dismissCooldownMinutes: draft.dismissCooldownMinutes,
        ),
      );
    }
    existing
      ..delayHours = draft.delayHours
      ..timezone = draft.timezone.trim()
      ..timezoneOffsetMinutes = draft.timezoneOffsetMinutes
      ..quietStartMinute = draft.quietStartMinute
      ..quietEndMinute = draft.quietEndMinute
      ..dailyCap = draft.dailyCap
      ..remindersPaused = draft.remindersPaused
      ..queueLimit = draft.queueLimit
      ..dismissCooldownMinutes = draft.dismissCooldownMinutes;
    return ReminderSettings.db.updateRow(session, existing);
  }

  Future<ItemReviewControl> snooze(
    Session session,
    UuidValue ownerId,
    UuidValue itemId,
    DateTime until,
  ) async {
    final at = until.toUtc();
    if (!at.isAfter(DateTime.now().toUtc())) {
      throw ValidationException(message: 'Snooze time must be in the future.');
    }
    await _ownedItem(session, ownerId, itemId);
    return _saveControl(
      session,
      ownerId,
      itemId,
      snoozedUntil: at,
      dismissedAt: DateTime.now().toUtc(),
    );
  }

  Future<ItemReviewControl> pause(
    Session session,
    UuidValue ownerId,
    UuidValue itemId,
    bool paused,
  ) async {
    await _ownedItem(session, ownerId, itemId);
    return _saveControl(session, ownerId, itemId, paused: paused);
  }

  Future<Item> archive(
    Session session,
    UuidValue ownerId,
    UuidValue itemId,
  ) async {
    final item = await _ownedItem(session, ownerId, itemId);
    return Item.db.updateRow(
      session,
      item.copyWith(
        lifecycle: ItemLifecycle.archived,
        revision: item.revision + 1,
      ),
    );
  }

  Future<ItemReviewControl> _saveControl(
    Session session,
    UuidValue ownerId,
    UuidValue itemId, {
    DateTime? snoozedUntil,
    DateTime? dismissedAt,
    bool? paused,
  }) async {
    final existing = await ItemReviewControl.db.findFirstRow(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.itemId.equals(itemId),
    );
    if (existing == null) {
      return ItemReviewControl.db.insertRow(
        session,
        ItemReviewControl(
          ownerId: ownerId,
          itemId: itemId,
          snoozedUntil: snoozedUntil,
          remindersPaused: paused ?? false,
          lastDismissedAt: dismissedAt,
        ),
      );
    }
    if (snoozedUntil != null) existing.snoozedUntil = snoozedUntil;
    if (dismissedAt != null) existing.lastDismissedAt = dismissedAt;
    if (paused != null) existing.remindersPaused = paused;
    return ItemReviewControl.db.updateRow(session, existing);
  }

  Future<Item> _ownedItem(
    Session session,
    UuidValue ownerId,
    UuidValue itemId,
  ) async {
    final item = await Item.db.findFirstRow(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.id.equals(itemId),
    );
    if (item == null) throw RecordNotFoundException(resource: 'item');
    return item;
  }

  static int estimateMinutes(ContentType type) => switch (type) {
    ContentType.note => 3,
    ContentType.post || ContentType.thread => 5,
    ContentType.other => 7,
    ContentType.article => 8,
    ContentType.video => 10,
  };

  static void _validateSettings(ReminderSettingsDraft draft) {
    final paired =
        (draft.quietStartMinute == null) == (draft.quietEndMinute == null);
    bool minute(int? value) => value == null || (value >= 0 && value < 1440);
    if (draft.delayHours < 1 || draft.delayHours > 24 * 365) {
      throw ValidationException(message: 'Reminder delay is out of range.');
    }
    if (draft.timezone.trim().isEmpty || draft.timezone.length > 80) {
      throw ValidationException(message: 'A timezone is required.');
    }
    if (draft.timezoneOffsetMinutes < -840 ||
        draft.timezoneOffsetMinutes > 840) {
      throw ValidationException(message: 'Timezone offset is out of range.');
    }
    if (!paired ||
        !minute(draft.quietStartMinute) ||
        !minute(draft.quietEndMinute)) {
      throw ValidationException(message: 'Quiet hours are invalid.');
    }
    if (draft.dailyCap < 0 || draft.dailyCap > 24) {
      throw ValidationException(message: 'Daily cap is out of range.');
    }
    if (draft.queueLimit < 1 || draft.queueLimit > 20) {
      throw ValidationException(message: 'Queue limit is out of range.');
    }
    if (draft.dismissCooldownMinutes < 0 ||
        draft.dismissCooldownMinutes > 24 * 60) {
      throw ValidationException(message: 'Dismiss cooldown is out of range.');
    }
  }
}
