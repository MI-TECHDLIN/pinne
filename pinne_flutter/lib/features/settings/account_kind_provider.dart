import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/server_client.dart';
import 'profile_provider.dart';

enum AccountKind { signedOut, guest, registered }

/// Distinguishes a device-bound anonymous user from a recoverable account.
final accountKindProvider = FutureProvider.autoDispose<AccountKind>((
  ref,
) async {
  if (ref.watch(profileUserIdProvider) == null) return AccountKind.signedOut;

  final isGuest = await ref.watch(clientProvider).account.isGuest();
  return isGuest ? AccountKind.guest : AccountKind.registered;
});
