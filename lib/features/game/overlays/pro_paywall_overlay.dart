// lib/game/overlays/pro_paywall_overlay.dart
// ─────────────────────────────────────────────────────────────────────────────
// Shown when a free user hits the 90-second limit.
// Game is PAUSED — not ended — so the user can potentially resume with an ad.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:spend_smart/features/game/components/hen_blitz_game.dart';
import 'package:spend_smart/features/game/models/game_models.dart';

class ProPaywallOverlay extends StatelessWidget {
  final HenBlitzGame game;
  final VoidCallback onUnlockPro;
  final VoidCallback onWatchAd;
  final VoidCallback onDismiss;

  const ProPaywallOverlay({
    super.key,
    required this.game,
    required this.onUnlockPro,
    required this.onWatchAd,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final petName = game.profile.petName;

    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8EF),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.30),
                  blurRadius: 30, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dismiss X
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: onDismiss,
                  child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('✕',
                          style: TextStyle(fontSize: 13, color: Colors.black45)),
                    ),
                  ),
                ),
              ),

              // Hen illustration placeholder
              const Text('🐔', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 12),

              // Headline
              Text(
                '$petName wants to keep running!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1D2E),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "You've used your free game today.",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 20),

              // 3 Pro features
              _ProFeatureRow(icon: '∞', label: 'Unlimited daily games'),
              const SizedBox(height: 8),
              _ProFeatureRow(icon: '5×', label: '5× more daily coins'),
              const SizedBox(height: 8),
              _ProFeatureRow(icon: '✦', label: 'Exclusive hen skins + accessories'),

              const SizedBox(height: 20),

              // Price
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFFF6B35).withOpacity(0.30)),
                ),
                child: Column(
                  children: [
                    RichText(
                      text: const TextSpan(children: [
                        TextSpan(text: 'SAR ',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 16,
                            color: Color(0xFF1A1D2E))),
                        TextSpan(text: '7.99',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1D2E))),
                        TextSpan(text: ' / month',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 14,
                            color: Color(0xFF6B7280))),
                      ]),
                    ),
                    const Text(
                      'or SAR 89/year · save 26%',
                      style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 12,
                        color: Color(0xFF34C759),
                        fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Unlock Pro CTA
              ElevatedButton(
                onPressed: onUnlockPro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Text('UNLOCK PRO',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5)),
              ),
              const SizedBox(height: 10),

              // Watch ad option
              GestureDetector(
                onTap: onWatchAd,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('▶ ',
                      style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 12,
                        color: Color(0xFF6B7280))),
                    Text('Watch 15-sec ad for 1 more play',
                      style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 12,
                        color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Legal footer
              const Text(
                'Auto-renews until cancelled · Terms · Restore',
                style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 10,
                  color: Color(0xFFADB5C2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProFeatureRow extends StatelessWidget {
  final String icon;
  final String label;
  const _ProFeatureRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35).withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(icon,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFF6B35))),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label,
          style: const TextStyle(
            fontFamily: 'Poppins', fontSize: 14,
            color: Color(0xFF1A1D2E)))),
        const Text('✓',
          style: TextStyle(
            fontFamily: 'Poppins', fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF34C759))),
      ],
    );
  }
}
