import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/tour/coach_mark_overlay.dart';
import '../features/tour/tour_controller.dart';
import 'pill_nav_bar.dart';

const shellDestinations = [
  PillNavDestination(label: 'Today', icon: Icons.wb_sunny_outlined),
  PillNavDestination(label: 'Collections', icon: Icons.grid_view_rounded),
  PillNavDestination(label: 'Search', icon: Icons.search_rounded),
  PillNavDestination(label: 'Progress', icon: Icons.donut_large_rounded),
  PillNavDestination(label: 'Settings', icon: Icons.tune_rounded),
];

/// Hosts the five tab branches with the floating pill nav over them, and the
/// Today tour above everything when it is open.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tourStep = ref.watch(tourControllerProvider);
    final scaffold = Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: FloatingPillNav(
        child: TourAnchor(
          target: TourTarget.nav,
          child: PillNavBar(
            destinations: shellDestinations,
            selectedIndex: navigationShell.currentIndex,
            onSelected: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
          ),
        ),
      ),
    );
    if (tourStep == null) return scaffold;
    return Stack(
      children: [
        scaffold,
        Positioned.fill(
          child: CoachMarkOverlay(
            step: tourStep,
            destinations: shellDestinations,
          ),
        ),
      ],
    );
  }
}
