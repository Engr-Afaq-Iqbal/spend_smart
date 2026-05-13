// lib/features/transaction/view/add_expense_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// Add Expense screen — matches the design exactly:
//   • Coral header with SAR amount + currency chips
//   • Custom numpad
//   • AI category suggestion bar (appears after amount entered)
//   • Category chip row (Food | Transport | Shopping | Enter...)
//   • "Add note, merchant, date..." row
//   • "Scan receipt instead" CTA
//   • Expandable optional details
//   • Save Expense button
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../controller/transaction_controller.dart';
import '../model/transaction_models.dart';
import '../widgets/numpad_widget.dart';

class AddExpenseView extends StatelessWidget {
  const AddExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionController>();
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ── Coral header ──────────────────────────────────────────────
          Container(
            color: AppColors.categoryFood,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Title bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left_rounded,
                              color: Colors.white, size: 28),
                          onPressed: Get.back,
                        ),
                        Expanded(
                            child: Center(
                          child: Text('add_expense'.tr,
                              style: AppTextStyles.h3
                                  .copyWith(color: Colors.white, fontSize: 17)),
                        )),
                        TextButton(
                          onPressed: controller.saveExpense,
                          child: Text('save'.tr,
                              style: AppTextStyles.labelLarge.copyWith(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  // Amount + currency chips (no subtitleKey for expense)
                  AmountDisplay(
                    headerColor: Colors.transparent,
                    subtitleKey: '',
                  ),
                ],
              ),
            ),
          ),

          // ── Scrollable body ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Numpad
                  const NumpadGrid(),

                  // AI Suggestion bar
                  Obx(() {
                    final suggested = controller.aiSuggestedCategory.value;
                    if (suggested == null) return const SizedBox.shrink();
                    return _AISuggestionBar(
                      category: suggested,
                      onAccept: controller.acceptAiSuggestion,
                      onDismiss: controller.dismissAiSuggestion,
                    );
                  }),

                  // Category chip row
                  _CategoryChips(),

                  // Note / merchant / date row
                  _NoteRow(isDark: isDark),

                  // Optional details
                  Obx(() => controller.showDetails.value
                      ? _OptionalDetails(isDark: isDark)
                      : const SizedBox.shrink()),

                  // Scan receipt CTA
                  _ScanReceiptCTA(isDark: isDark),

                  const SizedBox(height: 100), // space for save button
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Save button (floats above bottom) ─────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: ElevatedButton(
            onPressed: controller.saveExpense,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.categoryFood,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: Text('save_expense'.tr,
                style: AppTextStyles.labelLarge
                    .copyWith(color: Colors.white, fontSize: 15)),
          ),
        ),
      ),
    );
  }
}

// ── AI Suggestion bar ──────────────────────────────────────────────────────────
class _AISuggestionBar extends StatelessWidget {
  final ExpenseCategory category;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;
  const _AISuggestionBar(
      {required this.category,
      required this.onAccept,
      required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(category.icon, color: category.color, size: 18),
          const SizedBox(width: 8),
          Text('${'suggests'.tr} ',
              style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
          Text(category.labelKey.tr,
              style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  color: cs.primary,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          GestureDetector(
            onTap: onAccept,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('accept'.tr,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDismiss,
            child: Text('dismiss'.tr,
                style: AppTextStyles.bodySmall
                    .copyWith(fontSize: 11, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

// ── Category chip row ──────────────────────────────────────────────────────────
class _CategoryChips extends GetView<TransactionController> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final visible = [
      ExpenseCategory.food,
      ExpenseCategory.transport,
      ExpenseCategory.shopping,
    ];
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...visible.map((cat) {
                  final isActive = controller.selectedCategory.value == cat;
                  return GestureDetector(
                    onTap: () => controller.selectedCategory.value = cat,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isActive ? cat.color : cat.color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cat.emoji, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(cat.labelKey.tr,
                              style: AppTextStyles.labelSmall.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isActive ? Colors.white : cat.color)),
                        ],
                      ),
                    ),
                  );
                }),
                // Enter chip
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: cs.onBackground.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('enter_chip'.tr,
                      style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 12,
                          color: cs.onBackground.withOpacity(0.50))),
                ),
              ],
            ),
          ),
        ));
  }
}

// ── Note / merchant / date row ─────────────────────────────────────────────────
class _NoteRow extends GetView<TransactionController> {
  final bool isDark;
  const _NoteRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => controller.showDetails.value = true,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 6,
                      offset: const Offset(0, 1))
                ],
        ),
        child: Row(
          children: [
            Icon(Icons.edit_note_rounded,
                color: cs.onBackground.withOpacity(0.35), size: 20),
            const SizedBox(width: 10),
            Expanded(
                child: Text('add_note_merchant'.tr,
                    style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 13,
                        color: cs.onBackground.withOpacity(0.40)))),
            Icon(Icons.chevron_right_rounded,
                color: cs.onBackground.withOpacity(0.25), size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Optional details section ───────────────────────────────────────────────────
class _OptionalDetails extends GetView<TransactionController> {
  final bool isDark;
  const _OptionalDetails({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow:
            isDark ? null : [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('optional_details'.tr,
                  style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: cs.onBackground.withOpacity(0.45))),
              GestureDetector(
                  onTap: () => controller.showDetails.value = false,
                  child: Icon(Icons.keyboard_arrow_up_rounded,
                      color: cs.onBackground.withOpacity(0.40), size: 20)),
            ],
          ),
          const SizedBox(height: 14),
          _FieldLabel('merchant'.tr),
          _InputField(
              hint: 'merchant_hint'.tr,
              onChanged: (v) => controller.merchantText.value = v),
          const SizedBox(height: 12),
          _FieldLabel('note'.tr),
          _InputField(
              hint: 'note_hint'.tr,
              onChanged: (v) => controller.noteText.value = v),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('date'.tr),
                    Text('🗓 ${'today'.tr} • 10 May',
                        style: AppTextStyles.bodySmall
                            .copyWith(fontSize: 13, color: cs.onBackground))
                    // Obx(() => ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('recurring'.tr),
                    Obx(() => Row(children: [
                          Switch(
                            value: controller.isRecurring.value,
                            onChanged: (v) => controller.isRecurring.value = v,
                            activeColor: AppColors.categoryFood,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 4),
                          Text(
                              controller.isRecurring.value
                                  ? 'monthly'.tr
                                  : 'off'.tr,
                              style: AppTextStyles.bodySmall
                                  .copyWith(fontSize: 12)),
                        ])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _FieldLabel('payment_method'.tr),
          const SizedBox(height: 6),
          // Payment method chips
          Row(
              children: PaymentMethod.values.map((pm) {
            final labels = {
              PaymentMethod.bankTransfer: 'bank_transfer'.tr,
              PaymentMethod.cash: 'cash'.tr,
              PaymentMethod.online: 'online'.tr,
            };
            return Obx(() {
              final isActive = controller.paymentMethod.value == pm;
              return GestureDetector(
                onTap: () => controller.paymentMethod.value = pm,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.categoryFood.withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isActive
                            ? AppColors.categoryFood
                            : cs.onBackground.withOpacity(0.15)),
                  ),
                  child: Text(labels[pm]!,
                      style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 12,
                          color: isActive
                              ? AppColors.categoryFood
                              : cs.onBackground.withOpacity(0.55))),
                ),
              );
            });
          }).toList()),
        ],
      ),
    );
  }
}

// ── Scan Receipt CTA ──────────────────────────────────────────────────────────
class _ScanReceiptCTA extends StatelessWidget {
  final bool isDark;
  const _ScanReceiptCTA({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.scanReceipt),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.categoryFood.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.categoryFood.withOpacity(0.20)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.categoryFood.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.receipt_long_rounded,
                  color: AppColors.categoryFood, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('scan_receipt_instead'.tr,
                      style: AppTextStyles.labelLarge.copyWith(
                          fontSize: 13,
                          color: cs.onBackground,
                          fontWeight: FontWeight.w600)),
                  Text('ai_fills_auto'.tr,
                      style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11.5,
                          color: cs.onBackground.withOpacity(0.45))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('ai_badge'.tr,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: cs.primary)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: Theme.of(context)
                  .colorScheme
                  .onBackground
                  .withOpacity(0.45))),
    );
  }
}

class _InputField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _InputField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return TextField(
      onChanged: onChanged,
      style: AppTextStyles.bodyMedium
          .copyWith(fontSize: 14, color: cs.onBackground),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodySmall
            .copyWith(fontSize: 13, color: cs.onBackground.withOpacity(0.30)),
        filled: true,
        fillColor: isDark ? AppColors.darkBackground : AppColors.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
