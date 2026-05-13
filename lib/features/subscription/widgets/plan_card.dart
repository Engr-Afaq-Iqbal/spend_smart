// lib/features/subscription/widgets/plan_card.dart
// ─────────────────────────────────────────────────────────────────────────────
// Reusable plan pricing card. Used for Free, Pro, and Family.
//
// Visual states:
//   • Default      → white/dark card, grey border
//   • Selected     → accent-colored border + subtle gradient background
//   • Current plan → checkmark badge in top-right corner
//   • Most popular → coral "Most Popular" banner in top-right
//
// All colors read from theme — zero hardcoded values except brand accents.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/subscription_controller.dart';
import '../model/subscription_models.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class PlanCard extends StatefulWidget {
  final PlanDefinition plan;
  const PlanCard({super.key, required this.plan});

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween(begin: 1.0, end: 0.975)
        .animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl   = Get.find<SubscriptionController>();
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isSelected   = ctrl.isSelected(widget.plan.type);
      final isCurrent    = ctrl.isCurrentPlan(widget.plan.type);
      final accent       = widget.plan.accentColor;
      final cardBg       = isDark ? AppColors.darkSurface : AppColors.surfaceCard;
      final selectedBg   = isDark
          ? Color.lerp(AppColors.darkSurface, accent, 0.08)!
          : Color.lerp(AppColors.white, accent, 0.04)!;

      return GestureDetector(
        onTapDown: (_) => _scaleCtrl.forward(),
        onTapUp: (_) {
          _scaleCtrl.reverse();
          HapticFeedback.lightImpact();
          ctrl.selectPlan(widget.plan.type);
        },
        onTapCancel: () => _scaleCtrl.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (_, child) => Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? selectedBg : cardBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: Border.all(
                color: isSelected ? accent : cs.onBackground.withOpacity(0.10),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(
                      color: accent.withOpacity(0.20),
                      blurRadius: 20,
                      offset: const Offset(0, 6))]
                  : isDark ? null : [BoxShadow(
                      color: AppColors.shadow, blurRadius: 10,
                      offset: const Offset(0, 2))],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Plan header ────────────────────────────────────
                      _PlanHeader(
                        plan: widget.plan,
                        isSelected: isSelected,
                        isCurrent: isCurrent,
                        isDark: isDark,
                        ctrl: ctrl,
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // ── Price row ──────────────────────────────────────
                      if (widget.plan.type != PlanType.free)
                        _PriceRow(plan: widget.plan, ctrl: ctrl, isDark: isDark),

                      if (widget.plan.type == PlanType.free)
                        Text(
                          'sub_free_price'.tr,
                          style: AppTextStyles.h2.copyWith(
                            fontSize: 28,
                            color: cs.onBackground,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                      const SizedBox(height: AppSpacing.lg),

                      // ── Feature list ───────────────────────────────────
                      ...widget.plan.features.map((feat) =>
                          _FeatureRow(
                            feat: feat,
                            accentColor: accent,
                            isDark: isDark,
                          )),

                      const SizedBox(height: AppSpacing.lg),

                      // ── CTA button ─────────────────────────────────────
                      _CtaButton(
                        plan: widget.plan,
                        isSelected: isSelected,
                        isCurrent: isCurrent,
                        accent: accent,
                        ctrl: ctrl,
                      ),
                    ],
                  ),
                ),

                // ── Most Popular badge ─────────────────────────────────
                if (widget.plan.isMostPopular)
                  Positioned(
                    top: 0, right: 0,
                    child: _MostPopularBadge(),
                  ),

                // ── Selected checkmark (top-right, hidden if mostPopular) ──
                if (isSelected && !widget.plan.isMostPopular)
                  Positioned(
                    top: AppSpacing.md,
                    right: AppSpacing.md,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),

                if (isSelected && widget.plan.isMostPopular)
                  Positioned(
                    top: AppSpacing.md + 4,
                    right: AppSpacing.md + 4,
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// ── Plan header (dot + name + grey chevron for free) ─────────────────────────
class _PlanHeader extends StatelessWidget {
  final PlanDefinition plan;
  final bool isSelected;
  final bool isCurrent;
  final bool isDark;
  final SubscriptionController ctrl;

  const _PlanHeader({
    required this.plan, required this.isSelected,
    required this.isCurrent, required this.isDark, required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(
            color: plan.accentColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          plan.nameKey.tr,
          style: AppTextStyles.labelLarge.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: cs.onBackground.withOpacity(0.65),
          ),
        ),
        const Spacer(),
        if (plan.type == PlanType.free && !isSelected)
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: isDark ? Colors.white12 : AppColors.progressTrack,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.keyboard_arrow_down_rounded,
              color: cs.onBackground.withOpacity(0.40), size: 18),
          ),
      ],
    );
  }
}

// ── Price row with original crossed-out price for yearly ─────────────────────
class _PriceRow extends StatelessWidget {
  final PlanDefinition plan;
  final SubscriptionController ctrl;
  final bool isDark;
  const _PriceRow({required this.plan, required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(() {
      final isYearly  = ctrl.isYearly;
      final origStr   = ctrl.originalPriceStr(plan);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('SAR ', style: AppTextStyles.bodySmall.copyWith(
                fontSize: 14, color: cs.onBackground.withOpacity(0.70))),
              Text(
                plan.price(ctrl.billingPeriod.value),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1.0,
                ),
              ),
              Flexible(
                child: Text(
                  isYearly ? 'sub_per_year'.tr : 'sub_per_month'.tr,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 13, color: cs.onBackground.withOpacity(0.50)),
                ),
              ),
            ],
          ),
          // Yearly savings line
          if (isYearly && origStr != null) ...[
            const SizedBox(height: 3),
            Row(
              children: [
                Text(
                  '$origStr → ',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    color: cs.onBackground.withOpacity(0.35),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  'SAR ${plan.price(ctrl.billingPeriod.value)}${isYearly ? '/yr' : ''}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12, color: AppColors.success,
                    fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ],
      );
    });
  }
}

// ── Feature row with check or X icon ──────────────────────────────────────────
class _FeatureRow extends StatelessWidget {
  final PlanFeature feat;
  final Color accentColor;
  final bool isDark;
  const _FeatureRow({required this.feat, required this.accentColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        children: [
          // Check / X icon
          Icon(
            feat.included ? Icons.check_rounded : Icons.close_rounded,
            size: 16,
            color: feat.included
                ? accentColor
                : cs.onBackground.withOpacity(isDark ? 0.25 : 0.30),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              feat.labelKey.tr,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 13,
                fontWeight: feat.isHighlighted
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: feat.included
                    ? cs.onBackground.withOpacity(0.80)
                    : cs.onBackground.withOpacity(isDark ? 0.25 : 0.35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── CTA Button ────────────────────────────────────────────────────────────────
class _CtaButton extends StatelessWidget {
  final PlanDefinition plan;
  final bool isSelected;
  final bool isCurrent;
  final Color accent;
  final SubscriptionController ctrl;

  const _CtaButton({
    required this.plan, required this.isSelected,
    required this.isCurrent, required this.accent, required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFree = plan.type == PlanType.free;

    return Obx(() {
      final isProcessing = ctrl.isProcessing.value &&
          ctrl.selectedPlan.value == plan.type;

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isFree || isCurrent
              ? null
              : () => ctrl.subscribe(plan.type),
          style: ElevatedButton.styleFrom(
            backgroundColor: isFree || isCurrent
                ? (isDark ? Colors.white10 : AppColors.progressTrack)
                : accent,
            foregroundColor: isFree || isCurrent
                ? (isDark
                    ? Colors.white38
                    : AppColors.textSecondary)
                : Colors.white,
            disabledBackgroundColor: isDark ? Colors.white10 : AppColors.progressTrack,
            disabledForegroundColor: isDark ? Colors.white38 : AppColors.textSecondary,
            minimumSize: const Size.fromHeight(46),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: isProcessing
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : Text(
                  ctrl.buttonLabel(plan),
                  style: AppTextStyles.labelLarge.copyWith(
                    fontSize: 14,
                    color: isFree || isCurrent
                        ? (isDark ? Colors.white38 : AppColors.textSecondary)
                        : Colors.white,
                  ),
                ),
        ),
      );
    });
  }
}

// ── Most Popular badge ────────────────────────────────────────────────────────
class _MostPopularBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppSpacing.radiusXl),
          bottomLeft: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Text(
        'sub_most_popular'.tr,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
