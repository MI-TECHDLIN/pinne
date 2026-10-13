import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Capture, search and the Today review.
void captureScenes() {
  shoot('02_capture', (film) async {
    final capture = DemoCaptureApi(offline: true);
    var captured = false;
    final client = DemoClient(
      items: () => captured ? Sample.items() : Sample.items().skip(1).toList(),
    );
    capture.onCaptured = (_, _) => captured = true;
    final app = FilmApp(client: client, capture: capture);
    app.router.go(Routes.today);
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
    // The article's link was copied earlier, for the paste button.
    film.tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => switch (call.method) {
        'Clipboard.getData' => {'text': Sample.sharedUrl},
        'Clipboard.hasStrings' => {'value': true},
        _ => null,
      },
    );
    final showShare = ValueNotifier(false);
    var chooserUp = 1e9;
    var chooserDown = 1e9;
    var sheetGoneAt = 1e9;
    var sourceGoneAt = 1e9;
    final guide = film.guided();
    await film.precache(spiritArt('welcome'));
    await film.precache(NetworkImage(Sample.thumb('onboarding')));
    await film.open(
      Stage(
        screen: Stack(
          fit: StackFit.expand,
          children: [
            app.widget(),
            AtTime(
              builder: (context, t, child) {
                final gone = ramp(t, sourceGoneAt, 0.5, Curves.easeInOutCubic);
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
                    ramp(t, chooserUp, 0.4) *
                    (1 - ramp(t, chooserDown, 0.3, Curves.easeInCubic));
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
                      builder: (context, t, child) {
                        final gone = ramp(t, sheetGoneAt, 0.35);
                        if (gone >= 1) return const SizedBox.shrink();
                        return IgnorePointer(
                          ignoring: t > sheetGoneAt,
                          child: Opacity(
                            opacity: 1 - gone,
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
                        );
                      },
                      child: UncontrolledProviderScope(
                        container: share,
                        child: ShareApp(
                          payload: const SharedPayload(
                            text: Sample.sharedUrl,
                            subject: Sample.sharedTitle,
                          ),
                          onDone: () => sheetGoneAt = film.t,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
    await settle(film.tester);
    await film.until(0.2);
    await guide.step(key('source-share'), 'Share from any app', zoom: 1.8);
    chooserUp = film.t;
    await film.hold(0.5);
    await guide.step(
      key('chooser-pinne'),
      'Pick Pinne in the share sheet',
      zoom: 1.7,
      hold: 1.6,
    );
    chooserDown = film.t;
    await film.hold(0.3);
    // Saved the moment the sheet opens, with the small "Saved" celebration.
    showShare.value = true;
    await film.hold(0.1);
    await guide.step(
      key('share-saved-heading'),
      'Saved instantly, with a little celebration',
      click: false,
      zoom: 1.15,
      glide: 0.7,
    );
    await guide.step(
      find.textContaining('Kept on this phone'),
      'Offline? It stays on this phone and syncs later',
      click: false,
      zoom: 1.5,
    );
    await guide.step(key('share-why'), 'Say why you saved it', zoom: 1.5);
    await film.type(key('share-why'), Sample.sharedWhy);
    await guide.step(
      key('share-done'),
      'Done takes you back to your reading',
      zoom: 1.4,
      hold: 1.6,
    );
    sourceGoneAt = film.t + 0.4;
    guide.home();
    await film.hold(1.2);
    // The same link again, from Pinne's own Save sheet above the nav.
    await guide.step(
      key('capture-entry'),
      'Or save a link right inside Pinne',
      zoom: 1.4,
    );
    await film.hold(0.4);
    await guide.step(
      find.byTooltip('Paste'),
      'Paste the same link again',
      zoom: 1.5,
    );
    await guide.step(
      key('paste-save'),
      'Saved before? Pinne says so',
      zoom: 1.5,
      hold: 2.2,
    );
    await film.until(guide.current!.end + 0.3);
    // Back online: the outbox sends the save (shown in the next scene).
    capture.comeOnline();
  });

  shoot('04_search', (film) async {
    final app = FilmApp(
      recentSearches: const ['calm onboarding', 'pill nav ideas'],
    );
    app.router.go(Routes.search);
    final guide = film.guided();
    await film.open(Stage(screen: app.widget()));
    await settle(film.tester);
    await film.until(0.3);
    await guide.step(
      find.text('Recent searches'),
      'Recent searches stay on this phone',
      click: false,
      zoom: 1.5,
    );
    final field = key('search-field');
    await guide.step(field, 'Search the way you remember it', zoom: 1.5);
    await film.type(field, 'sunday dinner', charsPerSecond: 12);
    final why = find.textContaining('Matched saved note');
    await guide.waitFor(why);
    await film.hold(0.3);
    await guide.step(
      why,
      'Every result says why it matched',
      click: false,
      zoom: 1.6,
      hold: 2.2,
    );
    await film.until(guide.current!.end + 0.3);
  });

  shoot('05_today', (film) async {
    final due = DueQueue([
      Sample.items()[0],
      Sample.items()[3],
      Sample.items()[1],
      Sample.items()[2],
    ]);
    final app = FilmApp(
      client: DemoClient(queue: due.result, onSnoozed: due.remove),
    );
    final guide = film.guided();
    await film.open(Stage(screen: app.widget()));
    await settle(film.tester);
    await film.until(0.3);
    await guide.step(
      find.text(Sample.sharedWhy),
      'Back a day later, with your note on why',
      click: false,
      zoom: 1.5,
      hold: 2.4,
    );
    await guide.step(
      key('budget-20'),
      'Got 20 minutes? The queue grows to fit',
      zoom: 1.6,
    );
    await guide.step(
      key('review-remind'),
      'Remind me later brings it back tomorrow',
      zoom: 1.5,
      hold: 2.2,
    );
    await film.until(guide.current!.end + 0.3);
  });
}

/// The server's review queue for the film: due items in order, each about
/// five minutes, as many as fit the chosen time, minus whatever was snoozed.
class DueQueue {
  DueQueue(this.items);

  final List<Item> items;

  void remove(UuidValue id) => items.removeWhere((item) => item.id == id);

  ReviewQueueResult result(int budgetMinutes) {
    final fits = items.take((budgetMinutes / 5).floor()).toList();
    return ReviewQueueResult(
      entries: [
        for (final item in fits)
          ReviewQueueEntry(
            item: item,
            dueAt: item.savedAt.add(const Duration(hours: 24)),
            overdueMinutes: 120,
            estimatedMinutes: 5,
            selectionReason: 'Due for review · about 5 min (estimate)',
          ),
      ],
      timeBudgetMinutes: budgetMinutes,
      eligibleCount: items.length,
    );
  }
}
