// lib/features/game/systems/game_systems.dart
// ─────────────────────────────────────────────────────────────────────────────
// Game systems — DifficultySystem, CoinSystem, AntiCheatSystem,
// AudioSystem, LaneSystem.
//
// VERTICAL ROAD — LaneSystem now gives absolute X pixel positions for the
// 3 lanes on a portrait road (road = centre 60% of screen width).
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:spend_smart/features/game/models/game_models.dart';

// ═════════════════════════════════════════════════════════════════════════════
// DIFFICULTY SYSTEM
// ═════════════════════════════════════════════════════════════════════════════
class DifficultySystem {
  /// World scroll speed — multiplier on top of base lane speed.
  /// 1.0 = normal; increases over time.
  double worldSpeed = 1.0;

  /// Seconds between consecutive obstacle spawns
  double spawnInterval = 2.8;

  double _spawnTimer = 0.0;
  double totalTime   = 0.0;

  void update(double dt) {
    totalTime    += dt;
    worldSpeed    = (worldSpeed    + 0.005  * dt).clamp(1.0, 3.5);
    spawnInterval = (spawnInterval - 0.008  * dt).clamp(0.6, 2.8);
    _spawnTimer  += dt;
  }

  bool shouldSpawnObstacle() {
    if (_spawnTimer >= spawnInterval) {
      _spawnTimer = 0.0;
      return true;
    }
    return false;
  }

  double get eggSpawnInterval => (spawnInterval * 0.40).clamp(0.35, 1.2);

  /// Pixels per second that objects fall down the screen.
  /// Hen sits at bottom; everything else spawns at top and falls down.
  double get fallSpeed => 280.0 * worldSpeed;
}

// ═════════════════════════════════════════════════════════════════════════════
// LANE SYSTEM  (vertical road, portrait orientation)
// ═════════════════════════════════════════════════════════════════════════════
class LaneSystem {
  final double screenWidth;

  LaneSystem({required this.screenWidth});

  // Road occupies centre 60% of screen
  double get roadLeft  => screenWidth * 0.20;
  double get roadRight => screenWidth * 0.80;
  double get roadWidth => roadRight - roadLeft;
  double get laneWidth => roadWidth / 3;

  /// Absolute X centre of each lane
  double get leftX   => roadLeft + laneWidth * 0.5;
  double get centerX => roadLeft + laneWidth * 1.5;
  double get rightX  => roadLeft + laneWidth * 2.5;

  double xForLane(Lane lane) {
    return switch (lane) {
      Lane.left   => leftX,
      Lane.center => centerX,
      Lane.right  => rightX,
    };
  }

  Lane randomLane() {
    final r = (DateTime.now().microsecondsSinceEpoch % 3);
    return Lane.values[r];
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// COIN SYSTEM
// ═════════════════════════════════════════════════════════════════════════════
class CoinSystem {
  int coins      = 0;
  int multiplier = 1;
  bool hasShield  = false;
  bool hasMagnet  = false;
  bool hasFeather = false;

  final Map<EggType, int> eggsCollected = {};
  final List<_TimedCallback> _pendingCallbacks = [];

  void collectEgg(EggType type) {
    final base = EggData.coinValues[type] ?? 1;
    coins += base * multiplier;
    eggsCollected[type] = (eggsCollected[type] ?? 0) + 1;
  }

  void activatePowerUp(PowerUpType type) {
    switch (type) {
      case PowerUpType.multiplier:
        multiplier = 2;
        _resetAfter(10.0, () => multiplier = 1);
      case PowerUpType.shield:
        hasShield = true;
      case PowerUpType.magnet:
        hasMagnet = true;
        _resetAfter(8.0, () => hasMagnet = false);
      case PowerUpType.speedBoost:
        _resetAfter(5.0, () {});
      case PowerUpType.featherFloat:
        hasFeather = true;
        _resetAfter(6.0, () => hasFeather = false);
    }
  }

  void consumeShield() => hasShield = false;

  void update(double dt) {
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    for (final cb in List.of(_pendingCallbacks)) {
      if (now >= cb.fireAt) {
        cb.action();
        _pendingCallbacks.remove(cb);
      }
    }
  }

  void _resetAfter(double seconds, void Function() action) {
    final fireAt = DateTime.now().millisecondsSinceEpoch / 1000.0 + seconds;
    _pendingCallbacks.add(_TimedCallback(fireAt: fireAt, action: action));
  }

  Map<EggType, int> get collectedSnapshot => Map.unmodifiable(eggsCollected);
}

class _TimedCallback {
  final double fireAt;
  final void Function() action;
  const _TimedCallback({required this.fireAt, required this.action});
}

// ═════════════════════════════════════════════════════════════════════════════
// ANTI-CHEAT SYSTEM
// ═════════════════════════════════════════════════════════════════════════════
class AntiCheatSystem {
  final List<String> _events = [];
  final DateTime _sessionStart = DateTime.now();
  int _tickCount = 0;
  bool isFlagged = false;
  final List<double> _recentEventTimes = [];

  void recordTick(double dt) {
    _tickCount++;
    if (dt > 0.5 || dt < 0) isFlagged = true;
  }

  void recordEggCollect(EggType type, double yPos) {
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    _events.add('egg:${type.name}:${yPos.toStringAsFixed(0)}:$now');
    _recentEventTimes.add(now);
    _validateRate();
  }

  void recordObstacleHit(ObstacleType type) {
    _events.add('hit:${type.name}');
  }

  void recordPowerUp(PowerUpType type) {
    _events.add('pu:${type.name}');
  }

  void _validateRate() {
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    _recentEventTimes.removeWhere((t) => now - t > 1.0);
    if (_recentEventTimes.length > 5) {
      isFlagged = true;
      _events.add('FLAG:rate_exceeded');
    }
  }

  String generateHash() {
    final buffer =
        '${_sessionStart.millisecondsSinceEpoch}:$_tickCount:${_events.join(",")}:${isFlagged ? "FLAGGED" : "OK"}';
    return sha256.convert(utf8.encode(buffer)).toString();
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// AUDIO SYSTEM
// ═════════════════════════════════════════════════════════════════════════════
class AudioSystem {
  bool _initialized = false;
  bool isMuted = false;

  Future<void> init() async {
    try {
      await FlameAudio.audioCache.loadAll([
        'bgm_desert.ogg', 'egg_collect.ogg', 'golden_egg.ogg',
        'jump.ogg', 'slide.ogg', 'hurt.ogg', 'game_over.ogg', 'power_up.ogg',
      ]);
      _initialized = true;
      await FlameAudio.bgm.play('bgm_desert.ogg', volume: 0.4);
    } catch (_) {}
  }

  void playSFX(String file, {double volume = 0.8}) {
    if (!_initialized || isMuted) return;
    try { FlameAudio.play(file, volume: volume); } catch (_) {}
  }

  void playGameOver() {
    try { FlameAudio.bgm.stop(); } catch (_) {}
    playSFX('game_over.ogg', volume: 1.0);
  }

  void dispose() {
    try { FlameAudio.bgm.stop(); } catch (_) {}
  }
}
