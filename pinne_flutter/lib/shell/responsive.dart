import 'package:flutter/widgets.dart';

/// Pinne's three shared layout classes.
enum PinneWindowClass { compact, medium, expanded }

abstract final class PinneBreakpoints {
  static const compact = 600.0;
  static const expanded = 1024.0;

  static PinneWindowClass fromWidth(double width) {
    if (width < compact) return PinneWindowClass.compact;
    if (width <= expanded) return PinneWindowClass.medium;
    return PinneWindowClass.expanded;
  }

  static PinneWindowClass of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);
}

extension PinneWindowClassX on PinneWindowClass {
  bool get isCompact => this == PinneWindowClass.compact;
  bool get isMedium => this == PinneWindowClass.medium;
  bool get isExpanded => this == PinneWindowClass.expanded;

  double get pageGutter => switch (this) {
    PinneWindowClass.compact => 16,
    PinneWindowClass.medium => 28,
    PinneWindowClass.expanded => 40,
  };

  double get defaultMaxWidth => switch (this) {
    PinneWindowClass.compact => double.infinity,
    PinneWindowClass.medium => 720,
    PinneWindowClass.expanded => 1100,
  };
}
