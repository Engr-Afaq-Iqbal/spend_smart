// lib/features/settings/view/settings_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// Settings screen — pushed via Get.toNamed('/settings').
// All text uses .tr for localization. Colors via Theme.of(context).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/theme_controller.dart';
import '../controller/settings_controller.dart';
import '../model/settings_models.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/settings_footer.dart';
import '../widgets/settings_tile_widgets.dart';
import '../widgets/upgrade_banner.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: Get.back,
        ),
        title: Text(
          'settings_title'.tr,
          style: AppTextStyles.h3.copyWith(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        titleSpacing: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.lg,
          AppSpacing.pagePadding,
          AppSpacing.xxxl,
        ),
        children: [
          const ProfileHeaderCard(),
          const SizedBox(height: AppSpacing.lg),
          const UpgradeBanner(),
          const SizedBox(height: AppSpacing.xxl),
          ...SettingsCatalogue.sections.map(
            (section) => _SettingsSectionBlock(
              section: section,
              controller: controller,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SettingsFooter(),
        ],
      ),
    );
  }
}

class _SettingsSectionBlock extends StatelessWidget {
  final SettingsSection section;
  final SettingsController controller;

  const _SettingsSectionBlock(
      {required this.section, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label — translated
          SettingsSectionLabel(title: section.titleKey.tr),
          const SizedBox(height: AppSpacing.xs),
          SettingsSectionCard(
            children: section.tiles.map(_buildTile).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(SettingsTile tile) {
    switch (tile.type) {
      case SettingsTileType.toggle:
        final rxBool = controller.toggles[tile.id] ?? false.obs;
        return SettingsToggleTile(
          icon: tile.icon,
          iconColor: tile.iconColor,
          title: tile.titleKey.tr,
          subtitle: tile.subtitleKey?.tr,
          value: rxBool,
          onChanged: (v) => controller.onToggle(tile.id, v),
        );
      case SettingsTileType.navigate:
        // Accent color tile — show live color dot as leading extra
        if (tile.id == 'accent_color') {
          return _AccentColorTile(
            tile: tile,
            onTap: () => controller.onNavigateTile(tile.id),
          );
        }
        return SettingsNavigateTile(
          icon: tile.icon,
          iconColor: tile.iconColor,
          title: tile.titleKey.tr,
          subtitle: tile.subtitleKey?.tr,
          onTap: () => controller.onNavigateTile(tile.id),
        );
      case SettingsTileType.action:
        return SettingsActionTile(
          icon: tile.icon,
          iconColor: tile.iconColor,
          title: tile.titleKey.tr,
          isDangerous: tile.isDangerous,
          onTap: () => controller.onActionTile(tile.id),
        );
    }
  }
}

// ── Special accent color tile — shows the live color swatch ──────────────────
class _AccentColorTile extends StatelessWidget {
  final SettingsTile tile;
  final VoidCallback onTap;

  const _AccentColorTile({required this.tile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              // Icon pill
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: tile.iconColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(tile.icon, color: tile.iconColor, size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'settings_accent_color'.tr,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              // Live color swatch
              Obx(() => Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: themeCtrl.accentColor.value,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeCtrl.accentColor.value.withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  )),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
