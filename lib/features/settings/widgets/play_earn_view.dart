// lib/features/ai_coach/view/play_earn_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// "Play & Earn AI Credits" screen — gamified productivity screen.
// Accessible from Settings → Play & Earn, or from Coach screen credits badge.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/font_size_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../routes/app_routes.dart';
import '../../coach/controller/ai_credits_controller.dart';
import '../../coach/models/ai_credits_model.dart';
import '../../subscription/controller/subscription_controller.dart';

class PlayEarnView extends StatelessWidget {
  const PlayEarnView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fs = context.fs;
    final ctrl = AiCreditsController.to;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFFFF6B35),
            leading: GestureDetector(
              onTap: Get.back,
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _HeaderBanner(ctrl: ctrl, fs: fs),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Daily Bonus ────────────────────────────────────────
                _DailyBonusCard(ctrl: ctrl, isDark: isDark, fs: fs),
                const SizedBox(height: 20),

                // ── Mini-Games Section ────────────────────────────────
                _SectionTitle(title: '🎮 Mini-Games', isDark: isDark, fs: fs),
                const SizedBox(height: 12),
                ...ctrl.games.map((game) => _GameCard(
                      game: game,
                      ctrl: ctrl,
                      isDark: isDark,
                      fs: fs,
                    )),

                const SizedBox(height: 20),

                // ── Engagement Activities ──────────────────────────────
                _SectionTitle(
                    title: '✅ Daily Activities', isDark: isDark, fs: fs),
                const SizedBox(height: 12),
                _ActivityCard(
                  emoji: '📸',
                  title: 'Scan a Receipt',
                  subtitle: 'Use AI receipt scanner',
                  credits: 5,
                  isDark: isDark,
                  fs: fs,
                  onTap: () => Get.toNamed('/add-transaction'),
                ),
                _ActivityCard(
                  emoji: '🎯',
                  title: 'Set a Budget Goal',
                  subtitle: 'Create or update a category budget',
                  credits: 8,
                  isDark: isDark,
                  fs: fs,
                  onTap: () {},
                ),
                _ActivityCard(
                  emoji: '📊',
                  title: 'Review Weekly Spending',
                  subtitle: 'Open your reports tab',
                  credits: 5,
                  isDark: isDark,
                  fs: fs,
                  onTap: () => Get.back(),
                ),

                const SizedBox(height: 20),

                // ── Credit History ─────────────────────────────────────
                _SectionTitle(
                    title: '📜 Credit History', isDark: isDark, fs: fs),
                const SizedBox(height: 12),
                Obx(() => Column(
                      children: ctrl.history
                          .take(5)
                          .map((a) =>
                              _HistoryRow(activity: a, isDark: isDark, fs: fs))
                          .toList(),
                    )),

                const SizedBox(height: AppSpacing.xxxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header Banner ──────────────────────────────────────────────────────────────
class _HeaderBanner extends StatelessWidget {
  final AiCreditsController ctrl;
  final FontSizeController fs;
  const _HeaderBanner({required this.ctrl, required this.fs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B35), Color(0xFFFF4500)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text('⚡', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              'Play & Earn AI Credits',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fs.scaled(20),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Obx(() => Text(
                  'Balance: ${ctrl.balance.value} credits',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fs.scaled(14),
                    color: Colors.white70,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// ── Daily Bonus Card ───────────────────────────────────────────────────────────
class _DailyBonusCard extends StatelessWidget {
  final AiCreditsController ctrl;
  final bool isDark;
  final FontSizeController fs;
  const _DailyBonusCard(
      {required this.ctrl, required this.isDark, required this.fs});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final claimed = ctrl.claimedDailyBonus.value;
      final streak = ctrl.dailyStreak.value;
      final bonus = 10 + (streak * 2);

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: claimed
                ? [Colors.grey.shade300, Colors.grey.shade200]
                : [const Color(0xFFFFC947), const Color(0xFFFF8C5A)],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: claimed
                  ? Colors.transparent
                  : const Color(0xFFFF8C5A).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔥 Day $streak Streak!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fs.scaled(16),
                    fontWeight: FontWeight.w700,
                    color: claimed ? Colors.grey : Colors.white,
                  ),
                ),
                Text(
                  claimed ? 'Come back tomorrow!' : 'Claim your daily bonus',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fs.scaled(12),
                    color: claimed
                        ? Colors.grey.shade600
                        : Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: claimed ? null : ctrl.claimDailyBonus,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: claimed
                      ? Colors.grey.shade400
                      : Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white38),
                ),
                child: Text(
                  claimed ? '✓ Claimed' : '+$bonus ⚡',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fs.scaled(13),
                    fontWeight: FontWeight.w700,
                    color: claimed ? Colors.grey.shade700 : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ── Game Card ──────────────────────────────────────────────────────────────────
class _GameCard extends StatelessWidget {
  final MiniGameModel game;
  final AiCreditsController ctrl;
  final bool isDark;
  final FontSizeController fs;

  const _GameCard(
      {required this.game,
      required this.ctrl,
      required this.isDark,
      required this.fs});

  @override
  Widget build(BuildContext context) {
    final sub = Get.find<SubscriptionController>();
    final locked = game.isPremiumOnly && !sub.isPremium;

    return Obx(() {
      // Force rebuild when game list updates
      final canPlay = game.canPlay && !locked;

      return GestureDetector(
        onTap: () async {
          if (locked) {
            Get.toNamed(AppRoutes.subscription);
            return;
          }
          if (!canPlay) return;
          if (game.id == 'hen_blitz') {
            // Navigate to the actual HenBlitz game; award credits on return
            await Get.toNamed(AppRoutes.henBlitz);
            ctrl.earnCredits(
              amount: game.creditsReward,
              description: 'Completed Hen Blitz',
              gameId: game.id,
            );
            return;
          }
          // Simulate completion for other mini-games
          await Future.delayed(const Duration(milliseconds: 500));
          ctrl.earnCredits(
            amount: game.creditsReward,
            description: 'Completed ${_resolveTitle(game.titleKey)}',
            gameId: game.id,
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: isDark
                ? null
                : [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
          ),
          child: Row(
            children: [
              // Emoji icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(game.emoji,
                      style: TextStyle(fontSize: fs.scaled(24))),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _resolveTitle(game.titleKey),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: fs.scaled(14),
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (locked) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'PRO',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: fs.scaled(9),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFB8860B),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      _resolveDesc(game.descriptionKey),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: fs.scaled(11),
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    if (!canPlay && !locked) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Available in ${game.remainingCooldown.inMinutes}m',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: fs.scaled(10),
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Credits badge + CTA
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: canPlay
                      ? const Color(0xFFFF6B35)
                      : (isDark ? Colors.white10 : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  canPlay
                      ? '+${game.creditsReward} ⚡'
                      : locked
                          ? '🔒'
                          : '⏳',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fs.scaled(12),
                    fontWeight: FontWeight.w700,
                    color: canPlay
                        ? Colors.white
                        : (isDark ? Colors.white38 : Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _resolveTitle(String key) {
    const map = {
      'game_budget_quiz': 'Budget Quiz',
      'game_hen_blitz': 'Hen Blitz',
      'game_savings_challenge': 'Savings Challenge',
      'game_expense_trivia': 'Expense Trivia',
      'game_streak_bonus': 'Streak Bonus',
    };
    return map[key] ?? key;
  }

  String _resolveDesc(String key) {
    const map = {
      'game_budget_quiz_desc': 'Answer 5 budget questions',
      'game_hen_blitz_desc': 'Play the SpendSmart game',
      'game_savings_challenge_desc': 'Complete a savings micro-task',
      'game_expense_trivia_desc': 'Advanced financial trivia',
      'game_streak_bonus_desc': 'Maintain your daily streak',
    };
    return map[key] ?? key;
  }
}

// ── Activity Card ──────────────────────────────────────────────────────────────
class _ActivityCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final int credits;
  final bool isDark;
  final FontSizeController fs;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.credits,
    required this.isDark,
    required this.fs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border:
              Border.all(color: isDark ? Colors.white10 : Colors.transparent),
          boxShadow: isDark
              ? null
              : [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: fs.scaled(22))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: fs.scaled(13),
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary)),
                  Text(subtitle,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: fs.scaled(11),
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+$credits ⚡',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fs.scaled(11),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF6B35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── History Row ────────────────────────────────────────────────────────────────
class _HistoryRow extends StatelessWidget {
  final AiCreditActivity activity;
  final bool isDark;
  final FontSizeController fs;

  const _HistoryRow(
      {required this.activity, required this.isDark, required this.fs});

  @override
  Widget build(BuildContext context) {
    final isEarned = activity.amount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow:
            isDark ? null : [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Text(isEarned ? '⚡' : '💎',
              style: TextStyle(fontSize: fs.scaled(16))),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              activity.description,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fs.scaled(12),
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '${isEarned ? '+' : ''}${activity.amount}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fs.scaled(13),
              fontWeight: FontWeight.w700,
              color: isEarned ? const Color(0xFF22C55E) : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Title ──────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  final FontSizeController fs;
  const _SectionTitle(
      {required this.title, required this.isDark, required this.fs});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: fs.scaled(15),
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
    );
  }
}
