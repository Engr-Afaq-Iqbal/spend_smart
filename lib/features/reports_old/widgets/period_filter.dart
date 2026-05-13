// lib/features/reports/widgets/period_filter.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/reports_controller.dart';
import '../model/reports_models.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class PeriodFilter extends GetView<ReportsController> {
  const PeriodFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackBg = isDark
        ? Colors.white.withOpacity(0.08)
        : cs.primary.withOpacity(0.10);

    return Obx(() => Container(
          height: 36,
          decoration: BoxDecoration(
            color: trackBg,
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.all(3),
          child: Row(
            children: ReportPeriod.values.map((period) {
              final isActive = controller.selectedPeriod.value == period;
              // Translation key: reports_week / reports_month / reports_quarter / reports_year
              final label = 'reports_${period.name}'.tr;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectPeriod(period),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isActive ? cs.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 12,
                        color: isActive ? Colors.white : cs.primary,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }
}
