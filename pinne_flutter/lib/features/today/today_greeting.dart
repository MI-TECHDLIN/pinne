import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef GreetingClock = DateTime Function();
typedef GreetingIndexPicker = int Function(int length);

abstract interface class GreetingStore {
  String? get lastLine;
  void save(String line);
}

class SharedPreferencesGreetingStore implements GreetingStore {
  SharedPreferencesGreetingStore(this._preferences);

  static const _key = 'today.lastGreeting';
  final SharedPreferences _preferences;

  @override
  String? get lastLine => _preferences.getString(_key);

  @override
  void save(String line) => _preferences.setString(_key, line);
}

class MemoryGreetingStore implements GreetingStore {
  String? _lastLine;

  @override
  String? get lastLine => _lastLine;

  @override
  void save(String line) => _lastLine = line;
}

final greetingStoreProvider = Provider<GreetingStore>(
  (ref) => MemoryGreetingStore(),
);
final greetingClockProvider = Provider<GreetingClock>((ref) => DateTime.now);
final greetingIndexPickerProvider = Provider<GreetingIndexPicker>((ref) {
  final random = Random();
  return random.nextInt;
});

final todayGreetingProvider = NotifierProvider<TodayGreeting, String>(
  TodayGreeting.new,
);

/// Chooses a fresh Pinne line for each app session and long return.
class TodayGreeting extends Notifier<String> with WidgetsBindingObserver {
  static const returnThreshold = Duration(minutes: 10);

  DateTime? _backgroundedAt;

  @override
  String build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    return _choose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    handleLifecycleState(state);
  }

  @visibleForTesting
  void handleLifecycleState(AppLifecycleState lifecycleState) {
    final now = ref.read(greetingClockProvider)();
    switch (lifecycleState) {
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _backgroundedAt ??= now;
        break;
      case AppLifecycleState.resumed:
        final backgroundedAt = _backgroundedAt;
        _backgroundedAt = null;
        if (backgroundedAt != null &&
            now.difference(backgroundedAt) >= returnThreshold) {
          state = _choose();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  String _choose() {
    final now = ref.read(greetingClockProvider)();
    final store = ref.read(greetingStoreProvider);
    final choices = greetingLinesForHour(
      now.hour,
    ).where((line) => line != store.lastLine).toList(growable: false);
    final picker = ref.read(greetingIndexPickerProvider);
    final line = choices[picker(choices.length) % choices.length];
    store.save(line);
    return line;
  }
}

@visibleForTesting
List<String> greetingLinesForHour(int hour) {
  if (hour < 12) return _morningLines;
  if (hour < 18) return _afternoonLines;
  return _eveningLines;
}

const _morningLines = [
  'Begin gently. Follow what interests you.',
  'A fresh thought is a fine place to start.',
  'Make room for one good idea.',
  'Start small. Stay curious.',
  'There is time to notice something new.',
  'A quiet beginning can still go far.',
  'See where one useful thought leads.',
];

const _afternoonLines = [
  'Keep the useful things close.',
  'A small pause can sharpen the day.',
  'Follow the thought that still has energy.',
  'One clear next step is enough.',
  'Curiosity fits into ordinary moments.',
  'Take what helps. Leave the rest.',
  'There is still room for a good idea.',
];

const _eveningLines = [
  'Let the day settle. Keep what mattered.',
  'A quiet review can be enough.',
  'Keep one thought for tomorrow.',
  'End the day with something worth keeping.',
  'No rush. Notice what stayed with you.',
  'Small reflections make ideas last.',
  'Save the spark. Rest can do the rest.',
];
