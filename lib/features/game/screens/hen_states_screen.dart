// lib/screens/hen_states_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
// Route: /game/hen-states
// Shows the 5 hen financial states with speed/size comparison.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:spend_smart/features/game/models/game_models.dart';

class HenStatesScreen extends StatelessWidget {
  final UserFinancialProfile profile;

  const HenStatesScreen({super.key, required this.profile});

  // Static data for each state card
  static const List<_StateCardData> _states = [
    _StateCardData(
      state:      HenState.saver,
      label:      'SAVER',
      speed:      300,
      scale:      0.7,
      scaleLabel: '0.7× slim',
      speedLabel: '300 px/s',
      incomeRatio:'< 40%',
    ),
    _StateCardData(
      state:      HenState.balanced,
      label:      'BALANCED',
      speed:      230,
      scale:      1.0,
      scaleLabel: '1.0× slim',
      speedLabel: '230 px/s',
      incomeRatio:'40–60%',
    ),
    _StateCardData(
      state:      HenState.spender,
      label:      'SPENDER',
      speed:      175,
      scale:      1.3,
      scaleLabel: '1.3× slim',
      speedLabel: '175 px/s',
      incomeRatio:'60–80%',
    ),
    _StateCardData(
      state:      HenState.overspend,
      label:      'OVERSPEND',
      speed:      120,
      scale:      1.6,
      scaleLabel: '1.6× slim',
      speedLabel: '120 px/s',
      incomeRatio:'80–100%',
    ),
    _StateCardData(
      state:      HenState.broke,
      label:      'BROKE',
      speed:      70,
      scale:      1.9,
      scaleLabel: '1.9× slim',
      speedLabel: '70 px/s',
      incomeRatio:'> 100%',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6C8), // warm desert background
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
                        color: Colors.black.withOpacity(0.08),
                        shape: BoxShape.circle),
                      child: const Icon(Icons.chevron_left, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('HEN GUIDE · STATES',
                    style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B5C3A), letterSpacing: 1)),
                ],
              ),
            ),

            // ── Headline ───────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text('Your hen reflects\nyour spending.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1D2E),
                  height: 1.2)),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                'Log fewer expenses to make her faster and smaller.\nSpend big, and she waddles.',
                style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 13,
                  color: Color(0xFF6B5C3A), height: 1.5)),
            ),
            const SizedBox(height: 20),

            // ── Horizontal state cards ─────────────────────────────────
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _states.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final s = _states[i];
                  final isHere = s.state == profile.state;
                  return _StateCard(data: s, isCurrentState: isHere);
                },
              ),
            ),
            const SizedBox(height: 12),

            // ── Gradient label ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ShaderMask(
                shaderCallback: (r) => const LinearGradient(
                  colors: [Color(0xFF34C759), Color(0xFFFF3B30)],
                ).createShader(r),
                child: const Text(
                  'FASTER · SMALLER ←──────────────────────────────→ SLOWER · BIGGER',
                  style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 11,
                    fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),

            const Spacer(),

            // ── Bottom status card ─────────────────────────────────────
            _BottomStatusCard(profile: profile),
            const SizedBox(height: 12),

            // ── CTA button ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Text('GET FASTER — LOG EXPENSE',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── State card ─────────────────────────────────────────────────────────────────
class _StateCard extends StatelessWidget {
  final _StateCardData data;
  final bool isCurrentState;
  const _StateCard({required this.data, required this.isCurrentState});

  Color get _speedColor =>
      data.speed >= 200 ? const Color(0xFF34C759) : const Color(0xFFFF3B30);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentState ? const Color(0xFF34C759) : Colors.transparent,
          width: 2.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06),
              blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          if (isCurrentState)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF34C759),
                borderRadius: BorderRadius.circular(10)),
              child: const Text('YOU ARE HERE',
                style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 8,
                  fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          if (!isCurrentState) const SizedBox(height: 18),

          // Hen emoji sized by scale
          Text('🐔',
            style: TextStyle(fontSize: 30 * data.scale.clamp(0.6, 1.2))),
          const SizedBox(height: 6),

          Text(data.label,
            style: TextStyle(
              fontFamily: 'Poppins', fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isCurrentState
                  ? const Color(0xFF34C759)
                  : const Color(0xFF1A1D2E))),
          const SizedBox(height: 4),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _speedColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8)),
            child: Text(data.speedLabel,
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 10,
                fontWeight: FontWeight.w700, color: _speedColor)),
          ),
          const SizedBox(height: 3),
          Text(data.scaleLabel,
            style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 9,
              color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}

class _StateCardData {
  final HenState state;
  final String label;
  final int speed;
  final double scale;
  final String scaleLabel;
  final String speedLabel;
  final String incomeRatio;
  const _StateCardData({
    required this.state, required this.label, required this.speed,
    required this.scale, required this.scaleLabel, required this.speedLabel,
    required this.incomeRatio,
  });
}

// ── Bottom status card ─────────────────────────────────────────────────────────
class _BottomStatusCard extends StatelessWidget {
  final UserFinancialProfile profile;
  const _BottomStatusCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final ratio = profile.ratio;
    final spent = profile.monthlyExpenses;
    final budget = profile.monthlyIncome;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06),
                blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF34C759).withOpacity(0.12),
                shape: BoxShape.circle),
              child: const Center(
                child: Text('⚡',
                  style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("You're ${profile.stateLabel.toLowerCase().capitalise()} today",
                    style: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 13,
                      fontWeight: FontWeight.w700, color: Color(0xFF1A1D2E))),
                  Text(
                    '${profile.currentStreak} expenses logged · '
                    'SAR ${spent.toStringAsFixed(0)} of SAR ${budget.toStringAsFixed(0)} budget',
                    style: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 11,
                      color: Color(0xFF6B7280))),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: ratio.clamp(0.0, 1.0),
                      minHeight: 4,
                      backgroundColor: Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ratio < 0.6 ? const Color(0xFF34C759) : const Color(0xFFFF6B35)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF34C759).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8)),
              child: Text('${ratio.toStringAsFixed(1)}×',
                style: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 12,
                  fontWeight: FontWeight.w800, color: Color(0xFF34C759))),
            ),
          ],
        ),
      ),
    );
  }
}

extension _StringExt on String {
  String capitalise() =>
      isEmpty ? this : this[0].toUpperCase() + substring(1);
}
