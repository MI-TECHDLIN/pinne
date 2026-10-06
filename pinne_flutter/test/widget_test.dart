import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/app.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';

class _SignedOut extends SignedInNotifier {
  @override
  bool build() => false;
}

class _PlatformReducesMotion extends PlatformReduceMotionNotifier {
  @override
  bool build() => true;
}

Widget _app({List overrides = const []}) => ProviderScope(
  overrides: [
    serverUrlProvider.overrideWithValue('http://localhost:8080/'),
    signedInProvider.overrideWith(_SignedOut.new),
    serverHealthProvider.overrideWith(
      (ref) async => ServerHealth(
        ok: true,
        databaseOk: true,
        serverTime: DateTime.utc(2026, 10, 6),
        version: '0.1.0',
      ),
    ),
    ...overrides,
  ],
  child: const PinneApp(),
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('starts on Today and the pill nav switches tabs', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    expect(find.textContaining('a few good saves'), findsOneWidget);

    final tabs = {
      'collections': 'collections',
      'search': 'what you remember',
      'progress': 'progress',
      'today': 'a few good saves',
    };
    for (final MapEntry(key: tab, value: headline) in tabs.entries) {
      await tester.tap(find.byKey(ValueKey('nav-$tab')));
      await tester.pumpAndSettle();
      expect(find.textContaining(headline), findsWidgets, reason: tab);
    }
  });

  testWidgets('Settings shows server health from the health endpoint', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.byKey(const ValueKey('nav-settings')));
    await tester.pumpAndSettle();

    expect(find.text('Server online'), findsOneWidget);
    expect(find.text('API 0.1.0'), findsOneWidget);
    expect(find.text('http://localhost:8080/'), findsOneWidget);
  });

  testWidgets('the selected tab is announced as selected', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byKey(const ValueKey('nav-today'))),
      matchesSemantics(
        label: 'Today',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );
    semantics.dispose();
  });

  test('reduce motion follows the platform unless overridden', () {
    final container = ProviderContainer(
      overrides: [
        platformReduceMotionProvider.overrideWith(_PlatformReducesMotion.new),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(reduceMotionProvider), isTrue);
    container
        .read(motionPreferenceProvider.notifier)
        .set(MotionPreference.full);
    expect(container.read(reduceMotionProvider), isFalse);
  });
}
