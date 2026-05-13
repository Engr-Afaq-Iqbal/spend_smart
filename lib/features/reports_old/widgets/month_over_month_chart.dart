// lib/features/reports/widgets/month_over_month_chart.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/reports_controller.dart';
import '../model/reports_models.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_header.dart';

class MonthOverMonthChart extends GetView<ReportsController> {
  const MonthOverMonthChart({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SectionHeader(title: 'reports_month_over_month'.tr),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Obx(() {
            final comparisons = controller.monthlyComparisons;
            final maxAmt      = controller.maxMonthlyAmount;
            final delta       = controller.monthDelta.value;
            final trackCl     = isDark ? Colors.white12 : const Color(0xFFE8EAED);

            return Column(
              children: [
                SizedBox(
                  height: 110,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: comparisons.map((m) => _MonthBar(
                          comparison: m,
                          maxAmount: maxAmt,
                          trackColor: trackCl,
                          activeColor: cs.primary,
                        )).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Divider(height: 1, color: isDark ? Colors.white12 : const Color(0xFFF0F0F5)),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('reports_this_month'.tr,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 12, color: cs.onBackground.withOpacity(0.55))),
                    Row(
                      children: [
                        Icon(Icons.arrow_upward_rounded, size: 13, color: cs.primary),
                        const SizedBox(width: 3),
                        Text(
                          'SAR ${_fmt(delta)} ${'reports_sar_more'.tr.replaceAll('@amount', '')}',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: cs.primary, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  String _fmt(double v) {
    final n = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < n.length; i++) {
      if (i > 0 && (n.length - i) % 3 == 0) buf.write(',');
      buf.write(n[i]);
    }
    return buf.toString();
  }
}

class _MonthBar extends StatefulWidget {
  final MonthlyComparison comparison;
  final double maxAmount;
  final Color trackColor;
  final Color activeColor;
  const _MonthBar({required this.comparison, required this.maxAmount,
      required this.trackColor, required this.activeColor});

  @override
  State<_MonthBar> createState() => _MonthBarState();
}

class _MonthBarState extends State<_MonthBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs       = Theme.of(context).colorScheme;
    final ratio    = widget.comparison.amount / widget.maxAmount;
    final isActive = widget.comparison.isCurrentMonth;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => Container(
            width: 40,
            height: (ratio * 80 * _anim.value).clamp(4.0, 80.0),
            decoration: BoxDecoration(
              color: isActive ? widget.activeColor : widget.trackColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(widget.comparison.month,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 11,
              color: isActive ? widget.activeColor : cs.onBackground.withOpacity(0.40),
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            )),
      ],
    );
  }
}
