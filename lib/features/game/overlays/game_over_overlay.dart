// lib/game/overlays/game_over_overlay.dart
// ─────────────────────────────────────────────────────────────────────────────
// Full-screen game-over overlay matching the screenshot exactly.
// Slides up from the bottom with a spring animation.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spend_smart/features/game/models/game_models.dart';

class GameOverOverlay extends StatefulWidget {
  final GameResult result;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToApp;
  final String petName;
  final int personalBest; // previous best distance

  const GameOverOverlay({
    super.key,
    required this.result,
    required this.onPlayAgain,
    required this.onBackToApp,
    required this.petName,
    this.personalBest = 0,
  });

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool get _isPersonalBest =>
      widget.result.distanceMeters > widget.personalBest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SlideTransition(
        position: _slideAnim,
        child: DraggableScrollableSheet(
          initialChildSize: 0.90,
          minChildSize: 0.70,
          maxChildSize: 1.0,
          builder: (_, sc) => Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF8F0),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: sc,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 36, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),

                // GAME OVER title
                const Text('GAME OVER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1D2E),
                    letterSpacing: 1,
                  )),
                const SizedBox(height: 8),

                // Distance
                Text(
                  '${_fmtNum(widget.result.distanceMeters)} m',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFF6B35),
                  ),
                ),

                // Personal best badge
                if (_isPersonalBest) ...[
                  const SizedBox(height: 4),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🏆', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 5),
                          Text('PERSONAL BEST!',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87)),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 14),

                // Stopped by
                if (widget.result.killedBy != null)
                  _StoppedByCard(type: widget.result.killedBy!),
                const SizedBox(height: 10),

                // Finance tip
                if (widget.result.killedBy != null)
                  _FinanceTipCard(type: widget.result.killedBy!),
                const SizedBox(height: 16),

                // Eggs this run
                _EggsBreakdown(result: widget.result),
                const SizedBox(height: 20),

                // Play Again
                ElevatedButton.icon(
                  onPressed: widget.onPlayAgain,
                  icon: const Text('▶', style: TextStyle(fontSize: 16)),
                  label: const Text('PLAY AGAIN',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                ),
                const SizedBox(height: 10),

                // Back to App
                TextButton(
                  onPressed: widget.onBackToApp,
                  child: const Text('Back to App',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Color(0xFF1A1D2E))),
                ),
                const SizedBox(height: 16),

                // Share score
                _ShareRow(result: widget.result, petName: widget.petName),
              ],
            ),
          ),
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
}

class _StoppedByCard extends StatelessWidget {
  final ObstacleType type;
  const _StoppedByCard({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05),
              blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          const Text('🛑', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(
            'Stopped by: ${ObstacleNames.nameFor(type)}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1D2E)),
          )),
        ],
      ),
    );
  }
}

class _FinanceTipCard extends StatelessWidget {
  final ObstacleType type;
  const _FinanceTipCard({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCC02).withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(FinanceTips.tipFor(type),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFF5D4037),
                    height: 1.4)),
                const SizedBox(height: 4),
                const Text('See your debt overview ›',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFFFF6B35),
                    fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EggsBreakdown extends StatelessWidget {
  final GameResult result;
  const _EggsBreakdown({required this.result});

  @override
  Widget build(BuildContext context) {
    if (result.eggsCollected.isEmpty) return const SizedBox.shrink();

    final collected = result.eggsCollected.entries
        .where((e) => e.value > 0)
        .toList();

    int total = 0;
    for (final e in collected) {
      total += (e.value * (EggData.coinValues[e.key] ?? 0));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('EGGS THIS RUN',
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B7280), letterSpacing: 0.5)),
            Row(children: [
              const Text('🪙', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 4),
              Text('+$total',
                style: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFD700))),
            ]),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04),
                  blurRadius: 6, offset: const Offset(0, 1))
            ],
          ),
          child: Column(
            children: collected.map((e) {
              final coins = e.value * (EggData.coinValues[e.key] ?? 0);
              return _EggRow(type: e.key, count: e.value, coins: coins,
                isLast: e == collected.last);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _EggRow extends StatelessWidget {
  final EggType type;
  final int count;
  final int coins;
  final bool isLast;
  const _EggRow({required this.type, required this.count,
    required this.coins, required this.isLast});

  static const Map<EggType, String> _emojis = {
    EggType.cracked:  '🥚',
    EggType.silver:   '🩶',
    EggType.gold:     '🌕',
    EggType.diamond:  '💎',
    EggType.rainbow:  '🌈',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Text(_emojis[type] ?? '🥚',
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(child: Text(EggData.names[type] ?? '',
                style: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 14,
                  fontWeight: FontWeight.w500, color: Color(0xFF1A1D2E)))),
              Text('× $count',
                style: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280))),
              const SizedBox(width: 12),
              Text('+$coins',
                style: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 13,
                  fontWeight: FontWeight.w700, color: Color(0xFFFFD700))),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 14),
      ],
    );
  }
}

class _ShareRow extends StatelessWidget {
  final GameResult result;
  final String petName;
  const _ShareRow({required this.result, required this.petName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('SHARE SCORE',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280))),
        const SizedBox(width: 12),
        // WhatsApp
        _ShareBtn(
          icon: '📱',
          color: const Color(0xFF25D366),
          onTap: () {},
        ),
        const SizedBox(width: 8),
        // Instagram
        _ShareBtn(
          icon: '📸',
          color: const Color(0xFFE4405F),
          onTap: () {},
        ),
        const SizedBox(width: 8),
        // Copy link
        _ShareBtn(
          icon: '🔗',
          color: const Color(0xFF6B7280),
          onTap: () {},
        ),
      ],
    );
  }
}

class _ShareBtn extends StatelessWidget {
  final String icon;
  final Color color;
  final VoidCallback onTap;
  const _ShareBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.30)),
        ),
        child: Center(
          child: Text(icon, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
