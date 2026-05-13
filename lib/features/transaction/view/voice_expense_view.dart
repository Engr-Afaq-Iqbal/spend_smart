// lib/features/transaction/view/voice_expense_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// Voice Expense AI screen — dark themed matching the design:
//   • X close button + "VOICE ENTRY" title
//   • Animated glowing mic button (idle → listening → processing)
//   • Live transcription text
//   • "Got it ✓" / "Listening..." status
//   • Extracted AMOUNT / CATEGORY / MERCHANT rows
//   • Edit + Save buttons
// Shows premium gate for non-premium users.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/transaction_controller.dart';
import '../model/transaction_models.dart';
import '../widgets/premium_gate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class VoiceExpenseView extends StatefulWidget {
  const VoiceExpenseView({super.key});
  @override
  State<VoiceExpenseView> createState() => _VoiceExpenseViewState();
}

class _VoiceExpenseViewState extends State<VoiceExpenseView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  TransactionController get ctrl => Get.find<TransactionController>();

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
    _pulseAnim = Tween(begin: 1.0, end: 1.18)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // Show premium gate if not premium
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ctrl.isPremium.value) {
        PremiumGate.show(
          context: context,
          titleKey: 'premium_voice_title',
          descKey: 'premium_voice_desc',
          icon: Icons.mic_rounded,
        );
      } else {
        // Auto-start recording
        ctrl.startVoiceRecording();
      }
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    ctrl.resetVoice();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SafeArea(
        child: Obx(() {
          final state = ctrl.voiceState.value;
          return Column(
            children: [
              // ── Top bar ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                        color: Colors.white60, size: 24),
                      onPressed: Get.back,
                    ),
                    const Expanded(child: Center(
                      child: Text('VOICE ENTRY',
                        style: TextStyle(fontFamily: 'Poppins',
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: Colors.white, letterSpacing: 1)),
                    )),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // ── Animated mic button ──────────────────────────────────
              _AnimatedMicButton(
                pulseAnim: _pulseAnim,
                state: state,
                onTap: () {
                  if (state == VoiceState.idle) {
                    ctrl.startVoiceRecording();
                  } else if (state == VoiceState.listening) {
                    ctrl.stopVoiceRecording();
                  }
                },
              ),
              const SizedBox(height: 32),

              // ── Status text ──────────────────────────────────────────
              if (state == VoiceState.listening || state == VoiceState.idle)
                Column(children: [
                  Text(
                    state == VoiceState.listening ? 'listening'.tr : 'listening'.tr,
                    style: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 22,
                      fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text('voice_hint'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 13,
                      color: Colors.white54, height: 1.5)),
                ]),

              if (state == VoiceState.extracted)
                Column(children: [
                  const Text('Got it ✓',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 22,
                      fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('voice_hint'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13,
                      color: Colors.white38, height: 1.5)),
                ]),

              // ── Live transcription ────────────────────────────────────
              if (ctrl.transcribedText.value.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(ctrl.transcribedText.value,
                        style: const TextStyle(fontFamily: 'Poppins',
                          fontSize: 14, color: Colors.white70))),
                      Container(
                        width: 2, height: 18,
                        color: AppColors.primary,
                        margin: const EdgeInsets.only(left: 2),
                      ),
                    ],
                  ),
                ),
              ],

              // ── Extracted result card ─────────────────────────────────
              if (state == VoiceState.extracted &&
                  ctrl.voiceExtraction.value != null) ...[
                const SizedBox(height: 20),
                _ExtractionCard(result: ctrl.voiceExtraction.value!),
              ],

              const Spacer(flex: 3),

              // ── Action buttons ────────────────────────────────────────
              if (state == VoiceState.extracted)
                _ActionRow(
                  onEdit: ctrl.applyVoiceExtraction,
                  onSave: ctrl.applyVoiceExtraction,
                ),

              const SizedBox(height: 24),
            ],
          );
        }),
      ),
    );
  }
}

// ── Animated mic button ───────────────────────────────────────────────────────
class _AnimatedMicButton extends StatelessWidget {
  final Animation<double> pulseAnim;
  final VoiceState state;
  final VoidCallback onTap;
  const _AnimatedMicButton({
    required this.pulseAnim, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulseAnim,
        builder: (_, __) {
          final scale = state == VoiceState.listening ? pulseAnim.value : 1.0;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow rings
              if (state == VoiceState.listening)
                ...[1.6, 1.35].map((s) => Container(
                  width: 140 * s, height: 140 * s,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(
                        0.08 * (1 + pulseAnim.value * 0.3)),
                  ),
                )),
              // Main button
              Transform.scale(
                scale: scale,
                child: Container(
                  width: 140, height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: state == VoiceState.extracted
                          ? [const Color(0xFF2ECC71), const Color(0xFF27AE60)]
                          : [
                              const Color(0xFFFF8C5A),
                              AppColors.primary,
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.45),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    state == VoiceState.extracted
                        ? Icons.check_rounded
                        : Icons.mic_rounded,
                    color: Colors.white,
                    size: 52,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Extraction result card ────────────────────────────────────────────────────
class _ExtractionCard extends StatelessWidget {
  final AiExtractionResult result;
  const _ExtractionCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DETECTED',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
              fontWeight: FontWeight.w700, color: Colors.white38,
              letterSpacing: 1)),
          const SizedBox(height: 12),
          _DetectedRow(
            label: 'amount'.tr,
            value: result.amount != null ? 'SAR  ${result.amount!.toStringAsFixed(0)}' : '—',
            valueColor: Colors.white,
          ),
          const Divider(color: Colors.white10, height: 16),
          _DetectedRow(
            label: 'category'.tr,
            value: result.category?.labelKey.tr ?? '—',
            icon: result.category?.icon,
            iconColor: result.category?.color,
            hasAiBadge: true,
          ),
          const Divider(color: Colors.white10, height: 16),
          _DetectedRow(
            label: 'merchant'.tr,
            value: result.merchant ?? '—',
            hasAiBadge: true,
          ),
        ],
      ),
    );
  }
}

class _DetectedRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final Color valueColor;
  final bool hasAiBadge;

  const _DetectedRow({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.valueColor = Colors.white,
    this.hasAiBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
          style: const TextStyle(fontFamily: 'Poppins',
            fontSize: 12, color: Colors.white54)),
        const Spacer(),
        if (icon != null) ...[
          Icon(icon, color: iconColor ?? Colors.white, size: 14),
          const SizedBox(width: 5),
        ],
        Text(value,
          style: TextStyle(fontFamily: 'Poppins',
            fontSize: 14, fontWeight: FontWeight.w600, color: valueColor)),
        if (hasAiBadge) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('+ AI',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 9,
                fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
        ],
      ],
    );
  }
}

// ── Edit + Save action row ────────────────────────────────────────────────────
class _ActionRow extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onSave;
  const _ActionRow({required this.onEdit, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onEdit,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white24),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('edit'.tr,
                style: const TextStyle(fontFamily: 'Poppins',
                  fontSize: 14, color: Colors.white70)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: Text('save_expense'.tr,
                style: const TextStyle(fontFamily: 'Poppins',
                  fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
