import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/server_client.dart';
import 'capture_store.dart';
import 'outbox_sync.dart';

/// The local capture database. Overridden in `main.dart`; null where there
/// is no durable store (the web build), in which case capture is hidden.
final captureStoreProvider = Provider<CaptureStore?>(
  (ref) => throw UnimplementedError('captureStoreProvider must be overridden'),
);

final captureApiProvider = Provider<CaptureApi>(
  (ref) => ServerCaptureApi(ref.watch(clientProvider)),
);

/// The outbox sender, with its triggers: start-up, sign-in, the app coming
/// back to the foreground and the connection coming back. Retries in
/// between are timed by the sender's backoff.
final outboxSyncProvider = Provider<OutboxSync?>((ref) {
  final store = ref.watch(captureStoreProvider);
  if (store == null) return null;
  final sync = OutboxSync(
    store: store,
    api: ref.watch(captureApiProvider),
    canSync: () => ref.read(signedInProvider),
  );
  void kick() => unawaited(sync.drain());

  ref.listen<bool>(signedInProvider, (previous, signedIn) {
    if (signedIn) kick();
  });
  final lifecycle = AppLifecycleListener(
    onResume: () {
      // The share sheet may have saved from its own engine meanwhile.
      store.notifyExternalChange();
      kick();
    },
  );
  final stopWatching = ref.watch(captureApiProvider).watchConnectivity(kick);
  ref.onDispose(() {
    stopWatching();
    lifecycle.dispose();
    sync.dispose();
  });
  scheduleMicrotask(kick);
  return sync;
});

/// Every local capture, newest first, refreshed after each write.
final capturesProvider = StreamProvider<List<LocalCapture>>((ref) async* {
  final store = ref.watch(captureStoreProvider);
  if (store == null) {
    yield const [];
    return;
  }
  yield store.captures();
  await for (final _ in store.changes) {
    yield store.captures();
  }
});
