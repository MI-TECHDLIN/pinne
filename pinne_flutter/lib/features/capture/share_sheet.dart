import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_capture/pinne_capture.dart';

import '../../core/server_client.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import 'capture_labels.dart';
import 'capture_providers.dart';
import 'capture_store.dart';

/// The compact "Saved to Pinne" sheet shown over the app that shared.
///
/// The capture is written to the local database before the sheet says
/// "Saved". Title and note edits go to the same row while the capture is
/// held; Done releases it to the outbox and returns to the source app.
class ShareSheetScreen extends ConsumerStatefulWidget {
  const ShareSheetScreen({
    super.key,
    required this.text,
    this.subject,
    required this.onDone,
  });

  /// The shared text, which usually is or contains the link.
  final String text;

  /// The share subject some apps send, often the page title.
  final String? subject;

  /// Closes the sheet and returns to the app that shared.
  final VoidCallback onDone;

  @override
  ConsumerState<ShareSheetScreen> createState() => _ShareSheetScreenState();
}

class _ShareSheetScreenState extends ConsumerState<ShareSheetScreen> {
  static const _editDelay = Duration(milliseconds: 300);

  late final CaptureInput _input = parseCaptureInput(
    widget.text,
    subject: widget.subject,
  );
  final _title = TextEditingController();
  final _why = TextEditingController();
  LocalCapture? _saved;
  LocalCapture? _earlier;
  bool _failed = false;
  bool _closing = false;
  Timer? _editTimer;
  late final AppLifecycleListener _lifecycle;
  late final CaptureStore? _store;

  @override
  void initState() {
    super.initState();
    _store = ref.read(captureStoreProvider);
    _persist();
    // Leaving the sheet without Done still keeps every word typed.
    _lifecycle = AppLifecycleListener(onHide: _flushEdits);
  }

  void _persist() {
    final store = _store;
    if (store == null || _input.isEmpty) return;
    try {
      final link = _input.link;
      _earlier = link == null ? null : store.findSaved(link);
      final saved = store.save(_input, hold: true);
      _title.text = saved.title;
      _saved = saved;
      _failed = false;
    } on Object {
      _failed = true;
    }
  }

  void _scheduleEdit() {
    _editTimer?.cancel();
    _editTimer = Timer(_editDelay, _flushEdits);
  }

  void _flushEdits() {
    _editTimer?.cancel();
    final saved = _saved;
    final store = _store;
    if (saved == null || store == null) return;
    store.editHeld(
      saved.clientItemId,
      title: _title.text,
      intention: _why.text,
    );
  }

  void _done() {
    if (_closing) return;
    _closing = true;
    final saved = _saved;
    final store = _store;
    if (saved != null && store != null) {
      _flushEdits();
      store.release(saved.clientItemId);
      final sync = ref.read(outboxSyncProvider);
      if (sync != null) unawaited(sync.drain());
    }
    widget.onDone();
  }

  @override
  void dispose() {
    _flushEdits();
    _lifecycle.dispose();
    _title.dispose();
    _why.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = reduceMotionOf(context);
    final sheet = _SheetFrame(child: _content(context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _done();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned.fill(
              child:
                  Semantics(
                    label: 'Close and go back',
                    button: true,
                    child: GestureDetector(
                      onTap: _done,
                      child: const ColoredBox(color: Color(0x99000000)),
                    ),
                  ).animate().fadeIn(
                    duration: motionDurationOf(
                      context,
                      PinneMotionDurations.quick,
                    ),
                  ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: reduced
                  ? sheet.animate().fadeIn(
                      duration: PinneMotionDurations.reducedFade,
                    )
                  : sheet
                        .animate()
                        .fadeIn(duration: PinneMotionDurations.quick)
                        .slideY(
                          begin: 0.25,
                          end: 0,
                          duration: PinneMotionDurations.standard,
                          curve: PinneMotionCurves.enter,
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    if (_input.isEmpty) {
      return _Message(
        title: 'Nothing to save',
        body: 'This share had no link or text in it.',
        onClose: widget.onDone,
      );
    }
    if (_store == null || _failed) {
      return _Message(
        title: 'Not saved',
        body:
            'Pinne could not write to this phone\'s storage, so nothing was '
            'saved. Try sharing again.',
        onClose: widget.onDone,
        onRetry: _failed ? () => setState(_persist) : null,
      );
    }
    final saved = _saved!;
    final signedIn = ref.watch(signedInProvider);
    final theme = Theme.of(context);
    final earlier = _earlier;
    final status = earlier != null
        ? 'You saved this before. Anything you add here joins that save.'
        : signedIn
        ? 'Kept on this phone. It syncs next time Pinne is open and online.'
        : 'Kept on this phone. Sign in to Pinne to sync it.';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                liveRegion: true,
                child: Text(
                  earlier != null ? 'Already in Pinne' : 'Saved to Pinne',
                  key: const ValueKey('share-saved-heading'),
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
            SourceBadge(source: saved.source),
          ],
        ),
        const SizedBox(height: PinneSpacing.xs),
        Text(
          status,
          style: theme.textTheme.bodySmall?.copyWith(color: PinneColors.muted),
        ),
        const SizedBox(height: PinneSpacing.md),
        _Field(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                key: const ValueKey('share-title'),
                controller: _title,
                onChanged: (_) => _scheduleEdit(),
                maxLength: CaptureLimits.maxTitleLength,
                maxLines: 2,
                minLines: 1,
                textInputAction: TextInputAction.next,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration.collapsed(
                  hintText: 'Title',
                ).copyWith(counterText: ''),
              ),
              const SizedBox(height: 2),
              Text(
                saved.url == null ? 'Note' : readableUrl(saved.url!),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: PinneColors.muted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: PinneSpacing.sm),
        _Field(
          child: TextField(
            key: const ValueKey('share-why'),
            controller: _why,
            onChanged: (_) => _scheduleEdit(),
            maxLength: CaptureLimits.maxIntentionLength,
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration.collapsed(
              hintText: 'Why did you save this? (optional)',
              hintStyle: TextStyle(color: PinneColors.muted),
            ).copyWith(counterText: ''),
          ),
        ),
        const SizedBox(height: PinneSpacing.lg),
        // The one primary action on this screen, so it may use lime.
        FilledButton(
          key: const ValueKey('share-done'),
          style: FilledButton.styleFrom(
            backgroundColor: PinneColors.accentPrimaryAction,
            foregroundColor: PinneColors.ink,
            minimumSize: const Size.fromHeight(48),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
          onPressed: _done,
          child: Text(_doneLabel(saved.source)),
        ),
      ],
    );
  }

  static String _doneLabel(CaptureSource source) => switch (source) {
    CaptureSource.web || CaptureSource.note || CaptureSource.unknown => 'Done',
    _ => 'Done · back to ${source.label}',
  };
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 560),
      decoration: const BoxDecoration(
        color: PinneColors.midnightRaised,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(PinneRadii.sheet),
        ),
        border: Border(top: BorderSide(color: PinneColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            PinneSpacing.lg,
            PinneSpacing.lg,
            PinneSpacing.lg,
            PinneSpacing.lg,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PinneSpacing.md,
        vertical: PinneSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: PinneColors.glass,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PinneColors.line),
      ),
      child: child,
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.title,
    required this.body,
    required this.onClose,
    this.onRetry,
  });

  final String title;
  final String body;
  final VoidCallback onClose;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          liveRegion: true,
          child: Text(title, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: PinneSpacing.xs),
        Text(body, style: const TextStyle(color: PinneColors.muted)),
        const SizedBox(height: PinneSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: const Text('Try again')),
            TextButton(onPressed: onClose, child: const Text('Close')),
          ],
        ),
      ],
    );
  }
}
