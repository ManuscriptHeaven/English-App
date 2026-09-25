import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'curriculum_graph.dart';
import 'vocabulary_mastery.dart';

/// Structured snapshot of a child's curriculum progression.
class CurriculumProgressionState extends Equatable {
  final List<String> accessibleConceptIds;
  final List<String> recommendedConceptIds;
  final List<String> completedConceptIds;
  final List<String> masteredConceptIds;
  final List<String> lockedConceptIds;
  final int totalConceptsCount;

  const CurriculumProgressionState({
    required this.accessibleConceptIds,
    required this.recommendedConceptIds,
    required this.completedConceptIds,
    required this.masteredConceptIds,
    required this.lockedConceptIds,
    required this.totalConceptsCount,
  });

  double get completionPercentage =>
      totalConceptsCount > 0 ? (masteredConceptIds.length / totalConceptsCount).clamp(0.0, 1.0) : 0.0;

  @override
  List<Object?> get props => [
        accessibleConceptIds,
        recommendedConceptIds,
        completedConceptIds,
        masteredConceptIds,
        lockedConceptIds,
        totalConceptsCount,
      ];
}

/// Evaluates curriculum prerequisites, unlock conditions, and recommends the next best concepts.
class CurriculumProgressionEngine {
  const CurriculumProgressionEngine();

  /// Computes the complete progression state for a child profile given their masteries.
  CurriculumProgressionState getProgressionState({
    required ChildProfile child,
    required List<VocabularyMastery> masteries,
    required CurriculumGraph graph,
    String? targetWorldId,
  }) {
    final masteryMap = {for (final m in masteries) m.vocabularyId: m};

    // Filter concepts by targetWorldId if supplied, or all concepts in unlocked worlds
    final concepts = targetWorldId != null
        ? graph.getConceptsForWorld(targetWorldId)
        : graph.allConcepts.values.where((c) {
            return child.unlockedWorldIds.contains(c.worldId);
          }).toList();

    final masteredIds = <String>[];
    final completedIds = <String>[];
    final accessibleIds = <String>[];
    final lockedIds = <String>[];

    // Mastered set includes words with masteryScore >= 0.8 or isMastered
    final masteredSet = <String>{};
    for (final m in masteries) {
      if (m.isMastered || m.masteryScore >= 0.8) {
        masteredSet.add(m.vocabularyId);
      }
    }

    for (final concept in concepts) {
      final m = masteryMap[concept.id];
      if (m != null && (m.isMastered || m.masteryScore >= 0.8)) {
        masteredIds.add(concept.id);
      } else if (m != null && m.currentLearningState != VocabularyLearningState.newWord) {
        completedIds.add(concept.id);
      }

      // Check prerequisite unlock conditions
      final prereqsMet = graph.arePrerequisitesMet(concept.id, masteredSet);
      if (prereqsMet) {
        if (!masteredSet.contains(concept.id)) {
          accessibleIds.add(concept.id);
        }
      } else {
        lockedIds.add(concept.id);
      }
    }

    final recommendedIds = getNextRecommendedConcepts(
      child: child,
      masteries: masteries,
      graph: graph,
      targetWorldId: targetWorldId,
      limit: 3,
    );

    return CurriculumProgressionState(
      accessibleConceptIds: accessibleIds,
      recommendedConceptIds: recommendedIds,
      completedConceptIds: completedIds,
      masteredConceptIds: masteredIds,
      lockedConceptIds: lockedIds,
      totalConceptsCount: concepts.length,
    );
  }

  /// Recommends the top concepts that are accessible, developmentally matched,
  /// and prioritize words currently in introduced/learning states or lowest difficulty unstarted.
  List<String> getNextRecommendedConcepts({
    required ChildProfile child,
    required List<VocabularyMastery> masteries,
    required CurriculumGraph graph,
    String? targetWorldId,
    int limit = 3,
  }) {
    final masteryMap = {for (final m in masteries) m.vocabularyId: m};
    final masteredSet = <String>{};
    for (final m in masteries) {
      if (m.isMastered || m.masteryScore >= 0.8) {
        masteredSet.add(m.vocabularyId);
      }
    }

    final concepts = targetWorldId != null
        ? graph.getConceptsForWorld(targetWorldId)
        : graph.allConcepts.values.where((c) => child.unlockedWorldIds.contains(c.worldId)).toList();

    // Filter to accessible and unmastered concepts
    final candidates = concepts.where((c) {
      if (masteredSet.contains(c.id)) return false;
      return graph.arePrerequisitesMet(c.id, masteredSet);
    }).toList();

    // Sort by:
    // 1. In-progress concepts (learning or introduced) first for consolidation
    // 2. Developmental age match (e.g. toddler vs earlyExplorer)
    // 3. Lower conceptual difficulty first
    candidates.sort((a, b) {
      final mA = masteryMap[a.id];
      final mB = masteryMap[b.id];

      final inProgressA = mA != null && mA.currentLearningState != VocabularyLearningState.newWord ? 1 : 0;
      final inProgressB = mB != null && mB.currentLearningState != VocabularyLearningState.newWord ? 1 : 0;
      if (inProgressA != inProgressB) {
        return inProgressB.compareTo(inProgressA); // In-progress first
      }

      // Age band preference
      final ageBandA = _ageBandScore(a.ageBand, child.age);
      final ageBandB = _ageBandScore(b.ageBand, child.age);
      if (ageBandA != ageBandB) {
        return ageBandB.compareTo(ageBandA);
      }

      // Conceptual difficulty
      return a.conceptualDifficulty.compareTo(b.conceptualDifficulty);
    });

    return candidates.take(limit).map((c) => c.id).toList();
  }

  int _ageBandScore(String ageBand, int childAge) {
    if (childAge <= 4 && ageBand == 'toddler') return 3;
    if (childAge >= 5 && childAge <= 6 && ageBand == 'earlyExplorer') return 3;
    if (childAge >= 7 && ageBand == 'fluentExplorer') return 3;
    return 1;
  }

  /// Explains why a concept has a given state for educators or parents.
  String explainConceptStatus(
    String conceptId, {
    required List<VocabularyMastery> masteries,
    required CurriculumGraph graph,
  }) {
    final concept = graph.getConcept(conceptId);
    if (concept == null) return 'Unknown concept.';

    final mastery = masteries.firstWhere(
      (m) => m.vocabularyId == conceptId,
      orElse: () => VocabularyMastery.initial(childId: '', vocabularyId: conceptId, word: concept.word),
    );

    if (mastery.isMastered || mastery.masteryScore >= 0.8) {
      return 'Mastered! Solid accuracy across multiple contexts.';
    }
    if (mastery.currentLearningState == VocabularyLearningState.struggling) {
      return 'Needs gentle reinforcement and guided practice.';
    }
    if (mastery.currentLearningState == VocabularyLearningState.learning ||
        mastery.currentLearningState == VocabularyLearningState.introduced) {
      return 'In progress: actively being practiced.';
    }

    final masteredSet = masteries
        .where((m) => m.isMastered || m.masteryScore >= 0.8)
        .map((m) => m.vocabularyId)
        .toSet();

    if (graph.arePrerequisitesMet(conceptId, masteredSet)) {
      return 'Ready to explore! Prerequisites are fulfilled.';
    }

    final missing = graph.getPrerequisites(conceptId).where((p) => !masteredSet.contains(p.id)).toList();
    final names = missing.map((m) => '"${m.word}"').join(', ');
    return 'Locked: Requires mastering prerequisite $names first.';
  }
}
