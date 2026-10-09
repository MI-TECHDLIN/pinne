import 'package:pinne_server/src/generated/protocol.dart';
import 'package:pinne_server/src/link_previews/link_preview_parser.dart';
import 'package:pinne_server/src/link_previews/link_preview_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given link preview processing', (sessionBuilder, endpoints) {
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;
    late UuidValue aliceId;
    late UuidValue bobId;

    setUp(() async {
      alice = await signedInAs(sessionBuilder);
      bob = await signedInAs(sessionBuilder);
      aliceId = UuidValue.fromString(
        alice.build().authenticated!.userIdentifier,
      );
      bobId = UuidValue.fromString(bob.build().authenticated!.userIdentifier);
    });

    Future<Item> insert({
      required String title,
      bool manual = false,
      UuidValue? owner,
      TestSessionBuilder? session,
    }) => Item.db.insertRow(
      (session ?? alice).build(),
      Item(
        ownerId: owner ?? aliceId,
        url: 'https://example.com/article',
        canonicalUrl: 'https://example.com/article',
        title: title,
        titleManuallyLocked: manual,
      ),
    );

    test('job is idempotent, protects manual title, and requeues AI', () async {
      var loads = 0;
      final item = await insert(title: 'My chosen title', manual: true);
      final service = LinkPreviewService(
        loader: (uri) async {
          loads++;
          return PreviewLoadResult(
            accessState: AccessState.available,
            preview: LinkPreview(
              title: 'Remote title',
              description: 'Useful extracted evidence.',
              author: 'Author',
              siteName: 'Example',
              thumbnailUrl: Uri.parse('https://images.example.com/one.jpg'),
              durationSeconds: 90,
              metadata: const {'source': 'fixture'},
            ),
          );
        },
      );

      await service.process(
        alice.build(),
        ownerId: aliceId,
        itemId: item.id!,
      );
      await service.process(
        alice.build(),
        ownerId: aliceId,
        itemId: item.id!,
      );

      expect(loads, 1);
      final stored = await Item.db.findById(alice.build(), item.id!);
      expect(stored?.title, 'My chosen title');
      expect(stored?.previewDescription, 'Useful extracted evidence.');
      expect(stored?.durationSeconds, 90);
      expect(stored?.enrichmentState, EnrichmentState.ready);
      expect(stored?.accessState, AccessState.available);
      final task = await AiOrganizeTask.db.findFirstRow(
        alice.build(),
        where: (t) => t.itemId.equals(item.id!),
      );
      expect(task, isNotNull, reason: 'better evidence triggers AI organizing');
    });

    test('a foreign owner cannot claim or mutate the item', () async {
      var loads = 0;
      final item = await insert(title: 'Alice only');
      final service = LinkPreviewService(
        loader: (uri) async {
          loads++;
          return const PreviewLoadResult(accessState: AccessState.available);
        },
      );
      await service.process(
        bob.build(),
        ownerId: bobId,
        itemId: item.id!,
      );

      expect(loads, 0);
      final stored = await Item.db.findById(alice.build(), item.id!);
      expect(stored?.enrichmentState, EnrichmentState.pending);
    });

    test('retryable failures stop after the bounded attempt count', () async {
      var loads = 0;
      final item = await insert(title: 'Retry me');
      final service = LinkPreviewService(
        maxAttempts: 3,
        loader: (_) async {
          loads++;
          return const PreviewLoadResult(
            accessState: AccessState.unknown,
            retryable: true,
          );
        },
      );
      for (var attempt = 0; attempt < 3; attempt++) {
        await service.process(
          alice.build(),
          ownerId: aliceId,
          itemId: item.id!,
        );
      }

      final stored = await Item.db.findById(alice.build(), item.id!);
      expect(loads, 3);
      expect(stored?.previewAttemptCount, 3);
      expect(stored?.enrichmentState, EnrichmentState.failed);
    });

    test(
      'unavailable preview preserves the link and fabricates no summary',
      () async {
        final item = await insert(title: 'example.com/article');
        final service = LinkPreviewService(
          loader: (_) async => const PreviewLoadResult(
            accessState: AccessState.unavailable,
          ),
        );
        await service.process(
          alice.build(),
          ownerId: aliceId,
          itemId: item.id!,
        );

        final stored = await Item.db.findById(alice.build(), item.id!);
        expect(stored, isNotNull);
        expect(stored?.url, 'https://example.com/article');
        expect(stored?.summary, isNull);
        expect(stored?.accessState, AccessState.unavailable);
        expect(stored?.enrichmentState, EnrichmentState.failed);
      },
    );

    test(
      'refreshPreview is owner-scoped and returns immediately pending',
      () async {
        final item = await insert(title: 'Refresh me');
        await expectLater(
          endpoints.item.refreshPreview(bob, item.id!),
          throwsA(isA<RecordNotFoundException>()),
        );
        final refreshed = await endpoints.item.refreshPreview(alice, item.id!);
        expect(refreshed.enrichmentState, EnrichmentState.pending);
        expect(refreshed.previewAttemptCount, 0);
      },
    );
  });
}
