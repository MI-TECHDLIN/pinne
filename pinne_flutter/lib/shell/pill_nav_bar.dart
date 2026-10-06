import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/pinne_tokens.dart';
import '../ui/motion.dart';

class PillNavDestination {
  const PillNavDestination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

/// The floating five-tab navigation with the app's one real backdrop blur.
class PillNavBar extends StatelessWidget {
  const PillNavBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<PillNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _itemExtent = 54.0;
  static const _indicatorExtent = 44.0;

  @override
  Widget build(BuildContext context) {
    final reduced = reduceMotionOf(context);
    final indicatorTravel =
        (_itemExtent * destinations.length) - _indicatorExtent;
    final indicatorOffset =
        (selectedIndex * _itemExtent) + ((_itemExtent - _indicatorExtent) / 2);
    final alignmentX = indicatorTravel == 0
        ? 0.0
        : -1 + (2 * indicatorOffset / indicatorTravel);

    return ClipRRect(
      borderRadius: BorderRadius.circular(PinneRadii.chip),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xD90A0716),
            borderRadius: BorderRadius.circular(PinneRadii.chip),
            border: Border.all(color: PinneColors.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0xAA000000),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SizedBox(
            height: _indicatorExtent,
            width: _itemExtent * destinations.length,
            child: Stack(
              children: [
                AnimatedAlign(
                  alignment: Alignment(alignmentX, 0),
                  duration: reduced
                      ? Duration.zero
                      : PinneMotionDurations.standard,
                  curve: PinneMotionCurves.spring,
                  child: const DecoratedBox(
                    key: ValueKey('pill-nav-selected-indicator'),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(dimension: _indicatorExtent),
                  ),
                ),
                Row(
                  children: [
                    for (var i = 0; i < destinations.length; i++)
                      SizedBox(
                        width: _itemExtent,
                        child: _PillNavItem(
                          destination: destinations[i],
                          selected: i == selectedIndex,
                          onTap: () => onSelected(i),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PillNavItem extends StatelessWidget {
  const _PillNavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final PillNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: Tooltip(
        message: destination.label,
        child: InkResponse(
          key: ValueKey('nav-${destination.label.toLowerCase()}'),
          onTap: onTap,
          radius: 24,
          customBorder: const CircleBorder(),
          child: ExcludeSemantics(
            child: AnimatedSwitcher(
              duration: motionDurationOf(
                context,
                PinneMotionDurations.quick,
              ),
              child: Icon(
                destination.icon,
                key: ValueKey(selected),
                size: 21,
                color: selected ? PinneColors.ink : PinneColors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
