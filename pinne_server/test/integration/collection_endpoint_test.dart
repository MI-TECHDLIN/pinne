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
          CollectionDraft(name: 'Bob only', coverSeed: 2, paletteIndex: 0),
        );
        await expectLater(
          endpoints.collection.create(
            alice,
            CollectionDraft(
              name: 'Sneaky',
              parentId: bobs.id,
              coverSeed: 3,
              paletteIndex: 1,
            ),
          ),
          throwsA(isA<RecordNotFoundException>()),
        );
      },
    );

    test('when a move would create a cycle then it is refused', () async {
      final parent = await endpoints.collection.create(
        alice,
        CollectionDraft(name: 'Flutter', coverSeed: 4, paletteIndex: 2),
      );
      final child = await endpoints.collection.create(
        alice,
        CollectionDraft(
          name: 'Layouts',
          parentId: parent.id,
          coverSeed: 5,
          paletteIndex: 3,
        ),
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
      await endpoints.collection.create(
        alice,
        CollectionDraft(name: 'A', coverSeed: 6, paletteIndex: 0),
      );
      await endpoints.collection.create(
        bob,
        CollectionDraft(name: 'B', coverSeed: 7, paletteIndex: 1),
      );
      final names = (await endpoints.collection.list(alice)).map((c) => c.name);
      expect(names, ['A']);
    });

    test('when cover fields are valid then they are persisted', () async {
      final collection = await endpoints.collection.create(
        alice,
        CollectionDraft(name: 'Aurora', coverSeed: 4242, paletteIndex: 4),
      );

      expect(collection.coverSeed, 4242);
      expect(collection.paletteIndex, 4);
    });

    test('when palette is outside the allow-list then it is refused', () {
      return expectLater(
        endpoints.collection.create(
          alice,
          CollectionDraft(name: 'Invalid', coverSeed: 1, paletteIndex: 5),
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('when cover seed is negative then it is refused', () {
      return expectLater(
        endpoints.collection.create(
          alice,
          CollectionDraft(name: 'Invalid', coverSeed: -1, paletteIndex: 0),
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
