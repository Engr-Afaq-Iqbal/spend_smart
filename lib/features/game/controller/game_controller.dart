// lib/features/game/controller/game_controller.dart
// ─────────────────────────────────────────────────────────────────────────────
// GetX controller that sits between the SpendSmart app and the Flame game.
//
// Responsibilities:
//   • Builds UserFinancialProfile from live HomeController data
//   • Persists high score across sessions
//   • Handles game result → app state updates (AI credits, etc.)
//   • Manages daily play-count for free-user limit
// ─────────────────────────────────────────────────────────────────────────────

import 'package:get/get.dart';
import 'package:spend_smart/features/home/controller/home_controller.dart';
import 'package:spend_smart/features/subscription/controller/subscription_controller.dart';
import 'package:spend_smart/features/game/models/game_models.dart';

class GameController extends GetxController {
  // ── Personal best ──────────────────────────────────────────────────────────
  final RxInt personalBest = 0.obs;

  // ── Daily play count (free users limited) ─────────────────────────────────
  final RxInt dailyPlaysUsed = 0.obs;
  static const int _maxFreePlays = 1; // 1 game per day for free users

  // ── Last game result ───────────────────────────────────────────────────────
  final Rx<GameResult?> lastResult = Rx<GameResult?>(null);

  // ── Total AI credits earned from game ─────────────────────────────────────
  final RxInt totalAiCredits = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // In production: load personalBest + dailyPlaysUsed from SharedPreferences
  }

  // ── Build profile from live app data ──────────────────────────────────────
  UserFinancialProfile buildProfile() {
    final home = Get.find<HomeController>();
    final sub  = Get.find<SubscriptionController>();

    return UserFinancialProfile(
      monthlyIncome:   home.income.value,
      monthlyExpenses: home.spent.value,
      currentStreak:   home.healthScore.value ~/ 6, // mock streak from score
      isPro:           sub.isPremium,
      petName:         home.userName.value,
    );
  }

  // ── Called when a game session completes ──────────────────────────────────
  void onGameComplete(GameResult result) {
    lastResult.value = result;
    dailyPlaysUsed.value++;

    // Update personal best
    if (result.distanceMeters > personalBest.value) {
      personalBest.value = result.distanceMeters;
    }

    // Accumulate AI credits
    totalAiCredits.value += result.aiCreditsEarned;

    // In production:
    //   1. Save personalBest to SharedPreferences
    //   2. Call Cloud Function to record score (uses result.sessionHash)
    //   3. Award AI credits to the parent app
  }

  // ── Can the user play another game today? ─────────────────────────────────
  bool get canPlayToday {
    final sub = Get.find<SubscriptionController>();
    if (sub.isPremium) return true; // Pro: unlimited
    return dailyPlaysUsed.value < _maxFreePlays;
  }

  // ── Reset daily count (call from a midnight scheduler or on app resume) ───
  void resetDailyCount() => dailyPlaysUsed.value = 0;
}
