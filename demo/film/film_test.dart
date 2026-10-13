// Scenes filmed from origin/main. Run through demo/tool/render.sh.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/router.dart';

import 'capture_scenes.dart';
import 'cards.dart';
import 'demo_server.dart';
import 'film_app.dart';
import 'shoot.dart';
import 'stage.dart';

void main() {
  setUpFilm();
  captureScenes();

  shoot('01_hook', (film) async {
    final app = FilmApp(firstRun: true, client: DemoClient(displayName: ''));
    await film.precache(spiritArt('welcome'));
    await film.open(
      Stage(
        extra: [HookCard()],
        phone: PhoneRig(
          poses: [
            const Pose(0, at: Offset(1350, 1700)),
            const Pose(5.4, at: Offset(1350, 1700)),
            const Pose(6.6),
            const Pose(9.5),
            Pose(
              10.2,
              focus: onScreen(206, 330),
              at: const Offset(1350, 540),
              scale: 1.3,
            ),
            Pose(
              11.3,
              focus: onScreen(206, 330),
              at: const Offset(1350, 540),
              scale: 1.3,
            ),
            // The tour's welcome, then its spotlight on "Save a link".
            Pose(
              12.3,
              focus: onScreen(206, 470),
              at: const Offset(1350, 540),
              scale: 1.25,
            ),
            Pose(
              13.9,
              focus: onScreen(206, 470),
              at: const Offset(1350, 540),
              scale: 1.25,
            ),
            Pose(
              14.5,
              focus: onScreen(206, 400),
              at: const Offset(1350, 520),
              scale: 1.25,
            ),
          ],
          screen: app.widget(),
        ),
      ),
    );
    await settle(film.tester);
    await film.until(9.1);
    await film.tap(find.byKey(const ValueKey('onboarding-skip')));
    await film.until(10.6);
    await film.tap(find.byKey(const ValueKey('guest-sign-in-button')));
    await film.until(13.5);
    await film.tap(find.byKey(const ValueKey('tour-next')));
    await film.until(16);
  });

  shoot('03_organize', (film) async {
    final app = FilmApp();
    // The article shared in the capture scene, saved and synced. The server
    // organized it during the save, so its AI suggestions are waiting.
    final saved = app.store.save(
      parseCaptureInput(Sample.sharedUrl, subject: Sample.sharedTitle),
      intention: Sample.sharedWhy,
    );
    app.router.go(Routes.collections);
    await film.open(
      Stage(
        cues: const [
          Cue(
            0.2,
            7.4,
            kicker: 'Organize',
            title: 'AI suggests.\nYou decide.',
            body:
                'Groq suggests a collection, tags and a short summary on '
                'the server. Nothing changes until you accept.',
          ),
          Cue(
            7.7,
            13.5,
            kicker: 'Organize',
            title: 'You stay\nin control.',
            body:
                'Accept what fits, dismiss what doesn’t. The AI never '
                'overwrites your choices.',
          ),
        ],
        phone: PhoneRig(
          poses: [
            const Pose(0),
            const Pose(0.6),
            Pose(
              1.6,
              focus: onScreen(206, 560),
              at: const Offset(1350, 560),
              scale: 1.4,
            ),
            Pose(
              7.2,
              focus: onScreen(206, 560),
              at: const Offset(1350, 560),
              scale: 1.4,
            ),
            // The card shortens as chips go; follow it to the summary.
            Pose(
              8.2,
              focus: onScreen(206, 720),
              at: const Offset(1350, 600),
              scale: 1.4,
            ),
          ],
          screen: app.widget(),
        ),
      ),
    );
    await settle(film.tester);
    // Online: the outbox sends the save.
    app.capture.comeOnline();
    await settle(film.tester, 2);
    // Sent before the Saved list began listening; refresh it as the app
    // does when it returns to the foreground.
    app.store.notifyExternalChange();
    await settle(film.tester, 2);
    // The Saved list sits below the collections.
    await Scrollable.ensureVisible(
      film.tester.element(find.byKey(ValueKey('saved-${saved.clientItemId}'))),
      alignment: 0.12,
    );
    await settle(film.tester, 0.5);
    await film.until(2.6);
    await film.tap(find.byKey(const ValueKey('accept-${_sid}f1')));
    await film.until(4.0);
    await film.tap(find.byKey(const ValueKey('accept-${_sid}f2')));
    await film.until(5.4);
    await film.tap(find.byKey(const ValueKey('dismiss-${_sid}f3')));
    await film.until(6.8);
    await film.tap(find.byKey(const ValueKey('accept-${_sid}f4')));
    await film.until(13.5);
  });

  shoot('06_planner', (film) async {
    final app = FilmApp();
    app.router.go(Routes.planner);
    await film.open(
      Stage(
        cues: const [
          Cue(
            0.2,
            10,
            kicker: 'Make time',
            title: 'It finds time\nfor you.',
            body:
                'Pinne reads your busy times on the phone, then proposes '
                'short review sessions only in free time it has checked.',
          ),
        ],
        phone: PhoneRig(
          poses: [
            const Pose(0),
            const Pose(1.4),
            Pose(
              2.3,
              focus: onScreen(206, 300),
              at: const Offset(1350, 520),
              scale: 1.45,
            ),
            Pose(
              3.8,
              focus: onScreen(206, 300),
              at: const Offset(1350, 520),
              scale: 1.45,
            ),
            Pose(
              4.6,
              focus: onScreen(206, 410),
              at: const Offset(1350, 560),
              scale: 1.45,
            ),
            Pose(
              5.6,
              focus: onScreen(206, 410),
              at: const Offset(1350, 560),
              scale: 1.45,
            ),
            const Pose(6.3),
            const Pose(7.2),
            Pose(
              8.0,
              focus: onScreen(206, 560),
              at: const Offset(1350, 560),
              scale: 1.4,
            ),
          ],
          screen: app.widget(),
        ),
      ),
    );
    await settle(film.tester, 2);
    await film.until(0.7);
    await film.tap(find.text('Plan my week'));
    await film.until(6.4);
    await film.drag(
      const Offset(1350, 860),
      const Offset(0, -460),
      seconds: 0.8,
    );
    await film.until(8.5);
    await film.tap(find.text('Accept plan'));
    await film.until(10);
  });

  shoot('07_progress', (film) async {
    final progress = DemoProgressApi();
    final due = DueQueue([Sample.items()[3]]);
    final app = FilmApp(
      progress: progress,
      client: DemoClient(
        queue: due.result,
        onReviewed: (draft) {
          if (draft.eventType != ReviewEventType.reviewed) return;
          due.remove(draft.itemId);
          progress.reviewRecorded();
        },
      ),
    );
    app.router.go(Routes.progress);
    await film.open(
      Stage(
        cues: const [
          Cue(
            0.2,
            4.6,
            kicker: 'Progress',
            title: 'Honest progress.',
            body:
                'Numbers come only from real reviews. Opening a link or '
                'undoing never counts, and an empty week shows a dash, not 0%.',
          ),
          Cue(
            4.9,
            9.9,
            kicker: 'Progress',
            title: 'Milestones get\na celebration.',
            body:
                'Review your 25th save and your Ribbon Spirit celebrates '
                'with you. Once, never nagging.',
          ),
          Cue(
            10.2,
            13,
            kicker: 'Profile',
            title: 'Your spirit,\nyour totals.',
            body:
                'Tap your Ribbon Spirit for your profile: account, saves '
                'and reviews in one place.',
          ),
        ],
        phone: PhoneRig(
          poses: [
            const Pose(0),
            const Pose(0.6),
            Pose(
              1.4,
              focus: onScreen(206, 420),
              at: const Offset(1350, 520),
              scale: 1.3,
            ),
            Pose(
              3.5,
              focus: onScreen(206, 420),
              at: const Offset(1350, 520),
              scale: 1.3,
            ),
            const Pose(4.2),
            const Pose(4.8),
            Pose(
              5.5,
              focus: onScreen(206, 330),
              at: const Offset(1350, 540),
              scale: 1.3,
            ),
            Pose(
              6.2,
              focus: onScreen(206, 330),
              at: const Offset(1350, 540),
              scale: 1.3,
            ),
            Pose(
              7.0,
              focus: onScreen(206, 446),
              at: const Offset(1350, 540),
              scale: 1.15,
            ),
            Pose(
              9.6,
              focus: onScreen(206, 446),
              at: const Offset(1350, 540),
              scale: 1.15,
            ),
            const Pose(10.2),
            Pose(
              10.9,
              focus: onScreen(206, 300),
              at: const Offset(1350, 520),
              scale: 1.3,
            ),
          ],
          screen: app.widget(),
        ),
      ),
    );
    await settle(film.tester);
    // The middle of the top card, found once while it is on top.
    final deck =
        film.tester.getCenter(find.text('Reviewed this week').first) +
        const Offset(70, 110);
    for (final at in [1.6, 2.8]) {
      await film.until(at);
      await film.drag(
        deck,
        const Offset(-330, 30),
        seconds: 0.32,
        curve: Curves.easeIn,
      );
    }
    await film.until(4.3);
    await film.tap(find.byKey(const ValueKey('nav-today')));
    await film.until(5.7);
    await film.tap(find.byKey(const ValueKey('review-reviewed')));
    await film.until(9.5);
    await film.tap(find.byKey(const ValueKey('celebration-continue')));
    await film.until(10.1);
    await film.tap(find.byKey(const ValueKey('today-profile')));
    await film.until(13);
  });

  shoot('08_serverpod', (film) async {
    await film.open(const Stage(extra: [ServerpodCard()]));
    await film.until(15);
  });

  shoot('09_close', (film) async {
    await film.precache(spiritArt('happy'));
    await film.open(const Stage(extra: [CloseCard()]));
    await film.until(7);
  });
}

/// The start of the sample AI suggestion ids, `Sample.id(0xf1)` and on.
const _sid = '00000000-0000-4000-8000-0000000000';
