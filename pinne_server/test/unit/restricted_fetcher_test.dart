import 'dart:io';

import 'package:pinne_server/src/link_previews/restricted_fetcher.dart';
import 'package:test/test.dart';

void main() {
  group('address policy', () {
    final blocked = <String>[
      '0.0.0.0',
      '10.1.2.3',
      '100.64.0.1',
      '127.0.0.1',
      '169.254.169.254',
      '172.16.0.1',
      '192.168.1.1',
      '224.0.0.1',
      '240.0.0.1',
      '::',
      '::1',
      '::127.0.0.1',
      '::ffff:127.0.0.1',
      '64:ff9b::7f00:1',
      '2002:7f00:1::',
      '2001:0000:4136:e378:8000:63bf:3fff:fdd2',
      'fc00::1',
      'fd00::1',
      'fe80::1',
      'fec0::1',
      'ff02::1',
      '2001:db8::1',
    ];
    for (final address in blocked) {
      test('blocks $address', () {
        expect(RestrictedFetcher.isPublic(InternetAddress(address)), isFalse);
      });
    }

    test('allows globally routable addresses', () {
      expect(
        RestrictedFetcher.isPublic(InternetAddress('93.184.216.34')),
        isTrue,
      );
      expect(
        RestrictedFetcher.isPublic(InternetAddress('2606:4700:4700::1111')),
        isTrue,
      );
    });
  });

  group('redirect checks with a local fake server', () {
    late HttpServer server;
    late RestrictedFetcher fetcher;

    setUp(() async {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        if (request.uri.path == '/redirect-metadata') {
          request.response
            ..statusCode = 302
            ..headers.set('location', 'http://metadata.test/latest/meta-data');
        } else if (request.uri.path == '/redirect-loopback') {
          request.response
            ..statusCode = 302
            ..headers.set('location', 'http://loopback.test/private');
        } else if (request.uri.path == '/large') {
          request.response
            ..statusCode = 200
            ..headers.contentType = ContentType.html
            ..write(List.filled(100, 'x').join());
        } else if (request.uri.path == '/gzip-bomb') {
          request.response
            ..statusCode = 200
            ..headers.contentType = ContentType.html
            ..headers.set(HttpHeaders.contentEncodingHeader, 'gzip')
            ..add(gzip.encode(List.filled(1000, 120)));
        } else {
          request.response
            ..statusCode = 200
            ..headers.contentType = ContentType.html
            ..write('<title>Public fixture</title>');
        }
        await request.response.close();
      });
      fetcher = RestrictedFetcher(
        resolver: (host) async => [
          InternetAddress(
            host == 'metadata.test'
                ? '169.254.169.254'
                : host == 'loopback.test'
                ? '127.0.0.1'
                : '93.184.216.34',
          ),
        ],
        connector: (uri, address, port) =>
            Socket.startConnect(InternetAddress.loopbackIPv4, server.port),
      );
    });

    tearDown(() => server.close(force: true));

    test('allows the public test hop', () async {
      final response = await fetcher.get(Uri.parse('http://public.test/ok'));
      expect(response.body, contains('Public fixture'));
    });

    for (final path in ['redirect-metadata', 'redirect-loopback']) {
      test('blocks $path before a second connection', () async {
        await expectLater(
          fetcher.get(Uri.parse('http://public.test/$path')),
          throwsA(
            isA<RestrictedFetchException>().having(
              (error) => error.kind,
              'kind',
              RestrictedFetchFailure.blockedAddress,
            ),
          ),
        );
      });
    }

    for (final path in ['large', 'gzip-bomb']) {
      test('caps $path responses after encoding limits', () async {
        final tiny = RestrictedFetcher(
          maxBytes: 64,
          resolver: (host) async => [InternetAddress('93.184.216.34')],
          connector: (uri, address, port) =>
              Socket.startConnect(InternetAddress.loopbackIPv4, server.port),
        );
        await expectLater(
          tiny.get(Uri.parse('http://size-$path.test/$path')),
          throwsA(
            isA<RestrictedFetchException>().having(
              (error) => error.kind,
              'kind',
              RestrictedFetchFailure.tooLarge,
            ),
          ),
        );
      });
    }
  });
}
