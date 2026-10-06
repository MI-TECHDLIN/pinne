import 'package:flutter/material.dart';
import 'package:pinne_capture/pinne_capture.dart';

import '../../theme/pinne_tokens.dart';
import 'capture_store.dart';

/// The source as a text chip. The dot is decoration; the label carries the
/// meaning, so it never depends on colour.
class SourceBadge extends StatelessWidget {
  const SourceBadge({super.key, required this.source});

  final CaptureSource source;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Source: ${source.label}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PinneSpacing.sm + 2,
          vertical: PinneSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: PinneColors.glass,
          borderRadius: BorderRadius.circular(PinneRadii.chip),
          border: Border.all(color: PinneColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                color: PinneColors.sky,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(dimension: 6),
            ),
            const SizedBox(width: PinneSpacing.xs + 2),
            Text(
              source.label,
              style: const TextStyle(
                color: PinneColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Where a capture is on its way to the server, as an icon plus words.
class SyncStatusLabel extends StatelessWidget {
  const SyncStatusLabel({
    super.key,
    required this.capture,
    required this.signedIn,
  });

  final LocalCapture capture;
  final bool signedIn;

  static String textFor(LocalCapture capture, {required bool signedIn}) {
    return switch (capture.syncState) {
      CaptureSyncState.synced when capture.duplicate => 'Already saved',
      CaptureSyncState.synced => 'Synced',
      CaptureSyncState.failed => 'Not synced',
      CaptureSyncState.pending when !signedIn => 'On phone · sign in to sync',
      CaptureSyncState.pending => 'On phone · syncing',
    };
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (capture.syncState) {
      CaptureSyncState.synced => (
        Icons.cloud_done_outlined,
        PinneColors.lilac,
      ),
      CaptureSyncState.failed => (
        Icons.error_outline_rounded,
        PinneColors.peach,
      ),
      CaptureSyncState.pending => (Icons.schedule_rounded, PinneColors.muted),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: PinneSpacing.xs),
        Flexible(
          child: Text(
            textFor(capture, signedIn: signedIn),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
