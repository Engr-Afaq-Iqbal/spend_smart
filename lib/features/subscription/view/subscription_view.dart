// lib/features/subscription/view/subscription_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// Premium Subscription Plans screen — matches the design exactly:
//
//   HEADER (coral gradient):
//     "✦ Unlock Your Full Potential" chip
//     "Choose Your Plan" title
//     "7-day free trial — no card required" subtitle
//     Monthly ↔ Yearly animated toggle
//
//   BODY (scrollable cards):
//     Free plan card     (grey border, current plan)
//     Pro plan card      (coral border, Most Popular, 7-day CTA)
//     Family plan card   (purple border, 7-day CTA)
//
//   FOOTER:
//     Restore Purchase | Terms | Privacy
//     "Cancel anytime · No hidden fees"
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/subscription_controller.dart';
import '../model/subscription_models.dart';
import '../widgets/billing_toggle.dart';
import '../widgets/plan_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Derive header gradient from primary accent
    final accent      = cs.primary;
    final gradTop     = Color.lerp(accent, Colors.white, 0.10) ?? accent;
    final gradBottom  = Color.lerp(accent, Colors.black, 0.08) ?? accent;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // ── Coral header ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [gradTop, gradBottom],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                  child: Column(
                    children: [
                      // Back arrow row
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded,
                              color: Colors.white, size: 28),
                            onPressed: Get.back,
                            padding: EdgeInsets.zero,
                          ),
                          const Spacer(),
                        ],
                      ),

                      // "Unlock" pill chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.20),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome_rounded,
                              color: Colors.white, size: 13),
                            const SizedBox(width: 6),
                            Text('sub_unlock_potential'.tr,
                              style: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // "Choose Your Plan"
                      Text(
                        'sub_choose_plan'.tr,
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 6),

                      // "7-day free trial"
                      Text(
                        'sub_free_trial'.tr,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // Monthly / Yearly toggle
                      const BillingToggle(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Plan cards ─────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Free card
                const PlanCard(plan: SubscriptionPlans.free),

                // Pro card
                const PlanCard(plan: SubscriptionPlans.pro),

                // Family card
                const PlanCard(plan: SubscriptionPlans.family),

                const SizedBox(height: 8),

                // ── Footer ──────────────────────────────────────────────
                _Footer(),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Footer links + cancel note ────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final subColor = cs.onBackground.withOpacity(0.40);

    return Column(
      children: [
        // Links row
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 0,
          children: [
            _FooterLink('sub_restore'.tr),
            _Dot(color: subColor),
            _FooterLink('sub_terms'.tr),
            _Dot(color: subColor),
            _FooterLink('sub_privacy'.tr),
          ],
        ),

        const SizedBox(height: 8),

        // Cancel anytime note
        Text(
          'sub_cancel_anytime'.tr,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 11,
            color: cs.onBackground.withOpacity(0.30),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.45),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 3, height: 3,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
