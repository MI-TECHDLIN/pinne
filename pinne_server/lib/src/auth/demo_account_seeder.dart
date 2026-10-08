import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

class DemoSeedResult {
  const DemoSeedResult({required this.authUserId, required this.created});

  final UuidValue authUserId;
  final bool created;
}

/// Creates the empty judge account once, using Serverpod's supported admin API.
class DemoAccountSeeder {
  const DemoAccountSeeder({this.authServices});

  final AuthServices? authServices;

  Future<DemoSeedResult> seed(
    Session session, {
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.isEmpty) {
      throw ArgumentError('Demo account email and password must not be empty.');
    }

    final services = authServices ?? AuthServices.instance;
    final emailIdp = services.providers.whereType<EmailIdp>().single;
    return session.db.transaction((transaction) async {
      final existing = await emailIdp.admin.findAccount(
        session,
        email: normalizedEmail,
        transaction: transaction,
      );
      if (existing != null) {
        return DemoSeedResult(
          authUserId: existing.authUserId,
          created: false,
        );
      }

      final authUser = await services.authUsers.create(
        session,
        transaction: transaction,
      );
      await emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: authUser.id,
        email: normalizedEmail,
        password: password,
        transaction: transaction,
      );
      await services.userProfiles.createUserProfile(
        session,
        authUser.id,
        UserProfileData(email: normalizedEmail),
        transaction: transaction,
      );
      return DemoSeedResult(authUserId: authUser.id, created: true);
    });
  }
}
