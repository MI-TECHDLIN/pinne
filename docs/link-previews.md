# Link previews

Pinne fetches previews after a save has completed. Preview text is untrusted,
normalized plain text; provider HTML is never stored or rendered. A preview
failure changes only the preview/access state and never deletes the saved link
or claims that its source was deleted.

## Provider policy

Verified 2026-10-09 against provider documentation:

| Provider | Public metadata path | Credentials | Limits and terms |
| --- | --- | --- | --- |
| YouTube | `GET https://www.youtube.com/oembed?url=…&format=json` for public video URLs | None for oEmbed. The separate [YouTube Data API requires an API key or OAuth](https://developers.google.com/youtube/v3/docs). | Google does not publish a numeric oEmbed allowance. Pinne spaces requests per host, honors `429`, and uses bounded retries. Use is subject to the [YouTube API Services Terms](https://developers.google.com/youtube/terms/api-services-terms-of-service), including attribution and quota restrictions. |
| X | `GET https://publish.twitter.com/oembed?url=…&omit_script=true&dnt=true` for public posts | None for the documented oEmbed route; Pinne converts any returned blockquote to plain text and discards the HTML. | X does not publish a numeric oEmbed allowance on its current documentation surface. Pinne treats `429` as retryable and spaces requests. The legacy [official oEmbed documentation URL](https://developer.x.com/en/docs/x-for-websites/oembed-api) currently redirects to the X docs overview; this is intentionally not replaced with an unofficial API. Use is subject to the [X Developer Policy](https://docs.x.com/developer-terms/policy). |
| TikTok | [`GET https://www.tiktok.com/oembed?url=…`](https://developers.tiktok.com/docs/en/embed-videos) for public videos | None for oEmbed. | TikTok documents the endpoint and response but no oEmbed-specific numeric limit. Its documented API-v2 limits are endpoint-specific and return `429`; they do not state an oEmbed quota. Pinne applies its own politeness interval and bounded retry and follows the [TikTok Developer Terms](https://t.tiktok.com/legal/page/global/tik-tok-developer-terms-of-service/en). |
| Instagram / Facebook | Open Graph from the public page only | Meta's [oEmbed Read feature](https://developers.facebook.com/docs/features-reference/oembed-read) is token/app-review gated, so Pinne does not call it. | No login scraping and no unofficial API. Login-walled pages remain `loginRequired`; public pages may supply Open Graph metadata. |
| Other sites | Open Graph, Twitter-card tags, then `<title>` | None | Only the public page is requested. Robots/login walls, unsupported content, and failed fetches remain honest partial/failed states. |

Provider terms and endpoints can change. Re-check this table before enabling a
new provider or changing retention/display behavior.

## Security boundary

`RestrictedFetcher` accepts credential-free HTTP(S) URLs only. It resolves DNS
itself, rejects loopback, private, link-local, CGNAT, multicast, reserved,
IPv6 unique-local/site-local, and metadata-service addresses, and connects to
the checked address. Every redirect is independently resolved and checked,
with at most three redirects. Requests send no cookies or authorization, use a
clear Pinne user agent, and have short connect/total timeouts. Compressed and
decompressed bodies are each capped at 1 MiB; only HTML and JSON are accepted.

The same URL validation is applied to thumbnail URLs before they are returned
to a client. Images are displayed by Flutter from their source URL with an
error fallback; Pinne does not download or rehost them in this version.

## Evidence and states

Official oEmbed is preferred for YouTube, X, and TikTok. Other public pages use
`og:*`, Twitter-card tags, and `<title>`. Duration is stored only when the page
states `og:video:duration` or an `itemprop=duration` value; it is never guessed.

`accessState` says what the preview attempt established (`available`,
`loginRequired`, `unavailable`, or `unknown`). `enrichmentState` tracks the
background work (`pending`, `processing`, `ready`, `partial`, or `failed`). A
successful preview requeues AI organizing with `metadata_plus_preview`
evidence. User-edited titles are locked and never replaced by preview data.
