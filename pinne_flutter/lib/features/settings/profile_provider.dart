import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/library_revision.dart';
import '../../core/server_client.dart';
import '../../ui/ribbon_spirit/ribbon_recipe.dart';
import '../progress/progress_providers.dart';

/// Backwards-compatible name for the app-wide account identity.
final profileUserIdProvider = Provider<String?>((ref) {
  return ref.watch(accountIdProvider);
});

final profileEndpointProvider = Provider<EndpointProfile>(
  (ref) => ref.watch(clientProvider).profile,
);

final profileProvider = FutureProvider<PinneProfile?>((ref) async {
  if (ref.watch(profileUserIdProvider) == null) return null;
  return ref.watch(profileEndpointProvider).get();
});

final accountSummaryProvider = FutureProvider.autoDispose<AccountSummary?>((
  ref,
) async {
  if (ref.watch(profileUserIdProvider) == null) return null;
  ref.watch(libraryRevisionProvider);
  return ref.watch(clientProvider).account.summary();
});

/// This-week saves plus all-time reviewed/streak fields already calculated by
/// the progress API. Null while signed out.
final profileProgressProvider = FutureProvider.autoDispose<ProgressReport?>((
  ref,
) {
  if (ref.watch(accountIdProvider) == null) return null;
  ref.watch(libraryRevisionProvider);
  return ref
      .watch(progressApiProvider)
      .report(progressQuery(ProgressPeriod.thisWeek));
});

final avatarRecipeProvider = Provider<({int seed, int palette})>((ref) {
  final userId = ref.watch(profileUserIdProvider);
  final profile = ref.watch(profileProvider).asData?.value;
  return (
    seed:
        profile?.avatarSeed ??
        RibbonRecipe.seedForUser(userId ?? 'pinne-guest'),
    palette: profile?.avatarPalette ?? 0,
  );
});

/// Who is signed in, as Today and Profile name them.
@immutable
class AccountIdentity {
  const AccountIdentity({required this.name, this.type});

  /// The chosen display name, else the email's local part. Only a guest
  /// account (or no account) is called "Guest".
  factory AccountIdentity.of(PinneProfile? profile, AccountSummary? account) {
    final chosen = profile?.displayName.trim();
    final local = account?.email?.split('@').first.trim();
    return AccountIdentity(
      name: chosen != null && chosen.isNotEmpty
          ? chosen
          : local != null && local.isNotEmpty
          ? local
          : switch (account?.type) {
              ProfileAccountType.guest || null => 'Guest',
              _ => 'Pinne reader',
            },
      type: account?.type,
    );
  }

  final String name;

  /// Null while signed out.
  final ProfileAccountType? type;
}

/// Rebuilds with the account id, so a switch shows the new account's name
/// (or a loading state), never the previous one's.
final accountIdentityProvider = FutureProvider.autoDispose<AccountIdentity>((
  ref,
) async {
  final profile = ref.watch(profileProvider.future);
  final account = ref.watch(accountSummaryProvider.future);
  return AccountIdentity.of(await profile, await account);
});
