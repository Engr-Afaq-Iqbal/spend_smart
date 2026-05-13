// lib/features/home/widgets/savings_goal_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../model/home_models.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_header.dart';

class SavingsGoalSection extends GetView<HomeController> {
  const SavingsGoalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: 'home_savings_goal'.tr),
        const SizedBox(height: AppSpacing.md),
        Obx(() => Column(
              children: controller.savingsGoals
                  .map((goal) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _GoalCard(goal: goal),
                      ))
                  .toList(),
            )),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final SavingsGoal goal;
  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTxt = cs.onBackground.withOpacity(0.50);
    final trackCl = isDark ? Colors.white12 : const Color(0xFFE8EAED);

    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(goal.name,
                    style: AppTextStyles.labelLarge.copyWith(color: cs.onBackground)),
              ),
              _PercentageChip(percent: (goal.progress * 100).round()),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'SAR ${_fmt(goal.current)} ${'home_of'.tr} SAR ${_fmt(goal.target)}',
              style: AppTextStyles.bodySmall.copyWith(fontSize: 12, color: subTxt),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: goal.progress, minHeight: 8,
              backgroundColor: trackCl,
              valueColor: AlwaysStoppedAnimation(goal.color),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'SAR ${_fmt(goal.remaining)} ${'home_remaining'.tr} · ${goal.deadline}',
              style: AppTextStyles.bodySmall.copyWith(fontSize: 11.5, color: subTxt),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000) return '${(v ~/ 1000)},${(v % 1000).toInt().toString().padLeft(3, '0')}';
    return v.toStringAsFixed(0);
  }
}

class _PercentageChip extends StatelessWidget {
  final int percent;
  const _PercentageChip({required this.percent});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: primary.withOpacity(isDark ? 0.20 : 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text('$percent%',
          style: AppTextStyles.labelSmall.copyWith(
            color: primary, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}
