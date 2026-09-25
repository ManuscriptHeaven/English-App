import 'learning_concept.dart';

/// Explicit dependency progression graph linking concepts across foundational vocabulary,
/// phrases, sentence patterns, functional requests, dialogues, and stories.
class ConceptProgressionGraph {
  final Map<String, LearningConcept> _concepts;
  final Map<String, List<String>> _dependents;

  ConceptProgressionGraph(Map<String, LearningConcept> concepts)
      : _concepts = Map.unmodifiable(concepts),
        _dependents = _buildDependentsMap(concepts);

  static Map<String, List<String>> _buildDependentsMap(Map<String, LearningConcept> concepts) {
    final map = <String, List<String>>{};
    for (final c in concepts.values) {
      for (final p in c.prerequisites) {
        map.putIfAbsent(p, () => []).add(c.id);
      }
    }
    return map;
  }

  Map<String, LearningConcept> get allConcepts => _concepts;

  LearningConcept? getConcept(String id) => _concepts[id];

  bool contains(String id) => _concepts.containsKey(id);

  List<LearningConcept> getPrerequisites(String id) {
    final concept = _concepts[id];
    if (concept == null) return [];
    return concept.prerequisites.map((pId) => _concepts[pId]).whereType<LearningConcept>().toList();
  }

  List<LearningConcept> getDependents(String id) {
    final depIds = _dependents[id] ?? [];
    return depIds.map((dId) => _concepts[dId]).whereType<LearningConcept>().toList();
  }

  /// Determines whether all required prerequisites are satisfied in the learner's mastered set.
  bool arePrerequisitesMet(String conceptId, Set<String> masteredConceptIds) {
    final concept = _concepts[conceptId];
    if (concept == null) return true;
    if (concept.prerequisites.isEmpty) return true;
    return concept.prerequisites.every((p) => masteredConceptIds.contains(p));
  }

  /// Finds the progressive dependency path from a foundational word to an advanced communicative concept.
  List<String> findProgressionPath(String startConceptId, String targetConceptId) {
    final queue = <List<String>>[
      [startConceptId]
    ];
    final visited = <String>{startConceptId};

    while (queue.isNotEmpty) {
      final path = queue.removeAt(0);
      final current = path.last;

      if (current == targetConceptId) {
        return path;
      }

      for (final next in _dependents[current] ?? []) {
        if (!visited.contains(next)) {
          visited.add(next);
          queue.add([...path, next]);
        }
      }
    }
    return [];
  }

  /// Detects any circular prerequisite loops within the graph.
  List<String> detectCycles() {
    final cycles = <String>[];
    final visited = <String, int>{}; // 0=unvisited, 1=visiting, 2=visited

    bool hasCycle(String currentId, List<String> path) {
      visited[currentId] = 1;
      path.add(currentId);

      final concept = _concepts[currentId];
      if (concept != null) {
        for (final prereq in concept.prerequisites) {
          if (!_concepts.containsKey(prereq)) continue;
          final state = visited[prereq] ?? 0;
          if (state == 1) {
            cycles.add([...path, prereq].join(' -> '));
            return true;
          } else if (state == 0) {
            if (hasCycle(prereq, path)) return true;
          }
        }
      }

      path.removeLast();
      visited[currentId] = 2;
      return false;
    }

    for (final id in _concepts.keys) {
      if ((visited[id] ?? 0) == 0) {
        hasCycle(id, []);
      }
    }
    return cycles;
  }
}
