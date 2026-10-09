import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';

import 'owner.dart';

/// Reports account capabilities from server-owned auth records.
class AccountEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Whether the current auth user is a device-bound anonymous account.
  Future<bool> isGuest(Session session) async {
    final ownerId = session.ownerId;
    return await AnonymousAccount.db.findFirstRow(
          session,
          where: (table) => table.authUserId.equals(ownerId),
        ) !=
        null;
  }
}
