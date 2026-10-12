# Deploy Pinne to Serverpod Cloud

This is the captain's release runbook for a Serverpod Cloud backend and an
Android judge build. Run it from the repository checkout on the Windows laptop.
Do not put any value used below into Git, screenshots, the public submission,
or `scloud.yaml`.

The preparation in this repository stops before Cloud sign-in. The commands
were checked against Serverpod CLI 4.0.3 and the Cloud CLI it installed,
version 1.0.1, on 2026-10-11.

## What Cloud supplies

Serverpod Cloud overrides the example public hosts and database connection in
`config/production.yaml` at runtime. Keep the database enabled when creating
the project. Cloud then injects its TLS PostgreSQL connection, starts the
server with `--apply-migrations` on every deploy, supplies the standard auth
passwords, and provides `private` and `public` file storages. Pinne connects to
those storages through `ServerpodCloudProvider`; outside Cloud it retains the
existing `DatabaseCloudStorage` fallback.

Link previews and the hourly scan for roughly 24-hour resurfacing digests use
durable future calls. AI organizing uses future calls when available and runs
inline on **Starter**. Starter keeps capture, review, and organizing usable but
does not provide link previews or the digest scheduler. **Growth** enables the
full background feature set. Confirm current plans and prices in the Console;
commercial details can change.

Official references:

- [Set up the Cloud CLI](https://docs.serverpod.dev/cloud/getting-started/installation)
- [Deploy your first app](https://docs.serverpod.dev/cloud/getting-started/launch)
- [Deployments and default URLs](https://docs.serverpod.dev/cloud/concepts/deployments)
- [Managed database and automatic migrations](https://docs.serverpod.dev/cloud/guides/database)
- [Passwords, secrets, and variables](https://docs.serverpod.dev/cloud/concepts/passwords-secrets-env-vars)
- [Deployment hooks](https://docs.serverpod.dev/cloud/concepts/deployment-hooks)
- [Runtime and build logs](https://docs.serverpod.dev/cloud/concepts/logs)
- [Cloud storage](https://docs.serverpod.dev/cloud/concepts/storage)
- [Current Cloud pricing](https://serverpod.dev/cloud)

## 1. Install and sign in

Open PowerShell. Ensure Flutter's `bin`, Dart's global executable directory,
and Git are on `PATH`. Install the Serverpod CLI version used by this project
if needed:

```powershell
dart pub global activate serverpod_cli 4.0.3
serverpod --version
serverpod cloud version
```

`serverpod cloud version` automatically installs the separate Cloud CLI when
it is missing. The supported alternative is:

```powershell
dart install serverpod_cloud_cli
scloud version
```

`scloud` takes the same subcommands as `serverpod cloud`; its install directory
may need to be added to `PATH`. The rest of this runbook uses the wrapper.

Sign in. This is the first step that requires the captain: it opens a browser
and stores a Cloud authentication token on the laptop.

```powershell
serverpod cloud auth login
```

## 2. Launch the project

```powershell
cd <PINNE_REPOSITORY>\pinne_server
serverpod cloud launch
```

In the browser/terminal flow:

1. Create or select the Pinne project. The project ID must be globally unique,
   6–32 characters, and contain only lowercase letters, numbers, and hyphens.
   Save it as `<PROJECT_ID>` for the commands below.
2. Leave the managed database enabled. Pinne persists auth, saves, reviews,
   plans, progress, future calls, and local-storage fallback records.
3. Choose a plan. Starter supports the core synchronous flow and inline AI
   organizing. Growth is needed for link previews, background AI organizing,
   and the digest scheduler.
4. Accept the proposed pre-deploy hooks: `serverpod generate` and
   `serverpod run flutter_build`. A failing pre-deploy hook stops the upload.
5. Do not copy placeholder production values from `config/passwords.yaml`.
   Set the real custom values explicitly in the next step.

The launch writes `pinne_server/scloud.yaml`, links the checkout to the chosen
project, builds, uploads, applies every pending migration, and rolls out the
server. Commit `scloud.yaml` later if desired: it contains a project ID, not a
credential. Never commit `config/passwords.yaml`, `.env`, or `.scloud/`.

CLI note: Cloud database documentation also mentions an `--enable-db` launch
flag, but the installed Cloud CLI 1.0.1 `launch --help` does not expose that
flag. Trust the installed CLI and select database enablement in the browser
flow. Its log command is singular: `serverpod cloud log`, not `logs`.

After launch, subsequent releases are:

```powershell
serverpod cloud deploy
serverpod cloud status deployment show
```

## 3. Set custom passwords

Cloud passwords are encrypted, injected as `SERVERPOD_PASSWORD_<name>`, and
read by Pinne through `Serverpod.getPassword(name)`. Cloud itself manages the
database and Serverpod auth passwords; do not override those for a new project.

The commands below show placeholders. Replace them only in the terminal. For
values that must not remain in shell history, put the value alone in a file
outside the repository and use `--from-file C:\secure\value.txt` in place of
the quoted value; securely delete that file afterward.

Required for the judged Groq path and the private demo login:

```powershell
serverpod cloud password set groqApiKey "<GROQ_API_KEY>"
serverpod cloud password set demoAccountEmail "<JUDGE_DEMO_EMAIL>"
serverpod cloud password set demoAccountPassword "<STRONG_JUDGE_DEMO_PASSWORD>"
```

SMTP is optional. Without it, guest sign-in and the pre-seeded demo login work,
but production registration codes and password resets are unavailable. To
enable email delivery, set at least host and from address. Username and
password must be set together; omit both for an unauthenticated relay.

```powershell
serverpod cloud password set smtpHost "<SMTP_HOST>"
serverpod cloud password set smtpPort "<SMTP_PORT_USUALLY_587>"
serverpod cloud password set smtpUsername "<SMTP_USERNAME>"
serverpod cloud password set smtpPassword "<SMTP_PASSWORD>"
serverpod cloud password set smtpFromEmail "<SMTP_FROM_EMAIL>"
serverpod cloud password set smtpFromName "Pinne"
serverpod cloud password set smtpSsl "false"
```

Use `smtpSsl=true` only for implicit TLS, commonly port 465; the default path
uses STARTTLS. Check names and whether Cloud or the user manages them, then
restart the latest build with the new values:

```powershell
serverpod cloud password list
serverpod cloud deploy --redeploy
```

Groq is optional for server availability. If its key is absent, Pinne tries a
configured `geminiApiKey`, then uses deterministic organizing. Any provider
failure also falls back to deterministic rules. Link previews do not need an
AI key and fetch public HTTP(S) metadata from the server with SSRF, size,
redirect, and timeout restrictions.

## 4. Seed the empty judge account

`dart run bin/main.dart --seed-demo` remains the local/development command.
Cloud does not currently expose a remote process command, and direct database
seeding would require duplicating Cloud-managed auth secrets. Pinne therefore
supports the same idempotent seeder as a controlled one-off startup. The email
and password stay in Cloud passwords; the temporary switch is not secret.

```powershell
serverpod cloud variable set PINNE_SEED_DEMO_ON_START "true"
serverpod cloud deploy --redeploy
serverpod cloud log --since 10m
```

Wait for one of these log messages:

```text
Created empty demo account for <email>.
Demo account for <email> already exists; nothing changed.
```

Then remove the switch immediately and restart the same build:

```powershell
serverpod cloud variable unset PINNE_SEED_DEMO_ON_START
serverpod cloud deploy --redeploy
```

The seeder creates no example saves and is safe to repeat with the same email.
Keep the judge email and password only in Cloud and the private submission
form.

## 5. Verify the live backend

Launch prints these URLs:

```text
Web:      https://<PROJECT_ID>.serverpod.space/
API:      https://<PROJECT_ID>.api.serverpod.space/
Insights: https://<PROJECT_ID>.insights.serverpod.space/
```

The web host serves the Flutter build produced by the pre-deploy hook. On the
default Cloud domain, the app derives the matching `.api.serverpod.space` host
at runtime; a future custom domain should pass `SERVER_URL` to the web build.
The API health method is a Serverpod POST endpoint, not a plain browser GET:

```powershell
$Api = "https://<PROJECT_ID>.api.serverpod.space/"
Invoke-RestMethod -Method Post -Uri "${Api}health/check" -ContentType "application/json" -Body "{}"
serverpod cloud status live
serverpod cloud log --since 10m
```

The response should report `ok: true`, `databaseOk: true`, and version `0.1.0`.
Open the Insights URL and confirm the health session appears. If deployment
fails, inspect both:

```powershell
serverpod cloud status deployment show
serverpod cloud build log
```

Cloud runs migrations automatically at container startup. A failed migration
prevents the new release from becoming live; the prior successful deployment
keeps serving traffic.

## 6. Build and install the Android judge APK

The app already resolves the server in this order: `SERVER_URL` build define,
`assets/config.json`, then local development. Build with the Cloud API URL and
its trailing slash:

```powershell
cd <PINNE_REPOSITORY>\pinne_flutter
flutter pub get
flutter build apk --release --dart-define=SERVER_URL=https://<PROJECT_ID>.api.serverpod.space/
```

The result is:

```text
pinne_flutter\build\app\outputs\flutter-apk\app-release.apk
```

This hackathon APK uses release optimization with Android's debug signing key,
so it can be sideloaded without managing a private keystore. It is not suitable
for Play Store release. Its application ID is `com.mitechdlin.pinne`, visible
name is **Pinne**, version is `1.0.0+1`, internet permission is explicit, and
the `text/plain` share intent remains registered.

Install by transferring the APK to the Android phone and opening it, or with
Android platform tools and USB debugging:

```powershell
adb install -r .\build\app\outputs\flutter-apk\app-release.apk
```

If an older build with a different application ID is installed, uninstall that
old build first. Do not uninstall the final guest-tested build before judging:
guest credentials are device-bound.

## 7. Final judge test

Use the exact APK that will be submitted and a normal mobile internet
connection, not the laptop's local network.

- Open Pinne and confirm Settings reports the server as healthy.
- Tap **Try without an account** and reach a private empty workspace.
- Save a public web link and confirm it appears in Collections → Saved. On
  Growth, confirm preview metadata appears after processing; on Starter,
  confirm the saved link remains usable without a preview.
- With `groqApiKey` set, confirm an AI suggestion appears and can be accepted
  or dismissed. A deterministic suggestion alone does not prove Groq ran; use
  the startup log and stored task provider in Insights to confirm the path.
- Confirm the saved item enters the Today review queue and can be opened and
  reviewed.
- Open Planner, provide device-calendar permission only if desired, create a
  plan, and verify unknown/stale availability is never shown as free.
- Open Progress and confirm the newly completed review affects the report.
- Sign out only after the guest flow is complete. Sign in with the private demo
  credentials and confirm its empty workspace is usable.
- Re-run the health request, inspect Insights, and keep the Cloud project and
  APK accessible without payment or access restrictions through the end of
  judging on 2026-10-20.

## Submission text: Testing instructions for judges

Replace the two placeholders and paste this into the private testing field:

> Download and install the Pinne Android APK from `<APK_DOWNLOAD_LINK>`. The
> build connects to the live Serverpod backend at
> `https://<PROJECT_ID>.api.serverpod.space/`; no local server is needed. Open
> Pinne while online and tap **Try without an account**. No email, code, or
> external account is required, and the guest receives a private empty
> workspace. Save a link or note on Today, confirm it appears in Collections →
> Saved, and open it from the review queue to complete the save-and-review
> flow. You can also try Planner and Progress. Alternatively, choose email
> sign-in and use the demo email and password supplied separately in this
> private submission. Guest access is device-bound: do not sign out, clear app
> data, or uninstall until testing is complete.

## What was and was not verified before handoff

Locally verified: Serverpod/Cloud CLI help, code generation, analyzers, tests,
the production code paths, web pre-deploy build, and Android project metadata.
The repository contains no real credentials. The preparation environment did
not sign in to Cloud, create a project, choose a plan, deploy, set passwords,
or reach live Cloud URLs. It also has no Android SDK, so the APK itself must be
built and installed on the captain's Windows laptop.
