// // lib/features/settings/widgets/upgrade_banner.dart
// // ─────────────────────────────────────────────────────────────────────────────
// // "Upgrade to Pro" gradient banner shown below the profile card.
// // ─────────────────────────────────────────────────────────────────────────────
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/app_spacing.dart';
// import '../../../core/constants/app_text_styles.dart';
// import '../controller/settings_controller.dart';
//
// class UpgradeBanner extends GetView<SettingsController> {
//   const UpgradeBanner({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: controller.onUpgradeTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: AppSpacing.lg,
//           vertical: AppSpacing.md,
//         ),
//         decoration: BoxDecoration(
//           // Warm gold-to-orange gradient matching the design
//           gradient: const LinearGradient(
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//             colors: [const Color(0xFFFFC947), const Color(0xFFFF8C5A)],
//           ),
//           borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.warning.withOpacity(0.25),
//               blurRadius: 14,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // ── Icon + text ───────────────────────────────────────────
//             const Icon(Icons.auto_awesome_rounded,
//                 color: AppColors.white, size: 20),
//             const SizedBox(width: AppSpacing.md),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'settings_upgrade_title'.tr,
//                     style: AppTextStyles.labelLarge.copyWith(
//                       color: AppColors.white,
//                       fontSize: 15,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     'settings_upgrade_subtitle'.tr,
//                     style: AppTextStyles.bodySmall.copyWith(
//                       color: Colors.white70,
//                       fontSize: 11.5,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: AppSpacing.sm),
//
//             // ── CTA button ────────────────────────────────────────────
//             Container(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.25),
//                 borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
//                 border: Border.all(color: Colors.white38, width: 1),
//               ),
//               child: Text(
//                 'settings_upgrade_start'.tr,
//                 style: AppTextStyles.labelLarge.copyWith(
//                   color: AppColors.white,
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/features/settings/widgets/upgrade_banner.dart
// ─────────────────────────────────────────────────────────────────────────────
// "Upgrade to Pro" gradient banner shown below the profile card.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
// Navigate to subscription screen on tap
import '../controller/settings_controller.dart';

class UpgradeBanner extends GetView<SettingsController> {
  const UpgradeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/subscription'),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          // Warm gold-to-orange gradient matching the design
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [const Color(0xFFFFC947), const Color(0xFFFF8C5A)],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.warning.withOpacity(0.25),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Icon + text ───────────────────────────────────────────
            const Icon(Icons.auto_awesome_rounded,
                color: AppColors.white, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'settings_upgrade_title'.tr,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.white,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'settings_upgrade_subtitle'.tr,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white70,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // ── CTA button ────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: Colors.white38, width: 1),
              ),
              child: Text(
                'settings_upgrade_start'.tr,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
