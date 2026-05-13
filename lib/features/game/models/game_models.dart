// lib/game/models/game_models.dart
// ─────────────────────────────────────────────────────────────────────────────
// Pure data models — no Flutter/Flame imports. Fully unit-testable.
// ─────────────────────────────────────────────────────────────────────────────

// ── Enums ─────────────────────────────────────────────────────────────────────

enum HenState { saver, balanced, spender, overspend, broke }

enum Lane { left, center, right }

enum EggType { cracked, silver, gold, diamond, rainbow }

enum ObstacleType {
  creditCard,
  shoppingBoxes,
  billTornado,
  subscriptionSnake,
  taxBoulder,
  foxThief,
}

enum PowerUpType { magnet, speedBoost, multiplier, shield, featherFloat }

enum HenAnimation { run, jump, slide, hurt, idle }

// ── UserFinancialProfile ──────────────────────────────────────────────────────
class UserFinancialProfile {
  final double monthlyIncome;
  final double monthlyExpenses;
  final int currentStreak;
  final bool isPro;
  final String petName;

  const UserFinancialProfile({
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.currentStreak,
    required this.isPro,
    required this.petName,
  });

  /// Expense-to-income ratio, clamped to [0.0, 2.0]
  double get ratio => (monthlyExpenses / monthlyIncome).clamp(0.0, 2.0);

  /// Base horizontal move speed in world units/s.
  /// Saver=300, Balanced=230, Spender=175, Overspend=120, Broke=70
  double get henSpeed => (300.0 - ratio * 190.0).clamp(70.0, 300.0);

  /// Visual scale applied to the hen sprite (0.7 = slim saver, 1.9 = fat broke)
  double get henBodyScale => (0.7 + ratio * 0.6).clamp(0.7, 1.9);

  /// Upward impulse velocity when the hen jumps
  double get jumpForce => (550.0 - ratio * 280.0).clamp(80.0, 550.0);

  /// Seconds to complete a lane switch (lower = snappier)
  double get laneSpeed => (0.15 + ratio * 0.25).clamp(0.15, 0.45);

  /// Hitbox is slightly smaller than the visual body
  double get hitboxScale => henBodyScale * 0.85;

  /// Derived hen state used for UI labels and colour theming
  HenState get state {
    if (ratio < 0.4) return HenState.saver;
    if (ratio < 0.6) return HenState.balanced;
    if (ratio < 0.8) return HenState.spender;
    if (ratio < 1.0) return HenState.overspend;
    return HenState.broke;
  }

  String get stateLabel {
    switch (state) {
      case HenState.saver:     return 'SAVER';
      case HenState.balanced:  return 'BALANCED';
      case HenState.spender:   return 'SPENDER';
      case HenState.overspend: return 'OVERSPEND';
      case HenState.broke:     return 'BROKE';
    }
  }

  /// Demo / default profile used when no real data is available
  static const UserFinancialProfile demo = UserFinancialProfile(
    monthlyIncome: 12000,
    monthlyExpenses: 7200,
    currentStreak: 14,
    isPro: false,
    petName: 'Nugget',
  );
}

// ── GameResult ────────────────────────────────────────────────────────────────
class GameResult {
  final int distanceMeters;
  final int finalScore;
  final int coinsEarned;
  final Map<EggType, int> eggsCollected;
  final ObstacleType? killedBy;
  final String sessionHash;
  final DateTime sessionStart;
  final DateTime sessionEnd;

  const GameResult({
    required this.distanceMeters,
    required this.finalScore,
    required this.coinsEarned,
    required this.eggsCollected,
    this.killedBy,
    required this.sessionHash,
    required this.sessionStart,
    required this.sessionEnd,
  });

  /// 10 coins = 1 AI credit for the parent SpendSmart app
  int get aiCreditsEarned => coinsEarned ~/ 10;

  int get durationSeconds =>
      sessionEnd.difference(sessionStart).inSeconds;
}

// ── Static finance tips ───────────────────────────────────────────────────────
class FinanceTips {
  static const Map<ObstacleType, String> tips = {
    ObstacleType.creditCard:
        'Credit card debt charges 24% annual interest. Paying it off saves more than any investment.',
    ObstacleType.shoppingBoxes:
        'Impulse purchases add up fast. The 24-hour rule: wait a day before buying anything over SAR 50.',
    ObstacleType.billTornado:
        'Set up auto-pay for recurring bills to never miss a payment again.',
    ObstacleType.subscriptionSnake:
        'Review your subscriptions monthly. The average person pays for 3 they\'ve forgotten about.',
    ObstacleType.taxBoulder:
        'Set aside 10% of freelance income throughout the year so tax season doesn\'t surprise you.',
    ObstacleType.foxThief:
        'Never share banking credentials. Enable 2FA on all financial accounts today.',
  };

  static String tipFor(ObstacleType? type) =>
      type != null ? tips[type] ?? '' : '';
}

// ── Obstacle display names ────────────────────────────────────────────────────
class ObstacleNames {
  static const Map<ObstacleType, String> names = {
    ObstacleType.creditCard:       'Credit Card Wall',
    ObstacleType.shoppingBoxes:    'Shopping Avalanche',
    ObstacleType.billTornado:      'Bill Tornado',
    ObstacleType.subscriptionSnake:'Subscription Snake',
    ObstacleType.taxBoulder:       'Tax Boulder',
    ObstacleType.foxThief:         'Fox Thief',
  };

  static String nameFor(ObstacleType type) => names[type] ?? '';
}

// ── Egg coin values & display names ──────────────────────────────────────────
class EggData {
  static const Map<EggType, int> coinValues = {
    EggType.cracked:  1,
    EggType.silver:   5,
    EggType.gold:    15,
    EggType.diamond: 50,
    EggType.rainbow:100,
  };

  static const Map<EggType, String> names = {
    EggType.cracked:  'Cracked',
    EggType.silver:   'Silver',
    EggType.gold:     'Gold',
    EggType.diamond:  'Diamond',
    EggType.rainbow:  'Rainbow',
  };

  static const Map<EggType, String> rarityLabel = {
    EggType.cracked:  'COMMON',
    EggType.silver:   'UNCOMMON',
    EggType.gold:     'RARE',
    EggType.diamond:  'EPIC',
    EggType.rainbow:  'LEGENDARY',
  };

  static const Map<EggType, double> dropRate = {
    EggType.cracked:  0.68,
    EggType.silver:   0.25,
    EggType.gold:     0.12,
    EggType.diamond:  0.025,
    EggType.rainbow:  0.005,
  };

  static const Map<EggType, String> spriteName = {
    EggType.cracked:  'egg_cracked.png',
    EggType.silver:   'egg_silver.png',
    EggType.gold:     'egg_gold.png',
    EggType.diamond:  'egg_diamond.png',
    EggType.rainbow:  'egg_rainbow.png',
  };
}
