import 'package:equatable/equatable.dart';
import 'content_review_status.dart';
import 'learning_age_band.dart';
import 'religious_content_safety.dart';

/// Narrative vehicle integrating vocabulary, sentence patterns, moral dilemmas,
/// and communicative retelling opportunities.
class LearningStory extends Equatable {
  final String id;
  final String title;
  final int levelOrder;
  final List<LearningAgeBand> ageBands;
  final String worldId;
  final String unitId;
  final List<String> textSegments;
  final List<String> simpleTextSegments;
  final List<String> richNarrativeTextSegments;
  final List<String> audioSegments;
  final List<String> imageAssets;
  final List<String> targetConceptIds;
  final List<String> targetSentencePatterns;
  final List<String> comprehensionObjectives;
  final List<String> speakingPrompts;
  final List<String> retellingPrompts;
  final List<String> valueThemes;
  final ReligiousContentType religiousContentType;
  final ContentReviewStatus reviewStatus;
  final int estimatedDurationMinutes;
  final Map<String, dynamic> metadata;

  const LearningStory({
    required this.id,
    required this.title,
    this.levelOrder = 1,
    this.ageBands = const [
      LearningAgeBand.bandALittleExplorers,
      LearningAgeBand.bandBYoungAdventurers,
      LearningAgeBand.bandCGrowingSpeakers,
      LearningAgeBand.bandDConfidentSpeakers,
    ],
    required this.worldId,
    required this.unitId,
    this.textSegments = const [],
    this.simpleTextSegments = const [],
    this.richNarrativeTextSegments = const [],
    this.audioSegments = const [],
    this.imageAssets = const [],
    this.targetConceptIds = const [],
    this.targetSentencePatterns = const [],
    this.comprehensionObjectives = const [],
    this.speakingPrompts = const [],
    this.retellingPrompts = const [],
    this.valueThemes = const [],
    this.religiousContentType = ReligiousContentType.generalMoralValue,
    this.reviewStatus = ContentReviewStatus.approved,
    this.estimatedDurationMinutes = 4,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'levelOrder': levelOrder,
        'ageBands': ageBands.map((b) => b.name).toList(),
        'worldId': worldId,
        'unitId': unitId,
        'textSegments': textSegments,
        'simpleTextSegments': simpleTextSegments,
        'richNarrativeTextSegments': richNarrativeTextSegments,
        'audioSegments': audioSegments,
        'imageAssets': imageAssets,
        'targetConceptIds': targetConceptIds,
        'targetSentencePatterns': targetSentencePatterns,
        'comprehensionObjectives': comprehensionObjectives,
        'speakingPrompts': speakingPrompts,
        'retellingPrompts': retellingPrompts,
        'valueThemes': valueThemes,
        'religiousContentType': religiousContentType.name,
        'reviewStatus': reviewStatus.name,
        'estimatedDurationMinutes': estimatedDurationMinutes,
        'metadata': metadata,
      };

  factory LearningStory.fromJson(Map<String, dynamic> json) => LearningStory(
        id: json['id'] as String,
        title: json['title'] as String,
        levelOrder: json['levelOrder'] as int? ?? 1,
        ageBands: (json['ageBands'] as List<dynamic>?)
                ?.map((b) => LearningAgeBand.values.firstWhere(
                      (e) => e.name == b,
                      orElse: () => LearningAgeBand.bandALittleExplorers,
                    ))
                .toList() ??
            const [],
        worldId: json['worldId'] as String,
        unitId: json['unitId'] as String,
        textSegments: (json['textSegments'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        simpleTextSegments:
            (json['simpleTextSegments'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        richNarrativeTextSegments:
            (json['richNarrativeTextSegments'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        audioSegments: (json['audioSegments'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        imageAssets: (json['imageAssets'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        targetConceptIds:
            (json['targetConceptIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        targetSentencePatterns:
            (json['targetSentencePatterns'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        comprehensionObjectives:
            (json['comprehensionObjectives'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        speakingPrompts:
            (json['speakingPrompts'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        retellingPrompts:
            (json['retellingPrompts'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        valueThemes: (json['valueThemes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        religiousContentType: ReligiousContentType.values.firstWhere(
          (r) => r.name == json['religiousContentType'],
          orElse: () => ReligiousContentType.generalMoralValue,
        ),
        reviewStatus: ContentReviewStatus.values.firstWhere(
          (s) => s.name == json['reviewStatus'],
          orElse: () => ContentReviewStatus.approved,
        ),
        estimatedDurationMinutes: json['estimatedDurationMinutes'] as int? ?? 4,
        metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      );

  @override
  List<Object?> get props => [
        id,
        title,
        levelOrder,
        ageBands,
        worldId,
        unitId,
        textSegments,
        simpleTextSegments,
        richNarrativeTextSegments,
        audioSegments,
        imageAssets,
        targetConceptIds,
        targetSentencePatterns,
        comprehensionObjectives,
        speakingPrompts,
        retellingPrompts,
        valueThemes,
        religiousContentType,
        reviewStatus,
        estimatedDurationMinutes,
        metadata,
      ];
}
