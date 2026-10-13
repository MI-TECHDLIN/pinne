import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
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

  /// Details for the current owner only. No owner id is accepted from clients.
  Future<AccountSummary> summary(Session session) async {
    final ownerId = session.ownerId;
    final authUser = await AuthServices.instance.authUsers.get(
      session,
      authUserId: ownerId,
    );
    final anonymous = await AnonymousAccount.db.findFirstRow(
      session,
      where: (table) => table.authUserId.equals(ownerId),
    );
    if (anonymous != null) {
      return AccountSummary(
        type: ProfileAccountType.guest,
        memberSince: authUser.createdAt,
      );
    }

    final emailAccount = await EmailAccount.db.findFirstRow(
      session,
      where: (table) => table.authUserId.equals(ownerId),
    );
    final userProfile = await AuthServices.instance.userProfiles
        .maybeFindUserProfileByUserId(session, ownerId);
    final email = emailAccount?.email ?? userProfile?.email;
    final configuredDemoEmail = session.serverpod
        .getPassword('demoAccountEmail')
        ?.trim()
        .toLowerCase();
    return AccountSummary(
      type:
          email != null &&
              configuredDemoEmail != null &&
              email == configuredDemoEmail
          ? ProfileAccountType.demo
          : ProfileAccountType.email,
      email: email,
      memberSince: authUser.createdAt,
    );
  }
}
