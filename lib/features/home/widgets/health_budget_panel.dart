// lib/features/home/widgets/health_budget_panel.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import 'health_score_ring.dart';

class HealthBudgetPanel extends GetView<HomeController> {
  const HealthBudgetPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final cs       = Theme.of(context).colorScheme;
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final divColor = isDark ? Colors.white12 : const Color(0xFFF0F0F5);
    final subColor = cs.onBackground.withOpacity(0.45);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Obx(() => Row(
            children: [
              Expanded(
                child: HealthScoreRing(
                  score: controller.healthScore.value,
                  label: 'home_very_good'.tr,
                  size: 110,
                ),
              ),
              Container(
                width: 1, height: 100,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                color: divColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('home_monthly_budget'.tr,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontSize: 11, color: subColor)),
                    const SizedBox(height: 4),
                    Text(
                      'SAR ${_format(controller.monthlyBudget.value)}',
                      style: AppTextStyles.amountMedium.copyWith(
                        fontSize: 18, color: cs.onBackground),
                    ),
                    Text(
                      '${'home_of'.tr} SAR ${_format(controller.totalIncome.value)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11, color: subColor),
                    ),
                    const SizedBox(height: 10),
                    _BudgetBar(percent: controller.budgetUsedPercent.value),
                    const SizedBox(height: 8),
                    ...controller.budgetCategories.map(
                      (cat) => _CategoryLegendItem(
                        label: cat.name,
                        percent: '${(cat.percentage * 100).round()}%',
                        color: cat.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  String _format(double v) => v >= 1000
      ? '${(v / 1000).toStringAsFixed(v % 1000 == 0 ? 0 : 1)},${(v % 1000).toStringAsFixed(0).padLeft(3, '0')}'
      : v.toStringAsFixed(0);
}

class _BudgetBar extends StatelessWidget {
  final double percent;
  const _BudgetBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: percent,
        minHeight: 6,
        backgroundColor: isDark ? Colors.white12 : const Color(0xFFE8EAED),
        valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _CategoryLegendItem extends StatelessWidget {
  final String label;
  final String percent;
  final Color color;
  const _CategoryLegendItem({required this.label, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    final onBg = Theme.of(context).colorScheme.onBackground;
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Container(width: 8, height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 11, color: onBg.withOpacity(0.6))),
          ),
          Text(percent,
              style: AppTextStyles.labelSmall.copyWith(
                color: onBg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
