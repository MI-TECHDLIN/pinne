import 'package:pinne_capture/pinne_capture.dart';
import 'package:test/test.dart';

/// One row of the detection and normalization table.
typedef Row = ({
  String url,
  CaptureSource source,
  String? id,
  String canonical,
});

const _table = <Row>[
  // X and Twitter.
  (
    url: 'https://x.com/someone/status/1844123456789012345',
    source: CaptureSource.x,
    id: '1844123456789012345',
    canonical: 'https://x.com/someone/status/1844123456789012345',
  ),
  (
    url: 'https://twitter.com/SomeOne/status/1844123456789012345?s=20&t=abc',
    source: CaptureSource.x,
    id: '1844123456789012345',
    canonical: 'https://x.com/someone/status/1844123456789012345',
  ),
  (
    url:
        'https://mobile.twitter.com/someone/status/1844123456789012345/photo/1',
    source: CaptureSource.x,
    id: '1844123456789012345',
    canonical: 'https://x.com/someone/status/1844123456789012345',
  ),
  (
    url: 'https://x.com/i/web/status/1844123456789012345',
    source: CaptureSource.x,
    id: '1844123456789012345',
    canonical: 'https://x.com/i/status/1844123456789012345',
  ),
  (
    url: 'https://www.x.com/someone',
    source: CaptureSource.x,
    id: null,
    canonical: 'https://x.com/someone',
  ),
  // YouTube: long, short, shorts and other id-bearing forms.
  (
    url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    source: CaptureSource.youtube,
    id: 'dQw4w9WgXcQ',
    canonical: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  ),
  (
    url: 'https://youtu.be/dQw4w9WgXcQ?si=Tr4ck1ng',
    source: CaptureSource.youtube,
    id: 'dQw4w9WgXcQ',
    canonical: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  ),
  (
    url: 'https://youtube.com/shorts/dQw4w9WgXcQ?feature=share',
    source: CaptureSource.youtube,
    id: 'dQw4w9WgXcQ',
    canonical: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  ),
  (
    url: 'https://m.youtube.com/watch?feature=youtu.be&v=dQw4w9WgXcQ&list=PL1',
    source: CaptureSource.youtube,
    id: 'dQw4w9WgXcQ',
    canonical: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  ),
  (
    url: 'https://www.youtube.com/live/dQw4w9WgXcQ',
    source: CaptureSource.youtube,
    id: 'dQw4w9WgXcQ',
    canonical: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  ),
  (
    url: 'https://www.youtube.com/playlist?list=PLabcdef12',
    source: CaptureSource.youtube,
    id: 'playlist:PLabcdef12',
    canonical: 'https://www.youtube.com/playlist?list=PLabcdef12',
  ),
  (
    url: 'https://www.youtube.com/@flutterdev/',
    source: CaptureSource.youtube,
    id: null,
    canonical: 'https://www.youtube.com/@flutterdev',
  ),
  (
    url: 'https://www.youtube.com/watch?v=tooShort',
    source: CaptureSource.youtube,
    id: null,
    canonical: 'https://www.youtube.com/watch?v=tooShort',
  ),
  // Instagram.
  (
    url: 'https://www.instagram.com/p/C9xYz12AbCd/?igsh=MWZ0bXd',
    source: CaptureSource.instagram,
    id: 'C9xYz12AbCd',
    canonical: 'https://www.instagram.com/p/C9xYz12AbCd/',
  ),
  (
    url: 'https://instagram.com/reels/C9xYz12AbCd?utm_source=ig_web_copy_link',
    source: CaptureSource.instagram,
    id: 'C9xYz12AbCd',
    canonical: 'https://www.instagram.com/reel/C9xYz12AbCd/',
  ),
  (
    url: 'https://www.instagram.com/someone/reel/C9xYz12AbCd/',
    source: CaptureSource.instagram,
    id: 'C9xYz12AbCd',
    canonical: 'https://www.instagram.com/reel/C9xYz12AbCd/',
  ),
  (
    url: 'https://www.instagram.com/someone/',
    source: CaptureSource.instagram,
    id: null,
    canonical: 'https://www.instagram.com/someone',
  ),
  // TikTok.
  (
    url: 'https://www.tiktok.com/@Some.One/video/7301234567890123456?_r=1',
    source: CaptureSource.tiktok,
    id: '7301234567890123456',
    canonical: 'https://www.tiktok.com/@some.one/video/7301234567890123456',
  ),
  (
    url: 'https://vm.tiktok.com/ZMabc123/',
    source: CaptureSource.tiktok,
    id: null,
    canonical: 'https://vm.tiktok.com/ZMabc123',
  ),
  // Reddit.
  (
    url:
        'https://www.reddit.com/r/FlutterDev/comments/1abcde/some_title/'
        '?utm_source=share&utm_medium=web2x',
    source: CaptureSource.reddit,
    id: '1abcde',
    canonical: 'https://www.reddit.com/r/flutterdev/comments/1abcde/',
  ),
  (
    url:
        'https://old.reddit.com/r/FlutterDev/comments/1abcde/some_title/kx9z8y/',
    source: CaptureSource.reddit,
    id: '1abcde/kx9z8y',
    canonical:
        'https://www.reddit.com/r/flutterdev/comments/1abcde/comment/kx9z8y/',
  ),
  (
    url: 'https://redd.it/1abcde',
    source: CaptureSource.reddit,
    id: '1abcde',
    canonical: 'https://www.reddit.com/comments/1abcde/',
  ),
  (
    url: 'https://www.reddit.com/r/FlutterDev/s/AbCdEf123',
    source: CaptureSource.reddit,
    id: null,
    canonical: 'https://www.reddit.com/r/FlutterDev/s/AbCdEf123',
  ),
  // GitHub.
  (
    url: 'https://github.com/Flutter/Flutter',
    source: CaptureSource.github,
    id: 'flutter/flutter',
    canonical: 'https://github.com/flutter/flutter',
  ),
  (
    url: 'https://github.com/serverpod/serverpod.git',
    source: CaptureSource.github,
    id: 'serverpod/serverpod',
    canonical: 'https://github.com/serverpod/serverpod',
  ),
  (
    url: 'https://github.com/flutter/flutter/pulls/12345#issuecomment-1',
    source: CaptureSource.github,
    id: 'flutter/flutter/pull/12345',
    canonical: 'https://github.com/flutter/flutter/pull/12345',
  ),
  (
    url: 'https://github.com/flutter/flutter/blob/main/README.md',
    source: CaptureSource.github,
    id: null,
    canonical: 'https://github.com/flutter/flutter/blob/main/README.md',
  ),
  (
    url: 'https://github.com/settings/profile',
    source: CaptureSource.github,
    id: null,
    canonical: 'https://github.com/settings/profile',
  ),
  // Generic web.
  (
    url:
        'https://www.Example.com/flutter-desktop-sidebar/'
        '?utm_source=newsletter&b=2&a=1&fbclid=xyz#intro',
    source: CaptureSource.web,
    id: null,
    canonical: 'https://example.com/flutter-desktop-sidebar?a=1&b=2',
  ),
  (
    url: 'http://blog.example.org:80/post?id=7&ref=hn',
    source: CaptureSource.web,
    id: null,
    canonical: 'http://blog.example.org/post?id=7',
  ),
  (
    url: 'https://app.example.com/#/articles/42',
    source: CaptureSource.web,
    id: null,
    canonical: 'https://app.example.com/#/articles/42',
  ),
  // Unknown: shorteners, private hosts and credentials in the link.
  (
    url: 'https://bit.ly/3xYzAbC',
    source: CaptureSource.unknown,
    id: null,
    canonical: 'https://bit.ly/3xYzAbC',
  ),
  (
    url: 'https://t.co/AbCdEfGh12',
    source: CaptureSource.unknown,
    id: null,
    canonical: 'https://t.co/AbCdEfGh12',
  ),
  (
    url: 'http://localhost:8080/items',
    source: CaptureSource.unknown,
    id: null,
    canonical: 'http://localhost:8080/items',
  ),
  (
    url: 'http://192.168.1.20/admin',
    source: CaptureSource.unknown,
    id: null,
    canonical: 'http://192.168.1.20/admin',
  ),
  (
    url: 'https://x.com@phish.example/status/1',
    source: CaptureSource.unknown,
    id: null,
    canonical: 'https://phish.example/status/1',
  ),
];

void main() {
  group('normalizeLink detection and normalization table', () {
    for (final row in _table) {
      test(row.url, () {
        final link = normalizeLink(row.url);
        expect(link, isNotNull);
        expect(link!.source, row.source, reason: 'source');
        expect(link.sourceItemId, row.id, reason: 'source item id');
        expect(link.canonicalUrl, row.canonical, reason: 'canonical URL');
      });
    }
  });

  group('tracking-parameter variants of one item', () {
    void expectSameItem(List<String> urls) {
      final links = urls.map(normalizeLink).toList();
      final first = links.first!;
      for (final link in links) {
        expect(link!.canonicalUrl, first.canonicalUrl);
        expect(link.sourceItemId, first.sourceItemId);
        expect(link.source, first.source);
      }
    }

    test('YouTube video shared from the app, the web and as a short', () {
      expectSameItem([
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        'https://youtu.be/dQw4w9WgXcQ?si=abc123',
        'https://youtube.com/watch?v=dQw4w9WgXcQ&pp=ygUE&feature=shared',
        'https://www.youtube.com/shorts/dQw4w9WgXcQ',
      ]);
    });

    test('X post copied with share parameters', () {
      expectSameItem([
        'https://x.com/someone/status/1844123456789012345',
        'https://twitter.com/someone/status/1844123456789012345?s=46&t=Zz9',
        'https://x.com/someone/status/1844123456789012345?ref_src=twsrc',
      ]);
    });

    test('Instagram post with igshid and utm parameters', () {
      expectSameItem([
        'https://www.instagram.com/p/C9xYz12AbCd/',
        'https://www.instagram.com/p/C9xYz12AbCd/?igshid=MzRlODBiNWFlZA==',
        'https://instagram.com/p/C9xYz12AbCd?utm_source=ig_web_copy_link',
      ]);
    });

    test('article with utm, fbclid, gclid and a reordered query', () {
      expectSameItem([
        'https://example.com/post?b=2&a=1',
        'https://www.example.com/post/?a=1&b=2&utm_campaign=x&utm_medium=y',
        'https://example.com/post?fbclid=IwAR0&a=1&gclid=Cj0&b=2#comments',
        'https://example.com/post?UTM_Source=caps&a=1&b=2&si=s&igshid=i',
      ]);
    });
  });

  group('clean URL', () {
    test('keeps the YouTube start time but not tracking', () {
      final link = normalizeLink('https://youtu.be/dQw4w9WgXcQ?si=abc&t=42');
      expect(
        link!.cleanUrl,
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=42',
      );
      expect(link.canonicalUrl, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ');
    });

    test('keeps the original order and drops a text fragment', () {
      final link = normalizeLink(
        'https://Example.com/a?z=1&utm_source=x&b=2#:~:text=hello',
      );
      expect(link!.cleanUrl, 'https://example.com/a?z=1&b=2');
    });

    test('keeps an ordinary fragment for opening', () {
      final link = normalizeLink('https://example.com/a#section-2');
      expect(link!.cleanUrl, 'https://example.com/a#section-2');
      expect(link.canonicalUrl, 'https://example.com/a');
    });
  });

  group('content type guess', () {
    test('comes from the URL shape only', () {
      expect(
        normalizeLink('https://youtu.be/dQw4w9WgXcQ')!.contentType,
        CaptureContentType.video,
      );
      expect(
        normalizeLink('https://x.com/a/status/1')!.contentType,
        CaptureContentType.post,
      );
      expect(
        normalizeLink('https://example.com/post')!.contentType,
        CaptureContentType.other,
      );
    });
  });

  group('not a web link', () {
    for (final input in [
      '',
      '   ',
      'just some words',
      'ftp://example.com/file',
      'mailto:someone@example.com',
      'javascript:alert(1)',
      'intent://scan/#Intent;scheme=zxing;end',
      'https://',
      'x.com/someone/status/1',
    ]) {
      test('"$input" is null', () => expect(normalizeLink(input), isNull));
    }
  });

  group('display title', () {
    test('is a readable host and path', () {
      expect(
        normalizeLink('https://x.com/someone/status/1844')!.displayTitle,
        'x.com/someone/status/1844',
      );
      expect(
        normalizeLink('https://www.example.com/caf%C3%A9/menu/')!.displayTitle,
        'example.com/café/menu',
      );
    });

    test('is shortened for long URLs', () {
      final long = 'https://example.com/${'a' * 200}';
      final title = normalizeLink(long)!.displayTitle;
      expect(title.runes.length, CaptureLimits.derivedTitleLength);
      expect(title, endsWith('…'));
    });
  });

  test('every source has a short text label', () {
    for (final source in CaptureSource.values) {
      expect(source.label, isNotEmpty);
      expect(source.label.length, lessThanOrEqualTo(10));
    }
    expect(CaptureSource.youtube.label, 'YouTube');
    expect(CaptureSource.unknown.label, 'Unknown');
  });
}
