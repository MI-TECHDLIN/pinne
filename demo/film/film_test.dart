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
import 'tour.dart';

void main() {
  setUpFilm();
  captureScenes();

  shoot('01_hook', (film) async {
    final app = FilmApp(
      freshGuest: true,
      client: DemoClient(displayName: '', guest: true),
    );
    // The screen waits below the canvas while saves pile up and the
    // bookmarks comparison plays, then rises in beside the name with the
    // first-visit tour of a new guest.
    final guide = film.guided(
      const Shot(Offset(206, 446), Offset(1350, 1700), 1),
    );
    guide.camera.move(Shot.home(1350), start: 15.3, seconds: 1.1);
    await film.precache(spiritArt('welcome'));
    await film.open(Stage(extra: [HookCard()], screen: app.widget()));
    await settle(film.tester);
    await film.until(18.3);
    await guide.waitFor(key('tour-next'));
    await film.hold(0.6);
    await guide.step(
      key('tour-next'),
      'A short first-run tour shows you around',
      zoom: 1.4,
    );
    await film.until(guide.current!.end + 0.3);
  });

  shoot('03_organize', (film) async {
    final capture = DemoCaptureApi(offline: true);
    final app = FilmApp(capture: capture);
    // The article shared in the capture scene, still on the phone. The
    // server organizes it as part of the save, so its AI suggestions come
    // with the sync.
    final saved = app.store.save(
      parseCaptureInput(Sample.sharedUrl, subject: Sample.sharedTitle),
      intention: Sample.sharedWhy,
    );
    app.router.go(Routes.collections);
    final guide = film.guided();
    await film.open(Stage(screen: app.widget()));
    await settle(film.tester, 2);
    // The Saved list sits below the collections.
    await Scrollable.ensureVisible(
      film.tester.element(key('saved-${saved.clientItemId}')),
      alignment: 0.12,
    );
    await settle(film.tester, 0.5);
    await film.until(0.3);
    await guide.step(
      find.text('On phone · syncing'),
      'Back online, it syncs exactly once',
      click: false,
      zoom: 1.6,
    );
    capture.comeOnline();
    final first = key('accept-${_sid}f1');
    await guide.waitFor(first);
    await film.hold(0.4);
    // Up to the card's suggestions, as a person scrolls.
    await guide.drag(
      find.text('Synced'),
      Offset(0, -(guide.appRect(first).center.dy - 560)),
      shot: Shot.home(),
    );
    await film.hold(0.2);
    await guide.step(
      key('accept-${_sid}f1'),
      'AI suggests a collection. You decide.',
      zoom: 1.5,
    );
    await guide.step(key('accept-${_sid}f2'), 'Keep the tags that fit');
    await guide.step(
      key('accept-${_sid}f4'),
      'Add the short summary in one tap',
    );
    await guide.step(
      key('dismiss-${_sid}f3'),
      '“Maybe” marks a guess. Dismiss it.',
    );
    await guide.step(
      key('saved-summary'),
      'The AI never overwrites your choices',
      click: false,
      zoom: 1.4,
    );
    await film.until(guide.current!.end + 0.3);
  });

  shoot('06_planner', (film) async {
    final app = FilmApp();
    app.router.go(Routes.planner);
    final guide = film.guided();
    await film.open(Stage(screen: app.widget()));
    await settle(film.tester, 2);
    await film.until(0.3);
    await guide.step(
      button('Plan my week'),
      'Plan my week finds free slots',
      zoom: 1.5,
    );
    final checked = find.textContaining('Checked your busy times');
    await guide.waitFor(checked);
    await guide.step(
      checked,
      'It tells you exactly what it checked',
      click: false,
      zoom: 1.6,
      hold: 2.4,
    );
    await guide.drag(checked, const Offset(0, -380), shot: Shot.home());
    await film.hold(0.3);
    await guide.step(
      button('Accept plan'),
      'Accept, and the sessions go in your calendar',
      zoom: 1.4,
    );
    await film.until(guide.current!.end + 0.3);
  });

  shoot('07_progress', (film) async {
    final progress = DemoProgressApi();
    final due = DueQueue([Sample.items()[3]]);
    final app = FilmApp(
      progress: progress,
      client: DemoClient(
        displayName: '',
        guest: true,
        queue: due.result,
        onReviewed: (draft) {
          if (draft.eventType != ReviewEventType.reviewed) return;
          due.remove(draft.itemId);
          progress.reviewRecorded();
        },
      ),
    );
    app.router.go(Routes.progress);
    final guide = film.guided();
    await film.open(Stage(screen: app.widget()));
    await settle(film.tester);
    await film.until(0.3);
    await guide.step(
      key('progress-stack-top'),
      'Opening isn’t reviewing: only reviews count',
      click: false,
      zoom: 1.2,
      hold: 2.2,
    );
    await guide.drag(
      key('progress-stack-top'),
      const Offset(-260, 20),
      seconds: 0.32,
      curve: Curves.easeIn,
    );
    await guide.step(key('nav-today'), 'Back to Today’s save', zoom: 1.5);
    await guide.step(
      key('review-reviewed'),
      'Mark it reviewed',
      zoom: 1.5,
      hold: 1.6,
    );
    await guide.waitFor(key('celebration-continue'));
    await guide.step(
      key('celebration-continue'),
      'Milestones get a celebration, just once',
      zoom: 1.2,
      hold: 2.0,
    );
    await guide.step(
      key('today-profile'),
      'Tap your spirit for your profile',
      zoom: 1.6,
    );
    final signIn = key('profile-sign-in');
    await guide.waitFor(signIn);
    await guide.step(
      signIn,
      'A guest now. Sign in whenever you like.',
      click: false,
      zoom: 1.5,
      hold: 2.0,
    );
    await film.until(guide.current!.end + 0.3);
  });

  shoot('08_serverpod', (film) async {
    await film.open(const Stage(extra: [ServerpodCard()]));
    await film.until(16.6);
  });

  shoot('09_close', (film) async {
    await film.precache(spiritArt('happy'));
    await film.open(const Stage(extra: [CloseCard()]));
    await film.until(7);
  });
}

/// The start of the sample AI suggestion ids, `Sample.id(0xf1)` and on.
const _sid = '00000000-0000-4000-8000-0000000000';
