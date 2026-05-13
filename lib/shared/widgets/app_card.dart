// lib/shared/widgets/app_card.dart
// ─────────────────────────────────────────────────────────────────────────────
// Theme-aware card — background from Theme.of(context).cardTheme.color so it
// automatically switches between light (white) and dark (darkSurface).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;           // override only when explicitly needed
  final double? borderRadius;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark     = Theme.of(context).brightness == Brightness.dark;
    // Derive card color from theme so dark/light works automatically
    final cardColor  = color
        ?? Theme.of(context).cardTheme.color
        ?? (isDark ? AppColors.darkSurface : AppColors.surfaceCard);
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.30)
        : AppColors.shadow;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
