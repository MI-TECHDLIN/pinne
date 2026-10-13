// Scenes filmed from origin/main. Run through demo/tool/render.sh.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/router.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';
import 'package:pinne_flutter/ui/ai_suggestion_chips.dart';

import 'capture_scenes.dart';
import 'cards.dart';
import 'demo_server.dart';
import 'director.dart';
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
            const Pose(4.7, at: Offset(1350, 1700)),
            const Pose(5.9),
            const Pose(8.3),
            Pose(
              9.0,
              focus: onScreen(206, 330),
              at: const Offset(1350, 540),
              scale: 1.3,
            ),
            Pose(
              10.2,
              focus: onScreen(206, 330),
              at: const Offset(1350, 540),
              scale: 1.3,
            ),
            const Pose(10.9),
          ],
          screen: app.widget(),
        ),
      ),
    );
    await settle(film.tester);
    await film.until(7.9);
    await film.tap(find.byKey(const ValueKey('onboarding-skip')));
    await film.until(9.4);
    await film.tap(find.byKey(const ValueKey('guest-sign-in-button')));
    await film.until(11.5);
  });

  shoot('03_organize', (film) async {
    final app = FilmApp();
    app.router.go(Routes.settings);
    final panel = GlobalKey<_SuggestionPanelState>();
    await film.open(
      Stage(
        captionTop: 120,
        captionWidth: 760,
        cues: const [
          Cue(
            0.2,
            12.5,
            kicker: 'Organize',
            title: 'Gemini suggests.\nYou decide.',
            body:
                'A collection, tags and a short summary, made on the server. '
                'Nothing changes until you accept.',
          ),
        ],
        phone: PhoneRig(
          poses: const [
            Pose(0, at: Offset(1440, 540)),
            Pose(0.6, at: Offset(1440, 540)),
            Pose(
              1.8,
              focus: Offset(219, 620),
              at: Offset(1440, 862),
              scale: 1.45,
            ),
          ],
          screen: app.widget(),
        ),
        extra: [
          Positioned(
            left: 130,
            top: 520,
            width: 720,
            height: 500,
            child: AtTime(
              builder: (context, t, child) => fadeRise(t, 1.4, child!, dy: 40),
              child: Transform.scale(
                scale: 1.3,
                alignment: Alignment.topLeft,
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  minWidth: 0,
                  minHeight: 0,
                  maxWidth: 720 / 1.3,
                  maxHeight: 500 / 1.3,
                  child: _SuggestionPanel(key: panel),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    await settle(film.tester);
    // The AI card sits below the fold on Settings.
    await Scrollable.ensureVisible(
      film.tester.element(find.text('AI organizing')),
      alignment: 0.15,
    );
    await settle(film.tester, 0.3);
    await film.until(4.0);
    await film.tap(find.byKey(const ValueKey('accept-collection')));
    await film.until(5.6);
    await film.tap(find.byKey(const ValueKey('accept-tag-onboarding')));
    await film.until(7.2);
    await film.tap(find.byKey(const ValueKey('dismiss-tag-ux')));
    await film.until(8.8);
    await film.tap(find.byKey(const ValueKey('accept-summary')));
    await film.until(12.5);
  });

  shoot('06_planner', (film) async {
    final app = FilmApp();
    app.router.go(Routes.planner);
    await film.open(
      Stage(
        cues: const [
          Cue(
            0.2,
            12,
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
            const Pose(1.8),
            Pose(
              2.8,
              focus: onScreen(206, 300),
              at: const Offset(1350, 520),
              scale: 1.45,
            ),
            Pose(
              4.6,
              focus: onScreen(206, 300),
              at: const Offset(1350, 520),
              scale: 1.45,
            ),
            Pose(
              5.6,
              focus: onScreen(206, 410),
              at: const Offset(1350, 560),
              scale: 1.45,
            ),
            Pose(
              7.0,
              focus: onScreen(206, 410),
              at: const Offset(1350, 560),
              scale: 1.45,
            ),
            const Pose(7.8),
            const Pose(8.9),
            Pose(
              9.8,
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
    await film.until(1.0);
    await film.tap(find.text('Plan my week'));
    await film.until(8.0);
    await film.drag(
      const Offset(1350, 860),
      const Offset(0, -460),
      seconds: 0.8,
    );
    await film.until(10.4);
    await film.tap(find.text('Accept plan'));
    await film.until(12);
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
            7.6,
            kicker: 'Progress',
            title: 'Honest progress.',
            body:
                'Numbers come only from real reviews. Opening a link or '
                'undoing never counts, and an empty week shows a dash, not 0%.',
          ),
          Cue(
            7.9,
            14.5,
            kicker: 'Progress',
            title: 'Milestones get\na celebration.',
            body:
                'Review your 25th save and your Ribbon Spirit celebrates '
                'with you. Once, never nagging.',
          ),
        ],
        phone: PhoneRig(
          poses: [
            const Pose(0),
            const Pose(0.8),
            Pose(
              1.8,
              focus: onScreen(206, 420),
              at: const Offset(1350, 520),
              scale: 1.3,
            ),
            Pose(
              5.6,
              focus: onScreen(206, 420),
              at: const Offset(1350, 520),
              scale: 1.3,
            ),
            const Pose(6.5),
            const Pose(7.6),
            Pose(
              8.4,
              focus: onScreen(206, 330),
              at: const Offset(1350, 540),
              scale: 1.3,
            ),
            Pose(
              9.2,
              focus: onScreen(206, 330),
              at: const Offset(1350, 540),
              scale: 1.3,
            ),
            Pose(
              10.2,
              focus: onScreen(206, 446),
              at: const Offset(1350, 540),
              scale: 1.15,
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
    await film.until(2.4);
    await film.drag(
      deck,
      const Offset(-330, 30),
      seconds: 0.32,
      curve: Curves.easeIn,
    );
    await film.until(3.8);
    await film.drag(
      deck,
      const Offset(-330, 30),
      seconds: 0.32,
      curve: Curves.easeIn,
    );
    await film.until(5.2);
    await film.drag(
      deck,
      const Offset(-330, 30),
      seconds: 0.32,
      curve: Curves.easeIn,
    );
    await film.until(7.4);
    await film.tap(find.byKey(const ValueKey('nav-today')));
    await film.until(8.8);
    await film.tap(find.byKey(const ValueKey('review-reviewed')));
    await film.until(14.5);
  });

  shoot('08_serverpod', (film) async {
    await film.open(const Stage(extra: [ServerpodCard()]));
    await film.until(12);
  });

  shoot('09_close', (film) async {
    await film.precache(spiritArt('happy'));
    await film.open(const Stage(extra: [CloseCard()]));
    await film.until(7);
  });
}

/// Hosts the app's real [AiSuggestionChips] with suggestions shaped like the
/// server's `AiSuggestion` rows for the item saved in the capture scene.
class _SuggestionPanel extends StatefulWidget {
  const _SuggestionPanel({super.key});

  @override
  State<_SuggestionPanel> createState() => _SuggestionPanelState();
}

class _SuggestionPanelState extends State<_SuggestionPanel> {
  final _pending = <AiSuggestionChipData>[
    const AiSuggestionChipData(
      id: 'collection',
      label: 'Collection: App ideas',
    ),
    const AiSuggestionChipData(id: 'tag-onboarding', label: 'Tag: onboarding'),
    const AiSuggestionChipData(
      id: 'tag-ux',
      label: 'Tag: ux writing',
      uncertain: true,
    ),
    const AiSuggestionChipData(
      id: 'summary',
      label: 'Summary: Seven gentle first-run patterns',
    ),
  ];
  final _log = <String>[];

  void _resolve(String id, bool accepted) {
    final chip = _pending.firstWhere((c) => c.id == id);
    setState(() {
      _pending.remove(chip);
      _log.add('${accepted ? 'Accepted' : 'Dismissed'} ${chip.label}');
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    color: Colors.transparent,
    theme: pinneDarkTheme(),
    home: Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.topLeft,
        child: GlassPanel(
          tint: const Color(0xCC1D1633),
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI SUGGESTIONS · APP CHIP COMPONENT',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: PinneColors.lilac,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                Sample.sharedTitle,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: PinneColors.text,
                ),
              ),
              const SizedBox(height: 14),
              AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topLeft,
                child: AiSuggestionChips(
                  suggestions: List.of(_pending),
                  onAccept: (id) => _resolve(id, true),
                  onDismiss: (id) => _resolve(id, false),
                ),
              ),
              if (_log.isNotEmpty) const SizedBox(height: 12),
              for (final line in _log)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        line.startsWith('Accepted')
                            ? Icons.check_rounded
                            : Icons.close_rounded,
                        size: 18,
                        color: line.startsWith('Accepted')
                            ? PinneColors.violet
                            : PinneColors.muted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        line,
                        style: TextStyle(
                          color: line.startsWith('Accepted')
                              ? PinneColors.text
                              : PinneColors.muted,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
