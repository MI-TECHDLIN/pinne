import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// The owner of every Pinne row is the signed-in auth user of the request.
///
/// Endpoints must take the owner from here and never from client input.
extension OwnerSession on Session {
  /// The signed-in user's id. Throws when the session is not authenticated;
  /// endpoints that use this must set `requireLogin` to `true`.
  UuidValue get ownerId {
    final auth = authenticated;
    if (auth == null) {
      throw StateError('ownerId read on an unauthenticated session.');
    }
    return auth.authUserId;
  }
}
