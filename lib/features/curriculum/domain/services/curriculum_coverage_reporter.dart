import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import '../models/learning_age_band.dart';
import '../repositories/curriculum_repository.dart';

/// Statistical telemetry report describing curriculum depth, speaking balance,
/// and value-theme coverage.
class CurriculumCoverageReport extends Equatable {
  final int totalLevels;
  final int totalWorlds;
  final int totalUnits;
  final int totalLessons;
  final int totalConcepts;
  final int totalSentencePatterns;
  final int totalConversationFunctions;
  final int totalStories;
  final int speakingObjectivesCount;
  final int listeningObjectivesCount;
  final Map<int, int> conceptsPerLevel;
  final Map<int, int> lessonsPerLevel;
  final Map<String, int> unitsPerWorld;
  final Map<LearningAgeBand, int> conceptsPerAgeBand;
  final Map<String, int> conceptsPerValueTheme;
  final List<String> conceptsWithoutPrerequisites;

  const CurriculumCoverageReport({
    required this.totalLevels,
    required this.totalWorlds,
    required this.totalUnits,
    required this.totalLessons,
    required this.totalConcepts,
    required this.totalSentencePatterns,
    required this.totalConversationFunctions,
    required this.totalStories,
    required this.speakingObjectivesCount,
    required this.listeningObjectivesCount,
    required this.conceptsPerLevel,
    required this.lessonsPerLevel,
    required this.unitsPerWorld,
    required this.conceptsPerAgeBand,
    required this.conceptsPerValueTheme,
    required this.conceptsWithoutPrerequisites,
  });

  double get speakingToListeningRatio =>
      listeningObjectivesCount > 0 ? speakingObjectivesCount / listeningObjectivesCount : 1.0;

  @override
  List<Object?> get props => [
        totalLevels,
        totalWorlds,
        totalUnits,
        totalLessons,
        totalConcepts,
        totalSentencePatterns,
        totalConversationFunctions,
        totalStories,
        speakingObjectivesCount,
        listeningObjectivesCount,
        conceptsPerLevel,
        lessonsPerLevel,
        unitsPerWorld,
        conceptsPerAgeBand,
        conceptsPerValueTheme,
        conceptsWithoutPrerequisites,
      ];
}

/// Generates coverage telemetry across curriculum assets to detect developmental imbalances.
class CurriculumCoverageReporter {
  const CurriculumCoverageReporter();

  static CurriculumCoverageReport generate(ICurriculumRepository repo) {
    final levels = repo.getAllLevels();
    final worlds = repo.getAllWorlds();
    final units = repo.getAllUnits();
    final lessons = repo.getAllLessons();
    final concepts = repo.getAllConcepts();
    final sentencePatterns = repo.getAllSentencePatterns();
    final functions = repo.getAllConversationFunctions();
    final stories = repo.getAllStories();
    final objectives = repo.getAllObjectives();

    int speakingCount = 0;
    int listeningCount = 0;

    for (final obj in objectives) {
      if (obj.skillDimension == SkillDimension.speaking ||
          obj.skillDimension == SkillDimension.pronunciation) {
        speakingCount++;
      } else if (obj.skillDimension == SkillDimension.listening ||
          obj.skillDimension == SkillDimension.vocabularyRecognition) {
        listeningCount++;
      }
    }

    final conceptsPerLevel = <int, int>{};
    for (final c in concepts) {
      conceptsPerLevel[c.levelOrder] = (conceptsPerLevel[c.levelOrder] ?? 0) + 1;
    }

    final lessonsPerLevel = <int, int>{};
    for (final l in lessons) {
      final level = repo.getLevelById(l.levelId);
      final order = level?.order ?? 1;
      lessonsPerLevel[order] = (lessonsPerLevel[order] ?? 0) + 1;
    }

    final unitsPerWorld = <String, int>{};
    for (final u in units) {
      unitsPerWorld[u.worldId] = (unitsPerWorld[u.worldId] ?? 0) + 1;
    }

    final conceptsPerAge = <LearningAgeBand, int>{};
    for (final c in concepts) {
      for (final band in c.ageBands) {
        conceptsPerAge[band] = (conceptsPerAge[band] ?? 0) + 1;
      }
    }

    final conceptsPerValue = <String, int>{};
    for (final c in concepts) {
      for (final v in c.valueThemeIds) {
        conceptsPerValue[v] = (conceptsPerValue[v] ?? 0) + 1;
      }
    }

    final noPrereqs = concepts.where((c) => c.prerequisites.isEmpty).map((c) => c.id).toList();

    return CurriculumCoverageReport(
      totalLevels: levels.length,
      totalWorlds: worlds.length,
      totalUnits: units.length,
      totalLessons: lessons.length,
      totalConcepts: concepts.length,
      totalSentencePatterns: sentencePatterns.length,
      totalConversationFunctions: functions.length,
      totalStories: stories.length,
      speakingObjectivesCount: speakingCount,
      listeningObjectivesCount: listeningCount,
      conceptsPerLevel: conceptsPerLevel,
      lessonsPerLevel: lessonsPerLevel,
      unitsPerWorld: unitsPerWorld,
      conceptsPerAgeBand: conceptsPerAge,
      conceptsPerValueTheme: conceptsPerValue,
      conceptsWithoutPrerequisites: noPrereqs,
    );
  }
}
