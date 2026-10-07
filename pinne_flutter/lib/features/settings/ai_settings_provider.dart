import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/server_client.dart';
import 'profile_provider.dart';

final aiSettingsEndpointProvider = Provider<EndpointAiOrganizing>(
  (ref) => ref.watch(clientProvider).aiOrganizing,
);

final aiSettingsProvider =
    AsyncNotifierProvider<AiSettingsNotifier, AiSettings?>(
      AiSettingsNotifier.new,
    );

class AiSettingsNotifier extends AsyncNotifier<AiSettings?> {
  @override
  Future<AiSettings?> build() async {
    if (ref.watch(profileUserIdProvider) == null) return null;
    return ref.watch(aiSettingsEndpointProvider).getSettings();
  }

  Future<void> setEnabled(bool enabled) async {
    final previous = state;
    final settings = previous.asData?.value;
    if (settings == null) return;
    state = AsyncData(settings.copyWith(enabled: enabled));
    try {
      state = AsyncData(
        await ref.read(aiSettingsEndpointProvider).setEnabled(enabled),
      );
    } catch (error, stackTrace) {
      state = previous;
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
