// lib/features/reports/widgets/tabs/income_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/reports_controller.dart';
import '../reports_shared.dart';
import '../donut_chart.dart';
import '../bar_chart_widget.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';

class IncomeTab extends GetView<ReportsController> {
  const IncomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Total Income card ────────────────────────────────────────────
        RCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('rpt_total_income_tab'.tr,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5,
                  color: cs.onBackground.withOpacity(0.50))),
              const SizedBox(height: 8),
              Text('SAR ${controller.fmtAmount(controller.totalIncome.value)}',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 32, fontWeight: FontWeight.w700,
                  color: AppColors.categoryShopping)),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.arrow_upward_rounded, size: 14,
                  color: AppColors.categoryShopping),
                const SizedBox(width: 3),
                Text('${controller.incomeChange.value.toStringAsFixed(1)}% ${'rpt_vs_last_month'.tr}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12, color: AppColors.categoryShopping)),
              ]),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Daily Income bar chart ───────────────────────────────────────
        ReportSectionTitle(
          titleKey: 'rpt_daily_income',
          trailing: '1 – 31 ${'rpt_may_2026'.tr}',
        ),
        const SizedBox(height: AppSpacing.md),

        RCard(
          child: DailyBarChart(
            points: controller.dailyIncome,
            barColor: AppColors.categoryShopping,
            dateRange: '1 – 31 May',
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Income Breakdown donut ───────────────────────────────────────
        ReportSectionTitle(
          titleKey: 'rpt_income_breakdown',
          trailing: 'rpt_by_source'.tr,
        ),
        const SizedBox(height: AppSpacing.md),

        RCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DonutChart(
                slices: controller.incomeBreakdown,
                centerLabel: 'SAR',
                centerValue: controller.fmtAmount(controller.totalIncome.value),
                size: 140,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  children: controller.incomeBreakdown.map((s) =>
                    LegendRow(nameKey: s.nameKey, percentage: s.percentage, color: s.color)
                  ).toList(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Income Sources list ──────────────────────────────────────────
        const ReportSectionTitle(titleKey: 'rpt_income_sources'),
        const SizedBox(height: AppSpacing.md),

        RCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: controller.incomeSources.asMap().entries.map((e) {
              final idx = e.key;
              final src = e.value;
              final isLast = idx == controller.incomeSources.length - 1;
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
                            color: src.color, shape: BoxShape.circle)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(src.nameKey.tr,
                                style: AppTextStyles.labelLarge.copyWith(
                                  fontSize: 14, color: cs.onBackground)),
                              Text(src.subtitleKey.tr,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 11.5,
                                  color: cs.onBackground.withOpacity(0.45))),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(controller.fmtAmount(src.amount),
                              style: AppTextStyles.amountSmall.copyWith(
                                fontSize: 14, color: cs.onBackground,
                                fontWeight: FontWeight.w700)),
                            Text('${src.percentage.toStringAsFixed(1)}%',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 11, color: cs.onBackground.withOpacity(0.45))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Progress bar
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.lg + 22,
                      right: AppSpacing.lg,
                      bottom: isLast ? 0 : AppSpacing.sm,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: src.percentage / 100,
                        minHeight: 4,
                        backgroundColor: isDark ? Colors.white12 : const Color(0xFFE8EAED),
                        valueColor: AlwaysStoppedAnimation(src.color),
                      ),
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

        // ── On Track insight ─────────────────────────────────────────────
        InsightBanner(
          labelKey: 'rpt_on_track',
          messageKey: 'rpt_income_insight',
          bgColor: isDark
              ? AppColors.categoryShopping.withOpacity(0.10)
              : const Color(0xFFF0FDF4),
          iconColor: AppColors.categoryShopping,
          icon: Icons.check_circle_outline_rounded,
        ),

        const SizedBox(height: AppSpacing.xxl),
        Center(child: const ExportReportButton()),
        const SizedBox(height: AppSpacing.xxl),
      ],
    ));
  }
}
