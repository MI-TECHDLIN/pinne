import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';

import 'director.dart';
import 'tour.dart';

/// The film's own drawing: the stage behind the app screen and its type.
/// Colours are the app's tokens.
abstract final class Words {
  static TextStyle kicker([Color color = PinneColors.lilac]) => TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 3.2,
    color: color,
  );

  static TextStyle title([double size = 66]) => TextStyle(
    fontFamily: 'Outfit',
    fontSize: size,
    fontWeight: FontWeight.w600,
    height: 1.06,
    letterSpacing: -1.2,
    color: PinneColors.text,
  );

  static TextStyle light([double size = 66]) => TextStyle(
    fontFamily: 'Outfit',
    fontSize: size,
    fontWeight: FontWeight.w300,
    height: 1.06,
    letterSpacing: -1.2,
    color: PinneColors.text,
  );

  static TextStyle body([double size = 31]) => TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: size,
    fontWeight: FontWeight.w500,
    height: 1.42,
    color: PinneColors.muted,
  );
}

/// Midnight with slow violet and plum glows, like the app's own screens.
class StageBackground extends StatelessWidget {
  const StageBackground({super.key});

  @override
  Widget build(BuildContext context) => AtTime(
    builder: (context, t, _) {
      final drift = math.sin(t * 0.35);
      return Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: PinneColors.midnight),
          Positioned(
            left: -420 + drift * 40,
            top: -520,
            width: 1500,
            height: 1300,
            child: const _Glow(color: Color(0xFF3A2380), opacity: 0.85),
          ),
          Positioned(
            right: -500 - drift * 50,
            bottom: -620,
            width: 1600,
            height: 1300,
            child: const _Glow(color: Color(0xFF4A1F63), opacity: 0.55),
          ),
        ],
      );
    },
  );
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.opacity});

  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: RadialGradient(
        colors: [
          color.withValues(alpha: opacity),
          color.withValues(alpha: 0),
        ],
      ),
    ),
  );
}

/// A full stage: background, the app screen placed by the guide's camera,
/// anything extra, then the callout and the cursor on top.
class Stage extends StatelessWidget {
  const Stage({super.key, this.screen, this.extra = const []});

  final Widget? screen;
  final List<Widget> extra;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: SizedBox.fromSize(
      size: Film.size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const StageBackground(),
          if (screen != null) ScreenRig(screen: screen!),
          ...extra,
          if (screen != null) ...[const CalloutLayer(), const CursorLayer()],
        ],
      ),
    ),
  );
}
