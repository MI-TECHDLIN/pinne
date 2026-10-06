import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the health endpoint', (sessionBuilder, endpoints) {
    test(
      'when called without signing in then reports a live database',
      () async {
        final health = await endpoints.health.check(
          sessionBuilder.copyWith(
            authentication: AuthenticationOverride.unauthenticated(),
          ),
        );
        expect(health.ok, isTrue);
        expect(health.databaseOk, isTrue);
        expect(health.version, isNotEmpty);
      },
    );
  });
}
