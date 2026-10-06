import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import 'capture_store.dart';

/// Opens the capture database in the app's private support directory,
/// which the OS does not clear like a cache.
Future<CaptureStore?> openCaptureStore() async {
  final directory = await getApplicationSupportDirectory();
  await directory.create(recursive: true);
  return openCaptureStoreAt(p.join(directory.path, 'pinne_captures.sqlite'));
}

/// Opens or creates the capture database at [path].
CaptureStore openCaptureStoreAt(String path) {
  final db = sqlite3.open(path);
  CaptureStore.configureDurable(db);
  return CaptureStore(db);
}
