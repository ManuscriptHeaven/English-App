import 'package:kids_english_adventure/core/routing/route_names.dart';
import 'package:kids_english_adventure/core/theme/age_group_config.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/rewards/domain/models/child_progress.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/lesson.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';
import '../adaptive/activity_variety_engine.dart';
import '../adaptive/confidence_guardian.dart';
import '../adaptive/difficulty_engine.dart';
import '../adaptive/learning_recommendation.dart';
import '../adaptive/spaced_review_scheduler.dart';
import '../adaptive/vocabulary_mastery.dart';
import '../models/content_mastery.dart';
import '../models/learning_signal.dart';
import '../models/recommendation.dart';
import '../models/skill_mastery.dart';
import 'package:kids_english_adventure/features/curriculum/domain/repositories/curriculum_repository.dart';
import 'package:kids_english_adventure/features/curriculum/domain/services/curriculum_level_progression_engine.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_concept.dart';

/// Central deterministic recommendation engine deciding what a child should do next.
class AdventureRecommendationEngine {
  /// Generates the single highest-priority recommendation for a child.
  static Recommendation getNextRecommendation({
    required ChildProfile child,
    ChildProgress? progress,
    required List<ContentMastery> contentMasteries,
    required Map<SkillType, SkillMastery> skillMasteries,
    required World currentWorld,
    required List<Lesson> availableActivities,
    List<World>? trackWorlds,
    int dailyScreenTimeLimitMinutes = 30,
    required DateTime now,
  }) {
    // ----------------------------------------------------
    // PRIORITY 1: Parent Safety / Screen Time Limit
    // ----------------------------------------------------
    final minutesSpentToday = progress?.totalMinutesSpent ?? 0;
    if (minutesSpentToday >= dailyScreenTimeLimitMinutes) {
      return const Recommendation(
        activityId: 'activity_screen_time_rest',
        activityType: 'rest',
        worldId: 'world_home',
        skill: SkillType.manners,
        reason: 'Daily screen time limit reached. Encouraging off-screen play.',
        childFriendlyPrompt: 'MashaAllah! You did great today! Time for some fun off-screen play! 🌟',
        priority: RecommendationPriority.parentSafety,
        estimatedDurationMinutes: 0,
        difficultyLevel: 1,
        title: 'Rest & Play Time 🌿',
        subtitle: 'Daily adventure target achieved!',
        routePath: RouteNames.home,
        isRequired: true,
      );
    }

    // ----------------------------------------------------
    // PRIORITY 2: Overdue Spaced Repetition Review
    // ----------------------------------------------------
    final overdueItems = contentMasteries.where((cm) => cm.isDueForReview(now)).toList();
    if (overdueItems.isNotEmpty) {
      final item = overdueItems.first;
      return Recommendation(
        activityId: 'activity_spaced_review',
        activityType: 'review',
        worldId: currentWorld.id,
        skill: item.skill,
        reason: 'Content "${item.contentId}" is due for memory reinforcement.',
        childFriendlyPrompt: 'Pip says: "Let\'s refresh our memory on words we learned before!" 🧠',
        priority: RecommendationPriority.overdueReview,
        estimatedDurationMinutes: 3,
        difficultyLevel: item.currentDifficultyLevel,
        isReview: true,
        title: 'Memory Refresh 🧠',
        subtitle: 'Review words & phrases',
        routePath: RouteNames.adaptiveReview,
      );
    }

    // ----------------------------------------------------
    // PRIORITY 3: Critical Content-Level Weakness (< 0.45)
    // ----------------------------------------------------
    final weakContentList = contentMasteries.where((cm) => cm.isWeak).toList();
    if (weakContentList.isNotEmpty) {
      final weakItem = weakContentList.first;
      return _buildRecommendationForWeakContent(weakItem, currentWorld);
    }

    // ----------------------------------------------------
    // PRIORITY 4: Skill-Level Weakness (< 0.60)
    // ----------------------------------------------------
    for (final skill in [SkillType.speaking, SkillType.listening, SkillType.grammar]) {
      final sm = skillMasteries[skill];
      if (sm != null && sm.score < 0.60 && sm.totalItemsTracked > 0) {
        return _buildRecommendationForWeakSkill(skill, sm.score, currentWorld);
      }
    }

    // ----------------------------------------------------
    // PRIORITY 5: Next Uncompleted Curriculum Step (Across Child's Entire Track)
    // ----------------------------------------------------
    final completedIds = child.completedLessonIds;

    // First scan across the entire track in sequential order
    if (trackWorlds != null && trackWorlds.isNotEmpty) {
      for (final world in trackWorlds) {
        final worldLessons = world.chapters
            .expand((c) => c.units)
            .expand((u) => u.lessons)
            .toList();
        for (final lesson in worldLessons) {
          if (!completedIds.contains(lesson.id)) {
            return Recommendation(
              activityId: lesson.id,
              activityType: _mapLessonType(lesson.id),
              worldId: world.id,
              skill: _mapLessonSkill(lesson.id),
              reason: 'Next sequential milestone in child curriculum track.',
              childFriendlyPrompt: 'Ready for the next adventure? Let\'s go! 🚀',
              priority: RecommendationPriority.curriculumProgression,
              estimatedDurationMinutes: 4,
              difficultyLevel: _mapAgeDifficulty(child.ageGroup),
              valueConnectionId: lesson.connectedValueId,
              title: lesson.title,
              subtitle: lesson.subtitle,
              routePath: _mapRoutePath(lesson.id),
            );
          }
        }
      }
    }

    final nextLesson = availableActivities.firstWhere(
      (l) => !completedIds.contains(l.id),
      orElse: () => availableActivities.isNotEmpty ? availableActivities.last : _fallbackLesson,
    );

    if (!completedIds.contains(nextLesson.id)) {
      return Recommendation(
        activityId: nextLesson.id,
        activityType: _mapLessonType(nextLesson.id),
        worldId: currentWorld.id,
        skill: _mapLessonSkill(nextLesson.id),
        reason: 'Next sequential milestone in current adventure trail.',
        childFriendlyPrompt: 'Ready for the next adventure? Let\'s go! 🚀',
        priority: RecommendationPriority.curriculumProgression,
        estimatedDurationMinutes: 4,
        difficultyLevel: _mapAgeDifficulty(child.ageGroup),
        valueConnectionId: nextLesson.connectedValueId,
        title: nextLesson.title,
        subtitle: nextLesson.subtitle,
        routePath: _mapRoutePath(nextLesson.id),
      );
    }

    // ----------------------------------------------------
    // PRIORITY 6: Balanced Multi-Skill Practice
    // ----------------------------------------------------
    return const Recommendation(
      activityId: 'activity_speaking_practice',
      activityType: 'speaking',
      worldId: 'world_animal',
      skill: SkillType.speaking,
      reason: 'Encouraging spoken English confidence with Pip.',
      childFriendlyPrompt: 'Talk with Pip! Let\'s say some fun phrases aloud! 🎙️',
      priority: RecommendationPriority.balancedPractice,
      estimatedDurationMinutes: 3,
      difficultyLevel: 2,
      title: 'Speaking Lab with Pip 🎙️',
      subtitle: 'Practice clear pronunciation',
      routePath: RouteNames.speakingPractice,
    );
  }

  static Recommendation _buildRecommendationForWeakContent(ContentMastery weakItem, World world) {
    if (weakItem.contentId.contains('elephant') || weakItem.contentId.contains('lion')) {
      return const Recommendation(
        activityId: 'activity_animal_hunt',
        activityType: 'game',
        worldId: 'world_animal',
        skill: SkillType.vocabulary,
        reason: 'Elephant & safari animals need extra visual reinforcement.',
        childFriendlyPrompt: 'Let\'s visit our animal friends again in the Animal Hunt! 🦁',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 4,
        difficultyLevel: 1,
        isReview: true,
        title: 'Animal Hunt 🔍',
        subtitle: 'Find animal friends',
        routePath: RouteNames.animalHunt,
      );
    } else if (weakItem.contentId.contains('is_are')) {
      return const Recommendation(
        activityId: 'activity_grammar_is_are',
        activityType: 'grammar',
        worldId: 'world_animal',
        skill: SkillType.grammar,
        reason: 'Is vs Are agreement practice recommended.',
        childFriendlyPrompt: 'Let\'s play the Is vs Are word game! ⚖️',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 4,
        difficultyLevel: 2,
        isReview: true,
        title: 'Grammar: Is vs Are ⚖️',
        subtitle: 'Practice singular & plural',
        routePath: RouteNames.isAreQuiz,
      );
    } else if (weakItem.contentId.contains('room') || weakItem.contentId.contains('table') || weakItem.contentId.contains('bed')) {
      return const Recommendation(
        activityId: 'activity_home_hunt',
        activityType: 'game',
        worldId: 'world_home',
        skill: SkillType.vocabulary,
        reason: 'Household furniture and rooms reinforcement recommended.',
        childFriendlyPrompt: 'Let\'s explore our cozy home in Home Hunt! 🏡',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 4,
        difficultyLevel: 1,
        isReview: true,
        title: 'Home Hunt 🔍',
        subtitle: 'Find household objects',
        routePath: RouteNames.homeHunt,
      );
    } else if (weakItem.contentId.contains('this_is_my')) {
      return const Recommendation(
        activityId: 'activity_grammar_my_your',
        activityType: 'grammar',
        worldId: 'world_home',
        skill: SkillType.grammar,
        reason: 'Possessive grammar "This is my..." practice recommended.',
        childFriendlyPrompt: 'Let\'s practice "This is my room" together! ✍️',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 4,
        difficultyLevel: 2,
        isReview: true,
        title: 'Grammar: "This is my..." ✍️',
        subtitle: 'Learn possessive sentences',
        routePath: RouteNames.myYourGrammar,
      );
    } else if (weakItem.contentId.contains('pencil') || weakItem.contentId.contains('desk') || weakItem.contentId.contains('school')) {
      return const Recommendation(
        activityId: 'activity_classroom_hunt',
        activityType: 'game',
        worldId: 'world_school',
        skill: SkillType.vocabulary,
        reason: 'School and classroom tools reinforcement recommended.',
        childFriendlyPrompt: 'Let\'s explore the classroom in Classroom Hunt! 🏫',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 4,
        difficultyLevel: 1,
        isReview: true,
        title: 'Classroom Hunt 🔍',
        subtitle: 'Find learning tools',
        routePath: RouteNames.classroomHunt,
      );
    } else if (weakItem.contentId.contains('plural')) {
      return const Recommendation(
        activityId: 'activity_grammar_plurals',
        activityType: 'grammar',
        worldId: 'world_school',
        skill: SkillType.grammar,
        reason: 'Countable plurals practice recommended.',
        childFriendlyPrompt: 'Let\'s practice counting plural items! 📚',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 4,
        difficultyLevel: 2,
        isReview: true,
        title: 'Grammar: Plural Countables ✍️',
        subtitle: 'Learn singular & plural',
        routePath: RouteNames.pluralsGrammar,
      );
    } else if (weakItem.skill == SkillType.manners || weakItem.contentId.contains('share')) {
      return const Recommendation(
        activityId: 'activity_food_sharing',
        activityType: 'game',
        worldId: 'world_food',
        skill: SkillType.manners,
        reason: 'Sharing and dining Sunnah reinforcement recommended.',
        childFriendlyPrompt: 'Let\'s practice sharing treats with friends! 🤝',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 4,
        difficultyLevel: 1,
        isReview: true,
        title: 'Share the Food 🤝',
        subtitle: 'Generosity & dining habits',
        routePath: RouteNames.foodSharing,
      );
    } else if (weakItem.contentId.contains('apple') || weakItem.contentId.contains('banana') || weakItem.contentId.contains('milk') || weakItem.contentId.contains('food')) {
      return const Recommendation(
        activityId: 'activity_food_hunt',
        activityType: 'game',
        worldId: 'world_food',
        skill: SkillType.vocabulary,
        reason: 'Fruit and food vocabulary reinforcement recommended.',
        childFriendlyPrompt: 'Let\'s find fresh snacks in Food Hunt! 🍎',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 4,
        difficultyLevel: 1,
        isReview: true,
        title: 'Food Hunt 🔍',
        subtitle: 'Find delicious fruits',
        routePath: RouteNames.foodHunt,
      );
    } else if (weakItem.contentId.contains('tree') || weakItem.contentId.contains('flower') || weakItem.contentId.contains('nature')) {
      return const Recommendation(
        activityId: 'activity_nature_hunt',
        activityType: 'game',
        worldId: 'world_nature',
        skill: SkillType.vocabulary,
        reason: 'Nature & outdoor elements reinforcement recommended.',
        childFriendlyPrompt: 'Let\'s explore green trees in Nature Hunt! 🌳',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 4,
        difficultyLevel: 1,
        isReview: true,
        title: 'Nature Hunt 🔍',
        subtitle: 'Find trees & flowers',
        routePath: RouteNames.natureHunt,
      );
    } else if (weakItem.contentId.contains('weather') || weakItem.contentId.contains('rain') || weakItem.contentId.contains('sun')) {
      return const Recommendation(
        activityId: 'activity_weather_listen',
        activityType: 'listening',
        worldId: 'world_nature',
        skill: SkillType.listening,
        reason: 'Weather sentences reinforcement recommended.',
        childFriendlyPrompt: 'Listen carefully to weather sounds with Pip! 🎧',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 4,
        difficultyLevel: 1,
        isReview: true,
        title: 'Weather Listen & Tap 🎧',
        subtitle: 'Listen to rain & sun',
        routePath: RouteNames.weatherListen,
      );
    } else if (weakItem.contentId.contains('there_is_are')) {
      return const Recommendation(
        activityId: 'activity_there_is_are',
        activityType: 'grammar',
        worldId: 'world_nature',
        skill: SkillType.grammar,
        reason: '"There is / There are" grammar reinforcement recommended.',
        childFriendlyPrompt: 'Let\'s practice There is and There are! ✍️',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 4,
        difficultyLevel: 2,
        isReview: true,
        title: 'Grammar: There is / are ✍️',
        subtitle: 'Learn singular & plural',
        routePath: RouteNames.thereIsAre,
      );
    }

    return const Recommendation(
      activityId: 'activity_spaced_review',
      activityType: 'review',
      worldId: 'world_animal',
      skill: SkillType.vocabulary,
      reason: 'Targeted vocabulary practice recommended.',
      childFriendlyPrompt: 'Let\'s practice these words together! 🌟',
      priority: RecommendationPriority.criticalWeakness,
      estimatedDurationMinutes: 3,
      isReview: true,
      title: 'Quick Practice 🌟',
      subtitle: 'Strengthen memory',
      routePath: RouteNames.adaptiveReview,
    );
  }

  static Recommendation _buildRecommendationForWeakSkill(SkillType skill, double score, World world) {
    switch (skill) {
      case SkillType.speaking:
        return Recommendation(
          activityId: world.id == 'world_nature' ? 'activity_talk_with_pip' : 'activity_speaking_practice',
          activityType: 'speaking',
          worldId: world.id,
          skill: SkillType.speaking,
          reason: 'Speaking accuracy is lower than listening comprehension.',
          childFriendlyPrompt: 'Talk with Pip! Let\'s practice speaking in a happy voice! 🎙️',
          priority: RecommendationPriority.weakSkill,
          estimatedDurationMinutes: 3,
          difficultyLevel: 1,
          title: world.id == 'world_nature' ? 'Talk with Pip 🦜' : 'Speaking Lab 🎙️',
          subtitle: 'Practice clear speaking',
          routePath: world.id == 'world_nature' ? RouteNames.talkWithPip : RouteNames.speakingPractice,
        );
      case SkillType.listening:
        return Recommendation(
          activityId: world.id == 'world_home' ? 'activity_listen_find_home' : 'activity_listen_tap',
          activityType: 'listening',
          worldId: world.id,
          skill: SkillType.listening,
          reason: 'Listening comprehension reinforcement recommended.',
          childFriendlyPrompt: 'Listen carefully with Pip and tap the right picture! 🎧',
          priority: RecommendationPriority.weakSkill,
          estimatedDurationMinutes: 3,
          difficultyLevel: 1,
          title: 'Listen & Tap 🎧',
          subtitle: 'Sharpen your listening',
          routePath: world.id == 'world_home' ? RouteNames.listenAndFindHome : RouteNames.listenAndTap,
        );
      case SkillType.grammar:
        return Recommendation(
          activityId: world.id == 'world_home' ? 'activity_grammar_my_your' : 'activity_grammar_this_is',
          activityType: 'grammar',
          worldId: world.id,
          skill: SkillType.grammar,
          reason: 'Sentence structure building practice recommended.',
          childFriendlyPrompt: 'Let\'s build sentences together! ✍️',
          priority: RecommendationPriority.weakSkill,
          estimatedDurationMinutes: 4,
          difficultyLevel: 2,
          title: 'Grammar Explorer ✍️',
          subtitle: 'Build sentences',
          routePath: world.id == 'world_home' ? RouteNames.myYourGrammar : RouteNames.grammarThisIs,
        );
      default:
        return const Recommendation(
          activityId: 'activity_spaced_review',
          activityType: 'review',
          worldId: 'world_animal',
          skill: SkillType.vocabulary,
          reason: 'General reinforcement recommended.',
          childFriendlyPrompt: 'Let\'s practice together! 🌟',
          priority: RecommendationPriority.weakSkill,
          estimatedDurationMinutes: 3,
          title: 'Practice Session 🌟',
          subtitle: 'Skill practice',
          routePath: RouteNames.adaptiveReview,
        );
    }
  }

  static String _mapLessonType(String id) {
    if (id.contains('vocab')) return 'vocab';
    if (id.contains('hunt') || id.contains('match') || id.contains('sort') || id.contains('builder')) return 'game';
    if (id.contains('grammar') || id.contains('is_are')) return 'grammar';
    if (id.contains('story')) return 'story';
    if (id.contains('speak') || id.contains('listen')) return 'speaking';
    if (id.contains('challenge')) return 'challenge';
    return 'lesson';
  }

  static SkillType _mapLessonSkill(String id) {
    if (id.contains('grammar') || id.contains('is_are') || id.contains('builder')) return SkillType.grammar;
    if (id.contains('listen')) return SkillType.listening;
    if (id.contains('speak')) return SkillType.speaking;
    if (id.contains('story')) return SkillType.reading;
    if (id.contains('value') || id.contains('sort')) return SkillType.manners;
    return SkillType.vocabulary;
  }

  static int _mapAgeDifficulty(AgeGroupType ageGroup) {
    switch (ageGroup) {
      case AgeGroupType.toddler:
        return 1;
      case AgeGroupType.earlyLearner:
        return 2;
      case AgeGroupType.youngReader:
        return 3;
      case AgeGroupType.masterLearner:
        return 4;
    }
  }

  static String _mapRoutePath(String id) {
    if (id.startsWith('t1_') ||
        id.startsWith('t2_') ||
        id.startsWith('t3_') ||
        id.startsWith('t4_') ||
        id.startsWith('t5_') ||
        id.endsWith('_vocab') ||
        id == 'activity_animal_vocab' ||
        id == 'activity_animal_hunt' ||
        id == 'activity_listen_tap') {
      return RouteNames.interactiveSessionPath(id);
    }
    switch (id) {
      case 'activity_animal_vocab':
        return RouteNames.interactiveSessionPath(id);
      case 'activity_animal_hunt':
        return RouteNames.interactiveSessionPath(id);
      case 'activity_listen_tap':
        return RouteNames.interactiveSessionPath(id);
      case 'activity_word_match':
        return RouteNames.wordMatch;
      case 'activity_grammar_this_is':
        return RouteNames.grammarThisIs;
      case 'activity_grammar_is_are':
        return RouteNames.isAreQuiz;
      case 'activity_value_moment':
        return RouteNames.valueMoment;
      case 'activity_story_read':
        return RouteNames.storyPath('story_animal_park');
      case 'activity_listen_speak':
        return RouteNames.listeningPractice;
      case 'activity_final_challenge':
        return RouteNames.worldChallenge;
      case 'activity_home_vocab':
        return RouteNames.homeVocabulary;
      case 'activity_home_hunt':
        return RouteNames.homeHunt;
      case 'activity_family_vocab':
        return RouteNames.familyVocabulary;
      case 'activity_listen_find_home':
        return RouteNames.listenAndFindHome;
      case 'activity_grammar_my_your':
        return RouteNames.myYourGrammar;
      case 'activity_sentence_builder_home':
        return RouteNames.sentenceBuilder;
      case 'activity_cleanliness_sort':
        return RouteNames.cleanlinessSort;
      case 'activity_story_home':
        return RouteNames.storyPath('story_helping_home');
      case 'activity_speaking_home':
        return RouteNames.speakingPractice;
      case 'activity_home_challenge':
        return RouteNames.homeChallenge;
      case 'activity_school_vocab':
        return RouteNames.schoolVocabulary;
      case 'activity_classroom_hunt':
        return RouteNames.classroomHunt;
      case 'activity_listen_find_school':
        return RouteNames.listenAndFindSchool;
      case 'activity_listen_and_do_school':
        return RouteNames.listenAndDoSchool;
      case 'activity_teacher_friend_vocab':
        return RouteNames.teacherFriendVocabulary;
      case 'activity_school_actions':
        return RouteNames.schoolActions;
      case 'activity_grammar_plurals':
        return RouteNames.pluralsGrammar;
      case 'activity_polite_requests':
        return RouteNames.politeRequests;
      case 'activity_honesty_challenge':
        return RouteNames.honestyChallenge;
      case 'activity_story_school':
        return RouteNames.storyPath('story_honest_pencil');
      case 'activity_story_quiz_school':
        return RouteNames.storyQuizSchool;
      case 'activity_speaking_school':
        return RouteNames.speakingPractice;
      case 'activity_school_challenge':
        return RouteNames.schoolChallenge;
      default:
        return RouteNames.vocabularyDiscovery;
    }
  }

  /// Deterministic rule evaluating whether AI conversation is appropriate for the target learning need.
  static bool shouldRecommendAi({
    required SkillType skill,
    required double masteryScore,
    required bool parentAiEnabled,
    bool quotaExceeded = false,
  }) {
    if (!parentAiEnabled || quotaExceeded) return false;
    // Prefer AI for speaking practice and contextual review when mastery is between 0.35 and 0.65
    // If child is severely struggling (<0.30), prefer interactive deterministic games.
    if (skill == SkillType.speaking) return true;
    if (masteryScore >= 0.35 && masteryScore < 0.65) return true;
    return false;
  }

  /// Builds a dedicated ReviewTalk AI recommendation for detected weakness.
  static Recommendation buildReviewTalkRecommendation({
    required String targetTopic,
    required World world,
    required String childFriendlyPrompt,
  }) {
    return Recommendation(
      activityId: 'activity_talk_with_pip',
      activityType: 'speaking',
      worldId: world.id,
      skill: SkillType.speaking,
      reason: 'Targeted Review Talk recommended for "$targetTopic".',
      childFriendlyPrompt: childFriendlyPrompt,
      priority: RecommendationPriority.criticalWeakness,
      estimatedDurationMinutes: 3,
      difficultyLevel: 2,
      isReview: true,
      title: 'Review with Pip 🦜',
      subtitle: 'Targeted speaking review',
      routePath: RouteNames.talkWithPip,
    );
  }

  static String _mapCategoryToRoute(ActivityCategory category, String fallbackLessonId, String worldId) {
    switch (category) {
      case ActivityCategory.discovery:
        return RouteNames.vocabularyDiscovery;
      case ActivityCategory.animalHunt:
        return RouteNames.animalHunt;
      case ActivityCategory.story:
        return RouteNames.storyPath('story_animal_park');
      case ActivityCategory.conversation:
      case ActivityCategory.speaking:
        return RouteNames.talkWithPip;
      default:
        return _mapRoutePath(fallbackLessonId);
    }
  }

  /// Generates an explainable, pedagogical [LearningRecommendation] for a child explorer.
  static LearningRecommendation getAdaptiveRecommendation({
    required ChildProfile child,
    required List<VocabularyMastery> vocabularyMasteries,
    required World currentWorld,
    required List<Lesson> availableActivities,
    List<ActivityCategory> recentActivities = const [],
    int consecutiveErrors = 0,
    int hintUsageInSession = 0,
    int micFailureCount = 0,
    required DateTime now,
    DifficultyEngine difficultyEngine = const DifficultyEngine(),
    ConfidenceGuardian confidenceGuardian = const ConfidenceGuardian(),
    SpacedReviewScheduler reviewScheduler = const SpacedReviewScheduler(),
    ActivityVarietyEngine varietyEngine = const ActivityVarietyEngine(),
  }) {
    final difficulty = difficultyEngine.resolveDifficulty(
      childAge: child.age,
      recentMasteries: vocabularyMasteries,
      consecutiveErrors: consecutiveErrors,
    );

    // 1. Confidence Protection Check
    final confidenceIntervention = confidenceGuardian.assessConfidence(
      consecutiveErrors: consecutiveErrors,
      hintUsageInSession: hintUsageInSession,
      micFailureCount: micFailureCount,
      masteries: vocabularyMasteries,
    );

    if (confidenceIntervention.type == ConfidenceInterventionType.provideEasyWin) {
      final easyWord = confidenceIntervention.recommendedVocabularyId ?? 'vocab_elephant';
      return LearningRecommendation(
        childId: child.id,
        type: LearningRecommendationType.confidenceActivity,
        targetVocabularyIds: [easyWord],
        worldId: currentWorld.id,
        activityId: 'activity_animal_hunt',
        internalReason: confidenceIntervention.reason,
        childFriendlyPrompt: confidenceIntervention.pipEncouragingDialogue,
        priorityScore: 95,
        difficultyTier: AdaptiveDifficultyTier.support,
        generatedAt: now,
        routePath: RouteNames.animalHunt,
        title: 'Fun Play with Pip 🐾',
        subtitle: 'Gentle confidence builder',
      );
    }

    if (confidenceIntervention.type == ConfidenceInterventionType.switchActivityType) {
      return LearningRecommendation(
        childId: child.id,
        type: LearningRecommendationType.readStory,
        worldId: currentWorld.id,
        activityId: 'story_animal_park',
        internalReason: confidenceIntervention.reason,
        childFriendlyPrompt: confidenceIntervention.pipEncouragingDialogue,
        priorityScore: 90,
        difficultyTier: AdaptiveDifficultyTier.support,
        generatedAt: now,
        routePath: RouteNames.storyPath('story_animal_park'),
        title: 'Story Time Adventure 📖',
        subtitle: 'Listen and relax with a story',
      );
    }

    // 2. Overdue Spaced Repetition Review
    final dueReviews = reviewScheduler.getDueForReview(vocabularyMasteries, now);
    if (dueReviews.isNotEmpty) {
      final target = dueReviews.first;
      final targetIds = dueReviews.take(3).map((m) => m.vocabularyId).toList();
      return LearningRecommendation(
        childId: child.id,
        type: LearningRecommendationType.reviewDueVocabulary,
        targetVocabularyIds: targetIds,
        worldId: currentWorld.id,
        activityId: 'activity_animal_hunt',
        internalReason: 'Vocabulary "${target.word}" is due for spaced memory consolidation.',
        childFriendlyPrompt: 'Pip says: "Some animal friends want to play with us again! 🐘🦁"',
        priorityScore: 85,
        difficultyTier: difficulty,
        generatedAt: now,
        routePath: RouteNames.animalHunt,
        title: 'Memory Refresh 🧠',
        subtitle: 'Review ${target.word} and friends',
      );
    }

    // 3. Reinforce Weak / Struggling Vocabulary
    final struggling = reviewScheduler.getStruggling(vocabularyMasteries);
    if (struggling.isNotEmpty) {
      final weakWord = struggling.first;
      return LearningRecommendation(
        childId: child.id,
        type: LearningRecommendationType.reviewWeakVocabulary,
        targetVocabularyIds: [weakWord.vocabularyId],
        worldId: currentWorld.id,
        activityId: 'activity_animal_hunt',
        internalReason: 'Child had repeated mistakes with "${weakWord.word}". Prescribing gentle reinforcement.',
        childFriendlyPrompt: 'Pip says: "Let\'s find ${weakWord.word} together! I\'ll give you a hint! ✨"',
        priorityScore: 80,
        difficultyTier: AdaptiveDifficultyTier.easy,
        generatedAt: now,
        routePath: RouteNames.animalHunt,
        title: 'Practice with ${weakWord.word} 🐾',
        subtitle: 'Reinforce tricky words',
      );
    }

    // 4. Curriculum Progression with Activity Variety Rotation
    final completedIds = child.completedLessonIds;
    final nextLesson = availableActivities.firstWhere(
      (l) => !completedIds.contains(l.id),
      orElse: () => availableActivities.isNotEmpty ? availableActivities.last : _fallbackLesson,
    );

    final candidateCategory = ActivityCategoryExtension.fromActivityId(nextLesson.id);
    final targetCategory = varietyEngine.isCategoryEligible(candidateCategory, recentActivities)
        ? candidateCategory
        : varietyEngine.suggestComplementaryCategory(recentActivities);

    final mappedRoute = _mapCategoryToRoute(targetCategory, nextLesson.id, currentWorld.id);

    return LearningRecommendation(
      childId: child.id,
      type: LearningRecommendationType.continueWorld,
      targetVocabularyIds: nextLesson.targetVocabularyIds,
      worldId: currentWorld.id,
      lessonId: nextLesson.id,
      activityId: nextLesson.id,
      internalReason: 'Sequential curriculum progression in ${currentWorld.title}. Category selected: ${targetCategory.name}.',
      childFriendlyPrompt: 'Ready for our next adventure? Let\'s go! 🚀',
      priorityScore: 60,
      difficultyTier: difficulty,
      generatedAt: now,
      routePath: mappedRoute,
      title: nextLesson.title,
      subtitle: nextLesson.subtitle,
    );
  }

  /// Generates a curriculum-aware recommendation uniting Phase 12-13 adaptive decisions
  /// with Phase 14 progressive communicative curriculum hierarchy.
  static LearningRecommendation getCurriculumAwareRecommendation({
    required ChildProfile child,
    required List<VocabularyMastery> vocabularyMasteries,
    required World currentWorld,
    required List<Lesson> availableActivities,
    required ICurriculumRepository curriculumRepository,
    List<ActivityCategory> recentActivities = const [],
    int consecutiveErrors = 0,
    int hintUsageInSession = 0,
    int micFailureCount = 0,
    required DateTime now,
    DifficultyEngine difficultyEngine = const DifficultyEngine(),
    ConfidenceGuardian confidenceGuardian = const ConfidenceGuardian(),
    SpacedReviewScheduler reviewScheduler = const SpacedReviewScheduler(),
    ActivityVarietyEngine varietyEngine = const ActivityVarietyEngine(),
    CurriculumLevelProgressionEngine levelProgressionEngine = const CurriculumLevelProgressionEngine(),
  }) {
    // 1. First delegate to ConfidenceGuardian & SpacedReviewScheduler
    final baseRecommendation = getAdaptiveRecommendation(
      child: child,
      vocabularyMasteries: vocabularyMasteries,
      currentWorld: currentWorld,
      availableActivities: availableActivities,
      recentActivities: recentActivities,
      consecutiveErrors: consecutiveErrors,
      hintUsageInSession: hintUsageInSession,
      micFailureCount: micFailureCount,
      now: now,
      difficultyEngine: difficultyEngine,
      confidenceGuardian: confidenceGuardian,
      reviewScheduler: reviewScheduler,
      varietyEngine: varietyEngine,
    );

    // If confidence intervention or overdue/weak review is needed, honor it immediately
    if (baseRecommendation.type == LearningRecommendationType.confidenceActivity ||
        baseRecommendation.type == LearningRecommendationType.readStory ||
        baseRecommendation.type == LearningRecommendationType.reviewDueVocabulary ||
        baseRecommendation.type == LearningRecommendationType.reviewWeakVocabulary) {
      return baseRecommendation;
    }

    // 2. Evaluate Curriculum Level Progression
    final currentLevel = curriculumRepository.getLevelById(child.currentCurriculumLevelId) ??
        curriculumRepository.getAllLevels().first;
    final nextLevel = curriculumRepository.getAllLevels().firstWhere(
          (l) => l.order == currentLevel.order + 1,
          orElse: () => currentLevel,
        );
    final levelConcepts = currentLevel.coreConceptIds
        .map(curriculumRepository.getConceptById)
        .whereType<LearningConcept>()
        .toList();
    final levelCanDos = curriculumRepository
        .getAllCanDoStatements()
        .where((c) => c.levelOrder == currentLevel.order)
        .toList();

    final progressionEvaluation = levelProgressionEngine.evaluateLevelReadiness(
      currentLevel: currentLevel,
      nextLevel: nextLevel == currentLevel ? null : nextLevel,
      levelConcepts: levelConcepts,
      masteries: vocabularyMasteries,
      levelCanDoStatements: levelCanDos,
    );

    final difficulty = difficultyEngine.resolveDifficulty(
      childAge: child.age,
      recentMasteries: vocabularyMasteries,
      consecutiveErrors: consecutiveErrors,
    );

    if (progressionEvaluation.isReadyToAdvance) {
      return LearningRecommendation(
        childId: child.id,
        type: LearningRecommendationType.continueWorld,
        targetVocabularyIds: const [],
        worldId: currentWorld.id,
        activityId: 'activity_level_mission',
        internalReason: 'Child has demonstrated mastery for ${currentLevel.title}. Ready for capstone challenge!',
        childFriendlyPrompt: 'MashaAllah! You are ready for the ${currentLevel.childFriendlyTitle} celebration! 🌟',
        priorityScore: 88,
        difficultyTier: difficulty,
        generatedAt: now,
        routePath: RouteNames.worldDetailPath(currentWorld.id),
        title: 'Level Celebration 🏆',
        subtitle: 'Complete your ${currentLevel.title} mission!',
      );
    }

    // 3. Find Next Curriculum Concept in Current Level
    final masteryMap = {for (final m in vocabularyMasteries) m.vocabularyId: m};
    final unmasteredConcepts = currentLevel.coreConceptIds
        .where((cId) => !(masteryMap[cId]?.isMastered ?? false))
        .toList();

    if (unmasteredConcepts.isNotEmpty) {
      final nextConceptId = unmasteredConcepts.first;
      final concept = curriculumRepository.getConceptById(nextConceptId);
      final conceptText = concept?.canonicalText ?? nextConceptId;

      return LearningRecommendation(
        childId: child.id,
        type: LearningRecommendationType.continueWorld,
        targetVocabularyIds: [nextConceptId],
        worldId: currentWorld.id,
        activityId: 'activity_discovery',
        internalReason: 'Curriculum objective: introduce/reinforce concept "$conceptText" in ${currentLevel.title}.',
        childFriendlyPrompt: 'Let\'s learn a new English word with Pip: "$conceptText"! ✨',
        priorityScore: 75,
        difficultyTier: difficulty,
        generatedAt: now,
        routePath: RouteNames.vocabularyDiscovery,
        title: 'Learn "$conceptText" 🌟',
        subtitle: currentLevel.childFriendlyTitle,
      );
    }

    // Default fallback to base recommendation
    return baseRecommendation;
  }

  static const Lesson _fallbackLesson = Lesson(
    id: 'activity_animal_vocab',
    unitId: 'unit_animal_adventure',
    title: 'Animal Words Discovery',
    subtitle: 'Learn elephant, lion, cat, bird',
    orderIndex: 1,
    targetVocabularyIds: ['vocab_elephant', 'vocab_cat'],
    metadata: ContentMetadata(
      learningObjective: 'Animal vocabulary.',
      worldId: 'world_animal',
      status: PublishedStatus.published,
    ),
    activities: [],
    rewardXp: 20,
    rewardCoins: 10,
    rewardStars: 3,
    isUnlocked: true,
  );
}
