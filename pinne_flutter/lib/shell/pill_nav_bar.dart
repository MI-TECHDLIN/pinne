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

  static const maxWidth = 300.0;
  static const _indicatorExtent = 44.0;
  static const _inset = 5.0;

  @override
  Widget build(BuildContext context) {
    final reduced = reduceMotionOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : maxWidth;
        final width = available.clamp(0.0, maxWidth);
        final innerWidth = width - (_inset * 2) - 2;
        final slotWidth = innerWidth / destinations.length;
        final indicatorLeft =
            (slotWidth * selectedIndex) + ((slotWidth - _indicatorExtent) / 2);
        return SizedBox(
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(PinneRadii.chip),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(
                key: const ValueKey('pill-nav-pill'),
                // The border is outside the five-pixel content inset, so the
                // 44px indicator has six visual pixels above and below it.
                height: _indicatorExtent + (_inset * 2) + 2,
                padding: const EdgeInsets.all(_inset),
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedPositioned(
                      left: indicatorLeft,
                      top: 0,
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
                          Expanded(
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
      },
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
                key: ValueKey(
                  'pill-nav-icon-${destination.label.toLowerCase()}',
                ),
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
