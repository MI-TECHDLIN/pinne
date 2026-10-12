# AI organizing

Pinne organizes only metadata already saved with an item. It does not fetch the
saved URL in this phase. The provider receives the title, URL, source platform,
the user's intention and note, collection names and IDs, and any stored preview
description, author, and site name.

## Provider selection

The server selects the first configured provider in this order:

1. Groq when `groqApiKey` is set.
2. Gemini when `geminiApiKey` is set and no Groq key is set.
3. Deterministic local rules when neither key is set.

`PINNE_AI_ENABLED=false` forces local rules globally. A user can also turn
remote organizing off. At startup the server logs the selected provider name
and whether future calls are enabled, never a key. Missing configuration, the
per-user quota, an HTTP error, a rate limit, timeout, or invalid model output
all fall back to local rules and never make a save fail. A remote failure is
logged as a warning with its class or HTTP status only (`describeAiFailure` in
`pinne_server/lib/src/ai/ai_provider.dart`), never the key, prompt or response.

The app lists an item's pending suggestions on its Saved card, where each can
be accepted (it updates the item's collections, tags or summary) or dismissed.

The same organizing service runs through durable future calls when the hosting
plan supports them and inline on Serverpod Cloud Starter. Starter still cannot
run link previews, so its link organizing uses saved metadata only.

## Verified Groq choice (2026-10-12)

The primary model is the production model ID `openai/gpt-oss-20b`. Groq lists
it as a hosted model and supports strict structured outputs for it:

- <https://console.groq.com/docs/models>
- <https://console.groq.com/docs/structured-outputs>

Groq's Services Agreement permits API integration into customer applications
for end users and includes EEA/Swiss regional terms. Its free service has no
published EEA, Switzerland, or UK exclusion like Gemini's unpaid tier:
<https://console.groq.com/docs/legal/services-agreement>.

Pinne posts directly to
`https://api.groq.com/openai/v1/chat/completions` with a bearer token. The
request uses low reasoning effort and the documented strict JSON Schema shape:

```json
{
  "model": "openai/gpt-oss-20b",
  "messages": [
    {"role": "system", "content": "..."},
    {"role": "user", "content": "..."}
  ],
  "response_format": {
    "type": "json_schema",
    "json_schema": {
      "name": "pinne_organization",
      "strict": true,
      "schema": {"type": "object", "additionalProperties": false}
    }
  },
  "reasoning_effort": "low"
}
```

Strict mode constrains generation to the schema, but Pinne still treats the
response as untrusted. Groq and Gemini share one prompt and schema, and the
same local validator checks fields, collection ownership, lengths, tag count,
summary sentence count, and evidence coverage before anything is stored.

Groq publishes Free-plan limits for GPT-OSS 20B of 30 requests/minute, 1,000
requests/day, 8,000 tokens/minute, and 200,000 tokens/day. Account-specific
limits remain authoritative: <https://console.groq.com/docs/rate-limits>.
Pinne separately caps remote organizing at 20 items per owner per UTC day.

## Data use and disclosure

Groq's Services Agreement says it may not train or fine-tune models on inputs
or outputs unless the customer explicitly gives permission or instructions.
Groq's data documentation says inference requests are not retained by default.
It may temporarily log inputs and outputs for platform reliability or suspected
abuse, for up to 30 days; Groq also offers a Zero Data Retention control.

- <https://console.groq.com/docs/legal/services-agreement>
- <https://console.groq.com/docs/your-data>

The Settings disclosure for Groq therefore says:

> When AI organizing is on, Pinne sends the saved item's title, URL, source
> platform, your intention and notes, plus the names and IDs of your
> collections and any stored preview description, author and site name, to
> GroqCloud. It does not fetch the page. Groq says it does not train models on
> inputs or outputs unless the customer explicitly permits it. Requests are
> not retained by default, but Groq may temporarily log inputs and outputs for
> up to 30 days for reliability or suspected abuse. Turn this off to organize
> on this server with simple rules only.

If only `geminiApiKey` is configured, Settings instead names Gemini and shows
the Gemini-specific disclosure. Gemini remains secondary because its unpaid
service may not power an API client exposed to users in the EEA, Switzerland,
or the UK. See <https://ai.google.dev/gemini-api/terms>.

## Configuration

Create a Groq key at <https://console.groq.com/keys>. Store `groqApiKey` only
in the git-ignored `pinne_server/config/passwords.yaml` or the matching
`SERVERPOD_PASSWORD_groqApiKey` environment variable. `geminiApiKey` may remain
configured as a secondary provider, but it is selected only when the Groq key
is absent. Never commit either key.
