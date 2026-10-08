import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../theme/pinne_tokens.dart';
import '../../ui/glass_card.dart';
import '../../ui/motion.dart';
import '../collections/collection_cover.dart';
import 'progress_providers.dart';

/// A report date (yyyy-MM-dd) as a local calendar date.
DateTime reportDate(String value) {
  final parts = value.split('-').map(int.parse).toList();
  return DateTime(parts[0], parts[1], parts[2]);
}

const _weekdayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
const _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
const _monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String weekdayLetter(String date) =>
    _weekdayLetters[reportDate(date).weekday - 1];
String weekdayName(String date) => _weekdayNames[reportDate(date).weekday - 1];
String shortDate(String date) {
  final day = reportDate(date);
  return '${day.day} ${_monthNames[day.month - 1]}';
}

/// Animates a number up from zero once, unless motion is reduced.
class CountUpText extends StatelessWidget {
  const CountUpText({
    super.key,
    required this.value,
    required this.style,
    this.suffix = '',
  });

  final int value;
  final String suffix;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (reduceMotionOf(context)) return Text('$value$suffix', style: style);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: PinneMotionDurations.slow * 1.4,
      curve: PinneMotionCurves.enter,
      builder: (context, current, _) =>
          Text('${current.round()}$suffix', style: style),
    );
  }
}

/// Three stat pills like a learning plan: saved, reviewed, upcoming.
class ProgressStatPills extends StatelessWidget {
  const ProgressStatPills({super.key, required this.report});

  final ProgressReport report;

  @override
  Widget build(BuildContext context) {
    final pills = [
      ('Saved', report.savedCount, Icons.bookmark_rounded, PinneColors.peach),
      (
        'Reviewed',
        report.reviewedCount,
        Icons.check_circle_rounded,
        PinneColors.mint,
      ),
      (
        'Upcoming',
        report.remainingCount,
        Icons.schedule_rounded,
        PinneColors.sky,
      ),
    ];
    return Row(
      children: [
        for (final (i, (label, value, icon, colour)) in pills.indexed) ...[
          if (i > 0) const SizedBox(width: PinneSpacing.sm),
          Expanded(
            child: Semantics(
              label: '$label: $value',
              excludeSemantics: true,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 14, 10, 16),
                decoration: BoxDecoration(
                  color: colour.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(PinneRadii.card),
                  border: Border.all(color: colour.withValues(alpha: 0.28)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: colour,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 18, color: PinneColors.ink),
                    ),
                    const SizedBox(height: PinneSpacing.sm),
                    CountUpText(
                      value: value,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600, height: 1.1),
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                        color: PinneColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// The big review rate with a smooth trend line and a bubble on today.
class ReviewRateCard extends StatelessWidget {
  const ReviewRateCard({super.key, required this.report});

  final ProgressReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rate = report.reviewRate;
    final phrase = periodPhrase(report.period);
    final caption = rate == null
        ? 'Nothing saved $phrase yet, so there is nothing to rate.'
        : '${report.reviewedCount} of ${report.savedCount} '
              '${report.savedCount == 1 ? 'save' : 'saves'} from $phrase '
              'revisited';
    final marker = report.days.lastIndexWhere(
      (day) => !day.isFuture && day.cohortRate != null,
    );
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: rate == null
                ? 'Review rate: none yet'
                : 'Review rate: ${percentLabel(rate)}',
            excludeSemantics: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (rate == null)
                  Text('—', style: _bigNumber(theme))
                else
                  CountUpText(
                    value: (rate * 100).round(),
                    suffix: '%',
                    style: _bigNumber(theme),
                  ),
                const SizedBox(width: PinneSpacing.md),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Review\nrate',
                    style: theme.textTheme.titleMedium?.copyWith(height: 1.1),
                  ),
                ),
              ],
            ),
          ),
          Text(caption, style: const TextStyle(color: PinneColors.muted)),
          const SizedBox(height: PinneSpacing.lg),
          if (marker >= 0)
            Semantics(
              label: 'Review rate over $phrase',
              child: SizedBox(
                height: 132,
                width: double.infinity,
                child: CustomPaint(
                  painter: RateTrendPainter(
                    days: report.days,
                    marker: marker,
                    textDirection: Directionality.of(context),
                    labelStyle: theme.textTheme.labelLarge!.copyWith(
                      color: PinneColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          if (marker >= 0) ...[
            const SizedBox(height: PinneSpacing.sm),
            Row(
              children: [
                Text(
                  shortDate(report.startDate),
                  style: const TextStyle(
                    color: PinneColors.muted,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  shortDate(report.days.last.date),
                  style: const TextStyle(
                    color: PinneColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static TextStyle? _bigNumber(ThemeData theme) => theme.textTheme.displayLarge
      ?.copyWith(fontSize: 72, fontWeight: FontWeight.w500, height: 1);
}

/// A smooth line of the cohort review rate. Missing days are skipped, never
/// drawn as zero; future days stay empty.
class RateTrendPainter extends CustomPainter {
  RateTrendPainter({
    required this.days,
    required this.marker,
    required this.textDirection,
    required this.labelStyle,
  });

  final List<ProgressDay> days;
  final int marker;
  final TextDirection textDirection;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    const top = 38.0;
    final height = size.height - top - 6;
    double x(int i) =>
        days.length == 1 ? size.width / 2 : size.width * i / (days.length - 1);
    double y(double rate) => top + height * (1 - rate);

    // Quiet guides at 0%, 50% and 100%.
    final guide = Paint()
      ..color = PinneColors.line
      ..strokeWidth = 1;
    for (final level in [0.0, 0.5, 1.0]) {
      canvas.drawLine(Offset(0, y(level)), Offset(size.width, y(level)), guide);
    }

    final points = <Offset>[
      for (var i = 0; i < days.length; i++)
        if (!days[i].isFuture && days[i].cohortRate != null)
          Offset(x(i), y(days[i].cohortRate!)),
    ];
    if (points.length > 1) {
      final line = Path()..moveTo(points.first.dx, points.first.dy);
      for (var i = 0; i < points.length - 1; i++) {
        final a = points[i];
        final b = points[i + 1];
        final mid = (a.dx + b.dx) / 2;
        line.cubicTo(mid, a.dy, mid, b.dy, b.dx, b.dy);
      }
      final area = Path.from(line)
        ..lineTo(points.last.dx, y(0))
        ..lineTo(points.first.dx, y(0))
        ..close();
      canvas.drawPath(
        area,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              PinneColors.pink.withValues(alpha: 0.32),
              PinneColors.pink.withValues(alpha: 0),
            ],
          ).createShader(Offset.zero & size),
      );
      canvas.drawPath(
        line,
        Paint()
          ..color = PinneColors.pink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }

    final rate = days[marker].cohortRate!;
    final point = Offset(x(marker), y(rate));
    canvas.drawLine(
      Offset(point.dx, top - 6),
      Offset(point.dx, y(0)),
      Paint()
        ..color = PinneColors.text.withValues(alpha: 0.18)
        ..strokeWidth = 1,
    );
    canvas.drawCircle(point, 7, Paint()..color = PinneColors.midnight);
    canvas.drawCircle(
      point,
      7,
      Paint()
        ..color = PinneColors.text
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final label = TextPainter(
      text: TextSpan(
        text: percentLabel(rate),
        style: labelStyle,
      ),
      textDirection: textDirection,
    )..layout();
    final bubbleWidth = label.width + 20;
    final left = (point.dx - bubbleWidth / 2).clamp(
      0.0,
      size.width - bubbleWidth,
    );
    final bubble = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, 0, bubbleWidth, 26),
      const Radius.circular(13),
    );
    canvas.drawRRect(bubble, Paint()..color = PinneColors.text);
    label.paint(canvas, Offset(left + 10, 13 - label.height / 2));
  }

  @override
  bool shouldRepaint(RateTrendPainter oldDelegate) =>
      oldDelegate.days != days || oldDelegate.marker != marker;
}

/// This week's goal as tall day tiles with check marks.
class WeeklyGoalCard extends StatelessWidget {
  const WeeklyGoalCard({
    super.key,
    required this.goal,
    this.streakDays,
    this.onEdit,
  });

  final WeeklyGoalProgress goal;
  final int? streakDays;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Weekly goal', style: theme.textTheme.titleMedium),
              ),
              if (onEdit != null)
                TextButton(
                  key: const ValueKey('progress-goal-edit'),
                  onPressed: onEdit,
                  child: const Text('Edit'),
                ),
            ],
          ),
          Text(
            goal.reached
                ? 'Reached: ${goal.reviewDayCount} review days this week.'
                : '${goal.reviewDayCount} of ${goal.goalDays} review days '
                      'this week.',
            style: const TextStyle(color: PinneColors.muted),
          ),
          const SizedBox(height: PinneSpacing.md),
          Row(
            children: [
              for (final (i, day) in goal.days.indexed) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(child: _GoalTile(day: day)),
              ],
            ],
          ),
          if (goal.reached || streakDays != null) ...[
            const SizedBox(height: PinneSpacing.md),
            Wrap(
              spacing: PinneSpacing.sm,
              runSpacing: PinneSpacing.sm,
              children: [
                if (goal.reached)
                  const _Badge(
                    icon: Icons.emoji_events_rounded,
                    label: 'Goal reached',
                  ),
                if (streakDays != null)
                  _Badge(
                    icon: Icons.local_fire_department_rounded,
                    label: streakDays == 1
                        ? '1-day streak'
                        : '$streakDays-day streak',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({required this.day});

  final ProgressDay day;

  @override
  Widget build(BuildContext context) {
    final reviewed = day.reviewedCount > 0;
    final status = reviewed
        ? 'reviewed'
        : day.isFuture
        ? 'still to come'
        : 'no review';
    return Semantics(
      label: '${weekdayName(day.date)}${day.isToday ? ', today' : ''}: $status',
      excludeSemantics: true,
      child: Container(
        height: 74,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: reviewed
              ? PinneColors.lilac
              : PinneColors.glass.withValues(alpha: day.isFuture ? 0.04 : 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: day.isToday ? PinneColors.lilac : PinneColors.line,
            width: day.isToday ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              reviewed ? Icons.check_rounded : Icons.circle_outlined,
              size: reviewed ? 18 : 8,
              color: reviewed
                  ? PinneColors.ink
                  : PinneColors.muted.withValues(alpha: 0.5),
            ),
            Text(
              weekdayLetter(day.date),
              style: TextStyle(
                color: reviewed ? PinneColors.ink : PinneColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: PinneColors.violet.withValues(alpha: 0.22),
      borderRadius: BorderRadius.circular(PinneRadii.chip),
      border: Border.all(color: PinneColors.violet.withValues(alpha: 0.6)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: PinneColors.lilac),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

/// A collection's review rate as a card that fills from the left.
class CollectionProgressBar extends StatelessWidget {
  const CollectionProgressBar({super.key, required this.progress});

  final CollectionProgress progress;

  @override
  Widget build(BuildContext context) {
    final accent = collectionAccent(progress.paletteIndex);
    final fraction = progress.reviewRate ?? 0;
    Widget content(Color colour) => Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            progress.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: colour),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '${progress.reviewedCount} of ${progress.cohortCount} '
                  'revisited',
                  style: TextStyle(
                    color: colour.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                percentLabel(progress.reviewRate),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colour,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    Widget layers(double shown) => Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: accent.withValues(alpha: 0.2)),
        FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: shown,
          child: ColoredBox(color: accent),
        ),
        content(PinneColors.text),
        // The same text in ink where it sits on the filled part.
        ClipRect(
          clipper: _LeadingFraction(shown),
          child: content(PinneColors.ink),
        ),
      ],
    );

    return Semantics(
      label:
          '${progress.name}: ${percentLabel(progress.reviewRate)} revisited, '
          '${progress.reviewedCount} of ${progress.cohortCount}',
      excludeSemantics: true,
      child: SizedBox(
        height: 92,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(PinneRadii.card),
          child: reduceMotionOf(context)
              ? layers(fraction)
              : TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: fraction),
                  duration: PinneMotionDurations.slow * 1.4,
                  curve: PinneMotionCurves.enter,
                  builder: (context, shown, _) => layers(shown),
                ),
        ),
      ),
    );
  }
}

class _LeadingFraction extends CustomClipper<Rect> {
  _LeadingFraction(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction.clamp(0.0, 1.0), size.height);

  @override
  bool shouldReclip(_LeadingFraction oldClipper) =>
      oldClipper.fraction != fraction;
}

/// Distinct saves reviewed per day, with the best day called out.
class ReviewDaysChart extends StatelessWidget {
  const ReviewDaysChart({super.key, required this.report});

  final ProgressReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = report.days;
    final most = days.fold<int>(
      0,
      (top, day) => math.max(top, day.reviewedCount),
    );
    final dense = days.length > 10;
    final best = report.bestDayDate;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review days', style: theme.textTheme.titleMedium),
          Text(
            most == 0
                ? 'Your first review day will show up here.'
                : 'Saves revisited each day, ${periodPhrase(report.period)}.',
            style: const TextStyle(color: PinneColors.muted),
          ),
          const SizedBox(height: PinneSpacing.lg),
          SizedBox(
            height: 176,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (i, day) in days.indexed) ...[
                  if (i > 0) SizedBox(width: dense ? 3 : 8),
                  Expanded(
                    child: _DayBar(
                      day: day,
                      most: most,
                      best: day.date == best,
                      dense: dense,
                      showLabel: !dense || day.isToday || i % 7 == 0,
                      label: dense
                          ? '${reportDate(day.date).day}'
                          : weekdayLetter(day.date),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayBar extends StatelessWidget {
  const _DayBar({
    required this.day,
    required this.most,
    required this.best,
    required this.dense,
    required this.showLabel,
    required this.label,
  });

  final ProgressDay day;
  final int most;
  final bool best;
  final bool dense;
  final bool showLabel;
  final String label;

  @override
  Widget build(BuildContext context) {
    const maxBar = 104.0;
    final count = day.reviewedCount;
    final height = most == 0 || count == 0
        ? 6.0
        : 14 + (maxBar - 14) * count / most;
    final bar = Container(
      height: height,
      decoration: BoxDecoration(
        color: best
            ? PinneColors.violet
            : count > 0
            ? PinneColors.lilac.withValues(alpha: 0.42)
            : PinneColors.glass,
        borderRadius: BorderRadius.circular(dense ? 4 : 10),
        border: day.isToday && !best
            ? Border.all(color: PinneColors.lilac, width: 1.5)
            : null,
      ),
    );
    return Semantics(
      label:
          '${weekdayName(day.date)} ${shortDate(day.date)}: '
          '${day.isFuture ? 'still to come' : '$count reviewed'}'
          '${best ? ', best day so far' : ''}',
      excludeSemantics: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (best)
            const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'best day\nso far',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: PinneColors.lilac,
                  fontSize: 10,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (count > 0 && (!dense || best))
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: best ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          bar,
          const SizedBox(height: 6),
          SizedBox(
            height: 14,
            child: showLabel
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: day.isToday
                            ? PinneColors.text
                            : PinneColors.muted,
                        fontSize: 11,
                        fontWeight: day.isToday
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
