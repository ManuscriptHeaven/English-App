import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import 'learning_age_band.dart';

/// Explicit learning objective specifying what knowledge or performance is targeted,
/// how evidence is collected, and what constitutes demonstration of competence.
class LearningObjective extends Equatable {
  final String id;
  final SkillDimension skillDimension;
  final String description; // e.g. "Identify 5 common foods by listening"
  final String childFriendlyDescription; // e.g. "Listen carefully to food names with Pip!"
  final String measurableOutcome; // e.g. "Selects correct picture with >= 0.75 accuracy"
  final List<String> evidenceTypes; // e.g. ['spokenProduction', 'listeningChoice']
  final int minimumEvidence;
  final List<String> targetConceptIds;
  final int levelOrder;
  final List<LearningAgeBand> ageBands;
  final Map<String, dynamic> metadata;

  const LearningObjective({
    required this.id,
    required this.skillDimension,
    required this.description,
    required this.childFriendlyDescription,
    required this.measurableOutcome,
    this.evidenceTypes = const ['listeningChoice'],
    this.minimumEvidence = 3,
    this.targetConceptIds = const [],
    this.levelOrder = 1,
    this.ageBands = const [
      LearningAgeBand.bandALittleExplorers,
      LearningAgeBand.bandBYoungAdventurers,
      LearningAgeBand.bandCGrowingSpeakers,
      LearningAgeBand.bandDConfidentSpeakers,
    ],
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'skillDimension': skillDimension.name,
        'description': description,
        'childFriendlyDescription': childFriendlyDescription,
        'measurableOutcome': measurableOutcome,
        'evidenceTypes': evidenceTypes,
        'minimumEvidence': minimumEvidence,
        'targetConceptIds': targetConceptIds,
        'levelOrder': levelOrder,
        'ageBands': ageBands.map((b) => b.name).toList(),
        'metadata': metadata,
      };

  factory LearningObjective.fromJson(Map<String, dynamic> json) => LearningObjective(
        id: json['id'] as String,
        skillDimension: SkillDimension.values.firstWhere(
          (s) => s.name == json['skillDimension'],
          orElse: () => SkillDimension.vocabularyRecognition,
        ),
        description: json['description'] as String,
        childFriendlyDescription: json['childFriendlyDescription'] as String,
        measurableOutcome: json['measurableOutcome'] as String,
        evidenceTypes:
            (json['evidenceTypes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        minimumEvidence: json['minimumEvidence'] as int? ?? 3,
        targetConceptIds:
            (json['targetConceptIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        levelOrder: json['levelOrder'] as int? ?? 1,
        ageBands: (json['ageBands'] as List<dynamic>?)
                ?.map((b) => LearningAgeBand.values.firstWhere(
                      (e) => e.name == b,
                      orElse: () => LearningAgeBand.bandALittleExplorers,
                    ))
                .toList() ??
            const [],
        metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      );

  @override
  List<Object?> get props => [
        id,
        skillDimension,
        description,
        childFriendlyDescription,
        measurableOutcome,
        evidenceTypes,
        minimumEvidence,
        targetConceptIds,
        levelOrder,
        ageBands,
        metadata,
      ];
}
