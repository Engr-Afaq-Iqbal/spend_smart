// lib/screens/egg_guide_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
// Route: /game/egg-guide
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:spend_smart/features/game/models/game_models.dart';

class EggGuideScreen extends StatelessWidget {
  const EggGuideScreen({super.key});

  static const List<_EggEntry> _eggs = [
    _EggEntry(
      type: EggType.cracked,
      name: 'Cracked Egg',
      rarity: 'COMMON',
      rarityColor: Color(0xFF8B7355),
      dropRate: 0.68,
      reward: 1,
      powerUpLabel: null,
    ),
    _EggEntry(
      type: EggType.silver,
      name: 'Silver Egg',
      rarity: 'UNCOMMON',
      rarityColor: Color(0xFF607D8B),
      dropRate: 0.25,
      reward: 5,
      powerUpLabel: null,
    ),
    _EggEntry(
      type: EggType.gold,
      name: 'Gold Egg',
      rarity: 'RARE',
      rarityColor: Color(0xFFD4A017),
      dropRate: 0.12,
      reward: 15,
      powerUpLabel: '×2 MULTIPLIER',
      powerUpColor: Color(0xFFFFD700),
    ),
    _EggEntry(
      type: EggType.diamond,
      name: 'Diamond Egg',
      rarity: 'EPIC',
      rarityColor: Color(0xFF5B8DEF),
      dropRate: 0.025,
      reward: 50,
      powerUpLabel: 'SHIELD · 3s',
      powerUpColor: Color(0xFF5B8DEF),
    ),
    _EggEntry(
      type: EggType.rainbow,
      name: 'Rainbow\nEgg',
      rarity: 'LEGENDARY',
      rarityColor: Color(0xFFFF69B4),
      dropRate: 0.005,
      reward: 100,
      powerUpLabel: 'MAGNET 8s · ×5',
      powerUpColor: Color(0xFFFF69B4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.08),
                        shape: BoxShape.circle),
                      child: const Icon(Icons.chevron_left, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('HEN GUIDE · EGGS',
                    style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B5C3A), letterSpacing: 1)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Text('Collect eggs.\nEarn coins.',
                style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 28,
                  fontWeight: FontWeight.w900, color: Color(0xFF1A1D2E),
                  height: 1.2)),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: Text('Rare eggs unlock power-ups. Stack them mid-run.',
                style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 13,
                  color: Color(0xFF6B7280))),
            ),
            const SizedBox(height: 16),

            // Column header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('5 EGG TYPES',
                    style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6B7280), letterSpacing: 0.5)),
                  Text('RARITY · REWARD',
                    style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7280), letterSpacing: 0.5)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Egg list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _eggs.length,
                itemBuilder: (_, i) => _EggCard(entry: _eggs[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EggCard extends StatelessWidget {
  final _EggEntry entry;
  const _EggCard({required this.entry});

  static const Map<EggType, String> _emojis = {
    EggType.cracked:  '🥚',
    EggType.silver:   '🪨',
    EggType.gold:     '🌕',
    EggType.diamond:  '💎',
    EggType.rainbow:  '🌈',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05),
              blurRadius: 6, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Egg illustration
          SizedBox(
            width: 60, height: 72,
            child: Center(
              child: Text(_emojis[entry.type] ?? '🥚',
                style: const TextStyle(fontSize: 46)),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(entry.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D2E))),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: entry.rarityColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6)),
                    child: Text(entry.rarity,
                      style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: entry.rarityColor)),
                  ),
                ]),
                const SizedBox(height: 5),

                // Power-up badge if applicable
                if (entry.powerUpLabel != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: entry.powerUpColor!.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8)),
                    child: Text(entry.powerUpLabel!,
                      style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: entry.powerUpColor)),
                  ),
                  const SizedBox(height: 5),
                ],

                // Rarity bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: entry.dropRate,
                    minHeight: 4,
                    backgroundColor: Colors.black.withOpacity(0.06),
                    valueColor: AlwaysStoppedAnimation(entry.rarityColor),
                  ),
                ),
                const SizedBox(height: 3),
                Text('${(entry.dropRate * 100).toStringAsFixed(1)}% drop rate',
                  style: const TextStyle(
                    fontFamily: 'Poppins', fontSize: 10,
                    color: Color(0xFF6B7280))),
              ],
            ),
          ),

          // Reward badge
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              shape: BoxShape.circle),
            child: Center(
              child: Text('+${entry.reward}',
                style: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 13,
                  fontWeight: FontWeight.w900, color: Colors.white))),
          ),
        ],
      ),
    );
  }
}

class _EggEntry {
  final EggType type;
  final String name;
  final String rarity;
  final Color rarityColor;
  final double dropRate;
  final int reward;
  final String? powerUpLabel;
  final Color? powerUpColor;
  const _EggEntry({
    required this.type, required this.name, required this.rarity,
    required this.rarityColor, required this.dropRate, required this.reward,
    this.powerUpLabel, this.powerUpColor,
  });
}
