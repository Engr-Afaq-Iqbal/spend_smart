// lib/features/subscription/model/subscription_models.dart
// ─────────────────────────────────────────────────────────────────────────────
// Pure data models for the subscription/plans screen.
// No Flutter/GetX imports — fully unit-testable.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// ── Plan type ─────────────────────────────────────────────────────────────────
enum PlanType { free, pro, family }

// ── Billing period ────────────────────────────────────────────────────────────
enum BillingPeriod { monthly, yearly }

// ── Feature availability ──────────────────────────────────────────────────────
class PlanFeature {
  final String labelKey;
  final bool included;
  final bool isHighlighted; // bold highlight (e.g. AI scan 2/month)

  const PlanFeature({
    required this.labelKey,
    required this.included,
    this.isHighlighted = false,
  });
}

// ── Plan definition ───────────────────────────────────────────────────────────
class PlanDefinition {
  final PlanType type;
  final String nameKey;
  final double monthlyPrice;    // 0 = free
  final double yearlyPrice;     // 0 = free
  final double yearlyOriginal;  // crossed-out original price
  final Color accentColor;
  final Color? gradientEnd;     // for selected card gradient
  final bool isMostPopular;
  final List<PlanFeature> features;
  final String ctaKey;          // button label key

  const PlanDefinition({
    required this.type,
    required this.nameKey,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.yearlyOriginal,
    required this.accentColor,
    this.gradientEnd,
    this.isMostPopular = false,
    required this.features,
    required this.ctaKey,
  });

  /// Formatted price string without currency
  String price(BillingPeriod period) {
    if (monthlyPrice == 0) return '0';
    final v = period == BillingPeriod.monthly ? monthlyPrice : yearlyPrice;
    return v == v.truncate() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
  }

  String get periodKey => '/mo'; // overridden in view based on period
}

// ─────────────────────────────────────────────────────────────────────────────
// Static plan catalogue — swap prices from remote config without touching UI
// ─────────────────────────────────────────────────────────────────────────────
class SubscriptionPlans {
  static const List<PlanDefinition> all = [free, pro, family];

  static const PlanDefinition free = PlanDefinition(
    type: PlanType.free,
    nameKey: 'sub_free',
    monthlyPrice: 0,
    yearlyPrice: 0,
    yearlyOriginal: 0,
    accentColor: AppColors.textTertiary,
    ctaKey: 'sub_current_plan',
    features: [
      PlanFeature(labelKey: 'sub_feat_manual',     included: true),
      PlanFeature(labelKey: 'sub_feat_5cat',        included: true),
      PlanFeature(labelKey: 'sub_feat_basic_charts',included: true),
      PlanFeature(labelKey: 'sub_feat_ai_scan_2',   included: true, isHighlighted: true),
      PlanFeature(labelKey: 'sub_feat_pdf',         included: false),
      PlanFeature(labelKey: 'sub_feat_family',      included: false),
      PlanFeature(labelKey: 'sub_feat_voice',       included: false),
      PlanFeature(labelKey: 'sub_feat_ai_coach',    included: false),
    ],
  );

  static const PlanDefinition pro = PlanDefinition(
    type: PlanType.pro,
    nameKey: 'sub_pro',
    monthlyPrice: 9.99,
    yearlyPrice: 89,
    yearlyOriginal: 120,
    accentColor: AppColors.primary,
    gradientEnd: Color(0xFFFF8C5A),
    isMostPopular: true,
    ctaKey: 'sub_start_trial',
    features: [
      PlanFeature(labelKey: 'sub_feat_unlimited_cat', included: true),
      PlanFeature(labelKey: 'sub_feat_unlimited_ai',  included: true),
      PlanFeature(labelKey: 'sub_feat_voice_ar_en',   included: true),
      PlanFeature(labelKey: 'sub_feat_pdf_pro',       included: true),
      PlanFeature(labelKey: 'sub_feat_bank_import',   included: true),
      PlanFeature(labelKey: 'sub_feat_sub_tracker',   included: true),
      PlanFeature(labelKey: 'sub_feat_bnpl',          included: true),
      PlanFeature(labelKey: 'sub_feat_family_mode',   included: false),
    ],
  );

  static const PlanDefinition family = PlanDefinition(
    type: PlanType.family,
    nameKey: 'sub_family',
    monthlyPrice: 19.99,
    yearlyPrice: 179,
    yearlyOriginal: 240,
    accentColor: Color(0xFF9C27B0),
    gradientEnd: Color(0xFF6A0DAD),
    ctaKey: 'sub_start_trial',
    features: [
      PlanFeature(labelKey: 'sub_feat_everything_pro', included: true),
      PlanFeature(labelKey: 'sub_feat_6members',       included: true),
      PlanFeature(labelKey: 'sub_feat_shared_budget',  included: true),
      PlanFeature(labelKey: 'sub_feat_profiles',       included: true),
      PlanFeature(labelKey: 'sub_feat_pocket_kids',    included: true),
      PlanFeature(labelKey: 'sub_feat_parental',       included: true),
      PlanFeature(labelKey: 'sub_feat_per_member',     included: true),
      PlanFeature(labelKey: 'sub_feat_zatca',          included: false),
    ],
  );
}
