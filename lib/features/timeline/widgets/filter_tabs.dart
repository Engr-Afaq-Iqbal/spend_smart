// lib/features/timeline/widgets/filter_tabs.dart
// ─────────────────────────────────────────────────────────────────────────────
// Three pill-style filter buttons in the coral header.
// Matches design: inactive = transparent outline, active = white fill.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controller/timeline_controller.dart';
import '../model/timeline_models.dart';

class FilterTabs extends GetView<TimelineController> {
  const FilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: TimelineFilter.values.map((filter) {
              final isActive = controller.activeFilter.value == filter;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: _FilterPill(
                  label: filter.labelKey.tr,
                  isActive: isActive,
                  onTap: () => controller.setFilter(filter),
                ),
              );
            }).toList(),
          ),
        ));
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.white54,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color:
                isActive ? Theme.of(context).colorScheme.primary : Colors.white,
          ),
        ),
      ),
    );
  }
}
