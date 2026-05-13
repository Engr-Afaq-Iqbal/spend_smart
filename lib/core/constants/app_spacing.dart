// lib/core/constants/app_spacing.dart
// ─────────────────────────────────────────────────────────────────────────────
// Design-token–based spacing scale.
// Avoids magic numbers scattered throughout widgets.
// ─────────────────────────────────────────────────────────────────────────────

abstract class AppSpacing {
  // 4-point base grid
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Section padding (horizontal page margin)
  static const double pagePadding = 20.0;

  // Card radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusFull = 100.0;

  // Bottom nav height
  static const double bottomNavHeight = 70.0;

  // Icon sizes
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;

  // Category icon container size
  static const double categoryIconSize = 40.0;
}
