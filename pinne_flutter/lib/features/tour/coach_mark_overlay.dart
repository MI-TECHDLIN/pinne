import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shell/pill_nav_bar.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import 'tour_controller.dart';

/// Dims the app, cuts a window around the current [TourStep] target, and
/// shows a callout beside it with Back, Next and Skip.
///
/// Targets are found through [TourAnchors] and re-measured after every frame,
/// so the window follows scrolling, loading content and rotation.
class CoachMarkOverlay extends ConsumerStatefulWidget {
  const CoachMarkOverlay({
    super.key,
    required this.step,
    required this.destinations,
  });

  final int step;

  /// The pill nav tabs, listed on the step that points at the nav.
  final List<PillNavDestination> destinations;

  @override
  ConsumerState<CoachMarkOverlay> createState() => _CoachMarkOverlayState();
}

class _CoachMarkOverlayState extends ConsumerState<CoachMarkOverlay>
    with SingleTickerProviderStateMixin {
  late final _move = AnimationController(
    vsync: this,
    duration: PinneMotionDurations.standard,
  )..addListener(() => setState(() {}));
  Rect? _target;
  Rect? _from;
  int? _scrolledFor;

  TourStep get _step => tourSteps[widget.step];

  @override
  void initState() {
    super.initState();
    _move.value = 1;
    _track();
  }

  @override
  void didUpdateWidget(CoachMarkOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.step != widget.step) {
      _from = _hole;
      _scrolledFor = null;
      if (reduceMotionOf(context)) {
        _move.value = 1;
      } else {
        _move.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _move.dispose();
    super.dispose();
  }

  /// Measures the target after each frame for as long as the overlay lives.
  /// Only a changed rectangle schedules another frame.
  void _track() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _measure();
      _track();
    });
  }

  void _measure() {
    final target = _step.target;
    final anchor = target == null
        ? null
        : ref.read(tourAnchorsProvider)[target];
    final overlay = context.findRenderObject();
    Rect? rect;
    final box = anchor?.findRenderObject();
    if (box is RenderBox &&
        box.hasSize &&
        box.attached &&
        overlay is RenderBox) {
      final topLeft = box.localToGlobal(Offset.zero, ancestor: overlay);
      rect = topLeft & box.size;
      if (_scrolledFor != widget.step) {
        _scrolledFor = widget.step;
        Scrollable.ensureVisible(
          anchor!,
          alignment: .5,
          duration: reduceMotionOf(context)
              ? Duration.zero
              : PinneMotionDurations.standard,
          curve: PinneMotionCurves.enter,
        );
      }
    }
    if (rect != _target) setState(() => _target = rect);
  }

  /// The window on screen: the measured target, eased in from the last one.
  Rect? get _hole {
    final target = _target?.inflate(6);
    if (target == null) return null;
    final from = _from;
    if (from == null || _move.value >= 1) return target;
    return Rect.lerp(
      from,
      target,
      PinneMotionCurves.enter.transform(_move.value),
    );
  }

  void _next() => ref.read(tourControllerProvider.notifier).next();
  void _back() => ref.read(tourControllerProvider.notifier).back();
  void _skip() => ref.read(tourControllerProvider.notifier).finish();

  @override
  Widget build(BuildContext context) {
    final hole = _hole;
    final padding = MediaQuery.paddingOf(context);
    final reduced = reduceMotionOf(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _skip();
      },
      child: BlockSemantics(
        child: Semantics(
          key: const ValueKey('tour-overlay'),
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: 'App tour',
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Swallows taps so the app underneath stays still.
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: CustomPaint(
                  key: const ValueKey('tour-scrim'),
                  painter: _ScrimPainter(
                    hole: hole,
                    radius: _step.radius + 6,
                    highlightColor: context.pinne.violet,
                    edgeColor: context.pinne.lilac,
                  ),
                ),
              ),
              CustomSingleChildLayout(
                delegate: _CalloutLayout(
                  hole: hole,
                  padding: EdgeInsets.fromLTRB(
                    PinneSpacing.gutter + padding.left,
                    PinneSpacing.md + padding.top,
                    PinneSpacing.gutter + padding.right,
                    PinneSpacing.md + padding.bottom,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: reduced
                      ? PinneMotionDurations.reducedFade
                      : PinneMotionDurations.standard,
                  switchInCurve: PinneMotionCurves.enter,
                  switchOutCurve: PinneMotionCurves.exit,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: reduced
                        ? child
                        : ScaleTransition(
                            scale: Tween(
                              begin: .96,
                              end: 1.0,
                            ).animate(animation),
                            child: child,
                          ),
                  ),
                  child: _Callout(
                    key: ValueKey('tour-callout-${widget.step}'),
                    step: widget.step,
                    destinations: widget.destinations,
                    onNext: _next,
                    onBack: widget.step == 0 ? null : _back,
                    onSkip: _skip,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrimPainter extends CustomPainter {
  const _ScrimPainter({
    required this.hole,
    required this.radius,
    required this.highlightColor,
    required this.edgeColor,
  });

  final Rect? hole;
  final double radius;
  final Color highlightColor;
  final Color edgeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final screen = Offset.zero & size;
    final scrim = Paint()..color = const Color(0xD60C0816);
    final hole = this.hole;
    if (hole == null) {
      canvas.drawRect(screen, scrim);
      return;
    }
    final window = RRect.fromRectAndRadius(
      hole,
      Radius.circular(math.min(radius, hole.shortestSide / 2)),
    );
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(screen),
        Path()..addRRect(window),
      ),
      scrim,
    );
    canvas
      ..drawRRect(
        window.inflate(3),
        Paint()
          ..color = highlightColor.withValues(alpha: .35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      )
      ..drawRRect(
        window,
        Paint()
          ..color = edgeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
  }

  @override
  bool shouldRepaint(_ScrimPainter oldDelegate) =>
      oldDelegate.hole != hole ||
      oldDelegate.radius != radius ||
      oldDelegate.highlightColor != highlightColor ||
      oldDelegate.edgeColor != edgeColor;
}

/// Where the callout goes, in order: below the window, above it, to its
/// right, to its left, and finally over the window's lower edge. It is always
/// kept inside the safe area.
class _CalloutLayout extends SingleChildLayoutDelegate {
  const _CalloutLayout({required this.hole, required this.padding});

  final Rect? hole;
  final EdgeInsets padding;

  static const _gap = 14.0;
  static const _maxWidth = 380.0;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints(
        maxWidth: math.max(
          0,
          math.min(constraints.maxWidth - padding.horizontal, _maxWidth),
        ),
        maxHeight: math.max(0, constraints.maxHeight - padding.vertical),
      );

  @override
  Offset getPositionForChild(Size size, Size child) {
    final area = padding.deflateRect(Offset.zero & size);
    double clampX(double x) =>
        x.clamp(area.left, math.max(area.left, area.right - child.width));
    double clampY(double y) =>
        y.clamp(area.top, math.max(area.top, area.bottom - child.height));
    final hole = this.hole;
    if (hole == null) {
      return Offset(
        clampX(area.center.dx - child.width / 2),
        clampY(area.center.dy - child.height / 2),
      );
    }
    final x = clampX(hole.center.dx - child.width / 2);
    final below = hole.bottom + _gap;
    if (below + child.height <= area.bottom) return Offset(x, below);
    final above = hole.top - _gap - child.height;
    if (above >= area.top) return Offset(x, above);
    final y = clampY(hole.center.dy - child.height / 2);
    final right = hole.right + _gap;
    if (right + child.width <= area.right) return Offset(right, y);
    final left = hole.left - _gap - child.width;
    if (left >= area.left) return Offset(left, y);
    return Offset(x, clampY(hole.bottom - _gap - child.height));
  }

  @override
  bool shouldRelayout(_CalloutLayout oldDelegate) =>
      oldDelegate.hole != hole || oldDelegate.padding != padding;
}

class _Callout extends StatelessWidget {
  const _Callout({
    super.key,
    required this.step,
    required this.destinations,
    required this.onNext,
    required this.onSkip,
    this.onBack,
  });

  final int step;
  final List<PillNavDestination> destinations;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = tourSteps[step];
    final last = step == tourSteps.length - 1;
    final welcome = data.target == null;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        key: const ValueKey('tour-callout'),
        decoration: BoxDecoration(
          color: context.pinne.cardRaised,
          borderRadius: BorderRadius.circular(PinneRadii.card),
          border: Border.all(color: context.pinne.lilac.withValues(alpha: .35)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? context.pinne.shadow
                  : const Color(0xAA000000),
              blurRadius: 30,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            PinneSpacing.lg,
            PinneSpacing.lg,
            PinneSpacing.sm,
            PinneSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (welcome) ...[
                Center(
                  child: Image.asset(
                    'assets/art/cutout/ribbon_spirit_welcome.webp',
                    height: 96,
                    excludeFromSemantics: true,
                  ),
                ),
                const SizedBox(height: PinneSpacing.sm),
              ],
              Row(
                children: [
                  if (!welcome) ...[
                    _StepBadge(icon: data.icon),
                    const SizedBox(width: PinneSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STEP ${step + 1} OF ${tourSteps.length}',
                          style: TextStyle(
                            color: context.pinne.lilac,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Semantics(
                          header: true,
                          liveRegion: true,
                          child: Text(
                            data.title,
                            key: const ValueKey('tour-title'),
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!last)
                    TextButton(
                      key: const ValueKey('tour-skip'),
                      onPressed: onSkip,
                      style: TextButton.styleFrom(
                        foregroundColor: context.pinne.muted,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text('Skip tour'),
                    ),
                ],
              ),
              const SizedBox(height: PinneSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(right: PinneSpacing.sm),
                child: Text(
                  data.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.pinne.muted,
                    height: 1.4,
                  ),
                ),
              ),
              if (data.showTabs) ...[
                const SizedBox(height: PinneSpacing.md),
                Wrap(
                  spacing: PinneSpacing.xs,
                  runSpacing: PinneSpacing.xs,
                  children: [
                    for (final tab in destinations) _TabChip(destination: tab),
                  ],
                ),
              ],
              const SizedBox(height: PinneSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: _StepDots(step: step),
                      ),
                    ),
                  ),
                  if (onBack != null)
                    TextButton(
                      key: const ValueKey('tour-back'),
                      onPressed: onBack,
                      child: const Text('Back'),
                    ),
                  const SizedBox(width: PinneSpacing.xs),
                  FilledButton(
                    key: const ValueKey('tour-next'),
                    autofocus: true,
                    onPressed: onNext,
                    child: Text(
                      last
                          ? 'Done'
                          : welcome
                          ? 'Show me'
                          : 'Next',
                    ),
                  ),
                  const SizedBox(width: PinneSpacing.sm),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [context.pinne.lilac, context.pinne.violet],
      ),
    ),
    child: Icon(icon, size: 21, color: context.pinne.onViolet),
  );
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Step ${step + 1} of ${tourSteps.length}',
    child: ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < tourSteps.length; i++) ...[
            if (i > 0) const SizedBox(width: 5),
            Container(
              key: ValueKey('tour-dot-$i'),
              width: i == step ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == step ? context.pinne.lilac : context.pinne.line,
                borderRadius: BorderRadius.circular(PinneRadii.chip),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class _TabChip extends StatelessWidget {
  const _TabChip({required this.destination});

  final PillNavDestination destination;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: context.pinne.glass,
      borderRadius: BorderRadius.circular(PinneRadii.chip),
      border: Border.all(color: context.pinne.line),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(destination.icon, size: 14, color: context.pinne.lilac),
        const SizedBox(width: 5),
        Text(
          destination.label,
          style: TextStyle(color: context.pinne.text, fontSize: 12),
        ),
      ],
    ),
  );
}
