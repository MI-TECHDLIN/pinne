import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/features/progress/progress_widgets.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';

import '../support/golden_theme.dart';
import 'fake_progress_api.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

RateTrendPainter _painter(WidgetTester tester) => tester
    .widgetList<CustomPaint>(find.byType(CustomPaint))
    .map((paint) => paint.painter)
    .whereType<RateTrendPainter>()
    .single;

/// The percentage bubble on the Review rate trend. In Lavender Mist its
/// label was painted in `ink`, the same colour as the bubble, so it vanished.
void main() {
  setUpAll(loadGoldenFonts);

  Widget card(ThemeMode mode) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: pinneLightTheme(),
    darkTheme: pinneDarkTheme(),
    themeMode: mode,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ReviewRateCard(report: sampleReport()),
      ),
    ),
  );

  for (final mode in [ThemeMode.dark, ThemeMode.light]) {
    testWidgets('bubble label reads against its pill in ${mode.name}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(412, 380));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(card(mode));
      await tester.pumpAndSettle();

      final painter = _painter(tester);
      expect(
        _contrast(painter.labelStyle.color!, painter.palette.text),
        greaterThanOrEqualTo(4.5),
      );
      await expectLater(
        find.byType(ReviewRateCard),
        matchesGoldenFile(
          mode == ThemeMode.light
              ? '../../../docs/light-theme/review-rate-card.png'
              : '../../../docs/progress/review-rate-card.png',
        ),
      );
    });
  }

  testWidgets('bubble label follows a theme switch', (tester) async {
    await tester.pumpWidget(card(ThemeMode.dark));
    await tester.pumpAndSettle();
    final dark = _painter(tester);

    await tester.pumpWidget(card(ThemeMode.light));
    await tester.pumpAndSettle();
    final light = _painter(tester);

    expect(light.labelStyle.color, isNot(dark.labelStyle.color));
    expect(light.shouldRepaint(dark), isTrue);
    for (final painter in [dark, light]) {
      expect(
        _contrast(painter.labelStyle.color!, painter.palette.text),
        greaterThanOrEqualTo(4.5),
      );
    }
  });
}
