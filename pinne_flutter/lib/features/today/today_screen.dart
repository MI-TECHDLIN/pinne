import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PinnePage(
      headline: 'Today,',
      headlineBold: 'a few good saves',
      subtitle: 'A small queue of what is worth revisiting now.',
      children: [
        _DueNowCard(),
        SizedBox(height: PinneSpacing.md),
        ComingSoonCard(
          title: 'Your queue stays small',
          body:
              'Items you save show up here about a day later, '
              'with the note you left on why you saved them.',
        ),
      ],
    );
  }
}

class _DueNowCard extends StatelessWidget {
  const _DueNowCard();

  @override
  Widget build(BuildContext context) {
    final card = Semantics(
      container: true,
      label: 'Due now. Flutter desktop sidebar from X. About 10 minutes.',
      child: Container(
        key: const ValueKey('due-now-card'),
        padding: const EdgeInsets.all(PinneSpacing.lg),
        decoration: BoxDecoration(
          color: PinneColors.accentDue,
          borderRadius: BorderRadius.circular(PinneRadii.card),
        ),
        child: ExcludeSemantics(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DUE NOW · 10 MIN',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: PinneColors.ink.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: PinneSpacing.xs),
                    Text(
                      'Flutter desktop\nsidebar from X',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: PinneColors.ink,
                        height: 1.08,
                      ),
                    ),
                  ],
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: PinneColors.ink,
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(
                  dimension: 38,
                  child: Icon(
                    Icons.north_east_rounded,
                    color: PinneColors.accentDue,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (reduceMotionOf(context)) return card;
    return RepaintBoundary(
      child: card
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(
            begin: 0,
            end: -4,
            duration: PinneMotionDurations.float,
            curve: PinneMotionCurves.float,
          ),
    );
  }
}
