// lib/features/reports/widgets/tabs/expenses_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/reports_controller.dart';
import '../reports_shared.dart';
import '../donut_chart.dart';
import '../bar_chart_widget.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';

class ExpensesTab extends GetView<ReportsController> {
  const ExpensesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Total Expenses card ──────────────────────────────────────────
        RCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('rpt_total_expenses_tab'.tr,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5,
                  color: cs.onBackground.withOpacity(0.50))),
              const SizedBox(height: 8),
              Text('SAR ${controller.fmtAmount(controller.totalExpenses.value)}',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 32, fontWeight: FontWeight.w700,
                  color: AppColors.categoryFood)),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.arrow_upward_rounded, size: 14,
                  color: AppColors.categoryFood),
                const SizedBox(width: 3),
                Text('${controller.expensesChange.value.toStringAsFixed(1)}% ${'rpt_vs_last_month'.tr}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12, color: AppColors.categoryFood)),
              ]),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Daily Expenses bar chart ─────────────────────────────────────
        ReportSectionTitle(
          titleKey: 'rpt_daily_expenses',
          trailing: '1 – 31 ${'rpt_may_2026'.tr}',
        ),
        const SizedBox(height: AppSpacing.md),

        RCard(
          child: DailyBarChart(
            points: controller.dailyExpenses,
            barColor: AppColors.categoryFood,
            dateRange: '1 – 31 May',
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Expense Breakdown donut ──────────────────────────────────────
        ReportSectionTitle(
          titleKey: 'rpt_expense_breakdown',
          trailing: 'rpt_by_category'.tr,
        ),
        const SizedBox(height: AppSpacing.md),

        RCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DonutChart(
                slices: controller.expenseBreakdown,
                centerLabel: 'SAR',
                centerValue: controller.fmtAmount(controller.totalExpenses.value),
                size: 140,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  children: controller.expenseBreakdown.map((s) =>
                    LegendRow(nameKey: s.nameKey, percentage: s.percentage, color: s.color)
                  ).toList(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Top Expense Categories list ──────────────────────────────────
        const ReportSectionTitle(titleKey: 'rpt_top_expense_categories'),
        const SizedBox(height: AppSpacing.md),

        RCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: controller.topExpenseCategories.asMap().entries.map((e) {
              final idx = e.key;
              final cat = e.value;
              final isLast = idx == controller.topExpenseCategories.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 10, height: 10,
                          decoration: BoxDecoration(
                            color: cat.color, shape: BoxShape.circle)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cat.nameKey.tr,
                                style: AppTextStyles.labelLarge.copyWith(
                                  fontSize: 14, color: cs.onBackground,
                                  fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: LinearProgressIndicator(
                                  value: cat.percentage / 100,
                                  minHeight: 4,
                                  backgroundColor: isDark ? Colors.white12 : const Color(0xFFE8EAED),
                                  valueColor: AlwaysStoppedAnimation(cat.color),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('SAR ${controller.fmtAmount(cat.amount)}',
                              style: AppTextStyles.amountSmall.copyWith(
                                fontSize: 14, color: cs.onBackground,
                                fontWeight: FontWeight.w700)),
                            Text('${cat.percentage.toStringAsFixed(1)}%',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 11,
                                color: cs.onBackground.withOpacity(0.45))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(height: 1, indent: AppSpacing.lg + 22,
                      color: cs.onBackground.withOpacity(0.06)),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Heads Up insight ─────────────────────────────────────────────
        InsightBanner(
          labelKey: 'rpt_heads_up',
          messageKey: 'rpt_expense_insight',
          bgColor: isDark
              ? AppColors.warning.withOpacity(0.10)
              : const Color(0xFFFFFBEB),
          iconColor: AppColors.warning,
          icon: Icons.warning_amber_rounded,
        ),

        const SizedBox(height: AppSpacing.xxl),
        Center(child: const ExportReportButton()),
        const SizedBox(height: AppSpacing.xxl),
      ],
    ));
  }
}
