import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';

/// Represents an educational milestone composed of sequenced objectives and concept interactions,
/// decoupled from specific device UI screens.
class CurriculumLesson extends Equatable {
  final String id;
  final String unitId;
  final String levelId;
  final int order;
  final String title;
  final List<String> learningObjectiveIds;
  final List<String> targetConceptIds;
  final List<SkillDimension> targetSkillDimensions;
  final String speakingOutcome;
  final String listeningOutcome;
  final List<String> sentencePatternIds;
  final List<String> activityTemplateIds;
  final List<String> valueThemeIds;
  final int estimatedDurationMinutes;
  final Map<String, dynamic> ageBandAdaptations;
  final List<String> prerequisiteLessonIds;
  final List<String> reviewConceptIds;
  final Map<String, dynamic> metadata;

  const CurriculumLesson({
    required this.id,
    required this.unitId,
    required this.levelId,
    required this.order,
    required this.title,
    this.learningObjectiveIds = const [],
    this.targetConceptIds = const [],
    this.targetSkillDimensions = const [
      SkillDimension.vocabularyRecognition,
      SkillDimension.vocabularyRecall,
    ],
    required this.speakingOutcome,
    required this.listeningOutcome,
    this.sentencePatternIds = const [],
    this.activityTemplateIds = const [],
    this.valueThemeIds = const [],
    this.estimatedDurationMinutes = 5,
    this.ageBandAdaptations = const {},
    this.prerequisiteLessonIds = const [],
    this.reviewConceptIds = const [],
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'unitId': unitId,
        'levelId': levelId,
        'order': order,
        'title': title,
        'learningObjectiveIds': learningObjectiveIds,
        'targetConceptIds': targetConceptIds,
        'targetSkillDimensions': targetSkillDimensions.map((s) => s.name).toList(),
        'speakingOutcome': speakingOutcome,
        'listeningOutcome': listeningOutcome,
        'sentencePatternIds': sentencePatternIds,
        'activityTemplateIds': activityTemplateIds,
        'valueThemeIds': valueThemeIds,
        'estimatedDurationMinutes': estimatedDurationMinutes,
        'ageBandAdaptations': ageBandAdaptations,
        'prerequisiteLessonIds': prerequisiteLessonIds,
        'reviewConceptIds': reviewConceptIds,
        'metadata': metadata,
      };

  factory CurriculumLesson.fromJson(Map<String, dynamic> json) => CurriculumLesson(
        id: json['id'] as String,
        unitId: json['unitId'] as String,
        levelId: json['levelId'] as String,
        order: json['order'] as int,
        title: json['title'] as String,
        learningObjectiveIds:
            (json['learningObjectiveIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        targetConceptIds:
            (json['targetConceptIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        targetSkillDimensions: (json['targetSkillDimensions'] as List<dynamic>?)
                ?.map((s) => SkillDimension.values.firstWhere(
                      (e) => e.name == s,
                      orElse: () => SkillDimension.vocabularyRecall,
                    ))
                .toList() ??
            const [],
        speakingOutcome: json['speakingOutcome'] as String? ?? '',
        listeningOutcome: json['listeningOutcome'] as String? ?? '',
        sentencePatternIds:
            (json['sentencePatternIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        activityTemplateIds:
            (json['activityTemplateIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        valueThemeIds:
            (json['valueThemeIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        estimatedDurationMinutes: json['estimatedDurationMinutes'] as int? ?? 5,
        ageBandAdaptations: json['ageBandAdaptations'] as Map<String, dynamic>? ?? const {},
        prerequisiteLessonIds:
            (json['prerequisiteLessonIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        reviewConceptIds:
            (json['reviewConceptIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      );

  @override
  List<Object?> get props => [
        id,
        unitId,
        levelId,
        order,
        title,
        learningObjectiveIds,
        targetConceptIds,
        targetSkillDimensions,
        speakingOutcome,
        listeningOutcome,
        sentencePatternIds,
        activityTemplateIds,
        valueThemeIds,
        estimatedDurationMinutes,
        ageBandAdaptations,
        prerequisiteLessonIds,
        reviewConceptIds,
        metadata,
      ];
}
