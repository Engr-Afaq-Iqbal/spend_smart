// lib/features/expenses/view/expenses_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// The Expenses tab now delegates entirely to TimelineView.
// No Scaffold — lives inside the outer Scaffold from MainNavigation.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../timeline/view/timeline_view.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    // TimelineView is itself a StatefulWidget with AutomaticKeepAliveClientMixin
    // so state is preserved across tab switches without wrapping again.
    return const TimelineView();
  }
}
