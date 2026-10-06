import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the item endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;

    setUp(() async {
      alice = await signedInAs(sessionBuilder);
      bob = await signedInAs(sessionBuilder);
    });

    test('when signed out then every call is rejected', () async {
      final signedOut = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );
      await expectLater(
        endpoints.item.list(signedOut),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('when creating then the owner comes from the session', () async {
      final item = await endpoints.item.create(
        alice,
        ItemDraft(title: 'Sidebar pattern', url: 'https://x.com/a/1'),
      );
      final aliceId = alice.build().authenticated!.userIdentifier;
      expect(item.ownerId.uuid, aliceId);
      expect(item.revision, 1);
      expect(item.lifecycle, ItemLifecycle.active);
    });

    test('when another user asks for the item then it is invisible', () async {
      final item = await endpoints.item.create(
        alice,
        ItemDraft(title: 'Private'),
      );

      expect(await endpoints.item.get(bob, item.id!), isNull);
      expect(await endpoints.item.list(bob), isEmpty);
      expect(await endpoints.item.delete(bob, item.id!), isFalse);
      await expectLater(
        endpoints.item.update(bob, item.copyWith(title: 'Mine now')),
        throwsA(isA<RecordNotFoundException>()),
      );
      expect((await endpoints.item.get(alice, item.id!))!.title, 'Private');
    });

    test('when updating with a stale revision then it is refused', () async {
      final item = await endpoints.item.create(alice, ItemDraft(title: 'v1'));
      final updated = await endpoints.item.update(
        alice,
        item.copyWith(title: 'v2'),
      );
      expect(updated.revision, 2);

      await expectLater(
        endpoints.item.update(alice, item.copyWith(title: 'stale')),
        throwsA(isA<ValidationException>()),
      );
    });

    test('when the client sends a foreign owner then it is ignored', () async {
      final item = await endpoints.item.create(alice, ItemDraft(title: 'a'));
      final bobId = bob.build().authenticated!.userIdentifier;
      final updated = await endpoints.item.update(
        alice,
        item.copyWith(ownerId: UuidValue.fromString(bobId)),
      );
      expect(updated.ownerId, item.ownerId);
    });
  });
}
