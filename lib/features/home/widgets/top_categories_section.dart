// lib/features/home/widgets/top_categories_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../model/home_models.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_header.dart';

class TopCategoriesSection extends GetView<HomeController> {
  const TopCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'home_top_categories'.tr,
          actionLabel: 'home_view_all'.tr,
          onAction: () {},
        ),
        const SizedBox(height: AppSpacing.md),
        Obx(() => Column(
              children: controller.categories
                  .map((cat) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _CategoryCard(category: cat),
                      ))
                  .toList(),
            )),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategorySpend category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onBg   = Theme.of(context).colorScheme.onBackground;
    return AppCard(
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
                  color: category.color.withOpacity(isDark ? 0.20 : 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(category.icon, color: category.color, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(category.name,
                    style: AppTextStyles.labelLarge.copyWith(color: onBg)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('SAR ${category.amount.toStringAsFixed(0)}',
                      style: AppTextStyles.amountSmall.copyWith(color: onBg)),
                  Text('${(category.percentage * 100).round()}%',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: category.color, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: category.percentage,
              minHeight: 5,
              backgroundColor: isDark ? Colors.white12 : const Color(0xFFE8EAED),
              valueColor: AlwaysStoppedAnimation(category.color),
            ),
          ),
        ],
      ),
    );
  }
}
