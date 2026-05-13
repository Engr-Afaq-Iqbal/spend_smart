// lib/features/settings/widgets/settings_footer.dart
// ─────────────────────────────────────────────────────────────────────────────
// Bottom footer shown after all settings sections.
// Displays app name + version + copyright line.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_text_styles.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context)
        .colorScheme
        .onBackground
        .withOpacity(0.35);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          'footer_version'.tr,
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 11,
            color: color,
          ),
        ),
      ),
    );
  }
}
