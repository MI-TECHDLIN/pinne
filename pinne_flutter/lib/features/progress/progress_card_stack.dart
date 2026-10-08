import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';

/// One metric on a hero card: a big number with a small label chip.
@immutable
class ProgressCardData {
  const ProgressCardData({
    required this.id,
    required this.label,
    required this.icon,
    required this.value,
    required this.caption,
    required this.background,
    required this.foreground,
    this.unit,
    this.dayBars,
    this.dayLetters,
  });

  final String id;
  final String label;
  final IconData icon;
  final int value;
  final String? unit;
  final String caption;
  final Color background;
  final Color foreground;

  /// A mini row of day bars: true reviewed, false not, null still to come.
  final List<bool?>? dayBars;
  final List<String>? dayLetters;

  String get spoken =>
      '$label: $value${unit == null ? '' : ' $unit'}. $caption';
}

/// A playful deck of tilted progress cards. Swipe or tap the top card and it
/// flies off, then tucks in at the back while the next one springs forward.
///
/// Under reduced motion it is a plain, untilted page view.
class ProgressCardStack extends StatefulWidget {
  const ProgressCardStack({
    super.key,
    required this.cards,
    this.spirit,
    this.spiritCardId,
    this.height = 330,
  });

  final List<ProgressCardData> cards;

  /// Peeks over the top edge of the card with [spiritCardId].
  final Widget? spirit;
  final String? spiritCardId;
  final double height;

  @override
  State<ProgressCardStack> createState() => _ProgressCardStackState();
}

class _ProgressCardStackState extends State<ProgressCardStack> {
  late List<String> _order = [for (final card in widget.cards) card.id];
  Offset _drag = Offset.zero;
  bool _dragging = false;

  /// -1 or 1 while the top card flies off to that side, else 0.
  int _flying = 0;

  @override
  void didUpdateWidget(ProgressCardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ids = [for (final card in widget.cards) card.id];
    _order = [
      ..._order.where(ids.contains),
      ...ids.where((id) => !_order.contains(id)),
    ];
  }

  Map<String, ProgressCardData> get _byId => {
    for (final card in widget.cards) card.id: card,
  };

  void _next([int direction = -1]) {
    if (_order.length < 2 || _flying != 0) return;
    setState(() {
      _dragging = false;
      _flying = direction;
    });
    final next = _byId[_order[1]];
    if (next != null) {
      SemanticsService.sendAnnouncement(
        View.of(context),
        next.spoken,
        Directionality.of(context),
      );
    }
  }

  void _landed() {
    if (_flying == 0) return;
    setState(() {
      _order = [..._order.skip(1), _order.first];
      _flying = 0;
      _drag = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) return const SizedBox.shrink();
    if (reduceMotionOf(context)) {
      return _ProgressPager(
        cards: widget.cards,
        height: widget.height,
        spirit: widget.spirit,
        spiritCardId: widget.spiritCardId,
      );
    }
    final byId = _byId;
    final topIndex = widget.cards.indexWhere((c) => c.id == _order.first);
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var depth = _order.length - 1; depth >= 0; depth--)
                    _buildCard(byId[_order[depth]]!, depth, width),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: PinneSpacing.md),
        _Dots(count: widget.cards.length, active: topIndex),
      ],
    );
  }

  Widget _buildCard(ProgressCardData card, int depth, double width) {
    final top = depth == 0;
    final _Pose pose;
    final Duration duration;
    final Curve curve;
    if (top && _flying != 0) {
      pose = _Pose(
        dx: _flying * width * 1.15,
        dy: -70,
        angle: _flying * 0.42,
        scale: 0.96,
      );
      duration = const Duration(milliseconds: 260);
      curve = PinneMotionCurves.exit;
    } else if (top && _dragging) {
      pose = _Pose(
        dx: _drag.dx,
        dy: _drag.dx.abs() * -0.08,
        angle: _restPoses[0].angle + _drag.dx / width * 0.45,
      );
      duration = Duration.zero;
      curve = Curves.linear;
    } else {
      pose = depth < _restPoses.length
          ? _restPoses[depth]
          : _restPoses.last.copyWith(opacity: 0);
      duration = const Duration(milliseconds: 560);
      curve = PinneMotionCurves.spring;
    }

    Widget face = ProgressCardFace(
      card: card,
      index: widget.cards.indexOf(card),
      total: widget.cards.length,
    );
    if (widget.spirit != null && card.id == widget.spiritCardId) {
      face = _WithSpirit(spirit: widget.spirit!, child: face);
    }
    if (top) {
      face = Semantics(
        button: true,
        label:
            'Card ${widget.cards.indexOf(card) + 1} of '
            '${widget.cards.length}. ${card.spoken}',
        hint: 'Shows the next card',
        onTap: _next,
        excludeSemantics: true,
        child: GestureDetector(
          key: const ValueKey('progress-stack-top'),
          behavior: HitTestBehavior.opaque,
          onTap: _next,
          onHorizontalDragStart: (_) => setState(() {
            _dragging = true;
            _drag = Offset.zero;
          }),
          onHorizontalDragUpdate: (details) =>
              setState(() => _drag += details.delta),
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity ?? 0;
            if (_drag.dx.abs() > width * 0.26 || velocity.abs() > 650) {
              final direction = (_drag.dx + velocity / 10).sign.toInt();
              _next(direction == 0 ? -1 : direction);
            } else {
              setState(() {
                _dragging = false;
                _drag = Offset.zero;
              });
            }
          },
          onHorizontalDragCancel: () => setState(() {
            _dragging = false;
            _drag = Offset.zero;
          }),
          child: face,
        ),
      );
    } else {
      face = IgnorePointer(child: ExcludeSemantics(child: face));
    }
    return Positioned(
      key: ValueKey('progress-card-${card.id}'),
      left: 14,
      right: 14,
      top: 34,
      height: widget.height - 92,
      child: _PosedCard(
        pose: pose,
        duration: duration,
        curve: curve,
        onEnd: top ? _landed : null,
        child: face,
      ),
    );
  }
}

/// Resting poses by depth: the front card leans left, the next peeks out
/// below leaning right, and the third barely shows.
const _restPoses = [
  _Pose(angle: -0.035),
  _Pose(dx: 8, dy: 30, angle: 0.06, scale: 0.94),
  _Pose(dx: -6, dy: 52, angle: -0.075, scale: 0.88),
];

@immutable
class _Pose {
  const _Pose({
    this.dx = 0,
    this.dy = 0,
    this.angle = 0,
    this.scale = 1,
    this.opacity = 1,
  });

  final double dx;
  final double dy;
  final double angle;
  final double scale;
  final double opacity;

  _Pose copyWith({double? opacity}) => _Pose(
    dx: dx,
    dy: dy,
    angle: angle,
    scale: scale,
    opacity: opacity ?? this.opacity,
  );

  static _Pose lerp(_Pose a, _Pose b, double t) => _Pose(
    dx: a.dx + (b.dx - a.dx) * t,
    dy: a.dy + (b.dy - a.dy) * t,
    angle: a.angle + (b.angle - a.angle) * t,
    scale: a.scale + (b.scale - a.scale) * t,
    opacity: a.opacity + (b.opacity - a.opacity) * t,
  );
}

class _PoseTween extends Tween<_Pose> {
  _PoseTween({super.begin});

  @override
  _Pose lerp(double t) => _Pose.lerp(begin!, end!, t);
}

class _PosedCard extends ImplicitlyAnimatedWidget {
  const _PosedCard({
    required this.pose,
    required this.child,
    required super.duration,
    super.curve,
    super.onEnd,
  });

  final _Pose pose;
  final Widget child;

  @override
  AnimatedWidgetBaseState<_PosedCard> createState() => _PosedCardState();
}

class _PosedCardState extends AnimatedWidgetBaseState<_PosedCard> {
  _PoseTween? _pose;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _pose =
        visitor(
              _pose,
              widget.pose,
              (value) => _PoseTween(begin: value as _Pose),
            )
            as _PoseTween?;
  }

  @override
  Widget build(BuildContext context) {
    final pose = _pose!.evaluate(animation);
    return Opacity(
      opacity: pose.opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(pose.dx, pose.dy),
        child: Transform.rotate(
          angle: pose.angle,
          child: Transform.scale(scale: pose.scale, child: widget.child),
        ),
      ),
    );
  }
}

class _WithSpirit extends StatelessWidget {
  const _WithSpirit({required this.spirit, required this.child});

  final Widget spirit;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      Positioned.fill(child: child),
      Positioned(top: -54, right: 14, child: spirit),
    ],
  );
}

/// The reduced-motion hero: the same cards, flat, one page at a time.
class _ProgressPager extends StatefulWidget {
  const _ProgressPager({
    required this.cards,
    required this.height,
    this.spirit,
    this.spiritCardId,
  });

  final List<ProgressCardData> cards;
  final double height;
  final Widget? spirit;
  final String? spiritCardId;

  @override
  State<_ProgressPager> createState() => _ProgressPagerState();
}

class _ProgressPagerState extends State<_ProgressPager> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height - 40,
          child: PageView.builder(
            key: const ValueKey('progress-pager'),
            itemCount: widget.cards.length,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) {
              final card = widget.cards[index];
              Widget face = ProgressCardFace(
                card: card,
                index: index,
                total: widget.cards.length,
              );
              if (widget.spirit != null && card.id == widget.spiritCardId) {
                face = _WithSpirit(spirit: widget.spirit!, child: face);
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(6, 40, 6, 0),
                child: Semantics(
                  label:
                      'Card ${index + 1} of ${widget.cards.length}. '
                      '${card.spoken}',
                  excludeSemantics: true,
                  child: face,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: PinneSpacing.md),
        _Dots(
          count: widget.cards.length,
          active: _page.clamp(0, widget.cards.length - 1),
        ),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: motionDurationOf(context, PinneMotionDurations.quick),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == active ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == active ? PinneColors.violet : PinneColors.line,
              borderRadius: BorderRadius.circular(PinneRadii.chip),
            ),
          ),
      ],
    ),
  );
}

/// The face of one hero card.
class ProgressCardFace extends StatelessWidget {
  const ProgressCardFace({
    super.key,
    required this.card,
    required this.index,
    required this.total,
  });

  final ProgressCardData card;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = card.foreground;
    final dark = card.background.computeLuminance() < 0.2;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: card.background,
        borderRadius: BorderRadius.circular(28),
        border: dark ? Border.all(color: PinneColors.line) : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: fg.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(PinneRadii.chip),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(card.icon, size: 14, color: fg),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            card.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: fg,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: PinneSpacing.sm),
                Text(
                  '${index + 1}/$total',
                  style: TextStyle(
                    color: fg.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${card.value}',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: fg,
                      fontSize: 76,
                      height: 1,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -2,
                    ),
                  ),
                  if (card.unit != null) ...[
                    const SizedBox(width: PinneSpacing.sm),
                    Text(
                      card.unit!,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: fg.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: PinneSpacing.xs),
            Text(
              card.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: fg.withValues(alpha: 0.78),
                fontSize: 13,
                height: 1.35,
              ),
            ),
            if (card.dayBars != null) ...[
              const SizedBox(height: PinneSpacing.md),
              _MiniDayBars(
                bars: card.dayBars!,
                letters: card.dayLetters,
                foreground: fg,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MiniDayBars extends StatelessWidget {
  const _MiniDayBars({
    required this.bars,
    required this.foreground,
    this.letters,
  });

  final List<bool?> bars;
  final List<String>? letters;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < bars.length; i++) ...[
        if (i > 0) const SizedBox(width: 6),
        Expanded(
          child: Column(
            children: [
              Container(
                height: 22,
                decoration: BoxDecoration(
                  color: switch (bars[i]) {
                    true => PinneColors.mint,
                    false => foreground.withValues(alpha: 0.14),
                    null => foreground.withValues(alpha: 0.05),
                  },
                  borderRadius: BorderRadius.circular(8),
                ),
                child: bars[i] == true
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: PinneColors.ink,
                      )
                    : null,
              ),
              if (letters != null) ...[
                const SizedBox(height: 4),
                Text(
                  letters![i],
                  style: TextStyle(
                    color: foreground.withValues(alpha: 0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ],
  );
}
