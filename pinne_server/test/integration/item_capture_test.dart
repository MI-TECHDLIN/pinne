import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show Uuid, UuidValue;
import 'package:test/test.dart';
import 'package:serverpod_auth_idp_server/core.dart' show AuthUser;

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

UuidValue _id() => const Uuid().v4obj();

CaptureDraft _draft({
  UuidValue? clientItemId,
  UuidValue? operationId,
  String? url,
  String? text,
  String? title,
  String? intention,
  List<UuidValue>? collectionIds,
  DateTime? capturedAt,
}) => CaptureDraft(
  clientItemId: clientItemId ?? _id(),
  operationId: operationId ?? _id(),
  url: url,
  text: text,
  title: title,
  intention: intention,
  collectionIds: collectionIds,
  capturedAt: capturedAt ?? DateTime.utc(2026, 10, 5, 22),
);

void main() {
  withServerpod('Given the item capture method', (sessionBuilder, endpoints) {
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;

    setUp(() async {
      alice = await signedInAs(sessionBuilder);
      bob = await signedInAs(sessionBuilder);
    });

    Future<List<Item>> itemsOf(TestSessionBuilder who) =>
        endpoints.item.list(who);

    test('when signed out then the capture is rejected', () async {
      final signedOut = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );
      await expectLater(
        endpoints.item.capture(
          signedOut,
          _draft(url: 'https://x.com/a/status/1'),
        ),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test(
      'when capturing a link then it is saved, pending and normalized',
      () async {
        final clientItemId = _id();
        final result = await endpoints.item.capture(
          alice,
          _draft(
            clientItemId: clientItemId,
            url: 'https://twitter.com/Someone/status/1844123456789012345?s=20',
            intention: 'Try this in my dashboard',
          ),
        );

        expect(result.duplicate, isFalse);
        expect(result.duplicateOf, isNull);
        expect(result.clientItemId, clientItemId);
        expect(result.revision, 1);
        expect(result.sourcePlatform, SourcePlatform.x);
        expect(result.sourceItemId, '1844123456789012345');
        expect(
          result.canonicalUrl,
          'https://x.com/someone/status/1844123456789012345',
        );
        expect(result.enrichmentState, EnrichmentState.pending);
        expect(result.savedAt, DateTime.utc(2026, 10, 5, 22));
        expect(result.title, 'x.com/someone/status/1844123456789012345');

        final item = (await endpoints.item.get(alice, result.itemId))!;
        final aliceId = alice.build().authenticated!.userIdentifier;
        expect(item.ownerId.uuid, aliceId);
        expect(item.clientItemId, clientItemId);
        expect(item.intention, 'Try this in my dashboard');
        expect(item.contentType, ContentType.post);
        expect(item.accessState, AccessState.unknown);
        expect(item.url, 'https://x.com/someone/status/1844123456789012345');
      },
    );

    test('when capturing text then it becomes a note', () async {
      final result = await endpoints.item.capture(
        alice,
        _draft(text: 'Use a rail on wide screens\nand a pill nav on phones'),
      );
      final item = (await endpoints.item.get(alice, result.itemId))!;
      expect(result.sourcePlatform, SourcePlatform.note);
      expect(item.title, 'Use a rail on wide screens');
      expect(item.noteText, contains('pill nav'));
      expect(item.url, isNull);
      expect(item.contentType, ContentType.note);
      expect(item.accessState, AccessState.available);
    });

    test('when shared text holds a link then the link is saved', () async {
      final result = await endpoints.item.capture(
        alice,
        _draft(text: 'Great walkthrough https://youtu.be/dQw4w9WgXcQ?si=abc'),
      );
      expect(result.sourcePlatform, SourcePlatform.youtube);
      expect(result.sourceItemId, 'dQw4w9WgXcQ');
      expect(result.title, 'Great walkthrough');
    });

    test('when the user gave a title then it is kept', () async {
      final result = await endpoints.item.capture(
        alice,
        _draft(url: 'https://example.com/post', title: '  Sidebar pattern '),
      );
      expect(result.title, 'Sidebar pattern');
    });

    test(
      'when an ambiguous short link is captured then it is unknown',
      () async {
        final result = await endpoints.item.capture(
          alice,
          _draft(url: 'https://bit.ly/3xYzAbC'),
        );
        expect(result.sourcePlatform, SourcePlatform.unknown);
        expect(result.sourceItemId, isNull);
        expect(result.canonicalUrl, 'https://bit.ly/3xYzAbC');
      },
    );

    test(
      'when the same operation is retried then one item is returned',
      () async {
        final draft = _draft(
          url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
          intention: 'Watch the motion part',
        );

        final first = await endpoints.item.capture(alice, draft);
        final second = await endpoints.item.capture(alice, draft);
        final third = await endpoints.item.capture(alice, draft);

        expect(second.itemId, first.itemId);
        expect(third.itemId, first.itemId);
        expect(second.duplicate, isFalse);
        expect(third.revision, first.revision);
        final items = await itemsOf(alice);
        expect(items, hasLength(1));
        expect(items.single.intention, 'Watch the motion part');
      },
    );

    test(
      'when an operation id is reused for other content then it is refused',
      () async {
        final operationId = _id();
        final clientItemId = _id();
        await endpoints.item.capture(
          alice,
          _draft(
            operationId: operationId,
            clientItemId: clientItemId,
            url: 'https://example.com/one',
          ),
        );
        await expectLater(
          endpoints.item.capture(
            alice,
            _draft(
              operationId: operationId,
              clientItemId: clientItemId,
              url: 'https://example.com/two',
            ),
          ),
          throwsA(isA<ValidationException>()),
        );
        expect(await itemsOf(alice), hasLength(1));
      },
    );

    test(
      'when a client item is resent under a new operation id then it maps to the same item',
      () async {
        final clientItemId = _id();
        final first = await endpoints.item.capture(
          alice,
          _draft(clientItemId: clientItemId, url: 'https://example.com/a'),
        );
        final again = await endpoints.item.capture(
          alice,
          _draft(clientItemId: clientItemId, url: 'https://example.com/a'),
        );
        expect(again.itemId, first.itemId);
        expect(again.duplicate, isFalse);
        expect(await itemsOf(alice), hasLength(1));
      },
    );

    test(
      'when a duplicate arrives with other tracking params then the existing item is kept',
      () async {
        final collection = await endpoints.collection.create(
          alice,
          CollectionDraft(name: 'Flutter UI', coverSeed: 1, paletteIndex: 0),
        );
        final first = await endpoints.item.capture(
          alice,
          _draft(
            url: 'https://youtu.be/dQw4w9WgXcQ?si=FirstShare',
            title: 'Adaptive navigation rail',
            intention: 'Try the rail pattern',
            collectionIds: [collection.id!],
            capturedAt: DateTime.utc(2026, 10, 1, 9),
          ),
        );

        final repeat = await endpoints.item.capture(
          alice,
          _draft(
            url:
                'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
                '&feature=shared&utm_source=newsletter&t=42',
            intention: 'Check the 0:42 part',
            capturedAt: DateTime.utc(2026, 10, 5, 22),
          ),
        );

        expect(repeat.duplicate, isTrue);
        expect(repeat.duplicateOf, first.itemId);
        expect(repeat.itemId, first.itemId);
        expect(repeat.savedAt, DateTime.utc(2026, 10, 1, 9));
        expect(repeat.revision, first.revision + 1);

        final item = (await endpoints.item.get(alice, first.itemId))!;
        expect(item.title, 'Adaptive navigation rail');
        expect(item.intention, 'Try the rail pattern\n\nCheck the 0:42 part');
        expect(item.savedAt, DateTime.utc(2026, 10, 1, 9));
        expect(await itemsOf(alice), hasLength(1));

        final memberships = await ItemCollection.db.find(
          alice.build(),
          where: (t) => t.itemId.equals(first.itemId),
        );
        expect(memberships.map((m) => m.collectionId), [collection.id]);
        expect(memberships.single.manuallyLocked, isTrue);

        final replay = await endpoints.item.capture(
          alice,
          _draft(
            url: 'https://youtu.be/dQw4w9WgXcQ?si=FirstShare',
            title: 'Adaptive navigation rail',
            intention: 'Try the rail pattern',
            collectionIds: [collection.id!],
            capturedAt: DateTime.utc(2026, 10, 1, 9),
          ),
        );
        expect(replay.duplicate, isTrue, reason: 'new operation, same video');
        expect(
          (await endpoints.item.get(alice, first.itemId))!.intention,
          'Try the rail pattern\n\nCheck the 0:42 part',
          reason: 'a note already present is not appended twice',
        );
      },
    );

    test('when a duplicate is retried then it stays a duplicate', () async {
      await endpoints.item.capture(
        alice,
        _draft(url: 'https://example.com/post?b=2&a=1'),
      );
      final draft = _draft(
        url: 'https://www.example.com/post/?a=1&b=2&fbclid=abc',
        intention: 'second thoughts',
      );
      final first = await endpoints.item.capture(alice, draft);
      final retry = await endpoints.item.capture(alice, draft);

      expect(first.duplicate, isTrue);
      expect(retry.duplicate, isTrue);
      expect(retry.itemId, first.itemId);
      expect(retry.revision, first.revision);
      final items = await itemsOf(alice);
      expect(items.single.intention, 'second thoughts');
    });

    test(
      'when another user captures the same link then each owns a separate item',
      () async {
        final operationId = _id();
        final clientItemId = _id();
        final draft = _draft(
          operationId: operationId,
          clientItemId: clientItemId,
          url: 'https://www.instagram.com/p/C9xYz12AbCd/',
        );
        final mine = await endpoints.item.capture(alice, draft);
        final theirs = await endpoints.item.capture(bob, draft);

        expect(theirs.itemId, isNot(mine.itemId));
        expect(theirs.duplicate, isFalse);
        expect(await itemsOf(alice), hasLength(1));
        expect(await itemsOf(bob), hasLength(1));
        expect(await endpoints.item.get(bob, mine.itemId), isNull);
      },
    );

    test(
      'when capturing into a foreign collection then it is not found',
      () async {
        final aliceCollection = await endpoints.collection.create(
          alice,
          CollectionDraft(name: 'Private', coverSeed: 2, paletteIndex: 1),
        );
        await expectLater(
          endpoints.item.capture(
            bob,
            _draft(
              url: 'https://example.com/x',
              collectionIds: [aliceCollection.id!],
            ),
          ),
          throwsA(isA<RecordNotFoundException>()),
        );
        expect(await itemsOf(bob), isEmpty);
      },
    );

    test('when the capture is empty or malformed then it is refused', () async {
      for (final draft in [
        _draft(),
        _draft(text: '   '),
        _draft(url: 'not a link'),
        _draft(url: 'https://example.com/a', title: 'x' * 301),
        _draft(
          text: 'note',
          collectionIds: [for (var i = 0; i < 21; i++) _id()],
        ),
      ]) {
        await expectLater(
          endpoints.item.capture(alice, draft),
          throwsA(isA<ValidationException>()),
        );
      }
      expect(await itemsOf(alice), isEmpty);
    });

    test(
      'when the device clock is far ahead then savedAt is the server time',
      () async {
        final before = DateTime.now().toUtc();
        final result = await endpoints.item.capture(
          alice,
          _draft(
            url: 'https://example.com/future',
            capturedAt: DateTime.now().toUtc().add(const Duration(days: 3)),
          ),
        );
        expect(
          result.savedAt.isBefore(before.add(const Duration(minutes: 1))),
          isTrue,
        );
      },
    );
  });

  // Real concurrent transactions need the test rollback switched off, so this
  // group removes what it created.
  withServerpod(
    'Given concurrent captures',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, endpoints) {
      late TestSessionBuilder alice;

      setUp(() async {
        alice = await signedInAs(sessionBuilder);
      });

      tearDown(() async {
        final session = alice.build();
        await AuthUser.db.deleteWhere(
          session,
          where: (t) => t.id.equals(
            UuidValue.fromString(session.authenticated!.userIdentifier),
          ),
        );
      });

      test('when retries race then one item and one receipt exist', () async {
        final draft = _draft(url: 'https://example.com/race');
        final results = await Future.wait([
          for (var i = 0; i < 4; i++) endpoints.item.capture(alice, draft),
        ]);
        expect(results.map((r) => r.itemId).toSet(), hasLength(1));
        expect(results.where((r) => r.duplicate), isEmpty);
        expect(await endpoints.item.list(alice), hasLength(1));
      });

      test('when two shares of one item race then one item exists', () async {
        final results = await Future.wait([
          endpoints.item.capture(
            alice,
            _draft(url: 'https://youtu.be/dQw4w9WgXcQ?si=one'),
          ),
          endpoints.item.capture(
            alice,
            _draft(url: 'https://www.youtube.com/shorts/dQw4w9WgXcQ'),
          ),
        ]);
        expect(results.map((r) => r.itemId).toSet(), hasLength(1));
        expect(results.where((r) => r.duplicate), hasLength(1));
        expect(await endpoints.item.list(alice), hasLength(1));
      });
    },
  );
}
