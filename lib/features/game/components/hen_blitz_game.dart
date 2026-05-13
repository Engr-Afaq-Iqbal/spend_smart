// lib/features/game/components/hen_blitz_game.dart
// ─────────────────────────────────────────────────────────────────────────────
// VERTICAL ROAD version.
//
// Layout:
//   • Background scrolls DOWNWARD  (road moves toward player)
//   • Hen sits at BOTTOM of road, moves LEFT/RIGHT between 3 lanes
//   • Eggs, obstacles, power-ups spawn at TOP and fall DOWN
//   • No perspective scaling — everything is a constant size
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color, Colors;

import 'package:spend_smart/features/game/models/game_models.dart';
import 'package:spend_smart/features/game/systems/game_systems.dart';
import 'package:spend_smart/features/game/components/hen_component.dart';
import 'package:spend_smart/features/game/components/egg_component.dart';
import 'package:spend_smart/features/game/components/obstacle_components.dart';
import 'package:spend_smart/features/game/components/powerup_component.dart';
import 'package:spend_smart/features/game/components/floating_text.dart';
import 'package:spend_smart/features/game/components/parallax_world_component.dart';

class HenBlitzGame extends FlameGame with HasCollisionDetection {
  final UserFinancialProfile profile;
  final void Function(GameResult) onGameComplete;

  HenBlitzGame({required this.profile, required this.onGameComplete});

  // ── Systems ───────────────────────────────────────────────────────────────
  late final LaneSystem        laneSystem;
  late final CoinSystem        coinSystem;
  late final DifficultySystem  diffSystem;
  late final AntiCheatSystem   antiCheat;
  late final AudioSystem       audioSystem;

  // ── Components ────────────────────────────────────────────────────────────
  late final HenComponent            hen;
  late final ParallaxWorldComponent  parallaxWorld;

  // ── Game state ────────────────────────────────────────────────────────────
  double distanceMeters   = 0;
  int    hearts           = 3;
  bool   isGameOver       = false;
  bool   isInvincible     = false;
  double _invincibleTimer = 0;
  double _sessionTime     = 0;
  late final DateTime _sessionStart;

  // ── Spawn timers ──────────────────────────────────────────────────────────
  double _eggTimer      = 0;
  double _powerUpTimer  = 45.0;
  final  math.Random _rng = math.Random();

  // ── HUD ValueNotifiers ─────────────────────────────────────────────────────
  final ValueNotifier<int>    scoreNotifier    = ValueNotifier(0);
  final ValueNotifier<int>    coinsNotifier    = ValueNotifier(0);
  final ValueNotifier<int>    heartsNotifier   = ValueNotifier(3);
  final ValueNotifier<double> speedNotifier    = ValueNotifier(0);
  final ValueNotifier<bool>   gameOverNotifier = ValueNotifier(false);

  // ── Object pool (15 eggs) ─────────────────────────────────────────────────
  final List<EggComponent> _eggPool = [];

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Future<void> onLoad() async {
    _sessionStart = DateTime.now();

    laneSystem  = LaneSystem(screenWidth: size.x);
    coinSystem  = CoinSystem();
    diffSystem  = DifficultySystem();
    antiCheat   = AntiCheatSystem();
    audioSystem = AudioSystem();

    // Background (vertical scrolling road)
    parallaxWorld = ParallaxWorldComponent(profile: profile);
    add(parallaxWorld);

    // Hen at bottom centre
    hen = HenComponent(profile: profile);
    add(hen);

    // Pre-warm egg pool
    for (int i = 0; i < 15; i++) {
      _eggPool.add(EggComponent(
        type: EggType.cracked, lane: Lane.center, laneSystem: laneSystem));
    }

    overlays.add('hud');
    audioSystem.init();
    speedNotifier.value = diffSystem.fallSpeed.round().toDouble();
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void update(double dt) {
    if (isGameOver) return;
    super.update(dt);

    // Free-user time limit (90 s)
    _sessionTime += dt;
    if (!profile.isPro && _sessionTime >= 90.0) {
      overlays.add('proPaywall');
      pauseEngine();
      return;
    }

    diffSystem.update(dt);
    coinSystem.update(dt);
    antiCheat.recordTick(dt);

    // Distance and score
    distanceMeters += profile.henSpeed * dt / 80.0;
    scoreNotifier.value =
        distanceMeters.toInt() + coinSystem.coins * coinSystem.multiplier;
    coinsNotifier.value = coinSystem.coins;
    speedNotifier.value = diffSystem.fallSpeed;

    // Invincibility countdown
    if (isInvincible) {
      _invincibleTimer -= dt;
      if (_invincibleTimer <= 0) { isInvincible = false; _invincibleTimer = 0; }
    }

    // Egg spawning
    _eggTimer += dt;
    if (_eggTimer >= diffSystem.eggSpawnInterval) {
      _eggTimer = 0;
      _spawnEgg();
    }

    // Obstacle spawning
    if (diffSystem.shouldSpawnObstacle()) _spawnObstacle();

    // Power-up spawning
    _powerUpTimer -= dt;
    if (_powerUpTimer <= 0) {
      _powerUpTimer = 25.0 + _rng.nextDouble() * 25.0;
      _spawnPowerUp();
    }

    // Magnet — pull eggs horizontally toward hen's lane
    if (coinSystem.hasMagnet) _applyMagnet();
  }

  // ── Spawning ──────────────────────────────────────────────────────────────
  void _spawnEgg() {
    final type = _rollEggType();
    final lane = Lane.values[_rng.nextInt(3)];

    EggComponent? egg;
    for (final e in _eggPool) {
      if (!e.isMounted) { egg = e; break; }
    }
    if (egg == null) {
      egg = EggComponent(type: type, lane: lane, laneSystem: laneSystem);
      _eggPool.add(egg);
    } else {
      egg.reset(type: type, lane: lane);
    }
    add(egg);
  }

  EggType _rollEggType() {
    final r = _rng.nextDouble();
    if (r < EggData.dropRate[EggType.rainbow]!) return EggType.rainbow;
    if (r < EggData.dropRate[EggType.diamond]!) return EggType.diamond;
    if (r < EggData.dropRate[EggType.gold]!)    return EggType.gold;
    if (r < EggData.dropRate[EggType.silver]!)  return EggType.silver;
    return EggType.cracked;
  }

  void _spawnObstacle() {
    add(ObstacleFactory.create(
      type:       ObstacleType.values[_rng.nextInt(ObstacleType.values.length)],
      laneSystem: laneSystem,
      rng:        _rng,
    ));
  }

  void _spawnPowerUp() {
    add(PowerUpComponent(
      type:       PowerUpType.values[_rng.nextInt(PowerUpType.values.length)],
      lane:       Lane.values[_rng.nextInt(3)],
      laneSystem: laneSystem,
    ));
  }

  // ── Magnet: pull eggs toward the hen's X lane ─────────────────────────────
  void _applyMagnet() {
    const radius = 140.0;
    for (final child in children) {
      if (child is EggComponent) {
        final dx   = hen.position.x - child.position.x;
        final dy   = hen.position.y - child.position.y;
        final dist = math.sqrt(dx*dx + dy*dy);
        if (dist < radius && dist > 1) {
          child.position.x += dx / dist * 5.0;
          child.position.y += dy / dist * 5.0;
        }
      }
    }
  }

  // ── Collision handlers ────────────────────────────────────────────────────
  void onHenHit(ObstacleType obstacle) {
    if (isInvincible) return;
    antiCheat.recordObstacleHit(obstacle);

    if (coinSystem.hasShield) {
      coinSystem.consumeShield();
      triggerInvincibility(2.0);
      audioSystem.playSFX('hurt.ogg', volume: 0.4);
      return;
    }

    hearts--;
    heartsNotifier.value = hearts;
    audioSystem.playSFX('hurt.ogg');

    if (hearts <= 0) {
      triggerGameOver(killedBy: obstacle);
    } else {
      hen.playHurtAnimation();
      triggerInvincibility(1.5);
      _cameraShake();
    }
  }

  void onEggCollected(EggType type, double yPos) {
    antiCheat.recordEggCollect(type, yPos);
    coinSystem.collectEgg(type);
    coinsNotifier.value = coinSystem.coins;

    audioSystem.playSFX(
      (type == EggType.gold || type == EggType.diamond || type == EggType.rainbow)
          ? 'golden_egg.ogg' : 'egg_collect.ogg');

    add(FloatingText(
      text: '+${EggData.coinValues[type]}',
      startPosition: hen.position.clone()..y -= 30,
      color: _eggColor(type),
    ));
  }

  void onPowerUpCollected(PowerUpType type) {
    antiCheat.recordPowerUp(type);
    coinSystem.activatePowerUp(type);
    audioSystem.playSFX('power_up.ogg');
  }

  // ── Game flow ─────────────────────────────────────────────────────────────
  void triggerInvincibility(double seconds) {
    isInvincible     = true;
    _invincibleTimer = seconds;
  }

  void triggerGameOver({ObstacleType? killedBy}) {
    if (isGameOver) return;
    isGameOver = true;
    hen.playDeathAnimation();
    audioSystem.playGameOver();

    final result = GameResult(
      distanceMeters: distanceMeters.toInt(),
      finalScore:     scoreNotifier.value,
      coinsEarned:    coinSystem.coins,
      eggsCollected:  coinSystem.collectedSnapshot,
      killedBy:       killedBy,
      sessionHash:    antiCheat.generateHash(),
      sessionStart:   _sessionStart,
      sessionEnd:     DateTime.now(),
    );

    gameOverNotifier.value = true;
    overlays.remove('hud');
    overlays.add('gameOver');
    onGameComplete(result);
  }

  void _cameraShake() {
    add(_ShakeEffect());
  }

  Color _eggColor(EggType t) => switch (t) {
    EggType.cracked  => Colors.white70,
    EggType.silver   => Colors.white,
    EggType.gold     => const Color(0xFFFFD700),
    EggType.diamond  => const Color(0xFF7BC8F6),
    EggType.rainbow  => const Color(0xFFFF69B4),
  };

  @override
  void onDetach() {
    audioSystem.dispose();
    scoreNotifier.dispose();
    coinsNotifier.dispose();
    heartsNotifier.dispose();
    speedNotifier.dispose();
    gameOverNotifier.dispose();
    super.onDetach();
  }
}

// ── Camera shake ──────────────────────────────────────────────────────────────
class _ShakeEffect extends Component with HasGameRef<HenBlitzGame> {
  double _elapsed = 0;
  static const double _dur = 0.35;
  static const double _amp = 5.0;
  static const int    _n   = 5;

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= _dur) { removeFromParent(); return; }
    final offset = math.sin(_elapsed / _dur * _n * math.pi) *
                   _amp * (1 - _elapsed / _dur);
    gameRef.camera.viewfinder.position = Vector2(offset, offset * 0.4);
  }

  @override
  void onRemove() {
    gameRef.camera.viewfinder.position = Vector2.zero();
    super.onRemove();
  }
}
