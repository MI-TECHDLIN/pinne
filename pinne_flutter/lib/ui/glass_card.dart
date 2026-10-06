import 'package:flutter/material.dart';

import '../theme/pinne_tokens.dart';

/// Pinne's inexpensive glass treatment: translucent paint and a hairline.
///
/// Deliberately does not blur. The floating navigation owns the app's single
/// real [BackdropFilter].
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = PinneRadii.card,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(PinneSpacing.lg),
      decoration: BoxDecoration(
        color: PinneColors.glass,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: PinneColors.line, width: 1),
      ),
      child: child,
    );
  }
}
