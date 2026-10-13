import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/server_client.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/pinne_loading.dart';
import '../capture/capture_providers.dart';

/// Warns about this account's durable pending saves, then signs out.
Future<bool> confirmSignOut(BuildContext context, WidgetRef ref) async {
  final accountId = ref.read(accountIdProvider);
  if (accountId == null) return true;
  final count =
      ref.read(captureStoreProvider)?.outboxLength(accountId: accountId) ?? 0;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Sign out?'),
      content: Text(
        count == 0
            ? 'Your saves stay with this account. Sign in again to see them.'
            : '$count ${count == 1 ? 'save has' : 'saves have'} not synced '
                  'yet — ${count == 1 ? 'it stays' : 'they stay'} on this '
                  'phone and ${count == 1 ? 'syncs' : 'sync'} next time you '
                  'sign in to this account.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const ValueKey('confirm-sign-out'),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Sign out'),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;
  if (!context.mounted) return false;
  final navigator = Navigator.of(context, rootNavigator: true);
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: AlertDialog(
          key: ValueKey('signing-out'),
          content: Row(
            children: [
              PinneBrandedLoader(size: 28, label: 'Signing out'),
              SizedBox(width: PinneSpacing.md),
              Expanded(child: Text('Signing out…')),
            ],
          ),
        ),
      ),
    ),
  );
  try {
    await ref.read(signedInProvider.notifier).signOut();
  } finally {
    navigator.pop();
  }
  return true;
}
