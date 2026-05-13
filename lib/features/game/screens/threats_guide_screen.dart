// lib/features/game/screens/threats_guide_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
// Route: /game/threats-guide
// Shows all 6 obstacles with descriptions and dodge tips.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:spend_smart/features/game/models/game_models.dart';

class ThreatsGuideScreen extends StatelessWidget {
  const ThreatsGuideScreen({super.key});

  static const List<_ThreatData> _threats = [
    _ThreatData(
      number: '01',
      type: ObstacleType.creditCard,
      emoji: '💳',
      name: 'Credit Card Wall',
      tip: 'Blocks one lane — switch lanes!',
      color: Color(0xFFFF3B30),
    ),
    _ThreatData(
      number: '02',
      type: ObstacleType.shoppingBoxes,
      emoji: '📦',
      name: 'Shopping Avalanche',
      tip: 'Drops randomly — watch the sky!',
      color: Color(0xFFFF9500),
    ),
    _ThreatData(
      number: '03',
      type: ObstacleType.billTornado,
      emoji: '🌪️',
      name: 'Bill Tornado',
      tip: 'Sweeps all lanes — time your gap!',
      color: Color(0xFF5856D6),
    ),
    _ThreatData(
      number: '04',
      type: ObstacleType.subscriptionSnake,
      emoji: '🐍',
      name: 'Subscription Snake',
      tip: 'Slides across — jump over!',
      color: Color(0xFF34C759),
    ),
    _ThreatData(
      number: '05',
      type: ObstacleType.taxBoulder,
      emoji: '🪨',
      name: 'Tax Boulder',
      tip: 'Rolls toward center — move fast!',
      color: Color(0xFF8E8E93),
    ),
    _ThreatData(
      number: '06',
      type: ObstacleType.foxThief,
      emoji: '🦊',
      name: 'Fox Thief',
      tip: 'Follows your lane — outrun it!',
      color: Color(0xFFFF6B35),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white12, shape: BoxShape.circle),
                      child: const Icon(Icons.chevron_left,
                        size: 20, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('HEN GUIDE · THREATS',
                    style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white54, letterSpacing: 1)),
                ],
              ),
            ),

            // ── Headline ───────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: 'Six things will ',
                    style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 26,
                      fontWeight: FontWeight.w900, color: Colors.white,
                      height: 1.2)),
                  TextSpan(
                    text: 'stop her.',
                    style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFF6B35), height: 1.2)),
                ]),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 6, 20, 16),
              child: Text('Read the lane. React under 0.6 seconds.',
                style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 13,
                  color: Color(0xFFFF6B35))),
            ),

            // ── 2×3 grid of threat cards ───────────────────────────────
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.05,
                ),
                itemCount: _threats.length,
                itemBuilder: (_, i) => _ThreatCard(data: _threats[i]),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ThreatCard extends StatelessWidget {
  final _ThreatData data;
  const _ThreatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: data.color.withOpacity(0.20), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number label
          Text(data.number,
            style: TextStyle(
              fontFamily: 'Poppins', fontSize: 11,
              fontWeight: FontWeight.w700,
              color: data.color.withOpacity(0.60))),
          const Spacer(),

          // Emoji illustration
          Text(data.emoji,
            style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 8),

          // Name
          Text(data.name,
            style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 13,
              fontWeight: FontWeight.w700, color: Colors.white,
              height: 1.2)),
          const SizedBox(height: 4),

          // Dodge tip
          Text(data.tip,
            style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 11,
              color: Colors.white38, height: 1.3)),
        ],
      ),
    );
  }
}

class _ThreatData {
  final String number;
  final ObstacleType type;
  final String emoji;
  final String name;
  final String tip;
  final Color color;
  const _ThreatData({
    required this.number, required this.type, required this.emoji,
    required this.name, required this.tip, required this.color,
  });
}
