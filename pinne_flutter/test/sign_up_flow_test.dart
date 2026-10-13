import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/auth/sign_in_screen.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'support/golden_theme.dart';

/// Drives "Create account" against recorded answers from the real endpoint.
Future<List<String>> _startSignUp(
  WidgetTester tester,
  http.Response Function(Map<String, dynamic> call) answer,
) async {
  await tester.binding.setSurfaceSize(const Size(500, 1100));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final calls = <String>[];
  final client = Client(
    'http://localhost:8080/',
    httpClientOverride: MockClient((request) async {
      final call = jsonDecode(request.body) as Map<String, dynamic>;
      calls.add(request.url.path);
      return answer(call);
    }),
  )..authSessionManager = FlutterAuthSessionManager();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        clientProvider.overrideWithValue(client),
        emailDeliveryAvailableProvider.overrideWith((ref) async => true),
      ],
      child: MaterialApp(
        theme: pinneDarkTheme(),
        home: const SignInScreen(createAccount: true),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).first, 'reader@example.com');
  await tester.pump(const Duration(milliseconds: 600));
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
  return calls;
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('sign-up moves on to the code step once the email is sent', (
    tester,
  ) async {
    final calls = await _startSignUp(
      tester,
      (_) => http.Response(
        jsonEncode('0199e0f6-6d39-7c1a-9d43-7c6b2a8f1e10'),
        200,
      ),
    );

    expect(calls, ['/emailIdp/startRegistration']);
    expect(find.text('Verify account'), findsOneWidget);
    expect(
      find.textContaining('verification email has been sent'),
      findsOneWidget,
    );
  });

  testWidgets('a code email that could not be sent is explained', (
    tester,
  ) async {
    // The answer production gives when no email route works.
    await _startSignUp(
      tester,
      (_) => http.Response(
        jsonEncode({
          'className': 'serverpod_auth_idp.EmailAccountRequestException',
          'data': {
            '__className__': 'serverpod_auth_idp.EmailAccountRequestException',
            'reason': 'unknown',
          },
        }),
        400,
      ),
    );

    expect(find.textContaining('We could not send your code'), findsOneWidget);
    expect(find.textContaining('guest'), findsWidgets);
    expect(find.text('Verify account'), findsNothing);
  });
}
