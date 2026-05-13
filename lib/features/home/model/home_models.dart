// lib/features/home/model/home_models.dart
// ─────────────────────────────────────────────────────────────────────────────
// Pure data models — no dependencies on Flutter or GetX.
// Immutable value types with copyWith support for future state updates.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// ── Transaction ───────────────────────────────────────────────────────────────
class Transaction {
  final String id;
  final String title;
  final String category;
  final String time;
  final double amount;
  final bool isIncome;
  final Color color;
  final IconData icon;

  const Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
    this.isIncome = false,
    required this.color,
    required this.icon,
  });
}

// ── Category Spend ────────────────────────────────────────────────────────────
class CategorySpend {
  final String name;
  final double amount;
  final double percentage;   // 0.0 – 1.0
  final Color color;
  final IconData icon;

  const CategorySpend({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}

// ── Savings Goal ──────────────────────────────────────────────────────────────
class SavingsGoal {
  final String name;
  final double current;
  final double target;
  final String deadline;
  final Color color;

  const SavingsGoal({
    required this.name,
    required this.current,
    required this.target,
    required this.deadline,
    required this.color,
  });

  double get progress => (current / target).clamp(0.0, 1.0);
  double get remaining => target - current;
}

// ── Upcoming Bill ─────────────────────────────────────────────────────────────
class UpcomingBill {
  final String name;
  final int daysLeft;
  final double amount;
  final IconData icon;
  final Color color;

  const UpcomingBill({
    required this.name,
    required this.daysLeft,
    required this.amount,
    required this.icon,
    required this.color,
  });
}

// ── Budget Category (for the budget donut chart) ──────────────────────────────
class BudgetCategory {
  final String name;
  final double percentage;
  final Color color;

  const BudgetCategory({
    required this.name,
    required this.percentage,
    required this.color,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Hardcoded mock data — replace with API calls later without changing the UI.
// ─────────────────────────────────────────────────────────────────────────────
class MockData {
  static const List<Transaction> transactions = [
    Transaction(
      id: '1',
      title: "McDonald's",
      category: 'Food · 10:30 AM',
      time: '10:30 AM',
      amount: 45,
      color: AppColors.categoryFood,
      icon: Icons.fastfood_rounded,
    ),
    Transaction(
      id: '2',
      title: 'Uber',
      category: 'Transport · 11:15 AM',
      time: '11:15 AM',
      amount: 28,
      color: AppColors.categoryTransport,
      icon: Icons.directions_car_filled_rounded,
    ),
    Transaction(
      id: '3',
      title: 'Amazon',
      category: 'Shopping · Yesterday',
      time: 'Yesterday',
      amount: 156,
      color: AppColors.categoryShopping,
      icon: Icons.shopping_bag_rounded,
    ),
    Transaction(
      id: '4',
      title: 'April Salary',
      category: 'Income · Apr 35',
      time: 'Apr 35',
      amount: 12000,
      isIncome: true,
      color: AppColors.income,
      icon: Icons.account_balance_wallet_rounded,
    ),
    Transaction(
      id: '5',
      title: 'Netflix',
      category: 'Entertainment · Apr 27',
      time: 'Apr 27',
      amount: 45,
      color: AppColors.categoryFood,
      icon: Icons.play_circle_fill_rounded,
    ),
  ];

  static const List<CategorySpend> categories = [
    CategorySpend(
      name: 'Food & Dining',
      amount: 2100,
      percentage: 0.70,
      color: AppColors.categoryFood,
      icon: Icons.fastfood_rounded,
    ),
    CategorySpend(
      name: 'Transport',
      amount: 890,
      percentage: 0.59,
      color: AppColors.categoryTransport,
      icon: Icons.directions_car_filled_rounded,
    ),
    CategorySpend(
      name: 'Shopping',
      amount: 1440,
      percentage: 0.72,
      color: AppColors.categoryShopping,
      icon: Icons.shopping_bag_rounded,
    ),
  ];

  static const List<SavingsGoal> savingsGoals = [
    SavingsGoal(
      name: 'Vacation Fund 🌍',
      current: 3250,
      target: 5000,
      deadline: 'July 2025',
      color: const Color(0xFFFF6B35), // default; overridden by ThemeController accent
    ),
  ];

  static const List<UpcomingBill> upcomingBills = [
    UpcomingBill(
      name: 'Netflix',
      daysLeft: 2,
      amount: 45,
      icon: Icons.play_circle_fill_rounded,
      color: AppColors.categoryFood,
    ),
    UpcomingBill(
      name: 'Gym',
      daysLeft: 5,
      amount: 120,
      icon: Icons.fitness_center_rounded,
      color: AppColors.categoryTransport,
    ),
    UpcomingBill(
      name: 'Electric',
      daysLeft: 12,
      amount: 280,
      icon: Icons.bolt_rounded,
      color: AppColors.categoryShopping,
    ),
  ];

  static const List<BudgetCategory> budgetCategories = [
    BudgetCategory(name: 'Food', percentage: 0.45, color: AppColors.categoryFood),
    BudgetCategory(name: 'Trans', percentage: 0.25, color: AppColors.categoryTransport),
    BudgetCategory(name: 'Shop', percentage: 0.30, color: AppColors.categoryShopping),
  ];
}
