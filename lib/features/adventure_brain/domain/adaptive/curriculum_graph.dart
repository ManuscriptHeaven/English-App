import 'package:equatable/equatable.dart';
import 'skill_dimension.dart';

/// Relationship link type between two curriculum nodes.
enum CurriculumRelation {
  belongsToWorld,
  belongsToUnit,
  introducedInLesson,
  reinforcedInStory,
  exemplifiesValue,
  usesSentencePattern,
  sharesThemeWith,
  antonymOf,
  synonymOf,
}

/// A structured vocabulary concept node in the curriculum knowledge graph.
class CurriculumConcept extends Equatable {
  final String id;
  final String word;
  final String worldId;
  final String unitId;
  final String primaryLessonId;
  final List<String> themeTags;
  final List<String> relatedStoryIds;
  final List<String> connectedValueIds;
  final List<String> relatedVocabularyIds;
  final List<String> prerequisiteConceptIds;
  final int conceptualDifficulty; // 1 (basic concrete noun) to 5 (abstract concept)
  final String ageBand; // 'toddler', 'earlyExplorer', 'fluentExplorer'
  final List<SkillDimension> targetSkills;
  final String sentencePattern;

  const CurriculumConcept({
    required this.id,
    required this.word,
    required this.worldId,
    required this.unitId,
    required this.primaryLessonId,
    this.themeTags = const [],
    this.relatedStoryIds = const [],
    this.connectedValueIds = const [],
    this.relatedVocabularyIds = const [],
    this.prerequisiteConceptIds = const [],
    this.conceptualDifficulty = 1,
    this.ageBand = 'earlyExplorer',
    this.targetSkills = const [
      SkillDimension.vocabularyRecognition,
      SkillDimension.vocabularyRecall,
    ],
    this.sentencePattern = 'This is a {word}.',
  });

  @override
  List<Object?> get props => [
        id,
        word,
        worldId,
        unitId,
        primaryLessonId,
        themeTags,
        relatedStoryIds,
        connectedValueIds,
        relatedVocabularyIds,
        prerequisiteConceptIds,
        conceptualDifficulty,
        ageBand,
        targetSkills,
        sentencePattern,
      ];
}

/// Structured curriculum relationship graph linking worlds, lessons, vocabulary,
/// stories, and values across the application.
class CurriculumGraph {
  final Map<String, CurriculumConcept> _concepts;
  final Map<String, List<String>> _worldConcepts;
  final Map<String, List<String>> _lessonConcepts;
  final Map<String, List<String>> _storyConcepts;

  CurriculumGraph(Map<String, CurriculumConcept> concepts)
      : _concepts = Map.unmodifiable(concepts),
        _worldConcepts = _indexByWorld(concepts),
        _lessonConcepts = _indexByLesson(concepts),
        _storyConcepts = _indexByStory(concepts);

  static Map<String, List<String>> _indexByWorld(Map<String, CurriculumConcept> concepts) {
    final map = <String, List<String>>{};
    for (final c in concepts.values) {
      map.putIfAbsent(c.worldId, () => []).add(c.id);
    }
    return map;
  }

  static Map<String, List<String>> _indexByLesson(Map<String, CurriculumConcept> concepts) {
    final map = <String, List<String>>{};
    for (final c in concepts.values) {
      map.putIfAbsent(c.primaryLessonId, () => []).add(c.id);
    }
    return map;
  }

  static Map<String, List<String>> _indexByStory(Map<String, CurriculumConcept> concepts) {
    final map = <String, List<String>>{};
    for (final c in concepts.values) {
      for (final storyId in c.relatedStoryIds) {
        map.putIfAbsent(storyId, () => []).add(c.id);
      }
    }
    return map;
  }

  /// Retrieves a concept by ID.
  CurriculumConcept? getConcept(String vocabularyId) => _concepts[vocabularyId];

  /// All concepts linked to a given world ID.
  List<CurriculumConcept> getConceptsForWorld(String worldId) {
    final ids = _worldConcepts[worldId] ?? [];
    return ids.map((id) => _concepts[id]!).toList();
  }

  /// All concepts introduced in a given lesson ID.
  List<CurriculumConcept> getConceptsForLesson(String lessonId) {
    final ids = _lessonConcepts[lessonId] ?? [];
    return ids.map((id) => _concepts[id]!).toList();
  }

  /// All concepts reinforced in a given story ID.
  List<CurriculumConcept> getConceptsForStory(String storyId) {
    final ids = _storyConcepts[storyId] ?? [];
    return ids.map((id) => _concepts[id]!).toList();
  }

  /// Exposes all concept nodes in the graph.
  Map<String, CurriculumConcept> get allConcepts => _concepts;

  /// Finds related vocabulary concepts (e.g. synonyms, antonyms, shared theme).
  List<CurriculumConcept> getRelatedConcepts(String vocabularyId) {
    final concept = _concepts[vocabularyId];
    if (concept == null) return [];
    return concept.relatedVocabularyIds
        .map((id) => _concepts[id])
        .whereType<CurriculumConcept>()
        .toList();
  }

  /// Finds prerequisite concepts that should be familiar before learning this concept.
  List<CurriculumConcept> getPrerequisites(String vocabularyId) {
    final concept = _concepts[vocabularyId];
    if (concept == null) return [];
    return concept.prerequisiteConceptIds
        .map((id) => _concepts[id])
        .whereType<CurriculumConcept>()
        .toList();
  }

  /// Determines whether all prerequisites for a given concept have been satisfied.
  bool arePrerequisitesMet(String vocabularyId, Set<String> satisfiedConceptIds) {
    final concept = _concepts[vocabularyId];
    if (concept == null) return true;
    if (concept.prerequisiteConceptIds.isEmpty) return true;
    return concept.prerequisiteConceptIds.every((id) => satisfiedConceptIds.contains(id));
  }

  /// Finds concepts that depend on the given concept as a prerequisite.
  List<CurriculumConcept> getDependents(String vocabularyId) {
    return _concepts.values
        .where((c) => c.prerequisiteConceptIds.contains(vocabularyId))
        .toList();
  }

  /// Pre-populated standard curriculum graph with authentic content relationships.
  static CurriculumGraph standard() {
    final concepts = <String, CurriculumConcept>{
      // World 1: Animal Adventure
      'vocab_elephant': const CurriculumConcept(
        id: 'vocab_elephant',
        word: 'Elephant',
        worldId: 'world_animal',
        unitId: 'unit_savannah',
        primaryLessonId: 'activity_animal_vocab',
        themeTags: ['animals', 'big', 'gentle', 'wild'],
        relatedStoryIds: ['story_animal_park'],
        connectedValueIds: ['value_kindness_animals'],
        relatedVocabularyIds: ['vocab_big', 'vocab_small'],
        conceptualDifficulty: 1,
        ageBand: 'toddler',
        targetSkills: [
          SkillDimension.vocabularyRecognition,
          SkillDimension.vocabularyRecall,
          SkillDimension.pronunciation,
        ],
        sentencePattern: 'The elephant is big and gentle.',
      ),
      'vocab_lion': const CurriculumConcept(
        id: 'vocab_lion',
        word: 'Lion',
        worldId: 'world_animal',
        unitId: 'unit_savannah',
        primaryLessonId: 'activity_animal_vocab',
        themeTags: ['animals', 'brave', 'wild'],
        relatedStoryIds: ['story_animal_park'],
        connectedValueIds: ['value_kindness_animals'],
        relatedVocabularyIds: ['vocab_cat'],
        conceptualDifficulty: 1,
        ageBand: 'toddler',
        targetSkills: [
          SkillDimension.vocabularyRecognition,
          SkillDimension.vocabularyRecall,
        ],
        sentencePattern: 'The brave lion rests quietly.',
      ),
      'vocab_cat': const CurriculumConcept(
        id: 'vocab_cat',
        word: 'Cat',
        worldId: 'world_animal',
        unitId: 'unit_pets',
        primaryLessonId: 'activity_animal_vocab',
        themeTags: ['animals', 'pet', 'gentle', 'small'],
        relatedStoryIds: ['story_animal_park'],
        connectedValueIds: ['value_kindness_animals'],
        relatedVocabularyIds: ['vocab_lion', 'vocab_small'],
        conceptualDifficulty: 1,
        ageBand: 'toddler',
        sentencePattern: 'The kitten drinks clean water.',
      ),
      'vocab_bird': const CurriculumConcept(
        id: 'vocab_bird',
        word: 'Bird',
        worldId: 'world_animal',
        unitId: 'unit_forest',
        primaryLessonId: 'activity_animal_vocab',
        themeTags: ['animals', 'fly', 'tree'],
        relatedStoryIds: ['story_animal_park'],
        connectedValueIds: ['value_kindness_animals'],
        conceptualDifficulty: 1,
        ageBand: 'toddler',
        sentencePattern: 'A colorful bird sings high in the tree.',
      ),
      'vocab_water': const CurriculumConcept(
        id: 'vocab_water',
        word: 'Water',
        worldId: 'world_animal',
        unitId: 'unit_savannah',
        primaryLessonId: 'activity_animal_vocab',
        themeTags: ['nature', 'clean', 'drink'],
        relatedStoryIds: ['story_animal_park'],
        connectedValueIds: ['value_kindness_animals'],
        relatedVocabularyIds: ['vocab_clean'],
        conceptualDifficulty: 1,
        ageBand: 'earlyExplorer',
        sentencePattern: 'Ayaan brings clean water for the cat.',
      ),
      'vocab_clean': const CurriculumConcept(
        id: 'vocab_clean',
        word: 'Clean',
        worldId: 'world_animal',
        unitId: 'unit_pets',
        primaryLessonId: 'activity_animal_vocab',
        themeTags: ['adjective', 'taharah', 'water'],
        relatedStoryIds: ['story_animal_park'],
        connectedValueIds: ['value_kindness_animals', 'value_cleanliness'],
        relatedVocabularyIds: ['vocab_water'],
        prerequisiteConceptIds: ['vocab_water'],
        conceptualDifficulty: 2,
        ageBand: 'earlyExplorer',
        sentencePattern: 'The water is fresh and clean.',
      ),
      'vocab_gentle': const CurriculumConcept(
        id: 'vocab_gentle',
        word: 'Gentle',
        worldId: 'world_animal',
        unitId: 'unit_pets',
        primaryLessonId: 'activity_animal_vocab',
        themeTags: ['adjective', 'rahmah', 'manner'],
        relatedStoryIds: ['story_animal_park'],
        connectedValueIds: ['value_kindness_animals'],
        prerequisiteConceptIds: ['vocab_cat'],
        conceptualDifficulty: 2,
        ageBand: 'earlyExplorer',
        sentencePattern: 'We use gentle hands with living creatures.',
      ),
      'vocab_big': const CurriculumConcept(
        id: 'vocab_big',
        word: 'Big',
        worldId: 'world_animal',
        unitId: 'unit_savannah',
        primaryLessonId: 'activity_animal_vocab',
        themeTags: ['size', 'opposite'],
        relatedStoryIds: ['story_animal_park'],
        relatedVocabularyIds: ['vocab_small', 'vocab_elephant'],
        prerequisiteConceptIds: ['vocab_elephant'],
        conceptualDifficulty: 2,
        ageBand: 'earlyExplorer',
        sentencePattern: 'The elephant is very big.',
      ),
      'vocab_small': const CurriculumConcept(
        id: 'vocab_small',
        word: 'Small',
        worldId: 'world_animal',
        unitId: 'unit_pets',
        primaryLessonId: 'activity_animal_vocab',
        themeTags: ['size', 'opposite'],
        relatedStoryIds: ['story_animal_park'],
        relatedVocabularyIds: ['vocab_big', 'vocab_cat'],
        prerequisiteConceptIds: ['vocab_big'],
        conceptualDifficulty: 2,
        ageBand: 'earlyExplorer',
        sentencePattern: 'The little ant is very small.',
      ),
    };

    return CurriculumGraph(concepts);
  }
}
