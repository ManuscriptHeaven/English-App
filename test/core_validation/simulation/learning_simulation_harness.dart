import 'package:kids_english_adventure/features/adventure_brain/data/mock_learning_session_repository.dart';
import 'package:kids_english_adventure/features/adventure_brain/data/mock_vocabulary_mastery_repository.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/activity_variety_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/confidence_guardian.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_progression_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/difficulty_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session_orchestrator.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/session_activity.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/session_pip_guide.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/spaced_review_scheduler.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/adventure_brain/presentation/controllers/session_runtime_controller.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

import 'deterministic_clock.dart';
import 'simulated_learner.dart';
import 'simulation_metrics.dart';

/// Reusable headless testing harness running longitudinal learning simulations
/// against real production domain algorithms and services.
class LearningSimulationHarness {
  final DeterministicClock clock;
  final CurriculumGraph graph;
  final MasteryEngine masteryEngine;
  final SpacedReviewScheduler reviewScheduler;
  final DifficultyEngine difficultyEngine;
  final ConfidenceGuardian confidenceGuardian;
  final ActivityVarietyEngine varietyEngine;
  final CurriculumProgressionEngine progressionEngine;
  final LearningSessionOrchestrator orchestrator;
  final SessionPipGuide pipGuide;

  final MockLearningSessionRepository sessionRepo;
  final MockVocabularyMasteryRepository masteryRepo;
  final SessionRuntimeController controller;

  final World defaultWorld;

  LearningSimulationHarness._({
    required this.clock,
    required this.graph,
    required this.masteryRepo,
    required this.sessionRepo,
    required this.orchestrator,
    required this.controller,
  })  : masteryEngine = controller.masteryEngine,
        reviewScheduler = const SpacedReviewScheduler(),
        difficultyEngine = const DifficultyEngine(),
        confidenceGuardian = const ConfidenceGuardian(),
        varietyEngine = const ActivityVarietyEngine(),
        progressionEngine = const CurriculumProgressionEngine(),
        pipGuide = const SessionPipGuide(),
        defaultWorld = const World(
          id: 'world_animal',
          title: 'Animal Adventure',
          theme: 'animal',
          description: 'Animal World',
          bannerAssetPath: 'assets/banner.png',
          primaryColorHex: '0xFF66BB6A',
          orderIndex: 1,
          metadata: ContentMetadata(
            learningObjective: 'Animals',
            worldId: 'world_animal',
          ),
          chapters: [],
        );

  factory LearningSimulationHarness({
    DeterministicClock? clock,
    CurriculumGraph? graph,
    MockVocabularyMasteryRepository? masteryRepo,
    MockLearningSessionRepository? sessionRepo,
    MasteryEngine? masteryEngine,
    LearningSessionOrchestrator? orchestrator,
  }) {
    final effectiveClock = clock ?? DeterministicClock();
    final effectiveGraph = graph ?? CurriculumGraph.standard();
    final effectiveMasteryRepo = masteryRepo ?? MockVocabularyMasteryRepository();
    final effectiveSessionRepo = sessionRepo ?? MockLearningSessionRepository();
    final effectiveMasteryEngine = masteryEngine ?? const MasteryEngine();
    final effectiveOrchestrator = orchestrator ?? LearningSessionOrchestrator(clock: () => effectiveClock.now);
    final effectiveController = SessionRuntimeController(
      sessionRepository: effectiveSessionRepo,
      masteryRepository: effectiveMasteryRepo,
      masteryEngine: effectiveMasteryEngine,
      pipGuide: const SessionPipGuide(),
    );

    return LearningSimulationHarness._(
      clock: effectiveClock,
      graph: effectiveGraph,
      masteryRepo: effectiveMasteryRepo,
      sessionRepo: effectiveSessionRepo,
      orchestrator: effectiveOrchestrator,
      controller: effectiveController,
    );
  }

  /// Executes a single full learning session for the simulated learner.
  Future<LearningSession> runSession({
    required SimulatedLearner learner,
    required SimulationMetrics metrics,
    int consecutiveErrors = 0,
    int hintUsageInSession = 0,
    int micFailureCount = 0,
  }) async {
    final childId = learner.id;
    final currentMasteries = await masteryRepo.getMasteriesForChild(childId);

    // 1. Check confidence and emotional status
    final confidenceDecision = confidenceGuardian.assessConfidence(
      consecutiveErrors: consecutiveErrors,
      hintUsageInSession: hintUsageInSession,
      micFailureCount: micFailureCount,
      masteries: currentMasteries,
    );

    if (confidenceDecision.type != ConfidenceInterventionType.none) {
      metrics.recordConfidenceIntervention(
        trigger: 'Consecutive errors: $consecutiveErrors',
        intervention: confidenceDecision.type.name,
        timestamp: clock.now,
      );
    }

    // 2. Assemble adaptive session
    final session = orchestrator.assembleSession(
      child: learner.profile,
      masteries: currentMasteries,
      graph: graph,
      currentWorld: defaultWorld,
      consecutiveErrors: consecutiveErrors,
      hintUsageInSession: hintUsageInSession,
      micFailureCount: micFailureCount,
      now: clock.now,
    );

    metrics.recordDifficulty(
      tier: session.difficultyLevel <= 1
          ? 'support'
          : (session.difficultyLevel == 2
              ? 'easy'
              : (session.difficultyLevel == 3 ? 'standard' : 'challenge')),
      difficultyLevel: session.difficultyLevel,
      timestamp: clock.now,
    );

    await controller.startSession(session);

    // 3. Play through each activity
    bool abandoned = false;
    for (int i = 0; i < session.activities.length; i++) {
      if (learner.shouldAbandonSession()) {
        await controller.abandonSession();
        abandoned = true;
        break;
      }

      final activity = session.activities[i];
      clock.advanceMinutes(activity.estimatedDurationMinutes);

      // Focus concept for this activity
      final vocabId = activity.targetVocabularyIds.isNotEmpty
          ? activity.targetVocabularyIds.first
          : (session.reviewVocabularyIds.isNotEmpty ? session.reviewVocabularyIds.first : 'vocab_elephant');
      final concept = graph.getConcept(vocabId);
      final word = concept?.word ?? vocabId.replaceFirst('vocab_', '');

      final prevMastery = await masteryRepo.getMastery(childId: childId, vocabularyId: vocabId);
      final scoreBefore = prevMastery?.masteryScore ?? 0.0;
      final stateBefore = prevMastery?.currentLearningState ?? VocabularyLearningState.newWord;

      final isSpeaking = activity.activityType == SessionActivityType.conversationPip;
      final isStory = activity.activityType == SessionActivityType.storyReader;

      LearningEvidenceSource source = LearningEvidenceSource.unpromptedRecall;
      if (activity.activityType == SessionActivityType.warmUp) {
        source = LearningEvidenceSource.audioRecognition;
      } else if (isSpeaking) {
        source = LearningEvidenceSource.spokenProduction;
      } else if (isStory) {
        source = LearningEvidenceSource.storyContext;
      }

      final evidence = learner.simulateAttempt(
        vocabularyId: vocabId,
        word: word,
        timestamp: clock.now,
        source: source,
        isPronunciationContext: isSpeaking,
        isComprehensionContext: isStory,
      );

      metrics.totalAttempts++;
      if (evidence.isCorrect) metrics.correctAttempts++;
      if (evidence.usedHint) metrics.hintsUsed++;

      // Process attempt through controller (which marks activity done and updates masteries)
      await controller.completeActivity(
        activityId: activity.activityId,
        score: evidence.isCorrect ? 1.0 : 0.0,
        isCorrect: evidence.isCorrect,
        usedHint: evidence.usedHint,
        source: source,
        completedAt: clock.now,
      );

      final updatedMastery = await masteryRepo.getMastery(childId: childId, vocabularyId: vocabId);
      final scoreAfter = updatedMastery?.masteryScore ?? scoreBefore;
      final stateAfter = updatedMastery?.currentLearningState ?? stateBefore;

      metrics.recordTrajectory(
        MasteryTrajectoryStep(
          childId: childId,
          vocabularyId: vocabId,
          word: word,
          timestamp: clock.now,
          scoreBefore: scoreBefore,
          scoreAfter: scoreAfter,
          stateBefore: stateBefore,
          stateAfter: stateAfter,
          isCorrect: evidence.isCorrect,
          usedHint: evidence.usedHint,
          source: source.name,
          reason: '${activity.activityType.name} attempt',
        ),
      );
    }

    metrics.recordSession(
      lengthCategory: session.lengthCategory.name,
      activityTypeNames: session.activities.map((a) => a.activityType.name).toList(),
      newWords: session.targetVocabularyIds.length,
      reviewWords: session.reviewVocabularyIds.length,
      completed: !abandoned,
      abandoned: abandoned,
    );

    metrics.endTime = clock.now;
    return controller.currentState.session ?? session;
  }

  /// Simulates a target interaction count for a learner.
  Future<SimulationMetrics> simulateInteractions({
    required SimulatedLearner learner,
    required int targetInteractions,
    int hoursBetweenSessions = 12,
  }) async {
    final metrics = SimulationMetrics(
      profileName: learner.name,
      seed: learner.seed,
      startTime: clock.now,
    );

    int consecutiveErrors = 0;

    while (metrics.totalAttempts < targetInteractions) {
      await runSession(
        learner: learner,
        metrics: metrics,
        consecutiveErrors: consecutiveErrors,
      );

      // Track recent consecutive errors from last activity for struggle trigger simulation
      final lastStep = metrics.trajectorySteps.isNotEmpty ? metrics.trajectorySteps.last : null;
      if (lastStep != null && !lastStep.isCorrect) {
        consecutiveErrors++;
      } else {
        consecutiveErrors = 0;
      }

      clock.advanceHours(hoursBetweenSessions);
    }

    return metrics;
  }
}
