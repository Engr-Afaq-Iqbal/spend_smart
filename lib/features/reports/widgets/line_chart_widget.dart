// lib/features/reports/widgets/line_chart_widget.dart
// ─────────────────────────────────────────────────────────────────────────────
// Animated line chart for:
//   • Income vs Expenses (two lines with gradient fills)
//   • Net Worth trend (single smooth line with gradient fill + dots)
// Pure CustomPainter — no fl_chart dependency needed for these simple charts.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../model/reports_models.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_colors.dart';

// ── Income vs Expenses chart ──────────────────────────────────────────────────
class IncomeVsExpensesChart extends StatefulWidget {
  final List<IvsEPoint> points;
  final double height;
  const IncomeVsExpensesChart({
    super.key,
    required this.points,
    this.height = 140,
  });
  @override
  State<IncomeVsExpensesChart> createState() => _IvsEChartState();
}

class _IvsEChartState extends State<IncomeVsExpensesChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 1100));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.forward();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => SizedBox(
            width: double.infinity,
            height: widget.height,
            child: CustomPaint(
              painter: _IvsEPainter(
                points: widget.points,
                progress: _anim.value,
                isDark: isDark,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // X-axis labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['1', '5', '10', '15', '20', '25', '30'].map((l) =>
            Text(l, style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              color: cs.onBackground.withOpacity(0.35)))).toList(),
        ),
        const SizedBox(height: 10),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: AppColors.categoryShopping, label: 'Income'),
            const SizedBox(width: 20),
            _LegendDot(color: AppColors.categoryFood, label: 'Expenses'),
          ],
        ),
      ],
    );
  }
}

class _IvsEPainter extends CustomPainter {
  final List<IvsEPoint> points;
  final double progress;
  final bool isDark;
  const _IvsEPainter({required this.points, required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final allVals = points.expand((p) => [p.income, p.expenses]);
    final maxVal  = allVals.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return;

    final vPad = size.height * 0.05;

    Offset toXY(int idx, double val) {
      final x = (idx / (points.length - 1)) * size.width;
      final y = vPad + (1 - val / maxVal) * (size.height - vPad * 2);
      return Offset(x, y);
    }

    void drawLine(List<double> vals, Color color) {
      final visibleCount = (points.length * progress).ceil().clamp(2, points.length);
      final coords = List.generate(visibleCount, (i) => toXY(i, vals[i]));

      final path = Path()..moveTo(coords.first.dx, coords.first.dy);
      for (var i = 1; i < coords.length; i++) {
        final prev = coords[i - 1];
        final curr = coords[i];
        final cpX  = (prev.dx + curr.dx) / 2;
        path.cubicTo(cpX, prev.dy, cpX, curr.dy, curr.dx, curr.dy);
      }

      // Fill
      final fill = Path.from(path)
        ..lineTo(coords.last.dx, size.height)
        ..lineTo(coords.first.dx, size.height)
        ..close();
      canvas.drawPath(fill, Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, 0), Offset(0, size.height),
          [color.withOpacity(0.18), color.withOpacity(0.0)]));

      // Stroke
      canvas.drawPath(path, Paint()
        ..style  = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color  = color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round);
    }

    drawLine(points.map((p) => p.income).toList(),   AppColors.categoryShopping);
    drawLine(points.map((p) => p.expenses).toList(), AppColors.categoryFood);
  }

  @override
  bool shouldRepaint(covariant _IvsEPainter old) => old.progress != progress;
}

// ── Net Worth trend line ──────────────────────────────────────────────────────
class NetWorthTrendChart extends StatefulWidget {
  final List<TrendPoint> points;
  final double height;
  const NetWorthTrendChart({
    super.key,
    required this.points,
    this.height = 160,
  });
  @override
  State<NetWorthTrendChart> createState() => _NWTrendState();
}

class _NWTrendState extends State<NetWorthTrendChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 1200));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.forward();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs    = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const purple = Color(0xFF9C27B0);

    return Column(
      children: [
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => SizedBox(
            width: double.infinity,
            height: widget.height,
            child: CustomPaint(
              painter: _TrendPainter(
                points: widget.points,
                progress: _anim.value,
                lineColor: purple,
                isDark: isDark,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Month labels — show only non-empty labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.points
              .where((p) => p.label.isNotEmpty)
              .map((p) => Text(p.label,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 10,
                  color: cs.onBackground.withOpacity(0.35))))
              .toList(),
        ),
      ],
    );
  }
}

class _TrendPainter extends CustomPainter {
  final List<TrendPoint> points;
  final double progress;
  final Color lineColor;
  final bool isDark;

  const _TrendPainter({
    required this.points,
    required this.progress,
    required this.lineColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final minVal = points.map((p) => p.value).reduce((a, b) => a < b ? a : b);
    final maxVal = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final range  = (maxVal - minVal).clamp(1.0, double.infinity);
    const vPad   = 12.0;

    Offset toXY(int idx, double val) {
      final x = (idx / (points.length - 1)) * size.width;
      final y = vPad + (1 - (val - minVal) / range) * (size.height - vPad * 2);
      return Offset(x, y);
    }

    final visibleCount = (points.length * progress).ceil().clamp(2, points.length);
    final coords = List.generate(visibleCount, (i) => toXY(i, points[i].value));

    final path = Path()..moveTo(coords.first.dx, coords.first.dy);
    for (var i = 1; i < coords.length; i++) {
      final prev = coords[i - 1]; final curr = coords[i];
      final cpX  = (prev.dx + curr.dx) / 2;
      path.cubicTo(cpX, prev.dy, cpX, curr.dy, curr.dx, curr.dy);
    }

    // Gradient fill
    final fill = Path.from(path)
      ..lineTo(coords.last.dx, size.height)
      ..lineTo(coords.first.dx, size.height)
      ..close();
    canvas.drawPath(fill, Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0), Offset(0, size.height),
        [lineColor.withOpacity(0.25), lineColor.withOpacity(0.0)]));

    // Line
    canvas.drawPath(path, Paint()
      ..style = PaintingStyle.stroke..strokeWidth = 2.5
      ..color = lineColor..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);

    // Dots
    for (final pt in coords) {
      canvas.drawCircle(pt, 4, Paint()..color = Colors.white);
      canvas.drawCircle(pt, 3, Paint()..color = lineColor);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter old) => old.progress != progress;
}

// ── Shared legend dot ─────────────────────────────────────────────────────────
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 2.5,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.55))),
      ],
    );
  }
}
