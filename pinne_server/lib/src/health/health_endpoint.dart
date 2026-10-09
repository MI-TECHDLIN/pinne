import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../auth/email_delivery.dart';

/// Public liveness check that the app can call before sign-in.
class HealthEndpoint extends Endpoint {
  /// Bumped by hand when the API changes in a way the app should notice.
  static const apiVersion = '0.1.0';

  /// Whether new-account and password-reset codes can reach an inbox.
  Future<bool> emailDeliveryAvailable(Session session) async =>
      EmailDelivery.available;

  Future<ServerHealth> check(Session session) async {
    var databaseOk = true;
    try {
      await session.db.unsafeQuery('SELECT 1');
    } catch (e) {
      databaseOk = false;
      session.log(
        'Health check database probe failed: $e',
        level: LogLevel.warning,
      );
    }
    return ServerHealth(
      ok: true,
      databaseOk: databaseOk,
      serverTime: DateTime.now().toUtc(),
      version: apiVersion,
    );
  }
}
