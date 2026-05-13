// lib/game/components/powerup_component.dart
// ─────────────────────────────────────────────────────────────────────────────
// Power-up collectibles that apply special effects on collection.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:ui' as ui;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:spend_smart/features/game/models/game_models.dart';
import 'package:spend_smart/features/game/systems/game_systems.dart';
import 'package:spend_smart/features/game/utils/perspective_scaler.dart';
import 'package:spend_smart/features/game/components/hen_blitz_game.dart';
import 'package:spend_smart/features/game/components/hen_component.dart';

class PowerUpComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<HenBlitzGame> {
  final PowerUpType type;
  final Lane        lane;
  final LaneSystem  laneSystem;

  double _normalizedY = 0.0;
  double _laneOffset  = 0.0;

  PowerUpComponent({
    required this.type,
    required this.lane,
    required this.laneSystem,
  });

  @override
  Future<void> onLoad() async {
    _normalizedY = PerspectiveScaler.vanishingPointNY + 0.01;
    _laneOffset  = laneSystem.xForLane(lane);
    _updateSizePos();

    try {
      sprite = Sprite(await gameRef.images.load('sprites/powerup_sheet.png'));
    } catch (_) {
      final rec = ui.PictureRecorder();
      ui.Canvas(rec);
      sprite = Sprite(await rec.endRecording().toImage(1, 1));
    }

    add(CircleHitbox(radius: (size.x / 2).clamp(4.0, 40.0)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _normalizedY += gameRef.diffSystem.worldSpeed * dt;
    if (_normalizedY > 1.05) {
      removeFromParent();
      return;
    }
    _updateSizePos();
  }

  void _updateSizePos() {
    final scale = PerspectiveScaler.scaleForNY(_normalizedY);
    size = Vector2(48, 48) * scale;
    final wx = PerspectiveScaler.laneXForNY(
      _laneOffset, gameRef.size.x, _normalizedY);
    position = Vector2(wx - size.x / 2, gameRef.size.y * _normalizedY - size.y);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is HenComponent) {
      gameRef.onPowerUpCollected(type);
      removeFromParent();
    }
  }
}
