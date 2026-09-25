import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/curriculum_seed_data.dart';
import 'package:kids_english_adventure/features/curriculum/domain/feedback/learning_feedback_service.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/activity_template.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/concept_progression_graph.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_level.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_concept.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/religious_content_safety.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/sentence_pattern.dart';
import 'package:kids_english_adventure/features/curriculum/domain/repositories/curriculum_repository.dart';

void main() {
  group('Phase 14 Curriculum Architecture & Domain Models', () {
    late CurriculumRepository repository;

    setUp(() {
      repository = CurriculumSeedData.createRepository();
    });

    test('8 Progressive Curriculum Levels exist in correct order', () {
      final levels = repository.getAllLevels();
      expect(levels.length, 8);

      for (int i = 0; i < 8; i++) {
        expect(levels[i].order, i + 1);
      }

      expect(levels[0].languageStage, LanguageStage.firstWords);
      expect(levels[1].languageStage, LanguageStage.firstPhrases);
      expect(levels[2].languageStage, LanguageStage.firstSentences);
      expect(levels[3].languageStage, LanguageStage.everydaySpeaker);
      expect(levels[4].languageStage, LanguageStage.conversationBuilder);
      expect(levels[5].languageStage, LanguageStage.storySpeaker);
      expect(levels[6].languageStage, LanguageStage.confidentCommunicator);
      expect(levels[7].languageStage, LanguageStage.advancedYoungSpeaker);
    });

    test('15 Curriculum Worlds cover communicative language domains', () {
      final worlds = repository.getAllWorlds();
      expect(worlds.length, 15);

      final domainThemes = worlds.map((w) => w.theme).toSet();
      expect(domainThemes.contains('family'), isTrue);
      expect(domainThemes.contains('food'), isTrue);
      expect(domainThemes.contains('school'), isTrue);
      expect(domainThemes.contains('nature'), isTrue);
      expect(domainThemes.contains('community'), isTrue);
      expect(domainThemes.contains('manners'), isTrue);
    });

    test('16 Authentic Islamic Value Themes cover all moral pillars', () {
      final themes = repository.getAllValueThemes();
      expect(themes.length, 16);

      for (final theme in themes) {
        expect(theme.title.isNotEmpty, isTrue);
        expect(theme.childFriendlyTitle.isNotEmpty, isTrue);
        expect(theme.authenticReference.isNotEmpty, isTrue);
      }

      final gratitudeTheme = repository.getValueThemeById('value_gratitude');
      expect(gratitudeTheme, isNotNull);
      expect(gratitudeTheme!.authenticReference.contains('Abu Dawud'), isTrue);
    });

    test('Activity Templates support multimodal delivery blueprints', () {
      final templates = repository.getAllActivityTemplates();
      expect(templates.length, 8); // Seeded core interactive templates

      final repeatTemplate = repository.getActivityTemplateById('template_repeat_pip');
      expect(repeatTemplate, isNotNull);
      expect(repeatTemplate!.requiresSpeech, isTrue);
      expect(repeatTemplate.requiresAudio, isTrue);
      expect(repeatTemplate.type, ActivityTemplateType.repeatAfterPip);

      final builderTemplate = repository.getActivityTemplateById('template_sentence_builder');
      expect(builderTemplate, isNotNull);
      expect(builderTemplate!.interactionType, 'drag');
    });

    test('LearningAgeBand accurately manages developmental affordances', () {
      expect(LearningAgeBand.fromAge(4), LearningAgeBand.bandALittleExplorers);
      expect(LearningAgeBand.fromAge(5), LearningAgeBand.bandALittleExplorers);
      expect(LearningAgeBand.fromAge(6), LearningAgeBand.bandBYoungAdventurers);
      expect(LearningAgeBand.fromAge(7), LearningAgeBand.bandBYoungAdventurers);
      expect(LearningAgeBand.fromAge(8), LearningAgeBand.bandCGrowingSpeakers);
      expect(LearningAgeBand.fromAge(10), LearningAgeBand.bandCGrowingSpeakers);
      expect(LearningAgeBand.fromAge(11), LearningAgeBand.bandDConfidentSpeakers);

      expect(LearningAgeBand.bandALittleExplorers.requiresAudioAutoplay, isTrue);
      expect(LearningAgeBand.bandCGrowingSpeakers.requiresAudioAutoplay, isFalse);
      expect(LearningAgeBand.bandALittleExplorers.recommendedSessionMinutes, 5);
      expect(LearningAgeBand.bandDConfidentSpeakers.recommendedSessionMinutes, 15);
    });

    test('Phase 15 Regression: LearningAgeBand Band C spans Ages 8–10 strictly', () {
      expect(LearningAgeBand.bandCGrowingSpeakers.minAge, 8);
      expect(LearningAgeBand.bandCGrowingSpeakers.maxAge, 10);
      expect(LearningAgeBand.bandCGrowingSpeakers.displayName, contains('8–10'));
      expect(LearningAgeBand.fromAge(8), LearningAgeBand.bandCGrowingSpeakers);
      expect(LearningAgeBand.fromAge(9), LearningAgeBand.bandCGrowingSpeakers);
      expect(LearningAgeBand.fromAge(10), LearningAgeBand.bandCGrowingSpeakers);
      expect(LearningAgeBand.bandBYoungAdventurers.maxAge, 7);
      expect(LearningAgeBand.bandDConfidentSpeakers.displayName, contains('10–12+'));
    });

    test('SentencePattern dynamically populates slot values', () {
      const pattern = SentencePattern(
        id: 'pattern_test',
        template: 'I like {food} and {drink}.',
        examples: ['I like apples and water.'],
        variableSlots: ['food', 'drink'],
      );

      final result = pattern.populate({
        'food': 'sweet dates',
        'drink': 'fresh milk',
      });

      expect(result, 'I like sweet dates and fresh milk.');
    });

    test('ConceptProgressionGraph detects dependency cycles and paths', () {
      const c1 = LearningConcept(
        id: 'c1',
        type: ConceptType.vocabulary,
        canonicalText: 'apple',
        meaning: 'fruit',
        prerequisites: [],
      );
      const c2 = LearningConcept(
        id: 'c2',
        type: ConceptType.vocabulary,
        canonicalText: 'red apple',
        meaning: 'phrase',
        prerequisites: ['c1'],
      );
      const c3 = LearningConcept(
        id: 'c3',
        type: ConceptType.sentencePattern,
        canonicalText: 'I eat red apple',
        meaning: 'sentence',
        prerequisites: ['c2'],
      );

      final acyclicGraph = ConceptProgressionGraph({
        for (final c in [c1, c2, c3]) c.id: c,
      });
      expect(acyclicGraph.detectCycles(), isEmpty);

      final path = acyclicGraph.findProgressionPath('c1', 'c3');
      expect(path, equals(['c1', 'c2', 'c3']));

      // Create a cyclic graph: c1 -> c2 -> c3 -> c1
      const c1Cyclic = LearningConcept(
        id: 'c1',
        type: ConceptType.vocabulary,
        canonicalText: 'apple',
        meaning: 'fruit',
        prerequisites: ['c3'],
      );
      final cyclicGraph = ConceptProgressionGraph({
        for (final c in [c1Cyclic, c2, c3]) c.id: c,
      });
      expect(cyclicGraph.detectCycles().isNotEmpty, isTrue);
    });

    test('ReligiousContentSafety enforces scholar review requirements', () {
      expect(ReligiousContentType.hadithQuotation.requiresScholarReview, isTrue);
      expect(ReligiousContentType.quranicQuotation.requiresScholarReview, isTrue);
      expect(ReligiousContentType.directReligiousTeaching.requiresScholarReview, isTrue);
      expect(ReligiousContentType.generalMoralValue.requiresScholarReview, isFalse);
      expect(ReligiousContentType.lifestyleVocabulary.requiresScholarReview, isFalse);
    });

    test('LearningFeedbackService isolates sound effects and supports mock player', () async {
      final mockPlayer = MockFeedbackAudioPlayer();
      final feedbackService = LearningFeedbackService(
        audioPlayer: mockPlayer,
        debouncingWindow: const Duration(milliseconds: 100),
      );

      await feedbackService.triggerTap();
      expect(mockPlayer.playedSounds.length, 1);
      expect(mockPlayer.playedSounds.first, LearningSoundEffect.tap);

      // Rapid consecutive tap within debouncing window is ignored
      await feedbackService.triggerTap();
      expect(mockPlayer.playedSounds.length, 1);

      // Milestone celebration triggers proper sound
      await feedbackService.triggerMilestoneCelebration(isLevelComplete: true);
      expect(mockPlayer.playedSounds.contains(LearningSoundEffect.levelComplete), isTrue);

      feedbackService.dispose();
    });
  });
}
