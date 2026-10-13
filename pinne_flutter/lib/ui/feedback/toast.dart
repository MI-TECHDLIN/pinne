import 'package:flutter/material.dart';

import '../../theme/pinne_tokens.dart';
import 'friendly_error.dart';

enum ToastKind { success, info, error }

/// Pinne's floating toast: a dark glass pill with a tinted icon, instead of
/// the default grey bar. Rides on [ScaffoldMessenger] so timing, swipe to
/// dismiss and screen-reader announcements behave like any snack bar.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showPinneToast(
  BuildContext context,
  String message, {
  ToastKind kind = ToastKind.info,
  String? actionLabel,
  VoidCallback? onAction,
  Duration? duration,
}) {
  final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
  return messenger.showSnackBar(
    pinneToast(
      message,
      kind: kind,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    ),
  );
}

/// A toast for a failed action. [failedAction] is a short past-tense phrase
/// such as "Could not archive it"; the cause comes from [FriendlyError].
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorToast(
  BuildContext context,
  Object? error,
  String failedAction, {
  String? actionLabel,
  VoidCallback? onAction,
}) => showPinneToast(
  context,
  FriendlyError.from(error).toast(failedAction),
  kind: ToastKind.error,
  actionLabel: actionLabel,
  onAction: onAction,
);

/// The [SnackBar] behind [showPinneToast], for code that already holds a
/// [ScaffoldMessengerState].
SnackBar pinneToast(
  String message, {
  ToastKind kind = ToastKind.info,
  String? actionLabel,
  VoidCallback? onAction,
  Duration? duration,
}) => SnackBar(
  key: ValueKey('pinne-toast-${kind.name}'),
  behavior: SnackBarBehavior.floating,
  backgroundColor: Colors.transparent,
  elevation: 0,
  padding: EdgeInsets.zero,
  margin: const EdgeInsets.fromLTRB(
    PinneSpacing.gutter,
    0,
    PinneSpacing.gutter,
    PinneSpacing.sm,
  ),
  duration:
      duration ??
      (kind == ToastKind.error || actionLabel != null
          ? const Duration(seconds: 6)
          : const Duration(seconds: 4)),
  dismissDirection: DismissDirection.horizontal,
  content: PinneToastBody(
    message: message,
    kind: kind,
    actionLabel: actionLabel,
    onAction: onAction,
  ),
);

class PinneToastBody extends StatelessWidget {
  const PinneToastBody({
    super.key,
    required this.message,
    required this.kind,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final ToastKind kind;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final (icon, tint, label) = switch (kind) {
      ToastKind.success => (Icons.check_rounded, context.pinne.success, 'Done'),
      ToastKind.info => (
        Icons.info_outline_rounded,
        context.pinne.lilac,
        'Note',
      ),
      ToastKind.error => (
        Icons.priority_high_rounded,
        context.pinne.error,
        'Problem',
      ),
    };
    final action = actionLabel;
    return Semantics(
      liveRegion: true,
      label: '$label: $message',
      excludeSemantics: action == null,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          PinneSpacing.md,
          PinneSpacing.md,
          PinneSpacing.sm,
          PinneSpacing.md,
        ),
        decoration: BoxDecoration(
          color: context.pinne.cardRaised,
          borderRadius: BorderRadius.circular(PinneRadii.tile),
          border: Border.all(color: tint.withValues(alpha: .35)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? context.pinne.shadow
                  : const Color(0x99000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: context.pinne.ink),
            ),
            const SizedBox(width: PinneSpacing.md),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.pinne.text,
                  height: 1.3,
                ),
              ),
            ),
            if (action != null)
              TextButton(
                key: const ValueKey('pinne-toast-action'),
                onPressed: () {
                  ScaffoldMessenger.maybeOf(
                    context,
                  )?.hideCurrentSnackBar(reason: SnackBarClosedReason.action);
                  onAction?.call();
                },
                child: Text(action),
              )
            else
              const SizedBox(width: PinneSpacing.sm),
          ],
        ),
      ),
    );
  }
}
