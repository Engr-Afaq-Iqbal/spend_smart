// lib/features/reports/widgets/bar_chart_widget.dart
// ─────────────────────────────────────────────────────────────────────────────
// Vertical bar chart — used for Daily Income and Daily Expenses tabs.
// Pure CustomPainter — animated draw-up, responsive, theme-aware.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../model/reports_models.dart';
import '../../../core/constants/app_text_styles.dart';

class DailyBarChart extends StatefulWidget {
  final List<DailyPoint> points;
  final Color barColor;
  final double height;
  final String dateRange;

  const DailyBarChart({
    super.key,
    required this.points,
    required this.barColor,
    this.height = 130,
    required this.dateRange,
  });

  @override
  State<DailyBarChart> createState() => _DailyBarChartState();
}

class _DailyBarChartState extends State<DailyBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant DailyBarChart old) {
    super.didUpdateWidget(old);
    if (old.points != widget.points) _ctrl.forward(from: 0);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // x-axis labels at key positions
    const xLabels = ['1', '5', '10', '15', '20', '25', '30'];

    return Column(
      children: [
        // Chart
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => SizedBox(
            width: double.infinity,
            height: widget.height,
            child: CustomPaint(
              painter: _BarPainter(
                points: widget.points,
                progress: _anim.value,
                barColor: widget.barColor,
                isDark: isDark,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // X-axis labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: xLabels.map((l) => Text(l,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              color: cs.onBackground.withOpacity(0.35)))).toList(),
        ),
      ],
    );
  }
}

class _BarPainter extends CustomPainter {
  final List<DailyPoint> points;
  final double progress;
  final Color barColor;
  final bool isDark;

  const _BarPainter({
    required this.points,
    required this.progress,
    required this.barColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxVal = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return;

    final barWidth = (size.width / points.length) * 0.6;
    final gap      = (size.width / points.length) * 0.4;

    // Horizontal guide lines
    final guidePaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.06)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = size.height - (size.height * (i / 4));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), guidePaint);
    }

    for (var i = 0; i < points.length; i++) {
      final x    = i * (barWidth + gap) + gap / 2;
      final barH = (points[i].value / maxVal) * size.height * progress;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, size.height - barH, barWidth, barH),
        const Radius.circular(3),
      );

      canvas.drawRRect(rect,
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(x, size.height - barH),
            Offset(x, size.height),
            [barColor, barColor.withOpacity(0.6)],
          ));
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) =>
      old.progress != progress || old.points != points;
}
