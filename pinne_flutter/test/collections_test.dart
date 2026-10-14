import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/ai_suggestions.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/collections/collection_editor.dart';
import 'package:pinne_flutter/features/collections/collections_providers.dart';
import 'package:pinne_flutter/features/collections/collections_screen.dart';
import 'package:pinne_flutter/features/search/search_providers.dart';
import 'package:pinne_flutter/features/search/search_screen.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:sqlite3/sqlite3.dart';

import 'capture/fake_capture_server.dart';
import 'support/collections_fixture.dart';
import 'support/contrast.dart';
import 'support/golden_theme.dart';

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

class _SignedOut extends SignedInNotifier {
  @override
  bool build() => false;
}

class _AccountId extends AccountIdNotifier {
  @override
  String? build() => CaptureStore.testAccountId;
}

class _NoAccount extends AccountIdNotifier {
  @override
  String? build() => null;
}

class _Query extends SearchQuery {
  @override
  String build() => 'inspiration';
}

class _NoResults extends SearchResults {
  @override
  Future<SearchPage> build() async => SearchPage(results: []);
}

/// Suggestions that change the in-memory collections when accepted, like
/// the server does.
class _FakeAi implements AiSuggestionsApi {
  _FakeAi(this.suggestions, this.collections);

  final List<AiSuggestion> suggestions;
  final FakeCollectionsApi collections;
  void Function(AiSuggestion accepted)? onAccept;

  @override
  Future<AiSuggestionReview> review(UuidValue itemId) async =>
      AiSuggestionReview(
        suggestions: [
          for (final s in suggestions)
            if (s.status == AiSuggestionStatus.pending) s,
        ],
        organizing: false,
      );

  @override
  Future<Map<UuidValue, String>> collectionNames() async => {
    for (final s in collections.summariesList)
      s.collection.id!: s.collection.name,
  };

  @override
  Future<void> accept(UuidValue suggestionId) async {
    final index = suggestions.indexWhere((s) => s.id == suggestionId);
    final accepted = suggestions[index];
    suggestions[index] = accepted.copyWith(
      status: AiSuggestionStatus.accepted,
    );
    onAccept?.call(accepted);
  }

  @override
  Future<void> reject(UuidValue suggestionId) async {}
}

void main() {
  setUpAll(loadGoldenFonts);

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    required CollectionsApi api,
    bool signedIn = true,
    bool light = false,
    List overrides = const [],
  }) async {
    await tester.binding.setSurfaceSize(const Size(412, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...overrides,
          captureStoreProvider.overrideWithValue(
            CaptureStore(sqlite3.openInMemory()),
          ),
          captureApiProvider.overrideWithValue(FakeCaptureServer()),
          signedInProvider.overrideWith(
            signedIn ? _SignedIn.new : _SignedOut.new,
          ),
          accountIdProvider.overrideWith(
            signedIn ? _AccountId.new : _NoAccount.new,
          ),
          savedItemsProvider.overrideWith((ref) async* {
            yield const <Item>[];
          }),
          collectionsApiProvider.overrideWithValue(api),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: light ? pinneLightTheme() : goldenTheme(),
          builder: (context, app) => MotionPreferenceScope(
            preference: MotionPreference.reduced,
            child: app!,
          ),
          home: Scaffold(body: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder tileFor(String name) => find.ancestor(
    of: find.text(name),
    matching: find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith('collection-') &&
          w is InkWell,
    ),
  );

  String lineOf(WidgetTester tester, UuidValue id) => tester
      .widget<Text>(find.byKey(ValueKey('collection-line-${id.uuid}')))
      .data!;

  const sampleNames = [
    'Flutter UI',
    'Motion ideas',
    'Backend notes',
    'Not sorted yet',
    'SAMPLE COLLECTIONS',
    'SAMPLE',
  ];

  group('real accounts', () {
    testWidgets('an account with no collections sees an empty state, never '
        'sample collections', (tester) async {
      await pump(tester, const CollectionsScreen(), api: FakeCollectionsApi());

      for (final name in sampleNames) {
        expect(find.text(name), findsNothing, reason: name);
      }
      expect(find.byKey(const ValueKey('collections-empty')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('create-first-collection')),
        findsOneWidget,
      );
    });

    testWidgets('signed out shows no sample collections either', (
      tester,
    ) async {
      await pump(
        tester,
        const CollectionsScreen(),
        api: FakeCollectionsApi(),
        signedIn: false,
      );

      for (final name in sampleNames) {
        expect(find.text(name), findsNothing, reason: name);
      }
      expect(
        find.byKey(const ValueKey('create-first-collection')),
        findsNothing,
      );
    });

    testWidgets('cards show the real counts and most used tags', (
      tester,
    ) async {
      await pump(
        tester,
        const CollectionsScreen(),
        api: FakeCollectionsApi(fixtureSummaries),
      );

      expect(
        lineOf(tester, fixtureId(0xc01)),
        '12 saves · #design #dribbble',
      );
      expect(lineOf(tester, fixtureId(0xc03)), '1 save · #recipe');
      expect(lineOf(tester, fixtureId(0xc04)), 'No saves yet');
      expect(find.text('COLLECTION'), findsNWidgets(4));
    });
  });

  testWidgets('create a collection: name, auto colour that can be changed, '
      'description', (tester) async {
    final api = FakeCollectionsApi(fixtureSummaries);
    await pump(tester, const CollectionsScreen(), api: api);

    await tester.tap(find.byKey(const ValueKey('new-collection')));
    await tester.pumpAndSettle();
    expect(find.text('New collection'), findsOneWidget);
    // Palettes 0-3 are taken, so the new one starts on 4.
    expect(
      tester
          .widget<Semantics>(
            find
                .ancestor(
                  of: find.byKey(const ValueKey('collection-colour-4')),
                  matching: find.byType(Semantics),
                )
                .first,
          )
          .properties
          .selected,
      isTrue,
    );

    await tester.tap(find.byKey(const ValueKey('save-collection')));
    await tester.pumpAndSettle();
    expect(find.text('Give the collection a name.'), findsOneWidget);
    expect(api.created, isEmpty);

    await tester.enterText(
      find.byKey(const ValueKey('collection-name-field')),
      '  Travel plans ',
    );
    await tester.enterText(
      find.byKey(const ValueKey('collection-description-field')),
      'Places to go',
    );
    await tester.tap(find.byKey(const ValueKey('collection-colour-2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-collection')));
    await tester.pumpAndSettle();

    expect(api.created.single.name, 'Travel plans');
    expect(api.created.single.description, 'Places to go');
    expect(api.created.single.paletteIndex, 2);
    expect(find.byType(CollectionEditorSheet), findsNothing);
    expect(tileFor('Travel plans'), findsOneWidget);
  });

  testWidgets('a taken name is refused with the server\'s words', (
    tester,
  ) async {
    await pump(
      tester,
      const CollectionsScreen(),
      api: FakeCollectionsApi(fixtureSummaries),
    );

    await tester.tap(find.byKey(const ValueKey('new-collection')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('collection-name-field')),
      'cooking',
    );
    await tester.tap(find.byKey(const ValueKey('save-collection')));
    await tester.pumpAndSettle();

    expect(
      find.text('You already have a collection called "cooking".'),
      findsOneWidget,
    );
    expect(find.byType(CollectionEditorSheet), findsOneWidget);
  });

  testWidgets('search filters collections by name and description', (
    tester,
  ) async {
    await pump(
      tester,
      const CollectionsScreen(),
      api: FakeCollectionsApi(fixtureSummaries),
    );
    final field = find.byKey(const ValueKey('collections-search-field'));

    await tester.enterText(field, 'ui insp');
    await tester.pumpAndSettle();
    expect(tileFor('UI inspiration'), findsOneWidget);
    expect(tileFor('Flutter tips'), findsNothing);

    await tester.enterText(field, 'screens');
    await tester.pumpAndSettle();
    expect(tileFor('UI inspiration'), findsOneWidget);
    expect(tileFor('Cooking'), findsNothing);

    await tester.enterText(field, 'zzz');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('collections-no-match')), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(tileFor('Reading list'), findsOneWidget);
  });

  testWidgets('global Search lists matching collections', (tester) async {
    await pump(
      tester,
      const SearchScreen(),
      api: FakeCollectionsApi(fixtureSummaries),
      overrides: [
        searchQueryProvider.overrideWith(_Query.new),
        searchPageProvider.overrideWith(_NoResults.new),
        searchCollectionsProvider.overrideWith((ref) async => []),
      ],
    );

    expect(find.byKey(const ValueKey('search-collections')), findsOneWidget);
    expect(
      find.byKey(ValueKey('collection-result-${fixtureId(0xc01).uuid}')),
      findsOneWidget,
    );
    expect(
      find.byKey(ValueKey('collection-result-${fixtureId(0xc02).uuid}')),
      findsNothing,
    );
  });

  testWidgets('rename and recolour from the collection screen, then delete '
      'it with confirmation while its saves stay', (tester) async {
    final api = FakeCollectionsApi(fixtureSummaries);
    api.file(fixtureId(0xc03), fixtureItem(1, 'Fluffy pancakes'));
    await pump(tester, const CollectionsScreen(), api: api);

    await tester.tap(tileFor('Cooking'));
    await tester.pumpAndSettle();
    expect(find.byType(CollectionDetailScreen), findsOneWidget);
    expect(find.text('Fluffy pancakes'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('edit-collection')));
    await tester.pumpAndSettle();
    expect(find.text('Edit collection'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('collection-name-field')),
      'Weeknight dinners',
    );
    await tester.tap(find.byKey(const ValueKey('collection-colour-3')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-collection')));
    await tester.pumpAndSettle();

    final edited = api.summariesList
        .singleWhere((s) => s.collection.id == fixtureId(0xc03))
        .collection;
    expect(edited.name, 'Weeknight dinners');
    expect(edited.paletteIndex, 3);
    expect(
      find.descendant(
        of: find.byType(CollectionDetailScreen),
        matching: find.text('Weeknight dinners'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('delete-collection')));
    await tester.pumpAndSettle();
    expect(
      find.text('Its save stays in Pinne. It just leaves this collection.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('confirm-delete-collection')));
    await tester.pumpAndSettle();

    expect(find.byType(CollectionDetailScreen), findsNothing);
    expect(tileFor('Weeknight dinners'), findsNothing);
    expect(
      api.summariesList.map((s) => s.collection.name),
      isNot(contains('Weeknight dinners')),
    );
  });

  // Regression: accepting "Collection: X" on a Saved card changed nothing on
  // the Collections tab until a restart. The card had no count at all (a
  // fixed "A place for good finds."), and its detail screen was a fixed
  // placeholder, so there was nothing to refresh.
  testWidgets('accepting AI suggestions updates the collection cards and '
      'detail without a restart', (tester) async {
    final api = FakeCollectionsApi([
      fixtureSummary(n: 0xc01, name: 'UI inspiration', paletteIndex: 0),
    ]);
    final itemId = fixtureId(0x1001);
    final saved = fixtureItem(1, 'Fintech dashboard concept');
    AiSuggestion suggestion(
      AiSuggestionKind kind, {
      UuidValue? collectionId,
      String? value,
      String rationale = 'r',
    }) => AiSuggestion(
      id: const Uuid().v4obj(),
      ownerId: saved.ownerId,
      itemId: itemId,
      kind: kind,
      collectionId: collectionId,
      value: value,
      rationale: rationale,
    );
    final existing = suggestion(
      AiSuggestionKind.collection,
      collectionId: fixtureId(0xc01),
      rationale: "Matches your 'UI inspiration' saves: both mention dribbble.",
    );
    final tag = suggestion(AiSuggestionKind.tag, value: 'fintech');
    final create = suggestion(AiSuggestionKind.collection, value: 'Finance');
    final ai = _FakeAi([existing, tag, create], api);
    ai.onAccept = (accepted) {
      switch (accepted) {
        case AiSuggestion(kind: AiSuggestionKind.tag):
          final index = api.summariesList.indexWhere(
            (s) => s.collection.id == fixtureId(0xc01),
          );
          api.summariesList[index] = api.summariesList[index].copyWith(
            topTags: ['fintech'],
          );
        case AiSuggestion(collectionId: final id?):
          api.file(id, saved);
        case AiSuggestion(value: final name?):
          api
              .create(
                CollectionDraft(name: name, coverSeed: 1, paletteIndex: 1),
              )
              .then((created) => api.file(created.id!, saved));
      }
    };

    await pump(
      tester,
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SavedItemAiSuggestions(itemId: itemId),
          ),
          const Expanded(child: CollectionsScreen()),
        ],
      ),
      api: api,
      overrides: [aiSuggestionsApiProvider.overrideWithValue(ai)],
    );
    expect(lineOf(tester, fixtureId(0xc01)), 'No saves yet');
    expect(find.text('Collection: UI inspiration'), findsOneWidget);
    expect(
      find.text("Matches your 'UI inspiration' saves: both mention dribbble."),
      findsOneWidget,
    );
    expect(find.text('New collection: Finance'), findsOneWidget);

    await tester.tap(find.byKey(ValueKey('accept-${existing.id!.uuid}')));
    await tester.pumpAndSettle();
    expect(lineOf(tester, fixtureId(0xc01)), '1 save');

    await tester.tap(find.byKey(ValueKey('accept-${tag.id!.uuid}')));
    await tester.pumpAndSettle();
    expect(lineOf(tester, fixtureId(0xc01)), '1 save · #fintech');

    await tester.tap(find.byKey(ValueKey('accept-${create.id!.uuid}')));
    await tester.pumpAndSettle();
    expect(tileFor('Finance'), findsOneWidget);

    await tester.tap(tileFor('UI inspiration'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(CollectionDetailScreen),
        matching: find.text('Fintech dashboard concept'),
      ),
      findsOneWidget,
    );
  });

  group('Lavender Mist', () {
    testWidgets('empty state is readable', (tester) async {
      await pump(
        tester,
        const CollectionsScreen(),
        api: FakeCollectionsApi(),
        light: true,
      );
      await expectReadableText(tester);
    });

    testWidgets('the collection sheet is readable', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      await pump(
        tester,
        const CollectionsScreen(),
        api: FakeCollectionsApi(fixtureSummaries),
        light: true,
      );
      await tester.binding.setSurfaceSize(const Size(412, 915));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('new-collection')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('collection-name-field')),
        'Travel plans',
      );
      await tester.pumpAndSettle();
      await expectReadableText(
        tester,
        within: find.byType(CollectionEditorSheet),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../../docs/light-theme/collection-sheet.png'),
      );
    });

    testWidgets('the collection screen is readable', (tester) async {
      final api = FakeCollectionsApi(fixtureSummaries);
      api.file(
        fixtureId(0xc01),
        fixtureItem(
          2,
          'Meditation app onboarding screens',
          site: 'Dribbble',
          summary: 'Calm onboarding with one clear action per screen.',
        ),
      );
      await pump(
        tester,
        const CollectionsScreen(),
        api: api,
        light: true,
      );
      await tester.tap(tileFor('UI inspiration'));
      await tester.pumpAndSettle();
      await expectReadableText(tester);
    });
  });
}
