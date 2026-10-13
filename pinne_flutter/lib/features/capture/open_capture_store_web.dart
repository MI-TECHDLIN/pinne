import 'package:sqlite3/wasm.dart';

import 'capture_store.dart';

/// Opens the browser's durable capture outbox in IndexedDB. UI confirmation
/// awaits [CaptureStore.persist], so "Saved" is never shown for a queued-only
/// write that has not reached browser storage.
Future<CaptureStore?> openCaptureStore() async {
  final sqlite = await WasmSqlite3.loadFromUrlString('sqlite3.wasm');
  final fileSystem = await IndexedDbFileSystem.open(
    dbName: 'pinne_capture',
    writeAutomatically: true,
  );
  sqlite.registerVirtualFileSystem(fileSystem, makeDefault: true);
  final database = sqlite.open('pinne-captures.sqlite');
  CaptureStore.configureDurable(database);
  final store = CaptureStore(database, persistCallback: fileSystem.flush);
  await store.persist();
  return store;
}
