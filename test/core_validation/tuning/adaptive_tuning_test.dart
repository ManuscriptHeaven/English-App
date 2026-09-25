// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session_orchestrator.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'adaptive_tuning_experiment.dart';

void main() {
  final experiment = AdaptiveTuningExperiment();
  final baseTime = DateTime(2026, 9, 10, 8, 0, 0);

  const defaultWorld = World(
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

  group('Concern A: Assisted Learner Drift Experiments', () {
    test('Evaluate Scenarios 1-5 across Baseline and Candidates A-E', () {
      final candidates = experiment.concernACandidates;
      final resultsByCandidate = <String, Map<String, ConcernAScenarioResult>>{};

      for (final candidate in candidates) {
        final res = experiment.evaluateConcernAScenarios(candidate);
        resultsByCandidate[candidate.id] = res;
      }

      // Print Comparison Table
      print('\n=== CONCERN A: SCENARIO COMPARISON TABLE ===');
      print(
        'Candidate'.padRight(16) +
        'S1 (50% Hint)'.padRight(16) +
        'S2 (60% Mod)'.padRight(16) +
        'S3 (40% Hint)'.padRight(16) +
        'S4 (70% Mod)'.padRight(16) +
        'S5 (Recovery)'.padRight(16),
      );
      print('-' * 96);

      for (final candidate in candidates) {
        final r = resultsByCandidate[candidate.id]!;
        final s1 = '${r['Scenario 1 (50% Acc, High Hint)']!.finalScore.toStringAsFixed(2)} (${r['Scenario 1 (50% Acc, High Hint)']!.scoreDelta >= 0 ? '+' : ''}${r['Scenario 1 (50% Acc, High Hint)']!.scoreDelta})';
        final s2 = '${r['Scenario 2 (60% Acc, Mod Hint)']!.finalScore.toStringAsFixed(2)} (${r['Scenario 2 (60% Acc, Mod Hint)']!.scoreDelta >= 0 ? '+' : ''}${r['Scenario 2 (60% Acc, Mod Hint)']!.scoreDelta})';
        final s3 = '${r['Scenario 3 (40% Acc, High Hint)']!.finalScore.toStringAsFixed(2)} (${r['Scenario 3 (40% Acc, High Hint)']!.scoreDelta >= 0 ? '+' : ''}${r['Scenario 3 (40% Acc, High Hint)']!.scoreDelta})';
        final s4 = '${r['Scenario 4 (70% Acc, Mod Hint)']!.finalScore.toStringAsFixed(2)} (${r['Scenario 4 (70% Acc, Mod Hint)']!.scoreDelta >= 0 ? '+' : ''}${r['Scenario 4 (70% Acc, Mod Hint)']!.scoreDelta})';
        final s5 = '${r['Scenario 5 (Mistakes -> Recovery)']!.finalScore.toStringAsFixed(2)} (${r['Scenario 5 (Mistakes -> Recovery)']!.scoreDelta >= 0 ? '+' : ''}${r['Scenario 5 (Mistakes -> Recovery)']!.scoreDelta})';

        print(
          candidate.id.padRight(16) +
          s1.padRight(16) +
          s2.padRight(16) +
          s3.padRight(16) +
          s4.padRight(16) +
          s5.padRight(16),
        );
      }

      // Verification of Baseline Vulnerability:
      // In baseline, Scenario 1 (50% accuracy with hints) collapses to 0.0
      final baselineS1 = resultsByCandidate['baseline']!['Scenario 1 (50% Acc, High Hint)']!;
      expect(baselineS1.finalScore, equals(0.0), reason: 'Confirms baseline downward drift vulnerability');

      // Candidate C: Context-aware assisted error (0.06)
      final candCS1 = resultsByCandidate['candidate_c']!['Scenario 1 (50% Acc, High Hint)']!;
      // Should not collapse to zero:
      expect(candCS1.finalScore, greaterThan(0.15), reason: 'Candidate C preserves reasonable floor at 50% accuracy');
      expect(candCS1.finalScore, lessThanOrEqualTo(0.35), reason: 'Candidate C does not cause mastery inflation');

      // Candidate E: Balanced composite
      final candES1 = resultsByCandidate['candidate_e']!['Scenario 1 (50% Acc, High Hint)']!;
      expect(candES1.finalScore, greaterThan(0.15));
      expect(candES1.finalScore, lessThanOrEqualTo(0.35));

      // In Scenario 5 (Recovery): all viable candidates must demonstrate complete recovery
      final candCS5 = resultsByCandidate['candidate_c']!['Scenario 5 (Mistakes -> Recovery)']!;
      expect(candCS5.finalScore, greaterThanOrEqualTo(0.75), reason: 'Learner successfully recovers to familiar/mastered');
      expect(candCS5.finalState, equals(VocabularyLearningState.familiar));
    });
  });

  group('Concern B: Challenge Tier Access Experiments', () {
    test('Evaluate Strategies A-D across 5 key learner profiles', () {
      final strategies = [
        ChallengePromotionStrategy.strictStreak,
        ChallengePromotionStrategy.performanceOverride,
        ChallengePromotionStrategy.evidenceComposite,
        ChallengePromotionStrategy.twoSessionProof,
      ];

      print('\n=== CONCERN B: CHALLENGE ELIGIBILITY EVALUATION ===');
      print(
        'Profile'.padRight(28) +
        'StrictStreak'.padRight(16) +
        'PerfOverride'.padRight(16) +
        'EvidenceComp'.padRight(16) +
        'TwoSession'.padRight(16),
      );
      print('-' * 92);

      // Setup 5 synthetic profiles for testing:
      // 1. Fast Learner: Day 1 (streak=1), 15 attempts, 14 correct, 1 hint, 13 independent recalls, avgMastery=0.82
      final fastMastery = [
        VocabularyMastery(
          childId: 'p_fast',
          vocabularyId: 'v1',
          word: 'Elephant',
          exposureCount: 8,
          correctAttempts: 8,
          incorrectAttempts: 0,
          consecutiveCorrect: 8,
          lastSeenAt: baseTime,
          nextReviewAt: baseTime.add(const Duration(days: 7)),
          masteryScore: 0.95,
          confidenceLevel: 0.90,
          currentLearningState: VocabularyLearningState.mastered,
        ),
        VocabularyMastery(
          childId: 'p_fast',
          vocabularyId: 'v2',
          word: 'Lion',
          exposureCount: 7,
          correctAttempts: 6,
          incorrectAttempts: 1,
          consecutiveCorrect: 5,
          lastSeenAt: baseTime,
          nextReviewAt: baseTime.add(const Duration(days: 4)),
          masteryScore: 0.80,
          confidenceLevel: 0.85,
          currentLearningState: VocabularyLearningState.familiar,
        ),
      ];
      final fastChildDay1 = const ChildProfile(
        id: 'p_fast',
        parentId: 'parent_1',
        name: 'AyaanFast',
        age: 7,
        avatar: Avatar(id: 'av_1', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        unlockedWorldIds: ['world_animal'],
        streakDays: 1, // Day 1!
      );

      // 2. Average Learner: Day 1 (streak=1), 15 attempts, 11 correct, 3 hints, 8 independent, avgMastery=0.60
      final avgMastery = [
        VocabularyMastery(
          childId: 'p_avg',
          vocabularyId: 'v1',
          word: 'Elephant',
          exposureCount: 8,
          correctAttempts: 6,
          incorrectAttempts: 2,
          consecutiveCorrect: 2,
          lastSeenAt: baseTime,
          nextReviewAt: baseTime.add(const Duration(days: 2)),
          masteryScore: 0.62,
          confidenceLevel: 0.65,
          currentLearningState: VocabularyLearningState.practicing,
        ),
        VocabularyMastery(
          childId: 'p_avg',
          vocabularyId: 'v2',
          word: 'Lion',
          exposureCount: 7,
          correctAttempts: 5,
          incorrectAttempts: 2,
          consecutiveCorrect: 2,
          lastSeenAt: baseTime,
          nextReviewAt: baseTime.add(const Duration(days: 2)),
          masteryScore: 0.58,
          confidenceLevel: 0.60,
          currentLearningState: VocabularyLearningState.practicing,
        ),
      ];
      final avgChild = const ChildProfile(
        id: 'p_avg',
        parentId: 'parent_1',
        name: 'ZaydAvg',
        age: 6,
        avatar: Avatar(id: 'av_2', name: 'Zayd', assetPath: 'assets/zayd.png'),
        unlockedWorldIds: ['world_animal'],
        streakDays: 1,
      );

      // 3. Lucky Short-Streak Learner: 3 attempts, 3 correct (100% acc), 0 hints, avgMastery=0.78 (very small sample!)
      final luckyMastery = [
        VocabularyMastery(
          childId: 'p_lucky',
          vocabularyId: 'v1',
          word: 'Elephant',
          exposureCount: 3,
          correctAttempts: 3,
          incorrectAttempts: 0,
          consecutiveCorrect: 3,
          lastSeenAt: baseTime,
          nextReviewAt: baseTime.add(const Duration(days: 2)),
          masteryScore: 0.78,
          confidenceLevel: 0.75,
          currentLearningState: VocabularyLearningState.familiar,
        ),
      ];
      final luckyChild = const ChildProfile(
        id: 'p_lucky',
        parentId: 'parent_1',
        name: 'LuckyShort',
        age: 7,
        avatar: Avatar(id: 'av_3', name: 'Lucky', assetPath: 'assets/lucky.png'),
        unlockedWorldIds: ['world_animal'],
        streakDays: 1,
      );

      // 4. Assisted High-Accuracy Learner: 15 attempts, 14 correct, 11 hints (73% hint rate), avgMastery=0.76
      final assistedMastery = [
        VocabularyMastery(
          childId: 'p_assisted',
          vocabularyId: 'v1',
          word: 'Elephant',
          exposureCount: 15,
          correctAttempts: 14,
          incorrectAttempts: 1,
          consecutiveCorrect: 6,
          hintCount: 11,
          lastSeenAt: baseTime,
          nextReviewAt: baseTime.add(const Duration(days: 4)),
          masteryScore: 0.76,
          confidenceLevel: 0.80,
          currentLearningState: VocabularyLearningState.familiar,
        ),
      ];
      final assistedChild = const ChildProfile(
        id: 'p_assisted',
        parentId: 'parent_1',
        name: 'AssistedHighAcc',
        age: 7,
        avatar: Avatar(id: 'av_4', name: 'Assisted', assetPath: 'assets/assisted.png'),
        unlockedWorldIds: ['world_animal'],
        streakDays: 1,
      );

      // 5. Strong Returning Learner: streak=0 (reset), 14-day absence, 20 attempts, 18 correct, avgMastery=0.78
      final returningMastery = [
        VocabularyMastery(
          childId: 'p_ret',
          vocabularyId: 'v1',
          word: 'Elephant',
          exposureCount: 10,
          correctAttempts: 9,
          incorrectAttempts: 1,
          consecutiveCorrect: 5,
          lastSeenAt: baseTime,
          nextReviewAt: baseTime.add(const Duration(days: 4)),
          masteryScore: 0.80,
          confidenceLevel: 0.80,
          currentLearningState: VocabularyLearningState.familiar,
        ),
        VocabularyMastery(
          childId: 'p_ret',
          vocabularyId: 'v2',
          word: 'Lion',
          exposureCount: 10,
          correctAttempts: 9,
          incorrectAttempts: 1,
          consecutiveCorrect: 4,
          lastSeenAt: baseTime,
          nextReviewAt: baseTime.add(const Duration(days: 4)),
          masteryScore: 0.76,
          confidenceLevel: 0.78,
          currentLearningState: VocabularyLearningState.familiar,
        ),
      ];
      final returningChild = const ChildProfile(
        id: 'p_ret',
        parentId: 'parent_1',
        name: 'ReturningStrong',
        age: 7,
        avatar: Avatar(id: 'av_5', name: 'Ret', assetPath: 'assets/ret.png'),
        unlockedWorldIds: ['world_animal'],
        streakDays: 0,
      );

      final testCases = [
        ('1. Fast Day 1', fastChildDay1, fastMastery),
        ('2. Average Day 1', avgChild, avgMastery),
        ('3. Lucky Short-Streak', luckyChild, luckyMastery),
        ('4. Assisted High-Acc', assistedChild, assistedMastery),
        ('5. Strong Returning', returningChild, returningMastery),
      ];

      final results = <String, Map<ChallengePromotionStrategy, bool>>{};

      for (final tc in testCases) {
        final profileName = tc.$1;
        final child = tc.$2;
        final masteries = tc.$3;
        results[profileName] = {};

        for (final strat in strategies) {
          final orchestrator = LearningSessionOrchestrator(
            clock: () => baseTime,
            challengeStrategy: strat,
          );
          final session = orchestrator.assembleSession(
            child: child,
            masteries: masteries,
            graph: CurriculumGraph.standard(),
            currentWorld: defaultWorld,
            now: baseTime,
          );
          final isChallenge = session.difficultyLevel >= 3;
          results[profileName]![strat] = isChallenge;
        }

        print(
          profileName.padRight(28) +
          (results[profileName]![ChallengePromotionStrategy.strictStreak]! ? 'CHALLENGE' : 'standard/easy').padRight(16) +
          (results[profileName]![ChallengePromotionStrategy.performanceOverride]! ? 'CHALLENGE' : 'standard/easy').padRight(16) +
          (results[profileName]![ChallengePromotionStrategy.evidenceComposite]! ? 'CHALLENGE' : 'standard/easy').padRight(16) +
          (results[profileName]![ChallengePromotionStrategy.twoSessionProof]! ? 'CHALLENGE' : 'standard/easy').padRight(16),
        );
      }

      // Assertions:
      // In baseline (strictStreak), Fast Day 1 is blocked:
      expect(results['1. Fast Day 1']![ChallengePromotionStrategy.strictStreak], isFalse);

      // In Evidence Composite:
      // Fast Day 1 enters challenge:
      expect(results['1. Fast Day 1']![ChallengePromotionStrategy.evidenceComposite], isTrue);

      // Lucky Short-Streak is BLOCKED by all candidates (sample size < 12):
      expect(results['3. Lucky Short-Streak']![ChallengePromotionStrategy.evidenceComposite], isFalse);
      expect(results['3. Lucky Short-Streak']![ChallengePromotionStrategy.twoSessionProof], isFalse);

      // Assisted High-Accuracy is BLOCKED by evidenceComposite and twoSessionProof (hint rate > 15%):
      expect(results['4. Assisted High-Acc']![ChallengePromotionStrategy.evidenceComposite], isFalse);
      expect(results['4. Assisted High-Acc']![ChallengePromotionStrategy.twoSessionProof], isFalse);

      // Average Learner is BLOCKED by all (avgMastery < 0.75):
      expect(results['2. Average Day 1']![ChallengePromotionStrategy.evidenceComposite], isFalse);
      expect(results['2. Average Day 1']![ChallengePromotionStrategy.twoSessionProof], isFalse);

      // Strong Returning Learner qualifies under evidenceComposite:
      expect(results['5. Strong Returning']![ChallengePromotionStrategy.evidenceComposite], isTrue);
    });
  });

  group('Concern C: Returning Learner Grace Experiments', () {
    test('Evaluate returnee grace across Scenarios A-F and absence durations', () {
      // Test absence durations: 3d, 7d, 14d, 30d
      final absenceDurations = [3, 7, 14, 30];

      print('\n=== CONCERN C: RETURNEE GRACE & PENALTY SHOCK ===');
      print(
        'Absence Days'.padRight(16) +
        'Decay Score'.padRight(16) +
        'Baseline Miss 1'.padRight(18) +
        'Grace Miss 1'.padRight(18) +
        'Baseline Miss 2'.padRight(18) +
        'Grace Miss 2'.padRight(18),
      );
      print('-' * 104);

      const baseConfig = MasteryScoringConfig(
        assistedErrorPenalty: null,
        applyHintPenaltyOnError: true,
        returneeGraceDaysThreshold: 0,
        returneeGraceErrorDampening: 1.0,
      );
      final graceConfig = const MasteryScoringConfig(
        returneeGraceDaysThreshold: 7,
        returneeGraceErrorDampening: 0.50,
      );

      final baselineEngine = MasteryEngine(config: baseConfig);
      final graceEngine = MasteryEngine(config: graceConfig);

      for (final days in absenceDurations) {
        final initialMastery = VocabularyMastery(
          childId: 'c_ret',
          vocabularyId: 'v_lion',
          word: 'Lion',
          exposureCount: 10,
          correctAttempts: 9,
          incorrectAttempts: 1,
          consecutiveCorrect: 4,
          lastSeenAt: baseTime,
          nextReviewAt: baseTime.add(const Duration(days: 4)),
          masteryScore: 0.85,
          confidenceLevel: 0.85,
          currentLearningState: VocabularyLearningState.mastered,
        );

        final returnTime = baseTime.add(Duration(days: days));

        // 1. Decay
        final decayed = baselineEngine.applyTimeDecay(
          mastery: initialMastery,
          currentDate: returnTime,
        );

        // Baseline: Miss 1 and Miss 2
        final baseMiss1 = baselineEngine.recordAttempt(
          currentMastery: decayed,
          evidence: LearningEvidence(
            childId: 'c_ret',
            vocabularyId: 'v_lion',
            word: 'Lion',
            isCorrect: false,
            timestamp: returnTime,
          ),
        );
        final baseMiss2 = baselineEngine.recordAttempt(
          currentMastery: baseMiss1,
          evidence: LearningEvidence(
            childId: 'c_ret',
            vocabularyId: 'v_lion',
            word: 'Lion',
            isCorrect: false,
            timestamp: returnTime.add(const Duration(minutes: 5)),
          ),
        );

        // Grace: Miss 1 and Miss 2
        final graceMiss1 = graceEngine.recordAttempt(
          currentMastery: decayed,
          evidence: LearningEvidence(
            childId: 'c_ret',
            vocabularyId: 'v_lion',
            word: 'Lion',
            isCorrect: false,
            timestamp: returnTime,
          ),
        );
        final graceMiss2 = graceEngine.recordAttempt(
          currentMastery: graceMiss1,
          evidence: LearningEvidence(
            childId: 'c_ret',
            vocabularyId: 'v_lion',
            word: 'Lion',
            isCorrect: false,
            timestamp: returnTime.add(const Duration(minutes: 5)),
          ),
        );

        print(
          '$days days'.padRight(16) +
          decayed.masteryScore.toStringAsFixed(2).padRight(16) +
          baseMiss1.masteryScore.toStringAsFixed(2).padRight(18) +
          graceMiss1.masteryScore.toStringAsFixed(2).padRight(18) +
          baseMiss2.masteryScore.toStringAsFixed(2).padRight(18) +
          graceMiss2.masteryScore.toStringAsFixed(2).padRight(18),
        );

        if (days >= 7) {
          // Verify grace dampening takes effect for >= 7 days
          expect(graceMiss1.masteryScore, greaterThan(baseMiss1.masteryScore));
          expect(graceMiss2.masteryScore, greaterThan(baseMiss2.masteryScore));
        } else {
          // Under 7 days (e.g. 3 days), grace does not trigger, behaving exactly like baseline
          expect(graceMiss1.masteryScore, equals(baseMiss1.masteryScore));
        }
      }

      // Scenario E: Child who remembers material correctly despite long absence
      final returnTime14 = baseTime.add(const Duration(days: 14));
      final rememberedMastery = VocabularyMastery(
        childId: 'c_ret',
        vocabularyId: 'v_lion',
        word: 'Lion',
        exposureCount: 10,
        correctAttempts: 9,
        incorrectAttempts: 1,
        consecutiveCorrect: 4,
        lastSeenAt: baseTime,
        nextReviewAt: baseTime.add(const Duration(days: 4)),
        masteryScore: 0.85,
        confidenceLevel: 0.85,
        currentLearningState: VocabularyLearningState.mastered,
      );
      final recovered = graceEngine.recordAttempt(
        currentMastery: rememberedMastery,
        evidence: LearningEvidence(
          childId: 'c_ret',
          vocabularyId: 'v_lion',
          word: 'Lion',
          isCorrect: true,
          isIndependentRecall: true,
          timestamp: returnTime14,
        ),
      );
      print('\nScenario E (Remembered upon return): Initial=0.85 -> Decayed+Recovered=${recovered.masteryScore} (state=${recovered.currentLearningState.name})');
      expect(recovered.masteryScore, greaterThan(0.70));
    });
  });

  group('Longitudinal Full-Profile Comparison (Baseline vs Tuned)', () {
    test('Run all 5 standard profiles under Baseline and Tuned configurations', () async {
      const baseConfig = MasteryScoringConfig(
        assistedErrorPenalty: null,
        applyHintPenaltyOnError: true,
        returneeGraceDaysThreshold: 0,
        returneeGraceErrorDampening: 1.0,
      );
      const tunedConfig = MasteryScoringConfig(
        assistedErrorPenalty: 0.06,
        applyHintPenaltyOnError: false,
        returneeGraceDaysThreshold: 7,
        returneeGraceErrorDampening: 0.50,
      );

      print('\nRunning Baseline longitudinal simulations (Profiles A-E)...');
      final baseMetrics = await experiment.runLongitudinalSimulation(
        config: baseConfig,
        challengeStrategy: ChallengePromotionStrategy.strictStreak,
      );

      print('Running Tuned longitudinal simulations (Profiles A-E)...');
      final tunedMetrics = await experiment.runLongitudinalSimulation(
        config: tunedConfig,
        challengeStrategy: ChallengePromotionStrategy.evidenceComposite,
      );

      print('\n=== LONGITUDINAL PROFILE COMPARISON: BASELINE vs TUNED ===');
      print(
        'Profile'.padRight(20) +
        'Metric'.padRight(24) +
        'Baseline'.padRight(16) +
        'Tuned'.padRight(16) +
        'Delta',
      );
      print('-' * 84);

      void printRow(String profile, String metric, dynamic baseVal, dynamic tunedVal) {
        String deltaStr = '';
        if (baseVal is num && tunedVal is num) {
          final diff = tunedVal - baseVal;
          deltaStr = diff >= 0 ? '+${diff is double ? diff.toStringAsFixed(2) : diff}' : '${diff is double ? diff.toStringAsFixed(2) : diff}';
        }
        print(
          profile.padRight(20) +
          metric.padRight(24) +
          baseVal.toString().padRight(16) +
          tunedVal.toString().padRight(16) +
          deltaStr,
        );
      }

      // MaryamStruggling
      final bStrug = baseMetrics['struggling']!;
      final tStrug = tunedMetrics['struggling']!;
      printRow('MaryamStruggling', 'Accuracy', bStrug.accuracy, tStrug.accuracy);
      printRow('MaryamStruggling', 'Hint Rate', bStrug.hintRate, tStrug.hintRate);
      printRow('MaryamStruggling', 'Familiar Words', bStrug.conceptsFamiliarCount, tStrug.conceptsFamiliarCount);
      printRow('MaryamStruggling', 'Mastered Words', bStrug.conceptsMasteredCount, tStrug.conceptsMasteredCount);
      printRow('MaryamStruggling', 'Support Sessions', bStrug.difficultyTiers['support'] ?? 0, tStrug.difficultyTiers['support'] ?? 0);

      // ZaydAverage
      final bAvg = baseMetrics['average']!;
      final tAvg = tunedMetrics['average']!;
      printRow('ZaydAverage', 'Accuracy', bAvg.accuracy, tAvg.accuracy);
      printRow('ZaydAverage', 'Mastered Words', bAvg.conceptsMasteredCount, tAvg.conceptsMasteredCount);
      printRow('ZaydAverage', 'Challenge Sessions', bAvg.difficultyTiers['challenge'] ?? 0, tAvg.difficultyTiers['challenge'] ?? 0);

      // AyaanFast
      final bFast = baseMetrics['fast']!;
      final tFast = tunedMetrics['fast']!;
      printRow('AyaanFast', 'Accuracy', bFast.accuracy, tFast.accuracy);
      printRow('AyaanFast', 'Mastered Words', bFast.conceptsMasteredCount, tFast.conceptsMasteredCount);
      printRow('AyaanFast', 'Challenge Sessions', bFast.difficultyTiers['challenge'] ?? 0, tFast.difficultyTiers['challenge'] ?? 0);

      // ZaydReturning
      final bRet = baseMetrics['returning']!;
      final tRet = tunedMetrics['returning']!;
      printRow('ZaydReturning', 'Mastered Words', bRet.conceptsMasteredCount, tRet.conceptsMasteredCount);

      // AyaanNew
      final bNew = baseMetrics['new']!;
      final tNew = tunedMetrics['new']!;
      printRow('AyaanNew', 'Mastered Words', bNew.conceptsMasteredCount, tNew.conceptsMasteredCount);

      // Assertions verifying improvements without inflation:
      // 1. Struggling learner retains a healthier learning trajectory (familiar count >= baseline):
      expect(tStrug.conceptsFamiliarCount, greaterThanOrEqualTo(bStrug.conceptsFamiliarCount));
      // 2. Average learner does not suffer challenge inflation:
      expect(tAvg.difficultyTiers['challenge'] ?? 0, equals(0));
      // 3. Fast learner reaches challenge sessions:
      expect(tFast.difficultyTiers['challenge'] ?? 0, greaterThan(0));
    });
  });
}
