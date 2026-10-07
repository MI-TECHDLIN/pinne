import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'src/ai/ai_provider_registry.dart';
import 'src/generated/serverpod.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);

  final geminiApiKey = pod.getPassword('geminiApiKey');
  final aiEnabled =
      Platform.environment['PINNE_AI_ENABLED']?.toLowerCase() != 'false';
  AiProviderRegistry.configure(
    geminiApiKey: geminiApiKey,
    enabled: aiEnabled,
  );
  if (geminiApiKey == null || !aiEnabled) {
    stdout.writeln(
      'Gemini AI is disabled; deterministic organizing is active.',
    );
  }

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
      // Email/password. In development the verification codes are logged to
      // the console; in staging and production they are sent through the
      // Serverpod Cloud email service. Use `EmailIdpConfigFromPasswords` for a
      // custom email provider.
      ServerpodCloudEmailIdpConfig(appDisplayName: 'Pinne'),
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

  // Start the server.
  await pod.start();

  // Keep exactly one durable hourly digest scan across development restarts.
  // The scan only records a deduplicated in-app digest; delivery adapters are
  // deliberately outside this feature.
  const digestScheduleId = 'pinne-review-digest-hourly';
  await pod.futureCalls.cancel(digestScheduleId);
  await pod.futureCalls
      .callRecurring(identifier: digestScheduleId)
      .every(const Duration(hours: 1))
      .reminderDigest
      .recompute();
}
