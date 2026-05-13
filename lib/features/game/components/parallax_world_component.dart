// lib/features/game/components/parallax_world_component.dart
// ─────────────────────────────────────────────────────────────────────────────
// VERTICAL scrolling background system.
//
// Layout (portrait, top-down road view):
//   Layer 0: sky_sunset.png        — static sky strip at the very top
//   Layer 1: mesa_silhouette.png   — slow vertical scroll (distant mountains)
//   Layer 2: dunes_mid.png         — medium vertical scroll (dune bands)
//   Layer 3: cactus_near.png       — drawn on left/right with CustomPainter
//   Layer 4: road_ground.png       — fast vertical scroll (the actual road)
//
// Because Flame's ParallaxComponent only supports horizontal scrolling natively,
// we draw the background manually using a CustomPainter overlay + a single
// FlameGame Canvas-based component for the road.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:spend_smart/features/game/models/game_models.dart';
import 'package:spend_smart/features/game/components/hen_blitz_game.dart';

class ParallaxWorldComponent extends Component with HasGameRef<HenBlitzGame> {
  final UserFinancialProfile profile;

  // Loaded images
  ui.Image? _sky;
  ui.Image? _mesa;
  ui.Image? _dunes;
  ui.Image? _cactus;
  ui.Image? _road;

  // Scroll offsets (increase every frame → images tile downward)
  double _skyOffset   = 0;
  double _mesaOffset  = 0;
  double _dunesOffset = 0;
  double _roadOffset  = 0;

  // Scroll speeds (px per second at base world speed 1.0)
  // Road scrolls fastest; sky barely moves.
  static const double _skySpeed   = 8.0;
  static const double _mesaSpeed  = 25.0;
  static const double _dunesSpeed = 55.0;
  static const double _roadSpeed  = 240.0; // matches game feel

  ParallaxWorldComponent({required this.profile});

  @override
  Future<void> onLoad() async {
    // Load all background images; fail silently if missing
    _sky    = await _tryLoad('bg/sky_sunset.png');
    _mesa   = await _tryLoad('bg/mesa_silhouette.png');
    _dunes  = await _tryLoad('bg/dunes_mid.png');
    _cactus = await _tryLoad('bg/cactus_near.png');
    _road   = await _tryLoad('bg/road_ground.png');
  }

  Future<ui.Image?> _tryLoad(String name) async {
    try {
      return await Flame.images.load(name);
    } catch (_) {
      return null;
    }
  }

  @override
  void update(double dt) {
    final spd = gameRef.diffSystem.worldSpeed;

    _skyOffset   = (_skyOffset   + _skySpeed   * spd * dt) % gameRef.size.y;
    _mesaOffset  = (_mesaOffset  + _mesaSpeed  * spd * dt) % gameRef.size.y;
    _dunesOffset = (_dunesOffset + _dunesSpeed * spd * dt) % gameRef.size.y;
    _roadOffset  = (_roadOffset  + _roadSpeed  * spd * dt) % gameRef.size.y;
  }

  @override
  void render(Canvas canvas) {
    final sw = gameRef.size.x;
    final sh = gameRef.size.y;

    // 1. Sky — static top strip (1/3 of screen height)
    _drawTiledVertical(canvas, _sky,    sw, sh, _skyOffset,   skyH: sh * 0.35);

    // 2. Mesa — slow scroll below sky
    _drawTiledVertical(canvas, _mesa,   sw, sh, _mesaOffset,  topFrac: 0.15);

    // 3. Dunes — medium scroll
    _drawTiledVertical(canvas, _dunes,  sw, sh, _dunesOffset, topFrac: 0.25);

    // 4. Road — the main scrolling element (full height, fast)
    _drawRoad(canvas, sw, sh);

    // 5. Cactus — drawn on sides over road (static X, scroll Y)
    _drawTiledVertical(canvas, _cactus, sw, sh, _roadOffset * 0.6);
  }

  // Draws an image tiled vertically (seamless scroll downward).
  void _drawTiledVertical(
    Canvas canvas,
    ui.Image? img,
    double sw, double sh,
    double offset, {
    double topFrac  = 0.0,
    double? skyH,
  }) {
    if (img == null) return;

    final drawH = skyH ?? sh;
    final top   = sh * topFrac;
    final scaleX = sw / img.width;
    final scaleY = drawH / img.height;

    // Draw two copies so the seam is hidden during scroll
    for (final dy in [offset - drawH, offset]) {
      final dst = Rect.fromLTWH(0, top + dy, sw, drawH);
      canvas.drawImageRect(
        img,
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
        dst,
        Paint(),
      );
    }
  }

  // Road is drawn as a solid colored rectangle with lane markings painted
  // directly on the canvas — so it looks correct even without the image.
  void _drawRoad(Canvas canvas, double sw, double sh) {
    // If we have the road image use it, otherwise paint programmatically
    if (_road != null) {
      _drawTiledVertical(canvas, _road, sw, sh, _roadOffset);
      return;
    }

    // Fallback: painted road
    final roadLeft  = sw * 0.20;
    final roadRight = sw * 0.80;

    // Asphalt
    canvas.drawRect(
      Rect.fromLTWH(roadLeft, 0, roadRight - roadLeft, sh),
      Paint()..color = const Color(0xFF3A3732),
    );

    // Edge lines
    final edgePaint = Paint()
      ..color = const Color(0xFFDDDDDD)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(roadLeft, 0),  Offset(roadLeft, sh),  edgePaint);
    canvas.drawLine(Offset(roadRight, 0), Offset(roadRight, sh), edgePaint);

    // Dashed lane dividers
    final dashPaint = Paint()
      ..color = const Color(0xFFF0D232)
      ..strokeWidth = 2;
    final lane1X = roadLeft + (roadRight - roadLeft) / 3;
    final lane2X = roadLeft + 2 * (roadRight - roadLeft) / 3;
    const dashLen = 40.0;
    const gapLen  = 30.0;
    double y = -(_roadOffset % (dashLen + gapLen));
    while (y < sh) {
      canvas.drawLine(Offset(lane1X, y), Offset(lane1X, y + dashLen), dashPaint);
      canvas.drawLine(Offset(lane2X, y), Offset(lane2X, y + dashLen), dashPaint);
      y += dashLen + gapLen;
    }
  }
}
