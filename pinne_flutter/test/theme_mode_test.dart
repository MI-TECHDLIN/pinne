import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/theme/theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('theme mode defaults dark and persists the chosen appearance', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final store = SharedPreferencesThemePreferenceStore(preferences);
    final container = ProviderContainer(
      overrides: [themePreferenceStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    expect(container.read(themePreferenceProvider), PinneThemePreference.dark);

    await container
        .read(themePreferenceProvider.notifier)
        .set(PinneThemePreference.light);

    expect(
      preferences.getString(SharedPreferencesThemePreferenceStore.key),
      'light',
    );
    expect(
      SharedPreferencesThemePreferenceStore(preferences).read(),
      PinneThemePreference.light,
    );
  });

  test('system appearance round-trips through shared preferences', () async {
    SharedPreferences.setMockInitialValues({
      SharedPreferencesThemePreferenceStore.key: 'system',
    });
    final preferences = await SharedPreferences.getInstance();
    final store = SharedPreferencesThemePreferenceStore(preferences);

    expect(store.read(), PinneThemePreference.system);
    await store.write(PinneThemePreference.dark);
    expect(store.read(), PinneThemePreference.dark);
  });
}
