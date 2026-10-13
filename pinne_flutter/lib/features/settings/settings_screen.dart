import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/server_client.dart';
import '../../router.dart';
import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import '../auth/sign_out.dart';
import '../tour/tour_controller.dart';
import 'account_kind_provider.dart';
import 'ai_settings_provider.dart';
import 'profile_card.dart';
import '../../ui/feedback/toast.dart';

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
        const _AiOrganizingCard(),
        const SizedBox(height: PinneSpacing.md),
        const _GuidesCard(),
        if (kDebugMode)
          TextButton(
            onPressed: () => context.push(Routes.ribbonGallery),
            child: const Text('Ribbon studio'),
          ),
      ],
    );
  }
}

class _GuidesCard extends ConsumerWidget {
  const _GuidesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) => GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Guides', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: PinneSpacing.sm),
        _GuideRow(
          icon: Icons.explore_outlined,
          title: 'App tour',
          body: 'Walk through Today, step by step.',
          action: TextButton(
            key: const ValueKey('show-app-tour'),
            onPressed: () {
              context.go(Routes.today);
              ref.read(tourControllerProvider.notifier).start();
            },
            child: const Text('Show the app tour'),
          ),
        ),
        const Divider(height: PinneSpacing.lg),
        _GuideRow(
          icon: Icons.auto_stories_outlined,
          title: 'Welcome screens',
          body: 'Replay the three-screen introduction.',
          action: TextButton(
            key: const ValueKey('replay-onboarding'),
            onPressed: () => context.go('${Routes.onboarding}?replay=1'),
            child: const Text('Replay'),
          ),
        ),
      ],
    ),
  );
}

class _GuideRow extends StatelessWidget {
  const _GuideRow({
    required this.icon,
    required this.title,
    required this.body,
    required this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget action;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Icon(icon, color: context.pinne.lilac),
      ),
      const SizedBox(width: PinneSpacing.md),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            Text(body, style: TextStyle(color: context.pinne.muted)),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButtonTheme(
                data: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: context.pinne.lilac,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                child: action,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _AiOrganizingCard extends ConsumerWidget {
  const _AiOrganizingCard();

  // Shown until the server answers with its own provider's disclosure, so it
  // names no provider.
  static const fallbackDisclosure =
      "When AI organizing is on, Pinne sends the saved item's title, URL, "
      'source platform, your intention and notes, plus the names and IDs of '
      "your collections, to the server's external AI provider. It does not "
      'fetch the page. The provider and its data terms are shown here once '
      'Pinne reaches the server. Turn this off to keep organizing on this '
      'server with simple rules only.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(aiSettingsProvider);
    final value = settings.asData?.value;
    final signedIn = ref.watch(signedInProvider);
    final theme = Theme.of(context);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI organizing', style: theme.textTheme.titleMedium),
                    Text(
                      value?.available == false
                          ? 'Unavailable on this hosting plan.'
                          : signedIn
                          ? 'Suggest collections, tags and a short summary.'
                          : 'Sign in to change this setting.',
                      style: TextStyle(color: context.pinne.muted),
                    ),
                  ],
                ),
              ),
              Switch(
                key: const ValueKey('ai-organizing-toggle'),
                value: value?.enabled ?? true,
                activeTrackColor: context.pinne.violet,
                onChanged:
                    signedIn && value?.available == true && !settings.isLoading
                    ? (enabled) async {
                        try {
                          await ref
                              .read(aiSettingsProvider.notifier)
                              .setEnabled(enabled);
                        } catch (error) {
                          if (context.mounted) {
                            showErrorToast(
                              context,
                              error,
                              'Could not update AI organizing',
                            );
                          }
                        }
                      }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: PinneSpacing.sm),
          Text(
            value?.disclosure ?? fallbackDisclosure,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.pinne.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends ConsumerWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedIn = ref.watch(signedInProvider);
    final accountKind = ref.watch(accountKindProvider).asData?.value;
    final isGuest = accountKind == AccountKind.guest;
    final theme = Theme.of(context);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account', style: theme.textTheme.titleMedium),
                    Text(
                      isGuest
                          ? 'Guest account'
                          : signedIn
                          ? 'Signed in'
                          : 'Not signed in',
                      style: TextStyle(color: context.pinne.muted),
                    ),
                  ],
                ),
              ),
              signedIn
                  ? TextButton(
                      onPressed: () async {
                        final signedOut = await confirmSignOut(context, ref);
                        if (signedOut && context.mounted) {
                          context.go(Routes.signIn);
                        }
                      },
                      child: const Text('Sign out'),
                    )
                  : FilledButton(
                      onPressed: () => context.push(Routes.signIn),
                      child: const Text('Sign in'),
                    ),
            ],
          ),
          if (isGuest) ...[
            const SizedBox(height: PinneSpacing.md),
            Text(
              'Guest data belongs to this device\'s account. Signing out, '
              'clearing app data or uninstalling can make your saves '
              'unavailable.',
              key: ValueKey('guest-data-notice'),
              style: TextStyle(color: context.pinne.muted),
            ),
            const SizedBox(height: PinneSpacing.sm),
            Text(
              'Serverpod does not yet support linking a guest directly to '
              'email, so Pinne cannot safely offer an in-place upgrade yet.',
              key: ValueKey('guest-linking-unavailable'),
              style: TextStyle(color: context.pinne.muted),
            ),
          ],
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
            style: TextStyle(color: context.pinne.muted),
          ),
          const SizedBox(height: PinneSpacing.md),
          SegmentedButton<MotionPreference>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: context.pinne.violet,
              selectedForegroundColor: context.pinne.text,
              foregroundColor: context.pinne.muted,
              side: BorderSide(color: context.pinne.line),
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
