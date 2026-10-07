# AI organizing

Pinne organizes only metadata already saved with an item. It does not fetch the
saved URL in this phase.

## Verified Gemini choice (2026-10-07)

Pinne uses the stable model id `gemini-3.5-flash-lite`. Google's model page
describes it as a low-latency, cost-effective model for high-throughput, simple
data extraction and confirms that it supports structured outputs:
<https://ai.google.dev/gemini-api/docs/models/gemini-3.5-flash-lite>.
That is a better fit for short classification JSON than a larger reasoning
model. The pricing page lists standard input and output as free of charge on
the free tier: <https://ai.google.dev/gemini-api/docs/pricing>.

Google measures limits as requests per minute (RPM), input tokens per minute
(TPM), and requests per day (RPD). Limits are per project, daily quotas reset at
midnight Pacific time, and a limit breach returns HTTP 429. As of the
verification date, Google does not publish one guaranteed numeric free-tier
limit: the effective limits depend on the project and model, are shown in AI
Studio, may change with account status, and are explicitly not guaranteed.
Check the project's live RPM, TPM, and RPD values before a demo:
<https://ai.google.dev/gemini-api/docs/rate-limits>. Pinne additionally caps
remote organizing at 20 items per owner per UTC day; over-cap work uses the
local deterministic fallback.

The REST request sends an `x-goog-api-key` header in a `POST` request to
`/v1beta/interactions`. Its documented structured-output shape is:

```json
{
  "model": "gemini-3.5-flash-lite",
  "input": "...",
  "response_format": {
    "type": "text",
    "mime_type": "application/json",
    "schema": {"type": "object", "properties": {}}
  },
  "store": false
}
```

This is the current official REST shape:
<https://ai.google.dev/gemini-api/docs/structured-output>.
The response is still parsed and validated as untrusted input.

## Data use and disclosure

Google's Gemini API Additional Terms say that for unpaid services Google may
use submitted content and generated responses to provide, improve, and develop
its products and machine-learning technologies. Human reviewers may read,
annotate, and process input and output; Google says it disconnects reviewed
data from the Google Account, API key, and Cloud project first, and warns not
to submit sensitive, confidential, or personal information. The terms provide
different treatment in the EEA, Switzerland, and UK. Source:
<https://ai.google.dev/gemini-api/terms>.

The same terms also say an API client made available to users in the EEA,
Switzerland, or the UK may use only Paid Services. Confirm the deployment
region and audience before exposing Gemini-backed organizing publicly there;
the deterministic provider remains available everywhere.

The Settings disclosure therefore says:

> When AI organizing is on, Pinne sends the saved item's title, URL, source
> platform, your intention and notes, plus the names and IDs of your
> collections, to Google's Gemini API. It does not fetch the page. On Gemini's
> unpaid tier, Google may use prompts and responses to improve its products,
> and human reviewers may process them. Google says not to send sensitive,
> confidential or personal information. Different data terms apply in the
> EEA, Switzerland and UK. Turn this off to keep organizing on this server
> with simple rules only.

## Configuration

`geminiApiKey` belongs only in the git-ignored
`pinne_server/config/passwords.yaml` or the matching
`SERVERPOD_PASSWORD_geminiApiKey` environment variable. The remote provider is
selected when the key exists. Set `PINNE_AI_ENABLED=false` to force the
deterministic provider globally. A missing key, user opt-out, quota cap, HTTP
error, timeout, or malformed response also falls back without failing a save.
