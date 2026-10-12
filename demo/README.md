# Demo film

The hackathon demo video, as code. Every app shot is the real Pinne app on
this checkout, running live inside a drawn phone frame and filmed frame by
frame. Shot list and captions: [storyboard.md](storyboard.md).

## Render it

```bash
pip install imageio-ffmpeg numpy pillow   # or have ffmpeg on PATH
demo/tool/render.sh                       # every scene, then out/pinne-demo.mp4
demo/tool/render.sh --preview 05_today    # PNG stills every 0.5 s, one scene
demo/tool/render.sh --assemble --voiceover voiceover.m4a   # re-join only
```

Output goes to `$FILM_OUT` (default `demo/out/`, git-ignored): one segment
per scene in `segments/`, then `pinne-demo.mp4` and `pinne-demo-silent.mp4`.
Without a voiceover the film carries the music bed; with `--voiceover`
(or `FILM_VOICEOVER`) it carries the narration, loudness-normalised, with no
music under it (`--bed` adds the music far below the voice), and the closing
card holds until the narration ends. A full render takes about half an hour
on two cores; `--assemble` takes a minute.

## How it works

- `film/film_test.dart` and `film/capture_scenes.dart` are widget tests, one
  per scene. Each pumps the real `PinneApp` (router, shell, theme, providers)
  one 30 fps frame at a time, taps, drags and types into it like a person,
  captures the whole 1920x1080 stage and pipes raw frames to ffmpeg
  (`film/director.dart`).
- The phone frame, captions, touch markers and title cards are the film's own
  drawing (`film/stage.dart`, `film/cards.dart`). No device artwork or
  third-party marks: content tiles use plain Material icons, the source app
  and share chooser are generic, and sample links use the reserved
  `.example` domain.
- The app is signed in as a sample user (the hook starts signed out at
  onboarding and signs in as a guest). Its local capture store is the real
  SQLite store, in memory. The phone's clock for Today and Progress is
  pinned to Thursday of the render week, so the week has days behind it;
  the Planner's calendar still shows the real date. Server answers come from `film/demo_server.dart`,
  which mirrors the server's rules: keyword search with the same evidence
  fields, the planner placing sessions with the shared `planSlots` over the
  busy times the phone sent, cohort-based progress numbers.
- Fonts: `tool/fetch_fonts.py` downloads the exact Outfit and Plus Jakarta
  Sans files (SIL OFL 1.1) that the app's `google_fonts` would fetch, into
  `.cache/` (git-ignored); the film serves them to the app.
- `tool/film_engine.sh` points `flutter test` at the SDK's own engine through
  a wrapper that drops `--use-test-fonts`. Without it, text whose style names
  no font (Pinne's button labels) renders as test-font boxes; with it, that
  text falls back to Roboto as on an Android phone.
- Thumbnails (`assets/thumbs/`) are abstract images drawn by
  `tool/make_thumbs.py`. The music bed is synthesised by `tool/make_music.py`
  (no samples). The Ribbon Spirit stills come from
  `pinne_flutter/assets/art/cutout/` (see `docs/ai-art/`).

## What is real and what is drawn

| Shot | Real app code | Film drawing |
| --- | --- | --- |
| Hook | Onboarding, sign-in screen, guest Today; Ribbon Spirit art | Content tiles, title |
| Serverpod card, close | Ribbon Spirit art from the repo | Everything else |
| Capture | Share sheet, local store, outbox sync, Collections tab, preview states | Source reading app, share chooser |
| Organize | Settings screen, `AiSuggestionChips` | The panel hosting the chips |
| Search, Today, Planner, Progress, celebration | Whole screen | Phone frame only |

The film runs a debug build in a test engine, so it has no OS keyboard and
the status bar is drawn.

## Known app gaps the film shows

- `AiSuggestionChips` is not placed on any screen yet, so the Organize shot
  shows the real widget in a panel labelled "App chip component" next to the
  real Settings screen.

Fixed on `main` since the first cut and verified in this render: the source
and duration chips are readable on pastel and lime cards, and the lime card's
Reviewed button has an ink fill.
