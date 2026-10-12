# Storyboard

1920x1080, 30 fps, 1:47. Captions sit on the left, the phone on the right,
so captions never cover the app. Scenes are joined with 0.5 s crossfades, so
each starts 0.5 s before the previous one ends. Scene starts follow the beats
of the captain's voiceover script (hook, capture, organize, find, come back,
make time, progress, Serverpod, close).

"App render" means the real `PinneApp` (or the real share sheet) running in
the phone frame, driven by taps, drags and typing. "Card" means film-only
drawing (`film/cards.dart`).

| # | Starts | Length | Scene | What is on screen | Kind |
| --- | --- | --- | --- | --- | --- |
| 1 | 0:00.0 | 11.5 s | `01_hook` | Brand-free content tiles (play, post, article, image, link, bookmark, mic, camera) pile up. The FLUX Ribbon Spirit, "Pinne" and the tagline appear on the left while the phone slides in with the real onboarding (icons flying into the spirit's save box). Skip, then the real sign-in screen: "Try without an account" is tapped and the guest lands on an empty Today. | Card, then app render |
| 2 | 0:11.0 | 15.5 s | `02_capture` | A generic reading app (drawn) → generic share chooser (drawn) → the real "Saved to Pinne" share sheet; the why-note is typed; Done. The real Collections tab: the save shows "On phone · syncing", then "Synced", a preview skeleton, then the thumbnail and real title. | App render over a drawn source app |
| 3 | 0:26.0 | 12.5 s | `03_organize` | Settings → AI organizing with the Gemini disclosure. Beside it, the app's real `AiSuggestionChips` widget: accept collection, accept tag, dismiss an uncertain tag, accept summary; each decision is then listed with a check or a cross. | App render + real widget in a labelled panel |
| 4 | 0:38.0 | 12 s | `04_search` | Search tab: "sunday dinner video" typed; results with thumbnails, source and duration chips, "Your note" and "Matched saved note". | App render |
| 5 | 0:49.5 | 14 s | `05_today` | Today: "Two things worth revisiting", the lime due-now card with the saved note; tap "Remind me later" → "We'll bring it back tomorrow." → the next due save. | App render |
| 6 | 1:03.0 | 12 s | `06_planner` | Planner: Plan my week → sessions only in checked free evenings, "Checked your busy times just now" → scroll → Accept plan → "Adding to Family…". | App render |
| 7 | 1:14.5 | 14.5 s | `07_progress` | Progress: the tilted card deck flicked three times. Then the Today pill, Reviewed on the due card → "Counted as reviewed." → the real "25 saves revisited" celebration with confetti. | App render |
| 8 | 1:28.5 | 12 s | `08_serverpod` | "Serverpod does the real work": Flutter app, Serverpod 4 server (owner-scoped endpoints, Postgres models and migrations, review queue and future calls, safe link-preview fetcher, sign-in), PostgreSQL, Gemini API; "Set up for Serverpod Cloud". | Card |
| 9 | 1:40.0 | 7 s | `09_close` | Happy Ribbon Spirit art, "Pinne", tagline, github.com/MI-TECHDLIN/pinne, "Built with Serverpod 4 and Flutter". | Card |

## Captions

1. "You save everything." / "And never come back to it." → "Pinne" / "Save it. Come back to it." / "Try it without an account."
2. CAPTURE: "Share it from any app. Say why." / "Pinne saves it on your phone first, so nothing is lost, even offline." → "Synced, then filled in." / "Back online, the Serverpod server fetches a safe preview. The real title and thumbnail appear on their own."
3. ORGANIZE: "Gemini suggests. You decide." / "A collection, tags and a short summary, made on the server. Nothing changes until you accept."
4. FIND: "Find it by what you remember." / "Search your titles, notes and tags in plain words. Every result shows why it matched."
5. COME BACK: "A day later, it comes back." / "About 24 hours after you save something, Pinne brings it back with your note on why. Lime means due now." → "Review it, snooze it, or let it go." / "A small queue sized to the time you have. Remind me later brings it back tomorrow."
6. MAKE TIME: "It finds time for you." / "Pinne reads your busy times on the phone, then proposes short review sessions only in free time it has checked."
7. PROGRESS: "Honest progress." / "Numbers come only from real reviews. Opening a link or undoing never counts, and an empty week shows a dash, not 0%." → "Milestones get a celebration." / "Review your 25th save and your Ribbon Spirit celebrates with you. Once, never nagging."
8. BUILT ON SERVERPOD 4: "Serverpod does the real work." / "Set up for Serverpod Cloud: managed Postgres, automatic migrations and durable future calls."
9. "Pinne" / "Save it. Come back to it." / "github.com/MI-TECHDLIN/pinne" / "Built with Serverpod 4 and Flutter"

Every claim is checked against the code: owner rules and progress rules in
`AGENTS.md`, the 24-hour default in `reminder_settings.spy.yaml`, future calls
in `server.dart`, `ai_organizing_endpoint.dart`, `item_endpoint.dart` and
`link_previews/`, suggestion kinds in `ai_suggestion_kind.spy.yaml`, search
evidence in `search_service.dart`, snooze in `TodayServerActions.remindLater`,
celebrations in `CelebrationController`, and Serverpod Cloud in
`docs/deploy.md`.
