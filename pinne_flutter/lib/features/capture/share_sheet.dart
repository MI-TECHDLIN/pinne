import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/server_client.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/feedback/toast.dart';
import '../../ui/motion.dart';
import '../settings/profile_provider.dart';
import 'capture_labels.dart';
import 'capture_providers.dart';
import 'capture_store.dart';
import 'save_celebration.dart';

/// The compact "Saved to Pinne" sheet shown over the app that shared.
///
/// The capture is written to the local database as soon as the sheet opens,
/// held so nothing is lost while the user adds a note. Title and note edits
/// go to the same row while it is held. Done confirms the save: it releases
/// the capture to the outbox, plays the Saved celebration for a new save and
/// returns to the source app. Leaving by back or the dim keeps the save
/// quietly, with a toast; "Don't save" removes it.
class ShareSheetScreen extends ConsumerStatefulWidget {
  const ShareSheetScreen({
    super.key,
    required this.text,
    this.subject,
    required this.onDone,
    this.onToast,
  });

  /// The shared text, which usually is or contains the link.
  final String text;

  /// The share subject some apps send, often the page title.
  final String? subject;

  /// Closes the sheet and returns to the app that shared.
  final VoidCallback onDone;

  /// Shows a short message that outlives the sheet, over the source app.
  final ValueChanged<String>? onToast;

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
  bool _confirmed = false;
  bool _discarding = false;
  bool _discarded = false;
  Timer? _editTimer;
  Timer? _closeTimer;
  late final AppLifecycleListener _lifecycle;
  late final CaptureStore? _store;
  late final String? _accountId;

  @override
  void initState() {
    super.initState();
    _store = ref.read(captureStoreProvider);
    _accountId = ref.read(accountIdProvider);
    _persist();
    // Leaving the sheet without Done still keeps every word typed.
    _lifecycle = AppLifecycleListener(onHide: _flushEdits);
  }

  void _persist() {
    final store = _store;
    final accountId = _accountId;
    if (store == null || accountId == null || _input.isEmpty) {
      _failed = true;
      return;
    }
    try {
      final link = _input.link;
      _earlier = link == null
          ? null
          : store.findSaved(link, accountId: accountId);
      final saved = store.save(_input, accountId: accountId, hold: true);
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
    final accountId = _accountId;
    if (_discarded || saved == null || store == null || accountId == null) {
      return;
    }
    store.editHeld(
      saved.clientItemId,
      accountId: accountId,
      title: _title.text,
      intention: _why.text,
    );
  }

  /// Lets the outbox send the capture. True when there was one to keep.
  bool _keep() {
    final saved = _saved;
    final store = _store;
    final accountId = _accountId;
    if (saved == null || store == null || accountId == null) return false;
    _flushEdits();
    store.release(saved.clientItemId, accountId: accountId);
    final sync = ref.read(outboxSyncProvider);
    if (sync != null) unawaited(sync.drain());
    return true;
  }

  /// Done: the only place a new save is confirmed and celebrated. A repeat
  /// already says "Already in Pinne", so it closes without celebrating.
  void _done() {
    if (_closing) return;
    _closing = true;
    if (!_keep() || _earlier != null) {
      widget.onDone();
      return;
    }
    setState(() => _confirmed = true);
    final avatar = ref.read(avatarRecipeProvider);
    showSaveCelebration(context, seed: avatar.seed, palette: avatar.palette);
    _closeTimer = Timer(saveCelebrationDuration, widget.onDone);
  }

  /// Back, swipe or a tap on the dim: the safe default keeps the save,
  /// without the celebration that only Done plays.
  void _leave() {
    if (_closing) return;
    _closing = true;
    if (_keep()) {
      widget.onToast?.call(
        _earlier != null ? 'Already in Pinne' : 'Saved to Pinne',
      );
    }
    widget.onDone();
  }

  /// "Don't save": removes the capture and its queued operation. If it
  /// already synced as a new item, the server copy goes first, so a failed
  /// call leaves both in place.
  Future<void> _discard() async {
    final saved = _saved;
    final store = _store;
    final accountId = _accountId;
    if (_closing || saved == null || store == null || accountId == null) {
      return;
    }
    _closing = true;
    _editTimer?.cancel();
    setState(() => _discarding = true);
    final current = store.capture(saved.clientItemId, accountId: accountId);
    final serverItemId = current?.serverItemId;
    if (current != null && serverItemId != null && !current.duplicate) {
      try {
        await ref
            .read(captureApiProvider)
            .remove(UuidValue.fromString(serverItemId));
      } on Object catch (error) {
        if (!mounted) return;
        setState(() {
          _closing = false;
          _discarding = false;
        });
        showErrorToast(context, error, 'Could not remove it');
        return;
      }
    }
    store.discard(saved.clientItemId, accountId: accountId);
    _discarded = true;
    widget.onToast?.call('Not saved');
    widget.onDone();
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
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
        if (!didPop) _leave();
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
                      onTap: _leave,
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
    if (_accountId == null) {
      return _Message(
        title: 'Open Pinne first',
        body:
            'Sign in or start a guest account before saving from another app.',
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
        ? 'Kept safe on this phone. Add why if you like, then tap Done.'
        : 'Kept safe on this phone. Tap Done, then sign in to Pinne to '
              'sync it.';
    final String heading;
    if (earlier != null) {
      heading = 'Already in Pinne';
    } else if (_confirmed) {
      heading = 'Saved to Pinne';
    } else {
      heading = 'Save to Pinne';
    }

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
                  heading,
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
          style: theme.textTheme.bodySmall?.copyWith(
            color: context.pinne.muted,
          ),
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
                  color: context.pinne.muted,
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
            decoration: InputDecoration.collapsed(
              hintText: 'Why did you save this? (optional)',
              hintStyle: TextStyle(color: context.pinne.muted),
            ).copyWith(counterText: ''),
          ),
        ),
        const SizedBox(height: PinneSpacing.lg),
        // The one primary action on this screen, so it may use lime.
        FilledButton(
          key: const ValueKey('share-done'),
          style: FilledButton.styleFrom(
            backgroundColor: context.pinne.accentPrimaryAction,
            foregroundColor: context.pinne.ink,
            minimumSize: const Size.fromHeight(48),
            textStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: _done,
          child: Text(_doneLabel(saved.source)),
        ),
        const SizedBox(height: PinneSpacing.xs),
        TextButton(
          key: const ValueKey('share-discard'),
          style: TextButton.styleFrom(minimumSize: const Size.fromHeight(44)),
          onPressed: _discarding ? null : _discard,
          child: Text(earlier != null ? 'Cancel' : "Don't save"),
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
      decoration: BoxDecoration(
        color: context.pinne.midnightRaised,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(PinneRadii.sheet),
        ),
        border: Border(top: BorderSide(color: context.pinne.line)),
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
        color: context.pinne.glass,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.pinne.line),
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
        Text(body, style: TextStyle(color: context.pinne.muted)),
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
