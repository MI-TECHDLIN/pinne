import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/capture/paste_capture_card.dart';
import 'package:pinne_flutter/features/capture/save_celebration.dart';
import 'package:pinne_flutter/features/capture/share_sheet.dart';
import 'package:pinne_flutter/features/settings/profile_provider.dart';
import 'package:pinne_flutter/shell/app_shell.dart';
import 'package:pinne_flutter/shell/pill_nav_bar.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../support/golden_theme.dart';
import 'fake_capture_server.dart';

class _SignedOut extends SignedInNotifier {
  @override
  bool build() => false;
}

class _AccountId extends AccountIdNotifier {
  @override
  String? build() => CaptureStore.testAccountId;
}

/// Renders the Save-a-link sheet over the pill nav, the save celebration and
/// the Android share card for docs/capture/ and docs/light-theme/.
void main() {
  setUpAll(loadGoldenFonts);
  late CaptureStore store;
  setUp(() {
    store = CaptureStore(sqlite3.openInMemory());
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });
  tearDown(() => store.close());

  Widget app({MotionPreference motion = MotionPreference.full}) =>
      ProviderScope(
        overrides: [
          captureStoreProvider.overrideWithValue(store),
          captureApiProvider.overrideWithValue(FakeCaptureServer()),
          signedInProvider.overrideWith(_SignedOut.new),
          accountIdProvider.overrideWith(_AccountId.new),
          avatarRecipeProvider.overrideWithValue((seed: 2026, palette: 0)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: goldenTheme(),
          builder: (context, child) =>
              MotionPreferenceScope(preference: motion, child: child!),
          home: Scaffold(
            extendBody: true,
            body: Navigator(
              onGenerateRoute: (_) => MaterialPageRoute<void>(
                builder: (_) => const Scaffold(
                  body: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(PinneSpacing.lg),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: CaptureEntryTile(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: FloatingPillNav(
              child: PillNavBar(
                destinations: shellDestinations,
                selectedIndex: 0,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      );

  void usePhone(WidgetTester tester, Size size, double systemBottom) {
    final ratio = tester.view.devicePixelRatio;
    tester.view.physicalSize = size * ratio;
    final bar = FakeViewPadding(top: 24 * ratio, bottom: systemBottom * ratio);
    tester.view.viewPadding = bar;
    tester.view.padding = bar;
    addTearDown(tester.view.reset);
  }

  Future<void> openWithLink(WidgetTester tester, String link) async {
    await tester.tap(find.byKey(const ValueKey('capture-entry')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('paste-content')), link);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
  }

  for (final (size, systemBottom) in [
    (const Size(360, 640), 24.0),
    (const Size(393, 851), 48.0),
  ]) {
    final name = '${size.width.toInt()}x${size.height.toInt()}';
    testWidgets('save sheet on $name', (tester) async {
      usePhone(tester, size, systemBottom);
      await tester.pumpWidget(app());
      await openWithLink(tester, 'https://example.com/read-later');
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../../../docs/capture/save-sheet-$name.png'),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  for (final reduced in [false, true]) {
    testWidgets('save celebration${reduced ? ' (reduced motion)' : ''}', (
      tester,
    ) async {
      usePhone(tester, const Size(393, 851), 48);
      await tester.pumpWidget(
        app(motion: reduced ? MotionPreference.reduced : MotionPreference.full),
      );
      await openWithLink(tester, 'https://example.com/read-later');
      await tester.tap(find.byKey(const ValueKey('paste-save')));
      // The peak: the Spirit has landed its hop and the sparkles are out.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 560));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          '../../../docs/capture/save-celebration${reduced ? '-reduced' : ''}.png',
        ),
      );
      await tester.pump(saveCelebrationDuration);
      await tester.pump();
      expect(find.byKey(const ValueKey('save-celebration')), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });
  }

  for (final brightness in Brightness.values) {
    final light = brightness == Brightness.light;
    testWidgets('share card before Done in ${brightness.name}', (tester) async {
      usePhone(tester, const Size(393, 851), 48);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            captureStoreProvider.overrideWithValue(store),
            captureApiProvider.overrideWithValue(FakeCaptureServer()),
            signedInProvider.overrideWith(_SignedOut.new),
            accountIdProvider.overrideWith(_AccountId.new),
            avatarRecipeProvider.overrideWithValue((seed: 2026, palette: 0)),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: goldenTheme(brightness: brightness),
            builder: (context, child) => MotionPreferenceScope(
              preference: MotionPreference.reduced,
              child: child!,
            ),
            home: ShareSheetScreen(
              text: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
              subject: 'Calm interface design, explained',
              onDone: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          light
              ? '../../../docs/light-theme/share-sheet.png'
              : '../../../docs/capture/share-sheet.png',
        ),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }
}
