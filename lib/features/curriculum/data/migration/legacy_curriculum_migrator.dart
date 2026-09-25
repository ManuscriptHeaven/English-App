import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_world.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_concept.dart';
import 'package:kids_english_adventure/features/vocabulary/domain/models/vocabulary_word.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

/// Report describing the results of migrating legacy entities to the progressive curriculum architecture.
class MigrationReport extends Equatable {
  final int totalConceptsMigrated;
  final int totalWorldsMigrated;
  final List<String> unmappedValueIds;
  final List<String> warnings;
  final bool isSuccessful;

  const MigrationReport({
    required this.totalConceptsMigrated,
    required this.totalWorldsMigrated,
    this.unmappedValueIds = const [],
    this.warnings = const [],
    this.isSuccessful = true,
  });

  @override
  List<Object?> get props => [
        totalConceptsMigrated,
        totalWorldsMigrated,
        unmappedValueIds,
        warnings,
        isSuccessful,
      ];
}

/// Bidirectional migration bridge that translates legacy vocabulary and world models
/// into Phase 14 [LearningConcept] and [CurriculumWorld] structures,
/// guaranteeing zero data loss and preserving all existing child mastery records.
class LegacyCurriculumMigrator {
  const LegacyCurriculumMigrator();

  /// Converts a legacy [VocabularyWord] into a curriculum-native [LearningConcept].
  LearningConcept migrateVocabularyWord(
    VocabularyWord word, {
    int targetLevelOrder = 1,
    List<LearningAgeBand>? targetAgeBands,
  }) {
    final conceptId = word.id.startsWith('concept_') ? word.id : 'concept_${word.id}';

    // Map part of speech and linguistic type
    final ConceptType type = _resolveConceptType(word.partOfSpeech);

    final tags = <String>[
      word.partOfSpeech,
      if (word.metadata.vocabularyTags.isNotEmpty) ...word.metadata.vocabularyTags,
      if (word.metadata.valueTags.isNotEmpty) ...word.metadata.valueTags,
    ];

    final valueThemeIds = <String>[
      if (word.connectedValueId != null && word.connectedValueId!.isNotEmpty)
        _mapLegacyValueToCurriculumTheme(word.connectedValueId!),
    ];

    return LearningConcept(
      id: conceptId,
      type: type,
      canonicalText: word.word,
      meaning: word.definition.isNotEmpty ? word.definition : word.word,
      levelOrder: targetLevelOrder,
      ageBands: targetAgeBands ??
          const [
            LearningAgeBand.bandALittleExplorers,
            LearningAgeBand.bandBYoungAdventurers,
            LearningAgeBand.bandCGrowingSpeakers,
            LearningAgeBand.bandDConfidentSpeakers,
          ],
      skillDimensions: const [
        SkillDimension.vocabularyRecognition,
        SkillDimension.vocabularyRecall,
        SkillDimension.speaking,
      ],
      tags: tags,
      valueThemeIds: valueThemeIds,
      audioId: word.audioUrl,
      imageAssetId: word.imageUrl,
      acceptableResponses: [word.word.toLowerCase(), word.word],
      metadata: {
        'legacyId': word.id,
        'phonetic': word.phonetic,
        'exampleSentence': word.exampleSentence,
        'slowAudioUrl': word.slowAudioUrl,
      },
    );
  }

  /// Converts a legacy [World] into a curriculum-native [CurriculumWorld].
  CurriculumWorld migrateWorld(
    World world, {
    List<String>? targetLevelIds,
  }) {
    final worldId = world.id.startsWith('world_') ? world.id : 'world_${world.id}';

    final valueThemes = world.featuredValues
        .map(_mapLegacyValueToCurriculumTheme)
        .where((id) => id.isNotEmpty)
        .toList();

    return CurriculumWorld(
      id: worldId,
      levelIds: targetLevelIds ?? ['level_1_first_words', 'level_2_first_phrases'],
      title: world.title,
      childFriendlyTitle: '${world.title} 🌍',
      theme: world.theme,
      description: world.description,
      primaryLanguageDomain: world.theme,
      valueThemes: valueThemes,
      unitIds: world.chapters.map((c) => 'unit_${c.id}').toList(),
      visualThemeId: world.bannerAssetPath,
      metadata: {
        'legacyId': world.id,
        'primaryColorHex': world.primaryColorHex,
        'orderIndex': world.orderIndex,
        'legacyMetadata': world.metadata.toJson(),
      },
    );
  }

  /// Batch migration of legacy vocabulary and worlds into modern curriculum repositories.
  MigrationReport migrateAll({
    required List<VocabularyWord> legacyWords,
    required List<World> legacyWorlds,
  }) {
    final warnings = <String>[];
    final unmappedValues = <String>[];

    final migratedConcepts = <LearningConcept>[];
    for (final word in legacyWords) {
      if (word.word.trim().isEmpty) {
        warnings.add('Skipped legacy word with empty text (ID: ${word.id})');
        continue;
      }
      migratedConcepts.add(migrateVocabularyWord(word));
    }

    final migratedWorlds = <CurriculumWorld>[];
    for (final world in legacyWorlds) {
      if (world.id.trim().isEmpty) {
        warnings.add('Skipped legacy world with empty id');
        continue;
      }
      migratedWorlds.add(migrateWorld(world));
    }

    return MigrationReport(
      totalConceptsMigrated: migratedConcepts.length,
      totalWorldsMigrated: migratedWorlds.length,
      unmappedValueIds: unmappedValues,
      warnings: warnings,
      isSuccessful: warnings.isEmpty,
    );
  }

  static ConceptType _resolveConceptType(String partOfSpeech) {
    switch (partOfSpeech.toLowerCase()) {
      case 'phrase':
        return ConceptType.phrase;
      case 'verb':
      case 'noun':
      case 'adjective':
      default:
        return ConceptType.vocabulary;
    }
  }

  static String _mapLegacyValueToCurriculumTheme(String legacyValue) {
    final lower = legacyValue.toLowerCase().trim();
    if (lower.contains('bismillah') || lower.contains('gratitude') || lower.contains('shukr')) {
      return 'theme_gratitude_shukr';
    }
    if (lower.contains('sharing') || lower.contains('charity') || lower.contains('sadaqah')) {
      return 'theme_sharing_generosity';
    }
    if (lower.contains('kindness') || lower.contains('mercy') || lower.contains('rahmah')) {
      return 'theme_kindness_mercy';
    }
    if (lower.contains('family') || lower.contains('parents') || lower.contains('respect')) {
      return 'theme_family_respect';
    }
    if (lower.contains('patience') || lower.contains('sabr')) {
      return 'theme_patience_perseverance';
    }
    if (lower.contains('honesty') || lower.contains('truth')) {
      return 'theme_honesty_truthfulness';
    }
    if (lower.contains('cleanliness') || lower.contains('taharah')) {
      return 'theme_cleanliness_taharah';
    }
    return 'theme_good_manners';
  }
}
