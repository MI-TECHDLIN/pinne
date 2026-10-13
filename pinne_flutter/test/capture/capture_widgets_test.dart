import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/capture/paste_capture_card.dart';
import 'package:pinne_flutter/features/capture/save_celebration.dart';
import 'package:pinne_flutter/features/capture/saved_section.dart';
import 'package:pinne_flutter/features/capture/share_sheet.dart';
import 'package:pinne_flutter/features/settings/profile_provider.dart';
import 'package:pinne_flutter/shell/pill_nav_bar.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:pinne_flutter/ui/ribbon_spirit/ribbon_spirit.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'fake_capture_server.dart';

class _SignedIn extends SignedInNotifier {
  _SignedIn(this.value);

  final bool value;

  @override
  bool build() => value;
}

class _AccountId extends AccountIdNotifier {
  @override
  String? build() => CaptureStore.testAccountId;
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
      accountIdProvider.overrideWith(_AccountId.new),
      avatarRecipeProvider.overrideWithValue((seed: 2026, palette: 0)),
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

/// Lays out like `AppShell`: the tab's own navigator under the floating nav.
Widget _shellHost({required CaptureStore store}) => _host(
  Scaffold(
    extendBody: true,
    body: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        builder: (_) => const Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CaptureEntryTile(),
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: FloatingPillNav(
      child: PillNavBar(
        destinations: const [
          PillNavDestination(label: 'Today', icon: Icons.today_rounded),
        ],
        selectedIndex: 0,
        onSelected: (_) {},
      ),
    ),
  ),
  store: store,
);

/// A phone in logical pixels: [systemBottom] is the gesture or button bar and
/// [keyboard] the on-screen keyboard once a field has focus.
typedef _Phone = ({Size size, double systemBottom, double keyboard});

const _phones = <_Phone>[
  (size: Size(360, 640), systemBottom: 24, keyboard: 300),
  (size: Size(393, 851), systemBottom: 48, keyboard: 300),
];

String _name(_Phone phone) =>
    '${phone.size.width.toInt()}x${phone.size.height.toInt()}';

/// Test views take physical pixels, so every inset is scaled by the ratio.
void _usePhone(WidgetTester tester, _Phone phone) {
  final ratio = tester.view.devicePixelRatio;
  tester.view.physicalSize = phone.size * ratio;
  final bar = FakeViewPadding(bottom: phone.systemBottom * ratio);
  tester.view.viewPadding = bar;
  tester.view.padding = bar;
  addTearDown(tester.view.reset);
}

/// Android reports the keyboard as an inset and drops the bottom padding it
/// covers.
void _showKeyboard(WidgetTester tester, _Phone phone) {
  final ratio = tester.view.devicePixelRatio;
  tester.view.viewInsets = FakeViewPadding(bottom: phone.keyboard * ratio);
  tester.view.padding = FakeViewPadding.zero;
}

/// Scrolls the control into view as focusing it would, then checks that it
/// is on screen, above the keyboard, clear of [avoid] and takes taps.
Future<void> _expectReachable(
  WidgetTester tester,
  String key, {
  required _Phone phone,
  required bool keyboard,
  Rect? avoid,
}) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  final control = tester.getRect(finder);
  final visible =
      Offset.zero &
      Size(
        phone.size.width,
        phone.size.height - (keyboard ? phone.keyboard : phone.systemBottom),
      );
  expect(
    visible.intersect(control) == control,
    isTrue,
    reason: '$key $control must be inside the visible area $visible',
  );
  if (avoid != null) {
    expect(
      control.overlaps(avoid),
      isFalse,
      reason: '$key $control must not be under the nav $avoid',
    );
  }
  final target = tester.renderObject(finder);
  expect(
    tester
        .hitTestOnBinding(control.center)
        .path
        .any((entry) => entry.target == target),
    isTrue,
    reason: '$key must receive a tap at its centre',
  );
}

void main() {
  late CaptureStore store;
  setUp(() {
    store = CaptureStore(sqlite3.openInMemory());
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });
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
      expect(find.byKey(const ValueKey('save-celebration')), findsNothing);
    });

    for (final phone in _phones) {
      testWidgets('share fields stay above a keyboard on ${_name(phone)}', (
        tester,
      ) async {
        _usePhone(tester, phone);
        await tester.pumpWidget(
          _host(
            ShareSheetScreen(
              text: 'https://example.com/read-later',
              onDone: () {},
            ),
            store: store,
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('share-why')));
        _showKeyboard(tester, phone);
        await tester.pumpAndSettle();

        for (final key in ['share-title', 'share-why', 'share-done']) {
          await _expectReachable(tester, key, phone: phone, keyboard: true);
        }
        await tester.pumpWidget(const SizedBox());
      });
    }

    testWidgets('a new share celebrates once; a repeat does not', (
      tester,
    ) async {
      Future<void> share() async {
        await tester.pumpWidget(
          _host(
            ShareSheetScreen(
              text: 'https://example.com/shared',
              onDone: () {},
            ),
            store: store,
            motion: MotionPreference.full,
          ),
        );
        await tester.pump(const Duration(milliseconds: 1));
      }

      await share();
      expect(find.byKey(const ValueKey('save-celebration')), findsOneWidget);
      expect(find.byKey(const ValueKey('save-sparkles')), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(saveCelebrationDuration);
      await tester.pump();
      expect(find.byKey(const ValueKey('save-celebration')), findsNothing);
      await tester.pumpWidget(const SizedBox());

      await share();
      expect(find.text('Already in Pinne'), findsOneWidget);
      expect(find.byKey(const ValueKey('save-celebration')), findsNothing);
      await tester.pumpWidget(const SizedBox());
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
    Item previewItem({
      required EnrichmentState enrichment,
      AccessState access = AccessState.unknown,
      String? thumbnail,
      String? author,
      int? duration,
    }) => Item(
      id: const Uuid().v4obj(),
      ownerId: const Uuid().v4obj(),
      url: 'https://example.com/article',
      title: 'The extracted title',
      sourcePlatform: SourcePlatform.web,
      enrichmentState: enrichment,
      accessState: access,
      thumbnailUrl: thumbnail,
      previewAuthor: author,
      durationSeconds: duration,
    );

    Future<void> showPreview(WidgetTester tester, Item item) async {
      final capture = store.save(
        parseCaptureInput('https://example.com/article'),
        intention: 'Keep this note prominent',
      );
      await tester.pumpWidget(
        _host(
          _page(SavedCard(capture: capture, signedIn: true, item: item)),
          store: store,
        ),
      );
      await tester.pump();
    }

    testWidgets('pending preview shows a soft skeleton', (tester) async {
      await showPreview(
        tester,
        previewItem(enrichment: EnrichmentState.pending),
      );
      expect(find.byKey(const ValueKey('preview-skeleton')), findsOneWidget);
      expect(
        find.text('Your note: “Keep this note prominent”'),
        findsOneWidget,
      );
    });

    testWidgets('ready preview shows thumbnail, author and known duration', (
      tester,
    ) async {
      await showPreview(
        tester,
        previewItem(
          enrichment: EnrichmentState.ready,
          access: AccessState.available,
          thumbnail: 'https://images.example.com/preview.jpg',
          author: 'A. Builder',
          duration: 125,
        ),
      );
      expect(find.byKey(const ValueKey('preview-thumbnail')), findsOneWidget);
      expect(find.text('The extracted title'), findsOneWidget);
      expect(find.text('A. Builder'), findsOneWidget);
      expect(find.text('2:05'), findsOneWidget);
    });

    testWidgets('unavailable preview keeps an honest line and user note', (
      tester,
    ) async {
      await showPreview(
        tester,
        previewItem(
          enrichment: EnrichmentState.failed,
          access: AccessState.unavailable,
        ),
      );
      expect(
        find.text('Preview not available. The link is saved.'),
        findsOneWidget,
      );
      expect(
        find.text('Your note: “Keep this note prominent”'),
        findsOneWidget,
      );
    });

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

      await tester.pumpWidget(_host(_page(const SavedSection()), store: store));
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
    for (final phone in _phones) {
      for (final keyboard in [false, true]) {
        testWidgets(
          'the sheet clears the floating nav on ${_name(phone)}'
          '${keyboard ? ' with a keyboard' : ''}',
          (tester) async {
            _usePhone(tester, phone);
            await tester.pumpWidget(_shellHost(store: store));
            await tester.tap(find.byKey(const ValueKey('capture-entry')));
            await tester.pumpAndSettle();
            await tester.enterText(
              find.byKey(const ValueKey('paste-content')),
              'https://example.com/read-later',
            );
            if (keyboard) _showKeyboard(tester, phone);
            await tester.pumpAndSettle();

            final nav = tester.getRect(
              find.byKey(const ValueKey('pill-nav-pill')),
            );
            for (final key in ['paste-content', 'paste-why', 'paste-save']) {
              await _expectReachable(
                tester,
                key,
                phone: phone,
                keyboard: keyboard,
                avoid: nav,
              );
            }
          },
        );
      }
    }

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

    testWidgets('a new save celebrates once with haptic and sparkles', (
      tester,
    ) async {
      final haptics = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'HapticFeedback.vibrate') haptics.add(call);
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await tester.pumpWidget(
        _host(
          _page(const PasteCaptureCard()),
          store: store,
          motion: MotionPreference.full,
        ),
      );
      await tester.enterText(
        find.byKey(const ValueKey('paste-content')),
        'https://example.com/new-save',
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('paste-save')));
      await tester.pump();

      expect(haptics, hasLength(1));
      expect(find.byKey(const ValueKey('save-celebration')), findsOneWidget);
      expect(find.byKey(const ValueKey('save-sparkles')), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
      expect(
        tester.widget<RibbonSpirit>(find.byType(RibbonSpirit)).mood,
        RibbonMood.excited,
      );
      expect(haptics.single.arguments, 'HapticFeedbackType.lightImpact');

      await tester.pump(
        saveCelebrationDuration + const Duration(milliseconds: 100),
      );
      await tester.pump();
      expect(find.byKey(const ValueKey('save-celebration')), findsNothing);
    });

    testWidgets('reduced motion uses a static happy confirmation', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(_page(const PasteCaptureCard()), store: store),
      );
      await tester.enterText(
        find.byKey(const ValueKey('paste-content')),
        'https://example.com/calm-save',
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('paste-save')));
      await tester.pump();

      final spirit = tester.widget<RibbonSpirit>(find.byType(RibbonSpirit));
      expect(spirit.mood, RibbonMood.happy);
      expect(spirit.animate, isFalse);
      expect(find.byKey(const ValueKey('save-sparkles')), findsNothing);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      await tester.pump(saveCelebrationDuration);
      await tester.pump();
    });

    testWidgets('the celebration shows above a keyboard that is still up', (
      tester,
    ) async {
      final phone = _phones.first;
      _usePhone(tester, phone);
      await tester.pumpWidget(_shellHost(store: store));
      await tester.tap(find.byKey(const ValueKey('capture-entry')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('paste-content')),
        'https://example.com/typed-save',
      );
      _showKeyboard(tester, phone);
      await tester.pumpAndSettle();
      final save = find.byKey(const ValueKey('paste-save'));
      await tester.ensureVisible(save);
      await tester.pumpAndSettle();
      await tester.tap(save);
      await tester.pump();
      await tester.pump(saveCelebrationDuration * 0.5);

      final card = tester.getRect(
        find.byKey(const ValueKey('save-celebration-card')),
      );
      expect(card.top, greaterThanOrEqualTo(0));
      expect(
        card.bottom,
        lessThanOrEqualTo(phone.size.height - phone.keyboard),
      );

      await tester.pump(saveCelebrationDuration);
      await tester.pump();
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
      await tester.pump();
      expect(find.textContaining('Already in Pinne'), findsOneWidget);
      expect(find.byKey(const ValueKey('save-celebration')), findsNothing);
    });
  });
}
