---
name: design-system
description: Flutter Design System patterns — AppTheme (Material 3 theming, light/dark), AppSpacing (8dp grid), AppColors, AppAssets, AppTextStyles, AppDecorations, AppShadows. Zero magic numbers rule with centralized UI constants.
---

# Design System & UI Constants

**CRITICAL: Zero magic numbers in UI code. ALL spacing, sizing, colors, radius, shadows, assets MUST come from centralized constants.**

Location: `core/theme/` — Private constructor pattern: `ClassName._();`

## AppSpacing — 8dp Grid System

```dart
class AppSpacing {
  AppSpacing._();

  static const double _unit = 8.0;

  // Spacing scale
  static const double xxs = _unit * 0.25;  // 2dp
  static const double xs = _unit * 0.5;    // 4dp
  static const double sm = _unit * 1;      // 8dp
  static const double md = _unit * 1.5;    // 12dp
  static const double lg = _unit * 2;      // 16dp
  static const double xl = _unit * 3;      // 24dp
  static const double xxl = _unit * 4;     // 32dp
  static const double xxxl = _unit * 5;    // 40dp

  // Component sizes
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 72.0;

  // Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Border radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusRound = 999.0;

  // Pre-built BorderRadius helpers
  static final borderRadiusSm = BorderRadius.circular(radiusSm);
  static final borderRadiusMd = BorderRadius.circular(radiusMd);
  static final borderRadiusLg = BorderRadius.circular(radiusLg);

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Animation durations (ms)
  static const int animationFast = 150;
  static const int animationMedium = 300;
  static const int animationSlow = 500;

  // Responsive breakpoints
  static const double mobileBreakpoint = 480.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;

  static double getHorizontalMargin(double screenWidth) {
    if (screenWidth < mobileBreakpoint) return lg;
    if (screenWidth < tabletBreakpoint) return xl;
    return xxl;
  }
}
```

## AppColors — Semantic Color Architecture

```dart
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutral
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1F2937);
  static const Color onSurface = Color(0xFF374151);

  // Utilities
  static Color getDisabledColor(Color color) => color.withOpacity(0.38);
  static Color getHoverColor(Color color) => color.withOpacity(0.08);

  // Material 3 ColorSchemes
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
    primary: primary,
    error: error,
  );

  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
    primary: primary,
    error: error,
  );
}
```

## AppAssets — Centralized Asset Paths

```dart
class AppAssets {
  AppAssets._();

  // Icons - by category
  static const String logo = 'assets/icons/logo.svg';
  static const String logoShort = 'assets/icons/logo_short.svg';

  // Icons - Navigation
  static const String iconHome = 'assets/icons/home.svg';
  static const String iconProfile = 'assets/icons/profile.svg';
  static const String iconSettings = 'assets/icons/settings.svg';

  // Icons - Actions
  static const String iconSearch = 'assets/icons/search.svg';
  static const String iconClose = 'assets/icons/close.svg';

  // Images
  static const String onboardingBg = 'assets/images/onboarding_bg.png';
  static const String placeholder = 'assets/images/placeholder.png';

  // Animations (Lottie)
  static const String animLoading = 'assets/animations/loading.json';
  static const String animSuccess = 'assets/animations/success.json';
}
```

## AppDecorations — Pre-built BoxDecoration Presets

```dart
class AppDecorations {
  AppDecorations._();

  static BoxDecoration get card => BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppSpacing.borderRadiusMd,
    boxShadow: AppShadows.card,
  );

  static BoxDecoration get outlined => BoxDecoration(
    border: Border.all(color: AppColors.onSurface.withOpacity(0.12)),
    borderRadius: AppSpacing.borderRadiusSm,
  );

  static BoxDecoration cardWith({Color? color, double? borderRadius, List<BoxShadow>? boxShadow}) =>
      BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.radiusMd),
        boxShadow: boxShadow ?? AppShadows.card,
      );
}
```

## AppShadows — Centralized Shadow Definitions

```dart
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> elevated = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 16, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> subtle = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1)),
  ];
}
```

## AppTheme — Material 3 ThemeData Assembly

**Central orchestrator that assembles all design tokens into ThemeData. Always `useMaterial3: true`.**

```dart
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    textTheme: AppTextStyles.textTheme,
    appBarTheme: _appBarTheme(Brightness.light),
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _cardTheme,
    dividerTheme: const DividerThemeData(space: 1, thickness: 1),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: Colors.white.withValues(alpha: 0.87),
      displayColor: Colors.white.withValues(alpha: 0.87),
    ),
    appBarTheme: _appBarTheme(Brightness.dark),
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _cardTheme,
  );

  // Component themes (private)
  static AppBarTheme _appBarTheme(Brightness brightness) => AppBarTheme(
    centerTitle: true,
    elevation: AppSpacing.elevationNone,
    systemOverlayStyle: brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light,
  );

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
        ),
      );

  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: Size.fromHeight(AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
        ),
      );

  static InputDecorationTheme get _inputDecorationTheme =>
      InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      );

  static CardTheme get _cardTheme => CardTheme(
    elevation: AppSpacing.elevationLow,
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.borderRadiusMd,
    ),
  );
}
```

### Usage in main.dart

```dart
MaterialApp.router(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,  // or .light, .dark
  routerConfig: router,
)
```

### Rules

- **Always `useMaterial3: true`** — Material 2 is deprecated
- **Use `ColorScheme.fromSeed()` or explicit ColorScheme** — generates complementary colors automatically
- **Component themes are private** — only `lightTheme`/`darkTheme` are public
- **All values from constants** — AppSpacing for sizes, AppColors for colors
- **Dark theme**: apply color transformations to textTheme, adjust colorScheme brightness

## AppTextStyles — Material 3 Typography

```dart
class AppTextStyles {
  AppTextStyles._();

  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.plusJakartaSans(
      fontSize: 32, fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.plusJakartaSans(
      fontSize: 28, fontWeight: FontWeight.bold,
    ),
    headlineLarge: GoogleFonts.plusJakartaSans(
      fontSize: 24, fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.plusJakartaSans(
      fontSize: 20, fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.plusJakartaSans(
      fontSize: 18, fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.plusJakartaSans(
      fontSize: 16, fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.plusJakartaSans(
      fontSize: 16, fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.plusJakartaSans(
      fontSize: 14, fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.plusJakartaSans(
      fontSize: 12, fontWeight: FontWeight.normal,
    ),
    labelLarge: GoogleFonts.plusJakartaSans(
      fontSize: 14, fontWeight: FontWeight.w600,
    ),
  );
}
```

### Typography Rules

- Use Material 3 semantic names (displayLarge, headlineMedium, bodySmall, labelLarge)
- Prefer Google Fonts for consistency across platforms
- Define line height and letter spacing via helper methods when needed
- Dark theme applies color transformations via `.apply(bodyColor:, displayColor:)`

## File Organization

```
lib/core/theme/
├── app_spacing.dart        # Spacing, sizing, radius, breakpoints, animations
├── app_colors.dart         # Color palette + Material 3 ColorScheme
├── app_assets.dart         # Centralized asset paths
├── app_text_styles.dart    # Material 3 TextTheme
├── app_theme.dart          # Complete ThemeData assembly
├── app_decorations.dart    # Pre-built BoxDecoration presets
└── app_shadows.dart        # Shadow definitions
```

## Anti-patterns to Reject

```dart
// ❌ Magic numbers
Padding(padding: EdgeInsets.all(16.0))
SizedBox(height: 8)
BorderRadius.circular(12)
Color(0xFF6366F1)
'assets/icons/home.svg'

// ✅ Semantic constants
Padding(padding: EdgeInsets.all(AppSpacing.lg))
SizedBox(height: AppSpacing.sm)
AppSpacing.borderRadiusMd
AppColors.primary
AppAssets.iconHome
```
