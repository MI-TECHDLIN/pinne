import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single invalidation point for everything derived from the account's
/// items, review events and planned sessions.
///
/// Providers that show those numbers (Today's queue and tiles, Progress,
/// Profile stats, Saved, Collections, Search) watch this and refetch when it
/// changes. Anything that mutates the library calls [LibraryRevision.bump]
/// instead of invalidating providers one by one. The app coming back to the
/// foreground bumps it too, since the share sheet or another device may have
/// changed things meanwhile.
final libraryRevisionProvider = NotifierProvider<LibraryRevision, int>(
  LibraryRevision.new,
);

class LibraryRevision extends Notifier<int> {
  @override
  int build() {
    final lifecycle = AppLifecycleListener(onResume: bump);
    ref.onDispose(lifecycle.dispose);
    return 0;
  }

  void bump() => state++;
}
