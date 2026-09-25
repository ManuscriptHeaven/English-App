import 'package:flutter/material.dart';

/// Premium child-first color palette.
/// Philosophy: warm, illustrated, world-specific — NOT generic Material blue/yellow.
class AppColors {
  // ══════════════════════════════════════════════
  // BASE PALETTE — Warm Illustrated World
  // ══════════════════════════════════════════════

  /// Warm cream — replaces clinical white as the default background.
  static const Color warmCream = Color(0xFFFFF8F0);
  static const Color warmCreamDeep = Color(0xFFF5ECD7);

  /// Sky tones for outdoor scenes
  static const Color skyMorning = Color(0xFFD6EEFF);
  static const Color skyAfternoon = Color(0xFFB8E4FF);
  static const Color skyEvening = Color(0xFFFFCE8F);

  /// Meadow / nature
  static const Color meadowGreen = Color(0xFF52C97F);
  static const Color meadowLight = Color(0xFFC5F0D6);
  static const Color meadowDark = Color(0xFF2E9E5A);

  /// Sun & reward tones
  static const Color sunYellow = Color(0xFFFFD166);
  static const Color sunLight = Color(0xFFFFF0B3);
  static const Color sunDark = Color(0xFFE6A800);

  /// Coral — warm accent (never harsh red)
  static const Color coralWarm = Color(0xFFFF6B6B);
  static const Color coralLight = Color(0xFFFFE5E5);
  static const Color coralDark = Color(0xFFCC4444);

  /// Lavender — gentle purple
  static const Color lavender = Color(0xFFB8A9F0);
  static const Color lavenderLight = Color(0xFFEDE9FF);
  static const Color lavenderDark = Color(0xFF7C6FD4);

  /// Mint — Islamic values, clean
  static const Color mintFresh = Color(0xFF72D7A8);
  static const Color mintLight = Color(0xFFC8F5DF);
  static const Color mintDark = Color(0xFF2EAA72);

  /// Earth tones — paths, ground, warmth
  static const Color earthBrown = Color(0xFF8B6F47);
  static const Color earthLight = Color(0xFFD4B896);
  static const Color earthDark = Color(0xFF5A4227);

  // ══════════════════════════════════════════════
  // SEMANTIC ALIASES — kept for backwards compatibility
  // ══════════════════════════════════════════════

  static const Color primary = meadowGreen;
  static const Color primaryDark = meadowDark;
  static const Color primaryLight = meadowLight;

  static const Color secondary = sunYellow;
  static const Color secondaryDark = sunDark;
  static const Color secondaryLight = sunLight;

  static const Color accent = coralWarm;
  static const Color accentDark = coralDark;
  static const Color accentLight = coralLight;

  /// Old background reference — now warmCream
  static const Color background = warmCream;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE8DCC8);

  // ══════════════════════════════════════════════
  // GAMIFICATION & REWARDS
  // ══════════════════════════════════════════════

  static const Color starGold = Color(0xFFFFD166);
  static const Color starGoldShine = Color(0xFFFFF0B3);
  static const Color coinOrange = Color(0xFFFF9F43);
  static const Color xpPurple = lavender;
  static const Color streakFire = Color(0xFFFF6B35);
  static const Color successGreen = meadowGreen;
  static const Color lockGrey = Color(0xFFCCBBA9);

  // ══════════════════════════════════════════════
  // FEEDBACK
  // ══════════════════════════════════════════════

  static const Color correctGreen = Color(0xFF52C97F);
  static const Color tryAgainOrange = Color(0xFFFF9F43);
  static const Color errorRed = Color(0xFFFF6B6B);

  // ══════════════════════════════════════════════
  // TEXT
  // ══════════════════════════════════════════════

  static const Color textPrimary = Color(0xFF2D2416);
  static const Color textSecondary = Color(0xFF7A6551);
  static const Color textMuted = Color(0xFFAD9880);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnDark = Colors.white;

  // ══════════════════════════════════════════════
  // WORLD THEMES — each world has its own sky, ground, accent
  // ══════════════════════════════════════════════

  // World 1 — Animal Adventure (Meadow)
  static const Color w1Sky = Color(0xFFB8E4FF);
  static const Color w1Ground = Color(0xFF8BC34A);
  static const Color w1Accent = Color(0xFFFF9F43);
  static const Color w1Bg = Color(0xFFE8F5E9);

  // World 2 — Home & Family (Warm Peach)
  static const Color w2Sky = Color(0xFFFFE4CC);
  static const Color w2Ground = Color(0xFFFFF3E0);
  static const Color w2Accent = Color(0xFFFF8FA3);
  static const Color w2Bg = Color(0xFFFFF8F0);

  // World 3 — School & Classroom (Soft Blue/Purple)
  static const Color w3Sky = Color(0xFFDDE8FF);
  static const Color w3Ground = Color(0xFFBBDEFB);
  static const Color w3Accent = Color(0xFF7C6FD4);
  static const Color w3Bg = Color(0xFFEEF3FF);

  // World 4 — Delicious Food (Berry/Warm)
  static const Color w4Sky = Color(0xFFFFE4E4);
  static const Color w4Ground = Color(0xFFFFF0E8);
  static const Color w4Accent = Color(0xFFFF6B6B);
  static const Color w4Bg = Color(0xFFFFF5F0);

  // World 5 — Nature & Weather (Forest/Rain)
  static const Color w5Sky = Color(0xFFCCEAFF);
  static const Color w5Ground = Color(0xFFA5D6A7);
  static const Color w5Accent = Color(0xFF4DB6AC);
  static const Color w5Bg = Color(0xFFE8F5E9);

  // ══════════════════════════════════════════════
  // ISLAMIC VALUES — Gentle Emerald
  // ══════════════════════════════════════════════

  static const Color valueEmerald = Color(0xFF2EAA72);
  static const Color valueMint = mintLight;
  static const Color valueTeal = mintFresh;
  static const Color valueGold = sunYellow;

  // Legacy world colors for backwards compat
  static const Color worldAnimalGreen = w1Ground;
  static const Color worldAnimalBg = w1Bg;
  static const Color worldHomeOrange = w2Accent;
  static const Color worldHomeBg = w2Bg;
  static const Color worldSchoolBlue = w3Accent;
  static const Color worldSchoolBg = w3Bg;
  static const Color worldFoodRed = w4Accent;
  static const Color worldFoodBg = w4Bg;
  static const Color worldAdventurePurple = w5Accent;
  static const Color worldAdventureBg = w5Bg;
}
