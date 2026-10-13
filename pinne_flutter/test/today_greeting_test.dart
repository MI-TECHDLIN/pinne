import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/features/today/today_greeting.dart';
import 'package:pinne_flutter/features/today/today_screen.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';

void main() {
  testWidgets('rotates only after a ten-minute return and never repeats', (
    tester,
  ) async {
    var now = DateTime(2026, 10, 13, 9);
    final store = MemoryGreetingStore()..save(_morningFirst);
    final container = ProviderContainer(
      overrides: [
        greetingStoreProvider.overrideWithValue(store),
        greetingClockProvider.overrideWithValue(() => now),
        greetingIndexPickerProvider.overrideWithValue((_) => 0),
      ],
    );
    addTearDown(container.dispose);

    final first = container.read(todayGreetingProvider);
    expect(first, isNot(_morningFirst));

    final controller = container.read(todayGreetingProvider.notifier);
    controller.handleLifecycleState(AppLifecycleState.paused);
    now = now.add(const Duration(minutes: 9, seconds: 59));
    controller.handleLifecycleState(AppLifecycleState.resumed);
    expect(container.read(todayGreetingProvider), first);

    controller.handleLifecycleState(AppLifecycleState.paused);
    now = now.add(const Duration(minutes: 10));
    controller.handleLifecycleState(AppLifecycleState.resumed);
    final afterReturn = container.read(todayGreetingProvider);
    expect(afterReturn, isNot(first));

    final nextSession = ProviderContainer(
      overrides: [
        greetingStoreProvider.overrideWithValue(store),
        greetingClockProvider.overrideWithValue(() => now),
        greetingIndexPickerProvider.overrideWithValue((_) => 0),
      ],
    );
    addTearDown(nextSession.dispose);
    expect(nextSession.read(todayGreetingProvider), isNot(afterReturn));
  });

  testWidgets('calm headline stays within two lines at narrow 1.3x text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 180));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: pinneDarkTheme(),
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.3)),
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: TodayHeadline(
                count: 0,
                calmLine: 'Begin gently. Follow what interests you.',
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final text = tester.widget<Text>(
      find.byKey(const ValueKey('today-calm-headline')),
    );
    expect(text.maxLines, 2);
    expect(text.overflow, TextOverflow.ellipsis);
  });
}

const _morningFirst = 'Begin gently. Follow what interests you.';
