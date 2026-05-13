// lib/features/coach/view/coach_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// Coach tab — Hen Blitz game hub integrated into SpendSmart.
// No Scaffold — lives inside the outer Scaffold from MainNavigation.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spend_smart/core/constants/app_colors.dart';
import 'package:spend_smart/core/constants/app_spacing.dart';
import 'package:spend_smart/core/constants/app_text_styles.dart';
import 'package:spend_smart/features/game/controller/game_controller.dart';
import 'package:spend_smart/routes/app_routes.dart';

class CoachView extends StatefulWidget {
  const CoachView({super.key});
  @override
  State<CoachView> createState() => _CoachViewState();
}

class _CoachViewState extends State<CoachView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final GameController _gc;

  @override
  void initState() {
    super.initState();
    _gc = Get.put<GameController>(GameController(), permanent: false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverToBoxAdapter(
          child: _GameHeroBanner(gc: _gc),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding, AppSpacing.lg,
              AppSpacing.pagePadding, AppSpacing.xxxl),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text('HEN GUIDE',
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: cs.onBackground.withOpacity(0.45))),
              const SizedBox(height: AppSpacing.md),
              _GuideCard(emoji: '🐔', title: 'Hen States',
                subtitle: 'How your finances power her',
                color: const Color(0xFFFF9500),
                onTap: () => Get.toNamed(AppRoutes.henStates)),
              const SizedBox(height: AppSpacing.sm),
              _GuideCard(emoji: '🥚', title: 'Egg Guide',
                subtitle: 'Collect eggs, earn coins',
                color: const Color(0xFFFFD700),
                onTap: () => Get.toNamed(AppRoutes.eggGuide)),
              const SizedBox(height: AppSpacing.sm),
              _GuideCard(emoji: '⚡', title: 'Threats',
                subtitle: 'Six things that stop her',
                color: const Color(0xFFFF3B30),
                onTap: () => Get.toNamed(AppRoutes.threatsGuide)),
              const SizedBox(height: AppSpacing.xxl),
              Obx(() {
                final best = _gc.personalBest.value;
                if (best == 0) return const SizedBox.shrink();
                return _PersonalBestCard(bestDistance: best, isDark: isDark);
              }),
            ]),
          ),
        ),
      ],
    );
  }
}

class _GameHeroBanner extends StatelessWidget {
  final GameController gc;
  const _GameHeroBanner({required this.gc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.pagePadding),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFE8B45A), Color(0xFFAD6A18)]),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [BoxShadow(
          color: const Color(0xFFE8B45A).withOpacity(0.30),
          blurRadius: 16, offset: const Offset(0, 6))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20)),
              child: const Text('🐔  HEN BLITZ',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
                  fontWeight: FontWeight.w800, color: Colors.white,
                  letterSpacing: 0.5))),
            const Spacer(),
            const Text('🐔', style: TextStyle(fontSize: 52)),
          ]),
          const SizedBox(height: 10),
          const Text('Your hen runs on\nyour real finances.',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 22,
              fontWeight: FontWeight.w800, color: Colors.white, height: 1.2)),
          const SizedBox(height: 6),
          const Text('Spend less → run faster',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13,
              color: Colors.white70)),
          const SizedBox(height: 16),
          Obx(() {
            final canPlay = gc.canPlayToday;
            return GestureDetector(
              onTap: canPlay
                  ? () => Get.toNamed(AppRoutes.henBlitz)
                  : () => Get.toNamed(AppRoutes.subscription),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: canPlay ? const Color(0xFFFF6B35) : Colors.black38,
                  borderRadius: BorderRadius.circular(30)),
                child: Center(child: Text(
                  canPlay ? '▶  PLAY NOW' : '🔒  UPGRADE TO PLAY MORE',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 15,
                    fontWeight: FontWeight.w800, color: Colors.white,
                    letterSpacing: 0.5)))));
          }),
        ],
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _GuideCard({required this.emoji, required this.title,
    required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: isDark ? null : [BoxShadow(color: AppColors.shadow, blurRadius: 8)]),
        child: Row(children: [
          Container(width: 44, height: 44,
            decoration: BoxDecoration(color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.labelLarge.copyWith(
              fontSize: 14, color: cs.onBackground)),
            Text(subtitle, style: AppTextStyles.bodySmall.copyWith(
              fontSize: 12, color: cs.onBackground.withOpacity(0.50))),
          ])),
          Icon(Icons.chevron_right_rounded,
            color: cs.onBackground.withOpacity(0.30), size: 20),
        ]),
      ),
    );
  }
}

class _PersonalBestCard extends StatelessWidget {
  final int bestDistance;
  final bool isDark;
  const _PersonalBestCard({required this.bestDistance, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: isDark ? null : [BoxShadow(color: AppColors.shadow, blurRadius: 8)]),
      child: Row(children: [
        const Text('🏆', style: TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Personal Best', style: AppTextStyles.bodySmall.copyWith(
            fontSize: 12, color: cs.onBackground.withOpacity(0.50))),
          Text('$bestDistance m', style: AppTextStyles.amountMedium.copyWith(
            fontSize: 20, color: const Color(0xFFFFD700),
            fontWeight: FontWeight.w800)),
        ])),
        TextButton(
          onPressed: () => Get.toNamed(AppRoutes.henBlitz),
          child: const Text('▶ Beat it', style: TextStyle(
            fontFamily: 'Poppins', fontWeight: FontWeight.w700,
            color: Color(0xFFFF6B35)))),
      ]),
    );
  }
}
