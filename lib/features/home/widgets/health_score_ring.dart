import 'package:get/get.dart';
import '../../../core/theme/theme_controller.dart';
// lib/features/home/widgets/health_score_ring.dart
// ─────────────────────────────────────────────────────────────────────────────
// Custom painted ring showing the financial health score.
// Uses CustomPainter for smooth arc rendering — no third-party chart lib needed.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class HealthScoreRing extends StatefulWidget {
  final int score;         // 0 – 100
  final String label;
  final double size;

  const HealthScoreRing({
    super.key,
    required this.score,
    required this.label,
    this.size = 100,
  });

  @override
  State<HealthScoreRing> createState() => _HealthScoreRingState();
}

class _HealthScoreRingState extends State<HealthScoreRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Map score to a gradient of colors
  Color get _scoreColor {
    if (widget.score >= 80) return AppColors.success;
    if (widget.score >= 60) return Get.find<ThemeController>().accentColor.value;
    if (widget.score >= 40) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (_, __) => CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _RingPainter(
              progress: (widget.score / 100) * _animation.value,
              scoreColor: _scoreColor,
              trackColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white12
                : const Color(0xFFE8EAED),
              strokeWidth: 9,
            ),
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(widget.score * _animation.value).round()}',
                      style: AppTextStyles.amountLarge.copyWith(fontSize: 26),
                    ),
                    Text(
                      'pts',
                      style: AppTextStyles.labelSmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Financial Health',
          style: AppTextStyles.labelMedium,
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_upward_rounded, size: 12, color: _scoreColor),
            const SizedBox(width: 2),
            Text(
              widget.label,
              style: AppTextStyles.labelMedium.copyWith(
                color: _scoreColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Custom Ring Painter ───────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;   // 0.0 – 1.0
  final Color scoreColor;
  final Color trackColor;
  final double strokeWidth;

  const _RingPainter({
    required this.progress,
    required this.scoreColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);
    const startAngle = -math.pi / 2;    // top
    final sweepAngle = 2 * math.pi * progress;

    // Track (background arc)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = trackColor
        ..strokeCap = StrokeCap.round,
    );

    if (progress > 0) {
      // Progress arc with gradient
      final gradientPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          colors: [scoreColor.withOpacity(0.6), scoreColor],
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          tileMode: TileMode.clamp,
          transform: const GradientRotation(-math.pi / 2),
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        gradientPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.scoreColor != scoreColor;
}
