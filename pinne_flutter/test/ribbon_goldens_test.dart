import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/features/today/today_screen.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';
import 'package:pinne_flutter/ui/ribbon_spirit/ribbon_gallery.dart';
import 'package:pinne_flutter/ui/ribbon_spirit/ribbon_spirit.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'support/golden_theme.dart';

void main() {
  setUpAll(loadGoldenFonts);
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  Widget frame(Widget child) => ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: goldenTheme(),
      builder: (context, child) => MotionPreferenceScope(
        preference: MotionPreference.full,
        child: child!,
      ),
      home: Scaffold(body: child),
    ),
  );

  testWidgets('twelve identities in all four moods', (tester) async {
    await tester.binding.setSurfaceSize(const Size(720, 1770));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      frame(
        const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PINNE / RIBBON SPIRIT',
                style: TextStyle(
                  color: PinneColors.lilac,
                  fontSize: 14,
                  letterSpacing: 3,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'A little soul. A different twist.',
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(height: 24),
              RibbonContactSheet(),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../docs/ribbon-spirit/gallery.png'),
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('hero, avatar sizes and Today states', (tester) async {
    await tester.binding.setSurfaceSize(const Size(880, 1040));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      frame(
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'YOUR LITTLE COMPANION',
                style: TextStyle(
                  color: PinneColors.lilac,
                  fontSize: 14,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Made of saved possibilities.',
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RibbonSpirit(seed: 2026, size: 280, animate: false),
                  RibbonSpirit(seed: 2026, size: 88, animate: false),
                  RibbonSpirit(seed: 2026, size: 48, animate: false),
                  RibbonSpirit(seed: 2026, size: 32, animate: false),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TodaySpiritCard(
                      due: true,
                      seed: 2026,
                      palette: 0,
                      animate: false,
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: TodaySpiritCard(
                      due: false,
                      seed: 2026,
                      palette: 0,
                      animate: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              const Text(
                'SIX COLOURS / NO LIME IN THE RIBBON',
                style: TextStyle(color: PinneColors.muted, letterSpacing: 2),
              ),
              Row(
                children: [
                  for (var palette = 0; palette < 6; palette++)
                    Expanded(
                      child: Column(
                        children: [
                          RibbonSpirit(
                            seed: 2026,
                            palette: palette,
                            size: 112,
                            animate: false,
                          ),
                          Text(PinneSpiritPalettes.values[palette].name),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../docs/ribbon-spirit/first-uses.png'),
    );
    await tester.pumpWidget(const SizedBox());
  });
}
