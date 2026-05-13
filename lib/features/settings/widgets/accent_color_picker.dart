// lib/features/settings/widgets/accent_color_picker.dart
// ─────────────────────────────────────────────────────────────────────────────
// Full-featured accent color picker shown as a modal bottom sheet.
//
// Sections:
//   1. Preset palette  — 12 curated beautiful colors with name labels
//   2. Custom picker   — flutter_colorpicker HSV wheel + hex input
//
// Usage:
//   AccentColorPicker.show(context);
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

// ── Preset color entry ────────────────────────────────────────────────────────
class _PresetColor {
  final String name;
  final String nameAr;
  final Color color;
  const _PresetColor(this.name, this.nameAr, this.color);
}

// ── Curated palette of 12 attractive accent colors ────────────────────────────
const List<_PresetColor> _presets = [
  _PresetColor('Coral Orange',   'برتقالي مرجاني',    Color(0xFFFF6B35)),
  _PresetColor('Deep Purple',    'بنفسجي داكن',        Color(0xFF6C3FE8)),
  _PresetColor('Ocean Blue',     'أزرق المحيط',        Color(0xFF2196F3)),
  _PresetColor('Emerald Green',  'أخضر زمردي',         Color(0xFF10B981)),
  _PresetColor('Hot Pink',       'وردي ساخن',           Color(0xFFEC4899)),
  _PresetColor('Golden Amber',   'عنبري ذهبي',          Color(0xFFF59E0B)),
  _PresetColor('Ruby Red',       'أحمر ياقوتي',         Color(0xFFEF4444)),
  _PresetColor('Teal',           'أزرق مخضر',           Color(0xFF14B8A6)),
  _PresetColor('Indigo',         'نيلي',                Color(0xFF4F46E5)),
  _PresetColor('Rose Gold',      'ذهبي وردي',           Color(0xFFE91E8C)),
  _PresetColor('Forest Green',   'أخضر الغابة',         Color(0xFF16A34A)),
  _PresetColor('Sunset Purple',  'بنفسجي الغروب',       Color(0xFF9333EA)),
];

class AccentColorPicker {
  // ── Public entry point ─────────────────────────────────────────────────────
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AccentPickerSheet(),
    );
  }
}

class _AccentPickerSheet extends StatefulWidget {
  const _AccentPickerSheet();

  @override
  State<_AccentPickerSheet> createState() => _AccentPickerSheetState();
}

class _AccentPickerSheetState extends State<_AccentPickerSheet>
    with SingleTickerProviderStateMixin {
  final ThemeController _themeCtrl = Get.find<ThemeController>();

  late Color _tempColor;           // staging color before Apply
  bool _showCustomPicker = false;  // toggle custom HSV wheel
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tempColor = _themeCtrl.accentColor.value;
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    _themeCtrl.setAccentColor(_tempColor);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final subColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.lg,
        AppSpacing.pagePadding,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ─────────────────────────────────────────────────────
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: subColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Title + current swatch ──────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  'accent_color_title'.tr,
                  style: AppTextStyles.h3.copyWith(color: textColor, fontSize: 18),
                ),
              ),
              // Live preview swatch
              Obx(() => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _themeCtrl.accentColor.value,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _themeCtrl.accentColor.value.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Tab bar ─────────────────────────────────────────────────────
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2D3A) : AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: TabBar(
              controller: _tabCtrl,
              indicator: BoxDecoration(
                color: _tempColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: subColor,
              labelStyle: AppTextStyles.labelSmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(fontSize: 12),
              tabs: [
                Tab(text: 'accent_color_presets'.tr),
                Tab(text: 'accent_color_custom'.tr),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Tab content ──────────────────────────────────────────────────
          SizedBox(
            height: 280,
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                // ── Tab 1: Preset grid ──────────────────────────────────
                _PresetGrid(
                  selectedColor: _tempColor,
                  onSelect: (c) => setState(() => _tempColor = c),
                ),

                // ── Tab 2: Custom HSV wheel ─────────────────────────────
                SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: _tempColor,
                    onColorChanged: (c) => setState(() => _tempColor = c),
                    pickerAreaHeightPercent: 0.55,
                    enableAlpha: false,
                    hexInputBar: true,
                    hexInputController: TextEditingController(
                        text: '#${_tempColor.value.toRadixString(16).substring(2).toUpperCase()}'),
                    labelTypes: const [],
                    displayThumbColor: true,
                    pickerAreaBorderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Stage preview bar ────────────────────────────────────────────
          _StagePreview(color: _tempColor, isDark: isDark, textColor: subColor),
          const SizedBox(height: AppSpacing.lg),

          // ── Action buttons ───────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: Get.back,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: subColor.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'accent_color_cancel'.tr,
                    style: AppTextStyles.labelLarge.copyWith(color: subColor),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _apply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _tempColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'accent_color_apply'.tr,
                    style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Preset color grid ─────────────────────────────────────────────────────────
class _PresetGrid extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onSelect;

  const _PresetGrid({required this.selectedColor, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isAr = Get.find<ThemeController>().isArabic;

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.78,
      ),
      itemCount: _presets.length,
      itemBuilder: (_, i) {
        final preset = _presets[i];
        final isSelected = selectedColor.value == preset.color.value;
        return GestureDetector(
          onTap: () => onSelect(preset.color),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: preset.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: preset.color.withOpacity(0.40),
                      blurRadius: isSelected ? 12 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                    : null,
              ),
              const SizedBox(height: 5),
              Text(
                isAr ? preset.nameAr : preset.name,
                style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Stage preview strip ────────────────────────────────────────────────────────
class _StagePreview extends StatelessWidget {
  final Color color;
  final bool isDark;
  final Color textColor;

  const _StagePreview({
    required this.color,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2D3A) : AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          // Button preview
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'accent_color_current'.tr,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Switch preview
          Switch(
            value: true,
            onChanged: (_) {},
            activeColor: Colors.white,
            activeTrackColor: color,
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Progress bar preview
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.65,
                minHeight: 6,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
