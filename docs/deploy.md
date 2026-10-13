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

Email codes need no password here: Serverpod Cloud sets `scloudAuthEmailKey`
on deploy, and Pinne sends registration and password-reset codes through the
Serverpod Cloud email service (Serverpod's template, project name "Pinne").

SMTP is optional and, when set, is tried first so codes arrive in Pinne's
branded email. On 2026-10-13 production could not reach `smtp.gmail.com:587`
at all (the connection timed out, while the same settings answered within a
second elsewhere), so on Cloud expect SMTP to fail over to the Cloud service.
A failing route is skipped for 30 minutes, and every failure appears in
`serverpod cloud log` as a line starting `ERROR: Email delivery:` with the
route and the reason, never the code or a password. To use only the Cloud
service, delete the `smtp*` passwords and redeploy. To use SMTP, set at least
host and from address. Username and password must be set together; omit both
for an unauthenticated relay.

For Gmail SMTP, first enable 2-Step Verification on the sending Google account
and create an app password. Use the account's full Gmail address as both the
username and from address, and store the 16-character app password as
`smtpPassword` (never the account's normal password):

```powershell
serverpod cloud password set smtpHost "smtp.gmail.com"
serverpod cloud password set smtpPort "587"
serverpod cloud password set smtpUsername "<YOUR_GMAIL_ADDRESS>"
serverpod cloud password set smtpPassword "<GMAIL_APP_PASSWORD>"
serverpod cloud password set smtpFromEmail "<YOUR_GMAIL_ADDRESS>"
serverpod cloud password set smtpFromName "Pinne"
serverpod cloud password set smtpSsl "false"
```

For another SMTP provider, use its corresponding connection details:

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

The app resolves the server in this order: the `SERVER_URL` build define, then,
in release builds for phones, the hosted API
`https://pinneapp.api.serverpod.space/`, then `assets/config.json`, which points
at local development (`http://localhost:8080`). A release APK built without
the define therefore talks to the `pinneapp` project; pass `SERVER_URL`
explicitly anyway, with its trailing slash, so the build never depends on the
project id baked into the app:

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

- Run the health request from section 5 and confirm `ok: true`. The app has no
  server indicator; a mis-built APK shows a friendly network error at sign-in.
- Tap **Try without an account** and reach a private empty workspace.
- On Today, tap **Load examples**. Confirm three example saves are in the
  review queue right away, open one, and mark it **Reviewed**.
- Save a public web link and confirm it appears in Collections → Saved. On
  Growth, confirm preview metadata appears after processing; on Starter,
  expect "Preview not available. The link is saved."
- Confirm AI suggestions (collection, tags, a summary) appear on the saved card
  and can be accepted or dismissed. Rules alone also suggest a site tag and
  quote the preview description as a summary, so this does not prove Groq
  ran. Check it with `curl -X POST <api-url>/health/aiProviderStatus`
  (`"groq: last call succeeded at ..."`). `serverpod cloud log` prints
  `AI organizing provider: groq` and `Future calls: enabled|disabled` at
  startup, and `AI organizing: groq failed, organized with rules instead:
  <reason>` (class, HTTP status and Groq error code only) whenever a call
  falls back to rules. Production keeps session logs off the console, so
  only these stderr lines reach `serverpod cloud log`.
- The new save enters the Today review queue about 24 hours later; it is not
  due during the same session.
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
> workspace. On Today, tap **Load examples**: three of the six example saves are
> due for review right away, so open one from the review queue and tap
> **Reviewed** to complete the save-and-review flow. Then save a link or note of
> your own on Today and find it in Collections → Saved, where you can accept or
> dismiss its AI suggestions. New saves come back for review in about 24 hours.
> You can also try Planner and Progress. Alternatively, choose email
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
