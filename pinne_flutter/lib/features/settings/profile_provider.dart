import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../core/server_client.dart';
import '../../ui/ribbon_spirit/ribbon_recipe.dart';

/// Identity, rather than a signed-in boolean, invalidates cached profiles on
/// account switches (including a switch directly between authenticated users).
final profileUserIdProvider = NotifierProvider<ProfileUserId, String?>(
  ProfileUserId.new,
);

class ProfileUserId extends Notifier<String?> {
  @override
  String? build() {
    if (!ref.watch(signedInProvider)) return null;
    final auth = ref.watch(clientProvider).auth;
    void sync() => state = auth.authInfo?.authUserId.toString();
    auth.authInfoListenable.addListener(sync);
    ref.onDispose(() => auth.authInfoListenable.removeListener(sync));
    return auth.authInfo?.authUserId.toString();
  }
}

final profileEndpointProvider = Provider<EndpointProfile>(
  (ref) => ref.watch(clientProvider).profile,
);

final profileProvider = FutureProvider<PinneProfile?>((ref) async {
  if (ref.watch(profileUserIdProvider) == null) return null;
  return ref.watch(profileEndpointProvider).get();
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
