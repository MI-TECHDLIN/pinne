import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/server_client.dart';
import '../../router.dart';
import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/feedback/friendly_error.dart';
import '../../ui/ribbon_spirit/ribbon_spirit.dart';
import 'profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final account = ref.watch(accountSummaryProvider);
    final progress = ref.watch(profileProgressProvider);
    final loading =
        profile.isLoading || account.isLoading || progress.isLoading;
    final error = profile.error ?? account.error ?? progress.error;

    return Scaffold(
      body: PinnePage(
        leading: IconButton.filledTonal(
          tooltip: 'Back',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.today),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        headline: 'Your',
        headlineBold: 'profile',
        subtitle: 'Your spirit, account and progress in one place.',
        children: [
          if (loading)
            const _ProfileSkeleton()
          else if (error != null)
            _ProfileError(
              error: error,
              onRetry: () {
                ref
                  ..invalidate(profileProvider)
                  ..invalidate(accountSummaryProvider)
                  ..invalidate(profileProgressProvider);
              },
            )
          else ...[
            _ProfileHero(
              profile: profile.value,
              account: account.value,
            ),
            const SizedBox(height: PinneSpacing.md),
            if (progress.value case final report?) _StatsCard(report: report),
            if (progress.value != null) const SizedBox(height: PinneSpacing.md),
            if (account.value?.type == ProfileAccountType.guest ||
                account.value == null)
              const _GuestAccountCard()
            else
              _SignedInAccountCard(account: account.value!),
          ],
        ],
      ),
    );
  }
}

class _ProfileHero extends ConsumerWidget {
  const _ProfileHero({required this.profile, required this.account});

  final PinneProfile? profile;
  final AccountSummary? account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarRecipeProvider);
    final type = account?.type;
    final isGuest = type == null || type == ProfileAccountType.guest;
    final name = profile?.displayName.trim();
    final displayName = name == null || name.isEmpty
        ? (isGuest ? 'Guest' : 'Pinne reader')
        : name;
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: PinneColors.cardRaised,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: RibbonSpirit(
                seed: avatar.seed,
                palette: avatar.palette,
                size: 96,
              ),
            ),
          ),
          const SizedBox(width: PinneSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: PinneSpacing.xs),
                _AccountBadge(type: type),
                if (account?.email case final email?) ...[
                  const SizedBox(height: PinneSpacing.sm),
                  Text(
                    email,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: PinneColors.muted),
                  ),
                ],
                if (account case final details?) ...[
                  const SizedBox(height: PinneSpacing.xs),
                  Text(
                    'Member since ${_dateLabel(details.memberSince.toLocal())}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: PinneColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountBadge extends StatelessWidget {
  const _AccountBadge({required this.type});

  final ProfileAccountType? type;

  @override
  Widget build(BuildContext context) {
    final label = switch (type) {
      ProfileAccountType.email => 'EMAIL',
      ProfileAccountType.demo => 'DEMO',
      ProfileAccountType.guest || null => 'GUEST',
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PinneColors.violet,
        borderRadius: BorderRadius.circular(PinneRadii.chip),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: PinneColors.text,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.report});

  final ProgressReport report;

  @override
  Widget build(BuildContext context) {
    final stats = <({String label, String value, Color color})>[
      (
        label: 'Saved this week',
        value: '${report.savedCount}',
        color: PinneColors.peach,
      ),
      (
        label: 'Reviewed',
        value: '${report.totalReviewedCount}',
        color: PinneColors.mint,
      ),
      (
        label: 'Weekly goal',
        value:
            '${report.weeklyGoal.reviewDayCount}/${report.weeklyGoal.goalDays} days',
        color: PinneColors.sky,
      ),
      if (report.streakEnabled)
        (
          label: 'Current streak',
          value: '${report.currentStreakDays ?? 0} days',
          color: PinneColors.pink,
        ),
    ];
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your progress', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: PinneSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - PinneSpacing.sm) / 2;
              return Wrap(
                spacing: PinneSpacing.sm,
                runSpacing: PinneSpacing.sm,
                children: [
                  for (final stat in stats)
                    SizedBox(
                      width: width,
                      child: _StatTile(
                        label: stat.label,
                        value: stat.value,
                        color: stat.color,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 88),
    padding: const EdgeInsets.all(PinneSpacing.md),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(PinneRadii.tile),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: PinneColors.ink,
          ),
        ),
        Text(
          label,
          maxLines: 2,
          style: const TextStyle(color: PinneColors.ink),
        ),
      ],
    ),
  );
}

class _GuestAccountCard extends StatelessWidget {
  const _GuestAccountCard();

  @override
  Widget build(BuildContext context) => GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.shield_outlined, color: PinneColors.lilac),
            const SizedBox(width: PinneSpacing.sm),
            Expanded(
              child: Text(
                'Keep your account available',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: PinneSpacing.sm),
        const Text(
          'You are using Pinne as a guest. This version of Serverpod cannot '
          'link a guest to email, so signing in or creating an account starts '
          'a separate account. Your current guest saves stay with this guest '
          'account and do not transfer.',
          key: ValueKey('profile-guest-separate-account-notice'),
          style: TextStyle(color: PinneColors.muted, height: 1.4),
        ),
        const SizedBox(height: PinneSpacing.md),
        Wrap(
          spacing: PinneSpacing.sm,
          runSpacing: PinneSpacing.sm,
          children: [
            FilledButton(
              key: const ValueKey('profile-sign-in'),
              onPressed: () => context.push('${Routes.signIn}?mode=login'),
              child: const Text('Sign in'),
            ),
            OutlinedButton(
              key: const ValueKey('profile-create-account'),
              onPressed: () => context.push('${Routes.signIn}?mode=create'),
              child: const Text('Create account'),
            ),
          ],
        ),
      ],
    ),
  );
}

class _SignedInAccountCard extends ConsumerWidget {
  const _SignedInAccountCard({required this.account});

  final AccountSummary account;

  @override
  Widget build(BuildContext context, WidgetRef ref) => GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: PinneSpacing.xs),
        const Text(
          'Your saves are attached to this account.',
          style: TextStyle(color: PinneColors.muted),
        ),
        const SizedBox(height: PinneSpacing.md),
        OutlinedButton.icon(
          key: const ValueKey('profile-sign-out'),
          onPressed: () => _confirmSignOut(context, ref),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Sign out'),
        ),
      ],
    ),
  );

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'Your saves stay with this account. Sign in again to see them.',
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
    if (confirmed != true) return;
    await ref.read(signedInProvider.notifier).signOut();
    if (context.mounted) context.go(Routes.signIn);
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey('profile-skeleton'),
    children: [
      for (final height in [144.0, 188.0, 150.0]) ...[
        Container(
          height: height,
          decoration: BoxDecoration(
            color: PinneColors.glass,
            borderRadius: BorderRadius.circular(PinneRadii.card),
            border: Border.all(color: PinneColors.line),
          ),
          padding: const EdgeInsets.all(PinneSpacing.lg),
          alignment: Alignment.topLeft,
          child: Container(
            width: height,
            height: 16,
            decoration: BoxDecoration(
              color: PinneColors.cardRaised,
              borderRadius: BorderRadius.circular(PinneRadii.chip),
            ),
          ),
        ),
        const SizedBox(height: PinneSpacing.md),
      ],
    ],
  );
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final friendly = FriendlyError.from(error);
    return GlassCard(
      child: Column(
        children: [
          Icon(friendly.icon, color: PinneColors.lilac, size: 36),
          const SizedBox(height: PinneSpacing.sm),
          Text(friendly.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: PinneSpacing.xs),
          Text(
            friendly.hint,
            textAlign: TextAlign.center,
            style: const TextStyle(color: PinneColors.muted),
          ),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}

String _dateLabel(DateTime date) =>
    '${_months[date.month - 1]} ${date.day}, ${date.year}';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
