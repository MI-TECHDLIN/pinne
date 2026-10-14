import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/settings/reminder_settings_provider.dart';
import 'package:pinne_flutter/features/settings/settings_screen.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';

import '../support/contrast.dart';
import '../support/test_account.dart';

class _FakeReminderSettingsApi implements ReminderSettingsApi {
  var value = ReminderSettings(
    ownerId: UuidValue.fromString('00000000-0000-4000-8000-000000000001'),
  );
  final updates = <int>[];

  @override
  Future<ReminderSettings> settings() async => value;

  @override
  Future<ReminderSettings> updateSettings(ReminderSettingsDraft draft) async {
    updates.add(draft.delayHours);
    value = value.copyWith(delayHours: draft.delayHours);
    return value;
  }
}

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('Review rhythm saves the delay in ${brightness.name}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(412, 560));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = _FakeReminderSettingsApi();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accountIdProvider.overrideWith(TestAccountId.new),
            reminderSettingsApiProvider.overrideWithValue(api),
          ],
          child: MaterialApp(
            theme: brightness == Brightness.light
                ? pinneLightTheme()
                : pinneDarkTheme(),
            home: const Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: ReviewRhythmCard(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bring saves back after'), findsOneWidget);
      expect(
        find.text('New saves return to Today after this time.'),
        findsOneWidget,
      );
      final selected = tester.widget<ChoiceChip>(
        find.byKey(const ValueKey('review-delay-24')),
      );
      expect(selected.selected, isTrue);

      await tester.tap(find.byKey(const ValueKey('review-delay-72')));
      await tester.pumpAndSettle();
      expect(api.updates, [72]);
      expect(api.value.delayHours, 72);
      if (brightness == Brightness.light) {
        await expectReadableText(tester, reason: 'Review rhythm settings');
      }
    });
  }
}
