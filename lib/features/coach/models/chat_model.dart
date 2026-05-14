// lib/features/ai_coach/model/chat_model.dart
// ─────────────────────────────────────────────────────────────────────────────
// Chat message domain model + prompt suggestion catalogue.
// ─────────────────────────────────────────────────────────────────────────────

enum MessageRole { user, assistant, system }

enum MessageContentType {
  text,
  chart,      // future: inline chart response
  pdf,        // future: PDF generation trigger
  error,
}

class ChatMessage {
  final String id;
  final MessageRole role;
  final String content;
  final MessageContentType contentType;
  final DateTime timestamp;
  final bool isStreaming;
  final Map<String, dynamic>? metadata; // chart data, links, etc.

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    this.contentType = MessageContentType.text,
    required this.timestamp,
    this.isStreaming = false,
    this.metadata,
  });

  ChatMessage copyWith({
    String? content,
    bool? isStreaming,
    MessageContentType? contentType,
  }) =>
      ChatMessage(
        id: id,
        role: role,
        content: content ?? this.content,
        contentType: contentType ?? this.contentType,
        timestamp: timestamp,
        isStreaming: isStreaming ?? this.isStreaming,
        metadata: metadata,
      );
}

class SuggestedPrompt {
  final String labelKey;
  final String promptKey;
  final String emoji;

  const SuggestedPrompt({
    required this.labelKey,
    required this.promptKey,
    required this.emoji,
  });
}

class PromptCatalogue {
  static const List<SuggestedPrompt> prompts = [
    SuggestedPrompt(
      labelKey: 'coach_prompt_how_am_i',
      promptKey: 'coach_prompt_how_am_i_full',
      emoji: '📊',
    ),
    SuggestedPrompt(
      labelKey: 'coach_prompt_save_more',
      promptKey: 'coach_prompt_save_more_full',
      emoji: '💰',
    ),
    SuggestedPrompt(
      labelKey: 'coach_prompt_forecast',
      promptKey: 'coach_prompt_forecast_full',
      emoji: '🔮',
    ),
    SuggestedPrompt(
      labelKey: 'coach_prompt_report',
      promptKey: 'coach_prompt_report_full',
      emoji: '📄',
    ),
    SuggestedPrompt(
      labelKey: 'coach_prompt_habits',
      promptKey: 'coach_prompt_habits_full',
      emoji: '🔍',
    ),
    SuggestedPrompt(
      labelKey: 'coach_prompt_budget',
      promptKey: 'coach_prompt_budget_full',
      emoji: '🎯',
    ),
  ];
}
