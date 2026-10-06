import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme/pinne_theme.dart';
import 'ui/motion.dart';

class PinneApp extends ConsumerWidget {
  const PinneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(platformReduceMotionProvider);
    final motionPreference = ref.watch(motionPreferenceProvider);
    return MaterialApp.router(
      title: 'Pinne',
      debugShowCheckedModeBanner: false,
      theme: pinneDarkTheme(),
      darkTheme: pinneDarkTheme(),
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => MotionPreferenceScope(
        preference: motionPreference,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
