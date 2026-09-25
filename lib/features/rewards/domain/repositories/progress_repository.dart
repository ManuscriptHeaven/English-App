import '../models/achievement.dart';
import '../models/child_progress.dart';
import '../models/daily_mission.dart';

/// Abstract repository for tracking child learning progress, missions, and achievements.
abstract class IProgressRepository {
  Future<ChildProgress> getProgressForChild(String childId);
  Future<void> saveProgress(ChildProgress progress);
  Future<List<Achievement>> getAchievementsForChild(String childId);
  Future<List<DailyMission>> getDailyMissionsForChild(String childId);
  Future<void> recordLessonCompletion({
    required String childId,
    required String lessonId,
    required int stars,
    required int score,
    required int timeSpentSeconds,
    required int rewardXp,
    required int rewardCoins,
  });
}
