import 'capture_limits.dart';
import 'capture_source.dart';
import 'text.dart';

/// A shared web link read from its text alone. Nothing here fetches the URL
/// or follows redirects, so a short link stays as ambiguous as it really is.
final class NormalizedLink {
  const NormalizedLink({
    required this.source,
    required this.canonicalUrl,
    required this.cleanUrl,
    this.sourceItemId,
    this.contentType = CaptureContentType.other,
  });

  final CaptureSource source;

  /// The platform's own id for the item: a post id, a video id, a repository
  /// name. Null when the link names a page rather than one item, or when the
  /// item cannot be told without following the link.
  final String? sourceItemId;

  /// The identity URL used to recognise the same item again. Tracking
  /// parameters, fragments and cosmetic differences such as `www.`, mobile
  /// hosts or old domains are removed.
  final String canonicalUrl;

  /// The link as shared, minus tracking parameters. Used for opening, so
  /// options that do not change identity, such as a YouTube start time, are
  /// kept.
  final String cleanUrl;

  final CaptureContentType contentType;

  /// Readable host and path, used as the title until a better one is known.
  String get displayTitle => readableUrl(canonicalUrl);

  @override
  bool operator ==(Object other) =>
      other is NormalizedLink &&
      other.source == source &&
      other.sourceItemId == sourceItemId &&
      other.canonicalUrl == canonicalUrl &&
      other.cleanUrl == cleanUrl &&
      other.contentType == contentType;

  @override
  int get hashCode =>
      Object.hash(source, sourceItemId, canonicalUrl, cleanUrl, contentType);

  @override
  String toString() =>
      'NormalizedLink(${source.name}, id: $sourceItemId, '
      'canonical: $canonicalUrl, clean: $cleanUrl, ${contentType.name})';
}

/// Reads an absolute http or https URL. Returns null for anything else,
/// including other schemes, so such text is treated as a note.
NormalizedLink? normalizeLink(String input) {
  final uri = _parseWebUri(input);
  if (uri == null) return null;

  // Credentials before the host (`https://x.com@other.example/`) are
  // dropped: the link opens the real host, so that host is what counts.
  final host = _hostOf(uri);
  if (!_looksPublic(host)) return _generic(uri, CaptureSource.unknown);
  final bare = _withoutPrefixes(host);
  if (_shorteners.contains(bare)) return _generic(uri, CaptureSource.unknown);

  final segments = [
    for (final segment in uri.pathSegments)
      if (segment.isNotEmpty) segment,
  ];
  return switch (bare) {
    'x.com' ||
    'twitter.com' ||
    'fxtwitter.com' ||
    'vxtwitter.com' ||
    'fixupx.com' => _x(uri, segments),
    'youtube.com' ||
    'music.youtube.com' ||
    'youtube-nocookie.com' => _youtube(uri, segments),
    'youtu.be' => _youtuBe(uri, segments),
    'instagram.com' || 'instagr.am' => _instagram(uri, segments),
    'tiktok.com' => _tiktok(uri, segments),
    'vm.tiktok.com' || 'vt.tiktok.com' => _generic(uri, CaptureSource.tiktok),
    'reddit.com' ||
    'old.reddit.com' ||
    'new.reddit.com' ||
    'np.reddit.com' => _reddit(uri, segments),
    'redd.it' => _reddIt(uri, segments),
    'github.com' => _github(uri, segments),
    'gist.github.com' => _gist(uri, segments),
    _ => _generic(uri, CaptureSource.web),
  };
}

/// A URL without its scheme, `www.` or trailing slash, percent-decoded and
/// shortened for display.
String readableUrl(String url) {
  var text = url.replaceFirst(RegExp(r'^[a-z]+://', caseSensitive: false), '');
  if (text.startsWith('www.')) text = text.substring(4);
  while (text.endsWith('/')) {
    text = text.substring(0, text.length - 1);
  }
  try {
    text = Uri.decodeFull(text);
  } on ArgumentError {
    // Keep the encoded form when it does not decode cleanly.
  } on FormatException {
    // Same as above.
  }
  return truncateRunes(text, CaptureLimits.derivedTitleLength);
}

/// Query parameters that only record how a link was shared or clicked.
/// Matched case-insensitively; every `utm_` parameter is also tracking.
const trackingParameters = {
  'fbclid',
  'gclid',
  'gclsrc',
  'dclid',
  'gbraid',
  'wbraid',
  'msclkid',
  'yclid',
  'twclid',
  'ttclid',
  'igshid',
  'igsh',
  'si',
  'ref',
  'ref_src',
  'ref_url',
  'mc_cid',
  'mc_eid',
  '_hsenc',
  '_hsmi',
  'mkt_tok',
  'li_fat_id',
  'srsltid',
  '_ga',
  '_gl',
  'rdt',
};

bool _isTracking(String key) {
  final lower = key.toLowerCase();
  return lower.startsWith('utm_') || trackingParameters.contains(lower);
}

/// Generic link shorteners. Where they lead is unknown without a network
/// request, which capture never makes.
const _shorteners = {
  'bit.ly',
  'bl.ink',
  'buff.ly',
  'cutt.ly',
  'dlvr.it',
  'fb.me',
  'g.co',
  'goo.gl',
  'ift.tt',
  'is.gd',
  'lnkd.in',
  'ow.ly',
  'qr.ae',
  'rb.gy',
  'rebrand.ly',
  's.id',
  'shorturl.at',
  't.co',
  't.ly',
  'tiny.cc',
  'tinyurl.com',
  'trib.al',
  'v.gd',
};

Uri? _parseWebUri(String input) {
  final text = input.trim();
  if (text.isEmpty || text.length > CaptureLimits.maxUrlLength) return null;
  final Uri uri;
  try {
    uri = Uri.parse(text);
  } on FormatException {
    return null;
  }
  final scheme = uri.scheme.toLowerCase();
  if (scheme != 'http' && scheme != 'https') return null;
  if (uri.host.isEmpty) return null;
  return uri;
}

String _hostOf(Uri uri) {
  var host = uri.host.toLowerCase();
  while (host.endsWith('.')) {
    host = host.substring(0, host.length - 1);
  }
  return host;
}

final _ipv4 = RegExp(r'^\d{1,3}(\.\d{1,3}){3}$');

/// A host a person could share from the public web. Bare names such as
/// `localhost`, IP addresses and local-network names are ambiguous.
bool _looksPublic(String host) {
  if (!host.contains('.') || host.contains(':') || _ipv4.hasMatch(host)) {
    return false;
  }
  const privateSuffixes = ['.local', '.localhost', '.internal', '.lan'];
  return !privateSuffixes.any(host.endsWith);
}

String _withoutPrefixes(String host) {
  for (final prefix in const ['www.', 'm.', 'mobile.']) {
    if (host.startsWith(prefix)) return host.substring(prefix.length);
  }
  return host;
}

String _withoutWww(String host) =>
    host.startsWith('www.') ? host.substring(4) : host;

/// The raw `key=value` parts of the query that are not tracking, in their
/// original order and encoding.
List<String> _keptQuery(Uri uri) {
  if (!uri.hasQuery) return const [];
  return [
    for (final part in uri.query.split('&'))
      if (part.isNotEmpty && !_isTracking(_decodeKey(part))) part,
  ];
}

String _decodeKey(String part) {
  final key = part.split('=').first;
  try {
    return Uri.decodeQueryComponent(key);
  } on ArgumentError {
    return key;
  } on FormatException {
    return key;
  }
}

/// The first value of query parameter [name], decoded, or null.
String? _queryValue(Uri uri, String name) {
  if (!uri.hasQuery) return null;
  for (final part in uri.query.split('&')) {
    final separator = part.indexOf('=');
    if (separator < 0 || _decodeKey(part) != name) continue;
    try {
      return Uri.decodeQueryComponent(part.substring(separator + 1));
    } on ArgumentError {
      return null;
    } on FormatException {
      return null;
    }
  }
  return null;
}

String _portOf(Uri uri) {
  if (!uri.hasPort) return '';
  final isDefault =
      (uri.scheme == 'https' && uri.port == 443) ||
      (uri.scheme == 'http' && uri.port == 80);
  return isDefault ? '' : ':${uri.port}';
}

/// Cleans a link without platform knowledge. The canonical form drops
/// `www.`, a trailing slash, tracking parameters and fragments, and sorts
/// the remaining parameters. Hash routes (`#/…`, `#!…`) are identity, so
/// they stay.
NormalizedLink _generic(
  Uri uri,
  CaptureSource source, {
  String? canonicalHost,
}) {
  final host = _hostOf(uri);
  final port = _portOf(uri);
  final kept = _keptQuery(uri);
  final fragment = uri.fragment;

  var path = uri.path.isEmpty ? '/' : uri.path;
  while (path.length > 1 && path.endsWith('/')) {
    path = path.substring(0, path.length - 1);
  }
  final sorted = [...kept]..sort();
  final keepFragment = fragment.startsWith('/') || fragment.startsWith('!');
  final scheme = canonicalHost == null ? uri.scheme : 'https';
  final canonical = StringBuffer(
    '$scheme://${canonicalHost ?? _withoutWww(host)}$port$path',
  );
  if (sorted.isNotEmpty) canonical.write('?${sorted.join('&')}');
  if (keepFragment) canonical.write('#$fragment');

  final clean = StringBuffer('${uri.scheme}://$host$port${uri.path}');
  if (kept.isNotEmpty) clean.write('?${kept.join('&')}');
  if (fragment.isNotEmpty && !fragment.startsWith(':~:')) {
    clean.write('#$fragment');
  }

  return NormalizedLink(
    source: source,
    canonicalUrl: canonical.toString(),
    cleanUrl: clean.toString(),
  );
}

NormalizedLink _item(
  CaptureSource source,
  String id,
  String canonical, {
  required CaptureContentType type,
  String? clean,
}) => NormalizedLink(
  source: source,
  sourceItemId: id,
  canonicalUrl: canonical,
  cleanUrl: clean ?? canonical,
  contentType: type,
);

final _digits = RegExp(r'^\d{1,25}$');
final _xHandle = RegExp(r'^[A-Za-z0-9_]{1,15}$');

/// `x.com/{user}/status/{id}`, `/i/status/{id}` and `/i/web/status/{id}`,
/// on x.com, twitter.com and the common embed-fixing mirrors. Trailing
/// `/photo/1` and every query parameter are dropped.
NormalizedLink _x(Uri uri, List<String> s) {
  String? user;
  String? id;
  if (s.length >= 3 && (s[1] == 'status' || s[1] == 'statuses')) {
    user = s[0];
    id = s[2];
  } else if (s.length >= 4 &&
      s[0] == 'i' &&
      s[1] == 'web' &&
      s[2] == 'status') {
    id = s[3];
  }
  if (id != null && _digits.hasMatch(id)) {
    final named = user != null && user != 'i' && _xHandle.hasMatch(user);
    final canonical = named
        ? 'https://x.com/${user.toLowerCase()}/status/$id'
        : 'https://x.com/i/status/$id';
    return _item(
      CaptureSource.x,
      id,
      canonical,
      type: CaptureContentType.post,
    );
  }
  return _generic(uri, CaptureSource.x, canonicalHost: 'x.com');
}

final _youtubeId = RegExp(r'^[A-Za-z0-9_-]{11}$');
final _youtubeList = RegExp(r'^[A-Za-z0-9_-]{2,64}$');
final _youtubeTime = RegExp(r'^[0-9]{1,6}s?$|^([0-9]{1,3}[hms]){1,3}$');

NormalizedLink _youtube(Uri uri, List<String> s) {
  if (s.length == 1 && s[0] == 'watch') {
    final id = _queryValue(uri, 'v');
    if (id != null) return _youtubeVideo(uri, id);
  }
  const idPaths = {'shorts', 'live', 'embed', 'v', 'e'};
  if (s.length >= 2 && idPaths.contains(s[0])) return _youtubeVideo(uri, s[1]);
  if (s.length == 1 && s[0] == 'playlist') {
    final list = _queryValue(uri, 'list');
    if (list != null && _youtubeList.hasMatch(list)) {
      return _item(
        CaptureSource.youtube,
        'playlist:$list',
        'https://www.youtube.com/playlist?list=$list',
        type: CaptureContentType.other,
      );
    }
  }
  return _generic(uri, CaptureSource.youtube, canonicalHost: 'www.youtube.com');
}

NormalizedLink _youtuBe(Uri uri, List<String> s) {
  if (s.isNotEmpty) return _youtubeVideo(uri, s[0]);
  return _generic(uri, CaptureSource.youtube, canonicalHost: 'www.youtube.com');
}

/// Every video form (watch, youtu.be, shorts, live, embed) shares one
/// canonical watch URL. The start time is not identity, so it is kept only
/// in the clean URL.
NormalizedLink _youtubeVideo(Uri uri, String id) {
  if (!_youtubeId.hasMatch(id)) {
    return _generic(
      uri,
      CaptureSource.youtube,
      canonicalHost: 'www.youtube.com',
    );
  }
  final canonical = 'https://www.youtube.com/watch?v=$id';
  final time = _queryValue(uri, 't') ?? _queryValue(uri, 'start');
  final timed = time != null && _youtubeTime.hasMatch(time);
  return _item(
    CaptureSource.youtube,
    id,
    canonical,
    type: CaptureContentType.video,
    clean: timed ? '$canonical&t=$time' : canonical,
  );
}

final _instagramCode = RegExp(r'^[A-Za-z0-9_-]{5,64}$');

/// `/p/{code}`, `/reel/{code}`, `/reels/{code}` and `/tv/{code}`, optionally
/// after a username. The shortcode is the item id.
NormalizedLink _instagram(Uri uri, List<String> s) {
  const kinds = {'p': 'p', 'reel': 'reel', 'reels': 'reel', 'tv': 'reel'};
  final at = s.isNotEmpty && kinds.containsKey(s[0])
      ? 0
      : (s.length >= 3 && kinds.containsKey(s[1]) ? 1 : -1);
  if (at >= 0 && s.length > at + 1 && _instagramCode.hasMatch(s[at + 1])) {
    final kind = kinds[s[at]]!;
    final code = s[at + 1];
    return _item(
      CaptureSource.instagram,
      code,
      'https://www.instagram.com/$kind/$code/',
      type: kind == 'p' ? CaptureContentType.post : CaptureContentType.video,
    );
  }
  return _generic(
    uri,
    CaptureSource.instagram,
    canonicalHost: 'www.instagram.com',
  );
}

final _tiktokUser = RegExp(r'^@[A-Za-z0-9._]{1,32}$');

/// `/@{user}/video/{id}`, `/@{user}/photo/{id}`, `/v/{id}.html` and
/// `/embed/v2/{id}`. Short links (`vm.`, `vt.`, `/t/`) stay TikTok without
/// an item id, because the id is only known after following them.
NormalizedLink _tiktok(Uri uri, List<String> s) {
  if (s.length >= 3 &&
      _tiktokUser.hasMatch(s[0]) &&
      (s[1] == 'video' || s[1] == 'photo') &&
      _digits.hasMatch(s[2])) {
    final user = s[0].toLowerCase();
    return _item(
      CaptureSource.tiktok,
      s[2],
      'https://www.tiktok.com/$user/${s[1]}/${s[2]}',
      type: s[1] == 'video'
          ? CaptureContentType.video
          : CaptureContentType.post,
    );
  }
  String? id;
  if (s.length == 2 && s[0] == 'v' && s[1].endsWith('.html')) {
    id = s[1].substring(0, s[1].length - '.html'.length);
  } else if (s.length >= 2 && s[0] == 'embed') {
    id = s.last;
  }
  if (id != null && _digits.hasMatch(id)) {
    return _item(
      CaptureSource.tiktok,
      id,
      'https://www.tiktok.com/embed/v2/$id',
      type: CaptureContentType.video,
    );
  }
  return _generic(uri, CaptureSource.tiktok, canonicalHost: 'www.tiktok.com');
}

final _base36 = RegExp(r'^[a-z0-9]{1,16}$');
final _subreddit = RegExp(r'^[A-Za-z0-9_]{2,32}$');

/// Posts (`/r/{sub}/comments/{id}/…`, `/comments/{id}`, `redd.it/{id}`) use
/// the post id; a comment permalink is `{postId}/{commentId}`. Share links
/// (`/r/{sub}/s/{code}`) need a redirect, so they carry no item id.
NormalizedLink _reddit(Uri uri, List<String> s) {
  final at = s.indexOf('comments');
  final prefixOk =
      at == 0 || (at == 2 && (s[0] == 'r' || s[0] == 'u' || s[0] == 'user'));
  if (prefixOk && s.length > at + 1) {
    final id = s[at + 1].toLowerCase();
    if (_base36.hasMatch(id)) {
      final rest = s.sublist(at + 2);
      final comment = rest.length >= 2 ? rest[1].toLowerCase() : null;
      final sub = at == 2 && s[0] == 'r' && _subreddit.hasMatch(s[1])
          ? s[1].toLowerCase()
          : null;
      final post = sub == null
          ? 'https://www.reddit.com/comments/$id/'
          : 'https://www.reddit.com/r/$sub/comments/$id/';
      if (comment != null && _base36.hasMatch(comment)) {
        return _item(
          CaptureSource.reddit,
          '$id/$comment',
          '${post}comment/$comment/',
          type: CaptureContentType.post,
        );
      }
      return _item(
        CaptureSource.reddit,
        id,
        post,
        type: CaptureContentType.post,
      );
    }
  }
  return _generic(uri, CaptureSource.reddit, canonicalHost: 'www.reddit.com');
}

NormalizedLink _reddIt(Uri uri, List<String> s) {
  if (s.length == 1 && _base36.hasMatch(s[0].toLowerCase())) {
    final id = s[0].toLowerCase();
    return _item(
      CaptureSource.reddit,
      id,
      'https://www.reddit.com/comments/$id/',
      type: CaptureContentType.post,
    );
  }
  return _generic(uri, CaptureSource.reddit, canonicalHost: 'www.reddit.com');
}

/// First path segments on github.com that are site pages, not owners.
const _githubReserved = {
  'about',
  'apps',
  'codespaces',
  'collections',
  'contact',
  'customer-stories',
  'dashboard',
  'enterprise',
  'events',
  'explore',
  'features',
  'issues',
  'join',
  'login',
  'marketplace',
  'new',
  'notifications',
  'orgs',
  'organizations',
  'pricing',
  'pulls',
  'search',
  'security',
  'settings',
  'site',
  'sponsors',
  'team',
  'topics',
  'trending',
  'users',
};
final _githubOwner = RegExp(r'^[a-z0-9](?:[a-z0-9-]{0,38})$');
final _githubRepo = RegExp(r'^[a-z0-9._-]{1,100}$');
final _hex = RegExp(r'^[0-9a-f]{6,64}$');

/// A repository is `{owner}/{repo}`; issues, pull requests and discussions
/// are `{owner}/{repo}/{kind}/{number}`. GitHub names are case-insensitive,
/// so ids and canonical URLs are lower case.
NormalizedLink _github(Uri uri, List<String> s) {
  if (s.length >= 2 && !_githubReserved.contains(s[0].toLowerCase())) {
    final owner = s[0].toLowerCase();
    var repo = s[1].toLowerCase();
    if (repo.endsWith('.git')) repo = repo.substring(0, repo.length - 4);
    if (_githubOwner.hasMatch(owner) && _githubRepo.hasMatch(repo)) {
      if (s.length == 2) {
        return _item(
          CaptureSource.github,
          '$owner/$repo',
          'https://github.com/$owner/$repo',
          type: CaptureContentType.other,
        );
      }
      const kinds = {
        'issues': 'issues',
        'pull': 'pull',
        'pulls': 'pull',
        'discussions': 'discussions',
      };
      final kind = kinds[s[2]];
      if (kind != null && s.length >= 4 && _digits.hasMatch(s[3])) {
        final id = '$owner/$repo/$kind/${s[3]}';
        return _item(
          CaptureSource.github,
          id,
          'https://github.com/$id',
          type: CaptureContentType.thread,
        );
      }
    }
  }
  return _generic(uri, CaptureSource.github, canonicalHost: 'github.com');
}

NormalizedLink _gist(Uri uri, List<String> s) {
  final hash = s.isEmpty ? null : s[s.length >= 2 ? 1 : 0].toLowerCase();
  if (hash != null && s.length <= 2 && _hex.hasMatch(hash)) {
    final path = s.length == 2 ? '${s[0].toLowerCase()}/$hash' : hash;
    return _item(
      CaptureSource.github,
      'gist/$hash',
      'https://gist.github.com/$path',
      type: CaptureContentType.other,
    );
  }
  return _generic(uri, CaptureSource.github, canonicalHost: 'gist.github.com');
}
