// lib/features/ai_coach/view/ai_coach_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// Premium AI Coach chat interface.
// No Scaffold — lives inside MainNavigation's single Scaffold.
// Features:
//   • AI chat with streaming text
//   • Typing animation (3-dot bounce)
//   • Suggested prompts chips
//   • Chat history with smooth scrolling
//   • Credits badge in header
//   • Dark/Light theme support
//   • RTL / localization ready
//   • Error + empty states
//   • Voice-ready architecture
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spend_smart/controllers/font_size_controller.dart';

import '../../../core/constants/app_colors.dart';
import '../controller/ai_coach_controller.dart';
import '../controller/ai_credits_controller.dart';
import '../models/chat_model.dart';

class AiCoachView extends StatefulWidget {
  const AiCoachView({super.key});
  @override
  State<AiCoachView> createState() => _AiCoachViewState();
}

class _AiCoachViewState extends State<AiCoachView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final AiCoachController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(AiCoachController());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final fs = context.fs;

    return Column(
      children: [
        // ── Header ────────────────────────────────────────────────────────
        _CoachHeader(isDark: isDark, cs: cs, fs: fs),

        // ── Messages ──────────────────────────────────────────────────────
        Expanded(
          child: Obx(() {
            if (_ctrl.messages.isEmpty) {
              return _EmptyState(isDark: isDark, fs: fs);
            }
            return ListView.builder(
              controller: _ctrl.scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: _ctrl.messages.length +
                  (_ctrl.isTyping.value ? 1 : 0) +
                  (_ctrl.showSuggestions.value && _ctrl.messages.length == 1
                      ? 1
                      : 0),
              itemBuilder: (context, index) {
                // Typing indicator
                if (_ctrl.isTyping.value && index == _ctrl.messages.length) {
                  return const _TypingBubble();
                }
                // Suggestion chips after welcome message
                if (_ctrl.showSuggestions.value &&
                    _ctrl.messages.length == 1 &&
                    index == 1) {
                  return _SuggestionChips(
                    onTap: _ctrl.sendSuggestedPrompt,
                    isDark: isDark,
                    fs: fs,
                  );
                }
                final msg = _ctrl.messages[index];
                return _MessageBubble(
                  message: msg,
                  isDark: isDark,
                  cs: cs,
                  fs: fs,
                );
              },
            );
          }),
        ),

        // ── Error banner ──────────────────────────────────────────────────
        Obx(() {
          if (!_ctrl.hasError.value) return const SizedBox.shrink();
          return _ErrorBanner(
            message: _ctrl.errorMessage.value,
            onRetry: _ctrl.retryLastMessage,
            isDark: isDark,
          );
        }),

        // ── Input bar ────────────────────────────────────────────────────
        _InputBar(ctrl: _ctrl, isDark: isDark, cs: cs, fs: fs),
      ],
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────────
class _CoachHeader extends StatelessWidget {
  final bool isDark;
  final ColorScheme cs;
  final FontSizeController fs;

  const _CoachHeader(
      {required this.isDark, required this.cs, required this.fs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B35),
            const Color(0xFFFF8C5A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text('✨', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),

              // Title + status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Coach',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: fs.scaled(17),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4ADE80),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'SpendSmart LAI · Online',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: fs.scaled(11),
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Credits badge
              Obx(() {
                final credits = AiCreditsController.to.balance.value;
                return GestureDetector(
                  onTap: () => Get.toNamed('/play-earn'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white30, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('⚡', style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 4),
                        Text(
                          '$credits',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: fs.scaled(12),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(width: 8),

              // Clear chat
              GestureDetector(
                onTap: () {
                  Get.find<AiCoachController>().clearChat();
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Message Bubble ─────────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;
  final ColorScheme cs;
  final FontSizeController fs;

  const _MessageBubble(
      {required this.message,
      required this.isDark,
      required this.cs,
      required this.fs});

  bool get isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            _AiAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color(0xFFFF6B35)
                        : (isDark ? AppColors.darkSurface : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black26
                            : Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fs.scaled(13.5),
                      height: 1.55,
                      color: isUser
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fs.scaled(10),
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ── AI Avatar ──────────────────────────────────────────────────────────────────
class _AiAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8C5A)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text('✨', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

// ── Typing Bubble ──────────────────────────────────────────────────────────────
class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    _anims = _controllers
        .map((c) => Tween<double>(begin: 0, end: -8).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();

    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _AiAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _anims[i],
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, _anims[i].value),
                    child: Container(
                      width: 7,
                      height: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Suggestion Chips ───────────────────────────────────────────────────────────
class _SuggestionChips extends StatelessWidget {
  final void Function(SuggestedPrompt) onTap;
  final bool isDark;
  final FontSizeController fs;

  const _SuggestionChips(
      {required this.onTap, required this.isDark, required this.fs});

  @override
  Widget build(BuildContext context) {
    final prompts = PromptCatalogue.prompts;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Suggested questions:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fs.scaled(11),
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: prompts.map((p) {
              final label = _resolveLabel(p.labelKey);
              return GestureDetector(
                onTap: () => onTap(p),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFF6B35).withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(p.emoji, style: TextStyle(fontSize: fs.scaled(13))),
                      const SizedBox(width: 5),
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: fs.scaled(12),
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _resolveLabel(String key) {
    const map = {
      'coach_prompt_how_am_i': 'How am I doing?',
      'coach_prompt_save_more': 'How can I save more?',
      'coach_prompt_forecast': 'Forecast next month',
      'coach_prompt_report': 'Generate report',
      'coach_prompt_habits': 'Spending habits',
      'coach_prompt_budget': 'Review my budget',
    };
    return map[key] ?? key;
  }
}

// ── Input Bar ──────────────────────────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  final AiCoachController ctrl;
  final bool isDark;
  final ColorScheme cs;
  final FontSizeController fs;

  const _InputBar(
      {required this.ctrl,
      required this.isDark,
      required this.cs,
      required this.fs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Voice button (ready for future integration)
          GestureDetector(
            onTap: () => Get.snackbar(
              '🎙️ Coming Soon',
              'Voice input will be available in the next update',
              snackPosition: SnackPosition.TOP,
            ),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.mic_rounded,
                color: Color(0xFFFF6B35),
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Text field
          Expanded(
            child: TextField(
              controller: ctrl.textController,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fs.scaled(13.5),
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fs.scaled(13),
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              onSubmitted: (v) => ctrl.sendMessage(v),
              textInputAction: TextInputAction.send,
              maxLines: null,
            ),
          ),

          const SizedBox(width: 10),

          // Send button
          Obx(() {
            final typing = ctrl.isTyping.value;
            return GestureDetector(
              onTap: typing
                  ? null
                  : () => ctrl.sendMessage(ctrl.textController.text),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: typing
                        ? [Colors.grey.shade400, Colors.grey.shade300]
                        : [
                            const Color(0xFFFF6B35),
                            const Color(0xFFFF8C5A),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: typing
                      ? null
                      : [
                          BoxShadow(
                            color: const Color(0xFFFF6B35).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: fs.scaled(18),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Error Banner ───────────────────────────────────────────────────────────────
class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isDark;

  const _ErrorBanner(
      {required this.message, required this.onRetry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.error,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isDark;
  final FontSizeController fs;
  const _EmptyState({required this.isDark, required this.fs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('✨', style: TextStyle(fontSize: fs.scaled(56))),
          const SizedBox(height: 16),
          Text(
            'Starting your session...',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fs.scaled(15),
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
