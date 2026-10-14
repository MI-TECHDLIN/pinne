import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;
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

    test('names are trimmed and unique per owner, ignoring case', () async {
      final created = await endpoints.collection.create(
        alice,
        CollectionDraft(
          name: '  UI   inspiration ',
          description: '   ',
          coverSeed: 1,
          paletteIndex: 0,
        ),
      );
      expect(created.name, 'UI inspiration');
      expect(created.description, isNull);

      await expectLater(
        endpoints.collection.create(
          alice,
          CollectionDraft(
            name: 'ui INSPIRATION',
            coverSeed: 2,
            paletteIndex: 1,
          ),
        ),
        throwsA(isA<ValidationException>()),
      );
      await expectLater(
        endpoints.collection.create(
          alice,
          CollectionDraft(name: '   ', coverSeed: 2, paletteIndex: 1),
        ),
        throwsA(isA<ValidationException>()),
      );
      // Another owner may use the same name.
      final bobs = await endpoints.collection.create(
        bob,
        CollectionDraft(name: 'UI inspiration', coverSeed: 3, paletteIndex: 2),
      );
      expect(bobs.name, 'UI inspiration');
    });

    test('renaming onto another collection\'s name is refused, recolouring '
        'and keeping the name is not', () async {
      final design = await endpoints.collection.create(
        alice,
        CollectionDraft(name: 'Design', coverSeed: 1, paletteIndex: 0),
      );
      await endpoints.collection.create(
        alice,
        CollectionDraft(name: 'Recipes', coverSeed: 2, paletteIndex: 1),
      );

      await expectLater(
        endpoints.collection.update(alice, design.copyWith(name: 'recipes')),
        throwsA(isA<ValidationException>()),
      );
      final recoloured = await endpoints.collection.update(
        alice,
        design.copyWith(paletteIndex: 3, description: 'Screens I like'),
      );
      expect(recoloured.paletteIndex, 3);
      expect(recoloured.name, 'Design');
      expect(recoloured.description, 'Screens I like');
    });

    test('deleting a collection keeps its saves', () async {
      final collection = await endpoints.collection.create(
        alice,
        CollectionDraft(name: 'Temporary', coverSeed: 1, paletteIndex: 0),
      );
      final ownerId = UuidValue.fromString(
        alice.build().authenticated!.userIdentifier,
      );
      final item = await Item.db.insertRow(
        alice.build(),
        Item(ownerId: ownerId, title: 'Keep me'),
      );
      await ItemCollection.db.insertRow(
        alice.build(),
        ItemCollection(
          ownerId: ownerId,
          itemId: item.id!,
          collectionId: collection.id!,
        ),
      );
      expect(
        (await endpoints.collection.summaries(alice)).single.itemCount,
        1,
      );

      expect(await endpoints.collection.delete(alice, collection.id!), isTrue);

      expect(await endpoints.item.get(alice, item.id!), isNotNull);
      expect(await endpoints.collection.summaries(alice), isEmpty);
    });

    test('removing an item from a collection keeps the item', () async {
      final collection = await endpoints.collection.create(
        alice,
        CollectionDraft(name: 'Reading', coverSeed: 1, paletteIndex: 0),
      );
      final ownerId = UuidValue.fromString(
        alice.build().authenticated!.userIdentifier,
      );
      final item = await Item.db.insertRow(
        alice.build(),
        Item(ownerId: ownerId, title: 'An essay'),
      );
      await ItemCollection.db.insertRow(
        alice.build(),
        ItemCollection(
          ownerId: ownerId,
          itemId: item.id!,
          collectionId: collection.id!,
        ),
      );

      expect(
        await endpoints.collection.removeItem(bob, collection.id!, item.id!),
        isFalse,
      );
      expect(
        await endpoints.collection.removeItem(alice, collection.id!, item.id!),
        isTrue,
      );
      expect(await endpoints.collection.items(alice, collection.id!), isEmpty);
      expect(await endpoints.item.get(alice, item.id!), isNotNull);
    });
  });
}
