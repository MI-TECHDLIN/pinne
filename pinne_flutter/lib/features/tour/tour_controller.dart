import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tour_store.dart';

/// The parts of the app the Today tour points at.
enum TourTarget { saveLink, reviewCard, timeChips, weekStrip, planTiles, nav }

@immutable
class TourStep {
  const TourStep({
    required this.title,
    required this.body,
    required this.icon,
    this.target,
    this.radius = 22,
    this.showTabs = false,
  });

  /// Null for a centred step that spotlights nothing.
  final TourTarget? target;
  final String title;
  final String body;
  final IconData icon;

  /// Corner radius of the cut-out around the target.
  final double radius;

  /// Lists the five tabs under the text.
  final bool showTabs;
}

const tourSteps = [
  TourStep(
    title: 'Welcome to Pinne',
    body:
        'A quick look at how your saves come back to you. It takes about '
        'thirty seconds.',
    icon: Icons.waving_hand_rounded,
  ),
  TourStep(
    target: TourTarget.saveLink,
    title: 'Save anything',
    body:
        'Paste a link or jot a note here, or share from any app. It is kept '
        'on your phone first, even offline.',
    icon: Icons.add_link_rounded,
    radius: 18,
  ),
  TourStep(
    target: TourTarget.reviewCard,
    title: 'What is due now',
    body:
        'One save comes back at a time. Tap Reviewed when you are done, '
        'Remind me later to snooze it, or Archive to let it go.',
    icon: Icons.bolt_rounded,
  ),
  TourStep(
    target: TourTarget.timeChips,
    title: 'Pick your time',
    body:
        'Choose 5, 10 or 20 minutes and Pinne fits today’s reviews into that '
        'window.',
    icon: Icons.timer_outlined,
    radius: 99,
  ),
  TourStep(
    target: TourTarget.weekStrip,
    title: 'Your week at a glance',
    body:
        'Today is highlighted, and a dot marks each day you reviewed '
        'something.',
    icon: Icons.calendar_view_week_rounded,
    radius: 18,
  ),
  TourStep(
    target: TourTarget.planTiles,
    title: 'Plan and track',
    body:
        'Next up books a short review session in your free time. This week '
        'counts what you saved and came back to.',
    icon: Icons.insights_rounded,
    radius: 18,
  ),
  TourStep(
    target: TourTarget.nav,
    title: 'Find your way around',
    body:
        'Everything else is one tap away. You can replay this tour from '
        'Settings at any time.',
    icon: Icons.explore_outlined,
    radius: 99,
    showTabs: true,
  ),
];

/// The step on screen, or null when the tour is closed.
final tourControllerProvider = NotifierProvider<TourController, int?>(
  TourController.new,
);

class TourController extends Notifier<int?> {
  @override
  int? build() => null;

  /// Opens the tour at the first step, such as from Settings.
  void start() => state = 0;

  /// Opens the tour only if this phone has never finished or skipped it.
  void startIfFirstVisit() {
    if (state == null && !ref.read(tourStoreProvider).seen) start();
  }

  void next() {
    final step = state;
    if (step == null) return;
    if (step >= tourSteps.length - 1) {
      finish();
    } else {
      state = step + 1;
    }
  }

  void back() {
    final step = state;
    if (step != null && step > 0) state = step - 1;
  }

  /// Closes the tour, for Done and Skip alike, and remembers it was seen.
  Future<void> finish() async {
    state = null;
    await ref.read(tourStoreProvider).markSeen();
  }
}

/// Where each [TourTarget] is currently mounted.
final tourAnchorsProvider = Provider<TourAnchors>((ref) => TourAnchors());

class TourAnchors {
  final _contexts = <TourTarget, BuildContext>{};

  BuildContext? operator [](TourTarget target) {
    final context = _contexts[target];
    return context != null && context.mounted ? context : null;
  }

  void _register(TourTarget target, BuildContext context) =>
      _contexts[target] = context;

  void _unregister(TourTarget target, BuildContext context) {
    if (identical(_contexts[target], context)) _contexts.remove(target);
  }
}

/// Marks [child] as the spot the tour highlights for [target].
class TourAnchor extends ConsumerStatefulWidget {
  const TourAnchor({super.key, required this.target, required this.child});

  final TourTarget target;
  final Widget child;

  @override
  ConsumerState<TourAnchor> createState() => _TourAnchorState();
}

class _TourAnchorState extends ConsumerState<TourAnchor> {
  late final TourAnchors _anchors = ref.read(tourAnchorsProvider);

  @override
  void initState() {
    super.initState();
    _anchors._register(widget.target, context);
  }

  @override
  void didUpdateWidget(TourAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      _anchors
        .._unregister(oldWidget.target, context)
        .._register(widget.target, context);
    }
  }

  @override
  void dispose() {
    _anchors._unregister(widget.target, context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Opens the tour the first time Today is actually on screen.
class TourAutoStart extends ConsumerStatefulWidget {
  const TourAutoStart({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<TourAutoStart> createState() => _TourAutoStartState();
}

class _TourAutoStartState extends ConsumerState<TourAutoStart> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      // Offstage tab branches have tickers off; only a visible Today counts.
      if ((route?.isCurrent ?? true) && TickerMode.valuesOf(context).enabled) {
        ref.read(tourControllerProvider.notifier).startIfFirstVisit();
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
