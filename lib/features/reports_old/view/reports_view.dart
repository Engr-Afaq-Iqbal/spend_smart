// lib/features/reports/view/reports_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// ROOT CAUSE FIX: Scaffold removed. NestedScrollView removed.
//
// WHY NestedScrollView was causing the overflow:
//   NestedScrollView requires a BOUNDED height from its parent.
//   Inside PageView → Scaffold.body → PageView children get INFINITE height.
//   NestedScrollView inside infinite height = layout exception / 10k+ overflow.
//
// REPLACEMENT: SliverAppBar inside a single CustomScrollView.
// This correctly participates in the outer Scaffold's bounded constraints.
// The SliverAppBar pins the title + period filter at the top while scrolling.
//
// State preservation: AutomaticKeepAliveClientMixin keeps loaded data alive.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/reports_controller.dart';
import '../widgets/period_filter.dart';
import '../widgets/summary_cards.dart';
import '../widgets/category_donut_chart.dart';
import '../widgets/daily_spending_chart.dart';
import '../widgets/month_over_month_chart.dart';
import '../widgets/top_merchants_section.dart';
import '../widgets/export_action_bar.dart';
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
        // Single CustomScrollView with a SliverAppBar — works correctly
        // inside a bounded parent (outer Scaffold body via PageView).
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // ── Sticky header: title + period filter ─────────────────────
            SliverAppBar(
              pinned: true,
              floating: false,
              forceElevated: true,
              backgroundColor: bgColor,
              elevation: 0,
              scrolledUnderElevation: 1,
              // toolbarHeight = row with title text
              toolbarHeight: 56,
              // expandedHeight includes the period filter strip below title
              expandedHeight: 56 + 54.0,
              automaticallyImplyLeading: false, // tab — no back arrow
              title: Text(
                'reports_title'.tr,
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18,
                  color: cs.onBackground,
                ),
              ),
              titleSpacing: AppSpacing.pagePadding,
              // Period filter pinned below the title
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(54),
                child: Container(
                  color: bgColor,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pagePadding, 0,
                    AppSpacing.pagePadding, 10,
                  ),
                  child: const PeriodFilter(),
                ),
              ),
            ),

            // ── Scrollable content ────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding, AppSpacing.lg,
                AppSpacing.pagePadding, AppSpacing.xxxl,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SummaryCards(),
                  const SizedBox(height: AppSpacing.xxl),
                  const CategoryDonutChart(),
                  const SizedBox(height: AppSpacing.xxl),
                  const DailySpendingChart(),
                  const SizedBox(height: AppSpacing.xxl),
                  const MonthOverMonthChart(),
                  const SizedBox(height: AppSpacing.xxl),
                  const TopMerchantsSection(),
                  const SizedBox(height: AppSpacing.xxl),
                  const ExportActionBar(),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }
}
