// lib/features/reports/widgets/tabs/net_worth_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/reports_controller.dart';
import '../reports_shared.dart';
import '../donut_chart.dart';
import '../line_chart_widget.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';

class NetWorthTab extends GetView<ReportsController> {
  const NetWorthTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const purple = Color(0xFF9C27B0);

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Net Worth total card ─────────────────────────────────────────
        RCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('rpt_net_worth_label'.tr,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5,
                  color: cs.onBackground.withOpacity(0.50))),
              const SizedBox(height: 8),
              Text('SAR ${controller.fmtAmount(controller.netWorth.value)}',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 32, fontWeight: FontWeight.w700, color: purple)),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.arrow_upward_rounded, size: 14, color: AppColors.categoryShopping),
                const SizedBox(width: 3),
                Text('${controller.netWorthChange.value.toStringAsFixed(1)}% ${'rpt_vs_last_3months'.tr}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12, color: AppColors.categoryShopping)),
              ]),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Net Worth Trend line chart ────────────────────────────────────
        ReportSectionTitle(
          titleKey: 'rpt_net_worth_trend',
          trailing: 'rpt_last_3months'.tr,
        ),
        const SizedBox(height: AppSpacing.md),

        RCard(
          child: NetWorthTrendChart(points: controller.netWorthTrend),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Assets / Liabilities / Net Worth mini cards ──────────────────
        Row(
          children: [
            Expanded(child: _MiniStatCard(
              label: 'rpt_assets'.tr,
              value: '${_fmtK(controller.assets.value)}k',
              color: AppColors.categoryShopping,
              isDark: isDark,
            )),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _MiniStatCard(
              label: 'rpt_liabilities'.tr,
              value: '${_fmtK(controller.liabilities.value)}k',
              color: AppColors.categoryFood,
              isDark: isDark,
            )),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _MiniStatCard(
              label: 'rpt_net_worth_label'.tr,
              value: '${_fmtK(controller.netWorth.value)}k',
              color: purple,
              isDark: isDark,
            )),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Assets vs Liabilities half-donut ─────────────────────────────
        const ReportSectionTitle(titleKey: 'rpt_assets_vs_liabilities'),
        const SizedBox(height: AppSpacing.md),

        RCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HalfDonutGauge(
                assets: controller.assets.value,
                liabilities: controller.liabilities.value,
                netWorth: controller.netWorth.value,
                size: 180,
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AssetLiabilityLegendRow(
                      label: 'rpt_assets'.tr,
                      subLabel: 'SAR ${controller.fmtAmount(controller.assets.value)}',
                      percent: '77.1%',
                      color: AppColors.categoryShopping,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _AssetLiabilityLegendRow(
                      label: 'rpt_liabilities'.tr,
                      subLabel: 'SAR ${controller.fmtAmount(controller.liabilities.value)}',
                      percent: '22.9%',
                      color: AppColors.categoryFood,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Net Worth History ─────────────────────────────────────────────
        const ReportSectionTitle(titleKey: 'rpt_net_worth_history'),
        const SizedBox(height: AppSpacing.md),

        RCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: controller.netWorthHistory.asMap().entries.map((e) {
              final idx   = e.key;
              final entry = e.value;
              final isLast = idx == controller.netWorthHistory.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: 14),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.labelKey.tr,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 13, color: cs.onBackground)),
                            const SizedBox(height: 2),
                            Text(entry.dateKey,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 11,
                                color: cs.onBackground.withOpacity(0.45))),
                          ],
                        ),
                        const Spacer(),
                        Text('SAR ${controller.fmtAmount(entry.amount)}',
                          style: AppTextStyles.amountSmall.copyWith(
                            fontSize: 14,
                            color: entry.isCurrent ? AppColors.categoryShopping : cs.onBackground,
                            fontWeight: entry.isCurrent ? FontWeight.w700 : FontWeight.w500)),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(height: 1, indent: AppSpacing.lg,
                      color: cs.onBackground.withOpacity(0.06)),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── AI Insight ───────────────────────────────────────────────────
        InsightBanner(
          labelKey: 'rpt_ai_insight',
          messageKey: 'rpt_networth_insight',
          bgColor: isDark
              ? purple.withOpacity(0.10)
              : const Color(0xFFF5F3FF),
          iconColor: purple,
          icon: Icons.auto_awesome_rounded,
        ),

        const SizedBox(height: AppSpacing.xxl),
        Center(child: const ExportReportButton()),
        const SizedBox(height: AppSpacing.xxl),
      ],
    ));
  }

  static String _fmtK(double v) => (v / 1000).toStringAsFixed(1);
}

// ── Mini stat card ────────────────────────────────────────────────────────────
class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;
  const _MiniStatCard({required this.label, required this.value,
    required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ??
            (isDark ? AppColors.darkSurface : AppColors.surfaceCard),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: isDark ? null : [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(height: 6),
          Text(value,
            style: AppTextStyles.amountSmall.copyWith(
              fontSize: 14, fontWeight: FontWeight.w700, color: cs.onBackground)),
          const SizedBox(height: 2),
          Text(label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10, color: cs.onBackground.withOpacity(0.45))),
        ],
      ),
    );
  }
}

// ── Assets/Liabilities legend row ────────────────────────────────────────────
class _AssetLiabilityLegendRow extends StatelessWidget {
  final String label;
  final String subLabel;
  final String percent;
  final Color color;
  const _AssetLiabilityLegendRow({
    required this.label, required this.subLabel,
    required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 10, height: 10,
          margin: const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodySmall.copyWith(
                fontSize: 12, color: cs.onBackground.withOpacity(0.55))),
              Text(subLabel, style: AppTextStyles.labelSmall.copyWith(
                fontSize: 11, color: cs.onBackground.withOpacity(0.40))),
            ],
          ),
        ),
        Text(percent, style: AppTextStyles.labelMedium.copyWith(
          fontSize: 13, fontWeight: FontWeight.w700, color: cs.onBackground)),
      ],
    );
  }
}
