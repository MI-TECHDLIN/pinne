import 'package:pinne_server/src/generated/protocol.dart';
import 'package:pinne_server/src/reviews/review_queue_service.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Review queue', (sessionBuilder, endpoints) {
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;

    setUp(() async {
      alice = await signedInAs(sessionBuilder);
      bob = await signedInAs(sessionBuilder);
    });

    test('24h boundary, item controls and archive obey precedence', () async {
      final now = DateTime.utc(2026, 10, 6, 12);
      final due = await endpoints.item.create(
        alice,
        ItemDraft(
          title: 'Boundary',
          savedAt: now.subtract(const Duration(hours: 24)),
        ),
      );
      final young = await endpoints.item.create(
        alice,
        ItemDraft(
          title: 'Too young',
          savedAt: now.subtract(const Duration(hours: 23, minutes: 59)),
        ),
      );
      final session = alice.build();
      addTearDown(session.close);
      final owner = due.ownerId;
      const service = ReviewQueueService();
      var queue = await service.build(
        session,
        ownerId: owner,
        timeBudgetMinutes: 20,
        now: now,
      );
      expect(queue.entries.map((e) => e.item.id), contains(due.id));
      expect(queue.entries.map((e) => e.item.id), isNot(contains(young.id)));

      await ItemReviewControl.db.insertRow(
        session,
        ItemReviewControl(
          ownerId: owner,
          itemId: due.id!,
          snoozedUntil: now.add(const Duration(hours: 1)),
          lastDismissedAt: now,
        ),
      );
      queue = await service.build(
        session,
        ownerId: owner,
        timeBudgetMinutes: 20,
        now: now,
      );
      expect(queue.entries.map((e) => e.item.id), isNot(contains(due.id)));

      final archived = await endpoints.reviewQueue.archive(alice, young.id!);
      expect(archived.lifecycle, ItemLifecycle.archived);
      expect(await endpoints.review.progress(alice, young.id!), isNull);
      await expectLater(
        endpoints.reviewQueue.archive(bob, due.id!),
        throwsA(isA<RecordNotFoundException>()),
      );
    });

    test(
      'collection delay overrides account delay and pause excludes',
      () async {
        final now = DateTime.utc(2026, 10, 6, 12);
        final item = await endpoints.item.create(
          alice,
          ItemDraft(
            title: 'Collection item',
            savedAt: now.subtract(const Duration(hours: 3)),
          ),
        );
        final collection = await endpoints.collection.create(
          alice,
          CollectionDraft(name: 'Soon', coverSeed: 1, paletteIndex: 0),
        );
        final session = alice.build();
        addTearDown(session.close);
        await ItemCollection.db.insertRow(
          session,
          ItemCollection(
            ownerId: item.ownerId,
            itemId: item.id!,
            collectionId: collection.id!,
          ),
        );
        await ReminderRule.db.insertRow(
          session,
          ReminderRule(
            ownerId: item.ownerId,
            collectionId: collection.id,
            delayHours: 2,
          ),
        );
        const service = ReviewQueueService();
        var queue = await service.build(
          session,
          ownerId: item.ownerId,
          timeBudgetMinutes: 10,
          now: now,
        );
        expect(queue.entries.single.item.id, item.id);

        await ItemReviewControl.db.insertRow(
          session,
          ItemReviewControl(
            ownerId: item.ownerId,
            itemId: item.id!,
            remindersPaused: true,
          ),
        );
        queue = await service.build(
          session,
          ownerId: item.ownerId,
          timeBudgetMinutes: 10,
          now: now,
        );
        expect(queue.entries, isEmpty);
      },
    );

    test(
      'ranking is priority, overdue age, fit, then deterministic id',
      () async {
        final now = DateTime.utc(2026, 10, 6, 12);
        for (final draft in [
          ItemDraft(
            title: 'Low old',
            priority: 0,
            contentType: ContentType.article,
            savedAt: now.subtract(const Duration(days: 4)),
          ),
          ItemDraft(
            title: 'High newer',
            priority: 4,
            contentType: ContentType.post,
            savedAt: now.subtract(const Duration(days: 2)),
          ),
          ItemDraft(
            title: 'High older',
            priority: 4,
            contentType: ContentType.video,
            savedAt: now.subtract(const Duration(days: 3)),
          ),
        ]) {
          await endpoints.item.create(alice, draft);
        }
        final session = alice.build();
        addTearDown(session.close);
        final owner = UuidValue.fromString(
          alice.build().authenticated!.userIdentifier,
        );
        final first = await const ReviewQueueService().build(
          session,
          ownerId: owner,
          timeBudgetMinutes: 20,
          now: now,
        );
        final second = await const ReviewQueueService().build(
          session,
          ownerId: owner,
          timeBudgetMinutes: 20,
          now: now,
        );
        expect(first.entries.map((e) => e.item.title), [
          'High older',
          'High newer',
        ]);
        expect(
          second.entries.map((e) => e.item.id),
          first.entries.map((e) => e.item.id),
        );
        expect(
          first.entries.every((e) => e.selectionReason.contains('estimate')),
          isTrue,
        );
      },
    );
  });
}
