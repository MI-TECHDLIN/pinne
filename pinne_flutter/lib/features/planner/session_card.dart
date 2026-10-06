import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import 'planner_format.dart';

/// Fades and lifts a card into place; a plain fade with reduced motion.
class AnimatedEntry extends StatelessWidget {
  const AnimatedEntry({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (reduceMotionOf(context)) {
      return child.animate().fadeIn(duration: PinneMotionDurations.reducedFade);
    }
    return child
        .animate(delay: staggerDelayOf(context, index.clamp(0, 8)))
        .fadeIn(duration: PinneMotionDurations.standard)
        .slideY(
          begin: 0.12,
          end: 0,
          duration: PinneMotionDurations.standard,
          curve: PinneMotionCurves.enter,
        );
  }
}

/// A review session: time, what it holds, and where its event stands, in
/// words as well as styling.
class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.view,
    required this.zone,
    this.onMove,
    this.onCancel,
    this.onExport,
  });

  final SessionView view;
  final String zone;
  final VoidCallback? onMove;
  final VoidCallback? onCancel;
  final VoidCallback? onExport;

  @override
  Widget build(BuildContext context) {
    final session = view.session;
    final proposed = session.status == SessionStatus.proposed;
    final items = view.items;
    final theme = Theme.of(context);
    const ink = PinneColors.ink;
    final details = [
      itemCount(items.length),
      if (items.any((i) => i.estimated))
        'about ${items.fold<int>(0, (sum, i) => sum + i.plannedMinutes)} min, estimated',
    ].join(' · ');

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PinneRadii.card),
        gradient: proposed
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [PinneColors.sky, PinneColors.lilac],
              ),
        color: proposed ? PinneColors.card : null,
        border: proposed ? Border.all(color: PinneColors.lilac) : null,
      ),
      child: Stack(
        children: [
          if (!proposed)
            const Positioned(
              right: -18,
              top: -14,
              child: SizedBox(
                width: 84,
                height: 84,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PinneColors.violet,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(PinneSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: PinneSpacing.sm,
                  runSpacing: PinneSpacing.xs,
                  children: [
                    _Pill(
                      text: timeRange(session.startAt, session.endAt, zone),
                      dark: !proposed,
                    ),
                    if (proposed) const _Pill(text: 'Proposed', dark: false),
                  ],
                ),
                const SizedBox(height: PinneSpacing.sm),
                Text(
                  items.isEmpty
                      ? 'Open review time'
                      : items.length == 1
                      ? items.single.title
                      : '${items.first.title} and ${items.length - 1} more',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: proposed ? PinneColors.text : ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  items.isEmpty ? 'Pick anything from your queue.' : details,
                  style: TextStyle(
                    color: proposed ? PinneColors.muted : ink,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: PinneSpacing.xs),
                Text(
                  sessionStatusLine(view),
                  style: TextStyle(
                    color: proposed ? PinneColors.muted : ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onMove != null || onCancel != null || onExport != null)
                  Padding(
                    padding: const EdgeInsets.only(top: PinneSpacing.sm),
                    child: Wrap(
                      spacing: PinneSpacing.xs,
                      children: [
                        if (onMove != null)
                          _CardAction(
                            label: 'Move',
                            onPressed: onMove!,
                            dark: !proposed,
                          ),
                        if (onCancel != null)
                          _CardAction(
                            label: 'Cancel session',
                            onPressed: onCancel!,
                            dark: !proposed,
                          ),
                        if (onExport != null)
                          _CardAction(
                            label: 'Export .ics',
                            onPressed: onExport!,
                            dark: !proposed,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.dark});

  final String text;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PinneRadii.chip),
        color: dark
            ? PinneColors.ink.withValues(alpha: 0.12)
            : PinneColors.glass,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: dark ? PinneColors.ink : PinneColors.lilac,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  const _CardAction({
    required this.label,
    required this.onPressed,
    required this.dark,
  });

  final String label;
  final VoidCallback onPressed;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: dark ? PinneColors.ink : PinneColors.lilac,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
        ),
        visualDensity: VisualDensity.compact,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
