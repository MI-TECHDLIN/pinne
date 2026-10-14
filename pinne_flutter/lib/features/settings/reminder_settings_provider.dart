import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/library_revision.dart';
import '../../core/server_client.dart';

abstract interface class ReminderSettingsApi {
  Future<ReminderSettings> settings();
  Future<ReminderSettings> updateSettings(ReminderSettingsDraft draft);
}

class ServerReminderSettingsApi implements ReminderSettingsApi {
  const ServerReminderSettingsApi(this.endpoint);

  final EndpointReviewQueue endpoint;

  @override
  Future<ReminderSettings> settings() => endpoint.settings();

  @override
  Future<ReminderSettings> updateSettings(ReminderSettingsDraft draft) =>
      endpoint.updateSettings(draft);
}

final reminderSettingsApiProvider = Provider<ReminderSettingsApi>(
  (ref) => ServerReminderSettingsApi(ref.watch(clientProvider).reviewQueue),
);

final reminderSettingsProvider =
    AsyncNotifierProvider<ReminderSettingsNotifier, ReminderSettings?>(
      ReminderSettingsNotifier.new,
    );

class ReminderSettingsNotifier extends AsyncNotifier<ReminderSettings?> {
  @override
  Future<ReminderSettings?> build() async {
    if (ref.watch(accountIdProvider) == null) return null;
    return ref.watch(reminderSettingsApiProvider).settings();
  }

  Future<void> setDelayHours(int delayHours) async {
    final current = state.requireValue;
    if (current == null || current.delayHours == delayHours) return;
    state = const AsyncLoading<ReminderSettings?>();
    state = await AsyncValue.guard(() async {
      final saved = await ref
          .read(reminderSettingsApiProvider)
          .updateSettings(
            ReminderSettingsDraft(
              delayHours: delayHours,
              timezone: current.timezone,
              timezoneOffsetMinutes: current.timezoneOffsetMinutes,
              quietStartMinute: current.quietStartMinute,
              quietEndMinute: current.quietEndMinute,
              dailyCap: current.dailyCap,
              remindersPaused: current.remindersPaused,
              queueLimit: current.queueLimit,
              dismissCooldownMinutes: current.dismissCooldownMinutes,
            ),
          );
      ref.read(libraryRevisionProvider.notifier).bump();
      return saved;
    });
    if (state.hasError) {
      Error.throwWithStackTrace(state.error!, state.stackTrace!);
    }
  }
}
