// lib/features/subscription/controller/subscription_controller.dart
// ─────────────────────────────────────────────────────────────────────────────
// GetX controller for the Subscription Plans screen.
//
// Responsibilities:
//   • Billing period toggle (Monthly ↔ Yearly)
//   • Plan selection state
//   • Mock upgrade/subscribe flow
//   • Global premium status (read by TransactionController AI features)
//
// Registered as permanent=true in AppBindings so isPremium survives
// navigation and is accessible anywhere in the app.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/subscription_models.dart';
import '../../../core/constants/app_colors.dart';

class SubscriptionController extends GetxController {
  // ── Billing period ─────────────────────────────────────────────────────────
  final Rx<BillingPeriod> billingPeriod = BillingPeriod.monthly.obs;
  bool get isYearly => billingPeriod.value == BillingPeriod.yearly;

  void toggleBilling() {
    billingPeriod.value = isYearly
        ? BillingPeriod.monthly
        : BillingPeriod.yearly;
  }

  // ── Selected plan ──────────────────────────────────────────────────────────
  // Starts on Free (the active plan for non-premium users)
  final Rx<PlanType> selectedPlan = PlanType.free.obs;

  void selectPlan(PlanType plan) => selectedPlan.value = plan;

  bool isSelected(PlanType plan) => selectedPlan.value == plan;

  // ── Subscription state ─────────────────────────────────────────────────────
  final Rx<PlanType> activePlan = PlanType.free.obs;
  bool get isPremium => activePlan.value != PlanType.free;

  // ── Loading (subscribe flow) ───────────────────────────────────────────────
  final RxBool isProcessing = false.obs;

  // ── Subscribe action ───────────────────────────────────────────────────────
  Future<void> subscribe(PlanType plan) async {
    if (plan == PlanType.free) return; // already on free
    if (isProcessing.value) return;

    isProcessing.value = true;

    // Simulate network call to payment gateway
    await Future.delayed(const Duration(seconds: 2));

    // Mock success
    activePlan.value = plan;
    selectedPlan.value = plan;
    isProcessing.value = false;

    // Notify AI feature controllers about premium status
    _notifyPremiumStatus(true);

    Get.back(); // close plans screen
    Get.snackbar(
      'sub_success_title'.tr,
      'sub_success_body'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_rounded, color: AppColors.white),
    );
  }

  /// Propagates premium status to any active TransactionController
  void _notifyPremiumStatus(bool premium) {
    try {
      // TransactionController is route-scoped; may or may not exist
      // We use a global RxBool instead so TransactionController reads it
      PremiumStatus.isPremium.value = premium;
    } catch (_) {}
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  String priceDisplay(PlanDefinition plan) {
    if (plan.monthlyPrice == 0) return plan.nameKey.tr;
    return 'SAR ${plan.price(billingPeriod.value)}';
  }

  String periodSuffix() {
    return isYearly ? 'sub_per_year'.tr : 'sub_per_month'.tr;
  }

  String? originalPriceStr(PlanDefinition plan) {
    if (!isYearly || plan.yearlyOriginal == 0) return null;
    final orig = plan.yearlyOriginal;
    return 'SAR ${orig == orig.truncate() ? orig.toStringAsFixed(0) : orig.toStringAsFixed(2)}';
  }

  /// Button label for a given plan card
  String buttonLabel(PlanDefinition plan) {
    if (activePlan.value == plan.type) return 'sub_current_plan'.tr;
    if (plan.type == PlanType.free) return 'sub_current_plan'.tr;
    return plan.ctaKey.tr;
  }

  bool isCurrentPlan(PlanType plan) => activePlan.value == plan;
}

// ── Global premium status observable ─────────────────────────────────────────
// Lives outside the controller so it persists even when SubscriptionController
// is not registered (e.g. on screens opened before plans are viewed).
class PremiumStatus {
  static final RxBool isPremium = false.obs;
}
