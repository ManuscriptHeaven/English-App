import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_validator.dart';

void main() {
  group('CurriculumValidator Static Integrity Tests', () {
    test('Standard curriculum graph passes all static validation rules without errors', () {
      final graph = CurriculumGraph.standard();
      final report = CurriculumValidator.validate(graph);

      expect(report.isValid, isTrue);
      expect(report.errors, isEmpty);
      expect(graph.allConcepts.length, greaterThanOrEqualTo(6));
    });

    test('Detects missing prerequisite concept IDs in malformed graph', () {
      final invalidConcepts = {
        'concept_child': const CurriculumConcept(
          id: 'concept_child',
          word: 'Child',
          worldId: 'world_animal',
          unitId: 'unit_1',
          primaryLessonId: 'lesson_1',
          prerequisiteConceptIds: ['concept_non_existent'],
        ),
      };
      final graph = CurriculumGraph(invalidConcepts);
      final report = CurriculumValidator.validate(graph);

      expect(report.isValid, isFalse);
      expect(
        report.errors.any((err) => err.contains('concept_non_existent')),
        isTrue,
      );
    });

    test('Detects circular dependency cycles in prerequisite hierarchy', () {
      final cyclicConcepts = {
        'concept_a': const CurriculumConcept(
          id: 'concept_a',
          word: 'Concept A',
          worldId: 'world_animal',
          unitId: 'unit_1',
          primaryLessonId: 'lesson_1',
          prerequisiteConceptIds: ['concept_b'],
        ),
        'concept_b': const CurriculumConcept(
          id: 'concept_b',
          word: 'Concept B',
          worldId: 'world_animal',
          unitId: 'unit_1',
          primaryLessonId: 'lesson_1',
          prerequisiteConceptIds: ['concept_c'],
        ),
        'concept_c': const CurriculumConcept(
          id: 'concept_c',
          word: 'Concept C',
          worldId: 'world_animal',
          unitId: 'unit_1',
          primaryLessonId: 'lesson_1',
          prerequisiteConceptIds: ['concept_a'], // Cycle: A -> B -> C -> A
        ),
      };
      final graph = CurriculumGraph(cyclicConcepts);
      final report = CurriculumValidator.validate(graph);

      expect(report.isValid, isFalse);
      expect(
        report.errors.any((err) => err.contains('Circular prerequisite cycle detected')),
        isTrue,
      );
    });

    test('Detects self-referential prerequisite cycle', () {
      final selfCyclic = {
        'concept_loop': const CurriculumConcept(
          id: 'concept_loop',
          word: 'Loop',
          worldId: 'world_animal',
          unitId: 'unit_1',
          primaryLessonId: 'lesson_1',
          prerequisiteConceptIds: ['concept_loop'],
        ),
      };
      final graph = CurriculumGraph(selfCyclic);
      final report = CurriculumValidator.validate(graph);

      expect(report.isValid, isFalse);
      expect(
        report.errors.any((err) => err.contains('self-cycle')),
        isTrue,
      );
    });
  });
}
