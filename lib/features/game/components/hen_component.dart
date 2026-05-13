// lib/features/game/components/hen_component.dart
// ─────────────────────────────────────────────────────────────────────────────
// VERTICAL ROAD version.
//
// The hen sits at the BOTTOM of the screen and only moves LEFT/RIGHT
// between the three road lanes. Items fall from the top toward the hen.
//
// Controls:
//   swipeLeft / ← button  → move one lane left
//   swipeRight / → button → move one lane right
//   swipeUp / ↑ button    → jump (brief Y lift, then land)
//   swipeDown / SLIDE     → slide / duck (smaller hitbox for 800ms)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:ui' as ui;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:spend_smart/features/game/components/hen_blitz_game.dart';
import 'package:spend_smart/features/game/models/game_models.dart';

class HenComponent extends SpriteAnimationGroupComponent<HenAnimation>
    with CollisionCallbacks, HasGameRef<HenBlitzGame> {
  final UserFinancialProfile profile;

  bool _hasSprite = false;

  Lane currentLane = Lane.center;
  Lane targetLane = Lane.center;
  double _laneProgress = 1.0;

  // Jump state
  bool isJumping = false;
  bool isSliding = false;
  double _jumpVelocity = 0;
  double _baseY = 0; // resting Y — the hen returns here after jump

  static const double gravity = 1600.0;
  late RectangleHitbox _hitbox;

  // Tween start/end X for lane switches
  double _startX = 0;
  double _endX = 0;

  HenComponent({required this.profile});

  @override
  Future<void> onLoad() async {
    // Base size — larger hens are fatter spenders
    final base = 72.0 * profile.henBodyScale.clamp(0.7, 1.4);
    size = Vector2(base, base);

    // Hen sits at bottom of the road, 15% from bottom
    _baseY = gameRef.size.y * 0.80;
    final startX = gameRef.laneSystem.xForLane(Lane.center) - size.x / 2;
    position = Vector2(startX, _baseY - size.y);
    _startX = _endX = startX;

    // Hitbox (slightly smaller than visual)
    final hbFrac = 0.70;
    _hitbox = RectangleHitbox(
      size: size * hbFrac,
      position: size * (1 - hbFrac) / 2,
    );
    add(_hitbox);

    // ── Sprite sheet animations ─────────────────────────────────────────
    try {
      final sheet = await gameRef.images.load('sprites/hen_sheet.png');
      final ts = Vector2(96, 96);

      SpriteAnimation row(int r, int count, double step) => SpriteAnimation(
            List.generate(
                count,
                (i) => SpriteAnimationFrame(
                      Sprite(sheet,
                          srcPosition: Vector2(i * 96, r * 96), srcSize: ts),
                      step,
                    )),
            loop: true,
          );

      animations = {
        HenAnimation.run: row(0, 8, 0.08),
        HenAnimation.jump: row(1, 6, 0.10),
        HenAnimation.slide: row(2, 4, 0.12),
        HenAnimation.hurt: row(3, 4, 0.10),
        HenAnimation.idle: row(4, 2, 0.40),
      };
      _hasSprite = true;
    } catch (_) {
      // No sprite sheet — build a 1×1 placeholder so Flame's assertion passes.
      // render() detects empty frames and draws the fallback oval instead.
      final recorder = ui.PictureRecorder();
      ui.Canvas(recorder);
      final img = await recorder.endRecording().toImage(1, 1);
      final dummyAnim = SpriteAnimation(
        [SpriteAnimationFrame(Sprite(img), 1.0)],
        loop: true,
      );
      animations = {for (final a in HenAnimation.values) a: dummyAnim};
    }
    current = HenAnimation.run;
  }

  @override
  void render(ui.Canvas canvas) {
    // Fallback rendering when no sprite sheet is loaded
    if (!_hasSprite) {
      final paint = ui.Paint()
        ..color = const ui.Color(0xFFF5E6C8)
        ..style = ui.PaintingStyle.fill;
      canvas.drawOval(ui.Rect.fromLTWH(0, 0, size.x, size.y), paint);
      final beakPaint = ui.Paint()..color = const ui.Color(0xFFFF9500);
      canvas.drawPath(
        ui.Path()
          ..moveTo(size.x * 0.4, size.y * 0.35)
          ..lineTo(size.x * 0.60, size.y * 0.40)
          ..lineTo(size.x * 0.40, size.y * 0.45)
          ..close(),
        beakPaint,
      );
      final combPaint = ui.Paint()..color = const ui.Color(0xFFD32F2F);
      canvas.drawOval(
          ui.Rect.fromLTWH(
              size.x * 0.35, -size.y * 0.05, size.x * 0.30, size.y * 0.18),
          combPaint);
      canvas.drawCircle(ui.Offset(size.x * 0.60, size.y * 0.32), 4,
          ui.Paint()..color = const ui.Color(0xFF1A1D2E));
      return;
    }
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateLaneTween(dt);
    _updateJump(dt);
  }

  // ── Lane tween ────────────────────────────────────────────────────────────
  void _updateLaneTween(double dt) {
    if (currentLane == targetLane && _laneProgress >= 1.0) return;

    _laneProgress = (_laneProgress + dt / profile.laneSpeed).clamp(0.0, 1.0);
    final t = _easeInOut(_laneProgress);
    position.x = ui.lerpDouble(_startX, _endX, t)!;

    if (_laneProgress >= 1.0) {
      currentLane = targetLane;
      position.x = _endX;
    }
  }

  double _easeInOut(double t) => t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;

  void _startLaneSwitch(Lane newLane) {
    if (newLane == targetLane) return;
    _startX = position.x;
    _endX = gameRef.laneSystem.xForLane(newLane) - size.x / 2;
    targetLane = newLane;
    _laneProgress = 0;
  }

  // ── Jump ──────────────────────────────────────────────────────────────────
  void _updateJump(double dt) {
    if (!isJumping) return;
    _jumpVelocity += gravity * dt;
    position.y += _jumpVelocity * dt;
    if (position.y >= _baseY - size.y) {
      position.y = _baseY - size.y;
      isJumping = false;
      _jumpVelocity = 0;
      if (!isSliding) current = HenAnimation.run;
    }
  }

  // ── Public controls ───────────────────────────────────────────────────────
  void swipeLeft() {
    if (targetLane == Lane.left) return;
    _startLaneSwitch(Lane.values[targetLane.index - 1]);
  }

  void swipeRight() {
    if (targetLane == Lane.right) return;
    _startLaneSwitch(Lane.values[targetLane.index + 1]);
  }

  void jump() {
    if (isJumping || isSliding) return;
    isJumping = true;
    _jumpVelocity = -(profile.jumpForce * 0.65); // vertical road: shorter jump
    current = HenAnimation.jump;
    gameRef.audioSystem.playSFX('jump.ogg');
  }

  void slide() {
    if (isJumping || isSliding) return;
    isSliding = true;
    current = HenAnimation.slide;
    final origH = size.y;
    size = Vector2(size.x, size.y * 0.55);
    position.y = _baseY - size.y;

    // Rebuild hitbox
    remove(_hitbox);
    _hitbox = RectangleHitbox(
      size: size * 0.70,
      position: size * 0.15,
    );
    add(_hitbox);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!isMounted) return;
      isSliding = false;
      size = Vector2(size.x, origH);
      position.y = _baseY - size.y;
      remove(_hitbox);
      _hitbox = RectangleHitbox(size: size * 0.70, position: size * 0.15);
      add(_hitbox);
      current = HenAnimation.run;
    });
  }

  void playHurtAnimation() {
    current = HenAnimation.hurt;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (isMounted) current = HenAnimation.run;
    });
  }

  void playDeathAnimation() {
    current = HenAnimation.hurt;
  }
}
