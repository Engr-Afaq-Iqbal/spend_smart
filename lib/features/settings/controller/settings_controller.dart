// lib/features/settings/controller/settings_controller.dart
// ─────────────────────────────────────────────────────────────────────────────
// Feature-scoped controller for the Settings screen.
// Delegates theme/accent/locale changes to ThemeController (global singleton).
// All user-facing strings use .tr for localization.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/settings_models.dart';
import '../widgets/accent_color_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';

class SettingsController extends GetxController {
  ThemeController get _themeCtrl => Get.find<ThemeController>();

  final Rx<UserProfile> profile = SettingsCatalogue.profile.obs;

  final Map<String, RxBool> toggles = {
    'dark_mode':      false.obs,
    'ramadan_mode':   false.obs,
    'biometric':      true.obs,
    'cloud_sync':     true.obs,
    'budget_alerts':  true.obs,
    'upcoming_bills': true.obs,
    'weekly_summary': false.obs,
  };

  @override
  void onInit() {
    super.onInit();
    toggles['dark_mode']!.value = _themeCtrl.isDark.value;
    ever(_themeCtrl.isDark, (bool v) => toggles['dark_mode']!.value = v);
  }

  void onToggle(String id, bool value) {
    toggles[id]?.value = value;
    if (id == 'dark_mode') _themeCtrl.setDark(dark: value);
  }

  void onNavigateTile(String id) {
    switch (id) {
      case 'accent_color':
        AccentColorPicker.show(Get.context!);
        break;
      case 'language':
        _showLanguagePicker();
        break;
      case 'font_size':
      case 'currency':
      case 'pin_code':
      case 'auto_lock':
      case 'export_data':
      case 'family_mode':
      case 'support':
        _showComingSoon(id);
        break;
      case 'rate_app':
        Get.snackbar(
          'settings_rate_title'.tr,
          'settings_rate_body'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.surfaceCard,
          colorText: AppColors.textPrimary,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        break;
    }
  }

  void onActionTile(String id) {
    if (id == 'delete_account') _confirmDeleteAccount();
  }

  void onProfileTap() => _showComingSoon('profile_edit');

  void onUpgradeTap() {
    Get.snackbar(
      'settings_upgrade_snackbar'.tr,
      'settings_upgrade_snackbar_body'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _themeCtrl.accentColor.value,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.star_rounded, color: Colors.white),
    );
  }

  // ── Language picker dialog ────────────────────────────────────────────────
  void _showLanguagePicker() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'settings_language'.tr,
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langTile('English', 'en', Icons.language_rounded),
            const Divider(height: 1),
            _langTile('العربية', 'ar', Icons.language_rounded),
          ],
        ),
      ),
    );
  }

  Widget _langTile(String label, String code, IconData icon) {
    final isActive = _themeCtrl.currentLocale.value.languageCode == code;
    return ListTile(
      leading: Icon(icon, color: isActive ? _themeCtrl.accentColor.value : AppColors.textSecondary),
      title: Text(label, style: const TextStyle(fontFamily: 'Poppins')),
      trailing: isActive
          ? Icon(Icons.check_circle_rounded, color: _themeCtrl.accentColor.value)
          : null,
      onTap: () {
        _themeCtrl.setLanguage(code);
        Get.back();
      },
    );
  }

  void _showComingSoon(String feature) {
    Get.snackbar(
      'settings_coming_soon'.tr,
      'settings_coming_soon_body'.trParams({'feature': _featureLabel(feature)}),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surfaceCard,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      icon: Icon(Icons.info_outline_rounded, color: _themeCtrl.accentColor.value),
    );
  }

  void _confirmDeleteAccount() {
    Get.dialog(
      AlertDialog(
        title: Text('settings_delete_title'.tr,
            style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        content: Text('settings_delete_body'.tr,
            style: const TextStyle(fontFamily: 'Poppins')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('settings_delete_cancel'.tr,
                style: const TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'settings_delete_submitted'.tr,
                'settings_delete_submitted_body'.tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.error,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
            child: Text('settings_delete_confirm'.tr,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.error,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String _featureLabel(String id) {
    final map = {
      'font_size': 'settings_font_size'.tr,
      'accent_color': 'settings_accent_color'.tr,
      'language': 'settings_language'.tr,
      'currency': 'settings_currency'.tr,
      'pin_code': 'settings_pin_code'.tr,
      'auto_lock': 'settings_auto_lock'.tr,
      'export_data': 'settings_export_data'.tr,
      'family_mode': 'settings_family_mode'.tr,
      'support': 'settings_support'.tr,
      'profile_edit': 'settings_title'.tr,
    };
    return map[id] ?? id;
  }
}
