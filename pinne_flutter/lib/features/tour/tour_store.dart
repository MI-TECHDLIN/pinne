import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers, on this phone, that the Today tour was shown.
abstract interface class TourStore {
  bool get seen;
  Future<void> markSeen();
}

class SharedPreferencesTourStore implements TourStore {
  SharedPreferencesTourStore(this.preferences);

  static const seenKey = 'tour.today.seen.v1';
  final SharedPreferences preferences;

  @override
  bool get seen => preferences.getBool(seenKey) ?? false;

  @override
  Future<void> markSeen() => preferences.setBool(seenKey, true);
}

/// Tests that are not about the tour never see it.
/// Production overrides this with [SharedPreferencesTourStore].
final tourStoreProvider = Provider<TourStore>(
  (ref) => MemoryTourStore(seen: true),
);

class MemoryTourStore implements TourStore {
  MemoryTourStore({this.seen = false});

  @override
  bool seen;

  @override
  Future<void> markSeen() async => seen = true;
}
