// lib/features/reports/widgets/export_action_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/reports_controller.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class ExportActionBar extends GetView<ReportsController> {
  const ExportActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() => Row(
          children: [
            Expanded(child: _ExportButton(
              label: 'reports_export_pdf'.tr,
              icon: Icons.picture_as_pdf_rounded,
              isLoading: controller.isPdfExporting.value,
              onTap: controller.exportPdf,
              filled: false,
              isDark: isDark,
              accent: cs.primary,
            )),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _ExportButton(
              label: 'reports_share_card'.tr,
              icon: Icons.ios_share_rounded,
              isLoading: false,
              onTap: controller.shareCard,
              filled: false,
              isDark: isDark,
              accent: cs.primary,
            )),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _ExportButton(
              label: 'reports_export_csv'.tr,
              icon: Icons.table_chart_rounded,
              isLoading: controller.isCsvExporting.value,
              onTap: controller.exportCsv,
              filled: true,
              isDark: isDark,
              accent: cs.primary,
            )),
          ],
        ));
  }
}

class _ExportButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback onTap;
  final bool filled;
  final bool isDark;
  final Color accent;

  const _ExportButton({
    required this.label, required this.icon, required this.isLoading,
    required this.onTap, required this.filled, required this.isDark,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? Colors.white12 : const Color(0xFFE8EAED);
    final bgIdle      = isDark ? const Color(0xFF2A2D3A) : Colors.white;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: filled ? accent : (isLoading ? borderColor : bgIdle),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: filled ? null : Border.all(color: borderColor, width: 1.5),
          boxShadow: filled ? [
            BoxShadow(color: accent.withOpacity(0.28), blurRadius: 10, offset: const Offset(0, 4))
          ] : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading
                ? SizedBox(width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2,
                        color: filled ? Colors.white : accent))
                : Icon(icon, size: 18,
                    color: filled ? Colors.white : accent),
            const SizedBox(height: 4),
            Text(label,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 10.5,
                  color: filled ? Colors.white
                      : (isDark ? Colors.white70 : Colors.black87),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
