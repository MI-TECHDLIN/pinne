import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingStore {
  bool get completed;
  Future<void> markCompleted();
}

class SharedPreferencesOnboardingStore implements OnboardingStore {
  SharedPreferencesOnboardingStore(this.preferences);

  static const completedKey = 'onboarding.completed.v1';
  final SharedPreferences preferences;

  @override
  bool get completed => preferences.getBool(completedKey) ?? false;

  @override
  Future<void> markCompleted() => preferences.setBool(completedKey, true);
}

/// Tests that are not about first-run behavior keep their historical route.
/// Production overrides this with [SharedPreferencesOnboardingStore].
final onboardingStoreProvider = Provider<OnboardingStore>(
  (ref) => MemoryOnboardingStore(completed: true),
);

class MemoryOnboardingStore implements OnboardingStore {
  MemoryOnboardingStore({this.completed = false});

  @override
  bool completed;

  @override
  Future<void> markCompleted() async => completed = true;
}
