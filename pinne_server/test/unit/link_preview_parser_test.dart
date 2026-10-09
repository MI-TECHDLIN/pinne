import 'dart:io';

import 'package:pinne_server/src/link_previews/link_preview_parser.dart';
import 'package:test/test.dart';

void main() {
  test('parses official oEmbed fixture without retaining provider HTML', () {
    final source = File('test/fixtures/youtube_oembed.json').readAsStringSync();
    final preview = LinkPreviewParser.oEmbed(
      source,
      Uri.parse('https://www.youtube.com/watch?v=example'),
    );

    expect(preview.title, 'Build a calm review habit');
    expect(preview.author, 'Pinne Studio');
    expect(preview.siteName, 'YouTube');
    expect(preview.thumbnailUrl?.host, 'i.ytimg.com');
    expect(preview.metadata, isNot(contains('html')));
    expect(preview.durationSeconds, isNull, reason: 'oEmbed did not state it');
  });

  test('parses Open Graph fixture and only accepts stated duration', () {
    final source = File(
      'test/fixtures/article_open_graph.html',
    ).readAsStringSync();
    final preview = LinkPreviewParser.openGraph(
      source,
      Uri.parse('https://example.com/posts/one'),
    );

    expect(preview.title, 'A safer extraction pipeline');
    expect(preview.description, 'Parse evidence, not instructions.');
    expect(preview.author, 'A. Builder');
    expect(preview.siteName, 'Engineering Notes');
    expect(
      preview.thumbnailUrl,
      Uri.parse('https://example.com/images/preview.jpg'),
    );
    expect(preview.durationSeconds, 125);
  });

  test('turns oEmbed blockquote HTML into plain untrusted text only', () {
    final preview = LinkPreviewParser.oEmbed(
      '''{"provider_name":"X","author_name":"Pinne",
      "html":"<blockquote>Useful post text<script>steal()</script></blockquote>"}''',
      Uri.parse('https://x.com/pinne/status/1'),
    );
    expect(preview.title, 'Useful post text');
    expect(preview.author, 'Pinne');
    expect(preview.metadata, isNot(contains('html')));
  });

  test('normalizes and caps untrusted text', () {
    final preview = LinkPreviewParser.openGraph(
      '<title>${List.filled(400, 'x').join()}\u0000</title>',
      Uri.parse('https://example.com'),
    );
    expect(preview.title, hasLength(300));
    expect(preview.title, isNot(contains('\u0000')));
  });

  test('reads an explicitly stated ISO duration from itemprop', () {
    final preview = LinkPreviewParser.openGraph(
      '<title>Video</title><time itemprop="duration" datetime="PT1H2M3S"></time>',
      Uri.parse('https://example.com/video'),
    );
    expect(preview.durationSeconds, 3723);
  });
}
