import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme/pinne_tokens.dart';
import 'ribbon_recipe.dart';

enum RibbonMood { idle, happy, sleepy, excited }

/// Satin ribbon: a tapered spiral with a shaded underside and a fine rolled rim.
/// Geometry is in a 100 × 100 coordinate space; no raster assets or blur layers.
class RibbonPainter extends CustomPainter {
  RibbonPainter({
    required this.recipe,
    required this.palette,
    required this.mood,
    this.phase = 0,
    this.reducedMotion = false,
    this.transitionFrom,
    this.transitionProgress = 1,
  });

  final RibbonRecipe recipe;
  final SpiritPalette palette;
  final RibbonMood mood;
  final double phase;
  final bool reducedMotion;
  final double? transitionFrom;
  final double transitionProgress;

  double get wave => math.sin(phase * math.pi * 2);

  // Reduced motion keeps exactly the same body for every mood.
  double get opening {
    if (reducedMotion) return 0;
    final pose = switch (mood) {
      RibbonMood.idle => wave * .025,
      RibbonMood.happy =>
        -.12 + .045 * math.sin(phase * math.pi * 6) * math.pow(1 - phase, 3),
      RibbonMood.sleepy => -.035 + wave * .012,
      RibbonMood.excited => math.sin(phase * math.pi * 8) * .055,
    };
    return transitionFrom == null
        ? pose
        : ui.lerpDouble(
            transitionFrom,
            pose,
            Curves.elasticOut.transform(transitionProgress),
          )!;
  }

  Offset _point(double t) {
    final theta = -1.15 + t * math.pi * 2 * (recipe.curls + opening);
    final radius = 36 - t * 31;
    return Offset(
      50 + math.cos(theta) * radius,
      47 + math.sin(theta) * radius * recipe.aspect,
    );
  }

  Offset _normal(double t) {
    final tangent = _point(t + .0001) - _point(t - .0001);
    return Offset(-tangent.dy, tangent.dx) / tangent.distance;
  }

  double _width(double t) =>
      .45 +
      recipe.thickness * math.pow(math.sin(math.pi * t.clamp(0, 1)), .65) / 2;

  Offset _edge(double t, double side) =>
      _point(t) + _normal(t) * _width(t) * side;

  Path _strip(double start, double end, double left, double right) {
    final steps = math.max(3, ((end - start) * 220).ceil());
    final path = Path();
    for (var i = 0; i <= steps; i++) {
      final p = _edge(start + (end - start) * i / steps, left);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    for (var i = steps; i >= 0; i--) {
      final p = _edge(start + (end - start) * i / steps, right);
      path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);
    final bounce = !reducedMotion && mood == RibbonMood.excited
        ? -2.3 * math.pow(math.sin(phase * math.pi * 4), 2)
        : 0.0;
    canvas.translate(50, 50 + bounce);
    canvas.rotate(recipe.tilt);
    canvas.translate(-50, -50);

    final silhouette = _strip(0, 1, -1, 1);
    canvas.drawPath(
      silhouette.shift(const Offset(0, 1.1)),
      Paint()..color = palette.shadow.withValues(alpha: .65),
    );

    // The path gives an antialiased silhouette. Shared vertices interpolate
    // the satin gradient continuously, without seams between separate shaders.
    canvas.drawPath(silhouette, Paint()..color = palette.body);
    _paintSatin(canvas, silhouette);

    // Unbroken thin highlight along the inner lip, fading toward both tips.
    canvas.drawPath(
      _strip(.09, .86, -.83, -.78),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.light.withValues(alpha: 0),
            palette.light.withValues(alpha: .8),
            palette.light.withValues(alpha: 0),
          ],
        ).createShader(const Rect.fromLTWH(12, 14, 76, 72)),
    );

    final faceT =
        (math.pi / 2 + 1.15) / (math.pi * 2 * (recipe.curls + opening));
    final face = _point(faceT);
    canvas.save();
    canvas.translate(face.dx, face.dy - .5);
    // Keep the eyes upright within the character's seeded tilt.
    _eyes(canvas);
    canvas.restore();
    canvas.restore();
  }

  void _paintSatin(Canvas canvas, Path silhouette) {
    const samples = 180;
    const stops = [0.0, .14, .36, .82, 1.0];
    final points = <Offset>[];
    final colors = <Color>[];
    final indices = <int>[];
    for (var i = 0; i <= samples; i++) {
      final t = i / samples;
      final p = _point(t);
      final n = _normal(t) * _width(t);
      final shine = .5 + .5 * math.cos(t * math.pi * 2 + recipe.gradientAngle);
      final base = Color.lerp(palette.shadow, palette.body, .52 + shine * .48)!;
      colors.addAll([
        Color.lerp(palette.shadow, base, .3)!,
        Color.lerp(base, palette.light, .64)!,
        Color.lerp(base, palette.light, .28)!,
        base,
        Color.lerp(palette.shadow, base, .4)!,
      ]);
      for (final stop in stops) {
        points.add(p + n * (stop * 2 - 1));
      }
    }
    // Inner tip first: the broad outer fold carries the face in front.
    for (var i = samples - 1; i >= 0; i--) {
      for (var j = 0; j < stops.length - 1; j++) {
        final a = i * stops.length + j;
        final b = a + stops.length;
        indices.addAll([a, b, a + 1, a + 1, b, b + 1]);
      }
    }
    final ribbon = ui.Vertices(
      ui.VertexMode.triangles,
      points,
      colors: colors,
      indices: indices,
    );
    canvas.save();
    canvas.clipPath(silhouette);
    canvas.drawVertices(ribbon, BlendMode.dst, Paint());
    canvas.restore();
    ribbon.dispose();
  }

  void _eyes(Canvas canvas) {
    final paint = Paint()
      ..color = PinneColors.text
      ..strokeCap = StrokeCap.round;
    final blinking =
        !reducedMotion &&
        mood == RibbonMood.idle &&
        ((phase > .71 && phase < .733) || (phase > .755 && phase < .774));
    for (final x in [-4.6, 4.6]) {
      if (mood == RibbonMood.happy || mood == RibbonMood.sleepy || blinking) {
        final happy = mood == RibbonMood.happy;
        final path = Path()
          ..moveTo(x - 2, happy ? 1.2 : 0)
          ..quadraticBezierTo(x, happy ? -2.5 : 1.6, x + 2, happy ? 1.2 : 0);
        canvas.drawPath(
          path,
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.55,
        );
      } else {
        final excited = mood == RibbonMood.excited;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(x, 0),
            width: excited ? 4.7 : 3.8,
            height: excited ? 8 : 6.7,
          ),
          paint..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(RibbonPainter oldDelegate) =>
      recipe != oldDelegate.recipe ||
      palette != oldDelegate.palette ||
      mood != oldDelegate.mood ||
      phase != oldDelegate.phase ||
      reducedMotion != oldDelegate.reducedMotion ||
      transitionFrom != oldDelegate.transitionFrom ||
      transitionProgress != oldDelegate.transitionProgress;
}
