// lib/features/settings/widgets/font_size_picker.dart
// ─────────────────────────────────────────────────────────────────────────────
// Font size selector bottom sheet — called from Settings when user taps
// the "Font Size" tile.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../controllers/font_size_controller.dart';

class FontSizePicker {
  static void show(BuildContext context) {
    Get.bottomSheet(
      _FontSizePickerSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _FontSizePickerSheet extends StatelessWidget {
  final ctrl = FontSizeController.to;

  _FontSizePickerSheet();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fs = context.fs;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Font Size',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fs.scaled(17),
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Preview text
          Obx(() => Text(
                'This is how text will look in the app.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fs.scaled(14),
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              )),
          const SizedBox(height: 28),

          // Options
          ...AppFontSize.values.map((size) {
            return Obx(() {
              final selected = ctrl.fontSize.value == size;
              return GestureDetector(
                onTap: () => ctrl.setFontSize(size),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFFF6B35).withOpacity(0.1)
                        : (isDark
                            ? AppColors.darkBackground
                            : AppColors.background),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFFFF6B35)
                          : (isDark ? Colors.white12 : Colors.transparent),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Preview
                      Text(
                        'Aa',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: _previewSize(size),
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? const Color(0xFFFF6B35)
                              : (isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Label
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _label(size),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: fs.scaled(14),
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? const Color(0xFFFF6B35)
                                    : (isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.textPrimary),
                              ),
                            ),
                            Text(
                              _desc(size),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: fs.scaled(11),
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Check
                      if (selected)
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFFFF6B35), size: 22),
                    ],
                  ),
                ),
              );
            });
          }),

          const SizedBox(height: 16),
          GestureDetector(
            onTap: Get.back,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C5A)]),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  'Apply',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fs.scaled(15),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 8),
        ],
      ),
    );
  }

  double _previewSize(AppFontSize size) {
    switch (size) {
      case AppFontSize.small:
        return 18;
      case AppFontSize.medium:
        return 24;
      case AppFontSize.large:
        return 32;
    }
  }

  String _label(AppFontSize size) {
    switch (size) {
      case AppFontSize.small:
        return 'Small';
      case AppFontSize.medium:
        return 'Medium';
      case AppFontSize.large:
        return 'Large';
    }
  }

  String _desc(AppFontSize size) {
    switch (size) {
      case AppFontSize.small:
        return 'Compact — fits more content';
      case AppFontSize.medium:
        return 'Default — recommended';
      case AppFontSize.large:
        return 'Accessible — easier to read';
    }
  }
}
