// lib/features/settings/widgets/settings_tile_widgets.dart
// ─────────────────────────────────────────────────────────────────────────────
// Reusable atomic widgets for the Settings screen.
//
// Hierarchy:
//   SettingsSectionCard   → white card grouping a set of tiles
//   SettingsToggleTile    → tile with a Switch on the right
//   SettingsNavigateTile  → tile with a chevron → navigates somewhere
//   SettingsActionTile    → tap-only tile (no trailing widget, possibly red)
//   _SettingsTileBase     → shared layout used by all tile types
//   _IconPill             → rounded square icon container
//   SettingsSectionLabel  → grey ALL-CAPS section header
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  SECTION LABEL  (e.g. "APPEARANCE")
// ══════════════════════════════════════════════════════════════════════════════
class SettingsSectionLabel extends StatelessWidget {
  final String title;
  const SettingsSectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Color adapts to theme via Theme.of(context)
    final textColor = Theme.of(context).colorScheme.onBackground
        .withOpacity(0.45);

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
        top: AppSpacing.xs,
      ),
      child: Text(
        title,
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  SECTION CARD  — groups tiles in a rounded white / dark-surface card
// ══════════════════════════════════════════════════════════════════════════════
class SettingsSectionCard extends StatelessWidget {
  final List<Widget> children;
  const SettingsSectionCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardTheme.color ??
        Theme.of(context).colorScheme.surface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: isDark
            ? null
            : const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: _insertDividers(children, context),
      ),
    );
  }

  // Insert a 1px divider between tiles (not before first, not after last)
  List<Widget> _insertDividers(List<Widget> items, BuildContext context) {
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(Divider(
          height: 1,
          indent: 56, // align with tile text (icon width + padding)
          endIndent: 0,
          color: Theme.of(context).dividerTheme.color,
        ));
      }
    }
    return result;
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  TOGGLE TILE
// ══════════════════════════════════════════════════════════════════════════════
class SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final RxBool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTileBase(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      trailing: Obx(() => Switch(
            value: value.value,
            onChanged: onChanged,
          )),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  NAVIGATE TILE  — chevron on right, tapping navigates somewhere
// ══════════════════════════════════════════════════════════════════════════════
class SettingsNavigateTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const SettingsNavigateTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTileBase(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.35),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  ACTION TILE  — tap-only, no trailing widget; red for dangerous actions
// ══════════════════════════════════════════════════════════════════════════════
class SettingsActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final bool isDangerous;

  const SettingsActionTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTileBase(
      icon: icon,
      iconColor: iconColor,
      title: title,
      titleColor: isDangerous ? AppColors.error : null,
      onTap: onTap,
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  BASE TILE LAYOUT  — shared by all tile types
// ══════════════════════════════════════════════════════════════════════════════
class _SettingsTileBase extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? titleColor;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTileBase({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.titleColor,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = titleColor ??
        Theme.of(context).listTileTheme.titleTextStyle?.color ??
        AppColors.textPrimary;
    final subColor = Theme.of(context).listTileTheme.subtitleTextStyle?.color ??
        AppColors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              // ── Icon pill ────────────────────────────────────────────
              _IconPill(icon: icon, color: iconColor),
              const SizedBox(width: AppSpacing.md),

              // ── Text block ───────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 12,
                          color: subColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ── Trailing widget (switch / chevron) ───────────────────
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  ICON PILL  — rounded square with icon, matching the design's style
// ══════════════════════════════════════════════════════════════════════════════
class _IconPill extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconPill({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
