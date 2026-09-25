import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import 'learning_age_band.dart';

/// Evaluated dimension during an informal placement adventure with Pip.
class PlacementDimensionScore extends Equatable {
  final SkillDimension dimension;
  final double score; // 0.0 to 1.0
  final int totalAttempts;
  final bool demonstratedCompetence;

  const PlacementDimensionScore({
    required this.dimension,
    required this.score,
    required this.totalAttempts,
    required this.demonstratedCompetence,
  });

  Map<String, dynamic> toJson() => {
        'dimension': dimension.name,
        'score': score,
        'totalAttempts': totalAttempts,
        'demonstratedCompetence': demonstratedCompetence,
      };

  factory PlacementDimensionScore.fromJson(Map<String, dynamic> json) => PlacementDimensionScore(
        dimension: SkillDimension.values.firstWhere(
          (s) => s.name == json['dimension'],
          orElse: () => SkillDimension.vocabularyRecognition,
        ),
        score: (json['score'] as num).toDouble(),
        totalAttempts: json['totalAttempts'] as int,
        demonstratedCompetence: json['demonstratedCompetence'] as bool,
      );

  @override
  List<Object?> get props => [dimension, score, totalAttempts, demonstratedCompetence];
}

/// The diagnostic result of an initial placement exploration.
class PlacementResult extends Equatable {
  final String childId;
  final String recommendedLevelId;
  final int recommendedLevelOrder;
  final String recommendedStartingWorldId;
  final LearningAgeBand assignedAgeBand;
  final List<SkillDimension> skillStrengths;
  final List<SkillDimension> skillWeaknesses;
  final double overallConfidence;
  final String pedagogicalReasoning;
  final List<String> uncertainConceptAreas;
  final List<PlacementDimensionScore> dimensionScores;
  final DateTime assessedAt;

  const PlacementResult({
    required this.childId,
    required this.recommendedLevelId,
    required this.recommendedLevelOrder,
    required this.recommendedStartingWorldId,
    required this.assignedAgeBand,
    this.skillStrengths = const [],
    this.skillWeaknesses = const [],
    required this.overallConfidence,
    required this.pedagogicalReasoning,
    this.uncertainConceptAreas = const [],
    this.dimensionScores = const [],
    required this.assessedAt,
  });

  Map<String, dynamic> toJson() => {
        'childId': childId,
        'recommendedLevelId': recommendedLevelId,
        'recommendedLevelOrder': recommendedLevelOrder,
        'recommendedStartingWorldId': recommendedStartingWorldId,
        'assignedAgeBand': assignedAgeBand.name,
        'skillStrengths': skillStrengths.map((s) => s.name).toList(),
        'skillWeaknesses': skillWeaknesses.map((s) => s.name).toList(),
        'overallConfidence': overallConfidence,
        'pedagogicalReasoning': pedagogicalReasoning,
        'uncertainConceptAreas': uncertainConceptAreas,
        'dimensionScores': dimensionScores.map((d) => d.toJson()).toList(),
        'assessedAt': assessedAt.toIso8601String(),
      };

  factory PlacementResult.fromJson(Map<String, dynamic> json) => PlacementResult(
        childId: json['childId'] as String,
        recommendedLevelId: json['recommendedLevelId'] as String,
        recommendedLevelOrder: json['recommendedLevelOrder'] as int? ?? 1,
        recommendedStartingWorldId: json['recommendedStartingWorldId'] as String,
        assignedAgeBand: LearningAgeBand.values.firstWhere(
          (b) => b.name == json['assignedAgeBand'],
          orElse: () => LearningAgeBand.bandALittleExplorers,
        ),
        skillStrengths: (json['skillStrengths'] as List<dynamic>?)
                ?.map((s) => SkillDimension.values.firstWhere(
                      (e) => e.name == s,
                      orElse: () => SkillDimension.vocabularyRecognition,
                    ))
                .toList() ??
            const [],
        skillWeaknesses: (json['skillWeaknesses'] as List<dynamic>?)
                ?.map((s) => SkillDimension.values.firstWhere(
                      (e) => e.name == s,
                      orElse: () => SkillDimension.speaking,
                    ))
                .toList() ??
            const [],
        overallConfidence: (json['overallConfidence'] as num?)?.toDouble() ?? 0.8,
        pedagogicalReasoning: json['pedagogicalReasoning'] as String,
        uncertainConceptAreas:
            (json['uncertainConceptAreas'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        dimensionScores: (json['dimensionScores'] as List<dynamic>?)
                ?.map((d) => PlacementDimensionScore.fromJson(d as Map<String, dynamic>))
                .toList() ??
            const [],
        assessedAt: DateTime.parse(json['assessedAt'] as String),
      );

  @override
  List<Object?> get props => [
        childId,
        recommendedLevelId,
        recommendedLevelOrder,
        recommendedStartingWorldId,
        assignedAgeBand,
        skillStrengths,
        skillWeaknesses,
        overallConfidence,
        pedagogicalReasoning,
        uncertainConceptAreas,
        dimensionScores,
        assessedAt,
      ];
}
