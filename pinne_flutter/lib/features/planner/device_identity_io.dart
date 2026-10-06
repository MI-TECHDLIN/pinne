import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pinne_client/pinne_client.dart';

/// A random id for this app install, kept in the private support directory.
/// Device calendar ids stored on the server are scoped to it, so another
/// phone never acts on this phone's calendars.
Future<UuidValue> loadDeviceId() async {
  final directory = await getApplicationSupportDirectory();
  await directory.create(recursive: true);
  final file = File(p.join(directory.path, 'pinne_device_id'));
  if (await file.exists()) {
    try {
      return UuidValue.withValidation((await file.readAsString()).trim());
    } on FormatException {
      // A damaged file gets a fresh id below.
    }
  }
  final id = const Uuid().v4obj();
  await file.writeAsString(id.uuid, flush: true);
  return id;
}
