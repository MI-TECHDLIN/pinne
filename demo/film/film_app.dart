import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinne_flutter/app.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/planner/planner_providers.dart';
import 'package:pinne_flutter/features/progress/progress_providers.dart';
import 'package:pinne_flutter/features/settings/profile_provider.dart';
import 'package:pinne_flutter/features/today/today_providers.dart';
import 'package:pinne_flutter/router.dart';
import 'package:sqlite3/sqlite3.dart';

import 'demo_server.dart';

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

class _User extends ProfileUserId {
  @override
  String? build() => Sample.owner.uuid;
}

/// The real Pinne app (`PinneApp`, its router, shell, theme and providers),
/// signed in as the sample user, with the server answered by [DemoClient].
/// The local capture store is the app's real SQLite store, in memory.
class FilmApp {
  FilmApp({
    DemoClient? client,
    DemoCaptureApi? capture,
    DemoProgressApi? progress,
    CaptureStore? store,
  }) : client = client ?? DemoClient(),
       capture = capture ?? DemoCaptureApi(),
       progress = progress ?? DemoProgressApi(),
       store = store ?? CaptureStore(sqlite3.openInMemory()) {
    container = ProviderContainer(
      overrides: [
        serverUrlProvider.overrideWithValue('https://pinne.example/'),
        clientProvider.overrideWithValue(this.client),
        captureStoreProvider.overrideWithValue(this.store),
        captureApiProvider.overrideWithValue(this.capture),
        signedInProvider.overrideWith(_SignedIn.new),
        profileUserIdProvider.overrideWith(_User.new),
        progressApiProvider.overrideWithValue(this.progress),
        plannerApiProvider.overrideWithValue(planner),
        deviceCalendarApiProvider.overrideWithValue(calendar),
        deviceIdProvider.overrideWith((ref) async => Sample.id(0xde)),
        deviceTimezoneProvider.overrideWith((ref) async => 'UTC'),
        icsSharerProvider.overrideWithValue((ics) async {}),
        openExternalUrlProvider.overrideWithValue((uri) async => true),
      ],
    );
  }

  final DemoClient client;
  final DemoCaptureApi capture;
  final DemoProgressApi progress;
  final CaptureStore store;
  final planner = DemoPlannerApi();
  final calendar = DemoDeviceCalendar();
  late final ProviderContainer container;

  GoRouter get router => container.read(routerProvider);

  Widget widget() =>
      UncontrolledProviderScope(container: container, child: const PinneApp());

  void dispose() {
    container.dispose();
    store.close();
  }
}
