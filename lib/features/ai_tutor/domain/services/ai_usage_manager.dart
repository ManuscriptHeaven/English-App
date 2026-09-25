import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_parent_settings.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_usage_stats.dart';

/// Manages child daily usage quotas, session tracking, and parent budget enforcement.
class AiUsageManager {
  final Map<String, AiUsageStats> _dailyStats = {};

  String _getDateKey(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  String _getKey(String childId, DateTime dt) => '${childId}_${_getDateKey(dt)}';

  AiUsageStats getTodayStats(String childId, [DateTime? now]) {
    final date = now ?? DateTime.now();
    final key = _getKey(childId, date);
    return _dailyStats[key] ??
        AiUsageStats(
          childId: childId,
          dateKey: _getDateKey(date),
        );
  }

  bool canStartSession({
    required String childId,
    required AiParentSettings settings,
    DateTime? now,
  }) {
    if (!settings.aiTutorEnabled) return false;
    final stats = getTodayStats(childId, now);
    if (stats.usedMinutes >= settings.dailyMinutesLimit) return false;
    if (stats.usedTurns >= settings.dailyTurnsLimit) return false;
    return true;
  }

  bool canPerformTurn({
    required String childId,
    required AiParentSettings settings,
    DateTime? now,
  }) {
    if (!settings.aiTutorEnabled) return false;
    final stats = getTodayStats(childId, now);
    return stats.usedTurns < settings.dailyTurnsLimit && stats.usedMinutes < settings.dailyMinutesLimit;
  }

  void recordTurn({
    required String childId,
    required bool isSuccess,
    required bool isFallback,
    int estimatedSeconds = 15,
    DateTime? now,
  }) {
    final date = now ?? DateTime.now();
    final key = _getKey(childId, date);
    final current = getTodayStats(childId, date);

    final updated = current.copyWith(
      usedTurns: current.usedTurns + 1,
      usedMinutes: current.usedMinutes + (estimatedSeconds ~/ 60),
      successfulResponses: current.successfulResponses + (isSuccess ? 1 : 0),
      fallbackCount: current.fallbackCount + (isFallback ? 1 : 0),
    );

    _dailyStats[key] = updated;
  }

  void recordSessionStart(String childId, [DateTime? now]) {
    final date = now ?? DateTime.now();
    final key = _getKey(childId, date);
    final current = getTodayStats(childId, date);

    _dailyStats[key] = current.copyWith(
      sessionCount: current.sessionCount + 1,
    );
  }
}
