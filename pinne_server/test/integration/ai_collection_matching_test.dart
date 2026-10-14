import 'package:pinne_server/src/ai/ai_organization_service.dart';
import 'package:pinne_server/src/ai/ai_provider.dart';
import 'package:pinne_server/src/ai/ai_provider_registry.dart';
import 'package:pinne_server/src/ai/fake_ai_provider.dart';
import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

/// The captain's scenarios: before suggesting a new collection, organizing
/// compares the item with what each existing collection already holds.
void main() {
  withServerpod('Given collections with saves in them', (
    sessionBuilder,
    endpoints,
  ) {
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;
    late UuidValue aliceId;
    late UuidValue bobId;
    late Collection uiInspiration;
    late Collection flutterTips;

    UuidValue idOf(TestSessionBuilder builder) =>
        UuidValue.fromString(builder.build().authenticated!.userIdentifier);

    Future<Item> save(
      TestSessionBuilder owner, {
      required String title,
      String? url,
      String? description,
      List<String> tags = const [],
      Collection? into,
    }) async {
      final session = owner.build();
      final ownerId = idOf(owner);
      final item = await Item.db.insertRow(
        session,
        Item(
          ownerId: ownerId,
          title: title,
          url: url,
          previewDescription: description,
        ),
      );
      for (final name in tags) {
        final tag =
            await Tag.db.findFirstRow(
              session,
              where: (t) =>
                  t.ownerId.equals(ownerId) & t.normalizedName.equals(name),
            ) ??
            await Tag.db.insertRow(
              session,
              Tag(ownerId: ownerId, normalizedName: name, displayName: name),
            );
        await ItemTag.db.insertRow(
          session,
          ItemTag(ownerId: ownerId, itemId: item.id!, tagId: tag.id!),
        );
      }
      if (into != null) {
        await ItemCollection.db.insertRow(
          session,
          ItemCollection(
            ownerId: ownerId,
            itemId: item.id!,
            collectionId: into.id!,
          ),
        );
      }
      return item;
    }

    Future<List<AiSuggestion>> organize(
      TestSessionBuilder owner,
      Item item, {
      AiOrganizationService? service,
    }) async {
      final organizer = service ?? AiOrganizationService();
      final ownerId = idOf(owner);
      await organizer.enqueue(
        owner.build(),
        ownerId: ownerId,
        itemId: item.id!,
      );
      await organizer.process(
        owner.build(),
        ownerId: ownerId,
        itemId: item.id!,
      );
      return (await endpoints.aiOrganizing.review(owner, item.id!)).suggestions;
    }

    List<AiSuggestion> collectionSuggestions(List<AiSuggestion> all) => [
      for (final suggestion in all)
        if (suggestion.kind == AiSuggestionKind.collection) suggestion,
    ];

    setUp(() async {
      AiProviderRegistry.resetForTest();
      alice = await signedInAs(sessionBuilder);
      bob = await signedInAs(sessionBuilder);
      aliceId = idOf(alice);
      bobId = idOf(bob);
      uiInspiration = await endpoints.collection.create(
        alice,
        CollectionDraft(
          name: 'UI inspiration',
          description: 'Screens and interfaces I like',
          coverSeed: 11,
          paletteIndex: 0,
        ),
      );
      flutterTips = await endpoints.collection.create(
        alice,
        CollectionDraft(name: 'Flutter tips', coverSeed: 12, paletteIndex: 1),
      );
      await save(
        alice,
        title: 'Meditation app onboarding screens',
        url: 'https://dribbble.com/shots/101-meditation-onboarding',
        tags: ['design', 'dribbble'],
        into: uiInspiration,
      );
      await save(
        alice,
        title: 'Dashboard UI kit',
        url: 'https://dribbble.com/shots/102-dashboard-ui-kit',
        tags: ['design', 'dribbble'],
        into: uiInspiration,
      );
      await save(
        alice,
        title: 'Mobile banking app concept',
        url: 'https://dribbble.com/shots/103-banking',
        tags: ['design', 'dribbble'],
        into: uiInspiration,
      );
      await save(
        alice,
        title: 'Layouts in Flutter',
        url: 'https://docs.flutter.dev/ui/layout',
        description: 'How rows, columns and constraints build a widget tree.',
        tags: ['flutter'],
        into: flutterTips,
      );
      await save(
        alice,
        title: 'Riverpod state management guide',
        tags: ['flutter', 'riverpod'],
        into: flutterTips,
      );
    });

    test('a new design link goes to the existing UI inspiration collection, '
        'not a new one', () async {
      final link = await save(
        alice,
        title: 'Fintech dashboard concept',
        url: 'https://dribbble.com/shots/204-fintech-dashboard',
      );

      final suggestions = collectionSuggestions(await organize(alice, link));

      expect(suggestions, hasLength(1));
      expect(suggestions.single.collectionId, uiInspiration.id);
      expect(suggestions.single.value, isNull);
      expect(suggestions.single.rationale, contains("'UI inspiration'"));
      expect(suggestions.single.rationale, contains('dribbble'));
    });

    test('a Flutter article goes to Flutter tips', () async {
      final link = await save(
        alice,
        title: 'Building adaptive Flutter apps',
        url: 'https://docs.flutter.dev/ui/adaptive-responsive',
      );

      final suggestions = collectionSuggestions(await organize(alice, link));

      expect(suggestions.single.collectionId, flutterTips.id);
    });

    test('an unrelated cooking link proposes a new collection', () async {
      final link = await save(
        alice,
        title: 'Fluffy buttermilk pancakes recipe',
        url: 'https://www.seriouseats.com/fluffy-buttermilk-pancakes',
      );

      final suggestions = collectionSuggestions(await organize(alice, link));

      expect(suggestions, hasLength(1));
      expect(suggestions.single.collectionId, isNull);
      expect(suggestions.single.value, 'Cooking');
      expect(suggestions.single.rationale, contains('None of your'));
    });

    test('accepting "New collection" creates it, adds the item, and a second '
        'proposal with that name reuses it', () async {
      final pancakes = await save(
        alice,
        title: 'Fluffy buttermilk pancakes recipe',
        url: 'https://www.seriouseats.com/fluffy-buttermilk-pancakes',
      );
      final proposal = collectionSuggestions(
        await organize(alice, pancakes),
      ).single;

      final accepted = await endpoints.aiOrganizing.accept(
        alice,
        proposal.id!,
      );

      final cooking = (await endpoints.collection.list(
        alice,
      )).singleWhere((collection) => collection.name == 'Cooking');
      expect(accepted.status, AiSuggestionStatus.accepted);
      expect(accepted.collectionId, cooking.id);
      // Automatic cover: the palette no other collection uses yet.
      expect(cooking.paletteIndex, 2);
      expect(
        (await endpoints.collection.items(alice, cooking.id!)).map((i) => i.id),
        [pancakes.id],
      );
      final cookingCard = (await endpoints.collection.summaries(
        alice,
      )).singleWhere((summary) => summary.collection.id == cooking.id);
      expect(cookingCard.itemCount, 1);
      expect(cookingCard.recentTitles, ['Fluffy buttermilk pancakes recipe']);

      // The next recipe now matches the collection that was just created.
      final pasta = await save(
        alice,
        title: 'Weeknight pasta recipe',
        url: 'https://www.seriouseats.com/weeknight-pasta',
      );
      final next = collectionSuggestions(await organize(alice, pasta));
      expect(next.single.collectionId, cooking.id);
    });

    test('the provider sees each collection with a profile of its contents, '
        'and a proposed new collection is verified against them', () async {
      final fake = FakeAiProvider(
        result: const AiOrganizationResult(
          collectionIds: [],
          newCollectionName: 'Design references',
          collectionReason: 'Looks like a design reference.',
          tags: ['design'],
          rationale: 'Remote result.',
          evidenceCoverage: AiEvidenceCoverage.metadataOnly,
          uncertain: false,
          provider: 'fake',
        ),
      );
      final link = await save(
        alice,
        title: 'Travel booking app screens',
        url: 'https://dribbble.com/shots/305-travel-booking',
      );

      final suggestions = collectionSuggestions(
        await organize(
          alice,
          link,
          service: AiOrganizationService(remoteProviderOverride: fake),
        ),
      );

      final sent = {
        for (final option in fake.lastCollections) option.name: option,
      };
      expect(sent.keys, unorderedEquals(['UI inspiration', 'Flutter tips']));
      final ui = sent['UI inspiration']!;
      expect(ui.description, 'Screens and interfaces I like');
      expect(ui.itemCount, 3);
      expect(
        ui.samples.map((sample) => sample.title),
        containsAll(['Dashboard UI kit', 'Mobile banking app concept']),
      );
      expect(ui.samples.first.tags, containsAll(['design', 'dribbble']));
      expect(
        sent['Flutter tips']!.samples
            .firstWhere((sample) => sample.title == 'Layouts in Flutter')
            .summary,
        startsWith('How rows, columns'),
      );
      // The remote wanted a new collection, but an existing one is related.
      expect(suggestions.single.collectionId, uiInspiration.id);
      expect(suggestions.single.value, isNull);
    });

    test('a proposed name that only differs in case is the existing '
        'collection', () async {
      final fake = FakeAiProvider(
        result: const AiOrganizationResult(
          collectionIds: [],
          newCollectionName: 'flutter TIPS',
          tags: [],
          rationale: 'Remote result.',
          evidenceCoverage: AiEvidenceCoverage.metadataOnly,
          uncertain: false,
          provider: 'fake',
        ),
      );
      final note = await save(alice, title: 'Something to read later');

      final suggestions = collectionSuggestions(
        await organize(
          alice,
          note,
          service: AiOrganizationService(remoteProviderOverride: fake),
        ),
      );

      expect(suggestions.single.collectionId, flutterTips.id);
    });

    test(
      'an item already in a collection gets no collection suggestion',
      () async {
        final filed = await save(
          alice,
          title: 'Another dashboard on dribbble',
          url: 'https://dribbble.com/shots/406-dashboard',
          into: uiInspiration,
        );

        final suggestions = await organize(alice, filed);

        expect(collectionSuggestions(suggestions), isEmpty);
      },
    );

    test(
      'matching never uses or suggests another owner\'s collections',
      () async {
        final bobsDesign = await endpoints.collection.create(
          bob,
          CollectionDraft(
            name: 'Dribbble shots',
            coverSeed: 1,
            paletteIndex: 0,
          ),
        );
        await save(
          bob,
          title: 'Fintech dashboard',
          url: 'https://dribbble.com/shots/9-fintech',
          tags: ['design', 'dribbble', 'fintech'],
          into: bobsDesign,
        );
        final fake = FakeAiProvider(
          result: AiOrganizationResult(
            // A prompt-injected or confused id from another account.
            collectionIds: [bobsDesign.id!],
            tags: const [],
            rationale: 'Remote result.',
            evidenceCoverage: AiEvidenceCoverage.metadataOnly,
            uncertain: false,
            provider: 'fake',
          ),
        );
        final aliceLink = await save(
          alice,
          title: 'Fintech dashboard',
          url: 'https://dribbble.com/shots/9-fintech',
        );

        final suggestions = collectionSuggestions(
          await organize(
            alice,
            aliceLink,
            service: AiOrganizationService(remoteProviderOverride: fake),
          ),
        );

        expect(
          fake.lastCollections.map((option) => option.id),
          isNot(contains(bobsDesign.id)),
        );
        expect(
          fake.lastCollections.expand((option) => option.samples),
          everyElement(
            isA<AiCollectionSample>().having(
              (sample) => sample.tags,
              'tags',
              isNot(contains('fintech')),
            ),
          ),
        );
        expect(suggestions.single.collectionId, uiInspiration.id);

        // Bob cannot accept Alice's suggestion or read her collection.
        await expectLater(
          endpoints.aiOrganizing.accept(bob, suggestions.single.id!),
          throwsA(isA<RecordNotFoundException>()),
        );
        await expectLater(
          endpoints.collection.items(bob, uiInspiration.id!),
          throwsA(isA<RecordNotFoundException>()),
        );
        expect(bobId, isNot(aliceId));
      },
    );

    test('accepting a tag shows on the collection card', () async {
      final link = await save(
        alice,
        title: 'Glassmorphism login screen',
        url: 'https://dribbble.com/shots/507-glass-login',
        into: uiInspiration,
      );
      final fake = FakeAiProvider(
        result: const AiOrganizationResult(
          collectionIds: [],
          tags: ['glassmorphism'],
          rationale: 'Remote result.',
          evidenceCoverage: AiEvidenceCoverage.metadataOnly,
          uncertain: false,
          provider: 'fake',
        ),
      );
      final tag = (await organize(
        alice,
        link,
        service: AiOrganizationService(remoteProviderOverride: fake),
      )).singleWhere((suggestion) => suggestion.kind == AiSuggestionKind.tag);

      await endpoints.aiOrganizing.accept(alice, tag.id!);

      final card = (await endpoints.collection.summaries(
        alice,
      )).singleWhere((summary) => summary.collection.id == uiInspiration.id);
      expect(card.itemCount, 4);
      expect(card.topTags, contains('glassmorphism'));
      final items = await endpoints.collection.items(alice, uiInspiration.id!);
      expect(items.map((item) => item.title), contains(link.title));
    });
  });
}
