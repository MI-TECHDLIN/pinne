import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/capture/open_capture_store_io.dart';
import 'package:pinne_flutter/features/capture/outbox_sync.dart';
import 'package:sqlite3/sqlite3.dart';

import 'fake_capture_server.dart';

void main() {
  late CaptureStore store;
  late FakeCaptureServer server;
  late DateTime now;
  var signedIn = true;
  late OutboxSync sync;

  OutboxSync newSync(CaptureStore store) => OutboxSync(
    store: store,
    api: server,
    canSync: () => signedIn,
    clock: () => now,
    jitter: () => 0.5,
  );

  setUp(() {
    store = CaptureStore(sqlite3.openInMemory());
    server = FakeCaptureServer();
    now = DateTime.utc(2026, 10, 6, 12);
    signedIn = true;
    sync = newSync(store);
  });

  tearDown(() {
    sync.dispose();
    store.close();
  });

  LocalCapture save(String text, {String? intention}) =>
      store.save(parseCaptureInput(text), intention: intention, now: now);

  test('sends pending captures in order and empties the outbox', () async {
    final first = save('https://x.com/a/status/1');
    final second = save('Note to self');

    expect(await sync.drain(), 2);

    expect(server.calls.map((d) => d.clientItemId.uuid), [
      first.clientItemId,
      second.clientItemId,
    ]);
    expect(store.outboxLength(), 0);
    expect(
      store.captures().map((c) => c.syncState),
      everyElement(CaptureSyncState.synced),
    );
  });

  test(
    'offline: keeps the operation and retries with growing backoff',
    () async {
      final saved = save('https://example.com/a');
      server.offline = true;

      expect(await sync.drain(), 0);
      expect(store.outboxLength(), 1);
      expect(store.capture(saved.clientItemId)!.attempts, 1);
      // jitter 0.5 → 75% of the 2 s base.
      expect(store.nextDueAt(), now.add(const Duration(milliseconds: 1500)));

      // Not due yet: nothing is sent.
      await sync.drain();
      expect(server.calls, hasLength(1));

      now = now.add(const Duration(seconds: 2));
      await sync.drain();
      expect(server.calls, hasLength(2));
      expect(store.nextDueAt(), now.add(const Duration(seconds: 3)));

      server.comeOnline();
      now = now.add(const Duration(seconds: 4));
      expect(await sync.drain(), 1);
      expect(store.outboxLength(), 0);
    },
  );

  test('backoff is capped', () {
    const policy = BackoffPolicy();
    expect(policy.delay(1, 0), const Duration(seconds: 1));
    expect(policy.delay(3, 1), const Duration(seconds: 8));
    expect(policy.delay(40, 1), const Duration(minutes: 10));
  });

  test('a lost response is retried under the same operation id', () async {
    final saved = save('https://youtu.be/dQw4w9WgXcQ', intention: 'motion');
    server.loseNextResponse = true;

    await sync.drain();
    expect(store.outboxLength(), 1, reason: 'not confirmed, so not removed');

    now = now.add(const Duration(minutes: 1));
    await sync.drain();

    expect(server.calls, hasLength(2));
    expect(server.calls[0].operationId, server.calls[1].operationId);
    expect(server.calls[0].toJson(), server.calls[1].toJson());
    expect(server.items, hasLength(1), reason: 'one canonical item');
    final synced = store.capture(saved.clientItemId)!;
    expect(synced.syncState, CaptureSyncState.synced);
    expect(synced.duplicate, isFalse);
  });

  test('a repeat with other tracking params syncs as a duplicate', () async {
    save('https://youtu.be/dQw4w9WgXcQ?si=one');
    final repeat = save(
      'https://www.youtube.com/watch?v=dQw4w9WgXcQ&utm_source=x&t=42',
    );
    await sync.drain();
    expect(server.items, hasLength(1));
    expect(store.capture(repeat.clientItemId)!.duplicate, isTrue);
  });

  test('signed out: captures wait and sync after sign-in', () async {
    signedIn = false;
    save('https://example.com/a');

    expect(await sync.drain(), 0);
    expect(server.calls, isEmpty);
    expect(store.outboxLength(), 1);

    signedIn = true;
    expect(await sync.drain(), 1);
    expect(store.outboxLength(), 0);
  });

  test(
    'an expired session stops the pass without counting an attempt',
    () async {
      final saved = save('https://example.com/a');
      server.rejectNext = ServerpodClientUnauthorized();

      await sync.drain();
      expect(store.outboxLength(), 1);
      expect(store.capture(saved.clientItemId)!.attempts, 0);
      expect(
        store.capture(saved.clientItemId)!.syncState,
        CaptureSyncState.pending,
      );
    },
  );

  test(
    'a refused capture is parked, the rest continue, retry is manual',
    () async {
      final refused = save('https://example.com/refused');
      final fine = save('https://example.com/fine');
      server.rejectNext = ValidationException(message: 'Too many collections.');

      expect(await sync.drain(), 1);

      final parked = store.capture(refused.clientItemId)!;
      expect(parked.syncState, CaptureSyncState.failed);
      expect(parked.lastError, 'Too many collections.');
      expect(
        store.capture(fine.clientItemId)!.syncState,
        CaptureSyncState.synced,
      );
      expect(store.outboxLength(), 1, reason: 'kept until the server confirms');

      await sync.drain();
      expect(server.calls, hasLength(2), reason: 'not retried by itself');

      store.retry(refused.clientItemId);
      expect(await sync.drain(), 1);
      expect(store.outboxLength(), 0);
    },
  );

  test('concurrent drains send each operation once', () async {
    save('https://example.com/a');
    save('https://example.com/b');
    server.gate = Completer<void>();

    final first = sync.drain();
    final second = sync.drain();
    server.gate!.complete();
    await Future.wait([first, second]);

    expect(server.calls, hasLength(2));
    expect(store.outboxLength(), 0);
  });

  test('held captures are not sent', () async {
    store.save(
      parseCaptureInput('https://example.com/a'),
      hold: true,
      now: now,
    );
    expect(await sync.drain(), 0);
    expect(server.calls, isEmpty);
  });

  test('after a kill and restart the capture syncs exactly once', () async {
    final dir = Directory.systemTemp.createTempSync('pinne_sync_test');
    addTearDown(() => dir.deleteSync(recursive: true));
    final path = '${dir.path}/captures.sqlite';

    // Offline capture, acknowledged, then the app dies before syncing.
    final beforeKill = openCaptureStoreAt(path);
    server.offline = true;
    final saved = beforeKill.save(
      parseCaptureInput('https://x.com/a/status/9'),
    );
    final dying = newSync(beforeKill);
    await dying.drain();
    dying.dispose();

    // A new process opens the same file and the network is back.
    final afterRestart = openCaptureStoreAt(path);
    addTearDown(afterRestart.close);
    final revived = newSync(afterRestart);
    addTearDown(revived.dispose);
    server.comeOnline();
    now = now.add(const Duration(minutes: 5));

    expect(await revived.drain(), 1);
    expect(await revived.drain(), 0);
    expect(server.items, hasLength(1));
    expect(
      afterRestart.capture(saved.clientItemId)!.syncState,
      CaptureSyncState.synced,
    );
    beforeKill.close();
  });
}
