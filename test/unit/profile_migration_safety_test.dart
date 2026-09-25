import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/adaptive_mastery_model.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/adaptive_decision.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/adaptive_learning_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/telemetry/learning_event.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/telemetry/learning_telemetry_service.dart';

void main() {
  group('ChildProfile Migration & Backwards Compatibility Tests', () {
    test('Parses legacy minimal JSON payload without crashing and populates safe defaults', () {
      final legacyJson = {
        'id': 'child_legacy_1',
        'name': 'Zayd',
        'age': 5,
        'avatar': {
          'id': 'av_boy',
          'name': 'Explorer Boy',
          'assetPath': 'assets/avatars/boy.png',
        },
      };

      final profile = ChildProfile.fromJson(legacyJson);

      expect(profile.id, 'child_legacy_1');
      expect(profile.name, 'Zayd');
      expect(profile.age, 5);
      expect(profile.gender, 'boy'); // Safe default
      expect(profile.level, 1);
      expect(profile.xp, greaterThanOrEqualTo(0));
      expect(profile.coins, greaterThan(0));
      expect(profile.stars, greaterThan(0));
      expect(profile.unlockedWorldIds, contains('world_animal'));
      expect(profile.completedLessonIds, isEmpty);
      expect(profile.unlockedAchievementIds, isEmpty);
      expect(profile.inventoryItemIds, isEmpty);
      expect(profile.interests, contains('animals'));
    });

    test('Parses legacy JSON missing new array fields cleanly', () {
      final jsonWithMissingArrays = {
        'id': 'child_legacy_2',
        'name': 'Maryam',
        'age': 7,
        'gender': 'girl',
        'avatar': {
          'id': 'av_girl',
          'name': 'Explorer Girl',
          'assetPath': 'assets/avatars/girl.png',
        },
        'level': 3,
        'xp': 450,
        'coins': 120,
        'stars': 15,
        'streakDays': 4,
      };

      final profile = ChildProfile.fromJson(jsonWithMissingArrays);

      expect(profile.id, 'child_legacy_2');
      expect(profile.name, 'Maryam');
      expect(profile.gender, 'girl');
      expect(profile.unlockedWorldIds, const ['world_animal']);
      expect(profile.completedLessonIds, isEmpty);
    });
  });

  group('AdaptiveContentMastery Model & Calculation Tests', () {
    test('Calculates gradual mastery non-simplistically across attempts', () {
      final initial = AdaptiveContentMastery(
        contentId: 'vocab_elephant',
        skill: SkillType.vocabulary,
        lastPracticedTime: DateTime(2026, 1, 1),
      );

      expect(initial.masteryScore, 0.0);
      expect(initial.isWeak, isTrue);

      // Attempt 1: Correct
      final after1 = initial.recordAttempt(
        isCorrect: true,
        practicedPronunciation: true,
        now: DateTime(2026, 1, 1, 10, 0),
      );
      // Not instantly 1.0; gradual evolution
      expect(after1.masteryScore, greaterThan(0.20));
      expect(after1.masteryScore, lessThan(0.70));
      expect(after1.pronunciationAttempts, 1);

      // Attempt 2: Incorrect (error penalty)
      final after2 = after1.recordAttempt(
        isCorrect: false,
        usedHint: true,
        now: DateTime(2026, 1, 1, 10, 5),
      );
      expect(after2.consecutiveErrors, 1);
      expect(after2.hintUsageCount, 1);

      // Attempt 3, 4, 5: Sustained practice and comprehension
      var current = after2;
      for (int i = 0; i < 4; i++) {
        current = current.recordAttempt(
          isCorrect: true,
          newComprehensionScore: 0.90,
          completedActivity: true,
          now: DateTime(2026, 1, 1, 10, 10 + i),
        );
      }

      expect(current.consecutiveErrors, 0);
      expect(current.masteryScore, greaterThan(0.70));
      expect(current.isWeak, isFalse);
    });

    test('Preserves backwards-compatibility with missing JSON fields in AdaptiveContentMastery', () {
      final partialJson = {
        'contentId': 'vocab_lion',
        'skill': 'vocabulary',
      };

      final mastery = AdaptiveContentMastery.fromJson(partialJson);

      expect(mastery.contentId, 'vocab_lion');
      expect(mastery.skill, SkillType.vocabulary);
      expect(mastery.correctAttempts, 0);
      expect(mastery.incorrectAttempts, 0);
      expect(mastery.consecutiveErrors, 0);
      expect(mastery.masteryScore, 0.0);
    });
  });

  group('AdaptiveLearningEngine Decision Tests', () {
    test('Prescribes simplify and high scaffolding when child is struggling', () {
      final strugglingMastery = AdaptiveContentMastery(
        contentId: 'grammar_plurals',
        skill: SkillType.grammar,
        consecutiveErrors: 3,
        lastPracticedTime: DateTime.now(),
      );

      final decision = AdaptiveLearningEngine.evaluateIntervention(mastery: strugglingMastery);

      expect(decision.action, AdaptiveAction.simplify);
      expect(decision.suggestedScaffoldingLevel, 3);
      expect(decision.suggestedDifficulty, 1);
      expect(decision.rationale, contains('consecutive errors'));
    });

    test('Prescribes advance when child reaches mastery threshold', () {
      final masteredItem = AdaptiveContentMastery(
        contentId: 'vocab_cat',
        skill: SkillType.vocabulary,
        correctAttempts: 6,
        incorrectAttempts: 0,
        masteryScore: 0.92,
        lastPracticedTime: DateTime.now(),
      );

      final decision = AdaptiveLearningEngine.evaluateIntervention(mastery: masteredItem);

      expect(decision.action, AdaptiveAction.advance);
      expect(decision.suggestedScaffoldingLevel, 1);
    });

    test('Prescribes recommendWeakVocabulary when score is low', () {
      final weakItem = AdaptiveContentMastery(
        contentId: 'vocab_zebra',
        skill: SkillType.vocabulary,
        correctAttempts: 1,
        incorrectAttempts: 3,
        masteryScore: 0.35,
        lastPracticedTime: DateTime.now(),
      );

      final decision = AdaptiveLearningEngine.evaluateIntervention(mastery: weakItem);

      expect(decision.action, AdaptiveAction.recommendWeakVocabulary);
      expect(decision.targetContentId, 'vocab_zebra');
    });
  });

  group('LearningTelemetryService Child Isolation Tests', () {
    test('Strictly isolates events between children', () {
      final service = InMemoryLearningTelemetryService();

      service.recordEvent(LearningEvent(
        id: 'ev_1',
        eventType: LearningEventType.vocabularyViewed,
        childId: 'child_ayaan',
        worldId: 'world_animal',
        lessonId: 'l1',
        activityId: 'activity_animal_vocab',
        vocabularyId: 'vocab_elephant',
        timestamp: DateTime(2026, 1, 1, 10, 0),
      ));

      service.recordEvent(LearningEvent(
        id: 'ev_2',
        eventType: LearningEventType.answerCorrect,
        childId: 'child_maryam',
        worldId: 'world_animal',
        lessonId: 'l1',
        activityId: 'activity_animal_hunt',
        timestamp: DateTime(2026, 1, 1, 10, 1),
      ));

      final ayaanEvents = service.getEventsForChild('child_ayaan');
      final maryamEvents = service.getEventsForChild('child_maryam');
      final unknownEvents = service.getEventsForChild('child_unknown');

      expect(ayaanEvents.length, 1);
      expect(ayaanEvents.first.id, 'ev_1');
      expect(ayaanEvents.first.eventType, LearningEventType.vocabularyViewed);

      expect(maryamEvents.length, 1);
      expect(maryamEvents.first.id, 'ev_2');
      expect(maryamEvents.first.eventType, LearningEventType.answerCorrect);

      expect(unknownEvents, isEmpty);
    });
  });
}
