// lib/features/ai_coach/controller/ai_credits_controller.dart
// ─────────────────────────────────────────────────────────────────────────────
// GetX controller managing AI credits balance, earning, spending.
// Permanent: lives for the app lifetime — future backend swap = only this file.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:get/get.dart';

import '../../subscription/controller/subscription_controller.dart';
import '../models/ai_credits_model.dart';

class AiCreditsController extends GetxController {
  static AiCreditsController get to => Get.find<AiCreditsController>();

  // ── State ─────────────────────────────────────────────────────────────────
  final RxInt balance = 100.obs; // starter credits
  final RxList<AiCreditActivity> history = <AiCreditActivity>[].obs;
  final RxList<MiniGameModel> games = MiniGamesCatalogue.games.obs;
  final RxBool isLoading = false.obs;

  // ── Streak ────────────────────────────────────────────────────────────────
  final RxInt dailyStreak = 3.obs;
  final RxBool claimedDailyBonus = false.obs;

  SubscriptionController get _sub => Get.find<SubscriptionController>();

  @override
  void onInit() {
    super.onInit();
    _loadMockHistory();
  }

  // ── Earn credits ──────────────────────────────────────────────────────────

  /// Called after a mini-game/activity is completed
  Future<void> earnCredits({
    required int amount,
    required String description,
    AiFeature? feature,
    String? gameId,
  }) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600)); // simulate API

    balance.value += amount;
    history.insert(
      0,
      AiCreditActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: CreditActivityType.earned,
        amount: amount,
        description: description,
        timestamp: DateTime.now(),
        feature: feature,
      ),
    );

    // Update game cooldown
    if (gameId != null) {
      final idx = games.indexWhere((g) => g.id == gameId);
      if (idx != -1) {
        final old = games[idx];
        games[idx] = MiniGameModel(
          id: old.id,
          titleKey: old.titleKey,
          descriptionKey: old.descriptionKey,
          emoji: old.emoji,
          creditsReward: old.creditsReward,
          cooldownMinutes: old.cooldownMinutes,
          isPremiumOnly: old.isPremiumOnly,
          lastPlayedAt: DateTime.now(),
        );
      }
    }

    isLoading.value = false;

    Get.snackbar(
      '🎉 Credits Earned!',
      '+$amount AI credits added to your balance',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  /// Spend credits for an AI feature — returns true if successful
  Future<bool> spendCredits({
    required AiFeature feature,
    String? customDescription,
  }) async {
    // Premium users get unlimited basic features
    if (_sub.isPremium &&
        (feature == AiFeature.basicChat ||
            feature == AiFeature.advancedInsight)) {
      return true;
    }

    final cost = CreditCosts.forFeature(feature);
    if (cost == 0) return true; // free feature

    if (balance.value < cost) {
      Get.snackbar(
        '⚠️ Insufficient Credits',
        'You need $cost credits. Earn more by playing mini-games!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));

    balance.value -= cost;
    history.insert(
      0,
      AiCreditActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: CreditActivityType.spent,
        amount: -cost,
        description: customDescription ?? _featureLabel(feature),
        timestamp: DateTime.now(),
        feature: feature,
      ),
    );

    isLoading.value = false;
    return true;
  }

  void claimDailyBonus() {
    if (claimedDailyBonus.value) return;
    claimedDailyBonus.value = true;
    final bonus = 10 + (dailyStreak.value * 2);
    earnCredits(
      amount: bonus,
      description: 'Daily streak bonus (day ${dailyStreak.value})',
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool canAfford(AiFeature feature) {
    if (_sub.isPremium) return true;
    return balance.value >= CreditCosts.forFeature(feature);
  }

  String _featureLabel(AiFeature feature) {
    switch (feature) {
      case AiFeature.basicChat:
        return 'AI Chat';
      case AiFeature.advancedInsight:
        return 'Advanced Insight';
      case AiFeature.monthlyReport:
        return 'Monthly Report';
      case AiFeature.yearlyReport:
        return 'Yearly Report';
      case AiFeature.pdfExport:
        return 'PDF Export';
      case AiFeature.chartAnalysis:
        return 'Chart Analysis';
    }
  }

  void _loadMockHistory() {
    final now = DateTime.now();
    history.assignAll([
      AiCreditActivity(
        id: '1',
        type: CreditActivityType.earned,
        amount: 25,
        description: 'Completed Hen Blitz game',
        timestamp: now.subtract(const Duration(hours: 2)),
        feature: null,
      ),
      AiCreditActivity(
        id: '2',
        type: CreditActivityType.spent,
        amount: -20,
        description: 'Generated Monthly Report',
        timestamp: now.subtract(const Duration(hours: 5)),
        feature: AiFeature.monthlyReport,
      ),
      AiCreditActivity(
        id: '3',
        type: CreditActivityType.earned,
        amount: 15,
        description: 'Budget Quiz completed',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
      AiCreditActivity(
        id: '4',
        type: CreditActivityType.bonus,
        amount: 50,
        description: 'Welcome bonus',
        timestamp: now.subtract(const Duration(days: 7)),
      ),
    ]);
  }
}
