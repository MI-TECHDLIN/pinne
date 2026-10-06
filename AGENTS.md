# Pinne

Saved-content review app (spec: chapters 02-05 of the captain's "idea synopsis"
doc; it is not in this repo). Fully Serverpod 4 backend plus a Flutter app.
Claude is the planned AI provider. Run steps and commands are in `README.md`.

## Stack

- `pinne_server/`: Serverpod 4.0.x, PostgreSQL. Models are `lib/src/**/*.spy.yaml`, grouped by domain folder.
- `pinne_client/` and `pinne_server/lib/src/generated/`: generated. Never edit; change models or endpoints and run `serverpod generate`.
- `pinne_flutter/`: Riverpod 3 (`lib/core/`), go_router (`lib/router.dart`), shell and pill nav (`lib/shell/`), one folder per tab under `lib/features/`.

## Rules

- Owner ids come from the server session (`session.ownerId` in `pinne_server/lib/src/auth/owner.dart`), never from client input. Every query on an owned table filters by owner, and a foreign id behaves exactly like a missing one (`RecordNotFoundException`).
- Clients create records through `*Draft` models that have no owner or id.
- Relations between owned rows must check that both ends share the owner.
- Colours come from `pinne_flutter/lib/theme/pinne_tokens.dart`. Lime is only `accentDue` (due-now state) and `accentPrimaryAction` (one primary action per screen). Violet is for every other button, selected state and link. Never use lime decoratively.
- Animations read `reduceMotionProvider` (`lib/core/motion.dart`). It follows the OS reduce-motion flag unless the user overrides it in Settings.
- Secrets live only in git-ignored `pinne_server/config/passwords.yaml` and `pinne_server/.env`. Templates: `config/passwords.yaml.example` and `tool/setup_dev_secrets.sh`.

## Commands

- Checks: `dart analyze` and `dart test` in `pinne_server/`, `flutter analyze` and `flutter test` in `pinne_flutter/`, `dart format` on changed files.
- Server tests use an embedded PostgreSQL and need no Docker. Dev runs use `docker compose up -d` in `pinne_server/`.
- After a model change with a `table`: `serverpod generate`, then `serverpod create-migration`. A `migration.sql` may be hand-edited only to keep data safe, and the resulting schema must still equal `definition.sql`.
- With `serverpod start` running, prefer the `serverpod` MCP tools (`create_migration`, `apply_migrations`, `tail_server_logs`, `hot_restart`). Serverpod and Flutter agent skills are installed by `serverpod create` under the git-ignored `.claude/skills/`.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
