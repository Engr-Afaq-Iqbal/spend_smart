# SpendSmart Flutter App

A pixel-perfect Flutter implementation of the SpendSmart personal finance tracker UI.

## 📁 Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart        ← All brand colors (design tokens)
│   │   ├── app_spacing.dart       ← 4pt grid spacing scale
│   │   └── app_text_styles.dart   ← All typography styles
│   └── theme/
│       └── app_theme.dart         ← Light + Dark ThemeData
│
├── features/
│   ├── home/
│   │   ├── controller/
│   │   │   └── home_controller.dart    ← GetX controller, state, mock data
│   │   ├── model/
│   │   │   └── home_models.dart        ← Data models + mock data
│   │   ├── view/
│   │   │   ├── home_view.dart          ← Main scrollable home screen
│   │   │   └── main_navigation.dart   ← Root shell, BottomNav, PageView
│   │   └── widgets/
│   │       ├── ai_insight_banner.dart
│   │       ├── health_budget_panel.dart
│   │       ├── health_score_ring.dart  ← Custom painted ring
│   │       ├── recent_transactions_section.dart
│   │       ├── savings_goal_section.dart
│   │       ├── summary_header_card.dart
│   │       ├── top_categories_section.dart
│   │       └── upcoming_bills_section.dart
│   └── expenses/
│       └── view/expenses_view.dart     ← Placeholder (expand later)
│
├── routes/
│   ├── app_bindings.dart          ← GetX DI bindings
│   └── app_routes.dart            ← Named route definitions
│
├── shared/
│   └── widgets/
│       ├── app_card.dart          ← Reusable card container
│       └── section_header.dart    ← "Title + View All" row
│
└── main.dart
```

## 🚀 Getting Started

```bash
# 1. Get dependencies
flutter pub get

# 2. Run on device/simulator
flutter run

# 3. Build release APK
flutter build apk --release
```

## 🎨 Design System

| Token | Value |
|-------|-------|
| Primary | `#FF6B35` (coral orange) |
| Background | `#F8F9FC` |
| Surface | `#FFFFFF` |
| Text Primary | `#1A1D2E` |
| Text Secondary | `#6B7280` |

## 🔄 Swapping Mock Data for Real API

In `home_controller.dart`, replace the `_loadData()` body:

```dart
Future<void> _loadData() async {
  isLoading.value = true;
  final result = await YourApiService.getHomeData();
  transactions.assignAll(result.transactions);
  // ...
  isLoading.value = false;
}
```

Models stay the same — only the data source changes.

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `get` | State management + navigation |
| `google_fonts` | Poppins font |

## 🌙 Dark Mode

Dark theme is prepared in `app_theme.dart`. Enable it by changing:
```dart
themeMode: ThemeMode.system, // in main.dart
```
