# Demo film

The hackathon demo video, as code: a guided tour of the real Pinne app.
Every app shot is the real app on this checkout, filmed frame by frame and
placed on the canvas as a bare screen (no device frame). A camera eases
toward each step (never past 2x), a cursor glides onto the exact element
and clicks it, and one short callout beside it says what the step does.
Shot list: [storyboard.md](storyboard.md). Narration, one paragraph per
beat: [narration.txt](narration.txt). Where the cursor lands, step by step:
[cursor-coordinates.md](cursor-coordinates.md).

## Render it

```bash
pip install imageio-ffmpeg numpy pillow   # or have ffmpeg on PATH
demo/tool/render.sh                       # every scene, then out/pinne-demo.mp4
demo/tool/render.sh --preview 05_today    # PNG stills every 0.5 s, one scene
demo/tool/render.sh --assemble --voiceover voiceover.mp3   # re-join only
```

Output goes to `$FILM_OUT` (default `demo/out/`, git-ignored): one segment
per scene in `segments/`, each app scene's steps in `coords/`, then
`pinne-demo.mp4`, `cut.json` (scene starts, voice cues, clicks, loudness)
and `cursor-coordinates.md`. A full render takes about half an hour on two
cores; `--assemble` takes a few minutes.

With `--voiceover FILE` (or `FILM_VOICEOVER`), the recording of
`narration.txt` is split at the pauses between paragraphs into the blocks
`SCENES` in `tool/assemble.py` lists, and each block starts at its own
moment in its scene, so a line lands on what it describes (the hook's last
line waits for the bookmarks card). A scene runs as long as its footage or
its narration needs: it is trimmed into its spare footage (each scene is
filmed 1.5 s past its last step) or held on its last frame. If a paragraph
break is detected in the wrong place, `cut.json` shows it; `--cues` gives
the voiceover times where the blocks after the first begin (nine: "This is
Pinne", then scenes 2 to 9). The film never reaches 2:00.

`pinne-demo.mp4` carries the voice and the music bed; `pinne-demo-silent.mp4`
the same cut with the music alone. The bed (`tool/make_music.py`) is
synthesised here, no samples: a slow D major pad, sparse felt-piano notes
and a light low pulse at 72 bpm that lifts for the Serverpod scene and
resolves on the tonic as the close begins. It sits about 9 LU under the
voice and dips further while the voice speaks (sidechain ducking), so it is
heard mainly in the pauses. Soft synthesised clicks mark the cursor's
clicks. The mix is normalised to -16 LUFS integrated, -1.5 dBTP; the
music-only cut to -18 LUFS.

## How it works

- `film/film_test.dart` and `film/capture_scenes.dart` are widget tests, one
  per scene. Each pumps the real `PinneApp` (router, shell, theme, providers)
  one 30 fps frame at a time, clicks, drags and types into it like a person,
  captures the whole 1920x1080 canvas and pipes raw frames to ffmpeg
  (`film/director.dart`).
- `film/tour.dart` is the guided tour. Each step finds its target in the
  widget tree (by key, text or tooltip), frames it with the camera, glides
  the cursor to its centre and clicks there with a real gesture. The render
  fails if the cursor point is not inside the target's rect at click time,
  if the target is not fully on the canvas, if a callout covers its target
  or leaves the canvas, if two callouts would show at once, or if a callout
  is shown for less than 1.6 s. Every step is written to `coords/` and
  listed in `cursor-coordinates.md`.
- The callouts, cards and cursor are the film's own drawing (`film/tour.dart`,
  `film/cards.dart`), in the app's tokens and fonts. No device artwork or
  third-party marks: content tiles use plain Material icons, the source app
  and share chooser are generic, and sample links use the reserved
  `.example` domain.
- The hook opens as a new guest who has not seen the first-visit tour; the
  progress scene is a guest too, so Profile shows the guest's sign-in card.
  The other scenes are signed in as a sample user. The local capture store
  is the real SQLite store, in memory. The phone's clock for Today, its
  greeting and Progress is pinned to Thursday of the render week; the
  Planner's calendar shows the real date.
- Server answers come from `film/demo_server.dart`, which mirrors the
  server as deployed on Serverpod Cloud Starter: no future calls, so saves
  get no link preview and AI organizing runs during the save; suggestions
  are accepted or dismissed like `AiOrganizingEndpoint` does. Search uses
  the same evidence fields, the review queue fits the chosen 5, 10 or 20
  minutes, the planner places sessions with the shared `planSlots` over the
  busy times the phone sent, and progress numbers are cohort-based. Answers
  take a short round trip, so the app's loading skeletons show.
- Fonts: the Outfit and Plus Jakarta Sans files the app bundles
  (`pinne_flutter/assets/fonts/`, SIL OFL 1.1).
- `tool/film_engine.sh` points `flutter test` at the SDK's own engine through
  a wrapper that drops `--use-test-fonts`. Without it, text whose style names
  no font (Pinne's button labels) renders as test-font boxes; with it, that
  text falls back to Roboto as on an Android phone.
- The drawn reading app's hero image (`assets/thumbs/onboarding.png`) is
  abstract art drawn by `tool/make_thumbs.py`. The Ribbon Spirit stills come
  from `pinne_flutter/assets/art/cutout/` (see `docs/ai-art/`).

## What is real and what is drawn

| Shot | Real app code | Film drawing |
| --- | --- | --- |
| Hook | First-visit tour of a new guest; Ribbon Spirit art | Content tiles, bookmarks card, title |
| Capture | Share sheet with the Saved celebration, local store, Today's Save sheet and its "Already in Pinne" | Source reading app, share chooser |
| Organize, Search, Today, Planner, Progress, celebration, Profile | Whole screen | Cursor and callouts only |
| Serverpod card, close | Ribbon Spirit art from the repo | Everything else |

The film runs a debug build in a test engine, so it has no OS keyboard and
the status bar is drawn.

## Sources for the bookmarks card

The hook's "Why not just use bookmarks?" card compares Pinne with the save
features the platforms document themselves:
[Instagram Saved](https://help.instagram.com/1744643532522513) and
[collections](https://help.instagram.com/274531543007118/),
[X Bookmarks](https://help.x.com/en/using-x/bookmarks),
[YouTube Watch later](https://support.google.com/youtube/answer/56101),
[TikTok Favorites](https://support.tiktok.com/en/using-tiktok/exploring-videos),
[Reddit Saved](https://support.reddithelp.com/hc/en-us/articles/205243605-How-do-I-save-a-post-and-where-does-it-get-saved).
None of those pages describes a note on why you saved something or bringing
a save back to you. Its one figure-free fact, "people add bookmarks far
faster than they delete them", is from Cockburn, Greenberg, Jones, McKenzie
and Moyle, [Improving Web Page Revisitation: Analysis, Design, and
Evaluation](https://www.csse.canterbury.ac.nz/andrew.cockburn/papers/itsRevisitation.pdf)
(IT & Society, 2003), a study of browser bookmarks; the same paper found
people rarely navigated by bookmarks (under 2% of actions in early
studies).
