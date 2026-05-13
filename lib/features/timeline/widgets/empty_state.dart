// lib/features/timeline/widgets/empty_state.dart
// Shown when no transactions match the current filter/day selection.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class TimelineEmptyState extends StatelessWidget {
  const TimelineEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 52,
              color: cs.onBackground.withOpacity(0.20),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'timeline_no_transactions'.tr,
              style: AppTextStyles.labelLarge.copyWith(
                color: cs.onBackground.withOpacity(0.45),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'timeline_no_transactions_sub'.tr,
              style: AppTextStyles.bodySmall.copyWith(
                color: cs.onBackground.withOpacity(0.30),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
