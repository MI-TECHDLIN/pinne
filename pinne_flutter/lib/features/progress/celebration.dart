import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import '../../ui/ribbon_spirit/ribbon_spirit.dart';
import '../settings/profile_provider.dart';
import 'progress_providers.dart';

/// What a milestone says when it is celebrated.
@immutable
class CelebrationCopy {
  const CelebrationCopy({
    required this.number,
    required this.title,
    required this.unit,
    required this.line,
  });

  factory CelebrationCopy.of(ProgressMilestone milestone) =>
      switch (milestone.kind) {
        MilestoneKind.firstReview => const CelebrationCopy(
          number: 1,
          title: 'Your first review',
          unit: 'save revisited',
          line: 'You came back to something you saved. That is the whole idea.',
        ),
        MilestoneKind.reviewCount => CelebrationCopy(
          number: milestone.value,
          title: '${milestone.value} saves revisited',
          unit: 'saves revisited',
          line: 'Each one got the second look it deserved. Lovely work.',
        ),
        MilestoneKind.weeklyGoal => CelebrationCopy(
          number: milestone.value,
          title: 'Weekly goal reached',
          unit: milestone.value == 1 ? 'review day' : 'review days',
          line: 'You made time for what you saved this week.',
        ),
        MilestoneKind.queueCleared => CelebrationCopy(
          number: milestone.value,
          title: 'Queue cleared',
          unit: milestone.value == 1
              ? 'save revisited today'
              : 'saves revisited today',
          line: 'Nothing is waiting right now. Enjoy the quiet.',
        ),
      };

  final int number;
  final String title;
  final String unit;
  final String line;

  /// The whole message in words, for screen readers.
  String get spoken => '$title: $number $unit. $line';
}

/// Bigger moments first: a review count, then the weekly goal, the very
/// first review, and a cleared queue.
int _rank(ProgressMilestone milestone) => switch (milestone.kind) {
  MilestoneKind.reviewCount => 1000 + milestone.value,
  MilestoneKind.weeklyGoal => 300,
  MilestoneKind.firstReview => 200,
  MilestoneKind.queueCleared => 100,
};

final celebrationControllerProvider =
    NotifierProvider<CelebrationController, Set<String>>(
      CelebrationController.new,
    );

/// Shows each newly reached milestone once. State is the set of keys already
/// celebrated on this device; the server keeps the durable record.
class CelebrationController extends Notifier<Set<String>> {
  final _unsaved = <String>{};
  bool _showing = false;

  @override
  Set<String> build() => {};

  /// Celebrates whatever in [milestones] has not been celebrated yet.
  Future<void> celebrate(
    BuildContext context,
    Iterable<ProgressMilestone> milestones,
  ) async {
    if (_showing) return;
    final fresh =
        milestones
            .where((m) => !m.celebrated && !state.contains(m.key))
            .toList()
          ..sort((a, b) => _rank(b).compareTo(_rank(a)));
    if (fresh.isEmpty) {
      await _flush();
      return;
    }
    // Recorded before showing, so a lost answer or a closed app never
    // brings the same moment back.
    state = {...state, ...fresh.map((m) => m.key)};
    _unsaved.addAll(fresh.map((m) => m.key));
    unawaited(_flush());
    if (!context.mounted) return;
    _showing = true;
    try {
      final avatar = ref.read(avatarRecipeProvider);
      await showCelebration(
        context,
        milestone: fresh.first,
        also: fresh.skip(1).toList(),
        seed: avatar.seed,
        palette: avatar.palette,
      );
    } finally {
      _showing = false;
    }
  }

  /// Fetches this week's report and celebrates anything new, such as right
  /// after a review on Today. Failures stay silent: progress is a bonus.
  Future<void> checkAfterReview(BuildContext context) async {
    try {
      final report = await ref
          .read(progressApiProvider)
          .report(progressQuery(ProgressPeriod.thisWeek));
      if (!context.mounted) return;
      await celebrate(context, report.milestones);
    } on Object {
      // The Progress tab checks again when it opens.
    }
  }

  Future<void> _flush() async {
    if (_unsaved.isEmpty) return;
    final keys = _unsaved.toList();
    try {
      await ref.read(progressApiProvider).markCelebrated(keys);
      _unsaved.removeAll(keys);
    } on Object {
      // Kept for the next attempt.
    }
  }
}

/// A large celebration sheet over the app with the Ribbon Spirit.
Future<void> showCelebration(
  BuildContext context, {
  required ProgressMilestone milestone,
  List<ProgressMilestone> also = const [],
  required int seed,
  required int palette,
}) {
  final reduced = reduceMotionOf(context);
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Celebration',
    barrierColor: PinneColors.midnight.withValues(alpha: 0.86),
    transitionDuration: reduced
        ? PinneMotionDurations.reducedFade
        : const Duration(milliseconds: 460),
    pageBuilder: (context, _, _) => CelebrationView(
      milestone: milestone,
      also: also,
      seed: seed,
      palette: palette,
    ),
    transitionBuilder: (context, animation, _, child) {
      if (reduced) return FadeTransition(opacity: animation, child: child);
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(begin: 0.86, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: PinneMotionCurves.spring),
          ),
          child: child,
        ),
      );
    },
  );
}

class CelebrationView extends StatefulWidget {
  const CelebrationView({
    super.key,
    required this.milestone,
    this.also = const [],
    required this.seed,
    required this.palette,
  });

  final ProgressMilestone milestone;
  final List<ProgressMilestone> also;
  final int seed;
  final int palette;

  @override
  State<CelebrationView> createState() => _CelebrationViewState();
}

class _CelebrationViewState extends State<CelebrationView> {
  bool _announced = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_announced) return;
    _announced = true;
    final message = CelebrationCopy.of(widget.milestone).spoken;
    final view = View.of(context);
    final direction = Directionality.of(context);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => SemanticsService.sendAnnouncement(view, message, direction),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduced = reduceMotionOf(context);
    final copy = CelebrationCopy.of(widget.milestone);
    final card = Container(
      key: const ValueKey('celebration-card'),
      constraints: const BoxConstraints(maxWidth: 380),
      margin: const EdgeInsets.symmetric(horizontal: PinneSpacing.xl),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [PinneColors.cardRaised, PinneColors.card],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: PinneColors.lilac.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: PinneColors.violet.withValues(alpha: 0.35),
            blurRadius: 60,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RibbonSpirit(
            seed: widget.seed,
            palette: widget.palette,
            mood: RibbonMood.happy,
            size: 132,
          ),
          Semantics(
            header: true,
            child: Text(
              copy.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: PinneSpacing.sm),
          ExcludeSemantics(
            child: Text(
              '${copy.number}',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 96,
                height: 1,
                fontWeight: FontWeight.w500,
                letterSpacing: -3,
                color: PinneColors.lilac,
              ),
            ),
          ),
          Semantics(
            label: '${copy.number} ${copy.unit}',
            excludeSemantics: true,
            child: Text(
              copy.unit,
              style: theme.textTheme.titleMedium?.copyWith(
                color: PinneColors.muted,
              ),
            ),
          ),
          const SizedBox(height: PinneSpacing.lg),
          Text(
            copy.line,
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.45),
          ),
          if (widget.also.isNotEmpty) ...[
            const SizedBox(height: PinneSpacing.md),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: PinneSpacing.sm,
              runSpacing: PinneSpacing.sm,
              children: [
                for (final milestone in widget.also)
                  Chip(
                    avatar: const Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: PinneColors.lilac,
                    ),
                    label: Text('Also: ${CelebrationCopy.of(milestone).title}'),
                    side: const BorderSide(color: PinneColors.line),
                    backgroundColor: PinneColors.glass,
                  ),
              ],
            ),
          ],
          const SizedBox(height: PinneSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const ValueKey('celebration-continue'),
              onPressed: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    );

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          if (!reduced)
            Positioned.fill(
              child: IgnorePointer(child: RibbonConfetti(seed: widget.seed)),
            ),
          SafeArea(
            child: Center(child: SingleChildScrollView(child: card)),
          ),
        ],
      ),
    );
  }
}

/// Pastel ribbon streamers and paper pieces that drift down once.
/// Never lime: lime means "due now", not celebration.
class RibbonConfetti extends StatefulWidget {
  const RibbonConfetti({super.key, this.seed = 7});

  final int seed;

  static const colours = [
    PinneColors.peach,
    PinneColors.mint,
    PinneColors.pink,
    PinneColors.sky,
    PinneColors.lilac,
    PinneColors.violet,
  ];

  @override
  State<RibbonConfetti> createState() => _RibbonConfettiState();
}

class _RibbonConfettiState extends State<RibbonConfetti>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..forward();
  late final _pieces = _Piece.scatter(widget.seed);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: CustomPaint(
      painter: _ConfettiPainter(_pieces, _controller),
      size: Size.infinite,
    ),
  );
}

class _Piece {
  _Piece(math.Random random)
    : x = random.nextDouble(),
      delay = random.nextDouble() * 0.35,
      fall = 0.75 + random.nextDouble() * 0.6,
      sway = 12 + random.nextDouble() * 26,
      spin = (random.nextDouble() - 0.5) * 9,
      colour =
          RibbonConfetti.colours[random.nextInt(RibbonConfetti.colours.length)],
      ribbon = random.nextDouble() < 0.45,
      length = 26 + random.nextDouble() * 30;

  static List<_Piece> scatter(int seed) {
    final random = math.Random(seed);
    return [for (var i = 0; i < 46; i++) _Piece(random)];
  }

  final double x;
  final double delay;
  final double fall;
  final double sway;
  final double spin;
  final Color colour;
  final bool ribbon;
  final double length;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, this.progress) : super(repaint: progress);

  final List<_Piece> pieces;
  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    for (final piece in pieces) {
      final local = ((t - piece.delay) / (1 - piece.delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;
      final y = -60 + (size.height + 120) * local * piece.fall;
      final x =
          piece.x * size.width +
          math.sin(local * math.pi * 3 + piece.x * 9) * piece.sway;
      final fade = local > 0.8 ? (1 - local) / 0.2 : 1.0;
      final paint = Paint()
        ..color = piece.colour.withValues(alpha: 0.9 * fade)
        ..style = piece.ribbon ? PaintingStyle.stroke : PaintingStyle.fill
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(piece.spin * local);
      if (piece.ribbon) {
        final path = Path()..moveTo(0, 0);
        for (var s = 1; s <= 12; s++) {
          final along = piece.length * s / 12;
          path.lineTo(
            math.sin(s / 12 * math.pi * 2 + local * 10) * 6,
            along,
          );
        }
        canvas.drawPath(path, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(-5, -3, 10, 6),
            const Radius.circular(2),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.pieces != pieces;
}
