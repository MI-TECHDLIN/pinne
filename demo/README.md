# Demo film

The hackathon demo video, as code. Every app shot is the real Pinne app on
this checkout, running live inside a drawn phone frame and filmed frame by
frame. Shot list and captions: [storyboard.md](storyboard.md). Narration
script, one paragraph per beat: [narration.txt](narration.txt).

## Render it

```bash
pip install imageio-ffmpeg numpy pillow   # or have ffmpeg on PATH
demo/tool/render.sh                       # every scene, then out/pinne-demo.mp4
demo/tool/render.sh --preview 05_today    # PNG stills every 0.5 s, one scene
demo/tool/render.sh --assemble --voiceover voiceover.mp3   # re-join only
```

Output goes to `$FILM_OUT` (default `demo/out/`, git-ignored): one segment
per scene in `segments/`, then `pinne-demo.mp4` and `cut.json` (where each
scene starts). A full render takes about half an hour on two cores;
`--assemble` takes a minute or two.

Without a voiceover, `pinne-demo.mp4` runs 1:45.5 with the music bed. With
`--voiceover FILE` (or `FILM_VOICEOVER`), the recording of `narration.txt`
is split into its scene paragraphs at the pauses between them, and every
scene is trimmed into its spare footage (each is filmed 1.5 s past its
planned end) or held on its last frame to fit its paragraph, never cut
before its last essential moment. `pinne-demo.mp4` then carries the voice,
loudness-normalised, with the music ducked low under it (`--no-bed`: voice
only), and `pinne-demo-silent.mp4` the same cut with the music alone. If a
paragraph break is detected in the wrong place, `cut.json` shows it;
`--cues 14.2,27.0,...` gives the voiceover times where scenes 2 to 9 begin.
The film never reaches 2:00; a narration too long for that is sped up by
at most 1.2x.

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
- The hook starts signed out at onboarding, signs in as a guest and opens
  the first-visit tour; the other scenes are signed in as a sample user. The
  local capture store is the real SQLite store, in memory. The phone's clock
  for Today, its greeting and Progress is pinned to Thursday of the render
  week, so the week has days behind it; the Planner's calendar still shows
  the real date.
- Server answers come from `film/demo_server.dart`, which mirrors the
  server as deployed on Serverpod Cloud Starter: no future calls, so saves
  get no link preview ("Preview not available. The link is saved.") and AI
  organizing has already run during the save; suggestions are accepted or
  dismissed like `AiOrganizingEndpoint` does. Search uses the same evidence
  fields, the planner places sessions with the shared `planSlots` over the
  busy times the phone sent, and progress numbers are cohort-based. Answers
  take a short round trip, so the app's loading skeletons show.
- Fonts: the Outfit and Plus Jakarta Sans files the app bundles
  (`pinne_flutter/assets/fonts/`, SIL OFL 1.1).
- `tool/film_engine.sh` points `flutter test` at the SDK's own engine through
  a wrapper that drops `--use-test-fonts`. Without it, text whose style names
  no font (Pinne's button labels) renders as test-font boxes; with it, that
  text falls back to Roboto as on an Android phone.
- The drawn reading app's hero image (`assets/thumbs/onboarding.png`) is
  abstract art drawn by `tool/make_thumbs.py`. The music bed is synthesised
  by `tool/make_music.py` (no samples). The Ribbon Spirit stills come from
  `pinne_flutter/assets/art/cutout/` (see `docs/ai-art/`).

## What is real and what is drawn

| Shot | Real app code | Film drawing |
| --- | --- | --- |
| Hook | Onboarding, sign-in screen, guest Today, Today tour; Ribbon Spirit art | Content tiles, title |
| Capture | Share sheet, local store, outbox sync, Collections tab, Saved card with AI suggestions | Source reading app, share chooser |
| Organize | Saved card, `SavedItemAiSuggestions` accepting and dismissing | Phone frame only |
| Search, Today, Planner, Progress, celebration, Profile | Whole screen | Phone frame only |
| Serverpod card, close | Ribbon Spirit art from the repo | Everything else |

The film runs a debug build in a test engine, so it has no OS keyboard and
the status bar is drawn.
