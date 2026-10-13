import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import '../../ui/ribbon_spirit/ribbon_spirit.dart';
import '../progress/celebration.dart' show RibbonConfetti;

const saveCelebrationDuration = Duration(milliseconds: 1400);

OverlayEntry? _showing;

/// A short, untappable "Saved" moment once a new capture is on the phone: the
/// Ribbon Spirit hops in a burst of ribbon sparkles, then fades by itself.
/// The small sibling of the milestone celebration, which waits for Continue.
/// Reduced motion shows the happy Spirit and a check without movement.
void showSaveCelebration(
  BuildContext context, {
  required int seed,
  required int palette,
}) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;
  unawaited(HapticFeedback.lightImpact());
  // A quick second save replaces the first moment instead of stacking.
  _showing?.remove();
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _SaveCelebration(
      seed: seed,
      palette: palette,
      onFinished: () {
        if (_showing != entry) return;
        _showing = null;
        entry.remove();
      },
    ),
  );
  _showing = entry;
  overlay.insert(entry);
}

class _SaveCelebration extends StatefulWidget {
  const _SaveCelebration({
    required this.seed,
    required this.palette,
    required this.onFinished,
  });

  final int seed;
  final int palette;
  final VoidCallback onFinished;

  @override
  State<_SaveCelebration> createState() => _SaveCelebrationState();
}

class _SaveCelebrationState extends State<_SaveCelebration>
    with SingleTickerProviderStateMixin {
  late bool _reduced;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: saveCelebrationDuration,
  )..forward().whenComplete(widget.onFinished);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = reduceMotionOf(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned.fill(
      child: IgnorePointer(
        key: const ValueKey('save-celebration'),
        child: Semantics(
          liveRegion: true,
          label: 'Saved',
          child: SafeArea(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final progress = _controller.value;
                final opacity = _fade(progress);
                final entrance = Curves.easeOutBack.transform(
                  (progress / 0.28).clamp(0, 1),
                );
                final settle = Curves.easeInOut.transform(
                  ((progress - 0.28) / 0.34).clamp(0, 1),
                );
                final hop = _reduced
                    ? 0.0
                    : (-18 * math.sin(math.pi * settle)) -
                          (8 * math.sin(math.pi * entrance));
                final angle = _reduced
                    ? 0.0
                    : math.sin(progress * math.pi * 2.2) *
                          0.045 *
                          (1 - progress);
                final scale = _reduced ? 1.0 : 0.82 + (0.18 * entrance);
                return Opacity(
                  opacity: opacity,
                  child: Align(
                    alignment: const Alignment(0, -0.12),
                    child: Transform.translate(
                      offset: Offset(0, hop),
                      child: Transform.rotate(
                        angle: angle,
                        child: Transform.scale(scale: scale, child: child),
                      ),
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_reduced)
                      Positioned.fill(
                        child: RepaintBoundary(
                          child: CustomPaint(
                            key: const ValueKey('save-sparkles'),
                            painter: _SaveSparklesPainter(_controller),
                          ),
                        ),
                      ),
                    Container(
                      key: const ValueKey('save-celebration-card'),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [PinneColors.cardRaised, PinneColors.card],
                        ),
                        borderRadius: BorderRadius.circular(PinneRadii.card),
                        border: Border.all(
                          color: PinneColors.lilac.withValues(alpha: 0.4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: PinneColors.violet.withValues(alpha: 0.3),
                            blurRadius: 34,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RibbonSpirit(
                            seed: widget.seed,
                            palette: widget.palette,
                            mood: _reduced
                                ? RibbonMood.happy
                                : RibbonMood.excited,
                            size: 92,
                            animate: !_reduced,
                          ),
                          const SizedBox(height: PinneSpacing.xs),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 21,
                                color: PinneColors.mint,
                              ),
                              const SizedBox(width: PinneSpacing.sm),
                              Text(
                                'Saved',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static double _fade(double progress) {
    if (progress < 0.1) return Curves.easeOut.transform(progress / 0.1);
    if (progress > 0.78) {
      return 1 - Curves.easeIn.transform((progress - 0.78) / 0.22);
    }
    return 1;
  }
}

class _SaveSparklesPainter extends CustomPainter {
  _SaveSparklesPainter(this.progress) : super(repaint: progress);

  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    final t = Curves.easeOutCubic.transform(
      (progress.value / 0.62).clamp(0, 1),
    );
    final fade = (1 - ((progress.value - 0.48) / 0.28)).clamp(0, 1);
    final centre = size.center(Offset.zero);
    // Far enough out to clear the card the sparkles burst from behind.
    for (var i = 0; i < 22; i++) {
      final angle = (math.pi * 2 * i / 22) + ((i % 3) * 0.12);
      final distance = (84 + (i % 4) * 16) * t;
      final position = centre + Offset.fromDirection(angle, distance);
      final colours = RibbonConfetti.colours;
      final paint = Paint()
        ..color = colours[i % colours.length].withValues(alpha: fade * 0.9)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(angle + (t * 1.8));
      if (i.isEven) {
        canvas.drawLine(const Offset(-6, 0), const Offset(6, 0), paint);
      } else {
        canvas.drawCircle(Offset.zero, 3.2, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_SaveSparklesPainter oldDelegate) => false;
}
