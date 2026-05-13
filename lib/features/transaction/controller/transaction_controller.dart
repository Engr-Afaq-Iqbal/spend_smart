// lib/features/transaction/controller/transaction_controller.dart
// ─────────────────────────────────────────────────────────────────────────────
// GetX controller for all transaction creation flows.
// Scoped to the route — created on open, disposed on pop.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/transaction_models.dart';

// ── Voice recording states ─────────────────────────────────────────────────
enum VoiceState { idle, listening, processing, extracted, error }

// ── Receipt scan states ────────────────────────────────────────────────────
enum ScanState { idle, scanning, processing, extracted, error }

class TransactionController extends GetxController {
  // ── Shared state ──────────────────────────────────────────────────────────
  final RxString  displayAmount  = '0'.obs;
  final Rx<TxCurrency> currency  = TxCurrency.sar.obs;
  final RxBool    showDetails    = false.obs;

  // ── Expense specific ──────────────────────────────────────────────────────
  final Rx<ExpenseCategory> selectedCategory = ExpenseCategory.food.obs;
  final RxString  merchantText   = ''.obs;
  final RxString  noteText       = ''.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxBool    isRecurring    = false.obs;
  final Rx<PaymentMethod> paymentMethod = PaymentMethod.bankTransfer.obs;
  final RxBool    aiSuggestionShown = false.obs;
  final Rx<ExpenseCategory?> aiSuggestedCategory = Rx<ExpenseCategory?>(null);

  // ── Income specific ───────────────────────────────────────────────────────
  final Rx<IncomeType> selectedIncomeType = IncomeType.salary.obs;
  final RxString sourceDescription = ''.obs;
  final RxString accountText = ''.obs;
  final RxBool   isRecurringIncome = false.obs;
  final RxString incomeNoteText = ''.obs;

  // ── Voice state ────────────────────────────────────────────────────────────
  final Rx<VoiceState> voiceState = VoiceState.idle.obs;
  final RxString transcribedText = ''.obs;
  final Rx<AiExtractionResult?> voiceExtraction = Rx<AiExtractionResult?>(null);
  final RxInt  recordingSeconds  = 0.obs;

  // ── Receipt scan state ────────────────────────────────────────────────────
  final Rx<ScanState> scanState = ScanState.idle.obs;
  final Rx<AiExtractionResult?> scanExtraction = Rx<AiExtractionResult?>(null);

  // ── Subscription / Premium ────────────────────────────────────────────────
  // Set to false to show premium paywall for AI features
  final RxBool isPremium = false.obs;

  // ── Timer for recording animation ─────────────────────────────────────────
  Worker? _recordingWorker;

  // ─────────────────────────────────────────────────────────────────────────
  // NUMPAD LOGIC
  // ─────────────────────────────────────────────────────────────────────────

  void onNumpadTap(String key) {
    final current = displayAmount.value;
    if (key == '⌫') {
      if (current.length > 1) {
        displayAmount.value = current.substring(0, current.length - 1);
      } else {
        displayAmount.value = '0';
      }
      return;
    }
    if (key == '.' && current.contains('.')) return;
    if (current == '0' && key != '.') {
      displayAmount.value = key;
    } else {
      // Max 8 digits before decimal
      final parts = current.split('.');
      if (parts[0].length >= 8) return;
      displayAmount.value = current + key;
    }
    // Trigger AI category suggestion when amount > 0
    if (double.tryParse(displayAmount.value) != null &&
        double.parse(displayAmount.value) > 0 &&
        !aiSuggestionShown.value) {
      Future.delayed(const Duration(seconds: 1), _showAiSuggestion);
    }
  }

  void _showAiSuggestion() {
    aiSuggestedCategory.value = ExpenseCategory.food;
    aiSuggestionShown.value = true;
  }

  void acceptAiSuggestion() {
    if (aiSuggestedCategory.value != null) {
      selectedCategory.value = aiSuggestedCategory.value!;
    }
    aiSuggestedCategory.value = null;
  }

  void dismissAiSuggestion() {
    aiSuggestedCategory.value = null;
  }

  String get formattedAmount {
    final val = displayAmount.value;
    if (val == '0') return '0';
    return val;
  }

  double get numericAmount => double.tryParse(displayAmount.value) ?? 0;

  // ─────────────────────────────────────────────────────────────────────────
  // VOICE FLOW (Mock AI)
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> startVoiceRecording() async {
    voiceState.value = VoiceState.listening;
    transcribedText.value = '';
    recordingSeconds.value = 0;

    // Simulate live transcription
    await Future.delayed(const Duration(milliseconds: 800));
    transcribedText.value = '"Spent 45 riyals on lunch at McDon';
    await Future.delayed(const Duration(milliseconds: 600));
    transcribedText.value = '"Spent 45 riyals on lunch at McDonald\'s"';
    await Future.delayed(const Duration(seconds: 1));

    // Simulate processing
    voiceState.value = VoiceState.processing;
    await Future.delayed(const Duration(milliseconds: 800));

    // Show extracted result
    voiceState.value = VoiceState.extracted;
    voiceExtraction.value = MockAiData.voiceResult;
  }

  void stopVoiceRecording() {
    if (voiceState.value == VoiceState.listening) {
      voiceState.value = VoiceState.processing;
      Future.delayed(const Duration(milliseconds: 800), () {
        voiceState.value = VoiceState.extracted;
        voiceExtraction.value = MockAiData.voiceResult;
      });
    }
  }

  void applyVoiceExtraction() {
    final result = voiceExtraction.value;
    if (result == null) return;
    if (result.amount != null) {
      displayAmount.value = result.amount!.toStringAsFixed(
          result.amount! % 1 == 0 ? 0 : 2);
    }
    if (result.category != null) selectedCategory.value = result.category!;
    if (result.merchant != null) merchantText.value = result.merchant!;
    Get.back(); // close voice screen
  }

  void resetVoice() {
    voiceState.value = VoiceState.idle;
    transcribedText.value = '';
    voiceExtraction.value = null;
    recordingSeconds.value = 0;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // RECEIPT SCAN FLOW (Mock AI)
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> startReceiptScan() async {
    scanState.value = ScanState.scanning;
    // Simulate scanning delay
    await Future.delayed(const Duration(seconds: 2));
    scanState.value = ScanState.processing;
    await Future.delayed(const Duration(milliseconds: 800));
    scanState.value = ScanState.extracted;
    scanExtraction.value = MockAiData.receiptResult;
  }

  void applyScanExtraction() {
    final result = scanExtraction.value;
    if (result == null) return;
    if (result.amount != null) {
      displayAmount.value = result.amount!.toStringAsFixed(
          result.amount! % 1 == 0 ? 0 : 2);
    }
    if (result.category != null) selectedCategory.value = result.category!;
    if (result.merchant != null) merchantText.value = result.merchant!;
    Get.back(); // close scan screen
  }

  void resetScan() {
    scanState.value = ScanState.idle;
    scanExtraction.value = null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SAVE
  // ─────────────────────────────────────────────────────────────────────────

  void saveExpense() {
    // TODO: persist to storage/API
    Get.back();
    Get.snackbar(
      'Expense Saved',
      'SAR ${formattedAmount} recorded successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFFF6B35),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
    );
  }

  void saveIncome() {
    Get.back();
    Get.snackbar(
      'Income Saved',
      'SAR ${formattedAmount} recorded successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF34C759),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
    );
  }

  @override
  void onClose() {
    _recordingWorker?.dispose();
    super.onClose();
  }
}

