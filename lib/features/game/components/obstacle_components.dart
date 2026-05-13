// lib/features/game/components/obstacle_components.dart
// ─────────────────────────────────────────────────────────────────────────────
// VERTICAL ROAD — all 6 obstacles fall from TOP to BOTTOM in fixed lanes.
// Each has a unique movement personality on top of the basic vertical fall.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:spend_smart/features/game/models/game_models.dart';
import 'package:spend_smart/features/game/systems/game_systems.dart';
import 'package:spend_smart/features/game/components/hen_blitz_game.dart';
import 'package:spend_smart/features/game/components/hen_component.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BASE
// ─────────────────────────────────────────────────────────────────────────────
abstract class ObstacleComponent extends PositionComponent
    with CollisionCallbacks, HasGameRef<HenBlitzGame> {
  final ObstacleType obstacleType;
  final LaneSystem   laneSystem;
  double _lane_x; // current absolute X centre

  ObstacleComponent({
    required this.obstacleType,
    required this.laneSystem,
    required double startX,
  }) : _lane_x = startX;

  // Subclasses set their preferred size
  Vector2 get obstacleSize;

  @override
  Future<void> onLoad() async {
    size     = obstacleSize;
    position = Vector2(_lane_x - size.x / 2, -size.y);
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  // Standard fall — subclasses call this and may add extra logic
  void fallUpdate(double dt) {
    position.y += gameRef.diffSystem.fallSpeed * dt;
    position.x  = _lane_x - size.x / 2;
    if (position.y > gameRef.size.y + size.y) removeFromParent();
  }

  @override
  void onCollisionStart(Set<Vector2> pts, PositionComponent other) {
    if (other is HenComponent) {
      gameRef.onHenHit(obstacleType);
      removeFromParent();
    }
  }

  // Draws a coloured rounded-rect with an emoji label when no sprite loaded
  void renderBlock(Canvas canvas, Color color, String emoji) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.x, size.y),
          const Radius.circular(10)),
      Paint()..color = color,
    );
    // Emoji
    final tp = TextPainter(
      text: TextSpan(text: emoji, style: const TextStyle(fontSize: 28)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(size.x/2 - tp.width/2, size.y/2 - tp.height/2));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. CREDIT CARD WALL — full lane width, must switch lane to dodge
// ─────────────────────────────────────────────────────────────────────────────
class CreditCardWall extends ObstacleComponent {
  CreditCardWall({required super.laneSystem, required Lane lane})
      : super(obstacleType: ObstacleType.creditCard,
              startX: laneSystem.xForLane(lane));

  @override
  Vector2 get obstacleSize => Vector2(laneSystem.laneWidth * 0.85, 55);

  @override
  void update(double dt) { fallUpdate(dt); }

  @override
  void render(Canvas canvas) {
    renderBlock(canvas, const Color(0xFFE53935), '💳');
    // Draw card lines for realism
    final lp = Paint()..color = Colors.white.withOpacity(0.4)..strokeWidth = 1.5;
    canvas.drawLine(Offset(8, size.y*0.55), Offset(size.x-8, size.y*0.55), lp);
    canvas.drawRect(Rect.fromLTWH(8, size.y*0.28, 18, 10),
        Paint()..color = const Color(0xFFFFD700));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. SHOPPING AVALANCHE — falls fast from sky, wobbles side-to-side
// ─────────────────────────────────────────────────────────────────────────────
class ShoppingAvalanche extends ObstacleComponent {
  double _wobble = 0;
  final double _baseX;

  ShoppingAvalanche({required super.laneSystem, required Lane lane})
      : _baseX = laneSystem.xForLane(lane),
        super(obstacleType: ObstacleType.shoppingBoxes,
              startX: laneSystem.xForLane(lane));

  @override
  Vector2 get obstacleSize => Vector2(laneSystem.laneWidth * 0.80, 50);

  @override
  void update(double dt) {
    _wobble += dt * 4.0;
    _lane_x = _baseX + math.sin(_wobble) * 18;
    fallUpdate(dt);
  }

  @override
  void render(Canvas canvas) {
    renderBlock(canvas, const Color(0xFFBF8F5B), '📦');
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. BILL TORNADO — sweeps across ALL 3 lanes from left to right repeatedly
// ─────────────────────────────────────────────────────────────────────────────
class BillTornado extends ObstacleComponent {
  double _sweepPhase = 0;
  bool _sweepRight  = true;

  BillTornado({required super.laneSystem})
      : super(obstacleType: ObstacleType.billTornado,
              startX: laneSystem.leftX);

  @override
  Vector2 get obstacleSize => Vector2(laneSystem.laneWidth * 0.75, 70);

  @override
  void update(double dt) {
    // Slow descent — the danger is the horizontal sweep
    position.y += gameRef.diffSystem.fallSpeed * 0.60 * dt;
    if (position.y > gameRef.size.y + size.y) { removeFromParent(); return; }

    _sweepPhase += dt / 2.5 * (_sweepRight ? 1 : -1);
    if (_sweepPhase >= 1.0) { _sweepPhase = 1.0; _sweepRight = false; }
    if (_sweepPhase <= 0.0) { _sweepPhase = 0.0; _sweepRight = true; }

    _lane_x  = _lerp(laneSystem.leftX, laneSystem.rightX, _sweepPhase);
    position.x = _lane_x - size.x / 2;
  }

  double _lerp(double a, double b, double t) => a + (b-a)*t;

  @override
  void render(Canvas canvas) => renderBlock(canvas, const Color(0xFF6A1B9A), '🌪️');
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. SUBSCRIPTION SNAKE — slides across horizontally at mid-screen height
// ─────────────────────────────────────────────────────────────────────────────
class SubscriptionSnake extends ObstacleComponent {
  double _sinePhase = 0;

  SubscriptionSnake({required super.laneSystem})
      : super(obstacleType: ObstacleType.subscriptionSnake,
              startX: laneSystem.rightX + 80);

  @override
  Vector2 get obstacleSize =>
      Vector2(laneSystem.roadWidth * 0.65, 38);

  @override
  Future<void> onLoad() async {
    size     = obstacleSize;
    // Start at the right edge of the road, mid-screen height
    position = Vector2(laneSystem.roadRight, gameRef.size.y * 0.45);
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    _sinePhase += dt * 2.0;
    // Slide LEFT across screen
    position.x -= gameRef.diffSystem.fallSpeed * 0.55 * dt;
    // Sine Y wave
    position.y = gameRef.size.y * 0.45 + math.sin(_sinePhase) * 20;
    // Also slowly fall
    // Remove when past left edge
    if (position.x + size.x < laneSystem.roadLeft - 20) removeFromParent();
  }

  @override
  void render(Canvas canvas) => renderBlock(canvas, const Color(0xFF2E7D32), '🐍');
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. TAX BOULDER — enters from the right, rolls to centre lane, stops, falls
// ─────────────────────────────────────────────────────────────────────────────
class TaxBoulder extends ObstacleComponent {
  bool _stopped = false;
  double _angle  = 0;

  TaxBoulder({required super.laneSystem})
      : super(obstacleType: ObstacleType.taxBoulder,
              startX: laneSystem.rightX + 60);

  @override
  Vector2 get obstacleSize => Vector2(55, 55);

  @override
  Future<void> onLoad() async {
    size     = obstacleSize;
    position = Vector2(laneSystem.roadRight + 20, -size.y);
    add(CircleHitbox(
      radius: size.x / 2,
      collisionType: CollisionType.passive,
    ));
  }

  @override
  void update(double dt) {
    _angle += dt * 4.0;

    if (!_stopped) {
      // Roll left toward centre lane
      position.x -= dt * 180;
      if (position.x <= laneSystem.centerX - size.x / 2) {
        position.x = laneSystem.centerX - size.x / 2;
        _stopped   = true;
      }
    }
    // Fall downward
    position.y += gameRef.diffSystem.fallSpeed * dt;
    if (position.y > gameRef.size.y + size.y) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(size.x/2, size.y/2);
    canvas.rotate(_stopped ? 0 : _angle);
    canvas.translate(-size.x/2, -size.y/2);
    renderBlock(canvas, const Color(0xFF795548), '🪨');
    canvas.restore();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. FOX THIEF — follows hen's lane; 2-second tracking cooldown
// ─────────────────────────────────────────────────────────────────────────────
class FoxThief extends ObstacleComponent {
  double _chaseCooldown = 2.0;
  Lane   _foxLane;

  FoxThief({required super.laneSystem, required math.Random rng})
      : _foxLane = Lane.values[rng.nextInt(3)],
        super(obstacleType: ObstacleType.foxThief,
              startX: 0 /* set below */);

  @override
  Vector2 get obstacleSize => Vector2(laneSystem.laneWidth * 0.80, 48);

  @override
  Future<void> onLoad() async {
    size     = obstacleSize;
    _lane_x  = laneSystem.xForLane(_foxLane);
    position = Vector2(_lane_x - size.x / 2, -size.y);
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    _chaseCooldown -= dt;
    if (_chaseCooldown <= 0) {
      _chaseCooldown = 2.0;
      // Snap to hen's current lane
      _foxLane = gameRef.hen.currentLane;
      _lane_x  = laneSystem.xForLane(_foxLane);
    }
    fallUpdate(dt);
  }

  @override
  void render(Canvas canvas) => renderBlock(canvas, const Color(0xFFE65100), '🦊');
}

// ─────────────────────────────────────────────────────────────────────────────
// FACTORY
// ─────────────────────────────────────────────────────────────────────────────
class ObstacleFactory {
  static ObstacleComponent create({
    required ObstacleType type,
    required LaneSystem laneSystem,
    required math.Random rng,
  }) {
    final lane = Lane.values[rng.nextInt(3)];
    switch (type) {
      case ObstacleType.creditCard:
        return CreditCardWall(laneSystem: laneSystem, lane: lane);
      case ObstacleType.shoppingBoxes:
        return ShoppingAvalanche(laneSystem: laneSystem, lane: lane);
      case ObstacleType.billTornado:
        return BillTornado(laneSystem: laneSystem);
      case ObstacleType.subscriptionSnake:
        return SubscriptionSnake(laneSystem: laneSystem);
      case ObstacleType.taxBoulder:
        return TaxBoulder(laneSystem: laneSystem);
      case ObstacleType.foxThief:
        return FoxThief(laneSystem: laneSystem, rng: rng);
    }
  }
}
