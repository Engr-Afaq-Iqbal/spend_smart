// lib/features/home/widgets/ai_insight_banner.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class AIInsightBanner extends GetView<HomeController> {
  const AIInsightBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1C1F2E) : Colors.white;
    final subTxt = cs.onBackground.withOpacity(0.55);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('home_ai_insights'.tr,
            style: AppTextStyles.h3.copyWith(fontSize: 16, color: cs.onBackground)),
        const SizedBox(height: AppSpacing.md),
        Obx(() => Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black38 : Colors.black.withOpacity(0.06),
                    blurRadius: 12, offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cs.primary.withOpacity(0.7),
                          cs.primary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const Icon(Icons.auto_awesome_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('home_spendSmart_ai'.tr,
                            style: AppTextStyles.labelLarge.copyWith(
                              fontSize: 13, color: cs.onBackground)),
                        const SizedBox(height: 4),
                        Text(controller.aiInsight.value,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12.5, color: subTxt, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: AppSpacing.md),
        _InsightDots(count: 3, active: 0),
      ],
    );
  }
}

class _InsightDots extends StatelessWidget {
  final int count;
  final int active;
  const _InsightDots({required this.count, required this.active});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final trackCl = isDark ? Colors.white24 : const Color(0xFFE8EAED);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == active ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == active ? primary : trackCl,
              borderRadius: BorderRadius.circular(100),
            ),
          )),
    );
  }
}
