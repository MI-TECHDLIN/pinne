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

## Checks

```bash
(cd pinne_server && serverpod generate)   # after changing models or endpoints
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
