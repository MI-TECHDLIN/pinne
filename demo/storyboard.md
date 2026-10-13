# Storyboard

1920x1080, 30 fps, under 2:00 with the voiceover. The app screen stands on
the dark violet stage at full height, with no device around it. For every
step, the camera eases toward the element (at most 2x, no spins), the
cursor glides onto its centre and clicks, and one short callout sits beside
it, never over it. One callout at a time, each on screen at least 1.6 s.
Callouts carry the details the narration does not say. Scenes are joined
with 0.5 s crossfades. Each scene carries one beat of
[narration.txt](narration.txt); `tool/assemble.py` places each paragraph at
its moment and holds or trims the scene to fit. Where each scene starts and
each line lands: `cut.json`; every cursor step:
[cursor-coordinates.md](cursor-coordinates.md).

| # | Scene | What is on screen | Callouts (the little features) |
| --- | --- | --- | --- |
| 1 | `01_hook` | Card. Brand-free content tiles pile up: "You save everything." / "And never come back to it." Then, in the narration's pause, "Why not just use bookmarks?": saved in each app against Pinne, with one sourced line. Then the Ribbon Spirit, "Pinne", "Save it. Come back to it.", as the real app rises in with a new guest's first-visit tour. | A short first-run tour shows you around |
| 2 | `02_capture` | A generic reading app (drawn) → generic share chooser (drawn) → the real "Saved to Pinne" share sheet with the Saved celebration; the why-note typed; Done. Then Today's Save sheet, above the pill nav: the same link pasted and saved. | Share from any app · Pick Pinne in the share sheet · Saved instantly, with a little celebration · Offline? It stays on this phone and syncs later · Say why you saved it · Done takes you back to your reading · Or save a link right inside Pinne · Paste the same link again · Saved before? Pinne says so ("Already in Pinne") |
| 3 | `03_organize` | Collections: the save goes from "On phone · syncing" to "Synced", its AI suggestions arrive; accept the collection, a tag and the summary, dismiss the uncertain "Maybe" tag; the summary shows on the card. | Back online, it syncs exactly once · AI suggests a collection. You decide. · Keep the tags that fit · Add the short summary in one tap · "Maybe" marks a guess. Dismiss it. |
| 4 | `04_search` | Search: recent searches, "sunday dinner" typed, results with "Your note" and "Matched saved note". | Recent searches stay on this phone · Search the way you remember it · Every result says why it matched |
| 5 | `05_today` | Today: the lime due-now card with the saved note; 20 min chosen, "Four things worth revisiting"; Remind me later → "We'll bring it back tomorrow." | Back a day later, with your note on why · Got 20 minutes? The queue grows to fit · Remind me later brings it back tomorrow |
| 6 | `06_planner` | Planner: Plan my week → sessions only in checked free time, and the line "Checked your busy times just now". | Plan my week finds free slots · It tells you exactly what it checked |
| 7 | `07_progress` | Progress deck; Today, Reviewed → the "25 saves revisited" celebration → Continue; the Ribbon Spirit opens Profile with the guest's sign-in card. | Opening isn't reviewing: only reviews count · Back to Today's save · Mark it reviewed · Milestones get a celebration, just once · Tap your spirit for your profile · A guest now. Sign in whenever you like. |
| 8 | `08_serverpod` | Card. "Serverpod does the real work": Flutter app, Serverpod 4 server (typed Dart backend, PostgreSQL with migrations, owner-scoped endpoints, an AI pipeline that never makes you wait, sign-in), PostgreSQL, Groq (gpt-oss-20b), each appearing as the narration names it; "Running on Serverpod Cloud". | - |
| 9 | `09_close` | Card. Happy Ribbon Spirit art, "Pinne", tagline, github.com/MI-TECHDLIN/pinne, "Built with Serverpod 4 and Flutter". | - |

Every claim is checked against the code and docs: owner rules and progress
rules in `AGENTS.md`, the 24-hour default in `reminder_settings.spy.yaml`,
the outbox in `outbox_sync.dart` and `item_capture.dart`, duplicates in
`CaptureStore.findSaved`, the Saved celebration in `save_celebration.dart`,
Groq, its model, the rules fallback and inline organizing on Starter in
`docs/ai.md`, suggestion kinds and the uncertain flag in
`ai_suggestion_kind.spy.yaml` and acceptance in `AiOrganizingEndpoint`,
search evidence in `search_service.dart` and recent searches in
`search_history.dart` (stored on the device), the time budget in
`today_screen.dart`, snooze in `TodayServerActions.remindLater`, the
planner's coverage line in `planner_format.dart`, celebrations in
`CelebrationController`, the guest account card in `profile_screen.dart`,
the tour in `tour_controller.dart`, and Serverpod Cloud (managed database,
`--apply-migrations` on each deploy, previews and the digest off on Starter)
in `docs/deploy.md`. The bookmarks card's sources are in
[README.md](README.md#sources-for-the-bookmarks-card). The film claims no
link previews or background jobs.
