// lib/core/theme/font_size_controller.dart
// ─────────────────────────────────────────────────────────────────────────────
// Centralized dynamic font scaling system.
// Registered permanent — survives navigation.
// All widgets read scale via context.fs or FontSizeController.to.scale.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppFontSize { small, medium, large }

class FontSizeController extends GetxController {
  static FontSizeController get to => Get.find<FontSizeController>();

  final Rx<AppFontSize> fontSize = AppFontSize.medium.obs;

  double get scale {
    switch (fontSize.value) {
      case AppFontSize.small:
        return 0.85;
      case AppFontSize.medium:
        return 1.0;
      case AppFontSize.large:
        return 1.18;
    }
  }

  String get label {
    switch (fontSize.value) {
      case AppFontSize.small:
        return 'Small';
      case AppFontSize.medium:
        return 'Medium';
      case AppFontSize.large:
        return 'Large';
    }
  }

  String get labelAr {
    switch (fontSize.value) {
      case AppFontSize.small:
        return 'صغير';
      case AppFontSize.medium:
        return 'متوسط';
      case AppFontSize.large:
        return 'كبير';
    }
  }

  void setFontSize(AppFontSize size) {
    if (fontSize.value == size) return;
    fontSize.value = size;
    // Rebuild theme text so TextTheme scales app-wide
    _rebuildTextTheme();
  }

  void _rebuildTextTheme() {
    // Triggers Obx wrappers that depend on fontSize to rebuild
    fontSize.refresh();
  }

  /// Scales a base font size by the current factor.
  double scaled(double base) => base * scale;
}

// ── Extension for ergonomic usage ─────────────────────────────────────────────
extension FontSizeContext on BuildContext {
  FontSizeController get fs => FontSizeController.to;
  double sp(double base) => base * FontSizeController.to.scale;
}
