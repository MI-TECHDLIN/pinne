import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Review events',
    (sessionBuilder, endpoints) {
      late TestSessionBuilder alice;
      late TestSessionBuilder bob;

      setUp(() async {
        alice = await signedInAs(sessionBuilder);
        bob = await signedInAs(sessionBuilder);
      });

      ReviewEventDraft event(
        Item item,
        String clientId,
        ReviewEventType type, {
        DateTime? at,
        UuidValue? compensates,
      }) => ReviewEventDraft(
        clientEventId: clientId,
        itemId: item.id!,
        eventType: type,
        occurredAt: at ?? DateTime.utc(2026, 10, 5, 23, 30),
        timezone: 'Africa/Nairobi',
        timezoneOffsetMinutes: 180,
        compensatesEventId: compensates,
      );

      test('opening is idempotent and never counts as a review', () async {
        final item = await endpoints.item.create(
          alice,
          ItemDraft(title: 'A useful post'),
        );
        final draft = event(item, 'open-1', ReviewEventType.opened);
        final first = await endpoints.review.record(alice, draft);
        final replay = await endpoints.review.record(alice, draft);
        expect(replay.event.id, first.event.id);
        expect(replay.progress.openCount, 1);
        expect(replay.progress.firstReviewedAt, isNull);

        final second = await endpoints.review.record(
          alice,
          event(
            item,
            'open-2',
            ReviewEventType.opened,
            at: DateTime.utc(2026, 10, 6),
          ),
        );
        expect(second.progress.openCount, 2);
        expect(second.progress.firstReviewedAt, isNull);
        expect(first.event.effectiveLocalDate, '2026-10-06');
      });

      test('completed qualifies once, and undo rebuilds progress', () async {
        final item = await endpoints.item.create(
          alice,
          ItemDraft(title: 'Course'),
        );
        final completed = await endpoints.review.record(
          alice,
          event(item, 'complete-1', ReviewEventType.completed),
        );
        expect(completed.progress.completedAt, isNotNull);
        expect(completed.progress.firstReviewedAt, completed.event.occurredAt);

        final undone = await endpoints.review.record(
          alice,
          event(
            item,
            'undo-1',
            ReviewEventType.undo,
            compensates: completed.event.id,
          ),
        );
        expect(undone.progress.completedAt, isNull);
        expect(undone.progress.firstReviewedAt, isNull);

        final reviewed = await endpoints.review.record(
          alice,
          event(item, 'review-1', ReviewEventType.reviewed),
        );
        await endpoints.review.record(
          alice,
          event(item, 'review-2', ReviewEventType.reviewed),
        );
        final projection = await endpoints.review.progress(alice, item.id!);
        expect(projection!.firstReviewedAt, reviewed.event.occurredAt);
      });

      test('foreign item and reused client ids reveal nothing', () async {
        final item = await endpoints.item.create(
          alice,
          ItemDraft(title: 'Private'),
        );
        await expectLater(
          endpoints.review.record(
            bob,
            event(item, 'foreign', ReviewEventType.reviewed),
          ),
          throwsA(isA<RecordNotFoundException>()),
        );
        await endpoints.review.record(
          alice,
          event(item, 'stable', ReviewEventType.reviewed),
        );
        await expectLater(
          endpoints.review.record(
            alice,
            event(item, 'stable', ReviewEventType.opened),
          ),
          throwsA(isA<ValidationException>()),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
