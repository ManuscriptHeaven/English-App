import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session_orchestrator.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/session_activity.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('LearningSessionOrchestrator Tests', () {
    late CurriculumGraph graph;
    late LearningSessionOrchestrator orchestrator;
    late World animalWorld;
    final fixedNow = DateTime(2026, 9, 10, 10, 0, 0);

    setUp(() {
      graph = CurriculumGraph.standard();
      orchestrator = LearningSessionOrchestrator(clock: () => fixedNow);
      animalWorld = const World(
        id: 'world_animal',
        title: 'Animal Adventure',
        theme: 'animal',
        description: 'Explore animals',
        bannerAssetPath: 'assets/banner.png',
        primaryColorHex: '0xFF66BB6A',
        orderIndex: 1,
        metadata: ContentMetadata(
          learningObjective: 'Animal vocabulary',
          worldId: 'world_animal',
        ),
        chapters: [],
      );
    });

    test('1. Assembles balanced session for brand new child explorer', () {
      const ayaanNew = ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 5,
        avatar: Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        unlockedWorldIds: ['world_animal'],
      );

      final session = orchestrator.assembleSession(
        child: ayaanNew,
        masteries: const [],
        graph: graph,
        currentWorld: animalWorld,
        dailyScreenTimeLimitMinutes: 15,
        now: fixedNow,
      );

      expect(session.childId, equals('child_ayaan'));
      expect(session.worldId, equals('world_animal'));
      expect(session.status, equals(SessionStatus.planned));
      expect(session.activities, isNotEmpty);
      expect(session.activities.first.activityType, equals(SessionActivityType.warmUp));
      expect(session.targetVocabularyIds, isNotEmpty);
      expect(session.confidenceProtectionApplied, isFalse);
    });

    test('2. Prioritizes spaced review for returning learner with overdue words', () {
      const ayaanReturning = ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 6,
        avatar: Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        unlockedWorldIds: ['world_animal'],
      );

      // vocab_cat is overdue for review
      final masteries = [
        VocabularyMastery(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_cat',
          word: 'Cat',
          exposureCount: 4,
          correctAttempts: 3,
          incorrectAttempts: 1,
          consecutiveCorrect: 2,
          lastSeenAt: fixedNow.subtract(const Duration(days: 3)),
          nextReviewAt: fixedNow.subtract(const Duration(hours: 4)), // overdue!
          masteryScore: 0.60,
          confidenceLevel: 0.70,
          currentLearningState: VocabularyLearningState.familiar,
        ),
      ];

      final session = orchestrator.assembleSession(
        child: ayaanReturning,
        masteries: masteries,
        graph: graph,
        currentWorld: animalWorld,
        dailyScreenTimeLimitMinutes: 15,
        now: fixedNow,
      );

      expect(session.reviewVocabularyIds, contains('vocab_cat'));
      expect(session.activities.any((a) => a.targetVocabularyIds.contains('vocab_cat')), isTrue);
    });

    test('3. Activates confidence protection and simplifies session for struggling learner', () {
      const ayaanStruggling = ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 5,
        avatar: Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        unlockedWorldIds: ['world_animal'],
      );

      final masteries = [
        VocabularyMastery(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          exposureCount: 10,
          correctAttempts: 10,
          incorrectAttempts: 0,
          consecutiveCorrect: 10,
          lastSeenAt: fixedNow.subtract(const Duration(days: 1)),
          nextReviewAt: fixedNow.add(const Duration(days: 10)),
          masteryScore: 0.95,
          confidenceLevel: 1.0,
          currentLearningState: VocabularyLearningState.mastered,
        ),
      ];

      final session = orchestrator.assembleSession(
        child: ayaanStruggling,
        masteries: masteries,
        graph: graph,
        currentWorld: animalWorld,
        consecutiveErrors: 3, // Struggle trigger!
        dailyScreenTimeLimitMinutes: 15,
        now: fixedNow,
      );

      expect(session.confidenceProtectionApplied, isTrue);
      expect(session.lengthCategory, equals(SessionLengthCategory.micro));
      expect(session.difficultyLevel, equals(1));
      expect(session.supportLevel, equals(SupportLevel.maximum));
      // Familiar word offered as easy win
      expect(session.reviewVocabularyIds, contains('vocab_elephant'));
    });

    test('4. Elevates difficulty and supports independence for high mastery / streak child', () {
      const maryamAdvanced = ChildProfile(
        id: 'child_maryam',
        parentId: 'parent_1',
        name: 'Maryam',
        age: 8,
        streakDays: 5,
        avatar: Avatar(id: 'av_maryam', name: 'Maryam', assetPath: 'assets/maryam.png'),
        unlockedWorldIds: ['world_animal'],
      );

      final masteries = [
        VocabularyMastery(
          childId: 'child_maryam',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          exposureCount: 12,
          correctAttempts: 12,
          incorrectAttempts: 0,
          consecutiveCorrect: 12,
          lastSeenAt: fixedNow,
          nextReviewAt: fixedNow.add(const Duration(days: 14)),
          masteryScore: 0.95,
          confidenceLevel: 0.95,
          currentLearningState: VocabularyLearningState.mastered,
        ),
        VocabularyMastery(
          childId: 'child_maryam',
          vocabularyId: 'vocab_lion',
          word: 'Lion',
          exposureCount: 10,
          correctAttempts: 10,
          incorrectAttempts: 0,
          consecutiveCorrect: 10,
          lastSeenAt: fixedNow,
          nextReviewAt: fixedNow.add(const Duration(days: 14)),
          masteryScore: 0.90,
          confidenceLevel: 0.95,
          currentLearningState: VocabularyLearningState.mastered,
        ),
      ];

      final session = orchestrator.assembleSession(
        child: maryamAdvanced,
        masteries: masteries,
        graph: graph,
        currentWorld: animalWorld,
        dailyScreenTimeLimitMinutes: 20,
        now: fixedNow,
      );

      expect(session.difficultyLevel, equals(4));
      expect(session.supportLevel, equals(SupportLevel.independent));
      expect(session.lengthCategory, equals(SessionLengthCategory.extended));
    });

    test('5. Multi-child isolation: Ayaan struggle does not leak into Maryam session', () {
      const ayaan = ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 4,
        avatar: Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        unlockedWorldIds: ['world_animal'],
      );

      const maryam = ChildProfile(
        id: 'child_maryam',
        parentId: 'parent_1',
        name: 'Maryam',
        age: 7,
        streakDays: 4,
        avatar: Avatar(id: 'av_maryam', name: 'Maryam', assetPath: 'assets/maryam.png'),
        unlockedWorldIds: ['world_animal'],
      );

      // Ayaan's session assembled with struggle
      final ayaanSession = orchestrator.assembleSession(
        child: ayaan,
        masteries: const [],
        graph: graph,
        currentWorld: animalWorld,
        consecutiveErrors: 4,
        now: fixedNow,
      );

      // Maryam's session assembled normally with moderate mastery
      final maryamMasteries = [
        VocabularyMastery(
          childId: 'child_maryam',
          vocabularyId: 'vocab_cat',
          word: 'Cat',
          exposureCount: 4,
          correctAttempts: 3,
          incorrectAttempts: 1,
          consecutiveCorrect: 2,
          lastSeenAt: fixedNow,
          nextReviewAt: fixedNow.add(const Duration(days: 3)),
          masteryScore: 0.60,
          confidenceLevel: 0.70,
          currentLearningState: VocabularyLearningState.familiar,
        ),
      ];

      final maryamSession = orchestrator.assembleSession(
        child: maryam,
        masteries: maryamMasteries,
        graph: graph,
        currentWorld: animalWorld,
        consecutiveErrors: 0,
        now: fixedNow,
      );

      expect(ayaanSession.childId, equals('child_ayaan'));
      expect(ayaanSession.confidenceProtectionApplied, isTrue);
      expect(ayaanSession.difficultyLevel, equals(1));

      expect(maryamSession.childId, equals('child_maryam'));
      expect(maryamSession.confidenceProtectionApplied, isFalse);
      expect(maryamSession.difficultyLevel, equals(2));
      expect(maryamSession.sessionId, isNot(equals(ayaanSession.sessionId)));
    });
  });
}
