# Hen Blitz — Asset Requirements

## Overview
The placeholder files in `assets/game/` are **1×1 transparent PNGs** and **empty OGG files**.
Replace them with real art and audio before shipping.

---

## 🖼 Sprites (assets/game/sprites/)

| File | Size | Description |
|------|------|-------------|
| `hen_sheet.png` | 768×480 px | 8-column sprite sheet. Rows: 0=run(8fr), 1=jump(6fr), 2=slide(4fr), 3=hurt(4fr), 4=idle(2fr). Frame size: 96×96px |
| `egg_cracked.png` | 56×68 px | Grey cracked egg, worn texture |
| `egg_silver.png` | 64×77 px | Metallic silver egg with slight shimmer |
| `egg_gold.png` | 72×86 px | 4-frame animated gold shimmer sheet |
| `egg_diamond.png` | 80×96 px | 4-frame crystal-blue animated sheet |
| `egg_rainbow.png` | 88×106 px | 8-frame rainbow colour-cycling sheet |
| `obstacle_credit_card.png` | 80×100 px | Red credit card wall barrier |
| `obstacle_boxes.png` | 90×90 px | Stack of Amazon-style cardboard boxes |
| `obstacle_tornado.png` | 100×120 px | 4-frame spinning bill/invoice tornado |
| `obstacle_snake.png` | 120×60 px | 6-frame wriggling green/purple snake with subscription icons |
| `obstacle_boulder.png` | 100×100 px | Brown boulder with Arabic ريال symbol |
| `obstacle_fox.png` | 80×70 px | 4-frame running orange fox |
| `powerup_sheet.png` | 240×48 px | 5 power-ups in a row (48×48 each): magnet, lightning, ×2, shield, feather |

---

## 🌄 Backgrounds (assets/game/bg/)
All should be **1920px wide** and seamlessly tileable horizontally.

| File | Height | Description |
|------|--------|-------------|
| `sky_sunset.png` | 400 px | Warm orange/pink gradient desert sunset sky |
| `mesa_silhouette.png` | 200 px | Dark orange flat-top mesa/plateau silhouettes |
| `dunes_mid.png` | 300 px | Sandy dune hills, mid-distance |
| `cactus_near.png` | 400 px | Cacti on the road edges, transparent center strip |
| `road_ground.png` | 600 px | Sandy ground with two white dashed lane lines converging toward top center |

---

## 🔊 Audio (assets/game/audio/)
All files: OGG Vorbis format, 44.1 kHz stereo.

| File | Duration | Description |
|------|----------|-------------|
| `bgm_desert.ogg` | ~60 s (loop) | Upbeat desert theme, oud + percussion |
| `egg_collect.ogg` | 0.2 s | Light "ding" |
| `golden_egg.ogg` | 0.4 s | Sparkle fanfare |
| `jump.ogg` | 0.3 s | Hen cluck + whoosh |
| `slide.ogg` | 0.2 s | Skid sound |
| `hurt.ogg` | 0.4 s | Impact + squawk |
| `game_over.ogg` | 1.5 s | Sad trombone + cluck |
| `power_up.ogg` | 0.5 s | Ascending chime |

---

## 🎨 Art Style
- **Theme:** Warm desert, cartoonish 3D-ish art style
- **Palette:** Orange (#FF6B35), sand (#E8B45A), dark brown (#5A3010), white, red accents
- **Hen:** Round, white, expressive — scales in size based on spending ratio
- **Obstacles:** Finance-themed but cartoony — not scary, more "educational danger"
