import 'package:serverpod/serverpod.dart';

import 'link_preview_service.dart';

class LinkPreviewFutureCall extends FutureCall {
  Future<void> process(
    Session session,
    UuidValue itemId,
    UuidValue ownerId,
  ) => LinkPreviewService.instance.process(
    session,
    itemId: itemId,
    ownerId: ownerId,
  );
}
