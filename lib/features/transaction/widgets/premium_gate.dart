// // lib/features/transaction/widgets/premium_gate.dart
// // ─────────────────────────────────────────────────────────────────────────────
// // Reusable premium paywall dialog shown when non-premium users tap AI features.
// // ─────────────────────────────────────────────────────────────────────────────
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/app_spacing.dart';
// import '../../../core/constants/app_text_styles.dart';
//
// class PremiumGate {
//   static void show({
//     required BuildContext context,
//     required String titleKey,
//     required String descKey,
//     required IconData icon,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _PremiumSheet(
//         titleKey: titleKey,
//         descKey: descKey,
//         icon: icon,
//       ),
//     );
//   }
// }
//
// class _PremiumSheet extends StatelessWidget {
//   final String titleKey;
//   final String descKey;
//   final IconData icon;
//   const _PremiumSheet({required this.titleKey, required this.descKey, required this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//     final cs     = Theme.of(context).colorScheme;
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bg     = isDark ? AppColors.darkSurface : AppColors.white;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       padding: EdgeInsets.fromLTRB(24, 16, 24,
//           MediaQuery.of(context).viewInsets.bottom + 32),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Handle
//           Center(child: Container(
//             width: 40, height: 4,
//             decoration: BoxDecoration(
//               color: cs.onBackground.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(2)),
//           )),
//           const SizedBox(height: 24),
//
//           // Premium icon
//           Container(
//             width: 72, height: 72,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft, end: Alignment.bottomRight,
//                 colors: [AppColors.warning, AppColors.primary],
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: Colors.white, size: 34),
//           ),
//           const SizedBox(height: 16),
//
//           // Premium badge
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             decoration: BoxDecoration(
//               color: AppColors.warning.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: AppColors.warning.withOpacity(0.30)),
//             ),
//             child: Text('premium'.tr,
//               style: AppTextStyles.labelSmall.copyWith(
//                 fontSize: 11, fontWeight: FontWeight.w700,
//                 color: AppColors.warning, letterSpacing: 0.5)),
//           ),
//           const SizedBox(height: 12),
//
//           Text(titleKey.tr,
//             style: AppTextStyles.h3.copyWith(
//               fontSize: 20, color: cs.onBackground),
//             textAlign: TextAlign.center),
//           const SizedBox(height: 8),
//
//           Text(descKey.tr,
//             style: AppTextStyles.bodyMedium.copyWith(
//               fontSize: 14, color: cs.onBackground.withOpacity(0.60),
//               height: 1.5),
//             textAlign: TextAlign.center),
//           const SizedBox(height: 28),
//
//           // Upgrade CTA
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               Get.snackbar('premium_feature'.tr, 'Coming soon!',
//                 snackPosition: SnackPosition.BOTTOM,
//                 margin: const EdgeInsets.all(16));
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//               minimumSize: const Size.fromHeight(52),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30)),
//               elevation: 0,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.auto_awesome_rounded, size: 18),
//                 const SizedBox(width: 8),
//                 Text('unlock_premium'.tr,
//                   style: AppTextStyles.labelLarge.copyWith(
//                     color: Colors.white, fontSize: 15)),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           TextButton(
//             onPressed: Get.back,
//             child: Text('maybe_later'.tr,
//               style: AppTextStyles.bodyMedium.copyWith(
//                 color: cs.onBackground.withOpacity(0.45))),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/features/transaction/widgets/premium_gate.dart
// ─────────────────────────────────────────────────────────────────────────────
// Reusable premium paywall dialog shown when non-premium users tap AI features.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PremiumGate {
  static void show({
    required BuildContext context,
    required String titleKey,
    required String descKey,
    required IconData icon,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PremiumSheet(
        titleKey: titleKey,
        descKey: descKey,
        icon: icon,
      ),
    );
  }
}

class _PremiumSheet extends StatelessWidget {
  final String titleKey;
  final String descKey;
  final IconData icon;
  const _PremiumSheet(
      {required this.titleKey, required this.descKey, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.white;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
              child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: cs.onBackground.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2)),
          )),
          const SizedBox(height: 24),

          // Premium icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.warning, AppColors.primary],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 34),
          ),
          const SizedBox(height: 16),

          // Premium badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.warning.withOpacity(0.30)),
            ),
            child: Text('premium'.tr,
                style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                    letterSpacing: 0.5)),
          ),
          const SizedBox(height: 12),

          Text(titleKey.tr,
              style: AppTextStyles.h3
                  .copyWith(fontSize: 20, color: cs.onBackground),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),

          Text(descKey.tr,
              style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 14,
                  color: cs.onBackground.withOpacity(0.60),
                  height: 1.5),
              textAlign: TextAlign.center),
          const SizedBox(height: 28),

          // Upgrade CTA
          ElevatedButton(
            onPressed: () {
              Get.back(); // close gate sheet
              Future.delayed(const Duration(milliseconds: 200), () {
                Get.toNamed('/subscription');
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome_rounded, size: 18),
                const SizedBox(width: 8),
                Text('unlock_premium'.tr,
                    style: AppTextStyles.labelLarge
                        .copyWith(color: Colors.white, fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          TextButton(
            onPressed: Get.back,
            child: Text('maybe_later'.tr,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: cs.onBackground.withOpacity(0.45))),
          ),
        ],
      ),
    );
  }
}
