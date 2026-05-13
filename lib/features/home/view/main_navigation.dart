// lib/features/home/view/main_navigation.dart
// ─────────────────────────────────────────────────────────────────────────────
// Root navigation shell — ONE Scaffold, ONE PageView.
//
// OVERFLOW FIX (root cause + correct solution):
//
//   ROOT CAUSE:
//     Each tab (HomeView, ReportsView, etc.) previously returned its own
//     Scaffold. Flutter allows nested Scaffolds, but the inner Scaffold's
//     body slot receives an UNBOUNDED height from PageView. Any widget that
//     tries to measure its own height (CustomScrollView, NestedScrollView,
//     ListView with shrinkWrap: false) then reports an infinite height, which
//     Flutter renders as "BOTTOM OVERFLOWED BY 10000+ PIXELS".
//
//   CORRECT FIX (not a workaround):
//     Tab views are plain stateful widgets (no Scaffold). This Scaffold is
//     the ONE layout root. PageView body → bounded height → no overflow.
//     AutomaticKeepAliveClientMixin in each tab preserves scroll + state.
//
//   SWIPE NAVIGATION:
//     PageController + onPageChanged keeps BottomNavigationBar in sync.
//     Swipe left/right switches tabs just like WhatsApp.
//
//   TAB INDEX MAPPING (5 nav items, 4 pages — centre item is FAB spacer):
//     nav 0 → page 0 (Home)
//     nav 1 → page 1 (Expenses)
//     nav 2 → (FAB — ignored)
//     nav 3 → page 2 (Reports)
//     nav 4 → page 3 (Coach)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../coach/view/coach_view.dart';
import '../../expenses/view/expenses_view.dart';
import '../../reports/view/reports_view.dart';
import '../../transaction/widgets/add_transaction_sheet.dart';
import 'home_view.dart';

// ── Controller ────────────────────────────────────────────────────────────────
class BottomNavController extends GetxController {
  final RxInt navIndex = 0.obs;
  final PageController pageController = PageController();

  // nav index ↔ page index translation
  static int navToPage(int nav) => nav <= 1 ? nav : nav - 1; // 3→2, 4→3
  static int pageToNav(int page) => page <= 1 ? page : page + 1; // 2→3, 3→4

  void onNavTap(int tapped) {
    if (tapped == 2) return; // FAB spacer — ignore
    if (tapped == navIndex.value) return; // already on this tab
    navIndex.value = tapped;
    pageController.animateToPage(
      navToPage(tapped),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOutCubic,
    );
  }

  void onPageChanged(int page) {
    navIndex.value = pageToNav(page);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

// ── Shell ─────────────────────────────────────────────────────────────────────
class MainNavigation extends StatelessWidget {
  MainNavigation({super.key}) {
    Get.put(BottomNavController());
  }

  // Pages are StatefulWidgets with AutomaticKeepAliveClientMixin —
  // their state survives tab switches without a Scaffold wrapper.
  static const List<Widget> _pages = [
    HomeView(),
    ExpensesView(),
    ReportsView(),
    CoachView(),
  ];

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.find<BottomNavController>();
    final themeCtrl = Get.find<ThemeController>();

    // Obx rebuilds only when accent or navIndex changes
    return Obx(() {
      final accent = themeCtrl.accentColor.value;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final navBg = isDark ? AppColors.darkSurface : AppColors.white;
      final inactiveCl =
          isDark ? AppColors.darkTextSecondary : AppColors.navInactive;

      return Scaffold(
        // ── ONE body for the whole app ─────────────────────────────────────
        // PageView children are plain widgets, NOT Scaffolds.
        // They receive a properly bounded height from this Scaffold's body.
        body: PageView(
          controller: navCtrl.pageController,
          onPageChanged: navCtrl.onPageChanged,
          // physics: ClampingScrollPhysics prevents conflicting with inner
          // scroll views while still allowing swipe navigation
          physics: const ClampingScrollPhysics(),
          children: _pages,
        ),

        // ── Bottom navigation bar ──────────────────────────────────────────
        // Flutter's built-in BottomNavigationBar handles its own SafeArea
        // inset and intrinsic height — no custom sizing, no overflow risk.
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navCtrl.navIndex.value,
          onTap: navCtrl.onNavTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: navBg,
          selectedItemColor: accent,
          unselectedItemColor: inactiveCl,
          showUnselectedLabels: true,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedLabelStyle: const TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: 'nav_home'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.receipt_long_outlined),
              activeIcon: const Icon(Icons.receipt_long_rounded),
              label: 'nav_expenses'.tr,
            ),
            // Centre spacer for the FAB — non-interactive
            const BottomNavigationBarItem(
              icon: SizedBox(width: 48, height: 24),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_outlined),
              activeIcon: const Icon(Icons.bar_chart_rounded),
              label: 'nav_reports'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.smart_toy_outlined),
              activeIcon: const Icon(Icons.smart_toy_rounded),
              label: 'nav_coach'.tr,
            ),
          ],
        ),

        // ── Centred FAB ────────────────────────────────────────────────────
        floatingActionButton: _AccentFAB(accent: accent),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }
}

// ── Accent-reactive FAB ───────────────────────────────────────────────────────
class _AccentFAB extends StatelessWidget {
  final Color accent;
  const _AccentFAB({required this.accent});

  @override
  Widget build(BuildContext context) {
    final soft = Color.lerp(accent, Colors.white, 0.25) ?? accent;
    return SizedBox(
      width: 54,
      height: 54,
      child: FloatingActionButton(
        onPressed: () => AddTransactionSheet.show(context),
        elevation: 4,
        // Transparent background — gradient painted by the inner Container
        backgroundColor: Colors.transparent,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [soft, accent],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.40),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
