// lib/features/home/widgets/recent_transactions_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../model/home_models.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_header.dart';

class RecentTransactionsSection extends GetView<HomeController> {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final divColor = isDark ? Colors.white12 : const Color(0xFFF0F0F5);

    return Column(
      children: [
        SectionHeader(
          title: 'home_recent_transactions'.tr,
          actionLabel: 'home_view_all'.tr,
          onAction: () {},
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: EdgeInsets.zero,
          child: Obx(() => ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.transactions.length,
                separatorBuilder: (_, __) =>
                    Divider(indent: 68, endIndent: 0, height: 1, color: divColor),
                itemBuilder: (_, i) =>
                    _TransactionRow(transaction: controller.transactions[i]),
              )),
        ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final Transaction transaction;
  const _TransactionRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTxt = cs.onBackground.withOpacity(0.50);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: AppSpacing.categoryIconSize,
            height: AppSpacing.categoryIconSize,
            decoration: BoxDecoration(
              color: transaction.color.withOpacity(isDark ? 0.20 : 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(transaction.icon, color: transaction.color, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontSize: 14, color: cs.onBackground)),
                const SizedBox(height: 2),
                Text(transaction.category,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11.5, color: subTxt)),
              ],
            ),
          ),
          Text(
            transaction.isIncome
                ? '+SAR ${transaction.amount.toStringAsFixed(0)}'
                : 'SAR ${transaction.amount.toStringAsFixed(0)}',
            style: transaction.isIncome
                ? AppTextStyles.amountPositive.copyWith(fontSize: 14)
                : AppTextStyles.amountSmall.copyWith(color: cs.onBackground),
          ),
        ],
      ),
    );
  }
}
