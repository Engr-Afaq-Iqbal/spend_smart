// lib/features/home/widgets/summary_header_card.dart
// ─────────────────────────────────────────────────────────────────────────────
// Coral gradient header — accent-reactive via ThemeController.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../routes/app_routes.dart';

class SummaryHeaderCard extends GetView<HomeController> {
  const SummaryHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return Obx(() {
      final accent = themeCtrl.accentColor.value;
      // Derive gradient stops from the accent color
      final gradientLight = Color.lerp(accent, Colors.white, 0.15) ?? accent;
      final gradientDark  = Color.lerp(accent, Colors.black, 0.10) ?? accent;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding, AppSpacing.xxl,
          AppSpacing.pagePadding, AppSpacing.xxl,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientLight, gradientDark],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Greeting row ─────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.greeting} 🌤',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white70, fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${controller.userName.value}!',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.white, fontSize: 24,
                          ),
                        ),
                      ],
                    )),
                Row(
                  children: [
                    _IconButton(icon: Icons.notifications_outlined, onTap: () {}),
                    const SizedBox(width: AppSpacing.sm),
                    _IconButton(
                      icon: Icons.settings_outlined,
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.settings),
                      child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          border: Border.all(color: Colors.white30, width: 1.5),
                        ),
                        child: const Icon(Icons.person_rounded, color: AppColors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Finance stat chips ─────────────────────────────────────────
            Obx(() => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatChip(
                        label: 'home_income'.tr,
                        value: 'SAR ${_format(controller.income.value)}',
                        valueColor: AppColors.white,
                      ),
                      _VerticalDivider(),
                      _StatChip(
                        label: 'home_available'.tr,
                        value: 'SAR ${_format(controller.available.value)}',
                        valueColor: const Color(0xFFFFE0A3),
                      ),
                      _VerticalDivider(),
                      _StatChip(
                        label: 'home_spent'.tr,
                        value: 'SAR ${_format(controller.spent.value)}',
                        valueColor: AppColors.white,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );
    });
  }

  String _format(double v) => v >= 1000
      ? '${(v / 1000).toStringAsFixed(v % 1000 == 0 ? 0 : 1)}k'
      : v.toStringAsFixed(0);
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatChip({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 3),
        Text(value,
            style: AppTextStyles.labelLarge.copyWith(color: valueColor, fontSize: 13)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 32, color: Colors.white24);
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Icon(icon, color: AppColors.white, size: 20),
      ),
    );
  }
}
