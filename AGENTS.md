# Pinne

Saved-content review app (spec: chapters 02-05 of the captain's "idea synopsis"
doc; it is not in this repo). Fully Serverpod 4 backend plus a Flutter app.
Gemini is the AI organizing provider; its verified model, privacy terms and
fallback behavior are in `docs/ai.md`. Run steps and commands are in `README.md`.

## Stack

- `pinne_server/`: Serverpod 4.0.x, PostgreSQL. Models are `lib/src/**/*.spy.yaml`, grouped by domain folder.
- `pinne_client/` and `pinne_server/lib/src/generated/`: generated. Never edit; change models or endpoints and run `serverpod generate`.
- `pinne_flutter/`: Riverpod 3 (`lib/core/`), go_router (`lib/router.dart`), shell and pill nav (`lib/shell/`), one folder per tab under `lib/features/`.
- `pinne_capture/`: pure Dart rules shared by server and app (source detection, URL normalization, share-text parsing). Change capture rules only here, never copy them into one side.
- `pinne_calendar/`: pure Dart calendar rules shared the same way (intervals, `CalendarAdapter` contract, slot planner, `.ics`). Device calendars are read and written on the phone (`pinne_flutter/lib/features/planner/`); the server plans and stores (`pinne_server/lib/src/planning/`).

## Rules

- Owner ids come from the server session (`session.ownerId` in `pinne_server/lib/src/auth/owner.dart`), never from client input. Every query on an owned table filters by owner, and a foreign id behaves exactly like a missing one (`RecordNotFoundException`).
- Clients create records through `*Draft` models that have no owner or id.
- Capture is local-first: the app may say "Saved" only after `CaptureStore.save` returns (`pinne_flutter/lib/features/capture/`). Server mutations from the outbox must be idempotent by operation id; see `item_capture.dart`.
- Relations between owned rows must check that both ends share the owner.
- Unknown or stale calendar availability is never free time (BR04): only fresh readings of every conflict calendar verify a plan, and adapters refuse unsupported operations with `CalendarCapabilityException` instead of pretending. See "Calendar planning" in `README.md`.
- Progress numbers derive only from items and still-valid review events (`ReviewService.validEvents` and `qualifies`): opens and undone events never count, empty cohorts have a null rate, never 0%. Formulas: `docs/progress/README.md`.
- Colours come from `pinne_flutter/lib/theme/pinne_tokens.dart`. Lime is only `accentDue` (due-now state) and `accentPrimaryAction` (one primary action per screen). Violet is for every other button, selected state and link. Never use lime decoratively.
- The Ribbon Spirit (`lib/ui/ribbon_spirit/`) is the app's character. Its seed recipe and `PinneSpiritPalettes` indices are persisted in `pinne_profile`: never change the recipe math or reorder palettes (see `docs/ribbon-spirit/README.md`).
- Widgets gate animation on `reduceMotionOf(context)` (`lib/ui/motion.dart`; `reduceMotionProvider` is only for code without a context). It follows the OS reduce-motion flags unless the user overrides it in Settings.
- Secrets live only in git-ignored `pinne_server/config/passwords.yaml` and `pinne_server/.env`. Templates: `config/passwords.yaml.example` and `tool/setup_dev_secrets.sh`.

## Commands

- Checks: `dart analyze` and `dart test` in `pinne_calendar/`, `pinne_capture/` and `pinne_server/`, `flutter analyze` and `flutter test` in `pinne_flutter/`, `dart format` on changed files.
- Server tests use an embedded PostgreSQL and need no Docker. Dev runs use `docker compose up -d` in `pinne_server/`.
- After a model change with a `table`: `serverpod generate`, then `serverpod create-migration`. A `migration.sql` may be hand-edited only to keep data safe, and the resulting schema must still equal `definition.sql`.
- With `serverpod start` running, prefer the `serverpod` MCP tools (`create_migration`, `apply_migrations`, `tail_server_logs`, `hot_restart`). Serverpod and Flutter agent skills are installed by `serverpod create` under the git-ignored `.claude/skills/`.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
