import 'dart:async';
import 'dart:convert';

import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:sqlite3/common.dart';

/// Where a local capture is on its way to the server.
enum CaptureSyncState {
  /// Saved on this phone, waiting in the outbox.
  pending,

  /// The server confirmed it.
  synced,

  /// The server refused it. Kept locally until the user retries.
  failed,
}

/// One capture as stored on the device. The server id arrives once synced.
@immutable
class LocalCapture {
  const LocalCapture({
    required this.accountId,
    required this.clientItemId,
    required this.operationId,
    required this.title,
    required this.source,
    required this.capturedAt,
    required this.syncState,
    this.url,
    this.noteText,
    this.intention,
    this.sourceItemId,
    this.canonicalUrl,
    this.held = false,
    this.serverItemId,
    this.duplicate = false,
    this.attempts = 0,
    this.lastError,
  });

  final String accountId;
  final String clientItemId;
  final String operationId;
  final String title;
  final CaptureSource source;
  final DateTime capturedAt;
  final CaptureSyncState syncState;
  final String? url;
  final String? noteText;
  final String? intention;
  final String? sourceItemId;
  final String? canonicalUrl;

  /// Still open in the share sheet, so not sent yet and still editable.
  final bool held;
  final String? serverItemId;

  /// The server matched it to an item saved earlier.
  final bool duplicate;
  final int attempts;
  final String? lastError;
}

/// A queued server call. Its [draft] is frozen once it may have been sent,
/// so a retry is byte-for-byte the same request.
@immutable
class OutboxOperation {
  const OutboxOperation({
    required this.accountId,
    required this.operationId,
    required this.clientItemId,
    required this.draft,
    required this.attempts,
  });

  final String accountId;
  final String operationId;
  final String clientItemId;
  final CaptureDraft draft;
  final int attempts;
}

/// Local-first capture storage on SQLite.
///
/// A capture and its outbox operation are written in one transaction, and
/// the database runs in WAL mode with `synchronous = FULL`, so once [save]
/// returns the capture survives the app being killed. Only then may the UI
/// say "Saved".
///
/// The share sheet and the main app can run in separate Flutter engines on
/// Android. Each opens its own connection; SQLite's locking and the busy
/// timeout keep their writes apart, and the server's idempotency makes a
/// doubly sent operation harmless.
class CaptureStore {
  CaptureStore(this._db, {this.persistCallback}) {
    _migrate();
  }

  final CommonDatabase _db;
  final Future<void> Function()? persistCallback;
  final _changes = StreamController<void>.broadcast();

  static const _schemaVersion = 2;

  /// Keeps older unit-test callers concise. Production callers always pass
  /// the authenticated [accountId] explicitly.
  static const testAccountId = 'test-account';

  /// Holds older than this are left over from a share sheet that never
  /// closed cleanly, and are released at start-up.
  static const staleHold = Duration(minutes: 10);

  /// Fires after every write made through this store, and on
  /// [notifyExternalChange].
  Stream<void> get changes => _changes.stream;

  /// Flushes the platform store when its database writes are asynchronous.
  /// Native SQLite commits synchronously, so this is a no-op there.
  Future<void> persist() => persistCallback?.call() ?? Future<void>.value();

  /// Sets the pragmas that make a commit durable. Call once per connection.
  static void configureDurable(CommonDatabase db) {
    db.select('PRAGMA journal_mode = WAL');
    db.execute('PRAGMA synchronous = FULL');
    db.execute('PRAGMA busy_timeout = 5000');
    db.execute('PRAGMA foreign_keys = ON');
  }

  void _migrate() {
    final version = _db.select('PRAGMA user_version').first.columnAt(0) as int;
    if (version >= _schemaVersion) return;
    _transaction(() {
      _db.execute('''
        CREATE TABLE IF NOT EXISTS captures (
          client_item_id TEXT PRIMARY KEY,
          account_id TEXT NOT NULL,
          operation_id TEXT NOT NULL,
          url TEXT,
          note_text TEXT,
          title TEXT NOT NULL,
          intention TEXT,
          source TEXT NOT NULL,
          source_item_id TEXT,
          canonical_url TEXT,
          captured_at INTEGER NOT NULL,
          sync_state TEXT NOT NULL,
          server_item_id TEXT,
          revision INTEGER,
          duplicate INTEGER NOT NULL DEFAULT 0,
          enrichment_state TEXT
        )''');
      _db.execute('''
        CREATE TABLE IF NOT EXISTS outbox (
          seq INTEGER PRIMARY KEY AUTOINCREMENT,
          operation_id TEXT NOT NULL UNIQUE,
          account_id TEXT NOT NULL,
          client_item_id TEXT NOT NULL
            REFERENCES captures (client_item_id) ON DELETE CASCADE,
          payload TEXT NOT NULL,
          held INTEGER NOT NULL DEFAULT 0,
          held_since INTEGER,
          attempts INTEGER NOT NULL DEFAULT 0,
          next_attempt_at INTEGER NOT NULL DEFAULT 0,
          failed INTEGER NOT NULL DEFAULT 0,
          last_error TEXT
        )''');
      if (version == 1) {
        // Version 1 predates account scoping. These rows are quarantined
        // until [claimLegacyCaptures] can associate them with the session
        // that was persisted across the upgrade.
        _db.execute(
          "ALTER TABLE captures ADD COLUMN account_id TEXT NOT NULL DEFAULT ''",
        );
        _db.execute(
          "ALTER TABLE outbox ADD COLUMN account_id TEXT NOT NULL DEFAULT ''",
        );
      }
      _db.execute(
        'CREATE INDEX IF NOT EXISTS captures_account_captured_idx '
        'ON captures (account_id, captured_at)',
      );
      _db.execute(
        'CREATE INDEX IF NOT EXISTS outbox_account_due_idx '
        'ON outbox (account_id, held, failed, next_attempt_at)',
      );
      _db.execute('PRAGMA user_version = $_schemaVersion');
    });
  }

  /// Persists a capture and queues it for the server, atomically.
  ///
  /// With [hold] the operation is not sent until [release], so the share
  /// sheet can still change the title and note without ever sending two
  /// different payloads under one operation id.
  LocalCapture save(
    CaptureInput input, {
    String accountId = testAccountId,
    String? title,
    String? intention,
    bool hold = false,
    DateTime? now,
  }) {
    if (input.isEmpty) throw ArgumentError.value(input, 'input', 'is empty');
    final link = input.link;
    final at = (now ?? DateTime.now()).toUtc();
    final capture = LocalCapture(
      accountId: accountId,
      clientItemId: const Uuid().v4(),
      operationId: const Uuid().v4(),
      title: _clean(title) ?? input.suggestedTitle,
      source: input.source,
      capturedAt: at,
      syncState: CaptureSyncState.pending,
      url: link?.cleanUrl,
      noteText: input.note,
      intention: cleanIntention(intention, link: link),
      sourceItemId: link?.sourceItemId,
      canonicalUrl: link?.canonicalUrl,
      held: hold,
    );
    _transaction(() {
      _db.execute(
        'INSERT INTO captures (client_item_id, account_id, operation_id, url, note_text, '
        'title, intention, source, source_item_id, canonical_url, '
        'captured_at, sync_state) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          capture.clientItemId,
          accountId,
          capture.operationId,
          capture.url,
          capture.noteText,
          capture.title,
          capture.intention,
          capture.source.name,
          capture.sourceItemId,
          capture.canonicalUrl,
          at.millisecondsSinceEpoch,
          CaptureSyncState.pending.name,
        ],
      );
      _db.execute(
        'INSERT INTO outbox (operation_id, account_id, client_item_id, payload, held, '
        'held_since) VALUES (?, ?, ?, ?, ?, ?)',
        [
          capture.operationId,
          accountId,
          capture.clientItemId,
          _payload(capture),
          hold ? 1 : 0,
          hold ? at.millisecondsSinceEpoch : null,
        ],
      );
    });
    _notify();
    return capture;
  }

  /// Changes the title and note of a capture that is still held. Returns
  /// false once the capture has been released, because its request may
  /// already be on the wire.
  bool editHeld(
    String clientItemId, {
    String accountId = testAccountId,
    String? title,
    String? intention,
  }) {
    final changed = _transaction(() {
      final current = capture(clientItemId, accountId: accountId);
      if (current == null || !current.held || current.attempts > 0) {
        return false;
      }
      final edited = LocalCapture(
        accountId: accountId,
        clientItemId: current.clientItemId,
        operationId: current.operationId,
        title: _clean(title) ?? _derivedTitle(current),
        source: current.source,
        capturedAt: current.capturedAt,
        syncState: current.syncState,
        url: current.url,
        noteText: current.noteText,
        intention: cleanIntention(
          intention,
          link: current.url == null ? null : normalizeLink(current.url!),
        ),
        sourceItemId: current.sourceItemId,
        canonicalUrl: current.canonicalUrl,
      );
      _db.execute(
        'UPDATE captures SET title = ?, intention = ? '
        'WHERE client_item_id = ? AND account_id = ?',
        [edited.title, edited.intention, clientItemId, accountId],
      );
      _db.execute(
        'UPDATE outbox SET payload = ? WHERE operation_id = ? AND account_id = ?',
        [_payload(edited), current.operationId, accountId],
      );
      return true;
    });
    if (changed) _notify();
    return changed;
  }

  /// Lets the outbox send a held capture.
  void release(String clientItemId, {String accountId = testAccountId}) {
    _db.execute(
      'UPDATE outbox SET held = 0, held_since = NULL '
      'WHERE client_item_id = ? AND account_id = ? AND held = 1',
      [clientItemId, accountId],
    );
    if (_db.updatedRows > 0) _notify();
  }

  /// Removes a capture the user chose not to keep, with its outbox
  /// operation, so it is never sent. A capture that already synced must be
  /// removed on the server first.
  void discard(String clientItemId, {String accountId = testAccountId}) {
    _transaction(() {
      _db.execute(
        'DELETE FROM outbox WHERE client_item_id = ? AND account_id = ?',
        [clientItemId, accountId],
      );
      _db.execute(
        'DELETE FROM captures WHERE client_item_id = ? AND account_id = ?',
        [clientItemId, accountId],
      );
    });
    _notify();
  }

  /// Releases holds left by a share sheet that was killed before Done.
  int releaseStaleHolds({
    String accountId = testAccountId,
    DateTime? now,
  }) {
    final cutoff = (now ?? DateTime.now()).toUtc().subtract(staleHold);
    _db.execute(
      'UPDATE outbox SET held = 0, held_since = NULL '
      'WHERE account_id = ? AND held = 1 AND held_since <= ?',
      [accountId, cutoff.millisecondsSinceEpoch],
    );
    final released = _db.updatedRows;
    if (released > 0) _notify();
    return released;
  }

  static const _captureColumns =
      'c.account_id, c.client_item_id, c.operation_id, c.url, c.note_text, c.title, '
      'c.intention, c.source, c.source_item_id, c.canonical_url, '
      'c.captured_at, c.sync_state, c.server_item_id, c.duplicate, '
      'o.held, o.attempts, o.last_error';

  /// Every capture, newest first.
  List<LocalCapture> captures({String accountId = testAccountId}) {
    final rows = _db.select(
      'SELECT $_captureColumns FROM captures c '
      'LEFT JOIN outbox o ON o.client_item_id = c.client_item_id '
      'WHERE c.account_id = ? '
      'ORDER BY c.captured_at DESC, c.rowid DESC',
      [accountId],
    );
    return rows.map(_captureFrom).toList();
  }

  LocalCapture? capture(
    String clientItemId, {
    String accountId = testAccountId,
  }) {
    final rows = _db.select(
      'SELECT $_captureColumns FROM captures c '
      'LEFT JOIN outbox o ON o.client_item_id = c.client_item_id '
      'WHERE c.client_item_id = ? AND c.account_id = ?',
      [clientItemId, accountId],
    );
    return rows.isEmpty ? null : _captureFrom(rows.first);
  }

  /// An earlier capture of the same item, recognised with the same rules the
  /// server uses: platform item id first, then canonical URL.
  LocalCapture? findSaved(
    NormalizedLink link, {
    String accountId = testAccountId,
    String? except,
  }) {
    final rows = _db.select(
      'SELECT $_captureColumns FROM captures c '
      'LEFT JOIN outbox o ON o.client_item_id = c.client_item_id '
      'WHERE c.account_id = ? AND c.client_item_id IS NOT ? AND ('
      '(c.source = ? AND c.source_item_id IS NOT NULL '
      'AND c.source_item_id = ?) OR c.canonical_url = ?) '
      'ORDER BY c.captured_at ASC LIMIT 1',
      [
        accountId,
        except,
        link.source.name,
        link.sourceItemId,
        link.canonicalUrl,
      ],
    );
    return rows.isEmpty ? null : _captureFrom(rows.first);
  }

  /// Operations ready to send at [now], oldest first.
  List<OutboxOperation> dueOperations(
    DateTime now, {
    String accountId = testAccountId,
  }) {
    final rows = _db.select(
      'SELECT operation_id, client_item_id, payload, attempts FROM outbox '
      'WHERE account_id = ? AND held = 0 AND failed = 0 '
      'AND next_attempt_at <= ? ORDER BY seq',
      [accountId, now.toUtc().millisecondsSinceEpoch],
    );
    return [
      for (final row in rows)
        OutboxOperation(
          accountId: accountId,
          operationId: row['operation_id'] as String,
          clientItemId: row['client_item_id'] as String,
          draft: CaptureDraft.fromJson(
            jsonDecode(row['payload'] as String) as Map<String, dynamic>,
          ),
          attempts: row['attempts'] as int,
        ),
    ];
  }

  /// When the next queued operation becomes due, or null if none is.
  DateTime? nextDueAt({String accountId = testAccountId}) {
    final value = _db
        .select(
          'SELECT MIN(next_attempt_at) FROM outbox '
          'WHERE account_id = ? AND held = 0 AND failed = 0',
          [accountId],
        )
        .first
        .columnAt(0);
    return value == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(value as int, isUtc: true);
  }

  /// Operations not yet confirmed by the server, including held and failed.
  int outboxLength({String accountId = testAccountId}) =>
      _db
              .select(
                'SELECT COUNT(*) FROM outbox WHERE account_id = ?',
                [accountId],
              )
              .first
              .columnAt(0)
          as int;

  /// Records the server's answer and only then removes the operation.
  void confirm(
    String operationId,
    CaptureResult result, {
    String accountId = testAccountId,
  }) {
    _transaction(() {
      _db.execute(
        'UPDATE captures SET sync_state = ?, server_item_id = ?, '
        'revision = ?, duplicate = ?, enrichment_state = ? '
        'WHERE operation_id = ? AND account_id = ?',
        [
          CaptureSyncState.synced.name,
          result.itemId.uuid,
          result.revision,
          result.duplicate ? 1 : 0,
          result.enrichmentState.name,
          operationId,
          accountId,
        ],
      );
      _db.execute(
        'DELETE FROM outbox WHERE operation_id = ? AND account_id = ?',
        [operationId, accountId],
      );
    });
    _notify();
  }

  /// Keeps the operation and tries again at [nextAttemptAt].
  void scheduleRetry(
    String operationId, {
    String accountId = testAccountId,
    required int attempts,
    required DateTime nextAttemptAt,
    String? error,
  }) {
    _db.execute(
      'UPDATE outbox SET attempts = ?, next_attempt_at = ?, last_error = ? '
      'WHERE operation_id = ? AND account_id = ?',
      [
        attempts,
        nextAttemptAt.toUtc().millisecondsSinceEpoch,
        error,
        operationId,
        accountId,
      ],
    );
    _notify();
  }

  /// The server refused the operation; retrying the same request cannot
  /// help. It stays in the outbox, parked, until the user retries.
  void markFailed(
    String operationId,
    String error, {
    String accountId = testAccountId,
  }) {
    _transaction(() {
      _db.execute(
        'UPDATE outbox SET failed = 1, attempts = attempts + 1, '
        'last_error = ? WHERE operation_id = ? AND account_id = ?',
        [error, operationId, accountId],
      );
      _db.execute(
        'UPDATE captures SET sync_state = ? '
        'WHERE operation_id = ? AND account_id = ?',
        [CaptureSyncState.failed.name, operationId, accountId],
      );
    });
    _notify();
  }

  /// Puts a failed capture back in the queue.
  void retry(String clientItemId, {String accountId = testAccountId}) {
    _transaction(() {
      _db.execute(
        'UPDATE outbox SET failed = 0, next_attempt_at = 0 '
        'WHERE client_item_id = ? AND account_id = ?',
        [clientItemId, accountId],
      );
      _db.execute(
        'UPDATE captures SET sync_state = ? '
        'WHERE client_item_id = ? AND account_id = ?',
        [CaptureSyncState.pending.name, clientItemId, accountId],
      );
    });
    _notify();
  }

  /// Another engine may have written to the same database file.
  void notifyExternalChange() => _notify();

  /// Associates schema-v1 rows with the session restored during upgrade.
  /// Unowned rows are otherwise invisible and cannot be uploaded.
  int claimLegacyCaptures(String accountId) {
    final claimed = _transaction(() {
      _db.execute(
        "UPDATE captures SET account_id = ? WHERE account_id = ''",
        [accountId],
      );
      final count = _db.updatedRows;
      _db.execute(
        "UPDATE outbox SET account_id = ? WHERE account_id = ''",
        [accountId],
      );
      return count;
    });
    if (claimed > 0) _notify();
    return claimed;
  }

  void close() {
    unawaited(_changes.close());
    _db.close();
  }

  void _notify() {
    if (!_changes.isClosed) _changes.add(null);
  }

  T _transaction<T>(T Function() body) {
    _db.execute('BEGIN IMMEDIATE');
    try {
      final result = body();
      _db.execute('COMMIT');
      return result;
    } catch (_) {
      _db.execute('ROLLBACK');
      rethrow;
    }
  }

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  /// The title the server would derive by itself from the same content.
  static String _derivedTitle(LocalCapture capture) {
    final url = capture.url;
    final link = url == null ? null : normalizeLink(url);
    return link?.displayTitle ?? noteTitle(capture.noteText ?? '');
  }

  /// The request for [capture]. A title equal to the derived one is left
  /// out, so the server knows the user did not choose it.
  static String _payload(LocalCapture capture) {
    final title = capture.title == _derivedTitle(capture)
        ? null
        : capture.title;
    final draft = CaptureDraft(
      clientItemId: UuidValue.fromString(capture.clientItemId),
      operationId: UuidValue.fromString(capture.operationId),
      url: capture.url,
      text: capture.noteText,
      title: title,
      intention: capture.intention,
      capturedAt: capture.capturedAt,
    );
    return jsonEncode(draft.toJson());
  }

  static LocalCapture _captureFrom(Row row) {
    final held = row['held'] as int?;
    return LocalCapture(
      accountId: row['account_id'] as String,
      clientItemId: row['client_item_id'] as String,
      operationId: row['operation_id'] as String,
      title: row['title'] as String,
      source:
          CaptureSource.values.asNameMap()[row['source']] ??
          CaptureSource.unknown,
      capturedAt: DateTime.fromMillisecondsSinceEpoch(
        row['captured_at'] as int,
        isUtc: true,
      ),
      syncState: CaptureSyncState.values.byName(row['sync_state'] as String),
      url: row['url'] as String?,
      noteText: row['note_text'] as String?,
      intention: row['intention'] as String?,
      sourceItemId: row['source_item_id'] as String?,
      canonicalUrl: row['canonical_url'] as String?,
      held: held == 1,
      serverItemId: row['server_item_id'] as String?,
      duplicate: row['duplicate'] == 1,
      attempts: row['attempts'] as int? ?? 0,
      lastError: row['last_error'] as String?,
    );
  }
}
