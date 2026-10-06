import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The user's motion choice in Settings.
enum MotionPreference {
  /// Follow the operating system's reduce-motion setting.
  system,

  /// Always reduce motion.
  reduced,

  /// Always allow full motion.
  full,
}

/// Shared motion durations. Reduced transitions always use [reducedFade].
abstract final class PinneMotionDurations {
  static const reducedFade = Duration(milliseconds: 120);
  static const quick = Duration(milliseconds: 160);
  static const standard = Duration(milliseconds: 280);
  static const slow = Duration(milliseconds: 520);
  static const float = Duration(milliseconds: 3200);
  static const stagger = Duration(milliseconds: 70);
}

/// Shared motion curves.
abstract final class PinneMotionCurves {
  static const enter = Curves.easeOutCubic;
  static const exit = Curves.easeInCubic;
  static const spring = Curves.easeOutBack;
  static const float = Curves.easeInOut;
}

/// Makes the in-app preference available to context-only animation helpers.
class MotionPreferenceScope extends InheritedWidget {
  const MotionPreferenceScope({
    super.key,
    required this.preference,
    required super.child,
  });

  final MotionPreference preference;

  static MotionPreference maybeOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<MotionPreferenceScope>()
          ?.preference ??
      MotionPreference.system;

  @override
  bool updateShouldNotify(MotionPreferenceScope oldWidget) =>
      preference != oldWidget.preference;
}

/// Whether motion should be reduced for this part of the widget tree.
///
/// Android's Remove animations setting is exposed through [MediaQuery], while
/// iOS Reduce Motion is exposed separately through [AccessibilityFeatures].
/// The user's Settings override is then applied on top of both OS signals.
bool reduceMotionOf(BuildContext context) {
  final features = View.of(context).platformDispatcher.accessibilityFeatures;
  final platformRequestsReduction =
      MediaQuery.disableAnimationsOf(context) || features.reduceMotion;
  return switch (MotionPreferenceScope.maybeOf(context)) {
    MotionPreference.system => platformRequestsReduction,
    MotionPreference.reduced => true,
    MotionPreference.full => false,
  };
}

/// The duration for a transition at this context.
Duration motionDurationOf(BuildContext context, Duration full) =>
    reduceMotionOf(context) ? PinneMotionDurations.reducedFade : full;

/// No stagger is applied when reduced motion is enabled.
Duration staggerDelayOf(BuildContext context, int index) =>
    reduceMotionOf(context)
    ? Duration.zero
    : PinneMotionDurations.stagger * index;

/// The operating system's flags, kept live for non-widget consumers.
final platformReduceMotionProvider =
    NotifierProvider<PlatformReduceMotionNotifier, bool>(
      PlatformReduceMotionNotifier.new,
    );

class PlatformReduceMotionNotifier extends Notifier<bool>
    with WidgetsBindingObserver {
  @override
  bool build() {
    final binding = WidgetsBinding.instance;
    binding.addObserver(this);
    ref.onDispose(() => binding.removeObserver(this));
    return _read();
  }

  bool _read() {
    final features = PlatformDispatcher.instance.accessibilityFeatures;
    return features.disableAnimations || features.reduceMotion;
  }

  @override
  void didChangeAccessibilityFeatures() => state = _read();
}

/// The motion choice made in Settings. Defaults to following the system.
final motionPreferenceProvider =
    NotifierProvider<MotionPreferenceNotifier, MotionPreference>(
      MotionPreferenceNotifier.new,
    );

class MotionPreferenceNotifier extends Notifier<MotionPreference> {
  @override
  MotionPreference build() => MotionPreference.system;

  void set(MotionPreference preference) => state = preference;
}

/// Provider equivalent for logic that does not have a [BuildContext].
final reduceMotionProvider = Provider<bool>((ref) {
  return switch (ref.watch(motionPreferenceProvider)) {
    MotionPreference.system => ref.watch(platformReduceMotionProvider),
    MotionPreference.reduced => true,
    MotionPreference.full => false,
  };
});
