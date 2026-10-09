import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Server URL resolution, in order: `--dart-define=SERVER_URL=...`, then
/// `apiUrl` in `assets/config.json`, then `http://localhost:8080/`.
///
/// On a physical device use your computer's LAN address, not localhost.
Future<String> resolveServerUrl() => getServerUrl();

/// Google sign-in is only offered when the OAuth client ids are provided:
/// `--dart-define=GOOGLE_CLIENT_ID=...` and
/// `--dart-define=GOOGLE_SERVER_CLIENT_ID=...`.
const googleSignInConfigured = bool.hasEnvironment('GOOGLE_CLIENT_ID');

/// Creates the generated Serverpod client with auth wired in.
Future<Client> createServerClient(String serverUrl) async {
  final client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  unawaited(client.auth.initialize());
  if (googleSignInConfigured && !kIsWeb) {
    unawaited(client.auth.initializeGoogleSignIn());
  }
  return client;
}

/// The configured server URL. Overridden in `main.dart`.
final serverUrlProvider = Provider<String>(
  (ref) => throw UnimplementedError('serverUrlProvider must be overridden'),
);

/// The generated Serverpod client. Overridden in `main.dart`.
final clientProvider = Provider<Client>(
  (ref) => throw UnimplementedError('clientProvider must be overridden'),
);

/// Public server health, used by Settings. Refresh with `ref.invalidate`.
final serverHealthProvider = FutureProvider.autoDispose<ServerHealth>(
  (ref) => ref.watch(clientProvider).health.check(),
);

/// Whether this deployment can deliver email verification and reset codes.
final emailDeliveryAvailableProvider = FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(clientProvider).health.emailDeliveryAvailable(),
);

/// Creates a normal server-side auth user whose session is held by this app.
/// Kept injectable so the sign-in path can be exercised without a live server.
final guestSignInActionProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final client = ref.read(clientProvider);
    final authSuccess = await client.anonymousIdp.login();
    await client.auth.updateSignedInUser(authSuccess);
  };
});

/// Whether a user is signed in, kept in sync with the client's auth state.
final signedInProvider = NotifierProvider<SignedInNotifier, bool>(
  SignedInNotifier.new,
);

class SignedInNotifier extends Notifier<bool> {
  @override
  bool build() {
    final auth = ref.watch(clientProvider).auth;
    void sync() => state = auth.isAuthenticated;
    auth.authInfoListenable.addListener(sync);
    ref.onDispose(() => auth.authInfoListenable.removeListener(sync));
    return auth.isAuthenticated;
  }

  Future<void> signOut() => ref.read(clientProvider).auth.signOutDevice();
}
