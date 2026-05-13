// lib/features/reports/widgets/category_donut_chart.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/reports_controller.dart';
import '../model/reports_models.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_header.dart';

class CategoryDonutChart extends GetView<ReportsController> {
  const CategoryDonutChart({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SectionHeader(title: 'reports_spending_by_category'.tr),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Obx(() => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _AnimatedDonut(
                    slices: controller.categories,
                    centerLabel: _totalLabel(controller.categories),
                    centerTextColor: cs.onBackground,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: controller.categories
                          .map((s) => _LegendRow(slice: s, isDark: isDark))
                          .toList(),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  String _totalLabel(List<CategorySlice> slices) {
    final total = slices.fold<double>(0, (s, c) => s + c.amount);
    final n = total.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < n.length; i++) {
      if (i > 0 && (n.length - i) % 3 == 0) buf.write(',');
      buf.write(n[i]);
    }
    return buf.toString();
  }
}

class _AnimatedDonut extends StatefulWidget {
  final List<CategorySlice> slices;
  final String centerLabel;
  final Color centerTextColor;
  const _AnimatedDonut({required this.slices, required this.centerLabel, required this.centerTextColor});

  @override
  State<_AnimatedDonut> createState() => _AnimatedDonutState();
}

class _AnimatedDonutState extends State<_AnimatedDonut>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant _AnimatedDonut old) {
    super.didUpdateWidget(old);
    if (old.slices != widget.slices) _ctrl.forward(from: 0);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => SizedBox(
        width: 130, height: 130,
        child: CustomPaint(
          painter: _DonutPainter(slices: widget.slices, progress: _anim.value),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SAR', style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 11, color: widget.centerTextColor.withOpacity(0.55))),
                Text(widget.centerLabel, style: AppTextStyles.amountMedium.copyWith(
                  fontSize: 16, color: widget.centerTextColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<CategorySlice> slices;
  final double progress;
  const _DonutPainter({required this.slices, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center  = Offset(size.width / 2, size.height / 2);
    final outerR  = size.width / 2 - 4;
    final innerR  = outerR * 0.58;
    const gapRad  = 0.025;
    const start   = -math.pi / 2;
    final total   = slices.fold<double>(0, (s, c) => s + c.percentage);
    double sweep  = 0;
    for (final slice in slices) {
      final sw = (slice.percentage / total) * 2 * math.pi * progress - gapRad;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: (outerR + innerR) / 2),
        start + sweep + gapRad / 2,
        sw.clamp(0.0, 2 * math.pi),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = outerR - innerR
          ..color = slice.color
          ..strokeCap = StrokeCap.butt,
      );
      sweep += (slice.percentage / total) * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.progress != progress || old.slices != slices;
}

class _LegendRow extends StatelessWidget {
  final CategorySlice slice;
  final bool isDark;
  const _LegendRow({required this.slice, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 10, height: 10,
              decoration: BoxDecoration(color: slice.color, shape: BoxShape.circle)),
          const SizedBox(width: 7),
          Expanded(
            child: Text(slice.name,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12, color: cs.onBackground.withOpacity(0.70))),
          ),
          Text('${slice.percentage.toStringAsFixed(0)}%',
              style: AppTextStyles.labelSmall.copyWith(
                color: cs.onBackground, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}
