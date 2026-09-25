import 'package:flutter/material.dart';
import 'app_colors.dart';

/// World-specific visual theming system.
/// Every world has its own sky, ground, accent, and ambient color identity.
/// Worlds should feel different without looking like different apps.
class WorldTheme {
  final String worldId;
  final String displayName;
  final String emoji;

  // Environment colors
  final Color skyColor;
  final Color skyColorBottom;
  final Color groundColor;
  final Color groundColorDark;
  final Color accentColor;
  final Color backgroundColor;

  // UI tones
  final Color nodeCompletedColor;
  final Color nodeActiveColor;
  final Color nodeLockedColor;
  final Color pathColor;

  // Ambient decoration
  final List<String> environmentEmojis; // decorative scene elements
  final String worldCreatureEmoji;       // main world mascot

  const WorldTheme({
    required this.worldId,
    required this.displayName,
    required this.emoji,
    required this.skyColor,
    required this.skyColorBottom,
    required this.groundColor,
    required this.groundColorDark,
    required this.accentColor,
    required this.backgroundColor,
    required this.nodeCompletedColor,
    required this.nodeActiveColor,
    required this.nodeLockedColor,
    required this.pathColor,
    required this.environmentEmojis,
    required this.worldCreatureEmoji,
  });

  // ══════════════════════════════════════════════
  // WORLD DEFINITIONS
  // ══════════════════════════════════════════════

  static const WorldTheme animalAdventure = WorldTheme(
    worldId: 'world_animal',
    displayName: 'Animal Adventure',
    emoji: '🌿',
    skyColor: Color(0xFF87CEEB),
    skyColorBottom: AppColors.w1Sky,
    groundColor: AppColors.w1Ground,
    groundColorDark: Color(0xFF558B2F),
    accentColor: AppColors.w1Accent,
    backgroundColor: AppColors.w1Bg,
    nodeCompletedColor: AppColors.sunYellow,
    nodeActiveColor: AppColors.meadowGreen,
    nodeLockedColor: AppColors.lockGrey,
    pathColor: Color(0xFFD4B896),
    environmentEmojis: ['🌳', '🌿', '🌸', '🦋', '☁️'],
    worldCreatureEmoji: '🐘',
  );

  static const WorldTheme homeFamily = WorldTheme(
    worldId: 'world_home',
    displayName: 'Home & Family',
    emoji: '🏠',
    skyColor: Color(0xFFFFE4CC),
    skyColorBottom: AppColors.w2Sky,
    groundColor: Color(0xFFFFF3E0),
    groundColorDark: Color(0xFFFFCC80),
    accentColor: AppColors.w2Accent,
    backgroundColor: AppColors.w2Bg,
    nodeCompletedColor: AppColors.sunYellow,
    nodeActiveColor: AppColors.w2Accent,
    nodeLockedColor: AppColors.lockGrey,
    pathColor: Color(0xFFFFCC80),
    environmentEmojis: ['🌷', '🏡', '🌻', '🐝', '☀️'],
    worldCreatureEmoji: '🏠',
  );

  static const WorldTheme schoolClassroom = WorldTheme(
    worldId: 'world_school',
    displayName: 'School & Classroom',
    emoji: '🏫',
    skyColor: Color(0xFFDDE8FF),
    skyColorBottom: AppColors.w3Sky,
    groundColor: AppColors.w3Ground,
    groundColorDark: Color(0xFF90CAF9),
    accentColor: AppColors.w3Accent,
    backgroundColor: AppColors.w3Bg,
    nodeCompletedColor: AppColors.sunYellow,
    nodeActiveColor: AppColors.w3Accent,
    nodeLockedColor: AppColors.lockGrey,
    pathColor: Color(0xFFBBDEFB),
    environmentEmojis: ['📚', '✏️', '🎒', '📐', '⭐'],
    worldCreatureEmoji: '📚',
  );

  static const WorldTheme deliciousFood = WorldTheme(
    worldId: 'world_food',
    displayName: 'Delicious Food',
    emoji: '🍎',
    skyColor: Color(0xFFFFE4E4),
    skyColorBottom: AppColors.w4Sky,
    groundColor: AppColors.w4Ground,
    groundColorDark: Color(0xFFFFCDD2),
    accentColor: AppColors.w4Accent,
    backgroundColor: AppColors.w4Bg,
    nodeCompletedColor: AppColors.sunYellow,
    nodeActiveColor: AppColors.w4Accent,
    nodeLockedColor: AppColors.lockGrey,
    pathColor: Color(0xFFFFCCBC),
    environmentEmojis: ['🍎', '🍊', '🍋', '🍇', '🌮'],
    worldCreatureEmoji: '🍎',
  );

  static const WorldTheme natureWeather = WorldTheme(
    worldId: 'world_nature',
    displayName: 'Nature & Weather',
    emoji: '🌿',
    skyColor: Color(0xFFCCEAFF),
    skyColorBottom: AppColors.w5Sky,
    groundColor: AppColors.w5Ground,
    groundColorDark: Color(0xFF66BB6A),
    accentColor: AppColors.w5Accent,
    backgroundColor: AppColors.w5Bg,
    nodeCompletedColor: AppColors.sunYellow,
    nodeActiveColor: AppColors.w5Accent,
    nodeLockedColor: AppColors.lockGrey,
    pathColor: Color(0xFFA5D6A7),
    environmentEmojis: ['🌲', '🌦️', '🌈', '🦋', '🌸'],
    worldCreatureEmoji: '🌿',
  );

  /// Default fallback theme
  static const WorldTheme defaultTheme = animalAdventure;

  /// Look up theme by world ID
  static WorldTheme forWorldId(String worldId) {
    switch (worldId) {
      case 'world_animal':
        return animalAdventure;
      case 'world_home':
        return homeFamily;
      case 'world_school':
        return schoolClassroom;
      case 'world_food':
        return deliciousFood;
      case 'world_nature':
        return natureWeather;
      default:
        return animalAdventure;
    }
  }

  /// Determine world from activity ID prefix
  static WorldTheme forActivityId(String activityId) {
    if (activityId.contains('home') || activityId.contains('family') || activityId.contains('cleanliness')) {
      return homeFamily;
    }
    if (activityId.contains('school') || activityId.contains('classroom') || activityId.contains('teacher') || activityId.contains('plural') || activityId.contains('polite') || activityId.contains('honesty')) {
      return schoolClassroom;
    }
    if (activityId.contains('food') || activityId.contains('eating') || activityId.contains('hungry')) {
      return deliciousFood;
    }
    if (activityId.contains('nature') || activityId.contains('weather') || activityId.contains('care_for')) {
      return natureWeather;
    }
    return animalAdventure;
  }

  /// Gradient from sky to horizon
  LinearGradient get skyGradient => LinearGradient(
        colors: [skyColor, skyColorBottom],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  /// Ground gradient
  LinearGradient get groundGradient => LinearGradient(
        colors: [groundColor, groundColorDark],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
}
