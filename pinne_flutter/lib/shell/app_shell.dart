import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pill_nav_bar.dart';

const shellDestinations = [
  PillNavDestination(label: 'Today', icon: Icons.wb_sunny_outlined),
  PillNavDestination(label: 'Collections', icon: Icons.grid_view_rounded),
  PillNavDestination(label: 'Search', icon: Icons.search_rounded),
  PillNavDestination(label: 'Progress', icon: Icons.donut_large_rounded),
  PillNavDestination(label: 'Settings', icon: Icons.tune_rounded),
];

/// Hosts the five tab branches with the floating pill nav over them.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 14),
        child: Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 1,
          child: FittedBox(
            fit: BoxFit.scaleDown,
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
      ),
    );
  }
}
