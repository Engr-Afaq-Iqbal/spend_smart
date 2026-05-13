// lib/core/theme/theme_controller.dart
// ─────────────────────────────────────────────────────────────────────────────
// Global singleton — owns ThemeMode, accent color, and locale switching.
// Registered permanent: true in main.dart; never disposed.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app_theme.dart';

class ThemeController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  final RxBool   isDark      = false.obs;
  final Rx<Color> accentColor = const Color(0xFFFF6B35).obs;
  final Rx<Locale> currentLocale = const Locale('en', 'US').obs;

  // ── Computed ──────────────────────────────────────────────────────────────
  ThemeMode get themeMode => isDark.value ? ThemeMode.dark : ThemeMode.light;
  bool get isArabic => currentLocale.value.languageCode == 'ar';

  // ── Theme actions ─────────────────────────────────────────────────────────
  void toggleTheme() => setDark(dark: !isDark.value);

  void setDark({required bool dark}) {
    if (isDark.value == dark) return;
    isDark.value = dark;
    _applyTheme();
  }

  // ── Accent color actions ──────────────────────────────────────────────────
  void setAccentColor(Color color) {
    accentColor.value = color;
    _applyTheme();
  }

  // ── Language actions ──────────────────────────────────────────────────────
  void setLanguage(String langCode) {
    final locale = langCode == 'ar'
        ? const Locale('ar', 'SA')
        : const Locale('en', 'US');
    currentLocale.value = locale;
    Get.updateLocale(locale);
  }

  void toggleLanguage() => setLanguage(isArabic ? 'en' : 'ar');

  // ── Internal ──────────────────────────────────────────────────────────────
  void _applyTheme() {
    // Rebuild ThemeData with the current accent color
    Get.changeTheme(
      isDark.value
          ? AppTheme.buildDark(accentColor.value)
          : AppTheme.buildLight(accentColor.value),
    );
    _updateSystemUI();
  }

  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      isDark.value
          ? const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            )
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    _updateSystemUI();
  }
}
