// lib/features/reports/controller/reports_controller.dart
// Reports v2 — controls all 4 tabs + period chips + exports
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import '../model/reports_models.dart';
import '../services/export_service.dart';
import '../../../core/constants/app_colors.dart';

class ReportsController extends GetxController {
  // ── Tab + Period state ────────────────────────────────────────────────────
  final Rx<ReportsTab>    activeTab    = ReportsTab.overview.obs;
  final Rx<ReportPeriod>  activePeriod = ReportPeriod.m1.obs;
  final RxBool isLoading = false.obs;

  // ── Overview data ─────────────────────────────────────────────────────────
  final RxDouble totalBalance   = ReportsMockData.totalBalance.obs;
  final RxDouble balanceChange  = ReportsMockData.balanceChange.obs;
  final RxDouble totalIncome    = ReportsMockData.totalIncome.obs;
  final RxDouble incomeChange   = ReportsMockData.incomeChange.obs;
  final RxDouble totalExpenses  = ReportsMockData.totalExpenses.obs;
  final RxDouble expensesChange = ReportsMockData.expensesChange.obs;
  final RxList<CategorySlice> spendingBreakdown = <CategorySlice>[].obs;
  final RxList<IvsEPoint>     incomeVsExpenses   = <IvsEPoint>[].obs;

  // ── Income tab data ───────────────────────────────────────────────────────
  final RxList<DailyPoint>    dailyIncome      = <DailyPoint>[].obs;
  final RxList<CategorySlice> incomeBreakdown  = <CategorySlice>[].obs;
  final RxList<IncomeSource>  incomeSources    = <IncomeSource>[].obs;

  // ── Expenses tab data ─────────────────────────────────────────────────────
  final RxList<DailyPoint>      dailyExpenses        = <DailyPoint>[].obs;
  final RxList<CategorySlice>   expenseBreakdown     = <CategorySlice>[].obs;
  final RxList<ExpenseCategory> topExpenseCategories = <ExpenseCategory>[].obs;

  // ── Net Worth tab data ────────────────────────────────────────────────────
  final RxDouble netWorth       = ReportsMockData.netWorth.obs;
  final RxDouble netWorthChange = ReportsMockData.netWorthChange.obs;
  final RxDouble assets         = ReportsMockData.assets.obs;
  final RxDouble liabilities    = ReportsMockData.liabilities.obs;
  final RxList<TrendPoint>      netWorthTrend   = <TrendPoint>[].obs;
  final RxList<NetWorthEntry>   netWorthHistory = <NetWorthEntry>[].obs;

  // ── Export ────────────────────────────────────────────────────────────────
  final RxBool isPdfExporting = false.obs;
  final RxBool isCsvExporting = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAll();
    ever(activePeriod, (_) => _loadAll());
  }

  void setTab(ReportsTab tab)       => activeTab.value = tab;
  void setPeriod(ReportPeriod p)    => activePeriod.value = p;
  Future<void> refresh()            => _loadAll();

  Future<void> _loadAll() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 200));
    spendingBreakdown.assignAll(ReportsMockData.spendingBreakdown);
    incomeVsExpenses.assignAll(ReportsMockData.incomeVsExpenses);
    dailyIncome.assignAll(ReportsMockData.dailyIncome);
    incomeBreakdown.assignAll(ReportsMockData.incomeBreakdown);
    incomeSources.assignAll(ReportsMockData.incomeSources);
    dailyExpenses.assignAll(ReportsMockData.dailyExpenses);
    expenseBreakdown.assignAll(ReportsMockData.expenseBreakdown);
    topExpenseCategories.assignAll(ReportsMockData.topExpenseCategories);
    netWorthTrend.assignAll(ReportsMockData.netWorthTrend);
    netWorthHistory.assignAll(ReportsMockData.netWorthHistory);
    isLoading.value = false;
  }

  // ── Export sheet ──────────────────────────────────────────────────────────
  void showExportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ExportSheet(controller: this),
    );
  }

  Future<void> exportPdf() async {
    if (isPdfExporting.value) return;
    isPdfExporting.value = true;
    final result = await ExportService.exportPdf(
      metrics: [],
      categories: spendingBreakdown
          .map((s) => s)
          .toList(),
      merchants: [],
      period: activePeriod.value.labelKey.tr,
    );
    isPdfExporting.value = false;
    _handleExport(result);
  }

  Future<void> exportCsv() async {
    if (isCsvExporting.value) return;
    isCsvExporting.value = true;
    final result = await ExportService.exportCsv(
      metrics: [],
      categories: spendingBreakdown.toList(),
      merchants: [],
      period: activePeriod.value.labelKey.tr,
    );
    isCsvExporting.value = false;
    _handleExport(result);
  }

  void _handleExport(ExportResult result) {
    Get.back(); // close sheet
    if (result.success) {
      Get.snackbar('reports_export_success'.tr, 'reports_file_saved'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success, colorText: AppColors.white,
        margin: const EdgeInsets.all(16), borderRadius: 12,
        mainButton: TextButton(
          onPressed: () { if (result.filePath != null) OpenFilex.open(result.filePath!); },
          child: Text('reports_open'.tr, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w700)),
        ),
      );
    } else {
      Get.snackbar('reports_export_failed'.tr, result.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error, colorText: AppColors.white,
        margin: const EdgeInsets.all(16), borderRadius: 12,
      );
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String fmtAmount(double v) {
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

  String get periodDateLabel => 'rpt_may_2026'.tr;
}

// ── Export Bottom Sheet ───────────────────────────────────────────────────────
class _ExportSheet extends StatelessWidget {
  final ReportsController controller;
  const _ExportSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? AppColors.darkSurface : AppColors.white;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24,
          MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(child: Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: cs.onBackground.withOpacity(0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          )),
          const SizedBox(height: 20),
          Text('rpt_export_report'.tr,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18,
              fontWeight: FontWeight.w700, color: cs.onBackground)),
          const SizedBox(height: 20),
          _ExportOption(
            icon: Icons.picture_as_pdf_outlined,
            title: 'rpt_export_as_pdf'.tr,
            subtitle: 'rpt_export_pdf_sub'.tr,
            onTap: controller.exportPdf,
          ),
          _ExportOption(
            icon: Icons.table_chart_outlined,
            title: 'rpt_export_as_csv'.tr,
            subtitle: 'rpt_export_csv_sub'.tr,
            onTap: controller.exportCsv,
          ),
          _ExportOption(
            icon: Icons.share_outlined,
            title: 'rpt_share_summary'.tr,
            subtitle: 'rpt_share_summary_sub'.tr,
            onTap: () => Get.snackbar('rpt_share_summary'.tr,
              'reports_share_coming_soon'.tr,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16)),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  const _ExportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: cs.primary, size: 22),
          ),
          title: Text(title, style: TextStyle(
            fontFamily: 'Poppins', fontSize: 14,
            fontWeight: FontWeight.w600, color: cs.onBackground)),
          subtitle: Text(subtitle, style: TextStyle(
            fontFamily: 'Poppins', fontSize: 12,
            color: cs.onBackground.withOpacity(0.50))),
          trailing: Icon(Icons.chevron_right_rounded,
            color: cs.onBackground.withOpacity(0.30)),
          onTap: onTap,
        ),
        if (showDivider) Divider(height: 1,
          color: cs.onBackground.withOpacity(0.08)),
      ],
    );
  }
}
