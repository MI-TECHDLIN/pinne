import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/share_entry.dart';
import 'package:pinne_flutter/router.dart';

import 'cards.dart';
import 'demo_server.dart';
import 'director.dart';
import 'film_app.dart';
import 'shoot.dart';
import 'stage.dart';

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

/// Capture, search and the Today review, with link previews.
void captureScenes() {
  shoot('02_capture', (film) async {
    final capture = DemoCaptureApi(offline: true);
    var captured = false;
    var listsAfterCapture = 0;
    final client = DemoClient(
      items: () {
        final rest = Sample.items().skip(1).toList();
        if (!captured) return rest;
        // The preview job is still running on the first answer, then done.
        final saved = Sample.items().first;
        final item = listsAfterCapture++ == 0
            ? saved.copyWith(
                title: 'fieldnotes.example',
                enrichmentState: EnrichmentState.pending,
                accessState: AccessState.unknown,
                thumbnailUrl: null,
                previewSiteName: null,
                previewAuthor: null,
              )
            : saved;
        return [item, ...rest];
      },
    );
    capture.onCaptured = (_, _) => captured = true;
    final app = FilmApp(client: client, capture: capture);
    app.router.go(Routes.collections);
    // The share sheet runs in its own engine on Android, over the app that
    // shared, with the same on-device store.
    final share = ProviderContainer(
      overrides: [
        serverUrlProvider.overrideWithValue('https://pinne.example/'),
        clientProvider.overrideWithValue(client),
        captureStoreProvider.overrideWithValue(app.store),
        captureApiProvider.overrideWithValue(capture),
        signedInProvider.overrideWith(_SignedIn.new),
      ],
    );
    final showShare = ValueNotifier(false);
    var sheetGoneAt = 1e9;
    await film.precache(spiritArt('welcome'));
    for (final name in ['onboarding', 'knife', 'pasta', 'navbar']) {
      await film.precache(NetworkImage(Sample.thumb(name)));
    }
    await film.open(
      Stage(
        cues: const [
          Cue(
            0.2,
            7.6,
            kicker: 'Capture',
            title: 'Share it from any app.\nSay why.',
            body:
                'Pinne saves it on your phone first, so nothing is lost, '
                'even offline.',
          ),
          Cue(
            7.9,
            15.5,
            kicker: 'Capture',
            title: 'Synced, then\nfilled in.',
            body:
                'Back online, the Serverpod server fetches a safe preview. '
                'The real title and thumbnail appear on their own.',
          ),
        ],
        phone: PhoneRig(
          poses: [
            const Pose(0),
            const Pose(3.0),
            Pose(
              3.8,
              focus: onScreen(206, 740),
              at: const Offset(1350, 600),
              scale: 1.42,
            ),
            Pose(
              7.15,
              focus: onScreen(206, 740),
              at: const Offset(1350, 600),
              scale: 1.42,
            ),
            const Pose(7.9),
            const Pose(9.3),
            Pose(
              10.2,
              focus: onScreen(206, 620),
              at: const Offset(1350, 560),
              scale: 1.32,
            ),
          ],
          screen: Stack(
            fit: StackFit.expand,
            children: [
              app.widget(),
              AtTime(
                builder: (context, t, child) {
                  final gone = ramp(t, 7.5, 0.5, Curves.easeInOutCubic);
                  if (gone >= 1) return const SizedBox.shrink();
                  return IgnorePointer(
                    ignoring: gone > 0,
                    child: Opacity(opacity: 1 - gone, child: child),
                  );
                },
                child: SourceAppPage(
                  hero: NetworkImage(Sample.thumb('onboarding')),
                ),
              ),
              AtTime(
                builder: (context, t, _) {
                  final up =
                      ramp(t, 1.05, 0.4) *
                      (1 - ramp(t, 2.45, 0.3, Curves.easeInCubic));
                  if (up <= 0) return const SizedBox.shrink();
                  return UncontrolledProviderScope(
                    container: share,
                    child: ShareChooser(progress: up),
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: showShare,
                builder: (context, visible, _) => !visible
                    ? const SizedBox.shrink()
                    : AtTime(
                        builder: (context, t, child) => IgnorePointer(
                          ignoring: t > sheetGoneAt,
                          child: Opacity(
                            opacity: 1 - ramp(t, sheetGoneAt, 0.35),
                            child: Transform.translate(
                              offset: Offset(
                                0,
                                220 *
                                    ramp(
                                      t,
                                      sheetGoneAt,
                                      0.35,
                                      Curves.easeInCubic,
                                    ),
                              ),
                              child: child,
                            ),
                          ),
                        ),
                        child: UncontrolledProviderScope(
                          container: share,
                          child: ShareApp(
                            payload: const SharedPayload(
                              text: Sample.sharedUrl,
                            ),
                            onDone: () => sheetGoneAt = film.t,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
    await settle(film.tester);
    await film.until(0.8);
    await film.tap(find.byKey(const ValueKey('source-share')));
    await film.until(2.1);
    await film.tap(find.byKey(const ValueKey('chooser-pinne')));
    await film.until(2.55);
    showShare.value = true;
    await film.until(3.7);
    await film.tap(find.byKey(const ValueKey('share-why')));
    await film.type(find.byKey(const ValueKey('share-why')), Sample.sharedWhy);
    await film.until(6.8);
    await film.tap(find.byKey(const ValueKey('share-done')));
    await film.until(8.3);
    await film.drag(
      const Offset(1350, 820),
      const Offset(0, -700),
      seconds: 0.9,
    );
    await film.until(10.6);
    capture.comeOnline();
    await film.until(12.3);
    await film.drag(
      const Offset(1350, 700),
      const Offset(0, -420),
      seconds: 0.8,
    );
    await film.until(15.5);
  });

  shoot('04_search', (film) async {
    final app = FilmApp();
    app.router.go(Routes.search);
    for (final name in ['knife', 'pasta']) {
      await film.precache(NetworkImage(Sample.thumb(name)));
    }
    await film.open(
      Stage(
        cues: const [
          Cue(
            0.2,
            12,
            kicker: 'Find',
            title: 'Find it by what\nyou remember.',
            body:
                'Search your titles, notes and tags in plain words. Every '
                'result shows why it matched.',
          ),
        ],
        phone: PhoneRig(
          poses: [
            const Pose(0),
            const Pose(3.4),
            Pose(
              4.5,
              focus: onScreen(206, 470),
              at: const Offset(1350, 520),
              scale: 1.34,
            ),
            Pose(
              8.4,
              focus: onScreen(206, 470),
              at: const Offset(1350, 520),
              scale: 1.34,
            ),
            Pose(
              9.6,
              focus: onScreen(206, 640),
              at: const Offset(1350, 520),
              scale: 1.34,
            ),
          ],
          screen: app.widget(),
        ),
      ),
    );
    await settle(film.tester);
    await film.until(0.8);
    final field = find.byKey(const ValueKey('search-field'));
    await film.tap(field);
    await film.type(field, 'sunday dinner video', charsPerSecond: 13);
    await film.until(12);
  });

  shoot('05_today', (film) async {
    final due = DueQueue([Sample.items()[0], Sample.items()[3]]);
    final app = FilmApp(
      client: DemoClient(queue: due.result, onSnoozed: due.remove),
    );
    for (final name in ['onboarding', 'navbar']) {
      await film.precache(NetworkImage(Sample.thumb(name)));
    }
    await film.open(
      Stage(
        cues: const [
          Cue(
            0.2,
            7.2,
            kicker: 'Come back',
            title: 'A day later,\nit comes back.',
            body:
                'About 24 hours after you save something, Pinne brings it '
                'back with your note on why. Lime means due now.',
          ),
          Cue(
            7.5,
            14,
            kicker: 'Come back',
            title: 'Review it, snooze it,\nor let it go.',
            body:
                'A small queue sized to the time you have. Remind me later '
                'brings it back tomorrow.',
          ),
        ],
        phone: PhoneRig(
          poses: [
            const Pose(0),
            const Pose(0.8),
            Pose(
              1.9,
              focus: onScreen(206, 400),
              at: const Offset(1350, 540),
              scale: 1.3,
            ),
            Pose(
              11.6,
              focus: onScreen(206, 400),
              at: const Offset(1350, 540),
              scale: 1.3,
            ),
            const Pose(12.6),
          ],
          screen: app.widget(),
        ),
      ),
    );
    await settle(film.tester);
    await film.until(6.9);
    await film.tap(find.byKey(const ValueKey('review-remind')));
    await film.until(14);
  });
}

/// The server's review queue for the film: due items in order, each about
/// five minutes, minus whatever was snoozed.
class DueQueue {
  DueQueue(this.items);

  final List<Item> items;

  void remove(UuidValue id) => items.removeWhere((item) => item.id == id);

  ReviewQueueResult result() => ReviewQueueResult(
    entries: [
      for (final item in items)
        ReviewQueueEntry(
          item: item,
          dueAt: item.savedAt.add(const Duration(hours: 24)),
          overdueMinutes: 120,
          estimatedMinutes: 5,
          selectionReason: 'Due for review · about 5 min (estimate)',
        ),
    ],
    timeBudgetMinutes: 10,
    eligibleCount: items.length,
  );
}
