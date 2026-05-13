// lib/features/home/controller/home_controller.dart
// ─────────────────────────────────────────────────────────────────────────────
// GetX controller for the Home feature.
// Keeps UI logic out of widgets and state reactive.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:get/get.dart';
import '../model/home_models.dart';

class HomeController extends GetxController {
  // ── User info ─────────────────────────────────────────────────────────────
  final RxString userName = 'Ahmad'.obs;

  // ── Finance Summary ───────────────────────────────────────────────────────
  final RxDouble income = 12000.0.obs;
  final RxDouble available = 3550.0.obs;
  final RxDouble spent = 8450.0.obs;

  // ── Financial Health Score ────────────────────────────────────────────────
  final RxInt healthScore = 78.obs;
  final RxString healthLabel = 'Very Good'.obs;

  // ── Monthly Budget ────────────────────────────────────────────────────────
  final RxDouble monthlyBudget = 8450.0.obs;
  final RxDouble totalIncome = 12000.0.obs;
  final RxDouble budgetUsedPercent = 0.70.obs; // 70%

  // ── Lists (loaded from mock — swappable with API) ─────────────────────────
  final RxList<Transaction> transactions = <Transaction>[].obs;
  final RxList<CategorySpend> categories = <CategorySpend>[].obs;
  final RxList<SavingsGoal> savingsGoals = <SavingsGoal>[].obs;
  final RxList<UpcomingBill> upcomingBills = <UpcomingBill>[].obs;
  final RxList<BudgetCategory> budgetCategories = <BudgetCategory>[].obs;

  // ── AI Insight ────────────────────────────────────────────────────────────
  final RxString aiInsight =
      'You spend 34% more on weekends on food. Try setting a daily limit to stay on track.'.obs;

  // ── Loading state ─────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  // Simulate async data fetch — replace body with real API calls
  Future<void> _loadData() async {
    isLoading.value = true;
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 300));

    transactions.assignAll(MockData.transactions);
    categories.assignAll(MockData.categories);
    savingsGoals.assignAll(MockData.savingsGoals);
    upcomingBills.assignAll(MockData.upcomingBills);
    budgetCategories.assignAll(MockData.budgetCategories);

    isLoading.value = false;
  }

  /// Pull-to-refresh handler
  Future<void> refresh() => _loadData();

  // ── Helpers ───────────────────────────────────────────────────────────────
  /// Format SAR amounts: 12000 → "12,000"
  String formatAmount(double amount) {
    if (amount >= 1000) {
      final k = (amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1);
      return 'SAR ${k}k';
    }
    return 'SAR ${amount.toStringAsFixed(0)}';
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
