import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/server_client.dart';
import 'features/capture/capture_providers.dart';
import 'features/capture/open_capture_store.dart';
import 'features/capture/share_entry.dart';
import 'features/onboarding/onboarding_store.dart';
import 'features/search/search_history.dart';
import 'features/tour/tour_store.dart';
import 'features/today/today_greeting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final serverUrl = await resolveServerUrl();
  final client = await createServerClient(serverUrl);
  final store = await openCaptureStore();
  final preferences = await SharedPreferences.getInstance();
  final searchHistoryStore = SharedPreferencesSearchHistoryStore(preferences);
  store?.releaseStaleHolds();
  runApp(
    ProviderScope(
      overrides: [
        serverUrlProvider.overrideWithValue(serverUrl),
        clientProvider.overrideWithValue(client),
        captureStoreProvider.overrideWithValue(store),
        onboardingStoreProvider.overrideWithValue(
          SharedPreferencesOnboardingStore(preferences),
        ),
        tourStoreProvider.overrideWithValue(
          SharedPreferencesTourStore(preferences),
        ),
        greetingStoreProvider.overrideWithValue(
          SharedPreferencesGreetingStore(preferences),
        ),
        searchHistoryStoreProvider.overrideWithValue(searchHistoryStore),
        signOutCleanupProvider.overrideWith(
          (ref) =>
              () => ref.read(searchHistoryProvider.notifier).clear(),
        ),
      ],
      child: const PinneApp(),
    ),
  );
}

/// Entrypoint of Android's `ShareActivity`: only the "Saved to Pinne" sheet,
/// in its own engine, over the app that shared.
@pragma('vm:entry-point')
void shareMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  const channel = ShareChannel();
  final payload = await channel.take();
  if (payload == null) {
    await channel.finish();
    return;
  }
  final store = await openCaptureStore();
  final serverUrl = await resolveServerUrl();
  final client = await createServerClient(serverUrl);
  runApp(
    ProviderScope(
      overrides: [
        serverUrlProvider.overrideWithValue(serverUrl),
        clientProvider.overrideWithValue(client),
        captureStoreProvider.overrideWithValue(store),
      ],
      child: ShareApp(payload: payload, onDone: channel.finish),
    ),
  );
}
