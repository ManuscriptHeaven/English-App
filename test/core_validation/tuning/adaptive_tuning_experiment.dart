import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session_orchestrator.dart';
import '../simulation/deterministic_clock.dart';
import '../simulation/simulated_learner.dart';
import '../simulation/simulation_metrics.dart';
import '../simulation/learning_simulation_harness.dart';

/// Experiment candidate definition for Concern A: Assisted Learner Downward Drift.
class ConcernACandidate {
  final String id;
  final String name;
  final String description;
  final MasteryScoringConfig config;

  const ConcernACandidate({
    required this.id,
    required this.name,
    required this.description,
    required this.config,
  });
}

/// Scenario evaluation result for Concern A.
class ConcernAScenarioResult {
  final String scenarioName;
  final double initialScore;
  final double finalScore;
  final double scoreDelta;
  final VocabularyLearningState finalState;
  final List<double> trajectory;

  const ConcernAScenarioResult({
    required this.scenarioName,
    required this.initialScore,
    required this.finalScore,
    required this.scoreDelta,
    required this.finalState,
    required this.trajectory,
  });
}

/// Full simulation summary comparing candidate configurations.
class CandidateSimulationSummary {
  final String candidateId;
  final String candidateName;
  final Map<String, ConcernAScenarioResult> scenarioResults;
  final Map<String, SimulationMetrics> longitudinalMetrics;

  const CandidateSimulationSummary({
    required this.candidateId,
    required this.candidateName,
    required this.scenarioResults,
    required this.longitudinalMetrics,
  });
}

/// Headless experiment framework for evaluating adaptive engine tuning candidates.
class AdaptiveTuningExperiment {
  final baseTime = DateTime(2026, 9, 10, 8, 0, 0);

  /// Standard candidates for Concern A.
  List<ConcernACandidate> get concernACandidates => [
    const ConcernACandidate(
      id: 'baseline',
      name: 'Baseline Control',
      description: 'Production: assistedGain=0.05, errorPenalty=0.12, hintPenaltyOnError=0.04 (total 0.16 on assisted error)',
      config: MasteryScoringConfig(
        assistedErrorPenalty: null,
        applyHintPenaltyOnError: true,
        returneeGraceDaysThreshold: 0,
        returneeGraceErrorDampening: 1.0,
      ),
    ),
    const ConcernACandidate(
      id: 'candidate_a',
      name: 'Candidate A: Moderate Error Reduction',
      description: 'assistedGain=0.05, base errorPenalty reduced to 0.09',
      config: MasteryScoringConfig(
        errorPenalty: 0.09,
        assistedErrorPenalty: null,
        applyHintPenaltyOnError: true,
        returneeGraceDaysThreshold: 0,
      ),
    ),
    const ConcernACandidate(
      id: 'candidate_b',
      name: 'Candidate B: Increased Assisted Gain',
      description: 'assistedGain increased to 0.08, errorPenalty unchanged at 0.12',
      config: MasteryScoringConfig(
        assistedRecallGain: 0.08,
        assistedErrorPenalty: null,
        applyHintPenaltyOnError: true,
        returneeGraceDaysThreshold: 0,
      ),
    ),
    const ConcernACandidate(
      id: 'candidate_c',
      name: 'Candidate C: Context-Aware Assisted Error (0.06)',
      description: 'assistedGain=0.05, assistedErrorPenalty=0.06, no extra hint penalty on error',
      config: MasteryScoringConfig(
        assistedErrorPenalty: 0.06,
        applyHintPenaltyOnError: false,
        returneeGraceDaysThreshold: 0,
      ),
    ),
    const ConcernACandidate(
      id: 'candidate_d',
      name: 'Candidate D: Asymmetric First Error Softening',
      description: 'assistedGain=0.05, firstErrorPenalty=0.08, retains consecutiveErrorMultiplier=1.3',
      config: MasteryScoringConfig(
        firstErrorPenalty: 0.08,
        assistedErrorPenalty: null,
        applyHintPenaltyOnError: true,
        returneeGraceDaysThreshold: 0,
      ),
    ),
    const ConcernACandidate(
      id: 'candidate_e',
      name: 'Candidate E: Balanced Composite',
      description: 'assistedGain=0.07, errorPenalty=0.10, assistedErrorPenalty=0.07, no extra hint penalty on error',
      config: MasteryScoringConfig(
        assistedRecallGain: 0.07,
        errorPenalty: 0.10,
        assistedErrorPenalty: 0.07,
        applyHintPenaltyOnError: false,
        returneeGraceDaysThreshold: 0,
      ),
    ),
  ];

  /// Runs Scenarios 1 to 5 for a single Concern A candidate.
  Map<String, ConcernAScenarioResult> evaluateConcernAScenarios(ConcernACandidate candidate) {
    final engine = MasteryEngine(config: candidate.config);
    final results = <String, ConcernAScenarioResult>{};

    // Scenario 1: 50% accuracy, high hint usage (10 interactions, 5 correct assisted, 5 incorrect assisted)
    results['Scenario 1 (50% Acc, High Hint)'] = _runSequenceScenario(
      engine: engine,
      scenarioName: 'Scenario 1 (50% Acc, High Hint)',
      initialScore: 0.30,
      steps: List.generate(10, (i) => _Step(isCorrect: i % 2 == 0, usedHint: true, isIndependent: false)),
    );

    // Scenario 2: 60% accuracy, moderate/high hint usage (10 interactions, 6 correct [4 assisted, 2 indep], 4 incorrect)
    results['Scenario 2 (60% Acc, Mod Hint)'] = _runSequenceScenario(
      engine: engine,
      scenarioName: 'Scenario 2 (60% Acc, Mod Hint)',
      initialScore: 0.30,
      steps: [
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),
        const _Step(isCorrect: false, usedHint: true, isIndependent: false),
        const _Step(isCorrect: true, usedHint: false, isIndependent: true),
        const _Step(isCorrect: false, usedHint: false, isIndependent: false),
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),
        const _Step(isCorrect: true, usedHint: false, isIndependent: true),
        const _Step(isCorrect: false, usedHint: true, isIndependent: false),
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),
        const _Step(isCorrect: false, usedHint: false, isIndependent: false),
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),
      ],
    );

    // Scenario 3: 40% accuracy, high hint usage (10 interactions, 4 correct assisted, 6 incorrect assisted)
    results['Scenario 3 (40% Acc, High Hint)'] = _runSequenceScenario(
      engine: engine,
      scenarioName: 'Scenario 3 (40% Acc, High Hint)',
      initialScore: 0.30,
      steps: [
        const _Step(isCorrect: false, usedHint: true, isIndependent: false),
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),
        const _Step(isCorrect: false, usedHint: true, isIndependent: false),
        const _Step(isCorrect: false, usedHint: true, isIndependent: false),
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),
        const _Step(isCorrect: false, usedHint: true, isIndependent: false),
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),
        const _Step(isCorrect: false, usedHint: true, isIndependent: false),
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),
        const _Step(isCorrect: false, usedHint: true, isIndependent: false),
      ],
    );

    // Scenario 4: 70% accuracy, moderate hint usage
    results['Scenario 4 (70% Acc, Mod Hint)'] = _runSequenceScenario(
      engine: engine,
      scenarioName: 'Scenario 4 (70% Acc, Mod Hint)',
      initialScore: 0.30,
      steps: [
        const _Step(isCorrect: true, usedHint: false, isIndependent: true),
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),
        const _Step(isCorrect: false, usedHint: false, isIndependent: false),
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),
        const _Step(isCorrect: true, usedHint: false, isIndependent: true),
        const _Step(isCorrect: false, usedHint: true, isIndependent: false),
        const _Step(isCorrect: true, usedHint: false, isIndependent: true),
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),
        const _Step(isCorrect: false, usedHint: false, isIndependent: false),
        const _Step(isCorrect: true, usedHint: false, isIndependent: true),
      ],
    );

    // Scenario 5: Repeated mistakes followed by gradual improvement:
    // wrong, wrong, assisted correct, wrong, assisted correct, independent correct, independent correct, independent correct
    results['Scenario 5 (Mistakes -> Recovery)'] = _runSequenceScenario(
      engine: engine,
      scenarioName: 'Scenario 5 (Mistakes -> Recovery)',
      initialScore: 0.45,
      steps: [
        const _Step(isCorrect: false, usedHint: false, isIndependent: false), // wrong
        const _Step(isCorrect: false, usedHint: true, isIndependent: false),  // wrong
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),   // assisted correct
        const _Step(isCorrect: false, usedHint: true, isIndependent: false),  // wrong
        const _Step(isCorrect: true, usedHint: true, isIndependent: false),   // assisted correct
        const _Step(isCorrect: true, usedHint: false, isIndependent: true),   // indep correct
        const _Step(isCorrect: true, usedHint: false, isIndependent: true),   // indep correct
        const _Step(isCorrect: true, usedHint: false, isIndependent: true),   // indep correct
      ],
    );

    return results;
  }

  ConcernAScenarioResult _runSequenceScenario({
    required MasteryEngine engine,
    required String scenarioName,
    required double initialScore,
    required List<_Step> steps,
  }) {
    var mastery = VocabularyMastery(
      childId: 'child_test',
      vocabularyId: 'vocab_target',
      word: 'Target',
      exposureCount: 2,
      correctAttempts: 1,
      incorrectAttempts: 1,
      consecutiveCorrect: 0,
      consecutiveIncorrect: 0,
      lastSeenAt: baseTime,
      nextReviewAt: baseTime.add(const Duration(days: 1)),
      masteryScore: initialScore,
      confidenceLevel: 0.50,
      currentLearningState: VocabularyLearningState.learning,
    );

    final trajectory = <double>[mastery.masteryScore];

    for (int i = 0; i < steps.length; i++) {
      final s = steps[i];
      mastery = engine.recordAttempt(
        currentMastery: mastery,
        evidence: LearningEvidence(
          childId: 'child_test',
          vocabularyId: 'vocab_target',
          word: 'Target',
          isCorrect: s.isCorrect,
          usedHint: s.usedHint,
          isIndependentRecall: s.isIndependent,
          timestamp: baseTime.add(Duration(hours: i + 1)),
        ),
      );
      trajectory.add(mastery.masteryScore);
    }

    return ConcernAScenarioResult(
      scenarioName: scenarioName,
      initialScore: initialScore,
      finalScore: mastery.masteryScore,
      scoreDelta: double.parse((mastery.masteryScore - initialScore).toStringAsFixed(2)),
      finalState: mastery.currentLearningState,
      trajectory: trajectory,
    );
  }

  /// Runs full longitudinal simulation for a given candidate configuration across all 5 profiles.
  Future<Map<String, SimulationMetrics>> runLongitudinalSimulation({
    required MasteryScoringConfig config,
    ChallengePromotionStrategy challengeStrategy = ChallengePromotionStrategy.strictStreak,
  }) async {
    final engine = MasteryEngine(config: config);
    final results = <String, SimulationMetrics>{};

    // 1. Profile A: Brand-New (100 interactions)
    {
      final clock = DeterministicClock(baseTime);
      final harness = LearningSimulationHarness(
        clock: clock,
        masteryEngine: engine,
        orchestrator: LearningSessionOrchestrator(
          clock: () => clock.now,
          challengeStrategy: challengeStrategy,
        ),
      );
      final learner = SimulatedLearner.brandNew(
        id: 'child_new',
        name: 'AyaanNew',
        seed: 101,
      );
      results['new'] = await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 100,
      );
    }

    // 2. Profile B: Struggling (200 interactions)
    {
      final clock = DeterministicClock(baseTime);
      final harness = LearningSimulationHarness(
        clock: clock,
        masteryEngine: engine,
        orchestrator: LearningSessionOrchestrator(
          clock: () => clock.now,
          challengeStrategy: challengeStrategy,
        ),
      );
      final learner = SimulatedLearner.struggling(
        id: 'child_struggling',
        name: 'MaryamStruggling',
        seed: 202,
      );
      results['struggling'] = await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 200,
      );
    }

    // 3. Profile C: Average (300 interactions)
    {
      final clock = DeterministicClock(baseTime);
      final harness = LearningSimulationHarness(
        clock: clock,
        masteryEngine: engine,
        orchestrator: LearningSessionOrchestrator(
          clock: () => clock.now,
          challengeStrategy: challengeStrategy,
        ),
      );
      final learner = SimulatedLearner.average(
        id: 'child_average',
        name: 'ZaydAverage',
        seed: 303,
      );
      results['average'] = await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 300,
      );
    }

    // 4. Profile D: Fast (500 interactions)
    {
      final clock = DeterministicClock(baseTime);
      final harness = LearningSimulationHarness(
        clock: clock,
        masteryEngine: engine,
        orchestrator: LearningSessionOrchestrator(
          clock: () => clock.now,
          challengeStrategy: challengeStrategy,
        ),
      );
      final learner = SimulatedLearner.fast(
        id: 'child_fast',
        name: 'AyaanFast',
        seed: 404,
      );
      results['fast'] = await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 500,
      );
    }

    // 5. Profile E: Returning (100 interactions with 14d gap)
    {
      final clock = DeterministicClock(baseTime);
      final harness = LearningSimulationHarness(
        clock: clock,
        masteryEngine: engine,
        orchestrator: LearningSessionOrchestrator(
          clock: () => clock.now,
          challengeStrategy: challengeStrategy,
        ),
      );
      final learner = SimulatedLearner.returning(
        id: 'child_returning',
        name: 'ZaydReturning',
        seed: 505,
      );
      await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 20,
      );
      clock.advanceDays(14);
      results['returning'] = await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 80,
      );
    }

    return results;
  }
}

class _Step {
  final bool isCorrect;
  final bool usedHint;
  final bool isIndependent;

  const _Step({
    required this.isCorrect,
    required this.usedHint,
    required this.isIndependent,
  });
}
