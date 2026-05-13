// lib/features/reports/model/reports_models.dart
// ─────────────────────────────────────────────────────────────────────────────
// Reports v2 — complete data models for all 4 tabs:
//   Overview | Income | Expenses | Net Worth
// Pure Dart — no Flutter/GetX — fully unit-testable.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

// ── Tab enum ──────────────────────────────────────────────────────────────────
enum ReportsTab { overview, income, expenses, netWorth }

extension ReportsTabKey on ReportsTab {
  String get labelKey {
    switch (this) {
      case ReportsTab.overview:
        return 'rpt_overview';
      case ReportsTab.income:
        return 'rpt_income';
      case ReportsTab.expenses:
        return 'rpt_expenses';
      case ReportsTab.netWorth:
        return 'rpt_net_worth';
    }
  }
}

// ── Period chip enum ──────────────────────────────────────────────────────────
enum ReportPeriod { d7, m1, m3, m6, y1 }

extension ReportPeriodKey on ReportPeriod {
  String get labelKey {
    switch (this) {
      case ReportPeriod.d7:
        return 'rpt_7d';
      case ReportPeriod.m1:
        return 'rpt_1m';
      case ReportPeriod.m3:
        return 'rpt_3m';
      case ReportPeriod.m6:
        return 'rpt_6m';
      case ReportPeriod.y1:
        return 'rpt_1y';
    }
  }
}

// ── Category slice for donut charts ──────────────────────────────────────────
class CategorySlice {
  final String nameKey;
  final double percentage;
  final double amount;
  final Color color;
  const CategorySlice({
    required this.nameKey,
    required this.percentage,
    required this.amount,
    required this.color,
  });
}

// ── Income source row ─────────────────────────────────────────────────────────
class IncomeSource {
  final String nameKey;
  final String subtitleKey;
  final double amount;
  final double percentage;
  final Color color;
  const IncomeSource({
    required this.nameKey,
    required this.subtitleKey,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

// ── Expense category row ──────────────────────────────────────────────────────
class ExpenseCategory {
  final String nameKey;
  final double amount;
  final double percentage;
  final Color color;
  const ExpenseCategory({
    required this.nameKey,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

// ── Net worth history entry ───────────────────────────────────────────────────
class NetWorthEntry {
  final String labelKey;
  final String dateKey;
  final double amount;
  final bool isCurrent;
  const NetWorthEntry({
    required this.labelKey,
    required this.dateKey,
    required this.amount,
    this.isCurrent = false,
  });
}

// ── Daily chart bar/point ─────────────────────────────────────────────────────
class DailyPoint {
  final int day;
  final double value;
  const DailyPoint({required this.day, required this.value});
}

// ── Income vs Expenses line data ──────────────────────────────────────────────
class IvsEPoint {
  final int day;
  final double income;
  final double expenses;
  const IvsEPoint(
      {required this.day, required this.income, required this.expenses});
}

// ── Net worth trend point ─────────────────────────────────────────────────────
class TrendPoint {
  final String label; // "Feb", "Mar"...
  final double value;
  const TrendPoint({required this.label, required this.value});
}

// ─────────────────────────────────────────────────────────────────────────────
// MOCK DATA  — swap _loadData in controller for real API calls
// ─────────────────────────────────────────────────────────────────────────────
class ReportsMockData {
  // ── Overview ────────────────────────────────────────────────────────────────
  static const double totalBalance = 10600;
  static const double balanceChange = 12.0;
  static const double totalIncome = 28400;
  static const double incomeChange = 18.6;
  static const double totalExpenses = 17800;
  static const double expensesChange = 8.4;

  static const List<CategorySlice> spendingBreakdown = [
    CategorySlice(
        nameKey: 'rpt_food_dining',
        percentage: 29,
        amount: 5160,
        color: AppColors.categoryFood),
    CategorySlice(
        nameKey: 'rpt_transport',
        percentage: 18,
        amount: 3204,
        color: AppColors.categoryTransport),
    CategorySlice(
        nameKey: 'rpt_shopping',
        percentage: 23,
        amount: 4094,
        color: Color(0xFF9C27B0)),
    CategorySlice(
        nameKey: 'rpt_bills',
        percentage: 15,
        amount: 2670,
        color: AppColors.warning),
    CategorySlice(
        nameKey: 'rpt_other',
        percentage: 15,
        amount: 2672,
        color: AppColors.categoryShopping),
  ];

  static const List<IvsEPoint> incomeVsExpenses = [
    IvsEPoint(day: 1, income: 900, expenses: 400),
    IvsEPoint(day: 5, income: 300, expenses: 600),
    IvsEPoint(day: 10, income: 600, expenses: 300),
    IvsEPoint(day: 15, income: 2800, expenses: 200),
    IvsEPoint(day: 20, income: 12000, expenses: 800),
    IvsEPoint(day: 25, income: 500, expenses: 1200),
    IvsEPoint(day: 30, income: 400, expenses: 600),
  ];

  // ── Income tab ───────────────────────────────────────────────────────────────
  static const List<DailyPoint> dailyIncome = [
    DailyPoint(day: 1, value: 0),
    DailyPoint(day: 5, value: 200),
    DailyPoint(day: 10, value: 150),
    DailyPoint(day: 15, value: 600),
    DailyPoint(day: 20, value: 12000),
    DailyPoint(day: 25, value: 300),
    DailyPoint(day: 30, value: 0),
  ];

  static const List<CategorySlice> incomeBreakdown = [
    CategorySlice(
        nameKey: 'rpt_salary',
        percentage: 60,
        amount: 17040,
        color: AppColors.categoryShopping),
    CategorySlice(
        nameKey: 'rpt_business',
        percentage: 16,
        amount: 4544,
        color: Color(0xFF9C27B0)),
    CategorySlice(
        nameKey: 'rpt_freelancing',
        percentage: 12,
        amount: 3408,
        color: AppColors.categoryTransport),
    CategorySlice(
        nameKey: 'rpt_investment',
        percentage: 8,
        amount: 2272,
        color: AppColors.warning),
    CategorySlice(
        nameKey: 'rpt_other',
        percentage: 4,
        amount: 1136,
        color: AppColors.textTertiary),
  ];

  static const List<IncomeSource> incomeSources = [
    IncomeSource(
        nameKey: 'rpt_salary',
        subtitleKey: 'rpt_stc_main',
        amount: 17848,
        percentage: 60.0,
        color: AppColors.categoryShopping),
    IncomeSource(
        nameKey: 'rpt_business',
        subtitleKey: 'rpt_alrajhi',
        amount: 4544,
        percentage: 16.0,
        color: Color(0xFF9C27B0)),
    IncomeSource(
        nameKey: 'rpt_freelancing',
        subtitleKey: 'rpt_wise_usd',
        amount: 3408,
        percentage: 12.0,
        color: AppColors.categoryTransport),
    IncomeSource(
        nameKey: 'rpt_investment',
        subtitleKey: 'rpt_snb_capital',
        amount: 2272,
        percentage: 8.0,
        color: AppColors.warning),
    IncomeSource(
        nameKey: 'rpt_other',
        subtitleKey: 'rpt_cash',
        amount: 1136,
        percentage: 4.0,
        color: AppColors.textTertiary),
  ];

  // ── Expenses tab ─────────────────────────────────────────────────────────────
  static final List<DailyPoint> dailyExpenses = List.generate(30, (i) {
    var vals = [
      120.0,
      340.0,
      180.0,
      420.0,
      290.0,
      150.0,
      390.0,
      210.0,
      470.0,
      320.0,
      180.0,
      440.0,
      260.0,
      380.0,
      490.0,
      220.0,
      350.0,
      170.0,
      430.0,
      300.0,
      540.0,
      250.0,
      190.0,
      460.0,
      330.0,
      200.0,
      510.0,
      280.0,
      390.0,
      450.0,
    ];
    return DailyPoint(day: i + 1, value: vals[i]);
  });

  static const List<CategorySlice> expenseBreakdown = [
    CategorySlice(
        nameKey: 'rpt_food_dining',
        percentage: 29,
        amount: 5160,
        color: AppColors.categoryFood),
    CategorySlice(
        nameKey: 'rpt_transport',
        percentage: 18,
        amount: 3204,
        color: AppColors.categoryTransport),
    CategorySlice(
        nameKey: 'rpt_shopping',
        percentage: 23,
        amount: 4094,
        color: Color(0xFF9C27B0)),
    CategorySlice(
        nameKey: 'rpt_bills',
        percentage: 15,
        amount: 2670,
        color: AppColors.warning),
    CategorySlice(
        nameKey: 'rpt_other',
        percentage: 15,
        amount: 2672,
        color: AppColors.categoryShopping),
  ];

  static const List<ExpenseCategory> topExpenseCategories = [
    ExpenseCategory(
        nameKey: 'rpt_food_dining',
        amount: 5240,
        percentage: 29.4,
        color: AppColors.categoryFood),
    ExpenseCategory(
        nameKey: 'rpt_transport',
        amount: 3128,
        percentage: 17.5,
        color: AppColors.categoryTransport),
    ExpenseCategory(
        nameKey: 'rpt_shopping',
        amount: 4188,
        percentage: 23.5,
        color: Color(0xFF9C27B0)),
    ExpenseCategory(
        nameKey: 'rpt_bills',
        amount: 2640,
        percentage: 14.8,
        color: AppColors.warning),
    ExpenseCategory(
        nameKey: 'rpt_other',
        amount: 2628,
        percentage: 14.7,
        color: AppColors.categoryShopping),
  ];

  // ── Net Worth tab ────────────────────────────────────────────────────────────
  static const double netWorth = 356500;
  static const double netWorthChange = 7.3;
  static const double assets = 506800;
  static const double liabilities = 150300;

  static const List<TrendPoint> netWorthTrend = [
    TrendPoint(label: 'Feb', value: 310000),
    TrendPoint(label: '', value: 315000),
    TrendPoint(label: '', value: 312000),
    TrendPoint(label: 'Mar', value: 323200),
    TrendPoint(label: '', value: 330000),
    TrendPoint(label: '', value: 334000),
    TrendPoint(label: 'Apr', value: 340900),
    TrendPoint(label: '', value: 345000),
    TrendPoint(label: '', value: 350000),
    TrendPoint(label: 'May', value: 356500),
  ];

  static const List<NetWorthEntry> netWorthHistory = [
    NetWorthEntry(
        labelKey: 'rpt_3months_ago', dateKey: 'Feb 2026', amount: 323200),
    NetWorthEntry(
        labelKey: 'rpt_1month_ago', dateKey: 'Apr 2026', amount: 340900),
    NetWorthEntry(
        labelKey: 'rpt_current',
        dateKey: 'May 2026',
        amount: 356500,
        isCurrent: true),
  ];
}
