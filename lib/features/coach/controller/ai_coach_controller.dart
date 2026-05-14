// lib/features/ai_coach/controller/ai_coach_controller.dart
// ─────────────────────────────────────────────────────────────────────────────
// Manages the AI Coach chat session.
// Architecture is provider-agnostic — swap _generateResponse() for OpenAI,
// Claude, Gemini, etc. without touching the view layer.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controller/home_controller.dart';
import '../models/ai_credits_model.dart';
import '../models/chat_model.dart';
import 'ai_credits_controller.dart';

class AiCoachController extends GetxController {
  static AiCoachController get to => Get.find<AiCoachController>();

  // ── Chat state ────────────────────────────────────────────────────────────
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // ── UI state ──────────────────────────────────────────────────────────────
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final RxBool showSuggestions = true.obs;
  final RxInt sessionMessageCount = 0.obs;

  AiCreditsController get _credits => AiCreditsController.to;
  HomeController? get _home =>
      Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;

  @override
  void onInit() {
    super.onInit();
    _addWelcomeMessage();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // ── Public API ────────────────────────────────────────────────────────────

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || isTyping.value) return;

    // Check credits for non-basic messages
    final feature = _classifyFeature(trimmed);
    final hasCredits = await _credits.spendCredits(feature: feature);
    if (!hasCredits) return;

    textController.clear();
    showSuggestions.value = false;
    hasError.value = false;

    // Add user message
    final userMsg = ChatMessage(
      id: _id(),
      role: MessageRole.user,
      content: trimmed,
      timestamp: DateTime.now(),
    );
    messages.add(userMsg);
    sessionMessageCount.value++;
    _scrollToBottom();

    // Start AI response
    isTyping.value = true;
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final response = await _generateResponse(trimmed);
      isTyping.value = false;

      // Stream the response character by character
      final streamId = _id();
      final streamMsg = ChatMessage(
        id: streamId,
        role: MessageRole.assistant,
        content: '',
        timestamp: DateTime.now(),
        isStreaming: true,
      );
      messages.add(streamMsg);

      await _streamText(streamId, response);
    } catch (e) {
      isTyping.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to get response. Please try again.';
    }
  }

  void sendSuggestedPrompt(SuggestedPrompt prompt) {
    // Map prompt keys to actual text (in production use .tr)
    final text = _resolvePrompt(prompt.promptKey);
    sendMessage(text);
  }

  void clearChat() {
    messages.clear();
    sessionMessageCount.value = 0;
    showSuggestions.value = true;
    _addWelcomeMessage();
  }

  void retryLastMessage() {
    if (messages.isEmpty) return;
    final last = messages.lastWhere(
      (m) => m.role == MessageRole.user,
      orElse: () => messages.last,
    );
    if (last.role == MessageRole.user) {
      sendMessage(last.content);
    }
  }

  // ── Private ───────────────────────────────────────────────────────────────

  void _addWelcomeMessage() {
    final home = _home;
    final name = home?.userName.value ?? 'there';
    final spent = home?.spent.value.toStringAsFixed(0) ?? '0';
    final income = home?.income.value.toStringAsFixed(0) ?? '0';

    messages.add(ChatMessage(
      id: _id(),
      role: MessageRole.assistant,
      content:
          "Hi $name! 👋 I'm your AI financial coach.\n\nThis month you've spent SAR $spent out of SAR $income income. I'm here to help you with:\n\n• 💰 Spending analysis\n• 📊 Budget planning\n• 📄 Reports & summaries\n• 🔮 Financial forecasts\n\nHow can I help you today?",
      timestamp: DateTime.now(),
    ));
  }

  Future<String> _generateResponse(String userInput) async {
    // Simulate network delay for AI call
    await Future.delayed(const Duration(milliseconds: 1200));

    final lower = userInput.toLowerCase();
    final home = _home;
    final spent = home?.spent.value.toStringAsFixed(0) ?? '3,450';
    final income = home?.income.value.toStringAsFixed(0) ?? '8,000';
    final health = home?.healthScore.value.toStringAsFixed(0) ?? '72';

    // Financial context-aware responses
    if (lower.contains('how am i') ||
        lower.contains('financial') && lower.contains('doing')) {
      return "📊 **Your Financial Health: $health/100**\n\nYou're doing well overall! Here's your snapshot:\n\n• **Income:** SAR $income this month\n• **Spent:** SAR $spent (${((double.tryParse(spent) ?? 0) / (double.tryParse(income) ?? 1) * 100).toStringAsFixed(0)}% of income)\n• **Health Score:** $health/100 — Very Good 🟢\n\n**Top insight:** Food spending is 15% over budget. Reducing takeout 3× per week could save you SAR 320 this month.";
    }

    if (lower.contains('save') || lower.contains('saving')) {
      return "💰 **Savings Opportunities for You:**\n\n1. **Cancel unused subscriptions** → SAR 135/month\n2. **Set a weekly shopping cap** → Save up to SAR 715\n3. **Meal prep 2× per week** → SAR 280 saved\n4. **Switch utility plans** → SAR 90/month\n\n**Total potential savings: SAR 1,220/month** 🎯\n\nWant me to create a personalized savings plan?";
    }

    if (lower.contains('forecast') ||
        lower.contains('next month') ||
        lower.contains('predict')) {
      return "🔮 **Next Month Forecast:**\n\n• **Predicted spending:** SAR 9,200\n• **vs. budget:** +SAR 750 over\n• **Key risk:** Food & Entertainment trending high\n\n**Forecast breakdown:**\n- Food & Dining: SAR 2,100 (+15%)\n- Transport: SAR 800 (stable)\n- Shopping: SAR 1,800 (+8%)\n- Bills: SAR 1,200 (fixed)\n\n⚠️ At this rate, you'll exceed your budget by SAR 750. Shall I suggest adjustments?";
    }

    if (lower.contains('report') || lower.contains('summary')) {
      return "📄 **Generating your financial summary...**\n\nHere's your month-to-date summary:\n\n**Income:** SAR $income\n**Expenses:** SAR $spent\n**Net savings:** SAR ${((double.tryParse(income) ?? 0) - (double.tryParse(spent) ?? 0)).toStringAsFixed(0)}\n\n**Top spending categories:**\n1. 🍔 Food & Dining — SAR 1,850\n2. 🚗 Transport — SAR 780\n3. 🛍️ Shopping — SAR 650\n\nWould you like me to generate a full PDF report? (Costs 30 AI credits)";
    }

    if (lower.contains('habit') ||
        lower.contains('pattern') ||
        lower.contains('spending')) {
      return "🔍 **Your Spending Patterns:**\n\n**Weekday vs Weekend:**\n• Weekdays: SAR 180/day avg\n• Weekends: SAR 420/day avg (+133%)\n\n**Peak spending times:**\n• Lunch: 12pm-2pm (30% of daily spend)\n• Evening: 6pm-9pm (40% of daily spend)\n\n**Habit insights:**\n• You shop online 4× more on Thursdays\n• Coffee expenses increased 22% this month\n• 3 subscriptions haven't been used in 30+ days\n\nShall I help you set smart spending limits?";
    }

    if (lower.contains('budget')) {
      return "🎯 **Budget Analysis:**\n\nYour current budget utilization:\n\n| Category | Budget | Spent | Status |\n|----------|--------|-------|--------|\n| Food | 1,600 | 1,850 | ⚠️ Over |\n| Transport | 900 | 780 | ✅ Good |\n| Shopping | 800 | 650 | ✅ Good |\n| Bills | 1,200 | 1,200 | ✅ On track |\n\n💡 **Tip:** Reallocate SAR 200 from Shopping budget to Food to reduce stress on your food category.";
    }

    if (lower.contains('subscription') || lower.contains('plan')) {
      return "💎 **Subscription Plans:**\n\n**Free Plan (Current)**\n• 100 AI credits/month\n• Basic chat\n• Monthly summary\n\n**Pro Plan — SAR 29/month**\n• Unlimited AI credits\n• PDF reports\n• Advanced analytics\n• Priority AI responses\n• Chart generation\n\n**Family Plan — SAR 49/month**\n• Everything in Pro\n• Up to 5 family members\n• Shared budget tracking\n\nWant to upgrade to unlock all features?";
    }

    if (lower.contains('pdf') || lower.contains('export')) {
      return "📄 **PDF Report Generation**\n\nI can generate the following reports:\n\n• **Monthly Report** — 20 credits\n• **Yearly Report** — 50 credits\n• **Custom Range** — 35 credits\n\nYou currently have ${AiCreditsController.to.balance.value} credits.\n\nYour report will include:\n✓ Income & expense breakdown\n✓ Category analysis with charts\n✓ Savings opportunities\n✓ Month-over-month trends\n✓ Personalized recommendations\n\nReady to generate your monthly PDF?";
    }

    // Default thoughtful response
    return "That's a great question! Based on your financial data, I can see some interesting patterns. Your spending discipline has improved over the last 30 days, and you're on track with most budget categories.\n\nCould you tell me more about what specific aspect you'd like to focus on? I can help with:\n\n• Detailed expense analysis\n• Budget optimization\n• Savings strategies\n• Financial forecasts\n• Report generation";
  }

  Future<void> _streamText(String msgId, String fullText) async {
    final idx = messages.indexWhere((m) => m.id == msgId);
    if (idx == -1) return;

    // Build a list of Unicode-safe characters using runes, so emoji and
    // supplementary code points are never split into lone surrogate halves.
    final chars = fullText.runes
        .map((r) => String.fromCharCodes([r]))
        .toList(growable: false);

    String current = '';
    for (int i = 0; i < chars.length; i++) {
      current += chars[i];
      messages[idx] = messages[idx].copyWith(
        content: current,
        isStreaming: i < chars.length - 1,
      );

      // Vary speed for natural feel
      final delay = chars[i] == ' ' ? 18 : 12;
      await Future.delayed(Duration(milliseconds: delay));
      _scrollToBottom();
    }

    // Mark streaming complete
    messages[idx] = messages[idx].copyWith(isStreaming: false);
  }

  AiFeature _classifyFeature(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('pdf') || lower.contains('export')) {
      return AiFeature.pdfExport;
    }
    if (lower.contains('report') || lower.contains('yearly')) {
      return AiFeature.monthlyReport;
    }
    if (lower.contains('chart') || lower.contains('visual')) {
      return AiFeature.chartAnalysis;
    }
    if (lower.contains('forecast') || lower.contains('insight')) {
      return AiFeature.advancedInsight;
    }
    return AiFeature.basicChat;
  }

  String _resolvePrompt(String key) {
    const map = {
      'coach_prompt_how_am_i_full': 'How am I doing financially this month?',
      'coach_prompt_save_more_full': 'How can I save more money?',
      'coach_prompt_forecast_full': 'Forecast my spending next month',
      'coach_prompt_report_full': 'Generate my monthly financial report',
      'coach_prompt_habits_full': 'Analyze my spending habits and patterns',
      'coach_prompt_budget_full': 'Review my budget and suggest improvements',
    };
    return map[key] ?? key;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _id() => DateTime.now().microsecondsSinceEpoch.toString();
}
