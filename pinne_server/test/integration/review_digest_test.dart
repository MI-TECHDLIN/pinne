import 'package:pinne_server/src/generated/protocol.dart';
import 'package:pinne_server/src/reminders/review_digest_service.dart';
import 'package:pinne_server/src/reviews/review_queue_service.dart';
import 'package:pinne_server/src/reviews/review_service.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Review digests',
    (sessionBuilder, endpoints) {
      late TestSessionBuilder alice;
      setUp(() async => alice = await signedInAs(sessionBuilder));

      test(
        'quiet hours defer and the stable window key deduplicates',
        () async {
          final owner = UuidValue.fromString(
            alice.build().authenticated!.userIdentifier,
          );
          await endpoints.item.create(
            alice,
            ItemDraft(
              title: 'Due idea',
              savedAt: DateTime.utc(2026, 10, 4),
            ),
          );
          await endpoints.reviewQueue.updateSettings(
            alice,
            ReminderSettingsDraft(
              delayHours: 24,
              timezone: 'UTC',
              timezoneOffsetMinutes: 0,
              quietStartMinute: 22 * 60,
              quietEndMinute: 7 * 60,
              dailyCap: 2,
              remindersPaused: false,
              queueLimit: 5,
              dismissCooldownMinutes: 120,
            ),
          );
          final session = alice.build();
          addTearDown(session.close);
          const service = ReviewDigestService();
          expect(
            await service.recomputeOwner(
              session,
              owner,
              now: DateTime.utc(2026, 10, 6, 23),
            ),
            isNull,
          );
          final first = await service.recomputeOwner(
            session,
            owner,
            now: DateTime.utc(2026, 10, 7, 8),
          );
          expect(first, isNotNull);
          expect(first!.body, contains('Have a few minutes'));
          await service.recomputeOwner(
            session,
            owner,
            now: DateTime.utc(2026, 10, 7, 8),
          );
          expect(
            await ReviewDigest.db.count(
              session,
              where: (t) => t.ownerId.equals(owner),
            ),
            1,
          );
        },
      );

      test(
        'final eligibility removes an item reviewed before digest',
        () async {
          final item = await endpoints.item.create(
            alice,
            ItemDraft(
              title: 'Reviewed just in time',
              savedAt: DateTime.utc(2026, 10, 4),
            ),
          );
          final session = alice.build();
          addTearDown(session.close);
          await const ReviewService().record(
            session,
            item.ownerId,
            ReviewEventDraft(
              clientEventId: 'review-before-digest',
              itemId: item.id!,
              eventType: ReviewEventType.reviewed,
              occurredAt: DateTime.utc(2026, 10, 6, 8),
              timezone: 'UTC',
              timezoneOffsetMinutes: 0,
            ),
          );
          expect(
            await const ReviewDigestService().recomputeOwner(
              session,
              item.ownerId,
              now: DateTime.utc(2026, 10, 6, 9),
            ),
            isNull,
          );
        },
      );

      test('ten due saves produce one capped grouped digest', () async {
        final owner = UuidValue.fromString(
          alice.build().authenticated!.userIdentifier,
        );
        for (var i = 0; i < 10; i++) {
          await endpoints.item.create(
            alice,
            ItemDraft(
              title: 'Due idea $i',
              savedAt: DateTime.utc(2026, 10, 4),
            ),
          );
        }
        await endpoints.reviewQueue.updateSettings(
          alice,
          ReminderSettingsDraft(
            delayHours: 24,
            timezone: 'UTC',
            timezoneOffsetMinutes: 0,
            dailyCap: 1,
            remindersPaused: false,
            queueLimit: 3,
            dismissCooldownMinutes: 120,
          ),
        );
        final session = alice.build();
        addTearDown(session.close);
        final queue = await const ReviewQueueService().build(
          session,
          ownerId: owner,
          timeBudgetMinutes: 20,
          now: DateTime.utc(2026, 10, 7, 9),
        );
        expect(queue.eligibleCount, 10);
        expect(queue.entries.length, lessThanOrEqualTo(3));

        final service = const ReviewDigestService();
        final first = await service.recomputeOwner(
          session,
          owner,
          now: DateTime.utc(2026, 10, 7, 9),
        );
        expect(first!.itemCount, 10);
        expect(first.body, contains('ten saved ideas'));
        expect(
          await service.recomputeOwner(
            session,
            owner,
            now: DateTime.utc(2026, 10, 7, 10),
          ),
          isNull,
        );
      });

      test('explicit delivery windows gate and deduplicate a digest', () async {
        final item = await endpoints.item.create(
          alice,
          ItemDraft(
            title: 'Windowed idea',
            savedAt: DateTime.utc(2026, 10, 4),
          ),
        );
        final session = alice.build();
        addTearDown(session.close);
        await ReminderRule.db.insertRow(
          session,
          ReminderRule(
            ownerId: item.ownerId,
            delayHours: 24,
            deliveryWindows: [
              ReminderWindow(
                startMinute: 8 * 60,
                endMinute: 10 * 60,
                weekdays: [3],
              ),
            ],
          ),
        );
        const service = ReviewDigestService();
        expect(
          await service.recomputeOwner(
            session,
            item.ownerId,
            now: DateTime.utc(2026, 10, 7, 7),
          ),
          isNull,
        );
        final first = await service.recomputeOwner(
          session,
          item.ownerId,
          now: DateTime.utc(2026, 10, 7, 8),
        );
        final repeat = await service.recomputeOwner(
          session,
          item.ownerId,
          now: DateTime.utc(2026, 10, 7, 9),
        );
        expect(first, isNotNull);
        expect(repeat?.id, first?.id);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
