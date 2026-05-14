// lib/main.dart
// ─────────────────────────────────────────────────────────────────────────────
// Application entry point.
//
// Key wiring:
//   1. ThemeController registered permanent before GetMaterialApp
//   2. GetMaterialApp wrapped in Obx — reacts to ThemeController.accentColor,
//      isDark, and currentLocale changes instantly
//   3. AppTranslations wired into GetMaterialApp for full i18n
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controllers/font_size_controller.dart';
import 'core/l10n/app_translations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/coach/controller/ai_credits_controller.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register ThemeController BEFORE runApp — permanent so it never gets disposed
  Get.put<ThemeController>(ThemeController(), permanent: true);
  Get.put<FontSizeController>(FontSizeController(), permanent: true); // ← NEW
  Get.put<AiCreditsController>(AiCreditsController(), permanent: true); // ← NEW

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const SpendSmartApp());
}

class SpendSmartApp extends StatelessWidget {
  const SpendSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    // Obx makes GetMaterialApp rebuild whenever isDark, accentColor, or
    // currentLocale changes — entire app re-renders with correct theme/locale.
    return Obx(() => GetMaterialApp(
          title: 'SpendSmart',
          debugShowCheckedModeBanner: false,

          // ── Theme — rebuilt with current accent on every color change ─
          theme: AppTheme.buildLight(themeCtrl.accentColor.value),
          darkTheme: AppTheme.buildDark(themeCtrl.accentColor.value),
          themeMode: themeCtrl.themeMode,

          // ── Localization ─────────────────────────────────────────────
          translations: AppTranslations(),
          locale: themeCtrl.currentLocale.value,
          fallbackLocale: const Locale('en', 'US'),

          // ── Navigation ───────────────────────────────────────────────
          initialRoute: AppRoutes.home,
          getPages: AppPages.routes,
        ));
  }
}
