import 'package:flutter/material.dart';

import '../theme/pinne_tokens.dart';
import '../ui/glass_card.dart';

export '../ui/glass_card.dart';

/// Shared layout for top-level screens: the violet glow, a big light headline
/// with an optional bold tail, and scrolling content that clears the nav.
class PinnePage extends StatelessWidget {
  const PinnePage({
    super.key,
    required this.headline,
    this.headlineBold,
    this.subtitle,
    this.children = const [],
  });

  final String headline;
  final String? headlineBold;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final display = theme.textTheme.displaySmall;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.6, -1.2),
          radius: 1.2,
          colors: [PinneColors.glowViolet, PinneColors.midnight],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            PinneSpacing.gutter,
            PinneSpacing.xl,
            PinneSpacing.gutter,
            PinneSpacing.navClearance,
          ),
          children: [
            Semantics(
              header: true,
              child: Text.rich(
                TextSpan(
                  text: headline,
                  children: [
                    if (headlineBold != null)
                      TextSpan(
                        text: ' $headlineBold',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
                style: display,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: PinneSpacing.sm),
              Text(
                subtitle!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: PinneColors.muted,
                ),
              ),
            ],
            const SizedBox(height: PinneSpacing.xl),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Placeholder body for screens whose features are not built yet.
class ComingSoonCard extends StatelessWidget {
  const ComingSoonCard({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: PinneSpacing.xs),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: PinneColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
