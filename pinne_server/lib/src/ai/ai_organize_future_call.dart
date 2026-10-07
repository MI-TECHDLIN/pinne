import 'package:serverpod/serverpod.dart';

import 'ai_organization_service.dart';

class AiOrganizeFutureCall extends FutureCall {
  Future<void> process(
    Session session,
    UuidValue itemId,
    UuidValue ownerId,
  ) => AiOrganizationService.instance.process(
    session,
    itemId: itemId,
    ownerId: ownerId,
  );
}
