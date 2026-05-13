// lib/features/reports/controller/reports_controller.dart
// ─────────────────────────────────────────────────────────────────────────────
// GetX controller for the Reports screen.
//
// Responsibilities:
//   • Holds all reactive state (period, metrics, categories, etc.)
//   • Provides period-filter logic (swapping data per period)
//   • Delegates file generation to ExportService
//   • Shows Get.snackbar feedback on export completion
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../model/reports_models.dart';
import '../services/export_service.dart';

class ReportsController extends GetxController {
  // ── Period filter ─────────────────────────────────────────────────────────
  final Rx<ReportPeriod> selectedPeriod = ReportPeriod.month.obs;

  // ── Summary metrics ───────────────────────────────────────────────────────
  final RxList<SummaryMetric> metrics = <SummaryMetric>[].obs;

  // ── Category donut ────────────────────────────────────────────────────────
  final RxList<CategorySlice> categories = <CategorySlice>[].obs;

  // ── Daily spending chart ──────────────────────────────────────────────────
  final RxList<DailyPoint> dailyPoints = <DailyPoint>[].obs;
  final RxString chartMonth = 'April 2026'.obs;

  // ── Month-over-month ──────────────────────────────────────────────────────
  final RxList<MonthlyComparison> monthlyComparisons =
      <MonthlyComparison>[].obs;
  final RxDouble monthDelta = 0.0.obs; // delta vs previous month

  // ── Top merchants ─────────────────────────────────────────────────────────
  final RxList<MerchantSpend> merchants = <MerchantSpend>[].obs;

  // ── Export loading states ─────────────────────────────────────────────────
  final RxBool isPdfExporting = false.obs;
  final RxBool isCsvExporting = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData(ReportPeriod.month);

    // Reactively reload data whenever the period changes
    ever(selectedPeriod, _loadData);
  }

  // ── Period selection ───────────────────────────────────────────────────────
  void selectPeriod(ReportPeriod period) => selectedPeriod.value = period;

  // ── Data loading ───────────────────────────────────────────────────────────
  Future<void> _loadData(ReportPeriod period) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 250)); // simulate API

    // In a real app, pass `period` to the API call
    metrics.assignAll(ReportsMockData.summaryMetrics);
    categories.assignAll(ReportsMockData.categorySlices);
    dailyPoints.assignAll(ReportsMockData.dailyPoints);
    monthlyComparisons.assignAll(ReportsMockData.monthlyComparisons);
    monthDelta.value = ReportsMockData.monthOverMonthDelta;
    merchants.assignAll(ReportsMockData.topMerchants);

    // Update chart label based on period
    chartMonth.value = _periodLabel(period);
    isLoading.value = false;
  }

  Future<void> refresh() => _loadData(selectedPeriod.value);

  // ── Export orchestration ──────────────────────────────────────────────────
  Future<void> exportPdf() async {
    if (isPdfExporting.value) return;
    isPdfExporting.value = true;

    final result = await ExportService.exportPdf(
      metrics: metrics,
      categories: categories,
      merchants: merchants,
      period: selectedPeriod.value.label,
    );

    isPdfExporting.value = false;
    _handleExportResult(result);
  }

  Future<void> exportCsv() async {
    if (isCsvExporting.value) return;
    isCsvExporting.value = true;

    final result = await ExportService.exportCsv(
      metrics: metrics,
      categories: categories,
      merchants: merchants,
      period: selectedPeriod.value.label,
    );

    isCsvExporting.value = false;
    _handleExportResult(result);
  }

  // ── Share card (placeholder — extend with share_plus package) ─────────────
  void shareCard() {
    Get.snackbar(
      'reports_share_card_label'.tr,
      'reports_share_coming_soon'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surfaceCard,
      colorText: AppColors.textPrimary,
      icon: Icon(Icons.share_rounded,
          color: Get.find<ThemeController>().accentColor.value),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // ── Result feedback ────────────────────────────────────────────────────────
  void _handleExportResult(ExportResult result) {
    if (result.success) {
      Get.snackbar(
        'reports_export_success'.tr,
        'reports_file_saved'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
        icon: const Icon(Icons.check_circle_rounded, color: AppColors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: () {
            if (result.filePath != null) OpenFilex.open(result.filePath!);
          },
          child: Text(
            'reports_open'.tr,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } else {
      Get.snackbar(
        'reports_export_failed'.tr,
        result.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        icon: const Icon(Icons.error_rounded, color: AppColors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String _periodLabel(ReportPeriod p) {
    switch (p) {
      case ReportPeriod.week:
        return 'This Week';
      case ReportPeriod.month:
        return 'April 2026';
      case ReportPeriod.quarter:
        return 'Q2 2026';
      case ReportPeriod.year:
        return 'Year 2026';
    }
  }

  /// Max amount across monthly comparisons — used to normalize bar heights
  double get maxMonthlyAmount => monthlyComparisons.isEmpty
      ? 1
      : monthlyComparisons.map((m) => m.amount).reduce((a, b) => a > b ? a : b);
}
