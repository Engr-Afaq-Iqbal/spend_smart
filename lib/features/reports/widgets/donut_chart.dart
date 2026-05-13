// lib/features/reports/widgets/donut_chart.dart
// ─────────────────────────────────────────────────────────────────────────────
// Reusable animated donut chart. Zero third-party dependencies — pure
// CustomPainter. Used by Overview, Income, Expenses, and Net Worth tabs.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../model/reports_models.dart';
import '../../../core/constants/app_text_styles.dart';

class DonutChart extends StatefulWidget {
  final List<CategorySlice> slices;
  final String centerLabel;   // "SAR"
  final String centerValue;   // "17,800"
  final double size;

  const DonutChart({
    super.key,
    required this.slices,
    required this.centerLabel,
    required this.centerValue,
    this.size = 140,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant DonutChart old) {
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
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _DonutPainter(
            slices: widget.slices,
            progress: _anim.value,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.centerLabel,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11,
                    color: Theme.of(context).colorScheme.onBackground
                        .withOpacity(0.55))),
                Text(widget.centerValue,
                  style: AppTextStyles.amountMedium.copyWith(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                  )),
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
    if (slices.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width / 2 - 4;
    final innerR = outerR * 0.62;
    final strokeW = outerR - innerR;
    const gap = 0.02; // radians gap between slices
    const startAngle = -math.pi / 2;
    final total = slices.fold<double>(0, (s, c) => s + c.percentage);
    double sweep = 0;

    for (final slice in slices) {
      final sliceSweep =
          (slice.percentage / total) * 2 * math.pi * progress - gap;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: (outerR + innerR) / 2),
        startAngle + sweep + gap / 2,
        sliceSweep.clamp(0.0, 2 * math.pi),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
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

// ── Net Worth half-donut gauge ────────────────────────────────────────────────
class HalfDonutGauge extends StatefulWidget {
  final double assets;
  final double liabilities;
  final double netWorth;
  final double size;
  const HalfDonutGauge({
    super.key,
    required this.assets,
    required this.liabilities,
    required this.netWorth,
    this.size = 180,
  });
  @override
  State<HalfDonutGauge> createState() => _HalfDonutGaugeState();
}

class _HalfDonutGaugeState extends State<HalfDonutGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 1000));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = widget.assets + widget.liabilities;
    final assetsRatio = total > 0 ? widget.assets / total : 0.5;

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => SizedBox(
        width: widget.size,
        height: widget.size * 0.65,
        child: CustomPaint(
          painter: _HalfDonutPainter(
            assetsRatio: assetsRatio * _anim.value,
            assetsColor: cs.primary,
            liabilitiesColor: const Color(0xFFFF5252),
          ),
          child: Align(
            alignment: const Alignment(0, 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SAR', style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 11, color: cs.onBackground.withOpacity(0.55))),
                Text(_fmt(widget.netWorth),
                  style: AppTextStyles.amountMedium.copyWith(
                    fontSize: 18, fontWeight: FontWeight.w700,
                    color: cs.onBackground)),
              ],
            ),
          ),
        ),
      ),
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

class _HalfDonutPainter extends CustomPainter {
  final double assetsRatio;
  final Color assetsColor;
  final Color liabilitiesColor;
  const _HalfDonutPainter({
    required this.assetsRatio,
    required this.assetsColor,
    required this.liabilitiesColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.9);
    final outerR = size.width / 2 - 4;
    final innerR = outerR * 0.68;
    final strokeW = outerR - innerR;
    final rect = Rect.fromCircle(center: center, radius: (outerR + innerR) / 2);

    // Assets arc (left side → up → right, proportion)
    final assetsSweep = math.pi * assetsRatio;
    // Liabilities arc
    final liabSweep   = math.pi * (1 - assetsRatio);

    // Track
    canvas.drawArc(rect, math.pi, math.pi, false,
      Paint()..style = PaintingStyle.stroke..strokeWidth = strokeW
        ..color = Colors.grey.withOpacity(0.12));

    // Assets
    canvas.drawArc(rect, math.pi, assetsSweep, false,
      Paint()..style = PaintingStyle.stroke..strokeWidth = strokeW
        ..color = assetsColor..strokeCap = StrokeCap.butt);

    // Liabilities
    canvas.drawArc(rect, math.pi + assetsSweep, liabSweep, false,
      Paint()..style = PaintingStyle.stroke..strokeWidth = strokeW
        ..color = liabilitiesColor..strokeCap = StrokeCap.butt);
  }

  @override
  bool shouldRepaint(covariant _HalfDonutPainter old) =>
      old.assetsRatio != assetsRatio;
}
