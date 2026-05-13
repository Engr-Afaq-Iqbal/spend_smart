// lib/features/timeline/widgets/transaction_tile.dart
// ─────────────────────────────────────────────────────────────────────────────
// Single transaction row — icon pill, title, category label, amount.
// Matches design: icon in rounded square, amount right-aligned in accent/red.
// Theme-aware: card bg, text, icon opacity adapt to light/dark.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/timeline_models.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class TransactionTile extends StatelessWidget {
  final TimelineTransaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final cs       = Theme.of(context).colorScheme;
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final cardBg   = Theme.of(context).cardTheme.color ?? cs.surface;
    final subColor = cs.onBackground.withOpacity(0.50);

    // Income is green, expenses are accent (coral/user-chosen)
    final amountColor = transaction.isIncome
        ? const Color(0xFF34C759)
        : cs.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.20)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Category icon pill ──────────────────────────────────────
          Container(
            width: AppSpacing.categoryIconSize,
            height: AppSpacing.categoryIconSize,
            decoration: BoxDecoration(
              color: transaction.category.color
                  .withOpacity(isDark ? 0.20 : 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              transaction.category.icon,
              color: transaction.category.color,
              size: 18,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // ── Title + category ────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontSize: 14,
                    color: cs.onBackground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.category.labelKey.tr,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    color: subColor,
                  ),
                ),
              ],
            ),
          ),

          // ── Amount ──────────────────────────────────────────────────
          Text(
            transaction.displayAmount,
            style: AppTextStyles.amountSmall.copyWith(
              fontSize: 14,
              color: amountColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
