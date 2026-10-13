import 'package:flutter/material.dart';

import '../../theme/pinne_tokens.dart';
import '../ribbon_spirit/ribbon_cutout.dart';
import 'friendly_error.dart';

/// A designed failure state: the Ribbon Spirit, what happened in plain words,
/// what to do, and a Try again action. Use [PinneErrorCard] inside a screen
/// that still has other content and [PinneErrorState] when a whole screen
/// failed to load.
class PinneErrorCard extends StatelessWidget {
  const PinneErrorCard({
    super.key,
    required this.error,
    this.subject = 'this',
    this.onRetry,
    this.secondaryLabel,
    this.onSecondary,
  });

  final Object? error;

  /// What failed to load, such as "your queue".
  final String subject;
  final VoidCallback? onRetry;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final friendly = FriendlyError.from(error, subject: subject);
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 330;
        final art = _SpiritBadge(friendly: friendly, size: narrow ? 64 : 84);
        final copy = _ErrorCopy(
          friendly: friendly,
          onRetry: onRetry,
          secondaryLabel: secondaryLabel,
          onSecondary: onSecondary,
        );
        return Container(
          key: ValueKey('error-card-${friendly.cause.name}'),
          padding: const EdgeInsets.all(PinneSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [context.pinne.cardRaised, context.pinne.card],
            ),
            borderRadius: BorderRadius.circular(PinneRadii.card),
            border: Border.all(color: context.pinne.line),
          ),
          child: narrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    art,
                    const SizedBox(height: PinneSpacing.md),
                    copy,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: copy),
                    const SizedBox(width: PinneSpacing.md),
                    art,
                  ],
                ),
        );
      },
    );
  }
}

/// Full-screen version of [PinneErrorCard], centred in whatever space it has.
class PinneErrorState extends StatelessWidget {
  const PinneErrorState({
    super.key,
    required this.error,
    this.subject = 'this',
    this.onRetry,
    this.secondaryLabel,
    this.onSecondary,
  });

  final Object? error;
  final String subject;
  final VoidCallback? onRetry;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final friendly = FriendlyError.from(error, subject: subject);
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final artSize = (constraints.maxWidth * .38).clamp(96.0, 160.0);
        return Center(
          key: ValueKey('error-state-${friendly.cause.name}'),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(PinneSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SpiritBadge(friendly: friendly, size: artSize),
                  const SizedBox(height: PinneSpacing.lg),
                  Semantics(
                    header: true,
                    child: Text(
                      friendly.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: PinneSpacing.sm),
                  Text(
                    friendly.message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.pinne.muted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: PinneSpacing.xl),
                  _Actions(
                    friendly: friendly,
                    onRetry: onRetry,
                    secondaryLabel: secondaryLabel,
                    onSecondary: onSecondary,
                    alignment: WrapAlignment.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ErrorCopy extends StatelessWidget {
  const _ErrorCopy({
    required this.friendly,
    this.onRetry,
    this.secondaryLabel,
    this.onSecondary,
  });

  final FriendlyError friendly;
  final VoidCallback? onRetry;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(friendly.icon, size: 16, color: context.pinne.error),
            const SizedBox(width: PinneSpacing.xs),
            Flexible(
              child: Text(
                switch (friendly.cause) {
                  ErrorCause.offline => 'NO CONNECTION',
                  ErrorCause.server => 'SERVER BUSY',
                  ErrorCause.signedOut => 'SIGNED OUT',
                  ErrorCause.notFound => 'NOT FOUND',
                  ErrorCause.rejected => 'NOT ACCEPTED',
                  ErrorCause.credentials => 'SIGN-IN',
                  ErrorCause.tooManyAttempts => 'PAUSED',
                  ErrorCause.unknown => 'HICCUP',
                },
                style: TextStyle(
                  color: context.pinne.error,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: PinneSpacing.sm),
        Semantics(
          header: true,
          child: Text(friendly.title, style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: PinneSpacing.xs),
        Text(
          friendly.message,
          style: theme.textTheme.bodySmall?.copyWith(
            color: context.pinne.muted,
            height: 1.45,
          ),
        ),
        const SizedBox(height: PinneSpacing.md),
        _Actions(
          friendly: friendly,
          onRetry: onRetry,
          secondaryLabel: secondaryLabel,
          onSecondary: onSecondary,
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.friendly,
    this.onRetry,
    this.secondaryLabel,
    this.onSecondary,
    this.alignment = WrapAlignment.start,
  });

  final FriendlyError friendly;
  final VoidCallback? onRetry;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final secondary = secondaryLabel;
    return Wrap(
      alignment: alignment,
      spacing: PinneSpacing.sm,
      runSpacing: PinneSpacing.xs,
      children: [
        if (onRetry != null)
          FilledButton.icon(
            key: const ValueKey('error-retry'),
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Try again'),
          ),
        if (secondary != null && onSecondary != null)
          TextButton(
            key: const ValueKey('error-secondary'),
            onPressed: onSecondary,
            child: Text(secondary),
          ),
      ],
    );
  }
}

class _SpiritBadge extends StatelessWidget {
  const _SpiritBadge({required this.friendly, required this.size});

  final FriendlyError friendly;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.pinne.violet.withValues(alpha: .35),
                    context.pinne.violet.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(size * .08),
              child: RibbonSpiritCutout(
                asset: friendly.art,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * .34,
              height: size * .34,
              decoration: BoxDecoration(
                color: context.pinne.error,
                shape: BoxShape.circle,
                border: Border.all(color: context.pinne.card, width: 2),
              ),
              child: Icon(
                friendly.icon,
                size: size * .19,
                color: context.pinne.ink,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
