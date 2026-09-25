import 'curriculum_graph.dart';

/// Report containing static validation results for curriculum graphs.
class CurriculumValidationReport {
  final List<String> errors;
  final List<String> warnings;

  const CurriculumValidationReport({
    this.errors = const [],
    this.warnings = const [],
  });

  bool get isValid => errors.isEmpty;

  @override
  String toString() {
    if (isValid && warnings.isEmpty) {
      return 'CurriculumValidationReport: Graph is 100% valid with 0 warnings.';
    }
    return 'CurriculumValidationReport(isValid: $isValid, errors: ${errors.length}, warnings: ${warnings.length})\n'
        'Errors:\n  - ${errors.join('\n  - ')}\n'
        'Warnings:\n  - ${warnings.join('\n  - ')}';
  }
}

/// Static validation engine to prevent corrupted, circular, or orphan curriculum relationships
/// from silently reaching children.
class CurriculumValidator {
  const CurriculumValidator();

  /// Validates a [CurriculumGraph] against integrity and dependency rules.
  static CurriculumValidationReport validate(CurriculumGraph graph) {
    final errors = <String>[];
    final warnings = <String>[];

    final concepts = graph.allConcepts;

    // 1. Validate empty graph
    if (concepts.isEmpty) {
      errors.add('Curriculum graph contains zero concepts.');
      return CurriculumValidationReport(errors: errors, warnings: warnings);
    }

    // 2. Validate prerequisites existence & detect self-dependencies
    for (final entry in concepts.entries) {
      final conceptId = entry.key;
      final concept = entry.value;

      // Key must match concept.id
      if (conceptId != concept.id) {
        errors.add('Concept key "$conceptId" does not match concept.id "${concept.id}".');
      }

      // World ID and Lesson ID must not be blank
      if (concept.worldId.trim().isEmpty) {
        errors.add('Concept "$conceptId" has an empty worldId.');
      }
      if (concept.primaryLessonId.trim().isEmpty) {
        errors.add('Concept "$conceptId" has an empty primaryLessonId.');
      }

      // Check prerequisites
      for (final prereqId in concept.prerequisiteConceptIds) {
        if (prereqId == conceptId) {
          errors.add('Concept "$conceptId" lists itself as a prerequisite (self-cycle).');
        } else if (!concepts.containsKey(prereqId)) {
          errors.add('Concept "$conceptId" references nonexistent prerequisite concept "$prereqId".');
        }
      }

      // Check related vocabulary references
      for (final relId in concept.relatedVocabularyIds) {
        if (!concepts.containsKey(relId)) {
          warnings.add('Concept "$conceptId" lists related vocabulary "$relId" which is not defined in the graph.');
        }
      }

      // Warnings for orphan concepts (no theme tags and no related stories)
      if (concept.themeTags.isEmpty && concept.relatedStoryIds.isEmpty) {
        warnings.add('Concept "$conceptId" has no themeTags and no relatedStoryIds (possible orphan).');
      }
    }

    // 3. Detect circular dependency cycles (DFS cycle detection)
    final visited = <String, int>{}; // 0 = unvisited, 1 = visiting, 2 = visited

    bool hasCycle(String currentId, List<String> path) {
      visited[currentId] = 1;
      path.add(currentId);

      final concept = concepts[currentId];
      if (concept != null) {
        for (final prereqId in concept.prerequisiteConceptIds) {
          if (!concepts.containsKey(prereqId)) continue; // Already flagged as nonexistent

          final state = visited[prereqId] ?? 0;
          if (state == 1) {
            // Cycle found!
            final cyclePath = [...path, prereqId].join(' -> ');
            errors.add('Circular prerequisite cycle detected: $cyclePath');
            return true;
          } else if (state == 0) {
            if (hasCycle(prereqId, path)) return true;
          }
        }
      }

      path.removeLast();
      visited[currentId] = 2;
      return false;
    }

    for (final conceptId in concepts.keys) {
      if ((visited[conceptId] ?? 0) == 0) {
        hasCycle(conceptId, []);
      }
    }

    return CurriculumValidationReport(
      errors: List.unmodifiable(errors),
      warnings: List.unmodifiable(warnings),
    );
  }
}
