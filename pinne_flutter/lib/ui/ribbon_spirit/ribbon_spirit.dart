import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../motion.dart';
import '../../theme/pinne_tokens.dart';
import 'ribbon_painter.dart';
import 'ribbon_recipe.dart';

export 'ribbon_painter.dart' show RibbonMood;
export 'ribbon_recipe.dart';

/// Exactly one eligible spirit can loop in a ProviderScope. Picker/gallery
/// thumbnails opt out; hidden routes, scrolled-out spirits and background apps
/// release their slot. No timer runs just to discover visibility.
final _motionSlotProvider = Provider((ref) => _MotionSlot());

class _MotionSlot {
  final _waiting = <Object, void Function(bool)>{};
  Object? _active;

  void request(Object owner, bool eligible, void Function(bool) onChange) {
    if (eligible) {
      _waiting[owner] = onChange;
    } else {
      _waiting.remove(owner);
      if (_active == owner) {
        _active = null;
        onChange(false);
      }
    }
    if (_active == null && _waiting.isNotEmpty) {
      _active = _waiting.keys.first;
      _waiting[_active]!(true);
    }
  }
}

class RibbonSpirit extends ConsumerStatefulWidget {
  const RibbonSpirit({
    super.key,
    required this.seed,
    this.palette = 0,
    this.mood = RibbonMood.idle,
    this.size = 96,
    this.animate = true,
  }) : assert(palette >= 0 && palette < 6),
       assert(size > 0);

  final int seed;
  final int palette;
  final RibbonMood mood;
  final double size;

  /// Set false for thumbnails. The shared slot still enforces one visible loop.
  final bool animate;

  @override
  ConsumerState<RibbonSpirit> createState() => _RibbonSpiritState();
}

class _RibbonSpiritState extends ConsumerState<RibbonSpirit>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final _controller = AnimationController(
    vsync: this,
    duration: 8.seconds,
  );
  late final _slot = ref.read(_motionSlotProvider);
  late RibbonRecipe _recipe = RibbonRecipe(widget.seed);
  final _visibilityKey = UniqueKey();
  bool _visible = false;
  bool _foreground = true;
  bool _reduced = false;
  bool _tickerEnabled = true;
  bool _routeVisible = true;
  bool _syncScheduled = false;
  double _lastOpening = 0;
  double? _transitionFrom;
  Duration _transitionStart = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _foreground = lifecycle == null || lifecycle == AppLifecycleState.resumed;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tickerEnabled = TickerMode.valuesOf(context).enabled;
    _routeVisible = ModalRoute.of(context)?.isCurrent ?? true;
    _scheduleSync();
  }

  @override
  void didUpdateWidget(RibbonSpirit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seed != widget.seed) _recipe = RibbonRecipe(widget.seed);
    if (oldWidget.mood != widget.mood && _controller.isAnimating) {
      _transitionFrom = _lastOpening;
      _transitionStart = _controller.lastElapsedDuration ?? Duration.zero;
    }
    _scheduleSync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _sync();
  }

  void _scheduleSync() {
    if (_syncScheduled) return;
    _syncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (mounted) _sync();
    });
  }

  void _sync() => _slot.request(
    this,
    widget.animate &&
        _visible &&
        _foreground &&
        !_reduced &&
        _tickerEnabled &&
        _routeVisible,
    _setAnimating,
  );

  void _setAnimating(bool active) {
    if (!mounted) return;
    if (active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!active) {
      _transitionFrom = null;
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _slot.request(this, false, (_) {});
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _reduced = reduceMotionOf(context);
    _scheduleSync();
    Widget painting(double phase) {
      final elapsed =
          (_controller.lastElapsedDuration ?? Duration.zero) - _transitionStart;
      final painter = RibbonPainter(
        recipe: _recipe,
        palette: PinneSpiritPalettes.values[widget.palette],
        mood: widget.mood,
        phase: phase,
        reducedMotion: _reduced,
        transitionFrom: _transitionFrom,
        transitionProgress: (elapsed.inMicroseconds / 650000).clamp(0.0, 1.0),
      );
      _lastOpening = painter.opening;
      return CustomPaint(painter: painter);
    }

    // Still poses need neither visibility timers nor animation builders.
    final still = _reduced || !widget.animate;
    final child = SizedBox.square(
      dimension: widget.size,
      child: still
          ? painting(0)
          : const SizedBox.expand()
                .animate(controller: _controller, autoPlay: false)
                .custom(
                  duration: 8.seconds,
                  builder: (context, value, child) => painting(value),
                ),
    );
    return Semantics(
      image: true,
      label: '${widget.mood.name} ribbon spirit',
      child: RepaintBoundary(
        child: still
            ? child
            : VisibilityDetector(
                key: _visibilityKey,
                onVisibilityChanged: (info) {
                  _visible = info.visibleFraction > .05;
                  _sync();
                },
                child: child,
              ),
      ),
    );
  }
}
