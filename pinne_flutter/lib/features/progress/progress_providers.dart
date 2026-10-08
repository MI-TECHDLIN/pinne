import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/server_client.dart';

/// The progress endpoint, behind an interface so tests can use a fake server.
abstract interface class ProgressApi {
  Future<ProgressReport> report(ProgressQuery query);
  Future<void> markCelebrated(List<String> keys);
  Future<ProgressSettings> settings();
  Future<ProgressSettings> updateSettings(ProgressSettingsDraft draft);
}

class ServerProgressApi implements ProgressApi {
  ServerProgressApi(this._client);

  final Client _client;

  @override
  Future<ProgressReport> report(ProgressQuery query) =>
      _client.progress.report(query);

  @override
  Future<void> markCelebrated(List<String> keys) =>
      _client.progress.markCelebrated(keys);

  @override
  Future<ProgressSettings> settings() => _client.progress.settings();

  @override
  Future<ProgressSettings> updateSettings(ProgressSettingsDraft draft) =>
      _client.progress.updateSettings(draft);
}

final progressApiProvider = Provider<ProgressApi>(
  (ref) => ServerProgressApi(ref.watch(clientProvider)),
);

/// A query for [period] in the device's current timezone.
ProgressQuery progressQuery(ProgressPeriod period, {DateTime? now}) {
  final local = now ?? DateTime.now();
  return ProgressQuery(
    period: period,
    timezone: local.timeZoneName,
    timezoneOffsetMinutes: local.timeZoneOffset.inMinutes,
  );
}

final progressPeriodProvider =
    NotifierProvider<ProgressPeriodNotifier, ProgressPeriod>(
      ProgressPeriodNotifier.new,
    );

class ProgressPeriodNotifier extends Notifier<ProgressPeriod> {
  @override
  ProgressPeriod build() => ProgressPeriod.thisWeek;

  void select(ProgressPeriod period) => state = period;
}

/// The report for the chosen period. Null while signed out.
final progressReportProvider = FutureProvider.autoDispose<ProgressReport?>((
  ref,
) {
  if (!ref.watch(signedInProvider)) return null;
  final period = ref.watch(progressPeriodProvider);
  return ref.watch(progressApiProvider).report(progressQuery(period));
});

final progressSettingsProvider = FutureProvider.autoDispose<ProgressSettings?>((
  ref,
) {
  if (!ref.watch(signedInProvider)) return null;
  return ref.watch(progressApiProvider).settings();
});

/// How a period reads inside a sentence, such as "Saved this week".
String periodPhrase(ProgressPeriod period) => switch (period) {
  ProgressPeriod.thisWeek => 'this week',
  ProgressPeriod.lastWeek => 'last week',
  ProgressPeriod.thisMonth => 'this month',
  ProgressPeriod.custom => 'in this period',
};

/// A rate as a whole percentage, or an em dash when there is nothing to rate.
String percentLabel(double? rate) =>
    rate == null ? '—' : '${(rate * 100).round()}%';
