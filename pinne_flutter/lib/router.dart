import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/sign_in_screen.dart';
import 'features/collections/collections_screen.dart';
import 'features/planner/calendar_connections_screen.dart';
import 'features/planner/planner_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/onboarding/onboarding_store.dart';
import 'features/progress/progress_screen.dart';
import 'features/search/search_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/today/today_screen.dart';
import 'shell/app_shell.dart';
import 'ui/ribbon_spirit/ribbon_gallery.dart';

abstract final class Routes {
  static const today = '/today';
  static const planner = '/today/planner';
  static const calendarConnections = '/today/planner/calendars';
  static const collections = '/collections';
  static const search = '/search';
  static const progress = '/progress';
  static const settings = '/settings';
  static const signIn = '/sign-in';
  static const onboarding = '/onboarding';
  static const ribbonGallery = '/debug/ribbon-spirit';
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: Routes.onboarding,
    redirect: (context, state) =>
        onboardingRedirect(ref.read(onboardingStoreProvider), state),
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => OnboardingScreen(
          replay: state.uri.queryParameters['replay'] == '1',
        ),
      ),
      if (kDebugMode)
        GoRoute(
          path: Routes.ribbonGallery,
          builder: (context, state) => const RibbonGallery(),
        ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          _branch(
            Routes.today,
            const TodayScreen(),
            routes: [
              GoRoute(
                path: 'planner',
                builder: (context, state) => const PlannerScreen(),
                routes: [
                  GoRoute(
                    path: 'calendars',
                    builder: (context, state) =>
                        const CalendarConnectionsScreen(),
                  ),
                ],
              ),
            ],
          ),
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

String? onboardingRedirect(OnboardingStore store, GoRouterState state) {
  final isOnboarding = state.matchedLocation == Routes.onboarding;
  final replay = state.uri.queryParameters['replay'] == '1';
  if (!store.completed && !isOnboarding) return Routes.onboarding;
  if (store.completed && isOnboarding && !replay) return Routes.today;
  return null;
}

StatefulShellBranch _branch(
  String path,
  Widget screen, {
  List<RouteBase> routes = const [],
}) => StatefulShellBranch(
  routes: [
    GoRoute(path: path, builder: (context, state) => screen, routes: routes),
  ],
);
