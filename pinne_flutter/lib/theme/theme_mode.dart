import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PinneThemePreference {
  system,
  dark,
  light;

  ThemeMode get themeMode => switch (this) {
    PinneThemePreference.system => ThemeMode.system,
    PinneThemePreference.dark => ThemeMode.dark,
    PinneThemePreference.light => ThemeMode.light,
  };
}

abstract interface class ThemePreferenceStore {
  PinneThemePreference read();
  Future<void> write(PinneThemePreference preference);
}

class SharedPreferencesThemePreferenceStore implements ThemePreferenceStore {
  SharedPreferencesThemePreferenceStore(this.preferences);

  static const key = 'appearance.theme_mode';
  final SharedPreferences preferences;

  @override
  PinneThemePreference read() => switch (preferences.getString(key)) {
    'system' => PinneThemePreference.system,
    'light' => PinneThemePreference.light,
    _ => PinneThemePreference.dark,
  };

  @override
  Future<void> write(PinneThemePreference preference) async {
    await preferences.setString(key, preference.name);
  }
}

class _DefaultThemePreferenceStore implements ThemePreferenceStore {
  const _DefaultThemePreferenceStore();

  @override
  PinneThemePreference read() => PinneThemePreference.dark;

  @override
  Future<void> write(PinneThemePreference preference) async {}
}

final themePreferenceStoreProvider = Provider<ThemePreferenceStore>(
  (_) => const _DefaultThemePreferenceStore(),
);

final themePreferenceProvider =
    NotifierProvider<ThemePreferenceNotifier, PinneThemePreference>(
      ThemePreferenceNotifier.new,
    );

class ThemePreferenceNotifier extends Notifier<PinneThemePreference> {
  @override
  PinneThemePreference build() =>
      ref.watch(themePreferenceStoreProvider).read();

  Future<void> set(PinneThemePreference preference) async {
    state = preference;
    await ref.read(themePreferenceStoreProvider).write(preference);
  }
}
