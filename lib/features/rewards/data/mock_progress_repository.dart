import '../domain/models/achievement.dart';
import '../domain/models/child_progress.dart';
import '../domain/models/daily_mission.dart';
import '../domain/repositories/progress_repository.dart';

/// Seeded in-memory / local implementation for Phase 01.
class MockProgressRepository implements IProgressRepository {
  final Map<String, ChildProgress> _progressByChild = {};
  final Map<String, List<Achievement>> _achievementsByChild = {};
  final Map<String, List<DailyMission>> _missionsByChild = {};

  MockProgressRepository() {
    _seedData();
  }

  void _seedData() {
    const ayaanId = 'child_ayaan';
    _progressByChild[ayaanId] = ChildProgress(
      childId: ayaanId,
      totalLessonsCompleted: 1,
      totalStoriesRead: 1,
      totalGamesPlayed: 2,
      totalMinutesSpent: 25,
      wordProgressMap: {
        'vocab_elephant': WordProgress(
          wordId: 'vocab_elephant',
          timesSeen: 3,
          timesCorrect: 3,
          masteryLevel: 1.0,
          lastReviewed: DateTime.now(),
          nextReviewDate: DateTime.now().add(const Duration(days: 2)),
        ),
        'vocab_cat': WordProgress(
          wordId: 'vocab_cat',
          timesSeen: 2,
          timesCorrect: 2,
          masteryLevel: 0.8,
          lastReviewed: DateTime.now(),
          nextReviewDate: DateTime.now().add(const Duration(days: 1)),
        ),
      },
      practicedValuesIds: const ['value_kindness_animals'],
    );

    _achievementsByChild[ayaanId] = [
      const Achievement(
        id: 'ach_first_steps',
        title: 'First Word Explorer',
        description: 'Complete your very first English lesson!',
        category: 'vocabulary',
        iconAssetPath: 'assets/icons/ach_star.png',
        targetGoal: 1,
        currentProgress: 1,
        isUnlocked: true,
      ),
      const Achievement(
        id: 'ach_animal_hero',
        title: 'Animal Kind Hero',
        description: 'Practice 3 lessons showing mercy to Allah’s creatures',
        category: 'values',
        iconAssetPath: 'assets/icons/ach_heart.png',
        targetGoal: 3,
        currentProgress: 1,
        isUnlocked: false,
      ),
      const Achievement(
        id: 'ach_streak_3',
        title: '3-Day Fire Streak',
        description: 'Learn 3 days in a row without missing',
        category: 'streak',
        iconAssetPath: 'assets/icons/ach_fire.png',
        targetGoal: 3,
        currentProgress: 3,
        isUnlocked: true,
      ),
    ];

    _missionsByChild[ayaanId] = [
      const DailyMission(
        id: 'mission_daily_vocab',
        title: 'Learn 2 Animal Words',
        description: 'Tap & repeat 2 new animal names today',
        targetCount: 2,
        currentCount: 1,
        rewardCoins: 15,
        rewardStars: 1,
      ),
      const DailyMission(
        id: 'mission_daily_story',
        title: 'Read Animal Story',
        description: 'Listen to "A Friendly Day at the Animal Park"',
        targetCount: 1,
        currentCount: 0,
        rewardCoins: 20,
        rewardStars: 1,
      ),
    ];
  }

  @override
  Future<ChildProgress> getProgressForChild(String childId) async {
    return _progressByChild[childId] ?? ChildProgress(childId: childId);
  }

  @override
  Future<void> saveProgress(ChildProgress progress) async {
    _progressByChild[progress.childId] = progress;
  }

  @override
  Future<List<Achievement>> getAchievementsForChild(String childId) async {
    return _achievementsByChild[childId] ?? [];
  }

  @override
  Future<List<DailyMission>> getDailyMissionsForChild(String childId) async {
    return _missionsByChild[childId] ?? [];
  }

  @override
  Future<void> recordLessonCompletion({
    required String childId,
    required String lessonId,
    required int stars,
    required int score,
    required int timeSpentSeconds,
    required int rewardXp,
    required int rewardCoins,
  }) async {
    final current = await getProgressForChild(childId);
    final updatedLessons = Map<String, LessonProgress>.from(current.lessonProgressMap);
    updatedLessons[lessonId] = LessonProgress(
      lessonId: lessonId,
      stars: stars,
      score: score,
      timeSpentSeconds: timeSpentSeconds,
      completedAt: DateTime.now(),
    );

    final updated = current.copyWith(
      totalLessonsCompleted: current.totalLessonsCompleted + 1,
      totalMinutesSpent: current.totalMinutesSpent + (timeSpentSeconds ~/ 60),
      lessonProgressMap: updatedLessons,
    );

    await saveProgress(updated);
  }
}
