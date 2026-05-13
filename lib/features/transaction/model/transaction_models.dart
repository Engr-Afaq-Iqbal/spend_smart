// lib/features/transaction/model/transaction_models.dart
// ─────────────────────────────────────────────────────────────────────────────
// Pure data models for the transaction creation flows.
// No Flutter/GetX imports — fully unit-testable.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// ── Expense categories ────────────────────────────────────────────────────────
enum ExpenseCategory {
  food, transport, shopping, entertainment, health, utilities, bills, other
}

extension ExpenseCategoryProps on ExpenseCategory {
  String get labelKey {
    switch (this) {
      case ExpenseCategory.food:          return 'food_dining';
      case ExpenseCategory.transport:     return 'transport';
      case ExpenseCategory.shopping:      return 'shopping';
      case ExpenseCategory.entertainment: return 'entertainment';
      case ExpenseCategory.health:        return 'health';
      case ExpenseCategory.utilities:     return 'rpt_bills';
      case ExpenseCategory.bills:         return 'rpt_bills';
      case ExpenseCategory.other:         return 'rpt_other';
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.food:          return AppColors.categoryFood;
      case ExpenseCategory.transport:     return AppColors.categoryTransport;
      case ExpenseCategory.shopping:      return const Color(0xFF9C27B0);
      case ExpenseCategory.entertainment: return const Color(0xFFE91E8C);
      case ExpenseCategory.health:        return const Color(0xFF00BCD4);
      case ExpenseCategory.utilities:     return AppColors.warning;
      case ExpenseCategory.bills:         return AppColors.warning;
      case ExpenseCategory.other:         return AppColors.textTertiary;
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.food:          return Icons.fastfood_rounded;
      case ExpenseCategory.transport:     return Icons.directions_car_filled_rounded;
      case ExpenseCategory.shopping:      return Icons.shopping_bag_rounded;
      case ExpenseCategory.entertainment: return Icons.play_circle_fill_rounded;
      case ExpenseCategory.health:        return Icons.medical_services_rounded;
      case ExpenseCategory.utilities:     return Icons.bolt_rounded;
      case ExpenseCategory.bills:         return Icons.receipt_long_rounded;
      case ExpenseCategory.other:         return Icons.category_rounded;
    }
  }

  String get emoji {
    switch (this) {
      case ExpenseCategory.food:          return '🍔';
      case ExpenseCategory.transport:     return '🚗';
      case ExpenseCategory.shopping:      return '🛍️';
      case ExpenseCategory.entertainment: return '🎬';
      case ExpenseCategory.health:        return '💊';
      case ExpenseCategory.utilities:     return '⚡';
      case ExpenseCategory.bills:         return '📄';
      case ExpenseCategory.other:         return '📦';
    }
  }
}

// ── Income types ───────────────────────────────────────────────────────────────
enum IncomeType { salary, business, freelancing, investment, rental, interest, other }

extension IncomeTypeProps on IncomeType {
  String get labelKey {
    switch (this) {
      case IncomeType.salary:      return 'salary';
      case IncomeType.business:    return 'business';
      case IncomeType.freelancing: return 'freelancing';
      case IncomeType.investment:  return 'investment';
      case IncomeType.rental:      return 'rental';
      case IncomeType.interest:    return 'interest';
      case IncomeType.other:       return 'rpt_other';
    }
  }

  Color get color {
    switch (this) {
      case IncomeType.salary:      return AppColors.categoryShopping;
      case IncomeType.business:    return const Color(0xFF9C27B0);
      case IncomeType.freelancing: return AppColors.categoryTransport;
      case IncomeType.investment:  return AppColors.warning;
      case IncomeType.rental:      return const Color(0xFF00BCD4);
      case IncomeType.interest:    return const Color(0xFFE91E8C);
      case IncomeType.other:       return AppColors.textTertiary;
    }
  }

  IconData get icon {
    switch (this) {
      case IncomeType.salary:      return Icons.work_rounded;
      case IncomeType.business:    return Icons.business_center_rounded;
      case IncomeType.freelancing: return Icons.laptop_rounded;
      case IncomeType.investment:  return Icons.trending_up_rounded;
      case IncomeType.rental:      return Icons.home_rounded;
      case IncomeType.interest:    return Icons.account_balance_rounded;
      case IncomeType.other:       return Icons.category_rounded;
    }
  }
}

// ── Currency ──────────────────────────────────────────────────────────────────
enum TxCurrency { sar, usd, eur, aed, kwd }

extension TxCurrencyLabel on TxCurrency {
  String get labelKey {
    switch (this) {
      case TxCurrency.sar: return 'SAR';
      case TxCurrency.usd: return 'USD';
      case TxCurrency.eur: return 'EUR';
      case TxCurrency.aed: return 'AED';
      case TxCurrency.kwd: return 'KWD';
    }
  }
}

// ── Payment methods ───────────────────────────────────────────────────────────
enum PaymentMethod { bankTransfer, cash, online }

// ── AI extraction result ──────────────────────────────────────────────────────
class AiExtractionResult {
  final double? amount;
  final String? merchant;
  final ExpenseCategory? category;
  final DateTime? date;
  final String? note;
  final int? lineItemCount;

  const AiExtractionResult({
    this.amount,
    this.merchant,
    this.category,
    this.date,
    this.note,
    this.lineItemCount,
  });
}

// ── Mock AI results ───────────────────────────────────────────────────────────
class MockAiData {
  // Simulated voice extraction for "Spent 45 riyals on lunch at McDonald's"
  static const AiExtractionResult voiceResult = AiExtractionResult(
    amount: 45,
    merchant: "McDonald's",
    category: ExpenseCategory.food,
    lineItemCount: null,
  );

  // Simulated receipt scan extraction
  static const AiExtractionResult receiptResult = AiExtractionResult(
    amount: 245,
    merchant: "McDonald's",
    category: ExpenseCategory.food,
    lineItemCount: 4,
    note: "Big Mac Meal, McChicken, Cola Lg, Fries Lg",
  );
}
