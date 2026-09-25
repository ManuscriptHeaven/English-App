import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/rewards/domain/models/child_progress.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/lesson.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';
import '../models/content_mastery.dart';
import '../models/learning_session.dart';
import '../models/learning_signal.dart';
import '../models/recommendation.dart';
import '../models/skill_mastery.dart';
import 'adventure_recommendation_engine.dart';

/// Generates balanced daily adventure plans (3–5 activities, 15–25 mins).
class DailyAdventurePlanner {
  static LearningSession generateDailySession({
    required ChildProfile child,
    ChildProgress? progress,
    required List<ContentMastery> contentMasteries,
    required Map<SkillType, SkillMastery> skillMasteries,
    required World currentWorld,
    required List<Lesson> availableActivities,
    int dailyScreenTimeLimitMinutes = 20,
    required DateTime now,
  }) {
    final List<Recommendation> planActivities = [];
    int accumulatedMinutes = 0;

    // 1. Primary Recommendation (Highest priority need)
    final primaryRec = AdventureRecommendationEngine.getNextRecommendation(
      child: child,
      progress: progress,
      contentMasteries: contentMasteries,
      skillMasteries: skillMasteries,
      currentWorld: currentWorld,
      availableActivities: availableActivities,
      dailyScreenTimeLimitMinutes: dailyScreenTimeLimitMinutes,
      now: now,
    );

    planActivities.add(primaryRec);
    accumulatedMinutes += primaryRec.estimatedDurationMinutes;

    // 2. Add complementary activities for daily multi-skill balance
    final Set<SkillType> includedSkills = {primaryRec.skill};
    final Set<String> includedActivityIds = {primaryRec.activityId};

    for (final lesson in availableActivities) {
      if (accumulatedMinutes >= dailyScreenTimeLimitMinutes) break;
      if (planActivities.length >= 4) break;

      if (!includedActivityIds.contains(lesson.id)) {
        final rec = Recommendation(
          activityId: lesson.id,
          activityType: lesson.id.contains('story')
              ? 'story'
              : (lesson.id.contains('grammar') ? 'grammar' : 'game'),
          worldId: currentWorld.id,
          skill: _inferSkill(lesson.id),
          reason: 'Daily balanced skill variety.',
          childFriendlyPrompt: 'Let\'s try another fun challenge!',
          priority: RecommendationPriority.balancedPractice,
          estimatedDurationMinutes: 4,
          title: lesson.title,
          subtitle: lesson.subtitle,
          routePath: _inferRoute(lesson.id),
        );

        planActivities.add(rec);
        includedSkills.add(rec.skill);
        includedActivityIds.add(rec.activityId);
        accumulatedMinutes += rec.estimatedDurationMinutes;
      }
    }

    return LearningSession(
      id: 'session_${child.id}_${now.year}${now.month}${now.day}',
      childId: child.id,
      createdAt: now,
      totalEstimatedMinutes: accumulatedMinutes,
      activities: planActivities,
      completedActivityIds: const [],
      primaryFocusSkill: primaryRec.skill,
      primaryFocusValue: primaryRec.valueTitle ?? 'Kindness & Manners',
      difficultyLevel: primaryRec.difficultyLevel,
    );
  }

  static SkillType _inferSkill(String id) {
    if (id.contains('grammar') || id.contains('is_are') || id.contains('builder')) return SkillType.grammar;
    if (id.contains('story')) return SkillType.reading;
    if (id.contains('speak')) return SkillType.speaking;
    if (id.contains('listen')) return SkillType.listening;
    if (id.contains('value') || id.contains('sort')) return SkillType.manners;
    return SkillType.vocabulary;
  }

  static String _inferRoute(String id) {
    return '/activity/$id';
  }
}
