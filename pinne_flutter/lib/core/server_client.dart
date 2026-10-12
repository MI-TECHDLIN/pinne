import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Server URL resolution, in order: `--dart-define=SERVER_URL=...`, a
/// Serverpod Cloud API URL derived from its default web host, then `apiUrl` in
/// `assets/config.json`, then `http://localhost:8080/`.
///
/// On a physical device use your computer's LAN address, not localhost.
Future<String> resolveServerUrl() async {
  const definedUrl = String.fromEnvironment('SERVER_URL');
  if (definedUrl.isNotEmpty) return definedUrl;

  if (kIsWeb) {
    final cloudUrl = serverpodCloudApiUrl(Uri.base);
    if (cloudUrl != null) return cloudUrl;
  }

  return getServerUrl();
}

/// Returns the matching API host for a default Serverpod Cloud web URL.
///
/// Custom domains should use `SERVER_URL` because their API hostname cannot be
/// inferred from the page URL.
@visibleForTesting
String? serverpodCloudApiUrl(Uri pageUri) {
  const cloudWebSuffix = '.serverpod.space';
  final host = pageUri.host.toLowerCase();
  if (!host.endsWith(cloudWebSuffix)) return null;

  final projectId = host.substring(0, host.length - cloudWebSuffix.length);
  if (projectId.isEmpty || projectId.contains('.')) return null;
  final scheme = pageUri.scheme == 'http' ? 'http' : 'https';
  return '$scheme://$projectId.api.serverpod.space/';
}

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
