# pinne

Pinne is a saved-content review app. You share links from X, YouTube and the
web, keep a note on why you saved each one, find them again by what you
remember, get a gentle reminder about a day later, plan review sessions and see
honest progress.

It is built fully on [Serverpod](https://serverpod.dev) 4 with a Flutter app.
This repository holds the foundation: models, owner-scoped endpoints, auth
and the app shell. Product features land on top of it.

## Layout

| Path | What it is |
| --- | --- |
| `pinne_server/` | Serverpod server: models (`*.spy.yaml`), endpoints, migrations, tests |
| `pinne_client/` | Generated client package. Do not edit by hand |
| `pinne_flutter/` | Flutter app: Riverpod state, go_router navigation, design tokens |
| `pinne_capture/` | Pure Dart capture rules shared by server and app: source detection, URL normalization |
| `pinne_calendar/` | Pure Dart calendar rules shared by server and app: busy intervals, the calendar adapter contract, the slot planner, `.ics` export |
| `tool/setup_dev_secrets.sh` | Creates local secrets for development and tests |

## Prerequisites

- Flutter 3.47+ (Dart 3.13+)
- Docker, for the development PostgreSQL
- Serverpod CLI 4.x: `dart pub global activate serverpod_cli`, with
  `~/.pub-cache/bin` on your `PATH`

## Run it locally

All commands start from the repo root.

1. **Install dependencies and create local secrets** (first time only):

   ```bash
   flutter pub get
   tool/setup_dev_secrets.sh
   ```

   This writes `pinne_server/config/passwords.yaml` and `pinne_server/.env`
   with random values. Both files are git-ignored. The template, with every
   key explained, is `pinne_server/config/passwords.yaml.example`.

2. **Start the database:**

   ```bash
   cd pinne_server && docker compose up -d && cd ..
   ```

   PostgreSQL 16 listens on `localhost:8090`.

3. **Run the server** and apply migrations:

   ```bash
   cd pinne_server && dart run bin/main.dart --apply-migrations
   ```

   The API is on `http://localhost:8080`. Check it with:

   ```bash
   curl -X POST http://localhost:8080/health/check -d '{}'
   ```

   `serverpod start` (from `pinne_server/`) does steps 2 and 3 for you and
   adds hot reload, code generation on save, and launches the app.

4. **Run the app** in another terminal:

   ```bash
   cd pinne_flutter && flutter run
   ```

   The server URL comes from `--dart-define=SERVER_URL=...`, else `apiUrl` in
   `pinne_flutter/assets/config.json`, else `http://localhost:8080/`. On a
   physical phone use your computer's LAN address. Settings shows whether
   the server answers.

## Sign-in

Email sign-in works out of the box. In development the verification code is
printed in the server console.

Google sign-in is wired in but stays off until real credentials exist:

1. Create OAuth clients in Google Cloud Console (a Web client for the server,
   plus Android/iOS clients for the app).
2. Paste the Web client JSON as `googleClientSecret` in
   `pinne_server/config/passwords.yaml` (see the commented example there).
3. Run the app with
   `--dart-define=GOOGLE_CLIENT_ID=<app client id> --dart-define=GOOGLE_SERVER_CLIENT_ID=<web client id>`.

Without these the server logs `Google sign-in is disabled` and the app hides
the Google button. Never commit real credentials.

## Capture

Saving is local-first. A share or paste is written to a SQLite database on
the phone (WAL, `synchronous = FULL`, item and outbox row in one
transaction) before the app says "Saved", so it survives the app being
killed. An outbox then sends it to `item.capture`, retrying with backoff;
an operation leaves the outbox only once the server confirms it. Retries
reuse the same operation id, and the server answers a repeat with the same
result. Signed-out or offline captures wait on the phone and sync after
sign-in or reconnect. Code: `pinne_flutter/lib/features/capture/` and
`pinne_server/lib/src/items/item_capture.dart`.

- **Android:** `ShareActivity` receives `text/plain` shares (links and text)
  and shows the compact "Saved to Pinne" sheet over the app that shared,
  running the `shareMain` entrypoint in `lib/main.dart`. Done returns there.
  The sheet's engine closes with it, so it tries one send on Done and
  otherwise leaves the capture to the main app, which drains the outbox on
  start, resume, sign-in and reconnect. Background sync without opening the
  app (WorkManager) is not built yet.
- **Manual:** paste a link or type a note on Today. Captures show under
  Collections, in Saved.
- **Web:** has no durable local store, so capture is hidden there.

### iOS Share Extension (not built yet)

It needs a Mac with Xcode. To add it:

1. In `pinne_flutter/ios/Runner.xcworkspace`, add a **Share Extension**
   target (for example `ShareExtension`, bundle id
   `<Runner bundle id>.ShareExtension`), embedded in Runner, with the same
   team and minimum iOS version as Runner.
2. Add the **App Groups** capability to both Runner and the extension with
   one shared group (for example `group.<Runner bundle id>`). This writes
   `com.apple.security.application-groups` into `Runner.entitlements` and
   `ShareExtension.entitlements`. Register the group in the Apple Developer
   account and regenerate both provisioning profiles.
3. In the extension's `Info.plist`, set `NSExtensionActivationRule` to accept
   web URLs (`NSExtensionActivationSupportsWebURLWithMaxCount` = 1) and text
   (`NSExtensionActivationSupportsText` = true).
4. Move the capture database into the App Group container
   (`FileManager.containerURL(forSecurityApplicationGroupIdentifier:)`) so
   both processes reach it. `path_provider` cannot return that path; add a
   small platform channel for `openCaptureStore()` on iOS.
5. In the extension, persist the raw shared text to the shared container
   before showing "Saved" (native Swift, no Flutter engine, to stay inside
   the extension memory limit), then call
   `extensionContext.completeRequest` to return to the source app. The main
   app imports those rows on launch or resume, parses them with
   `pinne_capture` and queues them in the outbox.

## Calendar planning

Today → **Plan** opens the Planner. It proposes short review sessions in free
time, shows what was checked ("Checked your busy times 2 minutes ago"), and
schedules them only after you accept. Code: `pinne_flutter/lib/features/planner/`,
`pinne_server/lib/src/planning/` and `pinne_calendar/`.

| Route | Busy times | Sessions | Notes |
| --- | --- | --- | --- |
| Android phone calendars | Read on the phone from the calendars you check | Written to the one calendar you choose | Uses [`device_calendar_plus`](https://pub.dev/packages/device_calendar_plus) 0.10.1 (MIT). Asks for `READ_CALENDAR` and `WRITE_CALENDAR` only when you tap *Allow calendar access*. |
| Google Calendar | No | No | Reports "not configured" until `googleCalendarClientSecret` exists, and "not built yet" after. It never claims to have read a Google calendar. |
| Calendar file (.ics) | No | You import the file | Export only: not live sync and not proof of free time. |

How it stays honest:

- **Unknown is never free.** A plan is "checked" only when every calendar
  chosen for busy times was read on this phone in the last 15 minutes over
  the whole period. Otherwise it cannot be accepted as checked; you can only
  *Keep in Pinne without checking*, which writes nothing to a calendar and
  labels the sessions.
- **Accept rechecks.** Accepting reads busy times again. A new clash revises
  the plan instead of scheduling over it.
- **No duplicates.** The server stores each session and its calendar
  operation before the phone writes anything. The phone marks every event it
  writes with the session's id and looks for that mark before creating,
  moving or removing, so a write whose answer was lost is found, not
  repeated, and an event Pinne did not create is never changed.
- **Your calendar edits win.** Moving or deleting a Pinne event in your
  calendar app moves or cancels the session the next time the Planner opens.
- Calendar titles say only "Pinne review"; saved items' names stay in Pinne.
- Device calendar ids are stored with the install's id; only that phone acts
  on them. Disconnecting keeps scheduled sessions and existing events.

Planner settings (the sliders icon) set the week or month horizon, days,
daily window, session length, how many sessions, buffers around events,
earliest start, and whether plans need your acceptance or are suggestions
only. Items in sessions are your active, unreviewed saves for now
(`SessionItemSource` is the seam for the review queue).

## Checks

```bash
(cd pinne_server && serverpod generate)   # after changing models or endpoints
(cd pinne_calendar && dart analyze && dart test)
(cd pinne_capture && dart analyze && dart test)
(cd pinne_server && dart analyze && dart test)
(cd pinne_flutter && flutter analyze && flutter test)
```

Server tests need no Docker. They start an embedded PostgreSQL that Serverpod
manages (`config/test.yaml` sets `dataPath`), so `tool/setup_dev_secrets.sh`
must have run once. CI runs the same steps (`.github/workflows/ci.yml`).

## Changing the schema

Edit the `.spy.yaml` models, then from `pinne_server/`:

```bash
serverpod generate
serverpod create-migration
dart run bin/main.dart --apply-migrations
```

## AI art

The Ribbon Spirit stills in `pinne_flutter/assets/art/` were generated with
FLUX.2 [klein] 4B (Apache-2.0). Prompts, seeds, the licence record and the
AI-use disclosure for the submission are in
[`docs/ai-art/README.md`](docs/ai-art/README.md). The animated spirit in the
app is drawn in code (`docs/ribbon-spirit/`).
