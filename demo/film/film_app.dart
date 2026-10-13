import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinne_flutter/app.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/onboarding/onboarding_store.dart';
import 'package:pinne_flutter/features/planner/planner_providers.dart';
import 'package:pinne_flutter/features/progress/progress_providers.dart';
import 'package:pinne_flutter/features/search/search_history.dart';
import 'package:pinne_flutter/features/settings/profile_provider.dart';
import 'package:pinne_flutter/features/today/today_greeting.dart';
import 'package:pinne_flutter/features/today/today_providers.dart';
import 'package:pinne_flutter/features/tour/tour_store.dart';
import 'package:pinne_flutter/router.dart';
import 'package:sqlite3/sqlite3.dart';

import 'demo_server.dart';

class _SignedIn extends SignedInNotifier {
  _SignedIn(this.initial);
  final bool initial;

  @override
  bool build() => initial;

  void signIn() => state = true;
}

class _User extends ProfileUserId {
  @override
  String? build() => Sample.owner.uuid;
}

/// The real Pinne app (`PinneApp`, its router, shell, theme and providers),
/// signed in as the sample user, with the server answered by [DemoClient].
/// The local capture store is the app's real SQLite store, in memory.
///
/// With [firstRun] the app starts at onboarding, signed out, and the guest
/// button signs in after a short wait, as the server's anonymous sign-in
/// would; Today then opens its first-visit tour.
class FilmApp {
  FilmApp({
    DemoClient? client,
    DemoCaptureApi? capture,
    DemoProgressApi? progress,
    CaptureStore? store,
    bool firstRun = false,
    bool onboarded = false,
    List<String> recentSearches = const [],
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
        signedInProvider.overrideWith(() => _SignedIn(!firstRun)),
        onboardingStoreProvider.overrideWithValue(
          MemoryOnboardingStore(completed: !firstRun || onboarded),
        ),
        guestSignInActionProvider.overrideWithValue(() async {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          (container.read(signedInProvider.notifier) as _SignedIn).signIn();
        }),
        tourStoreProvider.overrideWithValue(MemoryTourStore(seen: !firstRun)),
        todayClockProvider.overrideWithValue(Sample.filmNow),
        greetingClockProvider.overrideWithValue(() => Sample.filmNow),
        // "Start small. Stay curious.", the same line in every scene.
        greetingIndexPickerProvider.overrideWithValue((_) => 3),
        profileUserIdProvider.overrideWith(_User.new),
        progressApiProvider.overrideWithValue(this.progress),
        plannerApiProvider.overrideWithValue(planner),
        deviceCalendarApiProvider.overrideWithValue(calendar),
        deviceIdProvider.overrideWith((ref) async => Sample.id(0xde)),
        deviceTimezoneProvider.overrideWith((ref) async => 'UTC'),
        icsSharerProvider.overrideWithValue((ics) async {}),
        openExternalUrlProvider.overrideWithValue((uri) async => true),
        searchHistoryStoreProvider.overrideWithValue(
          MemorySearchHistoryStore(recentSearches),
        ),
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
