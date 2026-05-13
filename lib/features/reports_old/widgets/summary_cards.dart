// lib/features/reports/widgets/summary_cards.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/reports_controller.dart';
import '../model/reports_models.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';

class SummaryCards extends GetView<ReportsController> {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: controller.metrics.asMap().entries.map((e) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: e.key == 0 ? 0 : AppSpacing.sm),
                child: _MetricCard(metric: e.value),
              ),
            );
          }).toList(),
        ));
  }
}

class _MetricCard extends StatelessWidget {
  final SummaryMetric metric;
  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final cs          = Theme.of(context).colorScheme;
    final subTxt      = cs.onBackground.withOpacity(0.50);
    final changeColor = metric.isPositiveChange ? AppColors.success : AppColors.error;
    final sign        = metric.isPositiveChange ? '+' : '';

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // use translation keys
            metric.title == 'Total Spent'
                ? 'reports_total_spent'.tr
                : 'reports_total_income'.tr,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 12, color: subTxt),
          ),
          const SizedBox(height: 6),
          Text('SAR ${_fmt(metric.amount)}',
              style: AppTextStyles.amountMedium.copyWith(
                fontSize: 17, color: cs.onBackground)),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                metric.isPositiveChange
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 13, color: changeColor,
              ),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  '$sign${metric.changePercent.toStringAsFixed(0)}% ${'reports_vs_last_month'.tr}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: changeColor, fontWeight: FontWeight.w600, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    final n = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < n.length; i++) {
      if (i > 0 && (n.length - i) % 3 == 0) buf.write(',');
      buf.write(n[i]);
    }
    return buf.toString();
  }
}
