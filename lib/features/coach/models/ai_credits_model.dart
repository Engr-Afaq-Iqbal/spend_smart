// lib/features/ai_coach/model/ai_credits_model.dart
// ─────────────────────────────────────────────────────────────────────────────
// Domain models for the AI Credits system.
// Backend-ready: all fields map 1-to-1 to Firestore/REST schema.
// ─────────────────────────────────────────────────────────────────────────────

enum CreditActivityType {
  earned,   // from games, engagement
  spent,    // used for AI features
  purchased, // from IAP
  bonus,    // promotions / referral
}

enum AiFeature {
  basicChat,
  advancedInsight,
  monthlyReport,
  yearlyReport,
  pdfExport,
  chartAnalysis,
}

class AiCreditActivity {
  final String id;
  final CreditActivityType type;
  final int amount;
  final String description;
  final DateTime timestamp;
  final AiFeature? feature;

  const AiCreditActivity({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    this.feature,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'amount': amount,
        'description': description,
        'timestamp': timestamp.toIso8601String(),
        'feature': feature?.name,
      };
}

class MiniGameModel {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String emoji;
  final int creditsReward;
  final int cooldownMinutes;
  final bool isPremiumOnly;
  final DateTime? lastPlayedAt;

  const MiniGameModel({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.emoji,
    required this.creditsReward,
    required this.cooldownMinutes,
    this.isPremiumOnly = false,
    this.lastPlayedAt,
  });

  bool get canPlay {
    if (lastPlayedAt == null) return true;
    final elapsed = DateTime.now().difference(lastPlayedAt!);
    return elapsed.inMinutes >= cooldownMinutes;
  }

  Duration get remainingCooldown {
    if (canPlay) return Duration.zero;
    final elapsed = DateTime.now().difference(lastPlayedAt!);
    return Duration(minutes: cooldownMinutes - elapsed.inMinutes);
  }
}

/// Feature credit costs — production: fetch from remote config
class CreditCosts {
  static const int basicChat = 0;
  static const int advancedInsight = 5;
  static const int monthlyReport = 20;
  static const int yearlyReport = 50;
  static const int pdfExport = 30;
  static const int chartAnalysis = 10;

  static int forFeature(AiFeature feature) {
    switch (feature) {
      case AiFeature.basicChat:
        return basicChat;
      case AiFeature.advancedInsight:
        return advancedInsight;
      case AiFeature.monthlyReport:
        return monthlyReport;
      case AiFeature.yearlyReport:
        return yearlyReport;
      case AiFeature.pdfExport:
        return pdfExport;
      case AiFeature.chartAnalysis:
        return chartAnalysis;
    }
  }
}

/// Mock catalogue of mini-games / engagement activities
class MiniGamesCatalogue {
  static final List<MiniGameModel> games = [
    const MiniGameModel(
      id: 'budget_quiz',
      titleKey: 'game_budget_quiz',
      descriptionKey: 'game_budget_quiz_desc',
      emoji: '🧠',
      creditsReward: 15,
      cooldownMinutes: 60,
    ),
    const MiniGameModel(
      id: 'hen_blitz',
      titleKey: 'game_hen_blitz',
      descriptionKey: 'game_hen_blitz_desc',
      emoji: '🐔',
      creditsReward: 25,
      cooldownMinutes: 1440, // 24 hrs
    ),
    const MiniGameModel(
      id: 'savings_challenge',
      titleKey: 'game_savings_challenge',
      descriptionKey: 'game_savings_challenge_desc',
      emoji: '💰',
      creditsReward: 10,
      cooldownMinutes: 30,
    ),
    const MiniGameModel(
      id: 'expense_trivia',
      titleKey: 'game_expense_trivia',
      descriptionKey: 'game_expense_trivia_desc',
      emoji: '📊',
      creditsReward: 20,
      cooldownMinutes: 120,
      isPremiumOnly: true,
    ),
    const MiniGameModel(
      id: 'streak_bonus',
      titleKey: 'game_streak_bonus',
      descriptionKey: 'game_streak_bonus_desc',
      emoji: '🔥',
      creditsReward: 30,
      cooldownMinutes: 1440,
    ),
  ];
}
