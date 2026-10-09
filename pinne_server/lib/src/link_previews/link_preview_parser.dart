import 'dart:convert';

import 'package:html/parser.dart' as html;

class LinkPreview {
  const LinkPreview({
    this.title,
    this.description,
    this.author,
    this.siteName,
    this.provider,
    this.thumbnailUrl,
    this.durationSeconds,
    this.loginWall = false,
    this.metadata = const {},
  });

  final String? title;
  final String? description;
  final String? author;
  final String? siteName;
  final String? provider;
  final Uri? thumbnailUrl;
  final int? durationSeconds;
  final bool loginWall;
  final Map<String, Object?> metadata;

  bool get hasEvidence =>
      title != null ||
      description != null ||
      author != null ||
      siteName != null ||
      thumbnailUrl != null;
}

class LinkPreviewParser {
  static LinkPreview oEmbed(String source, Uri baseUri) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) return const LinkPreview();
    final thumbnail = _uri(decoded['thumbnail_url'], baseUri);
    final provider = _text(decoded['provider_name'], 120);
    String? title = _text(decoded['title'], 300);
    if (title == null && decoded['html'] is String) {
      final fragment = html.parseFragment(decoded['html'] as String);
      for (final element in fragment.querySelectorAll('script, style')) {
        element.remove();
      }
      title = _text(fragment.querySelector('blockquote')?.text, 300);
    }
    return LinkPreview(
      title: title,
      author: _text(decoded['author_name'], 160),
      siteName: provider,
      provider: provider,
      thumbnailUrl: thumbnail,
      metadata: {
        'source': 'oembed',
        if (decoded['type'] is String) 'type': _text(decoded['type'], 40),
      },
    );
  }

  static LinkPreview openGraph(String source, Uri baseUri) {
    final document = html.parse(source);
    final values = <String, String>{};
    for (final element in document.querySelectorAll('meta')) {
      final key =
          (element.attributes['property'] ??
                  element.attributes['name'] ??
                  element.attributes['itemprop'])
              ?.trim()
              .toLowerCase();
      final content = element.attributes['content'];
      if (key != null && content != null && !values.containsKey(key)) {
        values[key] = content;
      }
    }
    String? pick(List<String> keys, int max) {
      for (final key in keys) {
        final value = _text(values[key], max);
        if (value != null) return value;
      }
      return null;
    }

    final rawTitle =
        pick(const ['og:title', 'twitter:title'], 300) ??
        _text(document.querySelector('title')?.text, 300);
    final durationElement = document.querySelector('[itemprop="duration"]');
    final duration = _duration(
      values['og:video:duration'] ??
          values['duration'] ??
          durationElement?.attributes['content'] ??
          durationElement?.attributes['datetime'] ??
          durationElement?.text,
    );
    final loginText =
        '${rawTitle ?? ''} ${source.substring(0, source.length.clamp(0, 20000))}'
            .toLowerCase();
    final loginWall = RegExp(
      r'\b(log ?in|sign ?in)\b.{0,80}\b(continue|view|account|required)\b|'
      r'\b(create an account|you must be logged in)\b',
    ).hasMatch(loginText);
    final image = pick(
      const ['og:image:secure_url', 'og:image', 'twitter:image'],
      2048,
    );
    return LinkPreview(
      title: rawTitle,
      description: pick(
        const ['og:description', 'twitter:description', 'description'],
        1000,
      ),
      author: pick(const ['author', 'article:author'], 160),
      siteName: pick(const ['og:site_name', 'twitter:site'], 160),
      provider: 'Open Graph',
      thumbnailUrl: _uri(image, baseUri),
      durationSeconds: duration,
      loginWall: loginWall,
      metadata: {
        'source': 'open_graph',
        if (duration != null) 'durationKnown': true,
      },
    );
  }

  static String? _text(Object? raw, int max) {
    if (raw is! String) return null;
    final cleaned = raw
        .replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) return null;
    return cleaned.length <= max
        ? cleaned
        : cleaned.substring(0, max).trimRight();
  }

  static Uri? _uri(Object? raw, Uri base) {
    final value = _text(raw, 2048);
    if (value == null) return null;
    final uri = base.resolve(value);
    if ((uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      return null;
    }
    return uri;
  }

  static int? _duration(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;
    final seconds = int.tryParse(value);
    if (seconds != null && seconds >= 0 && seconds <= 86400 * 7) {
      return seconds;
    }
    final match = RegExp(
      r'^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$',
      caseSensitive: false,
    ).firstMatch(value);
    if (match == null) return null;
    final result =
        (int.tryParse(match.group(1) ?? '') ?? 0) * 3600 +
        (int.tryParse(match.group(2) ?? '') ?? 0) * 60 +
        (int.tryParse(match.group(3) ?? '') ?? 0);
    return result <= 86400 * 7 ? result : null;
  }
}
