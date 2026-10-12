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
}
