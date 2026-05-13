// lib/features/timeline/widgets/summary_bar.dart
// ─────────────────────────────────────────────────────────────────────────────
// The section header + total row shown above the transaction list.
//
// Design matches:
//   "April 29 – Transactions"  (bold, left-aligned)
//   "Day Total        -SAR 283"  (subtle label + accent amount, right-aligned)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/timeline_controller.dart';
import '../model/timeline_models.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class SummaryBar extends GetView<TimelineController> {
  const SummaryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final filter = controller.activeFilter.value;
      final total  = controller.displayTotal;
      final txList = controller.filteredTransactions;

      // Dynamic section title
      final String sectionTitle = _buildTitle(filter);

      // Total label
      final String totalLabel = _buildTotalLabel(filter);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ──────────────────────────────────────────
          Text(
            sectionTitle,
            style: AppTextStyles.h3.copyWith(
              fontSize: 16,
              color: cs.onBackground,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Day/Week/Month total row ─────────────────────────────────
          if (txList.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? cs.primary.withOpacity(0.10)
                    : cs.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border(
                  left: BorderSide(
                    color: cs.primary,
                    width: 3,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    totalLabel,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: cs.onBackground.withOpacity(0.65),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '-SAR ${_fmt(total)}',
                    style: AppTextStyles.amountMedium.copyWith(
                      color: cs.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    });
  }

  String _buildTitle(TimelineFilter filter) {
    switch (filter) {
      case TimelineFilter.daily:
        final day = controller.selectedDay.value;
        if (day == null) return 'timeline_day_total'.tr;
        return '${_monthShort(day.month)} ${day.day} – ${'timeline_transactions'.tr}';
      case TimelineFilter.weekly:
        final idx = controller.selectedWeekIndex.value;
        if (idx == null) return 'timeline_week_total'.tr;
        return 'W${idx + 1} – ${'timeline_transactions'.tr}';
      case TimelineFilter.monthly:
        return '${controller.displayMonthName} – ${'timeline_transactions'.tr}';
    }
  }

  String _buildTotalLabel(TimelineFilter filter) {
    switch (filter) {
      case TimelineFilter.daily:
        return 'timeline_day_total'.tr;
      case TimelineFilter.weekly:
        return 'timeline_week_total'.tr;
      case TimelineFilter.monthly:
        return 'timeline_month_total'.tr;
    }
  }

  String _monthShort(int m) {
    const n = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return n[m];
  }

  String _fmt(double v) {
    if (v >= 1000) {
      final n = v.toStringAsFixed(0);
      final buf = StringBuffer();
      for (var i = 0; i < n.length; i++) {
        if (i > 0 && (n.length - i) % 3 == 0) buf.write(',');
        buf.write(n[i]);
      }
      return buf.toString();
    }
    return v.toStringAsFixed(0);
  }
}
