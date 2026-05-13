// lib/features/transaction/view/add_income_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/transaction_controller.dart';
import '../model/transaction_models.dart';
import '../widgets/numpad_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class AddIncomeView extends StatelessWidget {
  const AddIncomeView({super.key});

  static const _incomeGreen = Color(0xFF2ECC71);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionController>();
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // ── Green header ─────────────────────────────────────────────
          Container(
            color: _incomeGreen,
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
                        Expanded(child: Center(
                          child: Text('add_income'.tr,
                            style: AppTextStyles.h3.copyWith(
                              color: Colors.white, fontSize: 17)),
                        )),
                        TextButton(
                          onPressed: controller.saveIncome,
                          child: Text('save'.tr,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Colors.white, fontSize: 15,
                              fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  // Amount display
                  AmountDisplay(
                    headerColor: Colors.transparent,
                    subtitleKey: 'Tap amount to edit',
                  ),
                ],
              ),
            ),
          ),

          // ── Scrollable form body ──────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Income type label
                  Text('income_type'.tr,
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: cs.onBackground.withOpacity(0.45))),
                  const SizedBox(height: 10),

                  // Income type chip grid
                  _IncomeTypeGrid(isDark: isDark),
                  const SizedBox(height: 20),

                  // Details section label
                  Text('optional_details'.tr.replaceAll('OPTIONAL ', ''),
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: cs.onBackground.withOpacity(0.45))),
                  const SizedBox(height: 10),

                  _FormCard(isDark: isDark),

                  // Salary estimate row
                  const SizedBox(height: 16),
                  _SalaryEstimateRow(isDark: isDark, incomeGreen: _incomeGreen),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Save Income button ────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: ElevatedButton(
            onPressed: controller.saveIncome,
            style: ElevatedButton.styleFrom(
              backgroundColor: _incomeGreen,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: Text('save_income'.tr,
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white, fontSize: 15)),
          ),
        ),
      ),
    );
  }
}

// ── Income type chip grid ──────────────────────────────────────────────────────
class _IncomeTypeGrid extends GetView<TransactionController> {
  final bool isDark;
  const _IncomeTypeGrid({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final types = IncomeType.values;

    return Obx(() => Wrap(
      spacing: 8, runSpacing: 8,
      children: types.map((t) {
        final isActive = controller.selectedIncomeType.value == t;
        return GestureDetector(
          onTap: () => controller.selectedIncomeType.value = t,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF2ECC71)
                  : isDark ? AppColors.darkSurface : AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive
                    ? const Color(0xFF2ECC71)
                    : cs.onBackground.withOpacity(0.10)),
              boxShadow: isActive ? null : (isDark ? null : [
                BoxShadow(color: AppColors.shadow, blurRadius: 4)]),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(t.icon, size: 15,
                  color: isActive ? Colors.white : t.color),
                const SizedBox(width: 6),
                Text(t.labelKey.tr,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : cs.onBackground)),
                if (isActive) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check_rounded,
                    color: Colors.white, size: 14),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    ));
  }
}

// ── Details form card ──────────────────────────────────────────────────────────
class _FormCard extends GetView<TransactionController> {
  final bool isDark;
  const _FormCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final inputDeco = InputDecoration(
      filled: true,
      fillColor: isDark ? AppColors.darkBackground : AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: isDark ? null : [
          BoxShadow(color: AppColors.shadow, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FL('source_desc'.tr),
          TextField(
            onChanged: (v) => controller.sourceDescription.value = v,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 13, color: cs.onBackground),
            decoration: inputDeco.copyWith(
              hintText: 'source_desc_hint'.tr,
              hintStyle: AppTextStyles.bodySmall.copyWith(
                fontSize: 12, color: cs.onBackground.withOpacity(0.30))),
          ),
          const SizedBox(height: 12),

          _FL('date'.tr),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              const Text('🗓', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text('10 May 2026  ·  23 Dhul-Qi\'dah 1447',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12, color: cs.onBackground)),
            ]),
          ),
          const SizedBox(height: 12),

          _FL('account'.tr),
          DropdownButtonFormField<String>(
            value: 'Salary Account',
            items: ['Salary Account', 'Current Account', 'Savings Account']
                .map((a) => DropdownMenuItem(value: a,
                    child: Text(a, style: AppTextStyles.bodySmall)))
                .toList(),
            onChanged: (v) => controller.accountText.value = v ?? '',
            decoration: inputDeco,
            dropdownColor: isDark ? AppColors.darkSurface : AppColors.surfaceCard,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 13, color: cs.onBackground),
          ),
          const SizedBox(height: 12),

          _FL('payment_method'.tr),
          const SizedBox(height: 6),
          Obx(() => Row(
            children: [
              ...PaymentMethod.values.map((pm) {
                final labels = {
                  PaymentMethod.bankTransfer: 'bank_transfer'.tr,
                  PaymentMethod.cash: 'cash'.tr,
                  PaymentMethod.online: 'online'.tr,
                };
                final isActive = controller.paymentMethod.value == pm;
                return GestureDetector(
                  onTap: () => controller.paymentMethod.value = pm,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF2ECC71).withOpacity(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFF2ECC71)
                            : cs.onBackground.withOpacity(0.15)),
                    ),
                    child: Text(labels[pm]!,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 12,
                        color: isActive
                            ? const Color(0xFF2ECC71)
                            : cs.onBackground.withOpacity(0.55))),
                  ),
                );
              }),
            ],
          )),
        ],
      ),
    );
  }
}

// ── Salary estimate footer row ─────────────────────────────────────────────────
class _SalaryEstimateRow extends GetView<TransactionController> {
  final bool isDark;
  final Color incomeGreen;
  const _SalaryEstimateRow({required this.isDark, required this.incomeGreen});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: incomeGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: incomeGreen.withOpacity(0.20)),
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: incomeGreen.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.work_rounded, color: incomeGreen, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Salary · SAR ${controller.formattedAmount}',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontSize: 13, color: cs.onBackground)),
                Text('${'after_saving'.tr} SAR ${_calcAfter()}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 11, color: cs.onBackground.withOpacity(0.45))),
              ],
            )),
          ),
        ],
      ),
    );
  }

  String _calcAfter() {
    final base = controller.numericAmount;
    final after = base + 2560; // mock existing balance
    if (after >= 1000) {
      final n = after.toStringAsFixed(0);
      final buf = StringBuffer();
      for (var i = 0; i < n.length; i++) {
        if (i > 0 && (n.length - i) % 3 == 0) buf.write(',');
        buf.write(n[i]);
      }
      return buf.toString();
    }
    return after.toStringAsFixed(0);
  }
}

class _FL extends StatelessWidget {
  final String text;
  const _FL(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.45))),
    );
  }
}
