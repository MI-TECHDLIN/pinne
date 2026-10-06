import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/motion.dart';
import '../theme/pinne_tokens.dart';

class PillNavDestination {
  const PillNavDestination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

/// The floating pill navigation. The selected tab is violet and shows its
/// label, so the state never relies on colour alone.
class PillNavBar extends ConsumerWidget {
  const PillNavBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<PillNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = ref.motionDuration(PinneDurations.standard);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0716),
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
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < destinations.length; i++)
              _PillNavItem(
                destination: destinations[i],
                selected: i == selectedIndex,
                duration: duration,
                onTap: () => onSelected(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _PillNavItem extends StatelessWidget {
  const _PillNavItem({
    required this.destination,
    required this.selected,
    required this.duration,
    required this.onTap,
  });

  final PillNavDestination destination;
  final bool selected;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? PinneColors.text : PinneColors.muted;
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: InkWell(
        key: ValueKey('nav-${destination.label.toLowerCase()}'),
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: ExcludeSemantics(
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 12),
            decoration: BoxDecoration(
              color: selected ? PinneColors.violet : Colors.transparent,
              borderRadius: BorderRadius.circular(PinneRadii.chip),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(destination.icon, size: 20, color: foreground),
                if (selected) ...[
                  const SizedBox(width: 6),
                  Text(
                    destination.label,
                    style: TextStyle(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
