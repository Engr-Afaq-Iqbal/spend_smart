// lib/features/reports/widgets/daily_spending_chart.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/reports_controller.dart';
import '../model/reports_models.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_header.dart';

class DailySpendingChart extends GetView<ReportsController> {
  const DailySpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTxt = cs.onBackground.withOpacity(0.50);

    return Column(
      children: [
        SectionHeader(title: 'reports_daily_spending'.tr),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
          child: Obx(() => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(controller.chartMonth.value,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 12, color: subTxt)),
                      Row(
                        children: [
                          _LegendItem(color: cs.primary, label: 'reports_actual'.tr, isDashed: false),
                          const SizedBox(width: AppSpacing.md),
                          _LegendItem(color: AppColors.warning, label: 'reports_avg'.tr, isDashed: true),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _AnimatedLineChart(points: controller.dailyPoints, height: 130),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const ['1', '7', '14', '21', '30'].map((d) =>
                        Text(d, style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
                            color: Colors.grey))).toList(),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}

class _AnimatedLineChart extends StatefulWidget {
  final List<DailyPoint> points;
  final double height;
  const _AnimatedLineChart({required this.points, required this.height});

  @override
  State<_AnimatedLineChart> createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<_AnimatedLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant _AnimatedLineChart old) {
    super.didUpdateWidget(old);
    if (old.points != widget.points) _ctrl.forward(from: 0);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final accent = Get.find<ThemeController>().accentColor.value;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => SizedBox(
        width: double.infinity, height: widget.height,
        child: CustomPaint(
          painter: _LineChartPainter(
            points: widget.points,
            progress: _anim.value,
            lineColor: accent,
          ),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<DailyPoint> points;
  final double progress;
  final Color lineColor;
  const _LineChartPainter({required this.points, required this.progress, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxVal = points.map((p) => p.actual).reduce((a, b) => a > b ? a : b);
    final minVal = points.map((p) => p.actual).reduce((a, b) => a < b ? a : b);
    final range  = (maxVal - minVal).clamp(1.0, double.infinity);
    final vPad   = size.height * 0.08;

    Offset toXY(int index, double value) {
      final x = (index / (points.length - 1)) * size.width;
      final y = vPad + (1 - (value - minVal) / range) * (size.height - vPad * 2);
      return Offset(x, y);
    }

    final visibleCount = (points.length * progress).ceil().clamp(2, points.length);
    final visible = points.sublist(0, visibleCount);
    final coords = List.generate(visible.length, (i) => toXY(i, visible[i].actual));

    final linePath = Path();
    linePath.moveTo(coords.first.dx, coords.first.dy);
    for (var i = 1; i < coords.length; i++) {
      final prev = coords[i - 1];
      final curr = coords[i];
      final cpX = (prev.dx + curr.dx) / 2;
      linePath.cubicTo(cpX, prev.dy, cpX, curr.dy, curr.dx, curr.dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(coords.last.dx, size.height)
      ..lineTo(coords.first.dx, size.height)
      ..close();

    canvas.drawPath(fillPath, Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero, Offset(0, size.height),
        [lineColor.withOpacity(0.22), lineColor.withOpacity(0.0)],
      ));

    canvas.drawPath(linePath, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round);

    for (final pt in coords) {
      canvas.drawCircle(pt, 3, Paint()..color = lineColor);
    }

    // Dashed avg line
    if (points.isNotEmpty) {
      final avgY = toXY(0, points.first.avg).dy;
      _drawDashed(canvas, Offset(0, avgY), Offset(size.width * progress, avgY),
          AppColors.warning);
    }
  }

  void _drawDashed(Canvas canvas, Offset start, Offset end, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    final dir   = end - start;
    final total = dir.distance;
    final unit  = dir / total;
    double drawn = 0;
    while (drawn < total) {
      final segEnd = (drawn + 6).clamp(0.0, total);
      canvas.drawLine(start + unit * drawn, start + unit * segEnd, paint);
      drawn += 10;
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) =>
      old.progress != progress || old.points != points || old.lineColor != lineColor;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDashed;
  const _LegendItem({required this.color, required this.label, required this.isDashed});

  @override
  Widget build(BuildContext context) {
    final subTxt = Theme.of(context).colorScheme.onBackground.withOpacity(0.55);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18, height: 2,
          child: isDashed
              ? CustomPaint(painter: _DashPainter(color: color))
              : DecoratedBox(decoration: BoxDecoration(color: color,
                  borderRadius: BorderRadius.circular(2))),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: subTxt)),
      ],
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  const _DashPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(0, 1), const Offset(6, 1), p);
    canvas.drawLine(const Offset(10, 1), const Offset(18, 1), p);
  }
  @override
  bool shouldRepaint(_) => false;
}
