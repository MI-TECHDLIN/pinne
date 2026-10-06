import 'package:serverpod_auth_idp_server/core.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Inserts an auth user so owner foreign keys resolve, and returns a session
/// builder signed in as that user.
Future<TestSessionBuilder> signedInAs(TestSessionBuilder builder) async {
  final user = await AuthUser.db.insertRow(
    builder.build(),
    AuthUser(scopeNames: {}),
  );
  return builder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(
      user.id!.uuid,
      {},
    ),
  );
}
