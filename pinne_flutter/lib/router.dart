import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/sign_in_screen.dart';
import 'features/collections/collections_screen.dart';
import 'features/progress/progress_screen.dart';
import 'features/search/search_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/today/today_screen.dart';
import 'shell/app_shell.dart';

abstract final class Routes {
  static const today = '/today';
  static const collections = '/collections';
  static const search = '/search';
  static const progress = '/progress';
  static const settings = '/settings';
  static const signIn = '/sign-in';
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: Routes.today,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          _branch(Routes.today, const TodayScreen()),
          _branch(Routes.collections, const CollectionsScreen()),
          _branch(Routes.search, const SearchScreen()),
          _branch(Routes.progress, const ProgressScreen()),
          _branch(Routes.settings, const SettingsScreen()),
        ],
      ),
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

StatefulShellBranch _branch(String path, Widget screen) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: (context, state) => screen)],
);
