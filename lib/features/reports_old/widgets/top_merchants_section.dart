// lib/features/reports/widgets/top_merchants_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/reports_controller.dart';
import '../model/reports_models.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_header.dart';

class TopMerchantsSection extends GetView<ReportsController> {
  const TopMerchantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final divColor = isDark ? Colors.white12 : const Color(0xFFF0F0F5);

    return Column(
      children: [
        SectionHeader(title: 'reports_top_merchants'.tr),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: EdgeInsets.zero,
          child: Obx(() {
            final merchants = controller.merchants;
            final maxAmt    = merchants.isEmpty ? 1.0
                : merchants.map((m) => m.amount).reduce((a, b) => a > b ? a : b);
            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: merchants.length,
              separatorBuilder: (_, __) =>
                  Divider(indent: 68, endIndent: 0, height: 1, color: divColor),
              itemBuilder: (_, i) =>
                  _MerchantRow(merchant: merchants[i], maxAmount: maxAmt),
            );
          }),
        ),
      ],
    );
  }
}

class _MerchantRow extends StatelessWidget {
  final MerchantSpend merchant;
  final double maxAmount;
  const _MerchantRow({required this.merchant, required this.maxAmount});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ratio  = merchant.amount / maxAmount;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.categoryIconSize,
                height: AppSpacing.categoryIconSize,
                decoration: BoxDecoration(
                  color: merchant.color.withOpacity(isDark ? 0.20 : 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(merchant.icon, color: merchant.color, size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(merchant.name,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontSize: 14, color: cs.onBackground)),
              ),
              Text('SAR ${_fmt(merchant.amount)}',
                  style: AppTextStyles.amountSmall.copyWith(color: cs.onBackground)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: ratio, minHeight: 5,
              backgroundColor: isDark ? Colors.white12 : const Color(0xFFE8EAED),
              valueColor: AlwaysStoppedAnimation(merchant.color),
            ),
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
