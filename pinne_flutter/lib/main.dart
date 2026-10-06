import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/server_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final serverUrl = await resolveServerUrl();
  final client = await createServerClient(serverUrl);
  runApp(
    ProviderScope(
      overrides: [
        serverUrlProvider.overrideWithValue(serverUrl),
        clientProvider.overrideWithValue(client),
      ],
      child: const PinneApp(),
    ),
  );
}
