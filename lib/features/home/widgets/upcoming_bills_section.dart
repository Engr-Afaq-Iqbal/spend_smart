// lib/features/home/widgets/upcoming_bills_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../model/home_models.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';

class UpcomingBillsSection extends GetView<HomeController> {
  const UpcomingBillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: 'home_upcoming_bills'.tr),
        const SizedBox(height: AppSpacing.md),
        Obx(() => Row(
              children: controller.upcomingBills.asMap().entries.map((e) =>
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: e.key == 0 ? 0 : AppSpacing.sm),
                    child: _BillCard(bill: e.value),
                  ),
                )).toList(),
            )),
      ],
    );
  }
}

class _BillCard extends StatelessWidget {
  final UpcomingBill bill;
  const _BillCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1C1F2E) : Colors.white;
    final subTxt = cs.onBackground.withOpacity(0.50);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withOpacity(0.06),
            blurRadius: 8, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(bill.name,
              style: AppTextStyles.labelMedium.copyWith(
                color: cs.onBackground, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: AppSpacing.sm),
          Text('${bill.daysLeft}',
              style: AppTextStyles.amountLarge.copyWith(
                fontSize: 28, color: cs.primary)),
          Text('home_days'.tr,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: subTxt)),
          const SizedBox(height: AppSpacing.sm),
          Text('SAR ${bill.amount.toStringAsFixed(0)}',
              style: AppTextStyles.labelMedium.copyWith(
                fontSize: 12, color: subTxt)),
        ],
      ),
    );
  }
}
