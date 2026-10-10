import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:serverpod_auth_idp_server/core.dart' show AuthUser;
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given optional example saves', (sessionBuilder, endpoints) {
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;

    setUp(() async {
      alice = await signedInAs(sessionBuilder);
      bob = await signedInAs(sessionBuilder);
    });

    test('seeding is owner-scoped, labelled and idempotent', () async {
      final first = await endpoints.exampleSaves.seed(alice);
      final second = await endpoints.exampleSaves.seed(alice);

      expect(first.exampleItemCount, 6);
      expect(first.exampleCollectionCount, 2);
      expect(second.exampleItemCount, 6);
      final bobStatus = await endpoints.exampleSaves.status(bob);
      expect(bobStatus.totalItemCount, 0);
      expect(bobStatus.exampleItemCount, 0);
      expect(bobStatus.exampleCollectionCount, 0);

      final items = await endpoints.item.list(alice);
      final collections = await endpoints.collection.list(alice);
      expect(items, hasLength(6));
      expect(items.every((item) => item.isExample), isTrue);
      expect(collections, hasLength(2));
      expect(collections.every((collection) => collection.isExample), isTrue);
    });

    test('removal deletes only this owner examples', () async {
      await endpoints.exampleSaves.seed(alice);
      await endpoints.exampleSaves.seed(bob);
      await endpoints.item.create(alice, ItemDraft(title: 'My real save'));

      final status = await endpoints.exampleSaves.remove(alice);

      expect(status.totalItemCount, 1);
      expect(status.exampleItemCount, 0);
      expect((await endpoints.item.list(alice)).single.title, 'My real save');
      expect((await endpoints.item.list(bob)), hasLength(6));
    });

    test('signed-out calls are rejected', () async {
      final signedOut = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );
      await expectLater(
        endpoints.exampleSaves.seed(signedOut),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });

  withServerpod(
    'Given concurrent example seed retries',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, endpoints) {
      late TestSessionBuilder alice;

      setUp(() async => alice = await signedInAs(sessionBuilder));

      tearDown(() async {
        final session = alice.build();
        await AuthUser.db.deleteWhere(
          session,
          where: (t) => t.id.equals(
            UuidValue.fromString(session.authenticated!.userIdentifier),
          ),
        );
      });

      test('one starter set is created', () async {
        final results = await Future.wait([
          endpoints.exampleSaves.seed(alice),
          endpoints.exampleSaves.seed(alice),
          endpoints.exampleSaves.seed(alice),
        ]);

        expect(
          results.every((status) => status.exampleItemCount == 6),
          isTrue,
        );
        expect(await endpoints.item.list(alice), hasLength(6));
        expect(await endpoints.collection.list(alice), hasLength(2));
      });
    },
  );
}
