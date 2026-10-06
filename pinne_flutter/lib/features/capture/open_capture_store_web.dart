import 'capture_store.dart';

/// Capture needs the Android or iOS app: the web build has no durable local
/// database, and saving must never claim durability it does not have.
Future<CaptureStore?> openCaptureStore() async => null;
