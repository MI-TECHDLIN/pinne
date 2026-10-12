import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Starter hosting without future calls',
    (sessionBuilder, endpoints) {
      late TestSessionBuilder owner;

      setUp(() async {
        owner = await signedInAs(sessionBuilder);
      });

      CaptureDraft draft({String? url, String? text}) => CaptureDraft(
        clientItemId: const Uuid().v4obj(),
        operationId: const Uuid().v4obj(),
        url: url,
        text: text,
        capturedAt: DateTime.utc(2026, 10, 12),
      );

      test(
        'links save and review without leaving preview work pending',
        () async {
          final saved = await endpoints.item.capture(
            owner,
            draft(url: 'https://example.com/article'),
          );
          expect(saved.enrichmentState, EnrichmentState.failed);
          final item = (await endpoints.item.get(owner, saved.itemId))!;
          expect(item.enrichmentState, EnrichmentState.failed);
          expect(item.revision, saved.revision);

          final review = await endpoints.review.record(
            owner,
            ReviewEventDraft(
              clientEventId: 'starter-review',
              itemId: item.id!,
              eventType: ReviewEventType.completed,
              occurredAt: DateTime.utc(2026, 10, 12, 12),
              timezone: 'Africa/Lagos',
              timezoneOffsetMinutes: 60,
            ),
          );
          expect(review.progress.completedAt, isNotNull);

          await expectLater(
            endpoints.item.refreshPreview(owner, item.id!),
            throwsA(isA<ValidationException>()),
          );
        },
      );

      test(
        'notes are immediately ready and AI settings are unavailable',
        () async {
          final saved = await endpoints.item.capture(
            owner,
            draft(text: 'Read the saved article later'),
          );
          expect(saved.enrichmentState, EnrichmentState.ready);

          final settings = await endpoints.aiOrganizing.getSettings(owner);
          expect(settings.available, isFalse);
          expect(settings.enabled, isFalse);
          final attempted = await endpoints.aiOrganizing.setEnabled(
            owner,
            true,
          );
          expect(attempted.available, isFalse);
          expect(attempted.enabled, isFalse);
          await expectLater(
            endpoints.aiOrganizing.reprocess(owner, saved.itemId),
            throwsA(isA<ValidationException>()),
          );
        },
      );
    },
    configOverride: (config) => config.copyWith(
      futureCall: const FutureCallConfig(enabled: false),
    ),
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
