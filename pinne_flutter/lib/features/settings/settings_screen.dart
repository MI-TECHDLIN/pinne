import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/server_client.dart';
import '../../router.dart';
import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import 'profile_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PinnePage(
      headline: 'Settings',
      subtitle: 'Reminders, AI and privacy controls will live here.',
      children: [
        const ProfileCard(),
        const SizedBox(height: PinneSpacing.md),
        const _AccountCard(),
        const SizedBox(height: PinneSpacing.md),
        const _MotionCard(),
        const SizedBox(height: PinneSpacing.md),
        const ServerHealthCard(),
        if (kDebugMode)
          TextButton(
            onPressed: () => context.push(Routes.ribbonGallery),
            child: const Text('Ribbon studio'),
          ),
      ],
    );
  }
}

class _AccountCard extends ConsumerWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedIn = ref.watch(signedInProvider);
    final theme = Theme.of(context);
    return GlassCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account', style: theme.textTheme.titleMedium),
                Text(
                  signedIn ? 'Signed in' : 'Not signed in',
                  style: const TextStyle(color: PinneColors.muted),
                ),
              ],
            ),
          ),
          signedIn
              ? TextButton(
                  onPressed: () =>
                      ref.read(signedInProvider.notifier).signOut(),
                  child: const Text('Sign out'),
                )
              : FilledButton(
                  onPressed: () => context.push(Routes.signIn),
                  child: const Text('Sign in'),
                ),
        ],
      ),
    );
  }
}

class _MotionCard extends ConsumerWidget {
  const _MotionCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preference = ref.watch(motionPreferenceProvider);
    final reduced = reduceMotionOf(context);
    final theme = Theme.of(context);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Motion', style: theme.textTheme.titleMedium),
          Text(
            reduced ? 'Animations are reduced.' : 'Animations are on.',
            style: const TextStyle(color: PinneColors.muted),
          ),
          const SizedBox(height: PinneSpacing.md),
          SegmentedButton<MotionPreference>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: PinneColors.violet,
              selectedForegroundColor: PinneColors.text,
              foregroundColor: PinneColors.muted,
              side: const BorderSide(color: PinneColors.line),
            ),
            segments: const [
              ButtonSegment(
                value: MotionPreference.system,
                label: Text('System'),
              ),
              ButtonSegment(
                value: MotionPreference.reduced,
                label: Text('Reduce'),
              ),
              ButtonSegment(value: MotionPreference.full, label: Text('Full')),
            ],
            selected: {preference},
            onSelectionChanged: (selection) => ref
                .read(motionPreferenceProvider.notifier)
                .set(selection.single),
          ),
        ],
      ),
    );
  }
}

/// Shows whether the configured server answers its public health check.
class ServerHealthCard extends ConsumerWidget {
  const ServerHealthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(serverHealthProvider);
    final theme = Theme.of(context);
    final (label, detail, colour) = switch (health) {
      AsyncData(:final value) when value.ok && value.databaseOk => (
        'Server online',
        'API ${value.version}',
        PinneColors.mint,
      ),
      AsyncData(:final value) => (
        'Server degraded',
        value.databaseOk ? 'API ${value.version}' : 'Database unreachable',
        PinneColors.peach,
      ),
      AsyncError() => (
        'Server unreachable',
        'Is the server running?',
        PinneColors.pink,
      ),
      _ => ('Checking server…', '', PinneColors.muted),
    };
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: colour),
              const SizedBox(width: PinneSpacing.sm),
              Expanded(child: Text(label, style: theme.textTheme.titleMedium)),
              TextButton(
                onPressed: () => ref.invalidate(serverHealthProvider),
                child: const Text('Recheck'),
              ),
            ],
          ),
          if (detail.isNotEmpty)
            Text(detail, style: const TextStyle(color: PinneColors.muted)),
          Text(
            ref.watch(serverUrlProvider),
            style: theme.textTheme.bodySmall?.copyWith(
              color: PinneColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
