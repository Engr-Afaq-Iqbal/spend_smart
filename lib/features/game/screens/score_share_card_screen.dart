// lib/features/game/screens/score_share_card_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
// Full-screen shareable score card — matches the HEN BLITZ share design.
// Shows distance, egg counts, streak, rank, and share CTA.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spend_smart/features/game/models/game_models.dart';

class ScoreShareCardScreen extends StatelessWidget {
  final GameResult result;
  final UserFinancialProfile profile;

  const ScoreShareCardScreen({
    super.key,
    required this.result,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1000),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white70),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              // In production: use share_plus to share the card as image
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.share_rounded, color: Color(0xFFFF6B35)),
            label: const Text('Share',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Color(0xFFFF6B35))),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _ShareCard(result: result, profile: profile),
        ),
      ),
    );
  }
}

class _ShareCard extends StatelessWidget {
  final GameResult result;
  final UserFinancialProfile profile;
  const _ShareCard({required this.result, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8B45A), Color(0xFFC67C2A), Color(0xFF7A4A1A)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.50),
            blurRadius: 30, offset: const Offset(0, 8)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.30),
                    borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🐔', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 6),
                      Text('HEN BLITZ',
                        style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white, letterSpacing: 1)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hen emoji
            const Text('🐔', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 8),

            // Distance label
            const Text('DISTANCE',
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white60, letterSpacing: 1)),
            const SizedBox(height: 4),

            // Distance number
            Text(
              _fmtNum(result.distanceMeters),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: Color(0xFFFFD700),
                height: 1.0,
                shadows: [Shadow(blurRadius: 20, color: Color(0x80000000))],
              ),
            ),
            const SizedBox(height: 4),

            // Egg breakdown row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...EggType.values.map((t) {
                  final count = result.eggsCollected[t] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(_emojiForEgg(t),
                          style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 2),
                        Text('×$count',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: count > 0
                                ? Colors.white
                                : Colors.white38)),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Streak + Rank row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        const Text('STREAK',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF6B35), letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🔥',
                              style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 4),
                            Text('${profile.currentStreak} days',
                              style: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12)),
                    child: const Column(
                      children: [
                        Text('JEDDAH RANK',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white60, letterSpacing: 1)),
                        SizedBox(height: 4),
                        Text('#3 this week',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // CTA bottom
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.30),
                borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Text(
                    'Can you beat ${profile.petName}?',
                    style: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 14,
                      fontWeight: FontWeight.w700, color: Colors.white)),
                  const Text(
                    'Download Hen Blitz · Free on iOS & Android',
                    style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 11,
                      color: Colors.white60)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Date / handle row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${result.sessionStart.year}-'
                  '${result.sessionStart.month.toString().padLeft(2, '0')}-'
                  '${result.sessionStart.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontFamily: 'Poppins', fontSize: 10,
                    color: Colors.white38)),
                const Text('@henblitz',
                  style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 10,
                    color: Colors.white38)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmtNum(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  String _emojiForEgg(EggType t) {
    return switch (t) {
      EggType.cracked  => '🥚',
      EggType.silver   => '🪨',
      EggType.gold     => '🌕',
      EggType.diamond  => '💎',
      EggType.rainbow  => '🌈',
    };
  }
}
