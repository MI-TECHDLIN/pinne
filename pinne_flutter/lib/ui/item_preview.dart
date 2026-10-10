import 'package:flutter/material.dart';
import 'package:pinne_client/pinne_client.dart';

import '../theme/pinne_tokens.dart';
import 'motion.dart';

enum PreviewChipSurface { dark, pastel, due }

({Color background, Color foreground, Color border}) previewChipColors(
  PreviewChipSurface surface,
) => switch (surface) {
  PreviewChipSurface.dark => (
    background: PinneColors.cardRaised,
    foreground: PinneColors.text,
    border: PinneColors.line,
  ),
  PreviewChipSurface.pastel || PreviewChipSurface.due => (
    background: PinneColors.ink,
    foreground: PinneColors.text,
    border: PinneColors.ink,
  ),
};

class PreviewSourceChip extends StatelessWidget {
  const PreviewSourceChip({
    super.key,
    required this.source,
    this.surface = PreviewChipSurface.dark,
  });

  final SourcePlatform source;
  final PreviewChipSurface surface;

  @override
  Widget build(BuildContext context) {
    final colors = previewChipColors(surface);
    return Chip(
      key: const ValueKey('preview-source'),
      visualDensity: VisualDensity.compact,
      backgroundColor: colors.background,
      side: BorderSide(color: colors.border),
      label: Text(
        _sourceName(source),
        style: TextStyle(
          color: colors.foreground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static String _sourceName(SourcePlatform source) => switch (source) {
    SourcePlatform.youtube => 'YouTube',
    SourcePlatform.x => 'X',
    SourcePlatform.instagram => 'Instagram',
    SourcePlatform.tiktok => 'TikTok',
    SourcePlatform.reddit => 'Reddit',
    SourcePlatform.github => 'GitHub',
    SourcePlatform.note => 'Note',
    SourcePlatform.web => 'Web',
    SourcePlatform.other => 'Link',
    SourcePlatform.unknown => 'Link',
  };
}

class PreviewThumbnail extends StatelessWidget {
  const PreviewThumbnail({super.key, required this.item, this.height = 148});

  final Item item;
  final double height;

  @override
  Widget build(BuildContext context) {
    final pending =
        item.enrichmentState == EnrichmentState.pending ||
        item.enrichmentState == EnrichmentState.processing;
    final url = item.thumbnailUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(PinneRadii.tile),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: url == null
            ? _PreviewPlaceholder(pending: pending)
            : Image.network(
                url,
                key: const ValueKey('preview-thumbnail'),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                frameBuilder: (context, child, frame, synchronouslyLoaded) =>
                    synchronouslyLoaded || frame != null
                    ? child
                    : const _PreviewPlaceholder(pending: true),
                errorBuilder: (_, _, _) =>
                    const _PreviewPlaceholder(pending: false),
              ),
      ),
    );
  }
}

class _PreviewPlaceholder extends StatelessWidget {
  const _PreviewPlaceholder({required this.pending});

  final bool pending;

  @override
  Widget build(BuildContext context) => Container(
    key: ValueKey(pending ? 'preview-skeleton' : 'preview-placeholder'),
    color: PinneColors.cardRaised,
    alignment: Alignment.center,
    child: pending && !reduceMotionOf(context)
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: PinneColors.lilac,
            ),
          )
        : Icon(
            pending ? Icons.hourglass_empty_rounded : Icons.link_rounded,
            color: PinneColors.muted,
            size: 30,
          ),
  );
}

class PreviewByline extends StatelessWidget {
  const PreviewByline({super.key, required this.item, this.color});

  final Item item;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final byline = item.previewAuthor ?? item.previewSiteName;
    final status = previewAvailabilityText(item);
    if (byline == null && status == null) return const SizedBox.shrink();
    return Text(
      status ?? byline!,
      key: status == null ? null : const ValueKey('preview-unavailable'),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: color ?? PinneColors.muted,
        height: 1.35,
      ),
    );
  }
}

class DurationChip extends StatelessWidget {
  const DurationChip({
    super.key,
    required this.seconds,
    this.surface = PreviewChipSurface.dark,
  });

  final int seconds;
  final PreviewChipSurface surface;

  @override
  Widget build(BuildContext context) {
    final colors = previewChipColors(surface);
    return Chip(
      key: const ValueKey('known-duration'),
      visualDensity: VisualDensity.compact,
      backgroundColor: colors.background,
      side: BorderSide(color: colors.border),
      label: Text(
        _duration(seconds),
        style: TextStyle(
          color: colors.foreground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static String _duration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final remaining = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:'
          '${remaining.toString().padLeft(2, '0')}';
    }
    return '$minutes:${remaining.toString().padLeft(2, '0')}';
  }
}

String? previewAvailabilityText(Item item) {
  if (item.accessState == AccessState.loginRequired) {
    return 'Sign in is required for a preview. The link is saved.';
  }
  if (item.accessState == AccessState.unavailable ||
      item.enrichmentState == EnrichmentState.failed) {
    return 'Preview not available. The link is saved.';
  }
  return null;
}
