// lib/features/reports/widgets/tabs/overview_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/reports_controller.dart';
import '../reports_shared.dart';
import '../donut_chart.dart';
import '../line_chart_widget.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';

class OverviewTab extends GetView<ReportsController> {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Total Balance card ──────────────────────────────────────────
        RCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('rpt_total_balance'.tr,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: cs.onBackground.withOpacity(0.50))),
              const SizedBox(height: 8),
              Text('SAR ${controller.fmtAmount(controller.totalBalance.value)}',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 32,
                  color: AppColors.categoryShopping,
                  fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.arrow_upward_rounded, size: 14,
                    color: AppColors.categoryShopping),
                  const SizedBox(width: 3),
                  Text('${controller.balanceChange.value.toStringAsFixed(0)}% ${'rpt_vs_last_month'.tr}',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 12, color: AppColors.categoryShopping)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Income + Expenses row ────────────────────────────────────────
        Row(
          children: [
            Expanded(child: RCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(width: 10, height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.categoryShopping,
                        shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('rpt_total_income'.tr,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 11, letterSpacing: 0.4,
                        color: cs.onBackground.withOpacity(0.50))),
                  ]),
                  const SizedBox(height: 6),
                  Text('SAR ${controller.fmtAmount(controller.totalIncome.value)}',
                    style: AppTextStyles.amountMedium.copyWith(
                      fontSize: 16, fontWeight: FontWeight.w700,
                      color: cs.onBackground)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.arrow_upward_rounded, size: 12,
                      color: AppColors.categoryShopping),
                    const SizedBox(width: 2),
                    Expanded(child: Text(
                      '${controller.incomeChange.value.toStringAsFixed(1)}% ${'rpt_last_mo'.tr}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11, color: AppColors.categoryShopping),
                      overflow: TextOverflow.ellipsis)),
                  ]),
                ],
              ),
            )),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: RCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(width: 10, height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.categoryFood,
                        shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('rpt_total_expenses'.tr,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 11, letterSpacing: 0.4,
                        color: cs.onBackground.withOpacity(0.50))),
                  ]),
                  const SizedBox(height: 6),
                  Text('SAR ${controller.fmtAmount(controller.totalExpenses.value)}',
                    style: AppTextStyles.amountMedium.copyWith(
                      fontSize: 16, fontWeight: FontWeight.w700,
                      color: AppColors.categoryFood)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.arrow_upward_rounded, size: 12,
                      color: AppColors.categoryFood),
                    const SizedBox(width: 2),
                    Expanded(child: Text(
                      '${controller.expensesChange.value.toStringAsFixed(1)}% ${'rpt_last_mo'.tr}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11, color: AppColors.categoryFood),
                      overflow: TextOverflow.ellipsis)),
                  ]),
                ],
              ),
            )),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Spending Breakdown ───────────────────────────────────────────
        ReportSectionTitle(
          titleKey: 'rpt_spending_breakdown',
          trailing: 'rpt_top5'.tr,
        ),
        const SizedBox(height: AppSpacing.md),

        RCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DonutChart(
                slices: controller.spendingBreakdown,
                centerLabel: 'SAR',
                centerValue: controller.fmtAmount(controller.totalExpenses.value),
                size: 140,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  children: controller.spendingBreakdown.map((s) =>
                    LegendRow(nameKey: s.nameKey, percentage: s.percentage, color: s.color)
                  ).toList(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Income vs Expenses ───────────────────────────────────────────
        ReportSectionTitle(
          titleKey: 'rpt_income_vs_expenses',
          trailing: controller.periodDateLabel,
        ),
        const SizedBox(height: AppSpacing.md),

        RCard(
          child: IncomeVsExpensesChart(points: controller.incomeVsExpenses),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── AI Insight ───────────────────────────────────────────────────
        InsightBanner(
          labelKey: 'rpt_ai_insight',
          messageKey: 'rpt_overview_insight',
          bgColor: isDark
              ? AppColors.primary.withOpacity(0.10)
              : const Color(0xFFFFF3EE),
          iconColor: AppColors.primary,
          icon: Icons.auto_awesome_rounded,
        ),

        const SizedBox(height: AppSpacing.xxl),
        Center(child: const ExportReportButton()),
        const SizedBox(height: AppSpacing.xxl),
      ],
    ));
  }
}
