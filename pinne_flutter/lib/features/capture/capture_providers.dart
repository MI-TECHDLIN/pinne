import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/library_revision.dart';
import '../../core/server_client.dart';
import 'capture_store.dart';
import 'outbox_sync.dart';

/// The local capture database. Overridden in `main.dart`; null where there
/// is no durable store (the web build), in which case capture is hidden.
final captureStoreProvider = Provider<CaptureStore?>(
  (ref) => null,
);

final captureApiProvider = Provider<CaptureApi>(
  (ref) => ServerCaptureApi(ref.watch(clientProvider)),
);

/// The outbox sender, with its triggers: start-up, sign-in, the app coming
/// back to the foreground and the connection coming back. Retries in
/// between are timed by the sender's backoff.
final outboxSyncProvider = Provider<OutboxSync?>((ref) {
  final store = ref.watch(captureStoreProvider);
  final accountId = ref.watch(accountIdProvider);
  if (store == null || accountId == null) return null;
  store.claimLegacyCaptures(accountId);
  final sync = OutboxSync(
    store: store,
    api: ref.watch(captureApiProvider),
    accountId: accountId,
    canSync: () => ref.read(signedInProvider),
    onConfirmed: () => ref.read(libraryRevisionProvider.notifier).bump(),
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
  final accountId = ref.watch(accountIdProvider);
  if (store == null || accountId == null) {
    yield const [];
    return;
  }
  store.claimLegacyCaptures(accountId);
  yield store.captures(accountId: accountId);
  await for (final _ in store.changes) {
    yield store.captures(accountId: accountId);
  }
});

/// Server-side preview state overlaid on the durable local saves. Polling only
/// continues while preview jobs are pending or processing.
final savedItemsProvider = StreamProvider.autoDispose<List<Item>>((ref) async* {
  final accountId = ref.watch(accountIdProvider);
  ref.watch(capturesProvider);
  ref.watch(libraryRevisionProvider);
  if (accountId == null) {
    yield const [];
    return;
  }
  for (var poll = 0; poll < 8; poll++) {
    final items = await ref.watch(clientProvider).item.list(limit: 100);
    yield items;
    final working = items.any(
      (item) =>
          item.enrichmentState == EnrichmentState.pending ||
          item.enrichmentState == EnrichmentState.processing,
    );
    if (!working) return;
    await Future<void>.delayed(const Duration(seconds: 1));
  }
});
