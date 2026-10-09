import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

typedef DnsResolver = Future<List<InternetAddress>> Function(String host);
typedef SocketConnector =
    Future<ConnectionTask<Socket>> Function(
      Uri uri,
      InternetAddress address,
      int port,
    );

class RestrictedFetchException implements Exception {
  const RestrictedFetchException(this.kind, this.message);

  final RestrictedFetchFailure kind;
  final String message;

  @override
  String toString() => 'RestrictedFetchException($kind, $message)';
}

enum RestrictedFetchFailure {
  invalidUrl,
  blockedAddress,
  timeout,
  tooLarge,
  unsupportedContent,
  network,
  tooManyRedirects,
}

class RestrictedResponse {
  const RestrictedResponse({
    required this.uri,
    required this.statusCode,
    required this.contentType,
    required this.body,
  });

  final Uri uri;
  final int statusCode;
  final String contentType;
  final String body;
}

/// HTTP client for untrusted saved URLs.
///
/// Each hop gets a fresh client and DNS resolution. The client connects to the
/// exact address that was checked, preventing a second resolution between the
/// SSRF check and the socket connection.
class RestrictedFetcher {
  RestrictedFetcher({
    DnsResolver? resolver,
    SocketConnector? connector,
    this.connectTimeout = const Duration(seconds: 2),
    this.totalTimeout = const Duration(seconds: 6),
    this.maxBytes = 1024 * 1024,
    this.maxRedirects = 3,
  }) : _resolver = resolver ?? InternetAddress.lookup,
       _connector = connector ?? _connect;

  final DnsResolver _resolver;
  final SocketConnector _connector;
  final Duration connectTimeout;
  final Duration totalTimeout;
  final int maxBytes;
  final int maxRedirects;

  static const userAgent =
      'PinneLinkPreview/1.0 (+https://github.com/MI-TECHDLIN/pinne)';
  static final Map<String, Future<void>> _hostGates = {};
  static final Map<String, DateTime> _hostLastStarted = {};
  static const _hostSpacing = Duration(milliseconds: 750);

  Future<RestrictedResponse> get(Uri uri) => _get(uri).timeout(
    totalTimeout,
    onTimeout: () {
      throw const RestrictedFetchException(
        RestrictedFetchFailure.timeout,
        'The preview request timed out.',
      );
    },
  );

  Future<void> validatePublicUri(Uri uri) async {
    _validateUri(uri);
    final addresses = await _resolver(uri.host).timeout(connectTimeout);
    if (addresses.isEmpty || addresses.any((address) => !isPublic(address))) {
      throw const RestrictedFetchException(
        RestrictedFetchFailure.blockedAddress,
        'The host resolves to a non-public address.',
      );
    }
  }

  Future<RestrictedResponse> _get(Uri first) async {
    var current = first;
    for (var redirectCount = 0; ; redirectCount++) {
      _validateUri(current);
      await _waitForHost(current.host.toLowerCase());
      final addresses = await _resolver(current.host).timeout(
        connectTimeout,
        onTimeout: () => throw const RestrictedFetchException(
          RestrictedFetchFailure.timeout,
          'DNS lookup timed out.',
        ),
      );
      if (addresses.isEmpty || addresses.any((value) => !isPublic(value))) {
        throw const RestrictedFetchException(
          RestrictedFetchFailure.blockedAddress,
          'The host resolves to a non-public address.',
        );
      }

      final client = HttpClient()
        ..autoUncompress = false
        ..connectionTimeout = connectTimeout
        ..maxConnectionsPerHost = 1
        ..connectionFactory = (uri, proxyHost, proxyPort) {
          if (proxyHost != null || proxyPort != null) {
            throw const RestrictedFetchException(
              RestrictedFetchFailure.network,
              'Proxies are disabled.',
            );
          }
          return _connector(
            uri,
            addresses.first,
            uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80),
          );
        }
        ..findProxy = (_) => 'DIRECT';
      try {
        final request = await client.getUrl(current);
        request
          ..followRedirects = false
          ..headers.set(HttpHeaders.userAgentHeader, userAgent)
          ..headers.set(HttpHeaders.acceptHeader, 'text/html, application/json')
          ..headers.set(HttpHeaders.acceptEncodingHeader, 'gzip, deflate');
        final response = await request.close();
        if (_isRedirect(response.statusCode)) {
          await response.drain<void>();
          if (redirectCount >= maxRedirects) {
            throw const RestrictedFetchException(
              RestrictedFetchFailure.tooManyRedirects,
              'Too many redirects.',
            );
          }
          final location = response.headers.value(HttpHeaders.locationHeader);
          if (location == null) {
            throw const RestrictedFetchException(
              RestrictedFetchFailure.invalidUrl,
              'Redirect had no location.',
            );
          }
          current = current.resolve(location);
          continue;
        }

        final mediaType = response.headers.contentType?.mimeType.toLowerCase();
        if (mediaType != 'text/html' &&
            mediaType != 'application/json' &&
            mediaType != 'application/ld+json') {
          await response.drain<void>();
          if (response.statusCode < 200 || response.statusCode >= 300) {
            return RestrictedResponse(
              uri: current,
              statusCode: response.statusCode,
              contentType: mediaType ?? 'unsupported',
              body: '',
            );
          }
          throw RestrictedFetchException(
            RestrictedFetchFailure.unsupportedContent,
            'Unsupported content type: ${mediaType ?? 'missing'}.',
          );
        }
        final bytes = await _decode(response);
        final charset = response.headers.contentType?.charset?.toLowerCase();
        final body = charset == 'latin1' || charset == 'iso-8859-1'
            ? latin1.decode(bytes, allowInvalid: true)
            : utf8.decode(bytes, allowMalformed: true);
        return RestrictedResponse(
          uri: current,
          statusCode: response.statusCode,
          contentType: mediaType!,
          body: body,
        );
      } on RestrictedFetchException {
        rethrow;
      } on TimeoutException {
        throw const RestrictedFetchException(
          RestrictedFetchFailure.timeout,
          'The preview request timed out.',
        );
      } on Object catch (error) {
        throw RestrictedFetchException(
          RestrictedFetchFailure.network,
          'Network request failed: $error',
        );
      } finally {
        client.close(force: true);
      }
    }
  }

  Future<Uint8List> _decode(HttpClientResponse response) async {
    Stream<List<int>> stream = response.transform(_ByteLimit(maxBytes));
    final encoding = response.headers
        .value(HttpHeaders.contentEncodingHeader)
        ?.trim()
        .toLowerCase();
    if (encoding == 'gzip') {
      stream = stream.transform(gzip.decoder);
    } else if (encoding == 'deflate') {
      stream = stream.transform(zlib.decoder);
    } else if (encoding != null &&
        encoding.isNotEmpty &&
        encoding != 'identity') {
      throw RestrictedFetchException(
        RestrictedFetchFailure.unsupportedContent,
        'Unsupported content encoding: $encoding.',
      );
    }
    final builder = BytesBuilder(copy: false);
    var length = 0;
    await for (final chunk in stream) {
      length += chunk.length;
      if (length > maxBytes) {
        throw const RestrictedFetchException(
          RestrictedFetchFailure.tooLarge,
          'The decompressed response is too large.',
        );
      }
      builder.add(chunk);
    }
    return builder.takeBytes();
  }

  static bool _isRedirect(int status) =>
      status == 301 ||
      status == 302 ||
      status == 303 ||
      status == 307 ||
      status == 308;

  static Future<void> _waitForHost(String host) {
    final previous = _hostGates[host] ?? Future.value();
    final next = previous.catchError((_) {}).then((_) async {
      final now = DateTime.now().toUtc();
      final last = _hostLastStarted[host];
      final wait = last == null
          ? Duration.zero
          : _hostSpacing - now.difference(last);
      if (wait > Duration.zero) await Future<void>.delayed(wait);
      _hostLastStarted[host] = DateTime.now().toUtc();
    });
    _hostGates[host] = next;
    return next;
  }

  static void _validateUri(Uri uri) {
    if ((uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      throw const RestrictedFetchException(
        RestrictedFetchFailure.invalidUrl,
        'Only credential-free HTTP and HTTPS URLs are supported.',
      );
    }
  }

  static bool isPublic(InternetAddress address) {
    final bytes = address.rawAddress;
    if (address.type == InternetAddressType.IPv4) {
      return _isPublicV4(bytes);
    }
    if (address.type != InternetAddressType.IPv6 || bytes.length != 16) {
      return false;
    }
    // IPv4-compatible and IPv4-mapped IPv6.
    if (bytes.take(12).every((value) => value == 0) ||
        bytes.take(10).every((value) => value == 0) &&
            bytes[10] == 0xff &&
            bytes[11] == 0xff) {
      return _isPublicV4(bytes.sublist(12));
    }
    if (bytes.every((value) => value == 0) ||
        bytes.sublist(0, 15).every((value) => value == 0) && bytes[15] == 1) {
      return false; // unspecified and loopback
    }
    if ((bytes[0] & 0xfe) == 0xfc || // unique-local fc00::/7
        bytes[0] == 0xfe && (bytes[1] & 0xc0) == 0x80 || // link-local
        bytes[0] == 0xfe && (bytes[1] & 0xc0) == 0xc0 || // site-local
        bytes[0] == 0xff || // multicast
        bytes[0] == 0x00 &&
            bytes[1] == 0x64 &&
            bytes[2] == 0xff &&
            bytes[3] == 0x9b || // NAT64
        bytes[0] == 0x20 && bytes[1] == 0x02 || // 6to4 embeds IPv4
        bytes[0] == 0x20 &&
            bytes[1] == 0x01 &&
            bytes[2] == 0x00 &&
            bytes[3] == 0x00 || // Teredo
        bytes[0] == 0x20 &&
            bytes[1] == 0x01 &&
            bytes[2] == 0x0d &&
            bytes[3] == 0xb8) {
      return false; // documentation range
    }
    return true;
  }

  static bool _isPublicV4(List<int> b) {
    if (b.length != 4) return false;
    final a = b[0];
    final second = b[1];
    return a != 0 &&
        a != 10 &&
        a != 127 &&
        !(a == 100 && second >= 64 && second <= 127) && // CGNAT
        !(a == 169 && second == 254) &&
        !(a == 172 && second >= 16 && second <= 31) &&
        !(a == 192 && second == 168) &&
        a < 224; // multicast and reserved ranges
  }

  static Future<ConnectionTask<Socket>> _connect(
    Uri uri,
    InternetAddress address,
    int port,
  ) async {
    final task = await Socket.startConnect(address, port);
    if (uri.scheme == 'http') return task;
    final secure = task.socket.then(
      (socket) => SecureSocket.secure(socket, host: uri.host),
    );
    return ConnectionTask.fromSocket(secure, task.cancel);
  }
}

class _ByteLimit extends StreamTransformerBase<List<int>, List<int>> {
  const _ByteLimit(this.limit);

  final int limit;

  @override
  Stream<List<int>> bind(Stream<List<int>> stream) async* {
    var seen = 0;
    await for (final chunk in stream) {
      seen += chunk.length;
      if (seen > limit) {
        throw const RestrictedFetchException(
          RestrictedFetchFailure.tooLarge,
          'The compressed response is too large.',
        );
      }
      yield chunk;
    }
  }
}
