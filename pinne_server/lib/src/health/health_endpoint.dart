import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../ai/ai_provider_registry.dart';
import '../ai/ai_provider_status.dart';
import '../auth/email_delivery.dart';

/// Public liveness check that the app can call before sign-in.
class HealthEndpoint extends Endpoint {
  /// Bumped by hand when the API changes in a way the app should notice.
  static const apiVersion = '0.1.0';

  /// Whether new-account and password-reset codes can reach an inbox.
  Future<bool> emailDeliveryAvailable(Session session) async =>
      EmailDelivery.available;

  /// The configured AI provider and its last outcome in this process, such
  /// as `groq: last call failed at <time>: Groq returned HTTP 401
  /// (invalid_api_key).` Holds no key and no saved-item content.
  Future<String> aiProviderStatus(Session session) async =>
      AiProviderStatus.describe(
        configuredProvider: AiProviderRegistry.remote?.name,
      );

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
