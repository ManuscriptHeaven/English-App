import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/data/mock_vocabulary_mastery_repository.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session_orchestrator.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('Multi-Child Isolation Stress Validation (150 Interleaved Events)', () {
    late MockVocabularyMasteryRepository masteryRepo;
    late MasteryEngine masteryEngine;
    late LearningSessionOrchestrator orchestrator;
    final now = DateTime(2026, 9, 10, 8, 0, 0);

    const ayaan = ChildProfile(
      id: 'child_ayaan',
      parentId: 'parent_1',
      name: 'Ayaan',
      age: 7,
      avatar: Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
      unlockedWorldIds: ['world_animal'],
    );

    const maryam = ChildProfile(
      id: 'child_maryam',
      parentId: 'parent_1',
      name: 'Maryam',
      age: 4,
      avatar: Avatar(id: 'av_maryam', name: 'Maryam', assetPath: 'assets/maryam.png'),
      unlockedWorldIds: ['world_animal'],
    );

    const zayd = ChildProfile(
      id: 'child_zayd',
      parentId: 'parent_1',
      name: 'Zayd',
      age: 6,
      avatar: Avatar(id: 'av_zayd', name: 'Zayd', assetPath: 'assets/zayd.png'),
      unlockedWorldIds: ['world_animal'],
    );

    final world = const World(
      id: 'world_animal',
      title: 'Animal Adventure',
      theme: 'animal',
      description: 'World',
      bannerAssetPath: 'assets/banner.png',
      primaryColorHex: '0xFF66BB6A',
      orderIndex: 1,
      metadata: ContentMetadata(
        learningObjective: 'Animals',
        worldId: 'world_animal',
      ),
      chapters: [],
    );

    setUp(() {
      masteryRepo = MockVocabularyMasteryRepository();
      masteryEngine = const MasteryEngine();
      orchestrator = LearningSessionOrchestrator(clock: () => now);
    });

    test('Zero cross-child leakage across 150 interleaved events between Ayaan, Maryam, and Zayd', () async {
      // Run 50 interleaved rounds (3 events per round = 150 events)
      for (int round = 0; round < 50; round++) {
        final time = now.add(Duration(hours: round * 4));

        // 1. Ayaan: always correct (fast learner)
        final ayaanPrev = await masteryRepo.getMastery(childId: ayaan.id, vocabularyId: 'vocab_elephant');
        final ayaanUpdated = masteryEngine.recordAttempt(
          currentMastery: ayaanPrev,
          evidence: LearningEvidence(
            childId: ayaan.id,
            vocabularyId: 'vocab_elephant',
            word: 'Elephant',
            isCorrect: true,
            isIndependentRecall: true,
            timestamp: time,
          ),
        );
        await masteryRepo.saveMastery(ayaanUpdated);

        // 2. Maryam: consecutive errors (struggling learner)
        final maryamPrev = await masteryRepo.getMastery(childId: maryam.id, vocabularyId: 'vocab_elephant');
        final maryamUpdated = masteryEngine.recordAttempt(
          currentMastery: maryamPrev,
          evidence: LearningEvidence(
            childId: maryam.id,
            vocabularyId: 'vocab_elephant',
            word: 'Elephant',
            isCorrect: false,
            usedHint: true,
            timestamp: time,
          ),
        );
        await masteryRepo.saveMastery(maryamUpdated);

        // 3. Zayd: alternating correct/error
        final zaydPrev = await masteryRepo.getMastery(childId: zayd.id, vocabularyId: 'vocab_elephant');
        final zaydUpdated = masteryEngine.recordAttempt(
          currentMastery: zaydPrev,
          evidence: LearningEvidence(
            childId: zayd.id,
            vocabularyId: 'vocab_elephant',
            word: 'Elephant',
            isCorrect: round % 2 == 0,
            isIndependentRecall: true,
            timestamp: time,
          ),
        );
        await masteryRepo.saveMastery(zaydUpdated);
      }

      // Verify Ayaan's mastery: high score, mastered
      final ayaanFinal = await masteryRepo.getMastery(childId: ayaan.id, vocabularyId: 'vocab_elephant');
      expect(ayaanFinal?.childId, equals('child_ayaan'));
      expect(ayaanFinal?.masteryScore, greaterThanOrEqualTo(0.90));
      expect(ayaanFinal?.currentLearningState, equals(VocabularyLearningState.mastered));

      // Verify Maryam's mastery: low score, struggling
      final maryamFinal = await masteryRepo.getMastery(childId: maryam.id, vocabularyId: 'vocab_elephant');
      expect(maryamFinal?.childId, equals('child_maryam'));
      expect(maryamFinal?.masteryScore, equals(0.0));
      expect(maryamFinal?.currentLearningState, equals(VocabularyLearningState.struggling));

      // Verify Zayd's mastery: intermediate
      final zaydFinal = await masteryRepo.getMastery(childId: zayd.id, vocabularyId: 'vocab_elephant');
      expect(zaydFinal?.childId, equals('child_zayd'));
      expect(zaydFinal?.masteryScore, inInclusiveRange(0.20, 0.70));

      // Assemble sessions and verify strict isolation
      final ayaanSession = orchestrator.assembleSession(
        child: ayaan,
        masteries: [ayaanFinal!],
        graph: CurriculumGraph.standard(),
        currentWorld: world,
        now: now,
      );

      final maryamSession = orchestrator.assembleSession(
        child: maryam,
        masteries: [maryamFinal!],
        graph: CurriculumGraph.standard(),
        currentWorld: world,
        consecutiveErrors: 4,
        now: now,
      );

      expect(ayaanSession.confidenceProtectionApplied, isFalse);
      expect(ayaanSession.difficultyLevel, equals(4));
      expect(ayaanSession.difficultyLevel, greaterThan(maryamSession.difficultyLevel));

      expect(maryamSession.confidenceProtectionApplied, isTrue);
      expect(maryamSession.difficultyLevel, equals(1));
      expect(maryamSession.lengthCategory.name, equals('micro'));
    });
  });
}
