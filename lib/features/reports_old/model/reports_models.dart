// lib/features/reports/model/reports_models.dart
// ─────────────────────────────────────────────────────────────────────────────
// Pure data models for the Reports screen.
// No Flutter/GetX imports — keeps models testable in isolation.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// ── Period filter ─────────────────────────────────────────────────────────────
enum ReportPeriod { week, month, quarter, year }

extension ReportPeriodLabel on ReportPeriod {
  String get label {
    switch (this) {
      case ReportPeriod.week:    return 'Week';
      case ReportPeriod.month:   return 'Month';
      case ReportPeriod.quarter: return 'Quarter';
      case ReportPeriod.year:    return 'Year';
    }
  }
}

// ── Summary card data ─────────────────────────────────────────────────────────
class SummaryMetric {
  final String title;
  final double amount;
  final double changePercent; // positive = up, negative = down
  final String changeLabel;   // e.g. "vs last month"

  const SummaryMetric({
    required this.title,
    required this.amount,
    required this.changePercent,
    required this.changeLabel,
  });

  bool get isPositiveChange => changePercent >= 0;
}

// ── Donut chart slice ─────────────────────────────────────────────────────────
class CategorySlice {
  final String name;
  final double percentage;   // 0–100
  final double amount;
  final Color color;

  const CategorySlice({
    required this.name,
    required this.percentage,
    required this.amount,
    required this.color,
  });
}

// ── Daily spending data point ─────────────────────────────────────────────────
class DailyPoint {
  final int day;     // 1–31
  final double actual;
  final double avg;

  const DailyPoint({required this.day, required this.actual, required this.avg});
}

// ── Month-over-month comparison ───────────────────────────────────────────────
class MonthlyComparison {
  final String month;          // "Jan", "Feb", etc.
  final double amount;
  final bool isCurrentMonth;

  const MonthlyComparison({
    required this.month,
    required this.amount,
    this.isCurrentMonth = false,
  });
}

// ── Merchant row ──────────────────────────────────────────────────────────────
class MerchantSpend {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;

  const MerchantSpend({
    required this.name,
    required this.amount,
    required this.color,
    required this.icon,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Mock data — swap with real API responses without touching UI layer
// ─────────────────────────────────────────────────────────────────────────────
class ReportsMockData {
  // ── Summary cards ──────────────────────────────────────────────────────────
  static const List<SummaryMetric> summaryMetrics = [
    SummaryMetric(
      title: 'Total Spent',
      amount: 8450,
      changePercent: 12,
      changeLabel: 'vs last month',
    ),
    SummaryMetric(
      title: 'Total Income',
      amount: 12000,
      changePercent: 5,
      changeLabel: 'vs last month',
    ),
  ];

  // ── Category donut ─────────────────────────────────────────────────────────
  static const List<CategorySlice> categorySlices = [
    CategorySlice(name: 'Food',          percentage: 25, amount: 2113, color: AppColors.categoryFood),
    CategorySlice(name: 'Transport',     percentage: 11, amount:  930, color: AppColors.categoryTransport),
    CategorySlice(name: 'Shopping',      percentage: 17, amount: 1437, color: AppColors.categoryShopping),
    CategorySlice(name: 'Entertainment', percentage: 10, amount:  845, color: Color(0xFFE91E8C)),
    CategorySlice(name: 'Others',        percentage: 37, amount: 3125, color: Color(0xFFE8C96B)),
  ];

  // ── Daily spending for April 2026 ──────────────────────────────────────────
  static const List<DailyPoint> dailyPoints = [
    DailyPoint(day:  1, actual: 120, avg: 281),
    DailyPoint(day:  2, actual: 340, avg: 281),
    DailyPoint(day:  3, actual: 180, avg: 281),
    DailyPoint(day:  4, actual: 420, avg: 281),
    DailyPoint(day:  5, actual: 290, avg: 281),
    DailyPoint(day:  6, actual: 150, avg: 281),
    DailyPoint(day:  7, actual: 390, avg: 281),
    DailyPoint(day:  8, actual: 210, avg: 281),
    DailyPoint(day:  9, actual: 470, avg: 281),
    DailyPoint(day: 10, actual: 320, avg: 281),
    DailyPoint(day: 11, actual: 180, avg: 281),
    DailyPoint(day: 12, actual: 440, avg: 281),
    DailyPoint(day: 13, actual: 260, avg: 281),
    DailyPoint(day: 14, actual: 380, avg: 281),
    DailyPoint(day: 15, actual: 490, avg: 281),
    DailyPoint(day: 16, actual: 220, avg: 281),
    DailyPoint(day: 17, actual: 350, avg: 281),
    DailyPoint(day: 18, actual: 170, avg: 281),
    DailyPoint(day: 19, actual: 430, avg: 281),
    DailyPoint(day: 20, actual: 300, avg: 281),
    DailyPoint(day: 21, actual: 540, avg: 281),
    DailyPoint(day: 22, actual: 250, avg: 281),
    DailyPoint(day: 23, actual: 190, avg: 281),
    DailyPoint(day: 24, actual: 460, avg: 281),
    DailyPoint(day: 25, actual: 330, avg: 281),
    DailyPoint(day: 26, actual: 200, avg: 281),
    DailyPoint(day: 27, actual: 510, avg: 281),
    DailyPoint(day: 28, actual: 280, avg: 281),
    DailyPoint(day: 29, actual: 390, avg: 281),
    DailyPoint(day: 30, actual: 450, avg: 281),
  ];

  // ── Month-over-month (last 4 months) ───────────────────────────────────────
  static const List<MonthlyComparison> monthlyComparisons = [
    MonthlyComparison(month: 'Jan', amount: 7200),
    MonthlyComparison(month: 'Feb', amount: 6800),
    MonthlyComparison(month: 'Mar', amount: 7500),
    MonthlyComparison(month: 'Apr', amount: 8450, isCurrentMonth: true),
  ];

  static const double monthOverMonthDelta = 950; // this month vs last month

  // ── Top merchants ──────────────────────────────────────────────────────────
  static const List<MerchantSpend> topMerchants = [
    MerchantSpend(
      name: 'Amazon',
      amount: 1240,
      color: AppColors.categoryFood,
      icon: Icons.shopping_bag_rounded,
    ),
    MerchantSpend(
      name: 'Uber',
      amount: 890,
      color: AppColors.categoryTransport,
      icon: Icons.directions_car_filled_rounded,
    ),
    MerchantSpend(
      name: "McDonald's",
      amount: 650,
      color: AppColors.categoryShopping,
      icon: Icons.fastfood_rounded,
    ),
    MerchantSpend(
      name: 'Netflix',
      amount: 270,
      color: Color(0xFFE91E8C),
      icon: Icons.play_circle_fill_rounded,
    ),
  ];
}
