import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'src/ai/ai_provider_registry.dart';
import 'src/auth/demo_account_seeder.dart';
import 'src/auth/email_delivery.dart';
import 'src/generated/serverpod.dart';

/// The starting point of the Serverpod server.
Future<void> run(List<String> args, {bool seedDemo = false}) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);
  pod.loadCustomPasswords([
    (envName: 'PINNE_SMTP_HOST', alias: 'smtpHost'),
    (envName: 'PINNE_SMTP_PORT', alias: 'smtpPort'),
    (envName: 'PINNE_SMTP_USERNAME', alias: 'smtpUsername'),
    (envName: 'PINNE_SMTP_PASSWORD', alias: 'smtpPassword'),
    (envName: 'PINNE_SMTP_FROM_EMAIL', alias: 'smtpFromEmail'),
    (envName: 'PINNE_SMTP_FROM_NAME', alias: 'smtpFromName'),
    (envName: 'PINNE_SMTP_SSL', alias: 'smtpSsl'),
    (envName: 'PINNE_DEMO_ACCOUNT_EMAIL', alias: 'demoAccountEmail'),
    (envName: 'PINNE_DEMO_ACCOUNT_PASSWORD', alias: 'demoAccountPassword'),
  ]);

  final groqApiKey = _configuredPassword(pod, 'groqApiKey');
  final geminiApiKey = _configuredPassword(pod, 'geminiApiKey');
  final aiEnabled =
      Platform.environment['PINNE_AI_ENABLED']?.toLowerCase() != 'false';
  AiProviderRegistry.configure(
    groqApiKey: groqApiKey,
    geminiApiKey: geminiApiKey,
    enabled: aiEnabled,
  );
  stdout.writeln(
    'AI organizing provider: ${AiProviderRegistry.activeProviderName}.',
  );
  // Starter plans run without future calls: AI then runs inline on capture,
  // and link previews and the review digest are off.
  stdout.writeln(
    'Future calls: '
    '${pod.config.futureCall.enabled ? 'enabled' : 'disabled'}.',
  );

  // Google sign-in needs real OAuth credentials. Until `googleClientSecret` is
  // set in config/passwords.yaml the provider stays off and email sign-in
  // still works. See config/passwords.yaml.example.
  final googleConfigured = pod.getPassword('googleClientSecret') != null;
  if (!googleConfigured) {
    stdout.writeln('googleClientSecret not set; Google sign-in is disabled.');
  }

  // Token managers validate and issue authentication keys; identity providers
  // are the sign-in options available to users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      AnonymousIdpConfig(),
      EmailDelivery.configure(pod),
      if (googleConfigured) GoogleIdpConfigFromPasswords(),
    ],
  );

  // Configure cloud storage.
  // This setup works with Serverpod Cloud without extra configuration.
  // If you want to use a custom provider for cloud storage, replace these
  // with your preferred provider.
  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  // Serve the release web build when the pre-deploy hook has produced one.
  // Serverpod Cloud supplies the public web/API hosts at runtime; local runs
  // keep using the ports in config/development.yaml.
  final flutterAppDirectory = Directory('web/app');
  if (flutterAppDirectory.existsSync()) {
    pod.webServer.addRoute(
      FlutterRoute(flutterAppDirectory, enableWasmHeaders: false),
    );
  }

  // Start the server.
  await pod.start();

  final seedDemoOnStart =
      Platform.environment['PINNE_SEED_DEMO_ON_START']?.toLowerCase() == 'true';
  if (seedDemo || seedDemoOnStart) {
    final email = _configuredPassword(pod, 'demoAccountEmail');
    final password = _configuredPassword(pod, 'demoAccountPassword');
    if (email == null || password == null) {
      await pod.shutdown();
      throw StateError(
        'demoAccountEmail and demoAccountPassword must be configured.',
      );
    }
    final result = await pod.withSession(
      (session) => const DemoAccountSeeder().seed(
        session,
        email: email,
        password: password,
      ),
    );
    stdout.writeln(
      result.created
          ? 'Created empty demo account for $email.'
          : 'Demo account for $email already exists; nothing changed.',
    );
    if (seedDemo) {
      await pod.shutdown();
      return;
    }
  }

  // Keep exactly one durable hourly digest scan across development restarts.
  // The scan only records a deduplicated in-app digest; delivery adapters are
  // deliberately outside this feature.
  if (pod.config.futureCall.enabled) {
    const digestScheduleId = 'pinne-review-digest-hourly';
    await pod.futureCalls.cancel(digestScheduleId);
    await pod.futureCalls
        .callRecurring(identifier: digestScheduleId)
        .every(const Duration(hours: 1))
        .reminderDigest
        .recompute();
  }
}

String? _configuredPassword(Serverpod pod, String key) {
  final value = pod.getPassword(key)?.trim();
  if (value == null ||
      value.isEmpty ||
      (value.startsWith('<') && value.endsWith('>'))) {
    return null;
  }
  return value;
}
