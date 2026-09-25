/// Global application constants and configuration defaults.
class AppConstants {
  static const String appName = 'Kids English Adventure';
  static const String appTagline = 'Learn English & Beautiful Manners';
  static const String appVersion = '1.0.0';

  // Age limits
  static const int minAge = 3;
  static const int maxAge = 10;

  // Gamification defaults
  static const int defaultStartingCoins = 50;
  static const int defaultStartingStars = 5;
  static const int defaultStartingXp = 0;
  static const int xpPerLesson = 20;
  static const int coinsPerLesson = 10;
  static const int starsPerPerfectLesson = 3;

  // Session limits (Child Safety & Screen Time)
  static const int defaultScreenTimeMinutes = 30;
  static const int minScreenTimeMinutes = 10;
  static const int maxScreenTimeMinutes = 120;

  // Parent Gate
  static const int parentGateChallengeTimeoutSeconds = 60;
}
