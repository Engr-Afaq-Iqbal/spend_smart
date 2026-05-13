// lib/features/reports/view/reports_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// Reports v2 — redesigned from scratch to match the new 4-tab dashboard.
//
// Architecture:
//   • NO Scaffold — lives inside PageView in MainNavigation (single Scaffold)
//   • AutomaticKeepAliveClientMixin — scroll position survives tab switches
//   • SliverAppBar with pinned header containing:
//       "Reports" title + hamburger  →  tab bar (Overview|Income|Expenses|NetWorth)
//       Period chips (7D|1M|3M|6M|1Y|📅)
//   • Obx wraps only the tab body — header never rebuilds unnecessarily
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/reports_controller.dart';
import '../model/reports_models.dart';
import '../widgets/reports_shared.dart';
import '../widgets/tabs/overview_tab.dart';
import '../widgets/tabs/income_tab.dart';
import '../widgets/tabs/expenses_tab.dart';
import '../widgets/tabs/net_worth_tab.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});
  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.find<ReportsController>();
    final cs         = Theme.of(context).colorScheme;
    final bgColor    = Theme.of(context).scaffoldBackgroundColor;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: cs.primary));
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        color: cs.primary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            // ── Pinned sticky header ──────────────────────────────────────
            SliverAppBar(
              pinned: true,
              floating: false,
              forceElevated: true,
              backgroundColor: bgColor,
              elevation: 0,
              scrolledUnderElevation: 0.8,
              // Toolbar = title row
              toolbarHeight: 52,
              // expandedHeight = toolbar + tab bar + period chips
              expandedHeight: 52 + 44 + 46,
              automaticallyImplyLeading: false,

              // ── Title row ───────────────────────────────────────────────
              title: Text('rpt_reports'.tr,
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18, color: cs.onBackground)),
              titleSpacing: AppSpacing.pagePadding,
              actions: [
                IconButton(
                  icon: Icon(Icons.tune_rounded,
                    color: cs.onBackground.withOpacity(0.65), size: 22),
                  onPressed: () {},
                ),
              ],

              // ── Tab bar + period chips ───────────────────────────────────
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(44 + 46),
                child: Container(
                  color: bgColor,
                  child: Column(
                    children: [
                      // Tab bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pagePadding, 0,
                          AppSpacing.pagePadding, 0),
                        child: const ReportsTabBar(),
                      ),
                      // Thin divider below tabs
                      Divider(height: 1,
                        color: cs.onBackground.withOpacity(0.08)),
                      // Period chips
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pagePadding, 8,
                          AppSpacing.pagePadding, 8),
                        child: const PeriodChips(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Active tab content ────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding, AppSpacing.lg,
                AppSpacing.pagePadding, AppSpacing.sm),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Switch content based on active tab — no Scaffold, no Navigator
                  Obx(() {
                    switch (controller.activeTab.value) {
                      case ReportsTab.overview:  return const OverviewTab();
                      case ReportsTab.income:    return const IncomeTab();
                      case ReportsTab.expenses:  return const ExpensesTab();
                      case ReportsTab.netWorth:  return const NetWorthTab();
                    }
                  }),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }
}
