// lib/features/transaction/widgets/add_transaction_sheet.dart
// ─────────────────────────────────────────────────────────────────────────────
// The "ADD TRANSACTION" bottom sheet opened when user taps the center FAB.
// Matches the design exactly:
//   • Handle bar at top
//   • "ADD TRANSACTION" title
//   • Expense card (coral left border)
//   • Income card (green left border)
//   • Scan Receipt + Voice row (smaller, with +AI badge)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class AddTransactionSheet extends StatelessWidget {
  const AddTransactionSheet({super.key});

  static void show(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      useRootNavigator: true,
      builder: (_) => const AddTransactionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.white;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Handle ─────────────────────────────────────────────────
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onBackground.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Title ──────────────────────────────────────────────────
              Text('add_transaction'.tr,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: cs.onBackground.withOpacity(0.45),
                  )),
              const SizedBox(height: 16),

              // ── Expense card ────────────────────────────────────────────
              _ActionCard(
                leftColor: AppColors.categoryFood,
                icon: '💸',
                title: 'add_expense',
                subtitle: 'add_expense_sub'.tr,
                onTap: () {
                  Get.back();
                  Future.delayed(const Duration(milliseconds: 150), () {
                    Get.toNamed(AppRoutes.addExpense);
                  });
                },
              ),
              const SizedBox(height: 10),

              // ── Income card ─────────────────────────────────────────────
              _ActionCard(
                leftColor: AppColors.categoryShopping,
                icon: '💰',
                title: 'add_income'.tr,
                subtitle: 'add_income_sub'.tr,
                onTap: () {
                  Get.back();
                  Future.delayed(const Duration(milliseconds: 150), () {
                    Get.toNamed(AppRoutes.addIncome);
                  });
                },
              ),
              const SizedBox(height: 14),

              // ── Scan Receipt + Voice row ────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _AiActionCard(
                      icon: Icons.receipt_long_rounded,
                      label: 'scan_receipt'.tr,
                      onTap: () {
                        Get.back();
                        Future.delayed(const Duration(milliseconds: 150), () {
                          Get.toNamed(AppRoutes.scanReceipt);
                        });
                      },
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _AiActionCard(
                      icon: Icons.mic_rounded,
                      label: 'voice_expense'.tr,
                      sublabel: 'voice_expense_sub'.tr,
                      onTap: () {
                        Get.back();
                        Future.delayed(const Duration(milliseconds: 150), () {
                          Get.toNamed(AppRoutes.voiceExpense);
                        });
                      },
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Full-width action card (Expense / Income) ─────────────────────────────────
class _ActionCard extends StatefulWidget {
  final Color leftColor;
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _ActionCard({
    required this.leftColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF252836) : const Color(0xFFF9F9FB),
            borderRadius: BorderRadius.circular(14),
            border: Border(
              left: BorderSide(color: widget.leftColor, width: 4),
            ),
          ),
          child: Row(
            children: [
              Text(widget.icon, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title.tr,
                        style: AppTextStyles.labelLarge.copyWith(
                            fontSize: 15,
                            color: cs.onBackground,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(widget.subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 12,
                            color: cs.onBackground.withOpacity(0.45))),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: cs.onBackground.withOpacity(0.30), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Half-width AI action card (Scan / Voice) ──────────────────────────────────
class _AiActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? sublabel;
  final VoidCallback onTap;
  final bool isDark;
  const _AiActionCard({
    required this.icon,
    required this.label,
    this.sublabel,
    required this.onTap,
    required this.isDark,
  });
  @override
  State<_AiActionCard> createState() => _AiActionCardState();
}

class _AiActionCardState extends State<_AiActionCard> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: widget.isDark
                ? const Color(0xFF252836)
                : const Color(0xFFF9F9FB),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(widget.icon,
                      color: cs.onBackground.withOpacity(0.65), size: 22),
                  const SizedBox(width: 8),
                  // +AI badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cs.primary.withOpacity(0.30)),
                    ),
                    child: Text('ai_badge'.tr,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: cs.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.label,
                  style: AppTextStyles.labelMedium.copyWith(
                      fontSize: 13,
                      color: cs.onBackground,
                      fontWeight: FontWeight.w600)),
              if (widget.sublabel != null) ...[
                const SizedBox(height: 2),
                Text(widget.sublabel!,
                    style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        color: cs.onBackground.withOpacity(0.45))),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
