// lib/features/reports/widgets/reports_shared.dart
// ─────────────────────────────────────────────────────────────────────────────
// Shared primitive widgets reused across all 4 report tabs.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/reports_controller.dart';
import '../model/reports_models.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_colors.dart';

// ── Tab bar (Overview | Income | Expenses | Net Worth) ────────────────────────
class ReportsTabBar extends GetView<ReportsController> {
  const ReportsTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs    = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ReportsTab.values.map((tab) {
          final isActive = controller.activeTab.value == tab;
          return GestureDetector(
            onTap: () => controller.setTab(tab),
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tab.labelKey.tr,
                    style: AppTextStyles.labelMedium.copyWith(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? cs.primary
                          : cs.onBackground.withOpacity(0.45),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 2,
                    width: isActive ? 24 : 0,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ));
  }
}

// ── Period chip row (7D | 1M | 3M | 6M | 1Y | calendar) ─────────────────────
class PeriodChips extends GetView<ReportsController> {
  const PeriodChips({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() => Row(
      children: [
        ...ReportPeriod.values.map((p) {
          final isActive = controller.activePeriod.value == p;
          return GestureDetector(
            onTap: () => controller.setPeriod(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isActive ? cs.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                p.labelKey.tr,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? Colors.white
                      : cs.onBackground.withOpacity(0.45),
                ),
              ),
            ),
          );
        }),
        const Spacer(),
        Icon(Icons.calendar_today_outlined,
          size: 18, color: cs.onBackground.withOpacity(0.40)),
      ],
    ));
  }
}

// ── Section title row ─────────────────────────────────────────────────────────
class ReportSectionTitle extends StatelessWidget {
  final String titleKey;
  final String? trailing;
  const ReportSectionTitle({super.key, required this.titleKey, this.trailing});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titleKey.tr,
          style: AppTextStyles.labelLarge.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: cs.onBackground,
          )),
        if (trailing != null)
          Text(trailing!,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
              color: cs.onBackground.withOpacity(0.45),
            )),
      ],
    );
  }
}

// ── White/dark card wrapper ───────────────────────────────────────────────────
class RCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const RCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ??
            (isDark ? AppColors.darkSurface : AppColors.surfaceCard),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: isDark ? null : [
          BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

// ── Donut chart legend row ────────────────────────────────────────────────────
class LegendRow extends StatelessWidget {
  final String nameKey;
  final double percentage;
  final Color color;
  const LegendRow({super.key, required this.nameKey, required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(nameKey.tr,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 12, color: cs.onBackground.withOpacity(0.75)))),
          Text('${percentage.toStringAsFixed(0)}%',
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 12, fontWeight: FontWeight.w600, color: cs.onBackground)),
        ],
      ),
    );
  }
}

// ── AI Insight / On Track / Heads Up banner ───────────────────────────────────
class InsightBanner extends StatelessWidget {
  final String labelKey;
  final String messageKey;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;

  const InsightBanner({
    super.key,
    required this.labelKey,
    required this.messageKey,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(labelKey.tr,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: iconColor,
                    letterSpacing: 0.5,
                  )),
                const SizedBox(height: 3),
                Text(messageKey.tr,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12.5,
                    color: cs.onBackground.withOpacity(0.75),
                    height: 1.4,
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Export Report floating button ─────────────────────────────────────────────
class ExportReportButton extends GetView<ReportsController> {
  const ExportReportButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => controller.showExportSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
          color: cs.onBackground,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          boxShadow: [
            BoxShadow(color: cs.onBackground.withOpacity(0.25),
              blurRadius: 14, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.upload_rounded, color: cs.surface, size: 18),
            const SizedBox(width: 8),
            Text('rpt_export_report'.tr,
              style: AppTextStyles.labelLarge.copyWith(
                color: cs.surface, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
