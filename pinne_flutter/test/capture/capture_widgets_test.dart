import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/capture/paste_capture_card.dart';
import 'package:pinne_flutter/features/capture/saved_section.dart';
import 'package:pinne_flutter/features/capture/share_sheet.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:sqlite3/sqlite3.dart';

import 'fake_capture_server.dart';

class _SignedIn extends SignedInNotifier {
  _SignedIn(this.value);

  final bool value;

  @override
  bool build() => value;
}

Widget _host(
  Widget child, {
  required CaptureStore store,
  FakeCaptureServer? server,
  bool signedIn = false,
  MotionPreference motion = MotionPreference.reduced,
}) {
  return ProviderScope(
    overrides: [
      captureStoreProvider.overrideWithValue(store),
      captureApiProvider.overrideWithValue(server ?? FakeCaptureServer()),
      signedInProvider.overrideWith(() => _SignedIn(signedIn)),
    ],
    child: MaterialApp(
      theme: pinneDarkTheme(),
      builder: (context, app) =>
          MotionPreferenceScope(preference: motion, child: app!),
      home: child,
    ),
  );
}

Widget _page(Widget child) => Scaffold(
  body: ListView(padding: const EdgeInsets.all(16), children: [child]),
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  late CaptureStore store;
  setUp(() => store = CaptureStore(sqlite3.openInMemory()));
  tearDown(() => store.close());

  group('share sheet', () {
    testWidgets('is saved locally before it says Saved, then Done syncs', (
      tester,
    ) async {
      final server = FakeCaptureServer();
      var done = false;
      await tester.pumpWidget(
        _host(
          ShareSheetScreen(
            text: 'https://twitter.com/Someone/status/1844123456789012345?s=20',
            onDone: () => done = true,
          ),
          store: store,
          server: server,
          signedIn: true,
          motion: MotionPreference.full,
        ),
      );

      // The row exists by the first frame that can show "Saved".
      final stored = store.captures().single;
      expect(stored.held, isTrue);
      expect(stored.source, CaptureSource.x);
      expect(find.text('Saved to Pinne'), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text('X'), findsOneWidget);
      expect(find.bySemanticsLabel('Source: X'), findsOneWidget);
      expect(
        find.text('x.com/someone/status/1844123456789012345'),
        findsWidgets,
      );
      expect(find.text('Done · back to X'), findsOneWidget);
      expect(server.calls, isEmpty, reason: 'held while the sheet is open');

      await tester.enterText(
        find.byKey(const ValueKey('share-title')),
        'Flutter desktop sidebar pattern',
      );
      await tester.enterText(
        find.byKey(const ValueKey('share-why')),
        'Try this in my dashboard',
      );
      await tester.tap(find.byKey(const ValueKey('share-done')));
      await tester.pumpAndSettle();

      expect(done, isTrue);
      final sent = server.calls.single;
      expect(sent.title, 'Flutter desktop sidebar pattern');
      expect(sent.intention, 'Try this in my dashboard');
      expect(sent.url, 'https://x.com/someone/status/1844123456789012345');
      final synced = store.captures().single;
      expect(synced.syncState, CaptureSyncState.synced);
      expect(synced.intention, 'Try this in my dashboard');
    });

    testWidgets('edits are kept even if the sheet is closed by back', (
      tester,
    ) async {
      var done = false;
      await tester.pumpWidget(
        _host(
          ShareSheetScreen(
            text: 'https://example.com/flutter-sidebar',
            subject: 'Building a desktop sidebar',
            onDone: () => done = true,
          ),
          store: store,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('share-title')))
            .controller!
            .text,
        'Building a desktop sidebar',
      );
      expect(find.text('Done'), findsOneWidget);
      expect(find.textContaining('Sign in to Pinne to sync'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('share-why')),
        'For the admin panel',
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(done, isTrue);
      final capture = store.captures().single;
      expect(capture.intention, 'For the admin panel');
      expect(capture.held, isFalse);
      expect(
        store.dueOperations(DateTime.now().add(const Duration(days: 1))),
        hasLength(1),
        reason: 'waits in the outbox for sign-in',
      );
    });

    testWidgets('a repeat says it is already in Pinne', (tester) async {
      store.save(parseCaptureInput('https://youtu.be/dQw4w9WgXcQ'));
      await tester.pumpWidget(
        _host(
          ShareSheetScreen(
            text: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ&si=x',
            onDone: () {},
          ),
          store: store,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Already in Pinne'), findsOneWidget);
      expect(find.text('YouTube'), findsOneWidget);
      expect(find.text('Done · back to YouTube'), findsOneWidget);
    });

    testWidgets('an empty share saves nothing', (tester) async {
      var done = false;
      await tester.pumpWidget(
        _host(
          ShareSheetScreen(text: '   ', onDone: () => done = true),
          store: store,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nothing to save'), findsOneWidget);
      expect(find.text('Saved to Pinne'), findsNothing);
      expect(store.captures(), isEmpty);
      await tester.tap(find.text('Close'));
      expect(done, isTrue);
    });
  });

  group('saved list', () {
    testWidgets('shows source, sync state and note as text', (tester) async {
      final synced = store.save(
        parseCaptureInput('https://x.com/a/status/1'),
        intention: 'Try this in my dashboard',
      );
      store.confirm(
        synced.operationId,
        CaptureResult(
          itemId: const Uuid().v4obj(),
          clientItemId: UuidValue.fromString(synced.clientItemId),
          revision: 1,
          title: synced.title,
          sourcePlatform: SourcePlatform.x,
          duplicate: false,
          enrichmentState: EnrichmentState.pending,
          savedAt: synced.capturedAt,
        ),
      );
      store.save(parseCaptureInput('https://youtu.be/dQw4w9WgXcQ'));
      final failed = store.save(parseCaptureInput('Rail on wide screens'));
      store.markFailed(failed.operationId, 'Too many collections.');

      await tester.pumpWidget(
        _host(_page(const SavedSection()), store: store),
      );
      await tester.pumpAndSettle();

      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('X'), findsOneWidget);
      expect(find.text('YouTube'), findsOneWidget);
      expect(find.text('Note'), findsOneWidget);
      expect(find.text('Synced'), findsOneWidget);
      expect(find.text('On phone · sign in to sync'), findsOneWidget);
      expect(find.text('Not synced'), findsOneWidget);
      expect(
        find.text('Your note: “Try this in my dashboard”'),
        findsOneWidget,
      );
      expect(find.text('Too many collections.'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(
        store.capture(failed.clientItemId)!.syncState,
        CaptureSyncState.pending,
      );
    });

    testWidgets('new captures appear without a reload, with motion', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          _page(const SavedSection()),
          store: store,
          motion: MotionPreference.full,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Nothing saved yet'), findsOneWidget);

      store.save(parseCaptureInput('https://github.com/flutter/flutter'));
      await tester.pumpAndSettle();
      // Let the entrance animation start and finish.
      await tester.pump(PinneMotionDurations.slow);
      await tester.pumpAndSettle();
      expect(find.text('GitHub'), findsOneWidget);
      expect(find.text('github.com/flutter/flutter'), findsWidgets);
    });
  });

  group('paste capture', () {
    testWidgets('detects the source and saves locally', (tester) async {
      await tester.pumpWidget(
        _host(_page(const PasteCaptureCard()), store: store),
      );
      final save = find.byKey(const ValueKey('paste-save'));
      expect(tester.widget<FilledButton>(save).onPressed, isNull);

      await tester.enterText(
        find.byKey(const ValueKey('paste-content')),
        'youtube.com/watch?v=dQw4w9WgXcQ&utm_source=newsletter',
      );
      await tester.pump();
      expect(find.text('YouTube'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('paste-why')),
        'Motion reference',
      );
      await tester.tap(save);
      await tester.pumpAndSettle();

      final capture = store.captures().single;
      expect(capture.source, CaptureSource.youtube);
      expect(capture.sourceItemId, 'dQw4w9WgXcQ');
      expect(capture.intention, 'Motion reference');
      expect(capture.url, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ');
      expect(find.textContaining('Saved to Pinne'), findsOneWidget);
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('paste-content')))
            .controller!
            .text,
        isEmpty,
      );
    });

    testWidgets('a repeat is acknowledged as already saved', (tester) async {
      store.save(parseCaptureInput('https://example.com/post?a=1'));
      await tester.pumpWidget(
        _host(_page(const PasteCaptureCard()), store: store),
      );
      await tester.enterText(
        find.byKey(const ValueKey('paste-content')),
        'https://www.example.com/post/?a=1&fbclid=abc',
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('paste-save')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Already in Pinne'), findsOneWidget);
    });
  });
}
