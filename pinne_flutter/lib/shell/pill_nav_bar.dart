import 'dart:math' as math;
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

  /// The pill's height: the border sits outside the content inset.
  static const height = _indicatorExtent + (_inset * 2) + 2;

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
                height: height,
                padding: const EdgeInsets.all(_inset),
                decoration: BoxDecoration(
                  color: context.pinne.navFill,
                  borderRadius: BorderRadius.circular(PinneRadii.chip),
                  border: Border.all(color: context.pinne.line),
                  boxShadow: [
                    BoxShadow(
                      color: context.pinne.shadow,
                      blurRadius:
                          Theme.of(context).brightness == Brightness.light
                          ? 18
                          : 30,
                      offset: Theme.of(context).brightness == Brightness.light
                          ? const Offset(0, 6)
                          : const Offset(0, 10),
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
                      child: DecoratedBox(
                        key: const ValueKey('pill-nav-selected-indicator'),
                        decoration: BoxDecoration(
                          color: context.pinne.navSelected,
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
    final light = Theme.of(context).brightness == Brightness.light;
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
              duration: motionDurationOf(context, PinneMotionDurations.quick),
              child: Icon(
                destination.icon,
                key: ValueKey(
                  'pill-nav-icon-${destination.label.toLowerCase()}',
                ),
                size: 21,
                color: selected
                    ? light
                          ? context.pinne.onViolet
                          : context.pinne.ink
                    : context.pinne.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Places the pill nav as the shell shows it: centred and floating above the
/// phone's bottom inset, or [bottomGap] above the edge without one.
class FloatingPillNav extends StatelessWidget {
  const FloatingPillNav({super.key, required this.child});

  final Widget child;

  static const bottomGap = 14.0;

  /// How far up from the bottom of the screen the nav reaches, for anything
  /// that has to sit above it, such as the Save sheet.
  static double extentOf(MediaQueryData media) =>
      math.max(media.padding.bottom, bottomGap) + PillNavBar.height;

  @override
  Widget build(BuildContext context) => SafeArea(
    minimum: const EdgeInsets.only(bottom: bottomGap),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: SizedBox(width: PillNavBar.maxWidth, child: child),
      ),
    ),
  );
}
