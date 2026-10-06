import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';
import 'package:pinne_flutter/ui/ribbon_spirit/ribbon_painter.dart';
import 'package:pinne_flutter/ui/ribbon_spirit/ribbon_spirit.dart';
import 'package:visibility_detector/visibility_detector.dart';

Future<List<int>> pixels(
  int seed, {
  RibbonMood mood = RibbonMood.idle,
  bool reduced = false,
  double phase = 0,
}) async {
  final recorder = ui.PictureRecorder();
  RibbonPainter(
    recipe: RibbonRecipe(seed),
    palette: PinneSpiritPalettes.values[0],
    mood: mood,
    phase: phase,
    reducedMotion: reduced,
  ).paint(Canvas(recorder), const Size(160, 160));
  final picture = recorder.endRecording();
  final image = await picture.toImage(160, 160);
  final bytes = (await image.toByteData())!.buffer.asUint8List().toList();
  image.dispose();
  picture.dispose();
  return bytes;
}

void main() {
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  test('recipe and rendered pixels are deterministic and varied', () async {
    expect(RibbonRecipe(2026).signature, RibbonRecipe(2026).signature);
    expect(RibbonRecipe.seedForUser('alice'), 293307097);
    final a = await pixels(2026);
    expect(await pixels(2026), a);
    expect(await pixels(2027), isNot(a));
    final identities = {
      for (var seed = 0; seed < 100; seed++)
        RibbonRecipe(seed).signature.join(','),
    };
    expect(identities.length, 100);
    expect(RibbonRecipe.choicesFor('alice').toSet().length, 12);
    expect(PinneSpiritPalettes.values.length, 6);
  });

  test(
    'reduced motion freezes geometry and expresses moods through eyes',
    () async {
      for (final mood in RibbonMood.values) {
        expect(
          await pixels(91, mood: mood, reduced: true, phase: .73),
          await pixels(91, mood: mood, reduced: true),
        );
      }
      final idle = await pixels(91, reduced: true);
      for (final mood in RibbonMood.values.skip(1)) {
        expect(await pixels(91, mood: mood, reduced: true), isNot(idle));
      }
    },
  );

  test('full-motion poses change with time and idle blinks', () async {
    for (final mood in RibbonMood.values) {
      expect(
        await pixels(91, mood: mood, phase: .19),
        isNot(await pixels(91, mood: mood)),
      );
    }
    expect(await pixels(91, phase: .72), isNot(await pixels(91, phase: .70)));
  });

  List<AnimationController> controllers(WidgetTester tester) => tester
      .widgetList<Animate>(find.byType(Animate))
      .map((a) => a.controller!)
      .toList();

  testWidgets(
    'one visible loop; offscreen, ticker, lifecycle and reduce motion pause it',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      Widget spirits({bool enabled = true}) => UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          builder: (context, child) => Consumer(
            builder: (context, ref, _) => MotionPreferenceScope(
              preference: ref.watch(motionPreferenceProvider),
              child: child!,
            ),
          ),
          home: TickerMode(
            enabled: enabled,
            child: ListView(
              children: const [
                RibbonSpirit(seed: 7),
                RibbonSpirit(seed: 91),
                SizedBox(height: 1500),
              ],
            ),
          ),
        ),
      );
      await tester.pumpWidget(spirits());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      expect(controllers(tester).where((c) => c.isAnimating).length, 1);

      await tester.pumpWidget(spirits(enabled: false));
      await tester.pump();
      expect(controllers(tester).every((c) => !c.isAnimating), isTrue);
      await tester.pumpWidget(spirits());
      await tester.pump();
      expect(controllers(tester).where((c) => c.isAnimating).length, 1);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      expect(controllers(tester).every((c) => !c.isAnimating), isTrue);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      expect(controllers(tester).where((c) => c.isAnimating).length, 1);

      final liveControllers = controllers(tester);
      container
          .read(motionPreferenceProvider.notifier)
          .set(MotionPreference.reduced);
      await tester.pump();
      expect(
        liveControllers.every((c) => !c.isAnimating && c.value == 0),
        isTrue,
      );
      container
          .read(motionPreferenceProvider.notifier)
          .set(MotionPreference.full);
      await tester.pump();
      await tester.drag(find.byType(ListView), const Offset(0, -650));
      await tester.pumpAndSettle();
      expect(controllers(tester).every((c) => !c.isAnimating), isTrue);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
