import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';

import 'director.dart';

/// The film's own drawing: stage, captions, a brand-free phone frame and
/// touch markers. Colours are the app's tokens.
abstract final class Words {
  static TextStyle kicker([Color color = PinneColors.lilac]) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 3.2,
        color: color,
      );

  static TextStyle title([double size = 66]) => GoogleFonts.outfit(
    fontSize: size,
    fontWeight: FontWeight.w600,
    height: 1.06,
    letterSpacing: -1.2,
    color: PinneColors.text,
  );

  static TextStyle light([double size = 66]) => GoogleFonts.outfit(
    fontSize: size,
    fontWeight: FontWeight.w300,
    height: 1.06,
    letterSpacing: -1.2,
    color: PinneColors.text,
  );

  static TextStyle body([double size = 31]) => GoogleFonts.plusJakartaSans(
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

/// One caption on the left of the stage.
class Cue {
  const Cue(
    this.start,
    this.end, {
    this.kicker,
    required this.title,
    this.body,
  });

  final double start;
  final double end;
  final String? kicker;
  final String title;
  final String? body;
}

/// Captions that rise in and fade out, never over the phone.
class Captions extends StatelessWidget {
  const Captions(
    this.cues, {
    super.key,
    this.left = 130,
    this.width = 700,
    this.top,
  });

  final List<Cue> cues;
  final double left;
  final double width;

  /// Pins captions to this height instead of centring them.
  final double? top;

  @override
  Widget build(BuildContext context) => AtTime(
    builder: (context, t, _) {
      final visible = [
        for (final cue in cues)
          if (t >= cue.start - 0.01 && t <= cue.end + 0.01) cue,
      ];
      return Stack(
        children: [
          for (final cue in visible)
            Positioned(
              left: left,
              width: width,
              top: top ?? 0,
              bottom: top == null ? 0 : null,
              child: _CueView(cue: cue, t: t, centred: top == null),
            ),
        ],
      );
    },
  );
}

class _CueView extends StatelessWidget {
  const _CueView({required this.cue, required this.t, this.centred = true});

  final Cue cue;
  final double t;
  final bool centred;

  @override
  Widget build(BuildContext context) {
    final out = 1 - ramp(t, cue.end - 0.3, 0.3, Curves.easeInCubic);
    double part(double delay) {
      final p = ramp(t, cue.start + delay, 0.55);
      return p * out;
    }

    Widget rise(double delay, Widget child) {
      final p = part(delay);
      return Opacity(
        opacity: p.clamp(0, 1),
        child: Transform.translate(
          offset: Offset(0, (1 - ramp(t, cue.start + delay, 0.55)) * 28),
          child: child,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: centred ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (cue.kicker != null) ...[
          rise(0, Text(cue.kicker!.toUpperCase(), style: Words.kicker())),
          const SizedBox(height: 22),
        ],
        rise(0.08, Text(cue.title, style: Words.title())),
        if (cue.body != null) ...[
          const SizedBox(height: 26),
          rise(0.2, Text(cue.body!, style: Words.body())),
        ],
      ],
    );
  }
}

/// Where the phone sits: the phone-local point [focus] is drawn at stage
/// point [at], magnified by [scale].
class Pose {
  const Pose(
    this.time, {
    this.focus,
    this.at = const Offset(1350, 540),
    this.scale = 1,
  });

  final double time;
  final Offset? focus;
  final Offset at;
  final double scale;
}

/// Screen size of the filmed phone, in logical pixels.
const phoneScreen = Size(412, 892);
const _bezel = 13.0;
const phoneSize = Size(412 + _bezel * 2, 892 + _bezel * 2);
const phoneCenter = Offset(206 + _bezel, 446 + _bezel);

/// Converts a point on the app's screen to the phone's own coordinates.
Offset onScreen(double x, double y) => Offset(x + _bezel, y + _bezel);

/// The phone, moved by a camera between [poses] with eased motion.
class PhoneRig extends StatelessWidget {
  const PhoneRig({
    super.key,
    required this.poses,
    required this.screen,
    this.opacity,
  });

  final List<Pose> poses;
  final Widget screen;

  /// Optional fade for the whole phone.
  final double Function(double t)? opacity;

  @override
  Widget build(BuildContext context) => AtTime(
    child: PhoneFrame(child: screen),
    builder: (context, t, phone) {
      var a = poses.first;
      var b = poses.first;
      for (final pose in poses) {
        if (pose.time <= t) {
          a = pose;
          b = pose;
        } else {
          b = pose;
          break;
        }
      }
      final p = a == b
          ? 0.0
          : Curves.easeInOutCubic.transform(
              ((t - a.time) / (b.time - a.time)).clamp(0, 1),
            );
      final focus = Offset.lerp(
        a.focus ?? phoneCenter,
        b.focus ?? phoneCenter,
        p,
      )!;
      final at = Offset.lerp(a.at, b.at, p)!;
      final scale = ui.lerpDouble(a.scale, b.scale, p)!;
      final topLeft = at - focus * scale;
      final o = opacity?.call(t) ?? 1;
      return Stack(
        children: [
          // Sized to the scaled phone so taps hit-test where it is drawn.
          Positioned(
            left: topLeft.dx,
            top: topLeft.dy,
            width: phoneSize.width * scale,
            height: phoneSize.height * scale,
            child: Opacity(
              opacity: o.clamp(0, 1),
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox.fromSize(size: phoneSize, child: phone),
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// A plain modern phone drawn for the film: no maker's shape or marks.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: phoneSize,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(56),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B3352), Color(0xFF16121F), Color(0xFF2C2540)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 80,
            spreadRadius: 4,
            offset: Offset(0, 40),
          ),
          BoxShadow(
            color: Color(0x332A1B5A),
            blurRadius: 140,
            spreadRadius: 30,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF07050C),
            borderRadius: BorderRadius.circular(53),
          ),
          child: Padding(
            padding: const EdgeInsets.all(_bezel - 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(44),
              child: SizedBox.fromSize(
                size: phoneScreen,
                child: MediaQuery(
                  data: const MediaQueryData(
                    size: phoneScreen,
                    devicePixelRatio: 2.625,
                    padding: EdgeInsets.only(top: 34, bottom: 18),
                    viewPadding: EdgeInsets.only(top: 34, bottom: 18),
                    platformBrightness: Brightness.dark,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: PinneColors.midnight),
                      child,
                      const _StatusBar(),
                      const _GestureBar(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 34,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            children: [
              Text(
                '10:24',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: PinneColors.text,
                ),
              ),
              const Spacer(),
              // Camera hole, centred.
              Container(
                width: 11,
                height: 11,
                decoration: const BoxDecoration(
                  color: Color(0xFF020104),
                  shape: BoxShape.circle,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.signal_cellular_alt_rounded,
                size: 15,
                color: PinneColors.text,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.wifi_rounded, size: 15, color: PinneColors.text),
              const SizedBox(width: 4),
              const Icon(
                Icons.battery_5_bar_rounded,
                size: 15,
                color: PinneColors.text,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _GestureBar extends StatelessWidget {
  const _GestureBar();

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Container(
          width: 112,
          height: 4.5,
          decoration: BoxDecoration(
            color: PinneColors.text.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    ),
  );
}

/// Soft markers where the film taps and drags.
class TouchLayer extends StatelessWidget {
  const TouchLayer({super.key});

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: AtTime(
      builder: (context, t, _) {
        final film = FilmScope.of(context);
        return Stack(
          children: [
            for (final touch in film.touches)
              if (t >= touch.downAt && t < (touch.upAt ?? 1e9) + 0.5)
                _marker(touch, t),
          ],
        );
      },
    ),
  );

  Widget _marker(Touch touch, double t) {
    final appear = ramp(t, touch.downAt, 0.12);
    final gone = touch.upAt == null ? 0.0 : ramp(t, touch.upAt!, 0.45);
    final radius = 30 * (0.7 + 0.3 * appear) + 16 * gone;
    final o = appear * (1 - gone);
    return Positioned(
      left: touch.position.dx - radius,
      top: touch.position.dy - radius,
      width: radius * 2,
      height: radius * 2,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.30 * o),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.85 * o),
            width: 3,
          ),
        ),
      ),
    );
  }
}

/// A full stage: background, captions, the phone, touches, and anything
/// extra on top.
class Stage extends StatelessWidget {
  const Stage({
    super.key,
    this.cues = const [],
    this.captionTop,
    this.captionWidth = 700,
    this.phone,
    this.extra = const [],
  });

  final List<Cue> cues;
  final double? captionTop;
  final double captionWidth;
  final Widget? phone;
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
          Captions(cues, top: captionTop, width: captionWidth),
          ?phone,
          ...extra,
          const TouchLayer(),
        ],
      ),
    ),
  );
}
