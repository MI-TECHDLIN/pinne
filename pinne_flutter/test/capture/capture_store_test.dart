import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/capture/open_capture_store_io.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  late Directory dir;
  late String path;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('pinne_store_test');
    path = '${dir.path}/captures.sqlite';
  });

  tearDown(() => dir.deleteSync(recursive: true));

  group('durable before acknowledgement', () {
    test('a capture survives the app being killed right after save', () {
      final app = openCaptureStoreAt(path);
      final saved = app.save(
        parseCaptureInput('https://youtu.be/dQw4w9WgXcQ?si=share'),
        intention: 'Watch the motion part',
      );
      // `save` returning is the acknowledgement. Simulate a kill at that
      // moment: snapshot exactly what is on disk while the connection is
      // still open (never closed or checkpointed), then start from the
      // snapshot as a fresh process would.
      final restartedPath = '${dir.path}/after_kill.sqlite';
      for (final suffix in ['', '-wal']) {
        final file = File('$path$suffix');
        if (file.existsSync()) file.copySync('$restartedPath$suffix');
      }
      final restarted = openCaptureStoreAt(restartedPath);

      final survived = restarted.capture(saved.clientItemId);
      expect(survived, isNotNull);
      expect(survived!.source, CaptureSource.youtube);
      expect(survived.sourceItemId, 'dQw4w9WgXcQ');
      expect(survived.intention, 'Watch the motion part');
      expect(survived.syncState, CaptureSyncState.pending);

      final queued = restarted.dueOperations(DateTime.now());
      expect(queued, hasLength(1));
      expect(queued.single.operationId, saved.operationId);
      expect(queued.single.draft.clientItemId.uuid, saved.clientItemId);
      restarted.close();
      app.close();
    });

    test('the item and its outbox operation commit together', () {
      final db = sqlite3.open(path);
      CaptureStore.configureDurable(db);
      final store = CaptureStore(db);
      // A failing second insert must leave neither row behind.
      db.execute(
        "CREATE TRIGGER fail_outbox BEFORE INSERT ON outbox "
        "BEGIN SELECT RAISE(ABORT, 'disk full'); END",
      );
      expect(
        () => store.save(parseCaptureInput('https://example.com/a')),
        throwsA(isA<SqliteException>()),
      );
      expect(store.captures(), isEmpty);
      expect(store.outboxLength(), 0);
      store.close();
    });

    test('the database is configured for durable commits', () {
      final store = openCaptureStoreAt(path);
      store.close();
      final db = sqlite3.open(path);
      expect(db.select('PRAGMA journal_mode').first.columnAt(0), 'wal');
      db.close();
    });
  });

  test('shared capture enums match the generated client enums', () {
    final platforms = SourcePlatform.values.map((p) => p.name).toSet();
    final types = ContentType.values.map((t) => t.name).toSet();
    for (final source in CaptureSource.values) {
      expect(platforms, contains(source.name));
    }
    for (final type in CaptureContentType.values) {
      expect(types, contains(type.name));
    }
  });

  group('captures', () {
    late CaptureStore store;

    setUp(() => store = CaptureStore(sqlite3.openInMemory()));
    tearDown(() => store.close());

    test('use the shared normalization for source and identity', () {
      final saved = store.save(
        parseCaptureInput(
          'https://twitter.com/Someone/status/1844123456789012345?s=20&t=x',
        ),
      );
      final link = normalizeLink(
        'https://x.com/someone/status/1844123456789012345',
      )!;
      expect(saved.source, CaptureSource.x);
      expect(saved.sourceItemId, link.sourceItemId);
      expect(saved.canonicalUrl, link.canonicalUrl);
      expect(saved.title, link.displayTitle);
      expect(saved.url, 'https://x.com/someone/status/1844123456789012345');
    });

    test('a note keeps its text and a first-line title', () {
      final saved = store.save(parseCaptureInput('Rail on wide\nscreens'));
      expect(saved.source, CaptureSource.note);
      expect(saved.title, 'Rail on wide');
      final draft = store.dueOperations(DateTime.now()).single.draft;
      expect(draft.text, 'Rail on wide\nscreens');
      expect(draft.url, isNull);
      expect(draft.title, isNull, reason: 'derived titles are left out');
    });

    test('findSaved recognises a repeat with other tracking params', () {
      final first = store.save(
        parseCaptureInput('https://www.instagram.com/p/C9xYz12AbCd/'),
      );
      final again = parseCaptureInput(
        'https://instagram.com/p/C9xYz12AbCd?igshid=abc&utm_source=ig',
      );
      expect(store.findSaved(again.link!)?.clientItemId, first.clientItemId);
      expect(
        store.findSaved(parseCaptureInput('https://example.com/x').link!),
        isNull,
      );
    });

    test('newest first', () {
      final older = store.save(
        parseCaptureInput('https://example.com/1'),
        now: DateTime.utc(2026, 10, 1),
      );
      final newer = store.save(
        parseCaptureInput('https://example.com/2'),
        now: DateTime.utc(2026, 10, 2),
      );
      expect(store.captures().map((c) => c.clientItemId), [
        newer.clientItemId,
        older.clientItemId,
      ]);
    });
  });

  group('held captures', () {
    late CaptureStore store;

    setUp(() => store = CaptureStore(sqlite3.openInMemory()));
    tearDown(() => store.close());

    test('are not sent until released, and stay editable until then', () {
      final saved = store.save(
        parseCaptureInput('https://example.com/post'),
        hold: true,
      );
      expect(store.dueOperations(DateTime.now()), isEmpty);
      expect(store.nextDueAt(), isNull);

      expect(
        store.editHeld(
          saved.clientItemId,
          title: 'Sidebar pattern',
          intention: 'For the dashboard',
        ),
        isTrue,
      );
      store.release(saved.clientItemId);

      final draft = store.dueOperations(DateTime.now()).single.draft;
      expect(draft.title, 'Sidebar pattern');
      expect(draft.intention, 'For the dashboard');
      expect(store.capture(saved.clientItemId)!.title, 'Sidebar pattern');

      expect(
        store.editHeld(saved.clientItemId, title: 'Too late'),
        isFalse,
        reason: 'a released request may already be on the wire',
      );
      final frozen = store.dueOperations(DateTime.now()).single.draft;
      expect(jsonEncode(frozen.toJson()), jsonEncode(draft.toJson()));
    });

    test('clearing the title falls back to the derived one', () {
      final saved = store.save(
        parseCaptureInput('https://example.com/post'),
        hold: true,
      );
      store.editHeld(saved.clientItemId, title: '   ');
      expect(store.capture(saved.clientItemId)!.title, 'example.com/post');
    });

    test('stale holds from a killed share sheet are released', () {
      final at = DateTime.utc(2026, 10, 6, 12);
      store.save(
        parseCaptureInput('https://example.com/a'),
        hold: true,
        now: at,
      );
      expect(
        store.releaseStaleHolds(now: at.add(const Duration(minutes: 1))),
        0,
      );
      expect(
        store.releaseStaleHolds(now: at.add(const Duration(minutes: 11))),
        1,
      );
      expect(
        store.dueOperations(at.add(const Duration(minutes: 11))),
        hasLength(1),
      );
    });
  });

  test(
    'confirm records the server answer and only then empties the outbox',
    () {
      final store = CaptureStore(sqlite3.openInMemory());
      addTearDown(store.close);
      final saved = store.save(parseCaptureInput('https://example.com/a'));
      final op = store.dueOperations(DateTime.now()).single;
      expect(store.outboxLength(), 1);

      store.confirm(
        op.operationId,
        CaptureResult(
          itemId: UuidValue.fromString('0199a000-0000-7000-8000-000000000001'),
          clientItemId: UuidValue.fromString(saved.clientItemId),
          revision: 1,
          title: 'example.com/a',
          sourcePlatform: SourcePlatform.web,
          duplicate: true,
          duplicateOf: UuidValue.fromString(
            '0199a000-0000-7000-8000-000000000001',
          ),
          enrichmentState: EnrichmentState.pending,
          savedAt: saved.capturedAt,
        ),
      );
      final synced = store.capture(saved.clientItemId)!;
      expect(synced.syncState, CaptureSyncState.synced);
      expect(synced.duplicate, isTrue);
      expect(synced.serverItemId, '0199a000-0000-7000-8000-000000000001');
      expect(store.outboxLength(), 0);
    },
  );
}
