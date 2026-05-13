// lib/features/timeline/widgets/weekly_chart.dart
// ─────────────────────────────────────────────────────────────────────────────
// Weekly Totals section — W1/W2/W3/W4/W5 chips with a mini horizontal
// bar chart showing spending per week. Selected week is highlighted in accent.
//
// Matches design: W1-W5 labels at bottom, bar fills left→right,
// active bar is accent color, inactive bars are muted.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/timeline_controller.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';

class WeeklyChart extends GetView<TimelineController> {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'timeline_weekly_totals'.tr,
            style: AppTextStyles.labelMedium.copyWith(
              color: cs.onBackground.withOpacity(0.60),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Obx(() {
            final totals  = controller.weeklyTotals;
            final maxVal  = controller.maxWeeklyTotal;
            final selIdx  = controller.selectedWeekIndex.value;
            final accent  = cs.primary;
            final trackCl = isDark ? Colors.white12 : const Color(0xFFE8EAED);

            if (totals.isEmpty) return const SizedBox(height: 48);

            return Column(
              children: [
                // ── Bar chart ──────────────────────────────────────────
                SizedBox(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(totals.length, (i) {
                      final ratio = totals[i] / maxVal;
                      final isActive = i == selIdx;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectWeek(i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  height: (ratio * 40).clamp(3.0, 40.0),
                                  decoration: BoxDecoration(
                                    color: isActive ? accent : trackCl,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(3),
                                      topRight: Radius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 6),

                // ── Week labels ────────────────────────────────────────
                Row(
                  children: List.generate(totals.length, (i) {
                    final isActive = i == selIdx;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectWeek(i),
                        child: Center(
                          child: Text(
                            'W${i + 1}',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 11,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                              color: isActive
                                  ? cs.primary
                                  : cs.onBackground.withOpacity(0.45),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
