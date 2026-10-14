import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/app.dart';
import 'package:pinne_flutter/core/library_revision.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/ai_suggestions.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/progress/progress_providers.dart';
import 'package:pinne_flutter/features/settings/profile_provider.dart';
import 'package:pinne_flutter/features/today/today_greeting.dart';
import 'package:pinne_flutter/features/tour/tour_store.dart';
import 'package:pinne_flutter/ui/motion.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'capture/fake_capture_server.dart';
import 'progress/fake_progress_api.dart';

final _owner = UuidValue.fromString('00000000-0000-4000-8000-0000000000dd');

class _Storage implements ClientAuthSuccessStorage {
  AuthSuccess? value = AuthSuccess(
    authStrategy: 'jwt',
    token: 'sync-token',
    authUserId: _owner,
    scopeNames: const {},
  );

  @override
  Future<AuthSuccess?> get() async => value;

  @override
  Future<void> set(AuthSuccess? data) async => value = data;
}

/// The server's idea of the library, changed by actions "elsewhere".
class _World {
  final queue = <String>['Due item'];
  var saved = 12;
  var reviewed = 7;

  Future<http.Response> handle(http.Request request) async {
    final path = request.url.path;
    Object? body;
    switch (path) {
      case '/health/emailDeliveryAvailable':
        body = true;
      case '/serverpod_auth_core.status/isSignedIn':
        body = true;
      case '/account/isGuest':
        body = false;
      case '/account/summary':
        body = AccountSummary(
          type: ProfileAccountType.email,
          email: 'sync@example.com',
          memberSince: DateTime.utc(2026, 10, 1),
        ).toJson();
      case '/profile/get':
        body = null;
      case '/reviewQueue/get':
        body = ReviewQueueResult(
          entries: [
            for (final (i, title) in queue.indexed)
              ReviewQueueEntry(
                item: Item(
                  id: UuidValue.fromString(
                    '00000000-0000-4000-8000-00000000c0d$i',
                  ),
                  ownerId: _owner,
                  title: title,
                ),
                dueAt: DateTime.utc(2026, 10, 6),
                overdueMinutes: 60,
                estimatedMinutes: 3,
                selectionReason: 'due',
              ),
          ],
          timeBudgetMinutes: 10,
        ).toJson();
      case '/exampleSaves/status':
        body = ExampleSavesStatus(
          totalItemCount: 1,
          exampleItemCount: 0,
          exampleCollectionCount: 0,
        ).toJson();
      case '/progress/report':
        body = sampleReport()
            .copyWith(savedCount: saved, reviewedInPeriodCount: reviewed)
            .toJson();
      case '/planner/sessions':
        body = <Object>[];
      case '/item/list':
        body = <Object>[];
      case '/collection/list':
        body = <Object>[];
      default:
        return http.Response('{}', 500);
    }
    return http.Response(jsonEncode(body), 200);
  }
}

class _WorldCaptureApi extends FakeCaptureServer {
  _WorldCaptureApi(this.world);

  final _World world;

  @override
  Future<CaptureResult> capture(CaptureDraft draft) async {
    final result = await super.capture(draft);
    world.saved++;
    world.queue.add('Fresh save');
    return result;
  }
}

class _FakeAi implements AiSuggestionsApi {
  _FakeAi(this.onAccept);

  final void Function() onAccept;

  @override
  Future<void> accept(UuidValue suggestionId) async => onAccept();

  @override
  Future<Map<UuidValue, String>> collectionNames() async => {};

  @override
  Future<void> reject(UuidValue suggestionId) async {}

  @override
  Future<AiSuggestionReview> review(UuidValue itemId) async =>
      AiSuggestionReview(suggestions: [], organizing: false);
}

class _Reduced extends MotionPreferenceNotifier {
  @override
  MotionPreference build() => MotionPreference.reduced;
}

void main() {
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  testWidgets('Today follows changes made on other screens without a restart', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(412, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final world = _World();
    final capture = _WorldCaptureApi(world);
    final client =
        Client(
            'http://localhost:8080/',
            httpClientOverride: MockClient(world.handle),
          )
          ..authSessionManager = FlutterAuthSessionManager(
            storage: _Storage(),
          );
    await tester.runAsync(client.auth.initialize);
    final store = CaptureStore(sqlite3.openInMemory());
    addTearDown(store.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          serverUrlProvider.overrideWithValue('http://localhost:8080/'),
          clientProvider.overrideWithValue(client),
          captureStoreProvider.overrideWithValue(store),
          captureApiProvider.overrideWithValue(capture),
          motionPreferenceProvider.overrideWith(_Reduced.new),
          tourStoreProvider.overrideWithValue(MemoryTourStore(seen: true)),
          greetingClockProvider.overrideWithValue(
            () => DateTime(2026, 10, 7, 9),
          ),
          greetingIndexPickerProvider.overrideWithValue((_) => 0),
          aiSuggestionsApiProvider.overrideWithValue(
            _FakeAi(() => world.reviewed++),
          ),
        ],
        child: const PinneApp(),
      ),
    );
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(PinneApp)),
    );

    expect(find.text('12 saved this week'), findsOneWidget);
    expect(find.text('7 reviewed'), findsOneWidget);
    expect(find.text('Due item'), findsOneWidget);

    // Saved from the share sheet or Save a link: the outbox confirms it.
    final accountId = container.read(accountIdProvider)!;
    store.save(
      parseCaptureInput('https://example.com/a'),
      accountId: accountId,
    );
    await tester.runAsync(
      () => container.read(outboxSyncProvider)!.drain(),
    );
    await tester.pumpAndSettle();
    expect(find.text('13 saved this week'), findsOneWidget);

    // A review elsewhere, then the app comes back to the foreground.
    world
      ..reviewed = 9
      ..queue.clear()
      ..queue.add('Next due');
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pumpAndSettle();
    expect(find.text('9 reviewed'), findsOneWidget);
    expect(find.text('Next due'), findsOneWidget);
    expect(find.text('Due item'), findsNothing);

    // Accepting an AI suggestion counts as a library change too.
    await tester.runAsync(
      () => container
          .read(
            aiSuggestionsProvider(
              UuidValue.fromString(
                '00000000-0000-4000-8000-00000000c0d0',
              ),
            ).notifier,
          )
          .accept('00000000-0000-4000-8000-000000000999'),
    );
    expect(container.read(libraryRevisionProvider), greaterThan(0));
    // Progress and Profile derive from the same revision.
    world.reviewed = 10;
    container.read(libraryRevisionProvider.notifier).bump();
    final report = await container.refresh(progressReportProvider.future);
    expect(report!.reviewedInPeriodCount, 10);
    final profile = await container.refresh(profileProgressProvider.future);
    expect(profile!.reviewedInPeriodCount, 10);
    await tester.pumpAndSettle();
    expect(find.text('10 reviewed'), findsOneWidget);
  });
}
