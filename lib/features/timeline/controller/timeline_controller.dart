// lib/features/timeline/controller/timeline_controller.dart
// ─────────────────────────────────────────────────────────────────────────────
// GetX controller for the Transaction Timeline feature.
//
// Responsibilities:
//   • Owns the master transaction list (swap with API later)
//   • Manages active filter (Daily / Weekly / Monthly)
//   • Tracks selected month, day, and week
//   • Computes filtered/grouped transactions reactively
//   • Exposes calendar dot data (days with expenses in current month)
//   • Computes weekly totals and week labels
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/timeline_models.dart';

class TimelineController extends GetxController {
  // ── Master data (replace with repository call in production) ──────────────
  final List<TimelineTransaction> _allTransactions =
      TimelineMockData.transactions;

  // ── Filter state ──────────────────────────────────────────────────────────
  final Rx<TimelineFilter> activeFilter = TimelineFilter.monthly.obs;

  // ── Calendar state ────────────────────────────────────────────────────────
  // Currently displayed month/year in the calendar header
  final RxInt displayYear = 2026.obs;
  final RxInt displayMonth = 4.obs; // 1-based (April = 4)

  // Selected day (for daily filter). null = no day selected
  final Rxn<DateTime> selectedDay = Rxn<DateTime>();

  // Selected week index within the displayed month (0-based)
  // null = no week selected; set when user taps a week chip
  final Rxn<int> selectedWeekIndex = Rxn<int>();

  // ── Initialise with today's date ──────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    // Default to April 2026 (mock data month) if we're past that date,
    // otherwise use actual current date so it looks correct on any device
    displayYear.value = 2026;
    displayMonth.value = 4;
    // Pre-select today (April 29) to match the design screenshot
    selectedDay.value = DateTime(2026, 4, 29);
    selectedWeekIndex.value = _weekIndexOf(selectedDay.value!);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // FILTER ACTIONS
  // ──────────────────────────────────────────────────────────────────────────

  void setFilter(TimelineFilter f) {
    activeFilter.value = f;
    // Reset irrelevant selections when switching filters
    if (f == TimelineFilter.monthly) {
      selectedDay.value = null;
      selectedWeekIndex.value = null;
    } else if (f == TimelineFilter.weekly && selectedWeekIndex.value == null) {
      selectedWeekIndex.value = weeksInDisplayMonth.length - 1;
    } else if (f == TimelineFilter.daily && selectedDay.value == null) {
      // Default to first day of month
      selectedDay.value = DateTime(displayYear.value, displayMonth.value, 1);
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // CALENDAR NAVIGATION
  // ──────────────────────────────────────────────────────────────────────────

  void previousMonth() {
    var m = displayMonth.value - 1;
    var y = displayYear.value;
    if (m < 1) {
      m = 12;
      y--;
    }
    displayMonth.value = m;
    displayYear.value = y;
    // Clear day/week selection — they belong to the old month
    selectedDay.value = null;
    selectedWeekIndex.value = null;
  }

  void nextMonth() {
    var m = displayMonth.value + 1;
    var y = displayYear.value;
    if (m > 12) {
      m = 1;
      y++;
    }
    displayMonth.value = m;
    displayYear.value = y;
    selectedDay.value = null;
    selectedWeekIndex.value = null;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // DAY SELECTION
  // ──────────────────────────────────────────────────────────────────────────

  void selectDay(DateTime day) {
    selectedDay.value = day;
    selectedWeekIndex.value = _weekIndexOf(day);
    // Tapping a day always shows daily filter
    activeFilter.value = TimelineFilter.daily;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // WEEK SELECTION
  // ──────────────────────────────────────────────────────────────────────────

  void selectWeek(int weekIndex) {
    selectedWeekIndex.value = weekIndex;
    activeFilter.value = TimelineFilter.weekly;
    // Also clear any precise day selection
    selectedDay.value = null;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // COMPUTED: Transactions for the display month
  // ──────────────────────────────────────────────────────────────────────────

  List<TimelineTransaction> get monthTransactions {
    return _allTransactions
        .where((t) =>
            t.date.year == displayYear.value &&
            t.date.month == displayMonth.value)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // ──────────────────────────────────────────────────────────────────────────
  // COMPUTED: Filtered transactions shown in the list (reactive getter)
  // ──────────────────────────────────────────────────────────────────────────

  List<TimelineTransaction> get filteredTransactions {
    switch (activeFilter.value) {
      case TimelineFilter.monthly:
        return monthTransactions;

      case TimelineFilter.daily:
        final day = selectedDay.value;
        if (day == null) return [];
        return monthTransactions
            .where((t) =>
                t.date.year == day.year &&
                t.date.month == day.month &&
                t.date.day == day.day)
            .toList();

      case TimelineFilter.weekly:
        final idx = selectedWeekIndex.value;
        if (idx == null) return [];
        final weeks = weeksInDisplayMonth;
        if (idx >= weeks.length) return [];
        final weekDays = weeks[idx];
        if (weekDays.isEmpty) return [];
        final first = weekDays.first;
        final last = weekDays.last;
        return monthTransactions
            .where((t) =>
                !t.date.isBefore(first) &&
                !t.date
                    .isAfter(DateTime(last.year, last.month, last.day, 23, 59)))
            .toList();
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // COMPUTED: Total displayed in the bottom summary bar
  // ──────────────────────────────────────────────────────────────────────────

  double get displayTotal => filteredTransactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.absAmount);

  double get monthTotal => monthTransactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.absAmount);

  // ──────────────────────────────────────────────────────────────────────────
  // COMPUTED: Days that have at least one expense (for calendar dots)
  // ──────────────────────────────────────────────────────────────────────────

  /// Map from day-of-month → list of category colors for dots
  Map<int, List<TxCategory>> get dotMap {
    final result = <int, List<TxCategory>>{};
    for (final t in monthTransactions) {
      if (t.isIncome) continue; // don't show income dots
      result.putIfAbsent(t.date.day, () => []).add(t.category);
    }
    return result;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // COMPUTED: Calendar grid data
  // ──────────────────────────────────────────────────────────────────────────

  /// All weeks in the displayed month.
  /// Each week is a list of 7 nullable DateTimes (null = day outside month).
  List<List<DateTime?>> get calendarGrid {
    final firstDay = DateTime(displayYear.value, displayMonth.value, 1);
    final daysInMonth =
        DateUtils.getDaysInMonth(displayYear.value, displayMonth.value);
    // weekday: Mon=1 … Sun=7; we want Sunday=0 offset
    final startOffset = (firstDay.weekday % 7); // Sun=0, Mon=1 … Sat=6

    final List<List<DateTime?>> weeks = [];
    List<DateTime?> week = List.filled(7, null);
    var col = startOffset;

    for (var d = 1; d <= daysInMonth; d++) {
      week[col] = DateTime(displayYear.value, displayMonth.value, d);
      col++;
      if (col == 7) {
        weeks.add(week);
        week = List.filled(7, null);
        col = 0;
      }
    }
    if (col > 0) weeks.add(week); // last partial week
    return weeks;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // COMPUTED: Week ranges for the W1/W2/W3... chips
  // ──────────────────────────────────────────────────────────────────────────

  /// Returns weeks as lists of actual DateTime objects (non-null days only)
  List<List<DateTime>> get weeksInDisplayMonth {
    return calendarGrid
        .map((row) => row.whereType<DateTime>().toList())
        .where((w) => w.isNotEmpty)
        .toList();
  }

  /// Weekly expense totals indexed by week position
  List<double> get weeklyTotals {
    final weeks = weeksInDisplayMonth;
    return weeks.map((week) {
      final first = week.first;
      final last = week.last;
      return monthTransactions
          .where((t) =>
              !t.isIncome &&
              !t.date.isBefore(first) &&
              !t.date
                  .isAfter(DateTime(last.year, last.month, last.day, 23, 59)))
          .fold(0.0, (sum, t) => sum + t.absAmount);
    }).toList();
  }

  double get maxWeeklyTotal {
    final totals = weeklyTotals;
    if (totals.isEmpty) return 1;
    return totals.reduce((a, b) => a > b ? a : b).clamp(1, double.infinity);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ──────────────────────────────────────────────────────────────────────────

  /// Returns 0-based week index within the month for a given date
  int _weekIndexOf(DateTime date) {
    final weeks = weeksInDisplayMonth;
    for (var i = 0; i < weeks.length; i++) {
      if (weeks[i].any((d) => d.day == date.day)) return i;
    }
    return 0;
  }

  /// Label for the summary bar based on active filter
  String get summaryLabel {
    switch (activeFilter.value) {
      case TimelineFilter.daily:
        final d = selectedDay.value;
        if (d == null) return 'timeline_day_total'.tr;
        return '${_monthName(d.month)} ${d.day} – ${'timeline_transactions'.tr}';
      case TimelineFilter.weekly:
        final i = selectedWeekIndex.value;
        return i == null
            ? 'timeline_week_total'.tr
            : '${'timeline_week_total'.tr} W${i + 1}';
      case TimelineFilter.monthly:
        return 'timeline_month_total'.tr;
    }
  }

  String _monthName(int month) {
    const names = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[month];
  }

  String get displayMonthName {
    const names = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[displayMonth.value];
  }

  bool isDaySelected(DateTime day) =>
      selectedDay.value?.year == day.year &&
      selectedDay.value?.month == day.month &&
      selectedDay.value?.day == day.day;
}
