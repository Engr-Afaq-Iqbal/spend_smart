// lib/core/constants/app_colors.dart
// ─────────────────────────────────────────────────────────────────────────────
// Centralized color palette — extracted from the SpendSmart design mockups.
// All colors live here so swapping the brand palette = one file change.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Brand / Primary ──────────────────────────────────────────────────────
  /// Main coral/orange brand color used for CTAs, icons, accents
  static const Color primary = Color(0xFFFF6B35);

  /// Lighter tint of primary — used for backgrounds, chips, card fills
  static const Color primaryLight = Color(0xFFFFF0EB);

  /// Soft orange for progress bars, secondary accents
  static const Color primarySoft = Color(0xFFFF8C5A);

  // ── Neutrals ─────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F9FC);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFF0F0F5);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1D2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFFADB5C2);

  // ── Category Colors ───────────────────────────────────────────────────────
  /// Food & Dining — red/coral
  static const Color categoryFood = Color(0xFFFF5252);

  /// Transport — blue
  static const Color categoryTransport = Color(0xFF4285F4);

  /// Shopping — green
  static const Color categoryShopping = Color(0xFF34C759);

  /// Income — green positive
  static const Color income = Color(0xFF34C759);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFFF3B30);

  // ── Progress / Chart ──────────────────────────────────────────────────────
  static const Color progressTrack = Color(0xFFE8EAED);

  // ── Bottom Nav ────────────────────────────────────────────────────────────
  static const Color navBackground = Color(0xFFFFFFFF);
  static const Color navActive = Color(0xFFFF6B35);
  static const Color navInactive = Color(0xFFBCC0C8);

  // ── Shadow ────────────────────────────────────────────────────────────────
  static const Color shadow = Color(0x0F000000);
  static const Color shadowMedium = Color(0x1A000000);

  // ── Dark Theme Equivalents (prepared for future dark mode) ───────────────
  static const Color darkBackground = Color(0xFF0F1117);
  static const Color darkSurface = Color(0xFF1C1F2E);
  static const Color darkTextPrimary = Color(0xFFF1F3F9);
  static const Color darkTextSecondary = Color(0xFF8B90A0);
}
