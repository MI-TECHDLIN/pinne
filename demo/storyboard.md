# Storyboard

1920x1080, 30 fps, 1:45.5 with the music bed. Captions sit on the left, the
phone on the right, so captions never cover the app. Scenes are joined with
0.5 s crossfades, so each starts 0.5 s before the previous one ends. Each
scene carries one beat of the narration in [narration.txt](narration.txt)
(hook and welcome, capture, organize, search, come back, planner, progress,
Serverpod, close); with a voiceover, `tool/assemble.py` lengthens or
shortens every scene to its paragraph.

"App render" means the real `PinneApp` (or the real share sheet) running in
the phone frame, driven by taps, drags and typing. "Card" means film-only
drawing (`film/cards.dart`).

| # | Starts | Length | Scene | What is on screen | Kind |
| --- | --- | --- | --- | --- | --- |
| 1 | 0:00.0 | 16 s | `01_hook` | Brand-free content tiles (play, post, article, image, link, bookmark, mic, camera) pile up. The FLUX Ribbon Spirit, "Pinne" and the tagline appear on the left while the phone slides in with the real onboarding. Skip, the real sign-in screen, "Try without an account", the guest's Today, and the first-visit tour: "Welcome to Pinne", then its spotlight on "Save a link". | Card, then app render |
| 2 | 0:15.5 | 13 s | `02_capture` | A generic reading app (drawn) → generic share chooser (drawn) → the real "Saved to Pinne" share sheet; the why-note is typed; Done. The real Collections tab: the save shows "On phone · syncing", then "Synced", then its AI suggestions load (skeleton, then chips) on the Saved card. No link preview: it shows "Preview not available. The link is saved.", as on Serverpod Cloud Starter. | App render over a drawn source app |
| 3 | 0:28.0 | 13.5 s | `03_organize` | The same Saved card: accept the collection, accept a tag, dismiss the uncertain "Maybe" tag, accept the summary; the summary then shows on the card. | App render |
| 4 | 0:41.0 | 10 s | `04_search` | Search tab: "sunday dinner" typed; two results with "Your note" and "Matched saved note". | App render |
| 5 | 0:50.5 | 12 s | `05_today` | Today with the rotating greeting: "Two things worth revisiting", the lime due-now card with the saved note; "Remind me later" → "We'll bring it back tomorrow." → the next due save. | App render |
| 6 | 1:02.0 | 10 s | `06_planner` | Planner: Plan my week → sessions only in checked free evenings, "Checked your busy times just now" → scroll → Accept plan → "Adding to Family…". | App render |
| 7 | 1:11.5 | 13 s | `07_progress` | Progress: the card deck flicked twice. The Today pill, Reviewed on the due card → the "25 saves revisited" celebration with confetti → Continue → the Ribbon Spirit opens the Profile screen (account, totals). | App render |
| 8 | 1:24.0 | 15 s | `08_serverpod` | "Serverpod does the real work": Flutter app, Serverpod 4 server (typed Dart backend, PostgreSQL with migrations, owner-scoped endpoints, an AI pipeline that never makes you wait, sign-in), PostgreSQL, Groq (gpt-oss-20b); "Running on Serverpod Cloud". | Card |
| 9 | 1:38.5 | 7 s | `09_close` | Happy Ribbon Spirit art, "Pinne", tagline, github.com/MI-TECHDLIN/pinne, "Built with Serverpod 4 and Flutter". | Card |

## Captions

1. "You save everything." / "And never come back to it." → "Pinne" / "Save it. Come back to it." / "Try it without an account." → "A short tour shows you around."
2. CAPTURE: "Share it from any app. Say why." / "Pinne saves it on your phone first, so nothing is lost, even offline." → "Back online, it syncs." / "The outbox sends it to the Serverpod server exactly once, and the server organizes it as part of the save."
3. ORGANIZE: "AI suggests. You decide." / "Groq suggests a collection, tags and a short summary on the server. Nothing changes until you accept." → "You stay in control." / "Accept what fits, dismiss what doesn't. The AI never overwrites your choices."
4. FIND: "Find it by what you remember." / "Search your titles, notes and tags in plain words. Every result shows why it matched."
5. COME BACK: "A day later, it comes back." / "About 24 hours after you save something, Pinne brings it back with your note on why. Lime means due now." → "Review it, snooze it, or let it go." / "A small queue sized to the time you have. Remind me later brings it back tomorrow."
6. MAKE TIME: "It finds time for you." / "Pinne reads your busy times on the phone, then proposes short review sessions only in free time it has checked."
7. PROGRESS: "Honest progress." / "Numbers come only from real reviews. Opening a link or undoing never counts, and an empty week shows a dash, not 0%." → "Milestones get a celebration." / "Review your 25th save and your Ribbon Spirit celebrates with you. Once, never nagging." → PROFILE: "Your spirit, your totals." / "Tap your Ribbon Spirit for your profile: account, saves and reviews in one place."
8. BUILT ON SERVERPOD 4: "Serverpod does the real work." / "Running on Serverpod Cloud" / "Managed PostgreSQL, migrations applied on every deploy."
9. "Pinne" / "Save it. Come back to it." / "github.com/MI-TECHDLIN/pinne" / "Built with Serverpod 4 and Flutter"

Every claim is checked against the code and docs: owner rules and progress
rules in `AGENTS.md`, the 24-hour default in `reminder_settings.spy.yaml`,
the outbox in `outbox_sync.dart` and `item_capture.dart`, Groq, its model,
the rules fallback and inline organizing on Starter in `docs/ai.md`,
suggestion kinds in `ai_suggestion_kind.spy.yaml` and acceptance in
`AiOrganizingEndpoint`, search evidence in `search_service.dart`, snooze in
`TodayServerActions.remindLater`, celebrations in `CelebrationController`,
the tour in `tour_controller.dart`, and Serverpod Cloud (managed database,
`--apply-migrations` on each deploy, previews and the digest off on Starter)
in `docs/deploy.md`. The film claims no link previews or background jobs.
