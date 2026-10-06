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

/// The operating system's reduce-motion flag, kept live while the app runs.
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

  bool _read() =>
      PlatformDispatcher.instance.accessibilityFeatures.disableAnimations;

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

/// The single switch every animation reads. When true, skip or shorten
/// motion: use instant transitions, static illustrations and no parallax.
final reduceMotionProvider = Provider<bool>((ref) {
  return switch (ref.watch(motionPreferenceProvider)) {
    MotionPreference.system => ref.watch(platformReduceMotionProvider),
    MotionPreference.reduced => true,
    MotionPreference.full => false,
  };
});

/// Picks [full] or [Duration.zero] depending on [reduceMotionProvider].
extension MotionDurations on WidgetRef {
  Duration motionDuration(Duration full) =>
      watch(reduceMotionProvider) ? Duration.zero : full;
}
