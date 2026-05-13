// lib/features/home/view/home_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// ROOT CAUSE FIX: This widget NO LONGER returns a Scaffold.
//
// WHY: MainNavigation wraps all tabs in ONE Scaffold with a PageView body.
// If each tab also returns a Scaffold, Flutter creates nested Scaffolds.
// The inner Scaffold's body receives an UNBOUNDED height constraint from
// PageView, causing NestedScrollView / CustomScrollView to overflow by
// 10,000+ pixels.
//
// FIX: Each tab returns a plain widget (here: RefreshIndicator+CustomScrollView)
// that fits correctly inside the outer Scaffold's bounded body slot.
//
// State preservation: AutomaticKeepAliveClientMixin keeps the scroll
// position and loaded data alive when the user swipes to another tab.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../widgets/summary_header_card.dart';
import '../widgets/health_budget_panel.dart';
import '../widgets/top_categories_section.dart';
import '../widgets/ai_insight_banner.dart';
import '../widgets/recent_transactions_section.dart';
import '../widgets/savings_goal_section.dart';
import '../widgets/upcoming_bills_section.dart';
import '../../../core/constants/app_spacing.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  // Keep alive = scroll position + loaded data survive tab switches
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    final controller = Get.find<HomeController>();
    final primary    = Theme.of(context).colorScheme.primary;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: primary));
      }
      return RefreshIndicator(
        onRefresh: controller.refresh,
        color: primary,
        // CustomScrollView inside the outer Scaffold body — bounded correctly
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // Coral header — full width, no padding
            const SliverToBoxAdapter(child: SummaryHeaderCard()),

            // Padded content below header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding, AppSpacing.xl,
                AppSpacing.pagePadding, AppSpacing.xxxl,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const HealthBudgetPanel(),
                  const SizedBox(height: AppSpacing.xxl),
                  const TopCategoriesSection(),
                  const SizedBox(height: AppSpacing.xxl),
                  const AIInsightBanner(),
                  const SizedBox(height: AppSpacing.xxl),
                  const RecentTransactionsSection(),
                  const SizedBox(height: AppSpacing.xxl),
                  const SavingsGoalSection(),
                  const SizedBox(height: AppSpacing.xxl),
                  const UpcomingBillsSection(),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }
}
