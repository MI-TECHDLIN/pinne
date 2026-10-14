import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/core/library_revision.dart';
import 'package:pinne_flutter/features/capture/ai_suggestions.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/capture/saved_section.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:pinne_flutter/ui/pinne_loading.dart';
import 'package:sqlite3/sqlite3.dart';

import '../support/contrast.dart';
import '../support/golden_theme.dart';
import 'fake_capture_server.dart';

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

class _AccountId extends AccountIdNotifier {
  @override
  String? build() => CaptureStore.testAccountId;
}

/// Behaves like the server: resolved and replaced suggestions are gone, and
/// an id it no longer knows is refused with [RecordNotFoundException].
class _FakeAiSuggestions implements AiSuggestionsApi {
  _FakeAiSuggestions(this.suggestions);

  final List<AiSuggestion> suggestions;
  final accepted = <UuidValue>[];
  final rejected = <UuidValue>[];
  final work = const Uuid().v4obj();
  Completer<void>? pendingGate;
  bool fail = false;
  bool organizing = false;
  int reviews = 0;
  void Function(AiSuggestion accepted)? onAccept;

  @override
  Future<AiSuggestionReview> review(UuidValue itemId) async {
    reviews++;
    await pendingGate?.future;
    return AiSuggestionReview(
      suggestions: [
        for (final s in suggestions)
          if (s.itemId == itemId && s.status == AiSuggestionStatus.pending) s,
      ],
      organizing: organizing,
    );
  }

  @override
  Future<Map<UuidValue, String>> collectionNames() async => {work: 'Work'};

  int _pending(UuidValue id) => suggestions.indexWhere(
    (s) => s.id == id && s.status == AiSuggestionStatus.pending,
  );

  @override
  Future<void> accept(UuidValue suggestionId) async {
    if (fail) throw Exception('offline');
    final index = _pending(suggestionId);
    if (index < 0) throw RecordNotFoundException(resource: 'AI suggestion');
    accepted.add(suggestionId);
    final suggestion = suggestions[index];
    suggestions[index] = suggestion.copyWith(
      status: AiSuggestionStatus.accepted,
    );
    onAccept?.call(suggestion);
  }

  @override
  Future<void> reject(UuidValue suggestionId) async {
    if (fail) throw Exception('offline');
    final index = _pending(suggestionId);
    if (index < 0) throw RecordNotFoundException(resource: 'AI suggestion');
    rejected.add(suggestionId);
    suggestions[index] = suggestions[index].copyWith(
      status: AiSuggestionStatus.rejected,
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);
  late CaptureStore store;
  setUp(() => store = CaptureStore(sqlite3.openInMemory()));
  tearDown(() => store.close());

  final itemId = const Uuid().v4obj();
  final ownerId = const Uuid().v4obj();

  Item item({String? summary}) => Item(
    id: itemId,
    ownerId: ownerId,
    url: 'https://example.com/article',
    title: 'Calm interfaces',
    sourcePlatform: SourcePlatform.web,
    enrichmentState: EnrichmentState.failed,
    summary: summary,
  );

  AiSuggestion suggestion(
    AiSuggestionKind kind, {
    String? value,
    UuidValue? collectionId,
    bool uncertain = false,
  }) => AiSuggestion(
    id: const Uuid().v4obj(),
    ownerId: ownerId,
    itemId: itemId,
    kind: kind,
    value: value,
    collectionId: collectionId,
    rationale: 'Matches the title.',
    uncertain: uncertain,
  );

  Future<void> show(
    WidgetTester tester,
    _FakeAiSuggestions api, {
    Item? serverItem,
    bool settle = true,
    bool light = false,
  }) async {
    final capture = store.save(
      parseCaptureInput('https://example.com/article'),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          captureStoreProvider.overrideWithValue(store),
          captureApiProvider.overrideWithValue(FakeCaptureServer()),
          signedInProvider.overrideWith(_SignedIn.new),
          accountIdProvider.overrideWith(_AccountId.new),
          aiSuggestionsApiProvider.overrideWithValue(api),
        ],
        child: MaterialApp(
          theme: light ? pinneLightTheme() : pinneDarkTheme(),
          builder: (context, app) => MotionPreferenceScope(
            preference: MotionPreference.reduced,
            child: app!,
          ),
          home: Scaffold(
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SavedCard(
                  capture: capture,
                  signedIn: true,
                  item: serverItem ?? item(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  testWidgets('pending suggestions use an inline skeleton, not a spinner', (
    tester,
  ) async {
    final api = _FakeAiSuggestions([])..pendingGate = Completer<void>();

    await show(tester, api, settle: false);

    expect(
      find.byKey(const ValueKey('ai-suggestions-skeleton')),
      findsOneWidget,
    );
    expect(find.byType(PinneSuggestionSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('accepted and dismissed suggestions leave the card', (
    tester,
  ) async {
    final api = _FakeAiSuggestions([]);
    final collection = suggestion(
      AiSuggestionKind.collection,
      collectionId: api.work,
    );
    final tag = suggestion(
      AiSuggestionKind.tag,
      value: 'design',
      uncertain: true,
    );
    final summary = suggestion(
      AiSuggestionKind.summary,
      value: 'How quiet layouts reduce stress.',
    );
    api.suggestions.addAll([collection, tag, summary]);

    await show(tester, api);

    expect(find.text('AI suggestions'), findsOneWidget);
    expect(find.text('Collection: Work'), findsOneWidget);
    expect(find.text('Tag: design'), findsOneWidget);
    expect(find.text('Maybe'), findsOneWidget);
    expect(find.text('Summary: How quiet layouts reduce stress.'), findsOne);

    await tester.tap(find.byKey(ValueKey('accept-${collection.id!.uuid}')));
    await tester.pumpAndSettle();
    expect(api.accepted, [collection.id]);
    expect(find.text('Collection: Work'), findsNothing);

    await tester.tap(find.byKey(ValueKey('dismiss-${tag.id!.uuid}')));
    await tester.pumpAndSettle();
    expect(api.rejected, [tag.id]);
    expect(find.text('Tag: design'), findsNothing);

    await tester.tap(find.byKey(ValueKey('accept-${summary.id!.uuid}')));
    await tester.pumpAndSettle();
    expect(api.accepted, [collection.id, summary.id]);
    expect(find.text('AI suggestions'), findsNothing);
  });

  testWidgets('Saved card with AI suggestions renders in Lavender Mist', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(412, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final api = _FakeAiSuggestions([]);
    api.suggestions.addAll([
      suggestion(AiSuggestionKind.collection, collectionId: api.work),
      suggestion(AiSuggestionKind.tag, value: 'design', uncertain: true),
      suggestion(
        AiSuggestionKind.summary,
        value: 'How quiet layouts reduce stress.',
      ),
    ]);

    await show(tester, api, light: true);

    await expectReadableText(tester);
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../../docs/light-theme/saved-ai-suggestions.png'),
    );
  });

  testWidgets('no suggestions means no AI chrome', (tester) async {
    await show(tester, _FakeAiSuggestions([]));

    expect(find.text('Calm interfaces'), findsOneWidget);
    expect(find.text('AI suggestions'), findsNothing);
  });

  testWidgets('an accepted summary shows on the card', (tester) async {
    await show(
      tester,
      _FakeAiSuggestions([]),
      serverItem: item(summary: 'How quiet layouts reduce stress.'),
    );

    expect(find.byKey(const ValueKey('saved-summary')), findsOneWidget);
    expect(find.text('How quiet layouts reduce stress.'), findsOneWidget);
  });

  testWidgets('a refused accept puts the chip back and says why', (
    tester,
  ) async {
    final tag = suggestion(AiSuggestionKind.tag, value: 'design');
    final api = _FakeAiSuggestions([tag])..fail = true;
    await show(tester, api);

    await tester.tap(find.byKey(ValueKey('accept-${tag.id!.uuid}')));
    await tester.pumpAndSettle();

    expect(find.text('Tag: design'), findsOneWidget);
    expect(find.byKey(const ValueKey('pinne-toast-error')), findsOneWidget);
  });
  group('when organizing runs again after the preview', () {
    const longSummary =
        'A 2026 tutorial by Nick Saraev that walks through building mobile '
        'applications using Claude Code, covering setup, coding, and '
        'deployment steps. The course ends with publishing the finished app '
        'to both stores.';

    testWidgets('the newer suggestions replace the first ones without a '
        'restart, and a long summary wraps in full', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final first = suggestion(
        AiSuggestionKind.tag,
        value: 'youtube',
        uncertain: true,
      );
      final api = _FakeAiSuggestions([first])..organizing = true;
      await show(tester, api);
      expect(find.text('Tag: youtube'), findsOneWidget);

      // The preview arrives and the server organizes again.
      final summary = suggestion(AiSuggestionKind.summary, value: longSummary);
      api
        ..suggestions.remove(first)
        ..suggestions.addAll([
          suggestion(AiSuggestionKind.tag, value: 'tutorial'),
          summary,
        ])
        ..organizing = false;
      await tester.pump(aiSuggestionsPollInterval);
      await tester.pumpAndSettle();

      expect(find.text('Tag: youtube'), findsNothing);
      expect(find.text('Tag: tutorial'), findsOneWidget);
      expect(find.text('Summary: $longSummary'), findsOneWidget);
      final paragraph = tester.renderObject<RenderParagraph>(
        find.byKey(ValueKey('ai-suggestion-text-${summary.id!.uuid}')),
      );
      expect(paragraph.didExceedMaxLines, isFalse);

      // Nothing is pending any more, so the card stops asking.
      final reviews = api.reviews;
      await tester.pump(aiSuggestionsPollInterval * 3);
      expect(api.reviews, reviews);
    });

    testWidgets('a chip from the replaced version reloads the latest '
        'instead of failing, and an accepted summary shows on the card', (
      tester,
    ) async {
      final stale = suggestion(
        AiSuggestionKind.tag,
        value: 'unknown',
        uncertain: true,
      );
      final staleToo = suggestion(AiSuggestionKind.tag, value: 'short');
      final api = _FakeAiSuggestions([stale, staleToo])..organizing = true;
      var serverItem = item().copyWith(revision: 1);
      api.onAccept = (accepted) {
        if (accepted.kind == AiSuggestionKind.summary) {
          serverItem = serverItem.copyWith(
            summary: accepted.value,
            revision: serverItem.revision + 1,
          );
        }
      };
      final capture = store.save(
        parseCaptureInput('https://example.com/article'),
      );
      store.confirm(
        capture.operationId,
        CaptureResult(
          itemId: itemId,
          clientItemId: UuidValue.fromString(capture.clientItemId),
          revision: 1,
          title: 'Calm interfaces',
          sourcePlatform: SourcePlatform.web,
          duplicate: false,
          enrichmentState: EnrichmentState.ready,
          savedAt: DateTime.utc(2026, 10, 14),
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            captureStoreProvider.overrideWithValue(store),
            captureApiProvider.overrideWithValue(FakeCaptureServer()),
            signedInProvider.overrideWith(_SignedIn.new),
            accountIdProvider.overrideWith(_AccountId.new),
            aiSuggestionsApiProvider.overrideWithValue(api),
            savedItemsProvider.overrideWith((ref) async* {
              // Like the real provider, follows library changes.
              ref.watch(libraryRevisionProvider);
              yield [serverItem];
            }),
          ],
          child: MaterialApp(
            theme: pinneDarkTheme(),
            builder: (context, app) => MotionPreferenceScope(
              preference: MotionPreference.reduced,
              child: app!,
            ),
            home: const Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: SavedSection(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Tag: unknown'), findsOneWidget);

      // The newer version replaced every chip before the next poll.
      final summary = suggestion(
        AiSuggestionKind.summary,
        value: 'How quiet layouts reduce stress.',
      );
      api
        ..suggestions.clear()
        ..suggestions.add(summary)
        ..organizing = false;

      await tester.tap(find.byKey(ValueKey('dismiss-${stale.id!.uuid}')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('pinne-toast-error')), findsNothing);
      expect(find.text('Tag: unknown'), findsNothing);
      expect(find.text('Tag: short'), findsNothing);
      expect(find.text('Summary: How quiet layouts reduce stress.'), findsOne);

      await tester.tap(find.byKey(ValueKey('accept-${summary.id!.uuid}')));
      await tester.pumpAndSettle();
      expect(api.accepted, [summary.id]);
      expect(find.byKey(const ValueKey('pinne-toast-error')), findsNothing);
      expect(find.byKey(const ValueKey('saved-summary')), findsOneWidget);
      expect(find.text('How quiet layouts reduce stress.'), findsOneWidget);
      expect(find.text('AI suggestions'), findsNothing);
    });

    testWidgets('accepting a chip the newer version dropped says the '
        'suggestions changed, not that it failed', (tester) async {
      final stale = suggestion(AiSuggestionKind.tag, value: 'unknown');
      final api = _FakeAiSuggestions([stale]);
      await show(tester, api);

      final latest = suggestion(AiSuggestionKind.tag, value: 'tutorial');
      api.suggestions
        ..clear()
        ..add(latest);
      await tester.tap(find.byKey(ValueKey('accept-${stale.id!.uuid}')));
      await tester.pumpAndSettle();

      expect(api.accepted, isEmpty);
      expect(find.byKey(const ValueKey('pinne-toast-error')), findsNothing);
      expect(find.byKey(const ValueKey('pinne-toast-info')), findsOneWidget);
      expect(find.text('Tag: unknown'), findsNothing);
      expect(find.text('Tag: tutorial'), findsOneWidget);
    });
  });
}
