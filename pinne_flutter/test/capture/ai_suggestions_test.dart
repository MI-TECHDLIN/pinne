import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/ai_suggestions.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/capture/saved_section.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:pinne_flutter/ui/pinne_loading.dart';
import 'package:sqlite3/sqlite3.dart';

import 'fake_capture_server.dart';

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

class _FakeAiSuggestions implements AiSuggestionsApi {
  _FakeAiSuggestions(this.suggestions);

  final List<AiSuggestion> suggestions;
  final accepted = <UuidValue>[];
  final rejected = <UuidValue>[];
  final work = const Uuid().v4obj();
  Completer<void>? pendingGate;
  bool fail = false;

  @override
  Future<List<AiSuggestion>> pending(UuidValue itemId) async {
    await pendingGate?.future;
    return [
      for (final s in suggestions)
        if (s.itemId == itemId && s.status == AiSuggestionStatus.pending) s,
    ];
  }

  @override
  Future<Map<UuidValue, String>> collectionNames() async => {work: 'Work'};

  @override
  Future<void> accept(UuidValue suggestionId) async {
    if (fail) throw Exception('offline');
    accepted.add(suggestionId);
  }

  @override
  Future<void> reject(UuidValue suggestionId) async {
    if (fail) throw Exception('offline');
    rejected.add(suggestionId);
  }
}

void main() {
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
          aiSuggestionsApiProvider.overrideWithValue(api),
        ],
        child: MaterialApp(
          theme: pinneDarkTheme(),
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
}
