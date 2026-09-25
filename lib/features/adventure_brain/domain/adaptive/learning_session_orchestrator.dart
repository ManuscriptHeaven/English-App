import 'dart:math' as math;
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/lesson.dart';
import 'confidence_guardian.dart';
import 'curriculum_graph.dart';
import 'curriculum_progression_engine.dart';
import 'difficulty_engine.dart';
import 'learning_session.dart';
import 'session_activity.dart';
import 'spaced_review_scheduler.dart';
import 'vocabulary_mastery.dart';

enum ChallengePromotionStrategy {
  /// Baseline: requires both high mastery and at least 3 calendar streak days.
  strictStreak,

  /// Performance override: high mastery AND either streak >= 3 OR recent accuracy >= 0.90 with >= 10 attempts.
  performanceOverride,

  /// Evidence composite: high mastery AND either streak >= 3 OR (>= 12 attempts, >= 10 independent recalls, hint rate <= 0.15).
  evidenceComposite,

  /// Two-session proof: high mastery AND either streak >= 3 OR (>= 12 attempts, >= 2 mastered words, hint rate <= 0.15).
  twoSessionProof,
}

/// Orchestrates complete, personalized learning sessions for children based on
/// developmental readiness, spaced review, confidence state, and curriculum graph.
class LearningSessionOrchestrator {
  final SpacedReviewScheduler reviewScheduler;
  final ConfidenceGuardian confidenceGuardian;
  final DifficultyEngine difficultyEngine;
  final CurriculumProgressionEngine progressionEngine;
  final ChallengePromotionStrategy challengeStrategy;
  final DateTime Function()? clock;

  const LearningSessionOrchestrator({
    this.reviewScheduler = const SpacedReviewScheduler(),
    this.confidenceGuardian = const ConfidenceGuardian(),
    this.difficultyEngine = const DifficultyEngine(),
    this.progressionEngine = const CurriculumProgressionEngine(),
    this.challengeStrategy = ChallengePromotionStrategy.evidenceComposite,
    this.clock,
  });

  /// Assembles an end-to-end pedagogical session for the child.
  LearningSession assembleSession({
    required ChildProfile child,
    required List<VocabularyMastery> masteries,
    required CurriculumGraph graph,
    required World currentWorld,
    List<Lesson> availableLessons = const [],
    int dailyScreenTimeLimitMinutes = 15,
    int consecutiveErrors = 0,
    int hintUsageInSession = 0,
    int micFailureCount = 0,
    DateTime? now,
  }) {
    final currentTime = now ?? (clock != null ? clock!() : DateTime.now());

    // 1. Evaluate confidence and emotional safety
    final confidenceDecision = confidenceGuardian.assessConfidence(
      consecutiveErrors: consecutiveErrors,
      hintUsageInSession: hintUsageInSession,
      micFailureCount: micFailureCount,
      masteries: masteries,
    );
    final needsConfidenceProtection =
        confidenceDecision.type != ConfidenceInterventionType.none;

    // 2. Determine session length category based on age, screen-time limit, and confidence
    final lengthCategory = _determineLengthCategory(
      childAge: child.age,
      screenTimeLimit: dailyScreenTimeLimitMinutes,
      needsProtection: needsConfidenceProtection,
    );

    // 3. Determine difficulty level and support level
    final avgMastery = masteries.isNotEmpty
        ? masteries.map((m) => m.masteryScore).reduce((a, b) => a + b) / masteries.length
        : 0.0;

    int difficultyLevel = 2;
    SupportLevel supportLevel = SupportLevel.guided;

    if (needsConfidenceProtection) {
      difficultyLevel = 1;
      supportLevel = SupportLevel.maximum;
    } else if (_isChallengeEligible(avgMastery: avgMastery, child: child, masteries: masteries)) {
      difficultyLevel = child.age >= 7 ? 4 : 3;
      supportLevel = SupportLevel.independent;
    } else if (avgMastery < 0.35 || child.age <= 4) {
      difficultyLevel = 1;
      supportLevel = SupportLevel.guided;
    }

    // 4. Select Target Vocabulary and Review Vocabulary
    final reviewQueue = reviewScheduler.getPrioritizedReviewQueue(masteries, currentTime);
    final dueReviews = reviewScheduler.getDueForReview(masteries, currentTime);
    final struggling = reviewScheduler.getStruggling(masteries);

    final reviewWords = <String>[];
    if (needsConfidenceProtection && confidenceDecision.recommendedVocabularyId != null) {
      reviewWords.add(confidenceDecision.recommendedVocabularyId!);
    } else if (struggling.isNotEmpty) {
      reviewWords.add(struggling.first.vocabularyId);
    } else if (dueReviews.isNotEmpty) {
      reviewWords.addAll(dueReviews.take(2).map((m) => m.vocabularyId));
    } else if (reviewQueue.isNotEmpty) {
      reviewWords.add(reviewQueue.first.vocabularyId);
    }

    final newCandidates = progressionEngine.getNextRecommendedConcepts(
      child: child,
      masteries: masteries,
      graph: graph,
      targetWorldId: currentWorld.id,
      limit: 2,
    );

    final targetWords = newCandidates.where((w) => !reviewWords.contains(w)).toList();
    final reinforcementWords = struggling.map((s) => s.vocabularyId).toList();

    // 5. Construct Activities Sequence
    final activities = _buildActivitySequence(
      lengthCategory: lengthCategory,
      currentWorld: currentWorld,
      targetWords: targetWords,
      reviewWords: reviewWords,
      difficultyLevel: difficultyLevel,
      supportLevel: supportLevel,
      needsConfidenceProtection: needsConfidenceProtection,
      graph: graph,
    );

    final totalMinutes = activities.fold<int>(
      0,
      (sum, act) => sum + act.estimatedDurationMinutes,
    );

    // Primary goal description
    final primaryGoal = targetWords.isNotEmpty
        ? 'Learn new words: ${_resolveWordNames(targetWords, graph)}'
        : (reviewWords.isNotEmpty
            ? 'Reinforce: ${_resolveWordNames(reviewWords, graph)}'
            : 'Explore ${currentWorld.title}');

    final secondaryGoals = <String>[
      if (reviewWords.isNotEmpty) 'Strengthen memory of ${_resolveWordNames(reviewWords, graph)}',
      if (needsConfidenceProtection) 'Gentle confidence building',
      'Interactive listening and comprehension',
    ];

    final sessionId = 'session_${child.id}_${currentTime.millisecondsSinceEpoch}';

    return LearningSession(
      sessionId: sessionId,
      childId: child.id,
      worldId: currentWorld.id,
      unitId: 'unit_1',
      primaryGoal: primaryGoal,
      secondaryGoals: secondaryGoals,
      targetVocabularyIds: targetWords,
      reviewVocabularyIds: reviewWords,
      reinforcementVocabularyIds: reinforcementWords,
      activities: activities,
      currentActivityIndex: 0,
      status: SessionStatus.planned,
      lengthCategory: lengthCategory,
      difficultyLevel: difficultyLevel,
      supportLevel: supportLevel,
      totalEstimatedMinutes: totalMinutes,
      confidenceProtectionApplied: needsConfidenceProtection,
      createdAt: currentTime,
    );
  }

  SessionLengthCategory _determineLengthCategory({
    required int childAge,
    required int screenTimeLimit,
    required bool needsProtection,
  }) {
    if (needsProtection || screenTimeLimit <= 8) {
      return SessionLengthCategory.micro;
    }
    if (childAge <= 4 || screenTimeLimit <= 12) {
      return SessionLengthCategory.short;
    }
    if (childAge <= 6 || screenTimeLimit <= 18) {
      return SessionLengthCategory.standard;
    }
    return SessionLengthCategory.extended;
  }

  List<SessionActivity> _buildActivitySequence({
    required SessionLengthCategory lengthCategory,
    required World currentWorld,
    required List<String> targetWords,
    required List<String> reviewWords,
    required int difficultyLevel,
    required SupportLevel supportLevel,
    required bool needsConfidenceProtection,
    required CurriculumGraph graph,
  }) {
    final activities = <SessionActivity>[];
    final worldId = currentWorld.id;

    // Helper to get friendly word names
    final focusWord = (targetWords.isNotEmpty ? targetWords.first : (reviewWords.isNotEmpty ? reviewWords.first : 'elephant'));
    final concept = graph.getConcept(focusWord);
    final focusWordLabel = concept?.word ?? 'friends';

    // Step 1: Warm-up Activity (Always present)
    activities.add(
      SessionActivity(
        activityId: 'act_warmup_${worldId}_1',
        title: 'Morning Warm-up',
        subtitle: 'Listen and spot $focusWordLabel',
        activityType: SessionActivityType.warmUp,
        worldId: worldId,
        targetVocabularyIds: reviewWords.isNotEmpty ? [reviewWords.first] : [focusWord],
        difficultyLevel: math.max(1, difficultyLevel - 1),
        supportLevel: needsConfidenceProtection ? SupportLevel.maximum : SupportLevel.guided,
        estimatedDurationMinutes: 3,
        pedagogicalIntent: 'Warm up listening and attention with familiar, encouraging visuals.',
        pipPrompt: "Let's warm up together! Can you hear the sounds? 🐾",
        routePath: '/activity/vocabulary',
      ),
    );

    // Step 2: Vocabulary Discovery / Review
    if (lengthCategory.maxActivities >= 2) {
      final isReviewMode = targetWords.isEmpty && reviewWords.isNotEmpty;
      activities.add(
        SessionActivity(
          activityId: isReviewMode ? 'act_review_${worldId}_2' : 'act_discovery_${worldId}_2',
          title: isReviewMode ? 'Memory Flash' : 'Word Discovery',
          subtitle: isReviewMode ? 'Remember familiar words' : 'Meet new friends',
          activityType: isReviewMode
              ? SessionActivityType.reviewChallenge
              : SessionActivityType.vocabularyDiscovery,
          worldId: worldId,
          targetVocabularyIds: isReviewMode ? reviewWords : targetWords,
          difficultyLevel: difficultyLevel,
          supportLevel: supportLevel,
          estimatedDurationMinutes: 3,
          pedagogicalIntent: isReviewMode
              ? 'Spaced retrieval of previously acquired vocabulary.'
              : 'Multi-sensory introduction of new target vocabulary.',
          pipPrompt: isReviewMode
              ? "You know these words! Let's show Pip how clever you are! ✨"
              : "Look what I found! Let's say hello! 🌟",
          routePath: '/activity/vocabulary',
        ),
      );
    }

    // Step 3: Active Interactive Practice Game
    if (lengthCategory.maxActivities >= 3) {
      activities.add(
        SessionActivity(
          activityId: 'act_game_${worldId}_3',
          title: 'Animal Hunt Adventure',
          subtitle: 'Find and tap the right animal',
          activityType: SessionActivityType.interactiveGame,
          worldId: worldId,
          targetVocabularyIds: [...targetWords, ...reviewWords].take(3).toList(),
          difficultyLevel: difficultyLevel,
          supportLevel: supportLevel,
          estimatedDurationMinutes: 4,
          pedagogicalIntent: 'Active retrieval game with low-stress recognition under play.',
          pipPrompt: "Let's play Animal Hunt! Can you spot the hidden friends? 🔍",
          routePath: '/activity/game',
        ),
      );
    }

    // Step 4: Contextual Reinforcement (Story Reader)
    if (lengthCategory.maxActivities >= 4) {
      activities.add(
        SessionActivity(
          activityId: 'act_story_${worldId}_4',
          title: 'Jungle Tale',
          subtitle: 'Read along with Pip',
          activityType: SessionActivityType.storyReader,
          worldId: worldId,
          targetVocabularyIds: [...targetWords, ...reviewWords].take(2).toList(),
          difficultyLevel: difficultyLevel,
          supportLevel: supportLevel,
          estimatedDurationMinutes: 5,
          pedagogicalIntent: 'Contextual sentence reinforcement inside an illustrated narrative.',
          pipPrompt: "Storytime! Let's hear what happens to our animal friends! 📖",
          routePath: '/activity/story',
        ),
      );
    }

    // Step 5: Conversation or Celebration Closure
    if (lengthCategory.maxActivities >= 5) {
      activities.add(
        SessionActivity(
          activityId: 'act_chat_${worldId}_5',
          title: 'Talk with Pip',
          subtitle: 'Tell Pip about your day',
          activityType: SessionActivityType.conversationPip,
          worldId: worldId,
          targetVocabularyIds: targetWords,
          difficultyLevel: difficultyLevel,
          supportLevel: SupportLevel.guided,
          estimatedDurationMinutes: 4,
          pedagogicalIntent: 'Spoken production and child-led conversation with AI companion.',
          pipPrompt: "Tell Pip all about what you learned today! 🎙️✨",
          routePath: '/activity/chat',
        ),
      );
    }

    return activities;
  }

  String _resolveWordNames(List<String> ids, CurriculumGraph graph) {
    return ids.map((id) {
      final c = graph.getConcept(id);
      return c?.word ?? id;
    }).join(', ');
  }

  bool _isChallengeEligible({
    required double avgMastery,
    required ChildProfile child,
    required List<VocabularyMastery> masteries,
  }) {
    if (avgMastery < 0.75) return false;

    switch (challengeStrategy) {
      case ChallengePromotionStrategy.strictStreak:
        return child.streakDays >= 3;

      case ChallengePromotionStrategy.performanceOverride:
        if (child.streakDays >= 3) return true;
        final totalAttempts = masteries.fold<int>(0, (sum, m) => sum + m.exposureCount);
        final totalCorrect = masteries.fold<int>(0, (sum, m) => sum + m.correctAttempts);
        final accuracy = totalAttempts > 0 ? totalCorrect / totalAttempts : 0.0;
        return totalAttempts >= 10 && accuracy >= 0.90;

      case ChallengePromotionStrategy.evidenceComposite:
        if (child.streakDays >= 3) return true;
        final totalAttempts = masteries.fold<int>(0, (sum, m) => sum + m.exposureCount);
        final totalHints = masteries.fold<int>(0, (sum, m) => sum + m.hintCount);
        final independentRecalls = masteries.fold<int>(
          0,
          (sum, m) => sum + math.max(0, m.correctAttempts - m.hintCount),
        );
        final hintRate = totalAttempts > 0 ? totalHints / totalAttempts : 0.0;
        return totalAttempts >= 12 && independentRecalls >= 10 && hintRate <= 0.15;

      case ChallengePromotionStrategy.twoSessionProof:
        if (child.streakDays >= 3) return true;
        final totalAttempts = masteries.fold<int>(0, (sum, m) => sum + m.exposureCount);
        final totalHints = masteries.fold<int>(0, (sum, m) => sum + m.hintCount);
        final masteredCount = masteries.where((m) => m.isMastered).length;
        final hintRate = totalAttempts > 0 ? totalHints / totalAttempts : 0.0;
        return totalAttempts >= 12 && masteredCount >= 2 && hintRate <= 0.15;
    }
  }
}
