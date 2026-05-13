// lib/game/utils/perspective_scaler.dart
// ─────────────────────────────────────────────────────────────────────────────
// Pseudo-3D perspective math. Objects start tiny at the vanishing point
// (top 32% of screen) and grow as they approach the player at groundNY (78%).
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:ui';

class PerspectiveScaler {
  PerspectiveScaler._();

  /// Normalised Y of the vanishing point (0 = top, 1 = bottom)
  static const double vanishingPointNY = 0.32;

  /// Normalised Y of the ground / player level
  static const double groundNY = 0.78;

  /// Returns a scale factor in [0.04, 1.0] for a given normalised Y.
  /// Objects at vanishingPointNY appear at 4% of full size; at groundNY, full.
  static double scaleForNY(double normalizedY) {
    if (normalizedY <= vanishingPointNY) return 0.04;
    final t =
        (normalizedY - vanishingPointNY) / (groundNY - vanishingPointNY);
    return 0.04 + t.clamp(0.0, 1.0) * 0.96;
  }

  /// Maps a lane base-offset (in screen-width fractions relative to centre)
  /// to an absolute X position, taking perspective scale into account so that
  /// lanes converge toward the vanishing point.
  static double laneXForNY(
    double baseLaneOffset,
    double screenW,
    double normalizedY,
  ) {
    final centerX = screenW / 2;
    final scale = scaleForNY(normalizedY);
    return centerX + baseLaneOffset * scale;
  }

  /// Returns the base lane offset (unscaled, from screen centre) for a lane.
  /// left = -22% of screen width, center = 0, right = +22%.
  static double baseLaneOffset(bool isLeft, bool isRight, double screenW) {
    if (isLeft) return -screenW * 0.22;
    if (isRight) return screenW * 0.22;
    return 0.0;
  }

  /// Linearly interpolates between two doubles — convenience for tween math.
  static double lerp(double a, double b, double t) => a + (b - a) * t;

  /// Compute world Y pixel position for a given normalised Y.
  static double worldYForNY(double normalizedY, double screenH) =>
      screenH * normalizedY;
}
