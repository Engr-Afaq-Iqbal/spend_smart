// lib/features/transaction/widgets/numpad_widget.dart
// ─────────────────────────────────────────────────────────────────────────────
// Custom numpad matching the design:
//   • Large amount display at top with blinking cursor
//   • Currency chip row (SAR|USD|EUR|AED|KWD)
//   • 3×4 button grid (1-9, ., 0, ⌫)
// Theme-adaptive — dark background in dark mode, light in light mode.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spend_smart/features/transaction/model/transaction_models.dart';

import '../../../core/constants/app_text_styles.dart';
import '../controller/transaction_controller.dart';

// Expose TxCurrency here for convenience
export '../model/transaction_models.dart' show TxCurrency;

class AmountDisplay extends GetView<TransactionController> {
  final Color headerColor;
  final String subtitleKey;
  const AmountDisplay({
    super.key,
    required this.headerColor,
    this.subtitleKey = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      color: headerColor,
      child: Column(
        children: [
          // Amount row
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(controller.currency.value.labelKey,
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: Colors.white70, fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(controller.formattedAmount,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 52,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.1,
                      )),
                  // Blinking cursor
                  const _BlinkingCursor(),
                ],
              )),
          if (subtitleKey.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(subtitleKey.tr,
                style: AppTextStyles.bodySmall
                    .copyWith(color: Colors.white60, fontSize: 12)),
          ],
          const SizedBox(height: 12),
          // Currency chips
          Obx(() => _CurrencyChips(
                selected: controller.currency.value,
                onSelect: (c) => controller.currency.value = c,
              )),
        ],
      ),
    );
  }
}

// ── Blinking cursor ────────────────────────────────────────────────────────────
class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        width: 2,
        height: 44,
        margin: const EdgeInsets.only(left: 2),
        color: Colors.white,
      ),
    );
  }
}

// ── Currency chip row ──────────────────────────────────────────────────────────
class _CurrencyChips extends StatelessWidget {
  final TxCurrency selected;
  final ValueChanged<TxCurrency> onSelect;
  const _CurrencyChips({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TxCurrency.values.map((c) {
          final isActive = c == selected;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onSelect(c);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.20),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(c.labelKey,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                  )),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Numpad grid ────────────────────────────────────────────────────────────────
class NumpadGrid extends GetView<TransactionController> {
  const NumpadGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '⌫'];

    return Container(
      color: isDark ? const Color(0xFF0F1117) : const Color(0xFFF8F9FC),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemCount: keys.length,
        itemBuilder: (_, i) => _NumKey(
          label: keys[i],
          isDark: isDark,
          onTap: () {
            HapticFeedback.lightImpact();
            controller.onNumpadTap(keys[i]);
          },
        ),
      ),
    );
  }
}

class _NumKey extends StatefulWidget {
  final String label;
  final bool isDark;
  final VoidCallback onTap;
  const _NumKey(
      {required this.label, required this.isDark, required this.onTap});
  @override
  State<_NumKey> createState() => _NumKeyState();
}

class _NumKeyState extends State<_NumKey> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final isDelete = widget.label == '⌫';
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        decoration: BoxDecoration(
          color: _pressed
              ? cs.primary.withOpacity(0.12)
              : widget.isDark
                  ? const Color(0xFF1C1F2E)
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: widget.isDark
              ? null
              : [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1)),
                ],
        ),
        child: Center(
          child: isDelete
              ? Icon(Icons.backspace_outlined, color: cs.primary, size: 22)
              : Text(widget.label,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: cs.onBackground)),
        ),
      ),
    );
  }
}
