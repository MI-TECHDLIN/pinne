import 'dart:math' as math;

/// A versioned, platform-independent recipe. No Random or String.hashCode:
/// all integer arithmetic stays within JavaScript's exact integer range.
class RibbonRecipe {
  RibbonRecipe(int seed) {
    var state = seed.abs() % 2147483646 + 1;
    double next() {
      state = (state * 48271) % 2147483647;
      return state / 2147483647;
    }

    // Warm up so adjacent seeds have visibly different silhouettes.
    next();
    curls = 1.05 + next() * .58;
    thickness = 17 + next() * 7;
    tilt = (next() - .5) * .65;
    gradientAngle = next() * math.pi * 2;
    aspect = .85 + next() * .23;
  }

  late final double curls;
  late final double thickness;
  late final double tilt;
  late final double gradientAngle;
  late final double aspect;

  List<double> get signature => [curls, thickness, tilt, gradientAngle, aspect];

  /// Stable fallback and picker seeds, also safe to persist as an API int.
  static int seedForUser(String userId) {
    var seed = 7;
    for (final unit in userId.codeUnits) {
      seed = (seed * 31 + unit) % 2147483647;
    }
    return seed % 2147483647;
  }

  static List<int> choicesFor(String userId) => List.generate(
    12,
    (index) => seedForUser('$userId/ribbon/$index'),
  );
}
