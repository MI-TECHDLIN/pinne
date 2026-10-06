import 'package:pinne_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the collection endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;

    setUp(() async {
      alice = await signedInAs(sessionBuilder);
      bob = await signedInAs(sessionBuilder);
    });

    test(
      'when nesting under another user\'s collection then it is refused',
      () async {
        final bobs = await endpoints.collection.create(
          bob,
          CollectionDraft(name: 'Bob only'),
        );
        await expectLater(
          endpoints.collection.create(
            alice,
            CollectionDraft(name: 'Sneaky', parentId: bobs.id),
          ),
          throwsA(isA<RecordNotFoundException>()),
        );
      },
    );

    test('when a move would create a cycle then it is refused', () async {
      final parent = await endpoints.collection.create(
        alice,
        CollectionDraft(name: 'Flutter'),
      );
      final child = await endpoints.collection.create(
        alice,
        CollectionDraft(name: 'Layouts', parentId: parent.id),
      );
      await expectLater(
        endpoints.collection.update(
          alice,
          parent.copyWith(parentId: child.id),
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('when listing then only own collections are returned', () async {
      await endpoints.collection.create(alice, CollectionDraft(name: 'A'));
      await endpoints.collection.create(bob, CollectionDraft(name: 'B'));
      final names = (await endpoints.collection.list(alice)).map((c) => c.name);
      expect(names, ['A']);
    });
  });
}
