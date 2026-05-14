// lib/routes/app_routes.dart
// ─────────────────────────────────────────────────────────────────────────────
// Named routes for GetX navigation.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../features/coach/controller/ai_credits_controller.dart';
import '../features/game/controller/game_controller.dart';
import '../features/game/hen_blitz_screen.dart';
import '../features/game/models/game_models.dart';
import '../features/game/screens/egg_guide_screen.dart';
import '../features/game/screens/hen_states_screen.dart';
import '../features/game/screens/score_share_card_screen.dart';
import '../features/game/screens/threats_guide_screen.dart';
import '../features/home/view/main_navigation.dart';
import '../features/settings/controller/settings_controller.dart';
import '../features/settings/view/profile_view.dart';
import '../features/settings/view/settings_view.dart';
import '../features/settings/widgets/play_earn_view.dart';
import '../features/subscription/controller/subscription_controller.dart';
import '../features/subscription/view/subscription_view.dart';
import '../features/transaction/controller/transaction_controller.dart';
import '../features/transaction/view/add_expense_view.dart';
import '../features/transaction/view/add_income_view.dart';
import '../features/transaction/view/scan_receipt_view.dart';
import '../features/transaction/view/voice_expense_view.dart';
import 'app_bindings.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String playEarn = '/play-earn';
  static const String addExpense = '/add-expense';
  static const String addIncome = '/add-income';
  static const String voiceExpense = '/voice-expense';
  static const String scanReceipt = '/scan-receipt';
  static const String subscription = '/subscription';
  // ── Hen Blitz ─────────────────────────────────────────────────────────────
  static const String henBlitz = '/game/play';
  static const String henStates = '/game/hen-states';
  static const String eggGuide = '/game/egg-guide';
  static const String threatsGuide = '/game/threats-guide';
  static const String scoreCard = '/game/score-card';
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => MainNavigation(),
      binding: AppBindings(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      // Inline binding — SettingsController is scoped to this route.
      // It is created on push and disposed automatically on pop.
      binding: BindingsBuilder(() {
        Get.lazyPut<SettingsController>(() => SettingsController());
      }),
      transition: Transition.cupertino, // iOS-style slide from right
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.playEarn,
      page: () => const PlayEarnView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AiCreditsController>()) {
          Get.put<AiCreditsController>(AiCreditsController(), permanent: true);
        }
      }),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.addExpense,
      page: () => const AddExpenseView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TransactionController>(() => TransactionController());
      }),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 320),
    ),
    GetPage(
      name: AppRoutes.addIncome,
      page: () => const AddIncomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TransactionController>(() => TransactionController());
      }),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 320),
    ),
    GetPage(
      name: AppRoutes.voiceExpense,
      page: () => const VoiceExpenseView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TransactionController>(() => TransactionController());
      }),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.scanReceipt,
      page: () => const ScanReceiptView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TransactionController>(() => TransactionController());
      }),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.subscription,
      page: () => const SubscriptionView(),
      binding: BindingsBuilder(() {
        // SubscriptionController already registered as permanent in AppBindings
        // This ensures it's available even if navigated to before AppBindings runs
        if (!Get.isRegistered<SubscriptionController>()) {
          Get.put<SubscriptionController>(SubscriptionController(),
              permanent: true);
        }
      }),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 350),
    ),

    // ── Hen Blitz — Game play ─────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.henBlitz,
      page: () {
        // Build the UserFinancialProfile from live app data
        final gc = Get.find<GameController>();
        final profile = gc.buildProfile();
        return HenBlitzScreen(
          profile: profile,
          personalBest: gc.personalBest.value,
          onGameComplete: gc.onGameComplete,
          onOpenSubscription: () => Get.toNamed(AppRoutes.subscription),
        );
      },
      // GameController must already be registered (done in CoachView.initState)
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    // ── Hen Blitz — Guide screens ─────────────────────────────────────────────
    GetPage(
      name: AppRoutes.henStates,
      page: () {
        final gc = Get.find<GameController>();
        return HenStatesScreen(profile: gc.buildProfile());
      },
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    ),
    GetPage(
      name: AppRoutes.eggGuide,
      page: () => const EggGuideScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    ),
    GetPage(
      name: AppRoutes.threatsGuide,
      page: () => const ThreatsGuideScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    ),
    GetPage(
      name: AppRoutes.scoreCard,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final result = args['result'] as GameResult?;
        final profile = args['profile'] as UserFinancialProfile? ??
            UserFinancialProfile.demo;
        return result == null
            ? const SizedBox.shrink()
            : ScoreShareCardScreen(result: result, profile: profile);
      },
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 350),
    ),
  ];
}
