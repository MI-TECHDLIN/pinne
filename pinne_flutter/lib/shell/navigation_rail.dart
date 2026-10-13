import 'package:flutter/material.dart';

import '../theme/pinne_tokens.dart';
import 'pill_nav_bar.dart';

/// Wide-screen navigation using the same destinations as the phone pill.
class PinneNavigationRail extends StatelessWidget {
  const PinneNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<PillNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const ValueKey('pinne-navigation-rail'),
      color: const Color(0xE60A0716),
      child: SafeArea(
        right: false,
        child: SizedBox(
          width: 196,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 28, 14, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: PinneColors.violet,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bookmark_rounded,
                          color: PinneColors.text,
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: PinneSpacing.sm),
                      Text(
                        'Pinne',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: PinneSpacing.xxl),
                for (final (index, destination) in destinations.indexed) ...[
                  _RailDestination(
                    destination: destination,
                    selected: index == selectedIndex,
                    onTap: () => onSelected(index),
                  ),
                  const SizedBox(height: PinneSpacing.xs),
                ],
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Save it. Come back to it.',
                    style: TextStyle(
                      color: PinneColors.muted,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RailDestination extends StatelessWidget {
  const _RailDestination({
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
      child: Material(
        color: selected ? PinneColors.violet : Colors.transparent,
        borderRadius: BorderRadius.circular(PinneRadii.tile),
        child: InkWell(
          key: ValueKey('nav-${destination.label.toLowerCase()}'),
          mouseCursor: SystemMouseCursors.click,
          borderRadius: BorderRadius.circular(PinneRadii.tile),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  destination.icon,
                  size: 21,
                  color: selected ? PinneColors.text : PinneColors.muted,
                ),
                const SizedBox(width: PinneSpacing.md),
                Expanded(
                  child: Text(
                    destination.label,
                    style: TextStyle(
                      color: selected ? PinneColors.text : PinneColors.muted,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
