import 'package:pinne_client/pinne_client.dart';

/// The web build has no device calendar, so its id only needs to last for
/// the page.
Future<UuidValue> loadDeviceId() async => const Uuid().v4obj();
