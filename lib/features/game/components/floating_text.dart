// lib/game/components/floating_text.dart
// ─────────────────────────────────────────────────────────────────────────────
// Brief floating "+N" text that rises from the collection point then fades.
// Rendered directly on the Canvas — no widget overhead.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:spend_smart/features/game/components/hen_blitz_game.dart';

class FloatingText extends PositionComponent with HasGameRef<HenBlitzGame> {
  final String text;
  final Color  color;

  double _age = 0.0;
  static const double _lifetime = 0.9; // seconds before removal

  FloatingText({
    required this.text,
    required Vector2 startPosition,
    required this.color,
  }) {
    position = startPosition.clone();
  }

  @override
  void render(Canvas canvas) {
    final t      = (_age / _lifetime).clamp(0.0, 1.0);
    final alpha  = (1.0 - t).clamp(0.0, 1.0);
    final yOff   = -_age * 60.0; // rise 60 px/s

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color.withOpacity(alpha),
          fontSize: 18,
          fontWeight: FontWeight.w800,
          shadows: const [Shadow(blurRadius: 4, color: Colors.black54)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    tp.paint(canvas, Offset(-tp.width / 2, yOff));
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    if (_age >= _lifetime) removeFromParent();
  }
}
