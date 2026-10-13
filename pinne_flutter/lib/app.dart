import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/capture/capture_providers.dart';
import 'router.dart';
import 'theme/pinne_theme.dart';
import 'theme/theme_mode.dart';
import 'ui/motion.dart';

class PinneApp extends ConsumerWidget {
  const PinneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(platformReduceMotionProvider);
    // Keeps the capture outbox syncing for as long as the app runs.
    ref.watch(outboxSyncProvider);
    final motionPreference = ref.watch(motionPreferenceProvider);
    final themePreference = ref.watch(themePreferenceProvider);
    return MaterialApp.router(
      title: 'Pinne',
      debugShowCheckedModeBanner: false,
      theme: pinneLightTheme(),
      darkTheme: pinneDarkTheme(),
      themeMode: themePreference.themeMode,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => MotionPreferenceScope(
        preference: motionPreference,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
