import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../router.dart';
import '../../theme/pinne_theme.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import '../../ui/pinne_loading.dart';
import '../../ui/ribbon_spirit/ribbon_cutout.dart';
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

  static const _pageCount = 3;

  @override
  Widget build(BuildContext context) {
    final reduced = reduceMotionOf(context);
    final last = _page == _pageCount - 1;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.55),
            radius: 1.05,
            colors: [context.pinne.glowViolet, context.pinne.midnight],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  PinneSpacing.xl,
                  PinneSpacing.xs,
                  PinneSpacing.sm,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_page + 1} of $_pageCount',
                        key: const ValueKey('onboarding-step'),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: context.pinne.muted,
                        ),
                      ),
                    ),
                    TextButton(
                      key: const ValueKey('onboarding-skip'),
                      onPressed: _finishing ? null : _finish,
                      child: Text(last ? 'Close' : 'Skip'),
                    ),
                  ],
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
                  PinneSpacing.md,
                  PinneSpacing.xl,
                  PinneSpacing.lg,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        label: 'Page ${_page + 1} of $_pageCount',
                        child: ExcludeSemantics(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (
                                  var index = 0;
                                  index < _pageCount;
                                  index++
                                ) ...[
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
                                          ? context.pinne.lilac
                                          : context.pinne.line,
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                  ),
                                  if (index != _pageCount - 1)
                                    const SizedBox(width: PinneSpacing.sm),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: PinneSpacing.md),
                    _ProgressButton(
                      progress: (_page + 1) / _pageCount,
                      last: last,
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
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;
      // Phones in landscape and tablets put the scene beside the copy.
      final sideBySide = width >= 600 && width > height * 1.15;
      final contentWidth = sideBySide
          ? math.min(width, 980.0)
          : math.min(width, 560.0);
      final gutter = width < 380 ? PinneSpacing.lg : PinneSpacing.xl;
      final copy = _Copy(
        eyebrow: eyebrow,
        leading: leading,
        bold: bold,
        trailing: trailing,
        body: body,
        headlineSize: (math.min(contentWidth, 460) * .086).clamp(28.0, 40.0),
      );
      final glowingScene = _SceneGlow(child: scene);
      if (sideBySide) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Row(
                children: [
                  Expanded(child: glowingScene),
                  const SizedBox(width: PinneSpacing.xl),
                  Expanded(
                    child: Center(child: SingleChildScrollView(child: copy)),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: gutter),
        child: Center(
          child: SizedBox(
            width: contentWidth - gutter * 2,
            child: _SceneAndCopy(
              viewportHeight: height,
              minScene: math.min(200, height * .4),
              maxScene: 560,
              gap: height < 560 ? PinneSpacing.lg : PinneSpacing.xl,
              scene: glowingScene,
              copy: copy,
            ),
          ),
        ),
      );
    },
  );
}

class _Copy extends StatelessWidget {
  const _Copy({
    required this.eyebrow,
    required this.leading,
    required this.bold,
    required this.trailing,
    required this.body,
    required this.headlineSize,
  });

  final String eyebrow;
  final String leading;
  final String bold;
  final String trailing;
  final String body;
  final double headlineSize;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey('onboarding-copy'),
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow,
        style: TextStyle(
          color: context.pinne.lilac,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
        ),
      ),
      const SizedBox(height: PinneSpacing.sm),
      Semantics(
        header: true,
        child: Text.rich(
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
            fontSize: headlineSize,
            height: 1.05,
          ),
        ),
      ),
      const SizedBox(height: PinneSpacing.md),
      Text(
        body,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: context.pinne.muted,
          height: 1.5,
        ),
      ),
    ],
  );
}

/// A soft violet halo so each illustration sits on a stage, not on nothing.
class _SceneGlow extends StatelessWidget {
  const _SceneGlow({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: RadialGradient(
        center: const Alignment(0, .3),
        radius: .5,
        colors: [
          context.pinne.violet.withValues(alpha: .22),
          context.pinne.violet.withValues(alpha: 0),
        ],
      ),
    ),
    // Illustrations are pictures: their sample text keeps one size so the
    // composition never breaks. The page copy still follows text scaling.
    child: MediaQuery.withNoTextScaling(child: child),
  );
}

/// Lays out the copy at its natural height, then gives the scene what is left
/// between [minScene] and [maxScene]. The copy sits on the bottom edge, next
/// to the footer, and the scene is centred above it. Only when even the
/// smallest scene cannot fit does the page grow past [viewportHeight] and
/// scroll, so text is never clipped.
class _SceneAndCopy extends MultiChildRenderObjectWidget {
  _SceneAndCopy({
    required this.viewportHeight,
    required this.minScene,
    required this.maxScene,
    required this.gap,
    required Widget scene,
    required Widget copy,
  }) : super(children: [scene, copy]);

  final double viewportHeight;
  final double minScene;
  final double maxScene;
  final double gap;

  @override
  _RenderSceneAndCopy createRenderObject(BuildContext context) =>
      _RenderSceneAndCopy(viewportHeight, minScene, maxScene, gap);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSceneAndCopy renderObject,
  ) {
    renderObject
      ..viewportHeight = viewportHeight
      ..minScene = minScene
      ..maxScene = maxScene
      ..gap = gap;
  }
}

class _SceneAndCopyParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderSceneAndCopy extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _SceneAndCopyParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _SceneAndCopyParentData> {
  _RenderSceneAndCopy(
    this._viewportHeight,
    this._minScene,
    this._maxScene,
    this._gap,
  );

  double _viewportHeight;
  set viewportHeight(double value) {
    if (value == _viewportHeight) return;
    _viewportHeight = value;
    markNeedsLayout();
  }

  double _minScene;
  set minScene(double value) {
    if (value == _minScene) return;
    _minScene = value;
    markNeedsLayout();
  }

  double _maxScene;
  set maxScene(double value) {
    if (value == _maxScene) return;
    _maxScene = value;
    markNeedsLayout();
  }

  double _gap;
  set gap(double value) {
    if (value == _gap) return;
    _gap = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _SceneAndCopyParentData) {
      child.parentData = _SceneAndCopyParentData();
    }
  }

  @override
  void performLayout() {
    final width = constraints.maxWidth;
    final scene = firstChild!;
    final copy = childAfter(scene)!;
    copy.layout(BoxConstraints.tightFor(width: width), parentUsesSize: true);
    final copyHeight = copy.size.height;
    final room = _viewportHeight - copyHeight - _gap;
    final sceneHeight = room
        .clamp(_minScene, math.max(_minScene, _maxScene))
        .toDouble();
    scene.layout(BoxConstraints.tightFor(width: width, height: sceneHeight));
    final height = math.max(_viewportHeight, sceneHeight + _gap + copyHeight);
    size = constraints.constrain(Size(width, height));
    final sceneSpace = size.height - copyHeight - _gap;
    (scene.parentData! as _SceneAndCopyParentData).offset = Offset(
      0,
      (sceneSpace - sceneHeight) / 2,
    );
    (copy.parentData! as _SceneAndCopyParentData).offset = Offset(
      0,
      size.height - copyHeight,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}

/// Draws an illustration at its design size and scales the whole picture to
/// fit, so every phone sees the same proportions.
class _Stage extends StatelessWidget {
  const _Stage({required this.size, required this.child});

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) => FittedBox(
    // Leans toward the copy below so tall phones do not open a gap.
    alignment: const Alignment(0, .7),
    child: SizedBox.fromSize(size: size, child: child),
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
          child: RibbonSpiritCutout(
            asset: 'assets/art/cutout/ribbon_spirit_empty_collection.webp',
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
    return _Stage(
      size: const Size(340, 320),
      child: reduced
          ? composition(1)
          : AnimatedBuilder(
              animation: animation,
              builder: (_, _) => composition(animation.value),
            ),
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
              color: context.pinne.cardRaised,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.pinne.line),
              boxShadow: [
                BoxShadow(color: context.pinne.glowPlum, blurRadius: 16),
              ],
            ),
            child: Icon(icon, size: 21, color: context.pinne.lilac),
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
    Widget composition(double value) => LayoutBuilder(
      builder: (context, constraints) {
        final spiritHeight = math.min(108.0, constraints.maxHeight * .31);
        return Column(
          key: ValueKey(
            reduced ? 'onboarding-static-scene' : 'reminder-animation',
          ),
          children: [
            SizedBox(
              height: spiritHeight,
              child: Align(
                alignment: Alignment.centerRight,
                child: RibbonSpiritCutout(
                  asset: 'assets/art/cutout/ribbon_spirit_excited.webp',
                  key: const ValueKey('reminder-spirit'),
                  width: spiritHeight,
                  height: spiritHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: PinneSpacing.md),
            Expanded(
              child: Column(
                children: [
                  const Expanded(
                    child: _MiniSaveCard(
                      key: ValueKey('reminder-article'),
                      inset: EdgeInsets.only(right: 28),
                      title: 'A better way to keep notes',
                      label: 'ARTICLE · 4 MIN',
                    ),
                  ),
                  const SizedBox(height: PinneSpacing.sm),
                  const Expanded(
                    child: _MiniSaveCard(
                      key: ValueKey('reminder-video'),
                      inset: EdgeInsets.only(left: 28),
                      title: 'Motion with a purpose',
                      label: 'VIDEO · 6 MIN',
                    ),
                  ),
                  const SizedBox(height: PinneSpacing.sm),
                  Expanded(
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        reduced ? 0 : math.sin(value * math.pi * 2) * 2,
                      ),
                      child: const _MiniSaveCard(
                        key: ValueKey('reminder-due'),
                        title: 'Tiny habits that stick',
                        label: 'DUE NOW · SAVED 24H AGO',
                        due: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    return _Stage(
      size: const Size(340, 330),
      child: reduced
          ? composition(1)
          : AnimatedBuilder(
              animation: animation,
              builder: (_, _) => composition(animation.value),
            ),
    );
  }
}

class _MiniSaveCard extends StatelessWidget {
  const _MiniSaveCard({
    super.key,
    required this.title,
    required this.label,
    this.due = false,
    this.inset = EdgeInsets.zero,
  });
  final String title;
  final String label;
  final bool due;
  final EdgeInsets inset;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: inset,
    padding: const EdgeInsets.symmetric(
      horizontal: PinneSpacing.lg,
      vertical: PinneSpacing.sm,
    ),
    decoration: BoxDecoration(
      color: due
          ? context.pinne.accentDue
          : context.pinne.card.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(PinneRadii.card),
      border: due
          ? Theme.of(context).brightness == Brightness.light
                ? Border.all(color: context.pinne.dueEdge, width: 1.5)
                : null
          : Border.all(color: context.pinne.line),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).brightness == Brightness.light
              ? context.pinne.shadow
              : const Color(0x55000000),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    ),
    alignment: Alignment.centerLeft,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: due ? context.pinne.ink : context.pinne.lilac,
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
            color: due ? context.pinne.ink : context.pinne.text,
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
          child: RibbonSpiritCutout(
            asset: 'assets/art/cutout/ribbon_spirit_welcome.webp',
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
              color: context.pinne.card,
              borderRadius: BorderRadius.circular(PinneRadii.card),
              border: Border.all(color: context.pinne.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TODAY · 10:30',
                  style: TextStyle(
                    color: context.pinne.lilac,
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
                    color: context.pinne.violet,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: PinneSpacing.xs),
                Text(
                  '10 minute focus slot',
                  style: TextStyle(color: context.pinne.muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 26,
          bottom: 4,
          child: CustomPaint(
            painter: _RingPainter(
              progress: reduced ? .72 : .25 + value * .55,
              lineColor: context.pinne.line,
              progressColor: context.pinne.lilac,
            ),
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
    return _Stage(
      size: const Size(340, 300),
      child: reduced
          ? composition(1)
          : AnimatedBuilder(
              animation: animation,
              builder: (_, _) => composition(animation.value),
            ),
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
  Widget build(BuildContext context) {
    const loader = PinneBrandedLoader(size: 20, label: 'Finishing setup');
    // The last page ends on a labelled pill: the one primary action.
    final Widget button = last
        ? FilledButton.icon(
            key: const ValueKey('onboarding-next'),
            style: pinnePrimaryActionStyle().copyWith(
              textStyle: WidgetStatePropertyAll(
                Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              minimumSize: const WidgetStatePropertyAll(Size(0, 56)),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: PinneSpacing.xl),
              ),
            ),
            onPressed: busy ? null : onPressed,
            iconAlignment: IconAlignment.end,
            icon: busy ? loader : const Icon(Icons.arrow_forward_rounded),
            label: const Text('Get started'),
          )
        : CustomPaint(
            painter: _RingPainter(
              progress: progress,
              lineColor: context.pinne.line,
              progressColor: context.pinne.lilac,
            ),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: IconButton.filled(
                key: const ValueKey('onboarding-next'),
                tooltip: 'Next page',
                style: IconButton.styleFrom(
                  backgroundColor: context.pinne.accentPrimaryAction,
                  foregroundColor: context.pinne.ink,
                  minimumSize: const Size.square(54),
                ),
                onPressed: busy ? null : onPressed,
                icon: busy ? loader : const Icon(Icons.arrow_forward_rounded),
              ),
            ),
          );
    return AnimatedSwitcher(
      duration: motionDurationOf(context, PinneMotionDurations.quick),
      child: KeyedSubtree(key: ValueKey(last), child: button),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.lineColor,
    required this.progressColor,
  });
  final double progress;
  final Color lineColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 2;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0, 1),
      false,
      Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.progressColor != progressColor;
}
