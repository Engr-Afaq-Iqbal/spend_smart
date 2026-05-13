// lib/game/overlays/hud_overlay.dart
// ─────────────────────────────────────────────────────────────────────────────
// In-game HUD overlay. Uses ValueListenableBuilder exclusively — zero setState
// during the game loop. Matches the screenshot exactly.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spend_smart/features/game/components/hen_blitz_game.dart';
import 'package:spend_smart/features/game/models/game_models.dart';

class HudOverlay extends StatelessWidget {
  final HenBlitzGame game;

  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ── Top stats bar ────────────────────────────────────────────────
          _TopBar(game: game),
          const SizedBox(height: 8),

          // ── Hearts row + state badge ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hearts
                ValueListenableBuilder<int>(
                  valueListenable: game.heartsNotifier,
                  builder: (_, h, __) => Row(
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          i < h ? '❤️' : '🖤',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Hen state badge
                _StateBadge(state: game.profile.state),
              ],
            ),
          ),

          const Spacer(),

          // ── Bottom directional controls ──────────────────────────────────
          _BottomControls(game: game),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final HenBlitzGame game;
  const _TopBar({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.72),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // 🔥 Streak pill
          _StreakPill(streak: game.profile.currentStreak),
          const SizedBox(width: 10),

          // SPD bar
          Expanded(child: _SpeedBar(speedNotifier: game.speedNotifier)),
          const SizedBox(width: 10),

          // Score
          ValueListenableBuilder<int>(
            valueListenable: game.scoreNotifier,
            builder: (_, score, __) => Text(
              _fmtNum(score),
              style: GoogleFonts.robotoMono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 🪙 Coins
          ValueListenableBuilder<int>(
            valueListenable: game.coinsNotifier,
            builder: (_, coins, __) => _CoinBadge(coins: coins),
          ),
        ],
      ),
    );
  }

  String _fmtNum(int n) {
    if (n >= 1000) {
      final s = n.toString();
      final buf = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return buf.toString();
    }
    return n.toString();
  }
}

class _StreakPill extends StatelessWidget {
  final int streak;
  const _StreakPill({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 3),
          Text(
            '$streak',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedBar extends StatelessWidget {
  final ValueNotifier<double> speedNotifier;
  const _SpeedBar({required this.speedNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: speedNotifier,
      builder: (_, speed, __) {
        final fraction = (speed / 350.0).clamp(0.0, 1.0);
        return Row(
          children: [
            const Text('SPD',
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 10,
                color: Colors.white60, fontWeight: FontWeight.w600)),
            const SizedBox(width: 5),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: fraction,
                  minHeight: 6,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF34C759)),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              speed.toInt().toString(),
              style: const TextStyle(
                fontFamily: 'Poppins', fontSize: 11,
                color: Colors.white70, fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    );
  }
}

class _CoinBadge extends StatelessWidget {
  final int coins;
  const _CoinBadge({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2000),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD700), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 3),
          Text(
            '$coins',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFFD700),
            ),
          ),
        ],
      ),
    );
  }
}

class _StateBadge extends StatelessWidget {
  final HenState state;
  const _StateBadge({required this.state});

  Color get _color => switch (state) {
    HenState.saver     => const Color(0xFF34C759),
    HenState.balanced  => const Color(0xFF20B894),
    HenState.spender   => const Color(0xFFFF9500),
    HenState.overspend => const Color(0xFFFF6B35),
    HenState.broke     => const Color(0xFFFF3B30),
  };

  String get _label => '⚡ ${state.name.toUpperCase()} TODAY';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.90),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Bottom control buttons ────────────────────────────────────────────────────
class _BottomControls extends StatelessWidget {
  final HenBlitzGame game;
  const _BottomControls({required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _CtrlBtn(label: '←', onTap: game.hen.swipeLeft),
            _CtrlBtn(label: '↑', onTap: game.hen.jump, large: true),
            _CtrlBtn(label: '→', onTap: game.hen.swipeRight),
          ],
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: game.hen.slide,
          child: const Text(
            'SLIDE ↓',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: Colors.white54,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _CtrlBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool large;
  const _CtrlBtn({required this.label, required this.onTap, this.large = false});

  @override
  Widget build(BuildContext context) {
    final size = large ? 64.0 : 52.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.60),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: large ? 26 : 22,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
