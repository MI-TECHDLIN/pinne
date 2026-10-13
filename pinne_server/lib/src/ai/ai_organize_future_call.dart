import 'package:serverpod/serverpod.dart';

import 'ai_organization_service.dart';
import 'ai_provider_status.dart';

class AiOrganizeFutureCall extends FutureCall {
  Future<void> process(
    Session session,
    UuidValue itemId,
    UuidValue ownerId,
  ) async {
    try {
      await AiOrganizationService.instance.process(
        session,
        itemId: itemId,
        ownerId: ownerId,
      );
    } catch (error) {
      // Production session logs stay off the console; make a crashed task
      // visible in `serverpod cloud log` before Serverpod records it.
      AiProviderStatus.recordTaskError('${error.runtimeType}');
      rethrow;
    }
  }
}
