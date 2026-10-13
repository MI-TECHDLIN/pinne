import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/pinne_tokens.dart';
import 'glass_card.dart';
import 'motion.dart';

/// Pinne's shared loading treatment for content that will resolve into cards.
///
/// The skeleton stops shimmering when the user asks for reduced motion, while
/// keeping the same layout so content does not jump when it arrives.
class PinneSkeleton extends StatelessWidget {
  const PinneSkeleton({
    super.key,
    required this.child,
    this.label = 'Loading content',
  });

  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    final reduced = reduceMotionOf(context);
    return Semantics(
      container: true,
      liveRegion: true,
      label: label,
      child: ExcludeSemantics(
        child: Skeletonizer.zone(
          effect: reduced
              ? SolidColorEffect(color: context.pinne.cardRaised)
              : ShimmerEffect(
                  baseColor: context.pinne.cardRaised,
                  highlightColor: Color(0xFF4A3D6B),
                  duration: Duration(milliseconds: 1400),
                ),
          child: child,
        ),
      ),
    );
  }
}

/// A dark glass placeholder shaped like Pinne's saved/search/planner cards.
class PinneCardSkeleton extends StatelessWidget {
  const PinneCardSkeleton({
    super.key,
    this.height = 148,
    this.showThumbnail = false,
    this.label = 'Loading card',
  });

  final double height;
  final bool showThumbnail;
  final String label;

  @override
  Widget build(BuildContext context) => PinneSkeleton(
    label: label,
    child: GlassCard(
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showThumbnail) ...[
              const Expanded(
                child: Bone(
                  width: double.infinity,
                  borderRadius: BorderRadius.all(
                    Radius.circular(PinneRadii.tile),
                  ),
                ),
              ),
              const SizedBox(height: PinneSpacing.md),
            ],
            const Bone.text(width: 92, fontSize: 11),
            const SizedBox(height: PinneSpacing.sm),
            const Bone.text(width: 220, fontSize: 20),
            const SizedBox(height: PinneSpacing.sm),
            const Bone.text(width: 170, fontSize: 14),
            const Spacer(),
            const Bone.text(width: 116, fontSize: 13),
          ],
        ),
      ),
    ),
  );
}

/// A pastel-tile-sized placeholder for collections and Today actions.
class PinneTileSkeleton extends StatelessWidget {
  const PinneTileSkeleton({super.key, this.height = 196});

  final double height;

  @override
  Widget build(BuildContext context) => PinneSkeleton(
    label: 'Loading tile',
    child: SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.pinne.card,
          borderRadius: BorderRadius.all(Radius.circular(PinneRadii.tile)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(PinneSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Bone(
                  width: double.infinity,
                  borderRadius: BorderRadius.all(
                    Radius.circular(PinneSpacing.md),
                  ),
                ),
              ),
              SizedBox(height: PinneSpacing.md),
              Bone.text(width: 70, fontSize: 10),
              SizedBox(height: PinneSpacing.sm),
              Bone.text(width: 116, fontSize: 17),
              SizedBox(height: PinneSpacing.xs),
              Bone.text(width: 92, fontSize: 13),
            ],
          ),
        ),
      ),
    ),
  );
}

/// A compact placeholder for suggestion chips inside an existing card.
class PinneSuggestionSkeleton extends StatelessWidget {
  const PinneSuggestionSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const PinneSkeleton(
    label: 'Loading AI suggestions',
    child: Column(
      key: ValueKey('ai-suggestions-skeleton'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Bone.text(width: 92, fontSize: 12),
        SizedBox(height: PinneSpacing.xs),
        Row(
          children: [
            Bone(
              width: 116,
              height: 32,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            SizedBox(width: PinneSpacing.xs),
            Bone(
              width: 88,
              height: 32,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ],
        ),
      ],
    ),
  );
}

/// Branded indeterminate wait for compact actions that are not loading cards.
class PinneBrandedLoader extends StatelessWidget {
  const PinneBrandedLoader({super.key, this.size = 24, this.label = 'Working'});

  final double size;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    key: const ValueKey('pinne-branded-loader'),
    label: label,
    liveRegion: true,
    child: ExcludeSemantics(
      child: reduceMotionOf(context)
          ? SizedBox.square(
              dimension: size,
              child: Center(
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: size * 0.72,
                  color: context.pinne.lilac,
                ),
              ),
            )
          : LoadingAnimationWidget.twistingDots(
              leftDotColor: context.pinne.violet,
              rightDotColor: context.pinne.pink,
              size: size,
            ),
    ),
  );
}
