import 'package:pinne_server/src/auth/owner.dart';
import 'package:pinne_server/src/generated/protocol.dart';
import 'package:pinne_server/src/progress/progress_service.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Progress',
    (sessionBuilder, endpoints) {
      const service = ProgressService();
      late TestSessionBuilder alice;
      late TestSessionBuilder bob;
      var eventCounter = 0;

      setUp(() async {
        alice = await signedInAs(sessionBuilder);
        bob = await signedInAs(sessionBuilder);
      });

      Future<Item> save(
        TestSessionBuilder who,
        String title,
        DateTime savedAt,
      ) => endpoints.item.create(
        who,
        ItemDraft(title: title, savedAt: savedAt),
      );

      Future<ReviewEventReceipt> record(
        TestSessionBuilder who,
        Item item,
        ReviewEventType type,
        DateTime at, {
        int offsetMinutes = 180,
        UuidValue? compensates,
      }) => endpoints.review.record(
        who,
        ReviewEventDraft(
          clientEventId: 'event-${eventCounter++}',
          itemId: item.id!,
          eventType: type,
          occurredAt: at,
          timezone: 'Africa/Nairobi',
          timezoneOffsetMinutes: offsetMinutes,
          compensatesEventId: compensates,
        ),
      );

      Future<ProgressReport> report(
        TestSessionBuilder who,
        ProgressPeriod period,
        DateTime now, {
        int offsetMinutes = 180,
        String? start,
        String? end,
      }) async {
        final session = who.build();
        addTearDown(session.close);
        final owner = session.ownerId;
        return service.report(
          session,
          owner,
          ProgressQuery(
            period: period,
            customStartDate: start,
            customEndDate: end,
            timezone: 'Africa/Nairobi',
            timezoneOffsetMinutes: offsetMinutes,
          ),
          now: now,
        );
      }

      // Wednesday 7 October 2026, 15:00 in Nairobi (UTC+3).
      final now = DateTime.utc(2026, 10, 7, 12);

      test('the worked example holds', () async {
        final items = [
          for (var i = 0; i < 5; i++)
            await save(
              alice,
              'Saved last week $i',
              DateTime.utc(2026, 9, 29 + i, 9),
            ),
        ];
        // One reviewed before today, two first reviewed today.
        await record(
          alice,
          items[0],
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 6, 8),
        );
        await record(
          alice,
          items[1],
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 7, 7),
        );
        await record(
          alice,
          items[2],
          ReviewEventType.completed,
          DateTime.utc(2026, 10, 7, 8),
        );
        // The already-reviewed item is reopened three times.
        for (var i = 0; i < 3; i++) {
          await record(
            alice,
            items[0],
            ReviewEventType.opened,
            DateTime.utc(2026, 10, 7, 9, i),
          );
        }

        final progress = await report(alice, ProgressPeriod.lastWeek, now);
        expect(progress.startDate, '2026-09-28');
        expect(progress.endDate, '2026-10-05');
        expect(progress.today, '2026-10-07');
        expect(progress.savedCount, 5);
        expect(progress.reviewedCount, 3);
        expect(progress.reviewRate, closeTo(0.6, 1e-9));
        expect(progress.firstReviewedTodayCount, 2);
        expect(progress.remainingCount, 2);
        // Reviews happened this week, not during last week.
        expect(progress.reviewedInPeriodCount, 0);
        expect(progress.days, hasLength(7));
        expect(progress.days.last.cohortRate, 0);

        final thisWeek = await report(alice, ProgressPeriod.thisWeek, now);
        expect(thisWeek.savedCount, 0);
        expect(thisWeek.reviewRate, isNull);
        expect(thisWeek.reviewedInPeriodCount, 3);
        final tuesday = thisWeek.days[1];
        final wednesday = thisWeek.days[2];
        expect(tuesday.reviewedCount, 1);
        expect(wednesday.reviewedCount, 2);
        expect(wednesday.isToday, isTrue);
        expect(thisWeek.days[3].isFuture, isTrue);
        expect(thisWeek.bestDayDate, '2026-10-07');
        expect(thisWeek.weeklyGoal.reviewDayCount, 2);
        expect(thisWeek.weeklyGoal.days.map((d) => d.reviewedCount > 0), [
          false,
          true,
          true,
          false,
          false,
          false,
          false,
        ]);
      });

      test('an empty cohort has no rate rather than 0%', () async {
        final progress = await report(alice, ProgressPeriod.thisMonth, now);
        expect(progress.startDate, '2026-10-01');
        expect(progress.endDate, '2026-11-01');
        expect(progress.days, hasLength(31));
        expect(progress.savedCount, 0);
        expect(progress.reviewRate, isNull);
        expect(progress.remainingCount, 0);
        expect(progress.days.every((d) => d.cohortRate == null), isTrue);
        expect(progress.bestDayDate, isNull);
        expect(progress.collections, isEmpty);
        expect(progress.milestones, isEmpty);
        expect(progress.currentStreakDays, isNull);
      });

      test('archived items stay in the cohort', () async {
        final kept = await save(alice, 'Kept', DateTime.utc(2026, 10, 5, 9));
        final archived = await save(
          alice,
          'Archived',
          DateTime.utc(2026, 10, 6, 9),
        );
        await record(
          alice,
          archived,
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 6, 10),
        );
        await endpoints.reviewQueue.archive(alice, archived.id!);
        await endpoints.reviewQueue.archive(alice, kept.id!);

        final progress = await report(alice, ProgressPeriod.thisWeek, now);
        expect(progress.savedCount, 2);
        expect(progress.reviewedCount, 1);
        expect(progress.remainingCount, 1);
        expect(progress.reviewRate, 0.5);
      });

      test('repeated opens and reviews never inflate counts', () async {
        final item = await save(alice, 'Loved', DateTime.utc(2026, 10, 5, 9));
        for (var i = 0; i < 4; i++) {
          await record(
            alice,
            item,
            ReviewEventType.opened,
            DateTime.utc(2026, 10, 7, 8, i),
          );
        }
        var progress = await report(alice, ProgressPeriod.thisWeek, now);
        expect(progress.reviewedCount, 0);
        expect(progress.days[2].reviewedCount, 0);

        for (var i = 0; i < 3; i++) {
          await record(
            alice,
            item,
            ReviewEventType.reviewed,
            DateTime.utc(2026, 10, 7, 9, i),
          );
        }
        progress = await report(alice, ProgressPeriod.thisWeek, now);
        expect(progress.reviewedCount, 1);
        expect(progress.firstReviewedTodayCount, 1);
        expect(progress.days[2].reviewedCount, 1);
        expect(progress.reviewedInPeriodCount, 1);
        expect(progress.totalReviewedCount, 1);
      });

      test('undo removes a review and a later review counts again', () async {
        final item = await save(alice, 'Undo me', DateTime.utc(2026, 10, 5, 9));
        final reviewed = await record(
          alice,
          item,
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 6, 9),
        );
        await record(
          alice,
          item,
          ReviewEventType.undo,
          DateTime.utc(2026, 10, 6, 9, 1),
          compensates: reviewed.event.id,
        );
        var progress = await report(alice, ProgressPeriod.thisWeek, now);
        expect(progress.reviewedCount, 0);
        expect(progress.days[1].reviewedCount, 0);
        expect(progress.milestones, isEmpty);

        await record(
          alice,
          item,
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 7, 9),
        );
        progress = await report(alice, ProgressPeriod.thisWeek, now);
        expect(progress.reviewedCount, 1);
        expect(progress.firstReviewedTodayCount, 1);
        expect(progress.days[1].reviewedCount, 0);
        expect(progress.days[2].reviewedCount, 1);
      });

      test('local midnight decides the cohort and the review day', () async {
        // Lagos, UTC+1. Monday 5 October starts at 2026-10-04T23:00Z.
        const lagos = 60;
        final sundayNight = await save(
          alice,
          'Sunday 23:59',
          DateTime.utc(2026, 10, 4, 22, 59),
        );
        final mondayMorning = await save(
          alice,
          'Monday 00:00',
          DateTime.utc(2026, 10, 4, 23),
        );
        // 23:30Z on Tuesday is already Wednesday in Lagos.
        await record(
          alice,
          mondayMorning,
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 6, 23, 30),
          offsetMinutes: lagos,
        );
        final wednesday = DateTime.utc(2026, 10, 7, 10);

        final thisWeek = await report(
          alice,
          ProgressPeriod.thisWeek,
          wednesday,
          offsetMinutes: lagos,
        );
        expect(thisWeek.savedCount, 1);
        expect(thisWeek.reviewedCount, 1);
        expect(thisWeek.firstReviewedTodayCount, 1);
        expect(thisWeek.days[1].reviewedCount, 0);
        expect(thisWeek.days[2].reviewedCount, 1);

        final lastWeek = await report(
          alice,
          ProgressPeriod.lastWeek,
          wednesday,
          offsetMinutes: lagos,
        );
        expect(lastWeek.savedCount, 1);
        expect(lastWeek.reviewedCount, 0);
        expect(lastWeek.remainingCount, 1);
        expect(sundayNight.id, isNotNull);

        // In UTC both saves fall on Sunday 4 October, in last week.
        final utc = await report(
          alice,
          ProgressPeriod.lastWeek,
          wednesday,
          offsetMinutes: 0,
        );
        expect(utc.savedCount, 2);
      });

      test('custom periods are validated and end-exclusive', () async {
        await save(alice, 'First', DateTime.utc(2026, 10, 1, 9));
        await save(alice, 'Second', DateTime.utc(2026, 10, 2, 9));
        final progress = await report(
          alice,
          ProgressPeriod.custom,
          now,
          start: '2026-10-01',
          end: '2026-10-02',
        );
        expect(progress.savedCount, 1);
        expect(progress.days, hasLength(1));
        await expectLater(
          report(
            alice,
            ProgressPeriod.custom,
            now,
            start: '2026-10-02',
            end: '2026-10-02',
          ),
          throwsA(isA<ValidationException>()),
        );
        await expectLater(
          report(
            alice,
            ProgressPeriod.custom,
            now,
            start: '2026-02-30',
            end: '2026-03-02',
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('collections report their own review rate', () async {
        final reading = await endpoints.collection.create(
          alice,
          CollectionDraft(name: 'Reading', coverSeed: 1, paletteIndex: 2),
        );
        final watching = await endpoints.collection.create(
          alice,
          CollectionDraft(name: 'Watching', coverSeed: 2, paletteIndex: 3),
        );
        final a = await save(alice, 'A', DateTime.utc(2026, 10, 5, 9));
        final b = await save(alice, 'B', DateTime.utc(2026, 10, 5, 10));
        final c = await save(alice, 'C', DateTime.utc(2026, 10, 5, 11));
        final session = alice.build();
        addTearDown(session.close);
        for (final (item, collection) in [
          (a, reading),
          (b, reading),
          (c, watching),
        ]) {
          await ItemCollection.db.insertRow(
            session,
            ItemCollection(
              ownerId: item.ownerId,
              itemId: item.id!,
              collectionId: collection.id!,
            ),
          );
        }
        await record(
          alice,
          a,
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 6, 9),
        );

        final progress = await report(alice, ProgressPeriod.thisWeek, now);
        expect(progress.collections.map((c) => c.name), [
          'Reading',
          'Watching',
        ]);
        expect(progress.collections.first.reviewRate, 0.5);
        expect(progress.collections.first.paletteIndex, 2);
        expect(progress.collections.last.reviewRate, 0);
      });

      test('weekly goal and streak count distinct local days', () async {
        final items = [
          for (var i = 0; i < 3; i++)
            await save(alice, 'Item $i', DateTime.utc(2026, 9, 30, 9 + i)),
        ];
        // Sunday last week, then Monday and Tuesday (twice) this week.
        await record(
          alice,
          items[0],
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 4, 9),
        );
        await record(
          alice,
          items[1],
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 5, 9),
        );
        await record(
          alice,
          items[2],
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 6, 9),
        );
        await record(
          alice,
          items[0],
          ReviewEventType.applied,
          DateTime.utc(2026, 10, 6, 10),
        );

        var progress = await report(alice, ProgressPeriod.thisWeek, now);
        expect(progress.streakEnabled, isFalse);
        expect(progress.currentStreakDays, isNull);
        expect(progress.weeklyGoal.goalDays, 3);
        expect(progress.weeklyGoal.reviewDayCount, 2);
        expect(progress.weeklyGoal.reached, isFalse);
        expect(progress.days[1].reviewedCount, 2);

        await endpoints.progress.updateSettings(
          alice,
          ProgressSettingsDraft(streakEnabled: true, weeklyGoalDays: 2),
        );
        progress = await report(alice, ProgressPeriod.thisWeek, now);
        // Today is still open, so the streak runs Sunday to Tuesday.
        expect(progress.currentStreakDays, 3);
        expect(progress.weeklyGoal.reached, isTrue);
        expect(
          progress.milestones.map((m) => m.key),
          contains('weekly-goal-2026-10-05'),
        );

        final lastWeek = await report(alice, ProgressPeriod.lastWeek, now);
        expect(lastWeek.appliedCount, 1);

        await expectLater(
          endpoints.progress.updateSettings(
            alice,
            ProgressSettingsDraft(streakEnabled: true, weeklyGoalDays: 8),
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('milestones celebrate once and stay reached', () async {
        final items = [
          for (var i = 0; i < 10; i++)
            await save(alice, 'Item $i', DateTime.utc(2026, 10, 5, 9, i)),
        ];
        await record(
          alice,
          items[0],
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 6, 9),
        );
        var progress = await report(alice, ProgressPeriod.thisWeek, now);
        expect(progress.milestones.map((m) => (m.key, m.celebrated)), [
          ('first-review', false),
        ]);

        await endpoints.progress.markCelebrated(alice, ['first-review']);
        await endpoints.progress.markCelebrated(alice, ['first-review']);
        progress = await report(alice, ProgressPeriod.thisWeek, now);
        expect(progress.milestones.single.celebrated, isTrue);

        for (final item in items.skip(1)) {
          await record(
            alice,
            item,
            ReviewEventType.reviewed,
            DateTime.utc(2026, 10, 7, 9),
          );
        }
        progress = await report(alice, ProgressPeriod.thisWeek, now);
        final byKey = {for (final m in progress.milestones) m.key: m};
        expect(byKey['reviews-10']!.celebrated, isFalse);
        expect(byKey['reviews-10']!.value, 10);
        // Every item was due a day after saving and all are reviewed now.
        expect(byKey['queue-cleared-2026-10-07']!.value, 9);
        expect(byKey.containsKey('reviews-25'), isFalse);

        await expectLater(
          endpoints.progress.markCelebrated(alice, ['free-pizza']),
          throwsA(isA<ValidationException>()),
        );
      });

      test('the queue is not cleared while items still wait', () async {
        final reviewed = await save(
          alice,
          'Done',
          DateTime.utc(2026, 10, 5, 9),
        );
        await save(alice, 'Still waiting', DateTime.utc(2026, 10, 5, 10));
        await record(
          alice,
          reviewed,
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 7, 9),
        );
        final progress = await report(alice, ProgressPeriod.thisWeek, now);
        expect(
          progress.milestones.map((m) => m.kind),
          isNot(contains(MilestoneKind.queueCleared)),
        );
      });

      test('owners never see each other’s progress', () async {
        final mine = await save(alice, 'Mine', DateTime.utc(2026, 10, 5, 9));
        await record(
          alice,
          mine,
          ReviewEventType.reviewed,
          DateTime.utc(2026, 10, 6, 9),
        );
        await endpoints.progress.updateSettings(
          alice,
          ProgressSettingsDraft(streakEnabled: true, weeklyGoalDays: 1),
        );
        await endpoints.progress.markCelebrated(bob, ['first-review']);

        final theirs = await report(bob, ProgressPeriod.thisWeek, now);
        expect(theirs.savedCount, 0);
        expect(theirs.totalReviewedCount, 0);
        expect(theirs.days.every((d) => d.reviewedCount == 0), isTrue);
        expect(theirs.milestones, isEmpty);
        expect(theirs.streakEnabled, isFalse);
        expect((await endpoints.progress.settings(bob)).weeklyGoalDays, 3);

        final own = await report(alice, ProgressPeriod.thisWeek, now);
        expect(
          own.milestones.firstWhere((m) => m.key == 'first-review').celebrated,
          isFalse,
        );

        final live = await endpoints.progress.report(
          alice,
          ProgressQuery(
            period: ProgressPeriod.thisMonth,
            timezone: 'Africa/Nairobi',
            timezoneOffsetMinutes: 180,
          ),
        );
        expect(live.period, ProgressPeriod.thisMonth);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
