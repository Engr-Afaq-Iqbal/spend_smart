// lib/features/game/components/egg_component.dart
// ─────────────────────────────────────────────────────────────────────────────
// VERTICAL ROAD — eggs spawn at the TOP of the screen and fall DOWN.
// They stay in their assigned lane (fixed X), only Y changes.
// Size is CONSTANT (no perspective scaling) — they all appear the same size.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:spend_smart/features/game/models/game_models.dart';
import 'package:spend_smart/features/game/systems/game_systems.dart';
import 'package:spend_smart/features/game/components/hen_blitz_game.dart';
import 'package:spend_smart/features/game/components/hen_component.dart';
import 'package:flutter/material.dart';

class EggComponent extends PositionComponent
    with CollisionCallbacks, HasGameRef<HenBlitzGame> {
  EggType type;
  Lane lane;
  final LaneSystem laneSystem;

  // Visual size (constant — no perspective on vertical road)
  static const Map<EggType, double> eggRadius = {
    EggType.cracked:  16.0,
    EggType.silver:   18.0,
    EggType.gold:     20.0,
    EggType.diamond:  22.0,
    EggType.rainbow:  24.0,
  };

  // Colour when no sprite available
  static const Map<EggType, Color> _eggColor = {
    EggType.cracked:  Color(0xFFD4B89A),
    EggType.silver:   Color(0xFFB0BEC5),
    EggType.gold:     Color(0xFFFFD700),
    EggType.diamond:  Color(0xFF7BC8F6),
    EggType.rainbow:  Color(0xFFFF69B4),
  };

  // Wobble for visual appeal
  double _wobblePhase = 0;
  final math.Random _rng = math.Random();

  EggComponent({
    required this.type,
    required this.lane,
    required this.laneSystem,
  });

  @override
  Future<void> onLoad() async {
    _init();
    // Collision circle
    add(CircleHitbox(
      radius: (eggRadius[type] ?? 16) + 2,
      collisionType: CollisionType.passive,
    ));
  }

  void reset({required EggType type, required Lane lane}) {
    this.type = type;
    this.lane = lane;
    _init();
  }

  void _init() {
    final r = eggRadius[type] ?? 16.0;
    size    = Vector2(r * 2, r * 2.4); // eggs are oval
    // Spawn above the visible screen top (so they slide in smoothly)
    final cx = laneSystem.xForLane(lane);
    position = Vector2(cx - size.x / 2, -size.y - _rng.nextDouble() * 40);
    _wobblePhase = _rng.nextDouble() * math.pi * 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _wobblePhase += dt * 3.0;

    // Fall downward
    position.y += gameRef.diffSystem.fallSpeed * dt;

    // Gentle horizontal wobble (±4px) for visual interest
    final cx = laneSystem.xForLane(lane);
    position.x = cx - size.x / 2 + math.sin(_wobblePhase) * 4.0;

    // Gone past bottom → remove
    if (position.y > gameRef.size.y + size.y) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final r  = (eggRadius[type] ?? 16.0);
    final cl = _eggColor[type] ?? const Color(0xFFD4B89A);

    // Oval body
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = cl,
    );

    // Highlight gloss
    canvas.drawOval(
      Rect.fromLTWH(size.x * 0.25, size.y * 0.12,
                    size.x * 0.35, size.y * 0.22),
      Paint()..color = Colors.white.withOpacity(0.45),
    );

    // Rainbow egg — multi-color stripes
    if (type == EggType.rainbow) {
      final colors = [
        const Color(0xFFFF0000), const Color(0xFFFF9500),
        const Color(0xFFFFD700), const Color(0xFF34C759),
        const Color(0xFF5B8DEF), const Color(0xFF9C27B0),
      ];
      for (int i = 0; i < colors.length; i++) {
        canvas.drawRect(
          Rect.fromLTWH(0, size.y * i / colors.length,
                        size.x, size.y / colors.length),
          Paint()
            ..color = colors[i].withOpacity(0.40)
            ..blendMode = BlendMode.srcATop,
        );
      }
    }

    // Cracked egg — draw cracks
    if (type == EggType.cracked) {
      final crackPaint = Paint()
        ..color  = const Color(0xFF8B6A50)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(size.x * 0.50, size.y * 0.20),
        Offset(size.x * 0.42, size.y * 0.45),
        crackPaint,
      );
      canvas.drawLine(
        Offset(size.x * 0.42, size.y * 0.45),
        Offset(size.x * 0.55, size.y * 0.60),
        crackPaint,
      );
    }

    // Diamond facets
    if (type == EggType.diamond) {
      final facetPaint = Paint()
        ..color  = Colors.white.withOpacity(0.30)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(size.x * 0.50, size.y * 0.10),
        Offset(size.x * 0.15, size.y * 0.55),
        facetPaint,
      );
      canvas.drawLine(
        Offset(size.x * 0.50, size.y * 0.10),
        Offset(size.x * 0.85, size.y * 0.55),
        facetPaint,
      );
    }
  }

  @override
  void onCollisionStart(Set<Vector2> pts, PositionComponent other) {
    if (other is HenComponent) {
      gameRef.onEggCollected(type, position.y);
      removeFromParent();
    }
  }
}
