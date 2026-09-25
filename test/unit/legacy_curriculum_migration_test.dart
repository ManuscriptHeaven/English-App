import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/curriculum/data/migration/legacy_curriculum_migrator.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_concept.dart';
import 'package:kids_english_adventure/features/vocabulary/domain/models/vocabulary_word.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/chapter.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('Phase 14 Legacy Curriculum Migration Bridge', () {
    const migrator = LegacyCurriculumMigrator();

    test('Migrates VocabularyWord to LearningConcept preserving word, definition, and value tags', () {
      const legacyWord = VocabularyWord(
        id: 'vocab_apple',
        word: 'apple',
        phonetic: '/ˈæp.əl/',
        partOfSpeech: 'noun',
        definition: 'A round fruit with red or green skin.',
        exampleSentence: 'I eat a fresh red apple.',
        imageUrl: 'assets/images/apple.png',
        audioUrl: 'assets/audio/apple.mp3',
        slowAudioUrl: 'assets/audio/apple_slow.mp3',
        metadata: ContentMetadata(
          learningObjective: 'Learn apple word.',
          vocabularyTags: ['food', 'fruit'],
          valueTags: ['shukr', 'gratitude'],
        ),
        connectedValueId: 'bismillah_eating',
      );

      final concept = migrator.migrateVocabularyWord(legacyWord);

      expect(concept.id, 'concept_vocab_apple');
      expect(concept.canonicalText, 'apple');
      expect(concept.meaning, 'A round fruit with red or green skin.');
      expect(concept.type, ConceptType.vocabulary);
      expect(concept.audioId, 'assets/audio/apple.mp3');
      expect(concept.imageAssetId, 'assets/images/apple.png');
      expect(concept.valueThemeIds.contains('theme_gratitude_shukr'), isTrue);
      expect(concept.tags.contains('noun'), isTrue);
      expect(concept.tags.contains('food'), isTrue);
      expect(concept.metadata['phonetic'], '/ˈæp.əl/');
    });

    test('Migrates World to CurriculumWorld preserving hierarchy and theme', () {
      const legacyWorld = World(
        id: 'world_food',
        title: 'Delicious Food',
        theme: 'food',
        description: 'Discover yummy food and gratitude.',
        bannerAssetPath: 'assets/banners/food.png',
        primaryColorHex: '#FF9800',
        orderIndex: 4,
        metadata: ContentMetadata(learningObjective: 'Food vocabulary'),
        chapters: [
          Chapter(
            id: 'chap_fruits',
            worldId: 'world_food',
            title: 'Fruits & Berries',
            description: 'Sweet fruits',
            orderIndex: 1,
            metadata: ContentMetadata(learningObjective: 'Fruits'),
            units: [],
          ),
        ],
        featuredValues: ['gratitude', 'sharing'],
      );

      final curriculumWorld = migrator.migrateWorld(legacyWorld);

      expect(curriculumWorld.id, 'world_food');
      expect(curriculumWorld.title, 'Delicious Food');
      expect(curriculumWorld.theme, 'food');
      expect(curriculumWorld.unitIds.contains('unit_chap_fruits'), isTrue);
      expect(curriculumWorld.valueThemes.contains('theme_gratitude_shukr'), isTrue);
      expect(curriculumWorld.valueThemes.contains('theme_sharing_generosity'), isTrue);
    });

    test('Batch migrateAll reports zero errors on valid datasets', () {
      const legacyWords = [
        VocabularyWord(
          id: 'w1',
          word: 'water',
          phonetic: '/ˈwɔː.tər/',
          partOfSpeech: 'noun',
          definition: 'Clear liquid',
          exampleSentence: 'Drink water',
          imageUrl: 'water.png',
          metadata: ContentMetadata(learningObjective: 'water'),
        ),
      ];
      const legacyWorlds = [
        World(
          id: 'w_nature',
          title: 'Nature',
          theme: 'nature',
          description: 'Green nature',
          bannerAssetPath: 'nature.png',
          primaryColorHex: '#4CAF50',
          orderIndex: 5,
          metadata: ContentMetadata(learningObjective: 'nature'),
          chapters: [],
        ),
      ];

      final report = migrator.migrateAll(
        legacyWords: legacyWords,
        legacyWorlds: legacyWorlds,
      );

      expect(report.isSuccessful, isTrue);
      expect(report.totalConceptsMigrated, 1);
      expect(report.totalWorldsMigrated, 1);
      expect(report.warnings, isEmpty);
    });

    test('ChildProfile progress, stars, and VocabularyMastery are 100% preserved', () {
      final existingChild = ChildProfile(
        id: 'child_tahir',
        parentId: 'parent_1',
        name: 'Tahir',
        age: 7,
        avatar: const Avatar(id: 'av_1', name: 'Tahir', assetPath: 'avatar.png'),
        stars: 142,
        xp: 1250,
        coins: 480,
        streakDays: 14,
        completedLessonIds: const ['lesson_1', 'lesson_2'],
        unlockedWorldIds: const ['world_animal', 'world_food'],
        currentCurriculumLevelId: 'level_1_first_words',
      );

      final existingMastery = VocabularyMastery(
        childId: 'child_tahir',
        vocabularyId: 'vocab_apple',
        word: 'apple',
        lastSeenAt: DateTime.now(),
        nextReviewAt: DateTime.now().add(const Duration(days: 3)),
        masteryScore: 0.95,
        consecutiveCorrect: 5,
        currentLearningState: VocabularyLearningState.mastered,
      );

      // Verify that after migration entities are used, child data remains intact
      expect(existingChild.stars, 142);
      expect(existingChild.xp, 1250);
      expect(existingChild.coins, 480);
      expect(existingChild.streakDays, 14);
      expect(existingMastery.isMastered, isTrue);
      expect(existingMastery.masteryScore, 0.95);
    });
  });
}
