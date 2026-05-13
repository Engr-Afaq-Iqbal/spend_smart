// lib/features/settings/model/settings_models.dart
// ─────────────────────────────────────────────────────────────────────────────
// Pure data models. String fields are TRANSLATION KEYS — call .tr on them
// in the UI layer. No widget or GetX imports here.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class UserProfile {
  final String name;
  final String email;
  final String planKey; // translation key e.g. 'settings_free_plan'
  const UserProfile({required this.name, required this.email, required this.planKey});
  String get plan => planKey; // raw — call .tr in UI
}

enum SettingsTileType { toggle, navigate, action }

class SettingsTile {
  final String id;
  final String titleKey;        // translation key
  final String? subtitleKey;    // optional translation key
  final IconData icon;
  final Color iconColor;
  final SettingsTileType type;
  final bool isDangerous;

  const SettingsTile({
    required this.id,
    required this.titleKey,
    this.subtitleKey,
    required this.icon,
    required this.iconColor,
    required this.type,
    this.isDangerous = false,
  });
}

class SettingsSection {
  final String titleKey; // translation key
  final List<SettingsTile> tiles;
  const SettingsSection({required this.titleKey, required this.tiles});
}

// ─────────────────────────────────────────────────────────────────────────────
// Static catalogue
// ─────────────────────────────────────────────────────────────────────────────
class SettingsCatalogue {
  static const UserProfile profile = UserProfile(
    name: 'Ahmad Mohammed',
    email: 'ahmad@email.com',
    planKey: 'settings_free_plan',
  );

  static const List<SettingsSection> sections = [
    SettingsSection(
      titleKey: 'settings_section_appearance',
      tiles: [
        SettingsTile(id: 'dark_mode',    titleKey: 'settings_dark_mode',    icon: Icons.dark_mode_rounded,       iconColor: Color(0xFF5C6BC0), type: SettingsTileType.toggle),
        SettingsTile(id: 'font_size',    titleKey: 'settings_font_size',    subtitleKey: 'settings_font_size_value',  icon: Icons.text_fields_rounded,     iconColor: AppColors.categoryShopping, type: SettingsTileType.navigate),
        SettingsTile(id: 'accent_color', titleKey: 'settings_accent_color', icon: Icons.color_lens_rounded,      iconColor: AppColors.primary, type: SettingsTileType.navigate),
      ],
    ),
    SettingsSection(
      titleKey: 'settings_section_language',
      tiles: [
        SettingsTile(id: 'language',     titleKey: 'settings_language',     subtitleKey: 'settings_language_value',   icon: Icons.language_rounded,          iconColor: AppColors.warning,         type: SettingsTileType.navigate),
        SettingsTile(id: 'currency',     titleKey: 'settings_currency',     subtitleKey: 'settings_currency_value',   icon: Icons.currency_exchange_rounded, iconColor: AppColors.categoryShopping, type: SettingsTileType.navigate),
        SettingsTile(id: 'ramadan_mode', titleKey: 'settings_ramadan_mode', subtitleKey: 'settings_ramadan_subtitle', icon: Icons.nightlight_round,          iconColor: AppColors.categoryFood,    type: SettingsTileType.toggle),
      ],
    ),
    SettingsSection(
      titleKey: 'settings_section_security',
      tiles: [
        SettingsTile(id: 'biometric', titleKey: 'settings_biometric', icon: Icons.fingerprint_rounded, iconColor: AppColors.primary,      type: SettingsTileType.toggle),
        SettingsTile(id: 'pin_code',  titleKey: 'settings_pin_code',  subtitleKey: 'settings_pin_code_value', icon: Icons.pin_rounded,  iconColor: Color(0xFF5C6BC0), type: SettingsTileType.navigate),
        SettingsTile(id: 'auto_lock', titleKey: 'settings_auto_lock', subtitleKey: 'settings_auto_lock_value', icon: Icons.lock_clock_rounded, iconColor: AppColors.categoryShopping, type: SettingsTileType.navigate),
      ],
    ),
    SettingsSection(
      titleKey: 'settings_section_data',
      tiles: [
        SettingsTile(id: 'cloud_sync',  titleKey: 'settings_cloud_sync',  icon: Icons.cloud_sync_rounded, iconColor: Color(0xFF5C6BC0),         type: SettingsTileType.toggle),
        SettingsTile(id: 'export_data', titleKey: 'settings_export_data', icon: Icons.download_rounded,   iconColor: AppColors.categoryShopping, type: SettingsTileType.navigate),
        SettingsTile(id: 'family_mode', titleKey: 'settings_family_mode', subtitleKey: 'settings_family_mode_value', icon: Icons.group_rounded, iconColor: AppColors.warning, type: SettingsTileType.navigate),
      ],
    ),
    SettingsSection(
      titleKey: 'settings_section_notifications',
      tiles: [
        SettingsTile(id: 'budget_alerts',  titleKey: 'settings_budget_alerts',  icon: Icons.notifications_active_rounded, iconColor: AppColors.primary, type: SettingsTileType.toggle),
        SettingsTile(id: 'upcoming_bills', titleKey: 'settings_upcoming_bills', icon: Icons.receipt_long_rounded,         iconColor: AppColors.warning,  type: SettingsTileType.toggle),
        SettingsTile(id: 'weekly_summary', titleKey: 'settings_weekly_summary', icon: Icons.bar_chart_rounded,            iconColor: Color(0xFF5C6BC0),   type: SettingsTileType.toggle),
      ],
    ),
    SettingsSection(
      titleKey: 'settings_section_account',
      tiles: [
        SettingsTile(id: 'support',        titleKey: 'settings_support',        icon: Icons.help_outline_rounded,    iconColor: AppColors.categoryShopping, type: SettingsTileType.navigate),
        SettingsTile(id: 'rate_app',       titleKey: 'settings_rate_app',       icon: Icons.star_outline_rounded,    iconColor: AppColors.warning,          type: SettingsTileType.navigate),
        SettingsTile(id: 'delete_account', titleKey: 'settings_delete_account', icon: Icons.delete_forever_rounded,  iconColor: AppColors.error,            type: SettingsTileType.action, isDangerous: true),
      ],
    ),
  ];
}
