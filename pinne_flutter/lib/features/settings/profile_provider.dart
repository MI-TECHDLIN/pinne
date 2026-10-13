import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

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
  return ref.watch(clientProvider).account.summary();
});

/// This-week saves plus all-time reviewed/streak fields already calculated by
/// the progress API. Null while signed out.
final profileProgressProvider = FutureProvider.autoDispose<ProgressReport?>((
  ref,
) {
  if (ref.watch(accountIdProvider) == null) return null;
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
