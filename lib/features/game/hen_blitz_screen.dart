// lib/game/hen_blitz_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
// Top-level Flutter widget hosting the Flame game.
// Manages the pre-game modal, swipe detection, and overlay routing.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:spend_smart/features/game/components/hen_blitz_game.dart';
import 'package:spend_smart/features/game/models/game_models.dart';
import 'package:spend_smart/features/game/overlays/game_over_overlay.dart';
import 'package:spend_smart/features/game/overlays/hud_overlay.dart';
import 'package:spend_smart/features/game/overlays/pro_paywall_overlay.dart';

class HenBlitzScreen extends StatefulWidget {
  final UserFinancialProfile profile;
  final int personalBest;
  final VoidCallback? onOpenSubscription;
  final void Function(GameResult)? onGameComplete;

  const HenBlitzScreen({
    super.key,
    required this.profile,
    this.personalBest = 0,
    this.onOpenSubscription,
    this.onGameComplete,
  });

  @override
  State<HenBlitzScreen> createState() => _HenBlitzScreenState();
}

class _HenBlitzScreenState extends State<HenBlitzScreen> {
  late HenBlitzGame _game;
  Key _gameKey = UniqueKey();
  GameResult? _lastResult;

  bool _showPreGame = true;

  // Swipe detection state
  Offset? _swipeStart;
  DateTime _lastSwipe = DateTime.fromMillisecondsSinceEpoch(0);
  static const _swipeThreshold  = 300.0; // px/s minimum velocity
  static const _swipeDebounceMs = 80;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _game = HenBlitzGame(
      profile: widget.profile,
      onGameComplete: (result) {
        widget.onGameComplete?.call(result);
        if (mounted) setState(() => _lastResult = result);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Swipe detector wrapping the Flame GameWidget ───────────────
          GestureDetector(
            onPanStart:  _onPanStart,
            onPanEnd:    _onPanEnd,
            child: GameWidget(
              key: _gameKey,
              game: _game,
              overlayBuilderMap: {
                'hud': (_, __) => HudOverlay(game: _game),
                'gameOver': (context, __) => _lastResult == null
                    ? const SizedBox.shrink()
                    : GameOverOverlay(
                        result: _lastResult!,
                        petName: widget.profile.petName,
                        personalBest: widget.personalBest,
                        onPlayAgain: _restart,
                        onBackToApp: () => Navigator.of(context).pop(),
                      ),
                'proPaywall': (context, __) => ProPaywallOverlay(
                  game: _game,
                  onUnlockPro: () {
                    widget.onOpenSubscription?.call();
                  },
                  onWatchAd: () {
                    // Resume after watching ad (mock)
                    _game.overlays.remove('proPaywall');
                    _game.resumeEngine();
                    // Grant extra 60 seconds
                  },
                  onDismiss: () {
                    _game.overlays.remove('proPaywall');
                    _game.triggerGameOver();
                    Navigator.of(context).pop();
                  },
                ),
              },
            ),
          ),

          // ── Pre-game modal ─────────────────────────────────────────────
          if (_showPreGame)
            _PreGameModal(
              profile: widget.profile,
              onPlay: () {
                setState(() => _showPreGame = false);
              },
            ),
        ],
      ),
    );
  }

  // ── Swipe handling ────────────────────────────────────────────────────────
  void _onPanStart(DragStartDetails d) {
    _swipeStart = d.globalPosition;
  }

  void _onPanEnd(DragEndDetails d) {
    if (_swipeStart == null) return;
    if (_showPreGame) return;

    final now = DateTime.now();
    if (now.difference(_lastSwipe).inMilliseconds < _swipeDebounceMs) return;
    _lastSwipe = now;

    final velocity = d.velocity.pixelsPerSecond;
    final speed    = velocity.distance;
    if (speed < _swipeThreshold) return;

    final dx = velocity.dx.abs();
    final dy = velocity.dy.abs();

    if (dy > dx) {
      // Vertical swipe
      if (velocity.dy < 0) {
        _game.hen.jump();
        HapticFeedback.lightImpact();
      } else {
        _game.hen.slide();
        HapticFeedback.lightImpact();
      }
    } else {
      // Horizontal swipe
      if (velocity.dx < 0) {
        _game.hen.swipeLeft();
        HapticFeedback.selectionClick();
      } else {
        _game.hen.swipeRight();
        HapticFeedback.selectionClick();
      }
    }
    _swipeStart = null;
  }

  void _restart() {
    setState(() {
      _lastResult = null;
      _showPreGame = false;
      _initGame();
      _gameKey = UniqueKey();
    });
  }
}

// ── Pre-game modal ─────────────────────────────────────────────────────────────
class _PreGameModal extends StatelessWidget {
  final UserFinancialProfile profile;
  final VoidCallback onPlay;
  const _PreGameModal({required this.profile, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    final stateColor = _stateColor(profile.state);

    return Material(
      color: Colors.black.withOpacity(0.70),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // State badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: stateColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: stateColor.withOpacity(0.40)),
                ),
                child: Text(
                  'Today you are: ${profile.stateLabel}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: stateColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'You spent ${(profile.ratio * 100).toStringAsFixed(0)}% of income this month',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Improve your finances to make ${profile.petName} faster!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Color(0xFF1A1D2E),
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 20),

              // Speed preview
              _SpeedPreview(profile: profile),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: onPlay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Text('PLAY',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _stateColor(HenState s) {
    return switch (s) {
      HenState.saver     => const Color(0xFF34C759),
      HenState.balanced  => const Color(0xFF20B894),
      HenState.spender   => const Color(0xFFFF9500),
      HenState.overspend => const Color(0xFFFF6B35),
      HenState.broke     => const Color(0xFFFF3B30),
    };
  }
}

class _SpeedPreview extends StatelessWidget {
  final UserFinancialProfile profile;
  const _SpeedPreview({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Speed',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
                color: Color(0xFF6B7280))),
            Text('${profile.henSpeed.toStringAsFixed(0)} px/s',
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12,
                fontWeight: FontWeight.w700, color: Color(0xFF1A1D2E))),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: profile.henSpeed / 300.0,
            minHeight: 8,
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation<Color>(
              profile.state == HenState.saver || profile.state == HenState.balanced
                  ? const Color(0xFF34C759)
                  : const Color(0xFFFF6B35),
            ),
          ),
        ),
      ],
    );
  }
}
