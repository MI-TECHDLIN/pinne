import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/app.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/onboarding/onboarding_store.dart';
import 'package:pinne_flutter/features/today/today_greeting.dart';
import 'package:pinne_flutter/features/tour/tour_store.dart';
import 'package:pinne_flutter/theme/theme_mode.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'capture/fake_capture_server.dart';
import 'support/contrast.dart';
import 'support/golden_theme.dart';

class _SignedOut extends SignedInNotifier {
  @override
  bool build() => false;
}

class _AlwaysReduced extends MotionPreferenceNotifier {
  @override
  MotionPreference build() => MotionPreference.reduced;
}

class _Light extends ThemePreferenceNotifier {
  @override
  PinneThemePreference build() => PinneThemePreference.light;
}

void main() {
  setUpAll(loadGoldenFonts);
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  Widget app({bool onboarded = true, bool toured = true}) => ProviderScope(
    overrides: [
      serverUrlProvider.overrideWithValue('http://localhost:8080/'),
      captureStoreProvider.overrideWithValue(
        CaptureStore(sqlite3.openInMemory()),
      ),
      captureApiProvider.overrideWithValue(FakeCaptureServer()),
      signedInProvider.overrideWith(_SignedOut.new),
      motionPreferenceProvider.overrideWith(_AlwaysReduced.new),
      themePreferenceProvider.overrideWith(_Light.new),
      onboardingStoreProvider.overrideWithValue(
        MemoryOnboardingStore(completed: onboarded),
      ),
      tourStoreProvider.overrideWithValue(MemoryTourStore(seen: toured)),
      greetingClockProvider.overrideWithValue(() => DateTime(2026, 10, 7, 9)),
      greetingIndexPickerProvider.overrideWithValue((_) => 0),
    ],
    child: const PinneApp(),
  );

  Future<void> phone(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  testWidgets('every tab', (tester) async {
    await phone(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    final failures = <String>[];
    for (final tab in ['today', 'collections', 'search', 'progress', 'settings']) {
      final key = find.byKey(ValueKey('nav-$tab'));
      if (key.evaluate().isNotEmpty) {
        await tester.tap(key);
        await tester.pumpAndSettle();
      }
      failures.add('[$tab] n=${find.byType(RichText).evaluate().length} texts=${find.byType(Text).evaluate().map((e) => (e.widget as Text).data).take(8).toList()}');
      failures.add('[$tab] ${(await findContrastFailures(tester)).join('\n  ')}');
    }
    // ignore: avoid_print
    print(failures.join('\n'));
  });
}
