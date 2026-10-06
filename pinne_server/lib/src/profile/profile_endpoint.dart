import 'package:serverpod/serverpod.dart';

import '../auth/owner.dart';
import '../generated/protocol.dart';

class ProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Stable wire indices; keep aligned with PinneSpiritPalettes in the app.
  static const paletteCount = 6;
  static const maxSeed = 2147483646;

  Future<PinneProfile?> get(Session session) => PinneProfile.db.findFirstRow(
    session,
    where: (t) => t.ownerId.equals(session.ownerId),
  );

  Future<PinneProfile> upsert(Session session, ProfileDraft draft) async {
    if (draft.avatarPalette < 0 || draft.avatarPalette >= paletteCount) {
      throw ValidationException(message: 'Choose a valid avatar palette.');
    }
    if (draft.avatarSeed < 0 || draft.avatarSeed > maxSeed) {
      throw ValidationException(message: 'Choose a valid avatar seed.');
    }
    final name = draft.displayName.trim();
    if (name.isEmpty || name.length > 80) {
      throw ValidationException(
        message: 'Use a display name of 1–80 characters.',
      );
    }
    final profile = await PinneProfile.db.upsertRow(
      session,
      PinneProfile(
        ownerId: session.ownerId,
        displayName: name,
        avatarSeed: draft.avatarSeed,
        avatarPalette: draft.avatarPalette,
      ),
      conflictColumns: (t) => [t.ownerId],
      updateWhere: (t) => t.ownerId.equals(session.ownerId),
      updateColumns: (t) => [t.displayName, t.avatarSeed, t.avatarPalette],
    );
    return profile!;
  }
}
