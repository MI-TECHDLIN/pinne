import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_capture/pinne_capture.dart';

import '../../core/server_client.dart';
import '../../shell/pill_nav_bar.dart';
import '../../shell/responsive.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/glass_card.dart';
import '../settings/profile_provider.dart';
import 'capture_labels.dart';
import 'capture_providers.dart';
import 'save_celebration.dart';

/// Compact entry from Today into the existing local-first manual capture UI.
class CaptureEntryTile extends StatelessWidget {
  const CaptureEntryTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.pinne.sky,
      borderRadius: BorderRadius.circular(PinneRadii.tile),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const ValueKey('capture-entry'),
        mouseCursor: SystemMouseCursors.click,
        onTap: () => _showCapture(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PinneSpacing.lg,
            vertical: PinneSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: context.pinne.ink,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add_rounded, color: context.pinne.onViolet),
              ),
              const SizedBox(width: PinneSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Save a link',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.pinne.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Paste a link or jot a note',
                      style: TextStyle(color: context.pinne.ink, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: context.pinne.ink),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCapture(BuildContext context) {
    final wide = !PinneBreakpoints.of(context).isCompact;
    if (kIsWeb || wide) {
      return showDialog<void>(
        context: context,
        useRootNavigator: true,
        builder: (context) => Dialog(
          key: const ValueKey('capture-dialog'),
          insetPadding: const EdgeInsets.all(PinneSpacing.xl),
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: const _ManualCaptureSheet(),
          ),
        ),
      );
    }
    return showModalBottomSheet<void>(
      context: context,
      // On the root navigator the sheet sits above the shell, so the
      // floating nav can no longer paint over its fields.
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final media = MediaQuery.of(context);
        // Float above the nav, or above the keyboard that hides it.
        final bottom = math.max(
          media.viewInsets.bottom,
          FloatingPillNav.extentOf(media),
        );
        return Padding(
          padding: EdgeInsets.fromLTRB(
            PinneSpacing.sm,
            0,
            PinneSpacing.sm,
            bottom + PinneSpacing.sm,
          ),
          child: const _ManualCaptureSheet(),
        );
      },
    );
  }
}

class _ManualCaptureSheet extends StatelessWidget {
  const _ManualCaptureSheet();

  @override
  Widget build(BuildContext context) => Material(
    color: context.pinne.midnightRaised,
    borderRadius: BorderRadius.circular(PinneRadii.sheet),
    clipBehavior: Clip.antiAlias,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(PinneSpacing.lg),
      child: const PasteCaptureCard(),
    ),
  );
}

/// Manual capture on Today: paste a link or type a note, optionally say why,
/// save. The same local-first path as sharing: stored on the phone first,
/// then synced.
class PasteCaptureCard extends ConsumerStatefulWidget {
  const PasteCaptureCard({super.key});

  @override
  ConsumerState<PasteCaptureCard> createState() => _PasteCaptureCardState();
}

class _PasteCaptureCardState extends ConsumerState<PasteCaptureCard> {
  final _content = TextEditingController();
  final _why = TextEditingController();
  CaptureInput _input = CaptureInput.empty;
  String? _confirmation;
  String? _error;

  @override
  void dispose() {
    _content.dispose();
    _why.dispose();
    super.dispose();
  }

  void _onContentChanged(String text) {
    setState(() {
      _input = parseCaptureInput(text);
      _confirmation = null;
      _error = null;
    });
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null || text.trim().isEmpty || !mounted) return;
    _content.text = text.trim();
    _onContentChanged(_content.text);
  }

  Future<void> _save() async {
    final store = ref.read(captureStoreProvider);
    final accountId = ref.read(accountIdProvider);
    if (store == null || accountId == null || _input.isEmpty) return;
    final link = _input.link;
    var duplicate = false;
    try {
      final earlier = link == null
          ? null
          : store.findSaved(link, accountId: accountId);
      duplicate = earlier != null;
      store.save(_input, accountId: accountId, intention: _why.text);
      await store.persist();
      if (!mounted) return;
      final sync = ref.read(outboxSyncProvider);
      if (sync != null) unawaited(sync.drain());
      final syncLine = ref.read(signedInProvider)
          ? 'Kept on this phone; it syncs when you are online.'
          : 'Kept on this phone; sign in to sync it.';
      setState(() {
        _confirmation = earlier != null
            ? 'Already in Pinne. Your note joins that save.'
            : 'Saved to Pinne. $syncLine';
        _error = null;
        _input = CaptureInput.empty;
      });
      _content.clear();
      _why.clear();
    } on Object {
      setState(() => _error = 'Could not save on this phone. Try again.');
      return;
    }
    if (!duplicate) {
      final avatar = ref.read(avatarRecipeProvider);
      showSaveCelebration(context, seed: avatar.seed, palette: avatar.palette);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final available =
        ref.watch(captureStoreProvider) != null &&
        ref.watch(accountIdProvider) != null;
    final confirmation = _confirmation;
    final error = _error;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Save something', style: theme.textTheme.titleMedium),
          const SizedBox(height: PinneSpacing.xs),
          Text(
            available
                ? 'Paste a link or jot a note. It is kept on this phone first.'
                : 'Saving needs the Android or iOS app.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.pinne.muted,
            ),
          ),
          const SizedBox(height: PinneSpacing.md),
          TextField(
            key: const ValueKey('paste-content'),
            controller: _content,
            enabled: available,
            onChanged: _onContentChanged,
            minLines: 1,
            maxLines: 4,
            maxLength: CaptureLimits.maxTextLength,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(
              hintText: 'Paste a link or type a note',
              counterText: '',
              suffixIcon: IconButton(
                tooltip: 'Paste',
                onPressed: available ? _paste : null,
                icon: const Icon(Icons.content_paste_rounded),
              ),
            ),
          ),
          if (!_input.isEmpty) ...[
            const SizedBox(height: PinneSpacing.sm),
            Row(
              children: [
                SourceBadge(source: _input.source),
                const SizedBox(width: PinneSpacing.sm),
                Expanded(
                  child: Text(
                    _input.suggestedTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.pinne.muted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: PinneSpacing.sm),
            TextField(
              key: const ValueKey('paste-why'),
              controller: _why,
              minLines: 1,
              maxLines: 3,
              maxLength: CaptureLimits.maxIntentionLength,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              decoration: const InputDecoration(
                hintText: 'Why did you save this? (optional)',
                counterText: '',
              ),
            ),
          ],
          const SizedBox(height: PinneSpacing.md),
          Row(
            children: [
              Expanded(
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    error ?? confirmation ?? '',
                    key: const ValueKey('paste-confirmation'),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: error != null
                          ? context.pinne.peach
                          : context.pinne.lilac,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: PinneSpacing.sm),
              // Violet: Today's lime belongs to the due-now card.
              FilledButton(
                key: const ValueKey('paste-save'),
                onPressed: available && !_input.isEmpty ? _save : null,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
