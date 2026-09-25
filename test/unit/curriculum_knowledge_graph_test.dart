import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';

void main() {
  group('CurriculumKnowledgeGraph Tests', () {
    late CurriculumGraph graph;

    setUp(() {
      graph = CurriculumGraph.standard();
    });

    test('Standard curriculum graph contains core animal world concepts', () {
      final elephant = graph.getConcept('vocab_elephant');
      final lion = graph.getConcept('vocab_lion');
      final cat = graph.getConcept('vocab_cat');
      final bird = graph.getConcept('vocab_bird');
      final water = graph.getConcept('vocab_water');
      final clean = graph.getConcept('vocab_clean');
      final gentle = graph.getConcept('vocab_gentle');
      final big = graph.getConcept('vocab_big');
      final small = graph.getConcept('vocab_small');

      expect(elephant, isNotNull);
      expect(lion, isNotNull);
      expect(cat, isNotNull);
      expect(bird, isNotNull);
      expect(water, isNotNull);
      expect(clean, isNotNull);
      expect(gentle, isNotNull);
      expect(big, isNotNull);
      expect(small, isNotNull);
    });

    test('Retrieves all concepts mapped to a specific world', () {
      final animalConcepts = graph.getConceptsForWorld('world_animal');
      expect(animalConcepts.length, greaterThanOrEqualTo(8));
      expect(animalConcepts.map((c) => c.word), containsAll(['Elephant', 'Lion', 'Cat', 'Bird']));
    });

    test('Retrieves concepts introduced in a specific lesson', () {
      final lessonConcepts = graph.getConceptsForLesson('activity_animal_vocab');
      expect(lessonConcepts, isNotEmpty);
      expect(lessonConcepts.any((c) => c.id == 'vocab_elephant'), isTrue);
    });

    test('Retrieves concepts reinforced in a story book', () {
      final storyConcepts = graph.getConceptsForStory('story_animal_park');
      expect(storyConcepts, isNotEmpty);
      expect(storyConcepts.map((c) => c.word), containsAll(['Elephant', 'Cat', 'Water']));
    });

    test('Finds related semantic concept pairings', () {
      final relatedBig = graph.getRelatedConcepts('vocab_big');
      expect(relatedBig.map((c) => c.id), contains('vocab_small'));

      final relatedSmall = graph.getRelatedConcepts('vocab_small');
      expect(relatedSmall.map((c) => c.id), contains('vocab_big'));

      final relatedWater = graph.getRelatedConcepts('vocab_water');
      expect(relatedWater.map((c) => c.id), contains('vocab_clean'));
    });

    test('Concepts connect to authentic Islamic value teachings', () {
      final elephant = graph.getConcept('vocab_elephant')!;
      expect(elephant.connectedValueIds, contains('value_kindness_animals'));

      final clean = graph.getConcept('vocab_clean')!;
      expect(clean.connectedValueIds, contains('value_cleanliness'));
    });

    test('Concepts declare target skill dimensions for multi-modal pedagogy', () {
      final elephant = graph.getConcept('vocab_elephant')!;
      expect(elephant.targetSkills, contains(SkillDimension.vocabularyRecognition));
      expect(elephant.targetSkills, contains(SkillDimension.vocabularyRecall));
      expect(elephant.sentencePattern, isNotEmpty);
    });
  });
}
