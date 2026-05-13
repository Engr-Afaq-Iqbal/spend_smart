// lib/features/timeline/view/timeline_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// Transaction Timeline — the Expenses tab content.
//
// IMPORTANT: No Scaffold returned here.
// This widget lives inside the PageView in MainNavigation (ONE Scaffold).
// Returning a Scaffold here would cause nested-Scaffold overflow.
//
// Layout matches design exactly:
//   ┌──────────────────────────────────────┐
//   │  HEADER (coral gradient)             │
//   │    "Transaction Timeline"            │
//   │    [Daily] [Weekly] [Monthly]        │
//   ├──────────────────────────────────────┤
//   │  CALENDAR CARD                       │
//   │    ← April 2026 → Total: SAR 8,450   │
//   │    S  M  T  W  T  F  S               │
//   │    [date grid with dots]             │
//   ├──────────────────────────────────────┤
//   │  WEEKLY TOTALS CARD                  │
//   │    bar chart + W1…W5 labels          │
//   ├──────────────────────────────────────┤
//   │  "April 29 – Transactions" heading   │
//   │  [Transaction tiles]                 │
//   │  Day Total: -SAR 283                 │
//   └──────────────────────────────────────┘
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/timeline_controller.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/weekly_chart.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/summary_bar.dart';
import '../widgets/empty_state.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({super.key});

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView>
    with AutomaticKeepAliveClientMixin {
  // Keep scroll position + state alive across tab switches
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Derive gradient from theme's primary (accent-reactive)
    final accent = cs.primary;
    final gradientTop    = Color.lerp(accent, Colors.white, 0.12) ?? accent;
    final gradientBottom = Color.lerp(accent, Colors.black, 0.08) ?? accent;

    // Ensure controller is available (registered in bindings)
    final controller = Get.find<TimelineController>();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // ── Sticky coral header ─────────────────────────────────────────
        SliverAppBar(
          pinned: false,
          floating: false,
          snap: false,
          expandedHeight: 120,
          backgroundColor: accent,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [gradientTop, gradientBottom],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pagePadding, AppSpacing.lg,
                    AppSpacing.pagePadding, 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'timeline_title'.tr,
                        style: AppTextStyles.h2.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Filter pills
                      const FilterTabs(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Body content ────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding, AppSpacing.lg,
            AppSpacing.pagePadding, AppSpacing.xxxl,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── Calendar card ────────────────────────────────────────
              AppCard(
                padding: EdgeInsets.zero,
                child: const CalendarWidget(),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Weekly totals chart ───────────────────────────────────
              const WeeklyChart(),

              const SizedBox(height: AppSpacing.xxl),

              // ── Transaction list section ──────────────────────────────
              const SummaryBar(),

              const SizedBox(height: AppSpacing.md),

              // Reactive transaction list — rebuilds only on filter change
              Obx(() {
                final txList = controller.filteredTransactions;

                if (txList.isEmpty) {
                  return const TimelineEmptyState();
                }

                // ListView.builder inside SliverList — use Column here
                // because we're already inside a SliverList delegate.
                // shrinkWrap + NeverScrollableScrollPhysics is correct here
                // since the outer CustomScrollView handles scrolling.
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: txList.length,
                  itemBuilder: (_, i) => TransactionTile(
                    transaction: txList[i],
                  ),
                );
              }),
            ]),
          ),
        ),
      ],
    );
  }
}
