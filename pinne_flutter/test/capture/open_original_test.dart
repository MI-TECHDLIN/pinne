import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/open_original.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/ai_suggestions.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/capture/saved_section.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:sqlite3/sqlite3.dart';

import 'fake_capture_server.dart';

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

class _AccountId extends AccountIdNotifier {
  @override
  String? build() => CaptureStore.testAccountId;
}

class _Api implements AiSuggestionsApi {
  _Api(this.suggestions);
  final List<AiSuggestion> suggestions;
  int accepted = 0;

  @override
  Future<AiSuggestionReview> review(UuidValue itemId) async =>
      AiSuggestionReview(suggestions: suggestions, organizing: false);

  @override
  Future<Map<UuidValue, String>> collectionNames() async => {};

  @override
  Future<void> accept(UuidValue suggestionId) async => accepted++;

  @override
  Future<void> reject(UuidValue suggestionId) async {}
}

void main() {
  late CaptureStore store;
  late List<Uri> opened;
  setUp(() {
    store = CaptureStore(sqlite3.openInMemory());
    opened = [];
  });
  tearDown(() => store.close());

  final itemId = const Uuid().v4obj();

  Future<void> show(
    WidgetTester tester,
    String input, {
    Item? item,
    _Api? api,
    bool launches = true,
  }) async {
    final capture = store.save(parseCaptureInput(input));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          captureStoreProvider.overrideWithValue(store),
          captureApiProvider.overrideWithValue(FakeCaptureServer()),
          signedInProvider.overrideWith(_SignedIn.new),
          accountIdProvider.overrideWith(_AccountId.new),
          aiSuggestionsApiProvider.overrideWithValue(api ?? _Api([])),
          openExternalUrlProvider.overrideWithValue((uri) async {
            opened.add(uri);
            return launches;
          }),
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
                SavedCard(capture: capture, signedIn: true, item: item),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('tapping a saved card opens the original link externally', (
    tester,
  ) async {
    await show(tester, 'https://www.youtube.com/watch?v=abc123');

    await tester.tap(find.byKey(const ValueKey('saved-card-open')));
    await tester.pump();

    expect(opened.single.toString(), contains('youtube.com/watch?v=abc123'));
  });

  testWidgets('the Open original button opens the link', (tester) async {
    await show(tester, 'https://x.com/someone/status/1');

    expect(find.byTooltip('Open original'), findsOneWidget);
    await tester.tap(find.byTooltip('Open original'));
    await tester.pump();

    expect(opened, hasLength(1));
  });

  testWidgets('tapping a suggestion chip does not open the link', (
    tester,
  ) async {
    final suggestion = AiSuggestion(
      id: const Uuid().v4obj(),
      ownerId: const Uuid().v4obj(),
      itemId: itemId,
      kind: AiSuggestionKind.tag,
      value: 'design',
      rationale: 'Matches.',
      uncertain: false,
    );
    final api = _Api([suggestion]);
    await show(
      tester,
      'https://example.com/article',
      api: api,
      item: Item(
        id: itemId,
        ownerId: const Uuid().v4obj(),
        url: 'https://example.com/article',
        title: 'Calm interfaces',
        sourcePlatform: SourcePlatform.web,
        enrichmentState: EnrichmentState.failed,
      ),
    );

    await tester.tap(find.byKey(ValueKey('accept-${suggestion.id!.uuid}')));
    await tester.pumpAndSettle();

    expect(api.accepted, 1);
    expect(opened, isEmpty);
  });

  testWidgets('a note without a link opens nothing and offers no button', (
    tester,
  ) async {
    await show(tester, 'Buy oat milk on the way home');

    await tester.tap(find.byKey(const ValueKey('saved-card-open')));
    await tester.pump();

    expect(opened, isEmpty);
    expect(find.byTooltip('Open original'), findsNothing);
  });

  testWidgets('a link that cannot be opened shows a toast', (tester) async {
    await show(tester, 'https://example.com/a', launches: false);

    await tester.tap(find.byKey(const ValueKey('saved-card-open')));
    await tester.pump();

    expect(find.text('Could not open that link.'), findsOneWidget);
  });
}
