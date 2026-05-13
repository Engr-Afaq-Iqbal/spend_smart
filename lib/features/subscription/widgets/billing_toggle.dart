// lib/features/subscription/widgets/billing_toggle.dart
// ─────────────────────────────────────────────────────────────────────────────
// Monthly / Yearly animated toggle with "Save 25%" badge on Yearly.
// Sits in the coral header. White text on coral background.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/subscription_controller.dart';
import '../../../core/constants/app_text_styles.dart';

class BillingToggle extends GetView<SubscriptionController> {
  const BillingToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isYearly = controller.isYearly;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Monthly label
          GestureDetector(
            onTap: () {
              if (isYearly) {
                HapticFeedback.selectionClick();
                controller.toggleBilling();
              }
            },
            child: Text(
              'sub_monthly'.tr,
              style: AppTextStyles.labelMedium.copyWith(
                fontSize: 14,
                color: isYearly
                    ? Colors.white60
                    : Colors.white,
                fontWeight: isYearly ? FontWeight.w400 : FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Animated toggle switch
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              controller.toggleBilling();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 52,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.30),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white38, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  alignment: isYearly
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Yearly label + Save badge
          GestureDetector(
            onTap: () {
              if (!isYearly) {
                HapticFeedback.selectionClick();
                controller.toggleBilling();
              }
            },
            child: Row(
              children: [
                Text(
                  'sub_yearly'.tr,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontSize: 14,
                    color: isYearly ? Colors.white : Colors.white60,
                    fontWeight: isYearly ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (isYearly) ...[
                  const SizedBox(width: 6),
                  _SaveBadge(),
                ],
              ],
            ),
          ),

          // Show badge next to "Yearly" even when Monthly selected
          if (!isYearly) ...[
            const SizedBox(width: 6),
            _SaveBadge(),
          ],
        ],
      );
    });
  }
}

class _SaveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC107),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'sub_save_25'.tr,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }
}
