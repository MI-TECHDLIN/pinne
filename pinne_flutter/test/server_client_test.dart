import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/core/server_client.dart';

void main() {
  group('serverpodCloudApiUrl', () {
    test('derives the API URL from the default Cloud web host', () {
      expect(
        serverpodCloudApiUrl(Uri.parse('https://my-pinne.serverpod.space/')),
        'https://my-pinne.api.serverpod.space/',
      );
    });

    test('does not guess for custom or non-web Cloud hosts', () {
      expect(serverpodCloudApiUrl(Uri.parse('https://pinne.example/')), isNull);
      expect(
        serverpodCloudApiUrl(
          Uri.parse('https://my-pinne.api.serverpod.space/'),
        ),
        isNull,
      );
    });
  });

  group('releaseServerUrl', () {
    test('release phone builds use the hosted API, never localhost', () {
      expect(
        releaseServerUrl(isRelease: true, isWeb: false),
        'https://pinneapp.api.serverpod.space/',
      );
    });

    test('debug and web builds keep config.json and host detection', () {
      expect(releaseServerUrl(isRelease: false, isWeb: false), isNull);
      expect(releaseServerUrl(isRelease: true, isWeb: true), isNull);
    });
  });
}
