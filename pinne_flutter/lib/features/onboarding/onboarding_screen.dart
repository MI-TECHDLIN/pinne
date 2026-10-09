import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../router.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import 'onboarding_store.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, this.replay = false});

  final bool replay;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _pages = PageController();
  late final AnimationController _scene;
  var _page = 0;
  var _finishing = false;

  @override
  void initState() {
    super.initState();
    _scene = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotionOf(context)) {
      _scene.stop();
      _scene.value = 1;
    } else if (!_scene.isAnimating) {
      _scene.repeat();
    }
  }

  @override
  void dispose() {
    _scene.dispose();
    _pages.dispose();
    super.dispose();
  }

  Future<void> _advance() async {
    if (_page < 2) {
      await _pages.nextPage(
        duration: motionDurationOf(context, PinneMotionDurations.standard),
        curve: PinneMotionCurves.enter,
      );
      return;
    }
    await _finish();
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    await ref.read(onboardingStoreProvider).markCompleted();
    if (mounted) {
      context.go(widget.replay ? Routes.settings : Routes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduced = reduceMotionOf(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.55),
            radius: 1.05,
            colors: [PinneColors.glowViolet, PinneColors.midnight],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  key: const ValueKey('onboarding-skip'),
                  onPressed: _finishing ? null : _finish,
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView(
                  key: const ValueKey('onboarding-pages'),
                  controller: _pages,
                  onPageChanged: (page) => setState(() => _page = page),
                  children: [
                    _OnboardingPage(
                      eyebrow: 'EVERYTHING YOU SAVE, ONE HOME',
                      leading: 'Save it once. ',
                      bold: 'Find it',
                      trailing: ' later.',
                      body:
                          'Links, posts, articles and notes land together — with the reason you kept them.',
                      scene: _SaveScene(animation: _scene, reduced: reduced),
                    ),
                    _OnboardingPage(
                      eyebrow: 'WE BRING IT BACK',
                      leading: 'Good ideas, ',
                      bold: 'right on time',
                      trailing: '.',
                      body:
                          'Gentle reminders return each save when it is useful, with your original note beside it.',
                      scene: _ReminderScene(
                        animation: _scene,
                        reduced: reduced,
                      ),
                    ),
                    _OnboardingPage(
                      eyebrow: 'MAKE TIME, SEE PROGRESS',
                      leading: 'Turn saved into ',
                      bold: 'done',
                      trailing: '.',
                      body:
                          'Plan a small review window, then watch the ideas you revisit add up.',
                      scene: _ProgressScene(
                        animation: _scene,
                        reduced: reduced,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  PinneSpacing.xl,
                  PinneSpacing.sm,
                  PinneSpacing.xl,
                  PinneSpacing.xl,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          for (var index = 0; index < 3; index++) ...[
                            AnimatedContainer(
                              key: ValueKey('onboarding-dot-$index'),
                              duration: motionDurationOf(
                                context,
                                PinneMotionDurations.quick,
                              ),
                              width: index == _page ? 24 : 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: index == _page
                                    ? PinneColors.lilac
                                    : PinneColors.line,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            if (index != 2)
                              const SizedBox(width: PinneSpacing.sm),
                          ],
                        ],
                      ),
                    ),
                    _ProgressButton(
                      progress: (_page + 1) / 3,
                      last: _page == 2,
                      busy: _finishing,
                      onPressed: _advance,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.eyebrow,
    required this.leading,
    required this.bold,
    required this.trailing,
    required this.body,
    required this.scene,
  });

  final String eyebrow;
  final String leading;
  final String bold;
  final String trailing;
  final String body;
  final Widget scene;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: PinneSpacing.xl),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: math.max(PinneSpacing.sm, constraints.maxHeight * .02),
            ),
            SizedBox(height: constraints.maxHeight * .50, child: scene),
            const SizedBox(height: PinneSpacing.lg),
            Text(
              eyebrow,
              style: const TextStyle(
                color: PinneColors.lilac,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: PinneSpacing.sm),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: leading),
                  TextSpan(
                    text: bold,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(text: trailing),
                ],
              ),
              key: ValueKey('onboarding-headline-$bold'),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 36,
                height: 1.02,
              ),
            ),
            const SizedBox(height: PinneSpacing.md),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: PinneColors.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: PinneSpacing.md),
          ],
        ),
      ),
    ),
  );
}

class _SaveScene extends StatelessWidget {
  const _SaveScene({required this.animation, required this.reduced});
  final Animation<double> animation;
  final bool reduced;

  static const icons = [
    Icons.link_rounded,
    Icons.play_arrow_rounded,
    Icons.chat_bubble_outline_rounded,
    Icons.article_outlined,
    Icons.image_outlined,
    Icons.bookmark_border_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    Widget composition(double value) => Stack(
      key: ValueKey(reduced ? 'onboarding-static-scene' : 'flight-animation'),
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: const Alignment(0, .35),
          child: Image.asset(
            'assets/art/cutout/ribbon_spirit_empty_collection.webp',
            width: 245,
            semanticLabel: 'Ribbon Spirit beside an open save box',
          ),
        ),
        for (var index = 0; index < icons.length; index++)
          _FlyingContentIcon(
            icon: icons[index],
            index: index,
            progress: reduced ? 0.32 + index * .06 : value,
          ),
      ],
    );
    if (reduced) return composition(1);
    return AnimatedBuilder(
      animation: animation,
      builder: (_, _) => composition(animation.value),
    );
  }
}

class _FlyingContentIcon extends StatelessWidget {
  const _FlyingContentIcon({
    required this.icon,
    required this.index,
    required this.progress,
  });
  final IconData icon;
  final int index;
  final double progress;

  @override
  Widget build(BuildContext context) {
    const starts = [
      Alignment(-.9, -.75),
      Alignment(.85, -.62),
      Alignment(-.78, -.12),
      Alignment(.92, -.02),
      Alignment(-.56, .35),
      Alignment(.62, .46),
    ];
    final phase = ((progress - index * .11) % 1).clamp(0.0, 1.0);
    final eased = Curves.easeInOutCubic.transform(phase);
    final start = starts[index];
    const end = Alignment(.43, .58);
    final arc = math.sin(eased * math.pi) * (index.isEven ? -.28 : .28);
    final alignment = Alignment(
      start.x + (end.x - start.x) * eased + arc,
      start.y + (end.y - start.y) * eased - math.sin(eased * math.pi) * .18,
    );
    return Align(
      alignment: alignment,
      child: Opacity(
        opacity: phase > .88 ? (1 - phase) / .12 : 1,
        child: Transform.scale(
          scale: .75 + math.sin(phase * math.pi) * .2,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: PinneColors.cardRaised,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PinneColors.line),
              boxShadow: const [
                BoxShadow(color: PinneColors.glowPlum, blurRadius: 16),
              ],
            ),
            child: Icon(icon, size: 21, color: PinneColors.lilac),
          ),
        ),
      ),
    );
  }
}

class _ReminderScene extends StatelessWidget {
  const _ReminderScene({required this.animation, required this.reduced});
  final Animation<double> animation;
  final bool reduced;

  @override
  Widget build(BuildContext context) {
    Widget composition(double value) => Stack(
      key: ValueKey(reduced ? 'onboarding-static-scene' : 'reminder-animation'),
      children: [
        Positioned(
          right: 0,
          top: 0,
          child: Image.asset(
            'assets/art/cutout/ribbon_spirit_excited.webp',
            width: 132,
          ),
        ),
        Positioned(
          left: 12,
          right: 54,
          top: 42,
          child: Transform.rotate(
            angle: -.08,
            child: const _MiniSaveCard(
              title: 'A better way to keep notes',
              label: 'ARTICLE · 4 MIN',
            ),
          ),
        ),
        Positioned(
          left: 46,
          right: 14,
          top: 120,
          child: Transform.rotate(
            angle: .055,
            child: const _MiniSaveCard(
              title: 'Motion with a purpose',
              label: 'VIDEO · 6 MIN',
            ),
          ),
        ),
        Positioned(
          left: 22,
          right: 36,
          top: 198 + (reduced ? 0 : math.sin(value * math.pi * 2) * 4),
          child: Transform.rotate(
            angle: -.025,
            child: const _MiniSaveCard(
              title: 'Tiny habits that stick',
              label: 'DUE NOW · SAVED 24H AGO',
              due: true,
            ),
          ),
        ),
      ],
    );
    if (reduced) return composition(1);
    return AnimatedBuilder(
      animation: animation,
      builder: (_, _) => composition(animation.value),
    );
  }
}

class _MiniSaveCard extends StatelessWidget {
  const _MiniSaveCard({
    required this.title,
    required this.label,
    this.due = false,
  });
  final String title;
  final String label;
  final bool due;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(PinneSpacing.lg),
    decoration: BoxDecoration(
      color: due
          ? PinneColors.accentDue
          : PinneColors.card.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(PinneRadii.card),
      border: due ? null : Border.all(color: PinneColors.line),
      boxShadow: const [
        BoxShadow(
          color: Color(0x55000000),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: due ? PinneColors.ink : PinneColors.lilac,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: .8,
          ),
        ),
        const SizedBox(height: PinneSpacing.xs),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: due ? PinneColors.ink : PinneColors.text,
          ),
        ),
      ],
    ),
  );
}

class _ProgressScene extends StatelessWidget {
  const _ProgressScene({required this.animation, required this.reduced});
  final Animation<double> animation;
  final bool reduced;

  @override
  Widget build(BuildContext context) {
    Widget composition(double value) => Stack(
      key: ValueKey(reduced ? 'onboarding-static-scene' : 'progress-animation'),
      children: [
        Positioned(
          left: 0,
          bottom: 0,
          child: Image.asset(
            'assets/art/cutout/ribbon_spirit_welcome.webp',
            width: 175,
          ),
        ),
        Positioned(
          right: 2,
          top: 26,
          child: Container(
            width: 174,
            padding: const EdgeInsets.all(PinneSpacing.lg),
            decoration: BoxDecoration(
              color: PinneColors.card,
              borderRadius: BorderRadius.circular(PinneRadii.card),
              border: Border.all(color: PinneColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TODAY · 10:30',
                  style: TextStyle(
                    color: PinneColors.lilac,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: PinneSpacing.sm),
                Text(
                  'Review saved ideas',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: PinneSpacing.sm),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: PinneColors.violet,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: PinneSpacing.xs),
                const Text(
                  '10 minute focus slot',
                  style: TextStyle(color: PinneColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 26,
          bottom: 4,
          child: CustomPaint(
            painter: _RingPainter(progress: reduced ? .72 : .25 + value * .55),
            child: const SizedBox(
              width: 112,
              height: 112,
              child: Center(
                child: Text(
                  '4 / 6',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    if (reduced) return composition(1);
    return AnimatedBuilder(
      animation: animation,
      builder: (_, _) => composition(animation.value),
    );
  }
}

class _ProgressButton extends StatelessWidget {
  const _ProgressButton({
    required this.progress,
    required this.last,
    required this.busy,
    required this.onPressed,
  });
  final double progress;
  final bool last;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: last ? 'Continue to sign in' : 'Next onboarding page',
    child: CustomPaint(
      painter: _RingPainter(progress: progress),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: IconButton.filled(
          key: const ValueKey('onboarding-next'),
          style: IconButton.styleFrom(
            backgroundColor: PinneColors.accentPrimaryAction,
            foregroundColor: PinneColors.ink,
            minimumSize: const Size.square(54),
          ),
          onPressed: busy ? null : onPressed,
          icon: busy
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: PinneColors.ink,
                  ),
                )
              : Icon(last ? Icons.login_rounded : Icons.arrow_forward_rounded),
        ),
      ),
    ),
  );
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 2;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = PinneColors.line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0, 1),
      false,
      Paint()
        ..color = PinneColors.lilac
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
