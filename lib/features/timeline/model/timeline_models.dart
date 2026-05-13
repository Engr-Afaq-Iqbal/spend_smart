// lib/features/timeline/model/timeline_models.dart
// ─────────────────────────────────────────────────────────────────────────────
// Pure data models for the Transaction Timeline feature.
// No Flutter widget or GetX dependencies — fully unit-testable.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// ── View filter enum ──────────────────────────────────────────────────────────
enum TimelineFilter { daily, weekly, monthly }

extension TimelineFilterKey on TimelineFilter {
  String get labelKey {
    switch (this) {
      case TimelineFilter.daily:   return 'timeline_filter_daily';
      case TimelineFilter.weekly:  return 'timeline_filter_weekly';
      case TimelineFilter.monthly: return 'timeline_filter_monthly';
    }
  }
}

// ── Category enum ─────────────────────────────────────────────────────────────
enum TxCategory {
  food,
  transport,
  shopping,
  entertainment,
  health,
  utilities,
  income,
  other,
}

extension TxCategoryProps on TxCategory {
  String get labelKey {
    switch (this) {
      case TxCategory.food:          return 'category_food';
      case TxCategory.transport:     return 'category_transport';
      case TxCategory.shopping:      return 'category_shopping';
      case TxCategory.entertainment: return 'category_entertainment';
      case TxCategory.health:        return 'timeline_category_health';
      case TxCategory.utilities:     return 'timeline_category_utilities';
      case TxCategory.income:        return 'timeline_category_income';
      case TxCategory.other:         return 'timeline_category_other';
    }
  }

  Color get color {
    switch (this) {
      case TxCategory.food:          return AppColors.categoryFood;
      case TxCategory.transport:     return AppColors.categoryTransport;
      case TxCategory.shopping:      return AppColors.categoryShopping;
      case TxCategory.entertainment: return const Color(0xFFE91E8C);
      case TxCategory.health:        return const Color(0xFF00BCD4);
      case TxCategory.utilities:     return const Color(0xFF9C27B0);
      case TxCategory.income:        return AppColors.income;
      case TxCategory.other:         return AppColors.textTertiary;
    }
  }

  IconData get icon {
    switch (this) {
      case TxCategory.food:          return Icons.fastfood_rounded;
      case TxCategory.transport:     return Icons.directions_car_filled_rounded;
      case TxCategory.shopping:      return Icons.shopping_bag_rounded;
      case TxCategory.entertainment: return Icons.play_circle_fill_rounded;
      case TxCategory.health:        return Icons.medical_services_rounded;
      case TxCategory.utilities:     return Icons.bolt_rounded;
      case TxCategory.income:        return Icons.account_balance_wallet_rounded;
      case TxCategory.other:         return Icons.category_rounded;
    }
  }
}

// ── Timeline Transaction ───────────────────────────────────────────────────────
// Rich model with a full DateTime so filtering by day/week/month works correctly.
class TimelineTransaction {
  final String id;
  final String title;
  final TxCategory category;
  final DateTime date;         // full timestamp for accurate grouping
  final double amount;
  final bool isIncome;

  const TimelineTransaction({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    this.isIncome = false,
  });

  // Convenience: expense amount as positive regardless of sign
  double get absAmount => amount.abs();

  // Format amount for display: -SAR 245
  String get displayAmount =>
      isIncome ? '+SAR ${_fmt(absAmount)}' : '-SAR ${_fmt(absAmount)}';

  static String _fmt(double v) {
    if (v >= 1000) {
      final parts = v.toStringAsFixed(0);
      final buf = StringBuffer();
      for (var i = 0; i < parts.length; i++) {
        if (i > 0 && (parts.length - i) % 3 == 0) buf.write(',');
        buf.write(parts[i]);
      }
      return buf.toString();
    }
    return v.toStringAsFixed(0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rich mock dataset — April 2026 + surrounding months.
// Designed to produce visible dots on most days and realistic totals.
// ─────────────────────────────────────────────────────────────────────────────
class TimelineMockData {
  static final List<TimelineTransaction> transactions = [
    // ── April 2026 ───────────────────────────────────────────────────────────
    _t('t001', 'Starbucks',      TxCategory.food,          1,  38),
    _t('t002', 'Uber',           TxCategory.transport,     1,  22),
    _t('t003', 'Netflix',        TxCategory.entertainment,  3,  45),
    _t('t004', 'Amazon',         TxCategory.shopping,       4, 156),
    _t('t005', "McDonald's",     TxCategory.food,           5,  32),
    _t('t006', 'Carrefour',      TxCategory.shopping,       6,  87),
    _t('t007', 'Lyft',           TxCategory.transport,      7,  19),
    _t('t008', 'Clinic Visit',   TxCategory.health,         8, 120),
    _t('t009', 'IKEA',           TxCategory.shopping,       9, 340),
    _t('t010', 'Starbucks',      TxCategory.food,           9,  42),
    _t('t011', 'Electricity',    TxCategory.utilities,     10, 280),
    _t('t012', 'KFC',            TxCategory.food,          11,  55),
    _t('t013', 'Noon.com',       TxCategory.shopping,      12, 200),
    _t('t014', 'Uber Eats',      TxCategory.food,          13,  65),
    _t('t015', 'Taxi',           TxCategory.transport,     14,  30),
    _t('t016', 'Pizza Hut',      TxCategory.food,          15,  78),
    _t('t017', 'H&M',            TxCategory.shopping,      15, 190),
    _t('t018', 'Gym',            TxCategory.health,        16, 120),
    _t('t019', 'Apple Store',    TxCategory.shopping,      17, 499),
    _t('t020', 'Starbucks',      TxCategory.food,          18,  44),
    _t('t021', 'Uber',           TxCategory.transport,     19,  25),
    _t('t022', 'Salary',         TxCategory.income,        20, 12000, income: true),
    _t('t023', 'Spotify',        TxCategory.entertainment, 20,  35),
    _t('t024', 'Carrefour',      TxCategory.shopping,      21, 132),
    _t('t025', 'Clinic',         TxCategory.health,        22,  95),
    _t('t026', 'Noon.com',       TxCategory.shopping,      23, 175),
    _t('t027', 'McDonald\'s',    TxCategory.food,          24,  40),
    _t('t028', 'Internet Bill',  TxCategory.utilities,     25, 180),
    _t('t029', 'Amazon',         TxCategory.shopping,      29, 245),
    _t('t030', 'Starbucks',      TxCategory.food,          29,  38),
    _t('t031', 'Uber',           TxCategory.transport,     30,  28),
    _t('t032', 'Zara',           TxCategory.shopping,      30, 220),

    // ── March 2026 (previous month) ──────────────────────────────────────────
    _t('t033', 'Amazon',         TxCategory.shopping,      15, 189, month: 3),
    _t('t034', 'Starbucks',      TxCategory.food,          18,  36, month: 3),
    _t('t035', 'Salary',         TxCategory.income,        20, 12000, month: 3, income: true),
    _t('t036', 'Netflix',        TxCategory.entertainment, 25,  45, month: 3),
    _t('t037', 'Carrefour',      TxCategory.shopping,      27, 210, month: 3),

    // ── May 2026 (next month) ────────────────────────────────────────────────
    _t('t038', 'Noon.com',       TxCategory.shopping,       2, 155, month: 5),
    _t('t039', 'Starbucks',      TxCategory.food,           5,  40, month: 5),
    _t('t040', 'Salary',         TxCategory.income,        20, 12000, month: 5, income: true),
  ];

  // ── Helper constructor ────────────────────────────────────────────────────
  static TimelineTransaction _t(
    String id, String title, TxCategory category, int day, double amount, {
    int month = 4, int year = 2026, bool income = false,
  }) {
    return TimelineTransaction(
      id: id,
      title: title,
      category: category,
      date: DateTime(year, month, day, 10, 0),
      amount: amount,
      isIncome: income,
    );
  }
}
