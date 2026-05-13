// lib/features/timeline/widgets/calendar_widget.dart
// ─────────────────────────────────────────────────────────────────────────────
// Full monthly calendar grid with:
//   • Day-of-week header (S M T W T F S)
//   • Month + year title with ← → navigation
//   • "Total spent: SAR X,XXX" subtitle
//   • Colored dots below dates that have transactions
//   • Tappable dates — selected day gets filled accent circle
//   • Theme-aware (light / dark)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spend_smart/features/timeline/model/timeline_models.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controller/timeline_controller.dart';

class CalendarWidget extends GetView<TimelineController> {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final grid = controller.calendarGrid;
      final dotMap = controller.dotMap;
      final accent = cs.primary;
      final onBg = cs.onBackground;
      final subColor = onBg.withOpacity(0.50);
      final headerColor = onBg.withOpacity(0.40);

      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // ── Month title + navigation arrows ────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Prev month arrow
                _NavArrow(
                  icon: Icons.chevron_left_rounded,
                  onTap: controller.previousMonth,
                  isDark: isDark,
                ),

                // Month + year + total spent
                Column(
                  children: [
                    Text(
                      '${controller.displayMonthName} ${controller.displayYear.value}',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontSize: 15,
                        color: onBg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${'timeline_total_spent'.tr}: SAR ${_fmt(controller.monthTotal)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11.5,
                        color: subColor,
                      ),
                    ),
                  ],
                ),

                // Next month arrow
                _NavArrow(
                  icon: Icons.chevron_right_rounded,
                  onTap: controller.nextMonth,
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── Day-of-week header ──────────────────────────────────────
            Row(
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 11,
                            color: headerColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── Calendar grid ────────────────────────────────────────────
            ...grid.map((week) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: week.map((day) {
                      if (day == null) {
                        return const Expanded(child: SizedBox(height: 44));
                      }
                      final isSelected = controller.isDaySelected(day);
                      final dots = dotMap[day.day];
                      final hasData = dots != null && dots.isNotEmpty;
                      final isToday = _isToday(day);

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectDay(day),
                          child: SizedBox(
                            height: 44,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Day number with selection circle
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? accent
                                        : isToday
                                            ? accent.withOpacity(0.12)
                                            : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontSize: 13,
                                        fontWeight: isSelected || isToday
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? Colors.white
                                            : isToday
                                                ? accent
                                                : onBg,
                                      ),
                                    ),
                                  ),
                                ),

                                // Transaction dots — max 3 shown
                                if (hasData) ...[
                                  const SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: dots!
                                        .take(3)
                                        .map((cat) => Container(
                                              width: 4,
                                              height: 4,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? Colors.white
                                                        .withOpacity(0.8)
                                                    : cat.color,
                                                shape: BoxShape.circle,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ] else
                                  const SizedBox(
                                      height: 6), // keep height consistent
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )),
          ],
        ),
      );
    });
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  String _fmt(double v) {
    if (v >= 1000) {
      final n = v.toStringAsFixed(0);
      final buf = StringBuffer();
      for (var i = 0; i < n.length; i++) {
        if (i > 0 && (n.length - i) % 3 == 0) buf.write(',');
        buf.write(n[i]);
      }
      return buf.toString();
    }
    return v.toStringAsFixed(0);
  }
}

// ── Navigation arrow button ───────────────────────────────────────────────────
class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _NavArrow(
      {required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.60),
        ),
      ),
    );
  }
}
