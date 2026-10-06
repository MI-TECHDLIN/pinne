import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme/pinne_theme.dart';

class PinneApp extends ConsumerWidget {
  const PinneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Pinne',
      debugShowCheckedModeBanner: false,
      theme: pinneDarkTheme(),
      darkTheme: pinneDarkTheme(),
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
