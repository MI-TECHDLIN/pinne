# Storyboard

1920x1080, 30 fps, about 1:44. Captions sit on the left, the phone on the
right, so captions never cover the app. Scenes are joined with 0.5 s
crossfades, so each starts 0.5 s before the previous one ends.

"App render" means the real `PinneApp` (or the real share sheet) running in
the phone frame, driven by taps, drags and typing. "Card" means film-only
drawing (`film/cards.dart`).

| # | Starts | Length | Scene | What is on screen | Kind |
| --- | --- | --- | --- | --- | --- |
| 1 | 0:00.0 | 9.5 s | `01_hook` | Brand-free content tiles (play, post, article, image, link, bookmark, mic, camera) pile up. Then the FLUX Ribbon Spirit welcome art, "Pinne", tagline. | Card |
| 2 | 0:09.0 | 17 s | `02_capture` | A generic reading app (drawn) → generic share chooser (drawn) → the real "Saved to Pinne" share sheet; the why-note is typed; Done. The real app's Collections tab: the save shows "On phone · syncing", then "Synced", a preview skeleton, then the thumbnail and real title. | App render over a drawn source app |
| 3 | 0:25.5 | 10.5 s | `03_organize` | Settings → AI organizing with the Gemini disclosure. Beside it, the app's real `AiSuggestionChips` widget: accept collection, accept tag, dismiss an uncertain tag, accept summary. | App render + real widget in a labelled panel |
| 4 | 0:35.5 | 11.5 s | `04_search` | Search tab: "sunday dinner video" typed; results with thumbnails, "Your note" and "Matched saved note". | App render |
| 5 | 0:46.5 | 15 s | `05_today` | Today: lime due-now card with the excited spirit, thumbnail and saved note; tap Reviewed → "Counted as reviewed." → the real milestone celebration (25 saves revisited) with confetti. | App render |
| 6 | 1:01.0 | 12.5 s | `06_planner` | Planner: Plan my week → sessions only in checked free evenings, "Checked your busy times just now" → scroll → Accept plan → "Adding to Family…". | App render |
| 7 | 1:13.0 | 10.5 s | `07_progress` | Progress: the tilted card deck flicked three times, then the cohort numbers and the review-rate chart. | App render |
| 8 | 1:23.0 | 13 s | `08_serverpod` | "Serverpod does the real work": Flutter app, Serverpod 4 server (owner-scoped endpoints, Postgres models and migrations, review queue and future calls, safe link-preview fetcher, sign-in), PostgreSQL, Gemini API. | Card |
| 9 | 1:35.5 | 8 s | `09_close` | Happy Ribbon Spirit art, "Pinne", tagline, github.com/MI-TECHDLIN/pinne, "Built with Serverpod 4 and Flutter". | Card |

## Captions

1. "You save everything." / "And never come back to it." → "Pinne" / "Save it. Come back to it."
2. CAPTURE: "Share it from any app. Say why." / "Pinne saves it on your phone first, so nothing is lost, even offline." → "Synced, then filled in." / "Back online, the Serverpod server fetches a safe preview. The real title and thumbnail appear on their own."
3. ORGANIZE: "Gemini suggests. You decide." / "A collection, tags and a short summary, made on the server. Nothing changes until you accept."
4. FIND: "Find it by what you remember." / "Search your titles, notes and tags in plain words. Every result shows why it matched."
5. COME BACK: "A day later, it comes back." / "About 24 hours after you save something, Pinne brings it back with your note on why. Lime means due now." → "Reviewed. Or later." / "One tap counts it, or remind me later. Milestones get a small celebration from your Ribbon Spirit."
6. MAKE TIME: "It finds time for you." / "Pinne reads your busy times on the phone, then proposes short review sessions only in free time it has checked."
7. PROGRESS: "Honest progress." / "Numbers come only from real reviews. Opening a link or undoing never counts, and an empty week shows a dash, not 0%."
8. BUILT ON SERVERPOD 4: "Serverpod does the real work."
9. "Pinne" / "Save it. Come back to it." / "github.com/MI-TECHDLIN/pinne" / "Built with Serverpod 4 and Flutter"

Every claim is checked against the code: owner rules and progress rules in
`AGENTS.md`, the 24-hour default in `reminder_settings.spy.yaml`, future calls
in `server.dart`, `ai_organizing_endpoint.dart`, `item_endpoint.dart` and
`link_previews/`, suggestion kinds in `ai_suggestion_kind.spy.yaml`, and
search evidence in `search_service.dart`.
