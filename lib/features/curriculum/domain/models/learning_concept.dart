import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import 'content_review_status.dart';
import 'learning_age_band.dart';

/// Semantic classification of curriculum concept nodes.
enum ConceptType {
  vocabulary,
  phrase,
  sentencePattern,
  grammarPattern,
  listeningPattern,
  pronunciationTarget,
  conversationFunction,
  storySkill,
  socialLanguage,
  valueExpression;

  String get displayName {
    switch (this) {
      case ConceptType.vocabulary:
        return 'Vocabulary Word';
      case ConceptType.phrase:
        return 'Collocation / Phrase';
      case ConceptType.sentencePattern:
        return 'Sentence Structure';
      case ConceptType.grammarPattern:
        return 'Grammar Pattern';
      case ConceptType.listeningPattern:
        return 'Listening Audio Target';
      case ConceptType.pronunciationTarget:
        return 'Phonics / Pronunciation';
      case ConceptType.conversationFunction:
        return 'Social Language Function';
      case ConceptType.storySkill:
        return 'Story Comprehension Skill';
      case ConceptType.socialLanguage:
        return 'Manners / Social Exchange';
      case ConceptType.valueExpression:
        return 'Ethical / Value Expression';
    }
  }
}

/// A foundational knowledge node in the curriculum knowledge graph.
class LearningConcept extends Equatable {
  final String id;
  final ConceptType type;
  final String canonicalText; // e.g. "apple", "Can I have... please?"
  final String meaning;
  final int levelOrder;
  final List<LearningAgeBand> ageBands;
  final List<String> prerequisites;
  final List<String> relatedConceptIds;
  final List<SkillDimension> skillDimensions;
  final List<String> tags;
  final List<String> valueThemeIds;
  final String? audioId;
  final String? imageAssetId;
  final List<String> acceptableResponses;
  final List<String> reviewContexts;
  final ContentReviewStatus reviewStatus;
  final Map<String, dynamic> metadata;

  const LearningConcept({
    required this.id,
    required this.type,
    required this.canonicalText,
    required this.meaning,
    this.levelOrder = 1,
    this.ageBands = const [
      LearningAgeBand.bandALittleExplorers,
      LearningAgeBand.bandBYoungAdventurers,
      LearningAgeBand.bandCGrowingSpeakers,
      LearningAgeBand.bandDConfidentSpeakers,
    ],
    this.prerequisites = const [],
    this.relatedConceptIds = const [],
    this.skillDimensions = const [
      SkillDimension.vocabularyRecognition,
      SkillDimension.vocabularyRecall,
    ],
    this.tags = const [],
    this.valueThemeIds = const [],
    this.audioId,
    this.imageAssetId,
    this.acceptableResponses = const [],
    this.reviewContexts = const [],
    this.reviewStatus = ContentReviewStatus.approved,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'canonicalText': canonicalText,
        'meaning': meaning,
        'levelOrder': levelOrder,
        'ageBands': ageBands.map((b) => b.name).toList(),
        'prerequisites': prerequisites,
        'relatedConceptIds': relatedConceptIds,
        'skillDimensions': skillDimensions.map((s) => s.name).toList(),
        'tags': tags,
        'valueThemeIds': valueThemeIds,
        'audioId': audioId,
        'imageAssetId': imageAssetId,
        'acceptableResponses': acceptableResponses,
        'reviewContexts': reviewContexts,
        'reviewStatus': reviewStatus.name,
        'metadata': metadata,
      };

  factory LearningConcept.fromJson(Map<String, dynamic> json) => LearningConcept(
        id: json['id'] as String,
        type: ConceptType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => ConceptType.vocabulary,
        ),
        canonicalText: json['canonicalText'] as String,
        meaning: json['meaning'] as String,
        levelOrder: json['levelOrder'] as int? ?? 1,
        ageBands: (json['ageBands'] as List<dynamic>?)
                ?.map((b) => LearningAgeBand.values.firstWhere(
                      (e) => e.name == b,
                      orElse: () => LearningAgeBand.bandALittleExplorers,
                    ))
                .toList() ??
            const [],
        prerequisites:
            (json['prerequisites'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        relatedConceptIds:
            (json['relatedConceptIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        skillDimensions: (json['skillDimensions'] as List<dynamic>?)
                ?.map((s) => SkillDimension.values.firstWhere(
                      (e) => e.name == s,
                      orElse: () => SkillDimension.vocabularyRecall,
                    ))
                .toList() ??
            const [],
        tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        valueThemeIds:
            (json['valueThemeIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        audioId: json['audioId'] as String?,
        imageAssetId: json['imageAssetId'] as String?,
        acceptableResponses:
            (json['acceptableResponses'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        reviewContexts:
            (json['reviewContexts'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        reviewStatus: ContentReviewStatus.values.firstWhere(
          (s) => s.name == json['reviewStatus'],
          orElse: () => ContentReviewStatus.approved,
        ),
        metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      );

  @override
  List<Object?> get props => [
        id,
        type,
        canonicalText,
        meaning,
        levelOrder,
        ageBands,
        prerequisites,
        relatedConceptIds,
        skillDimensions,
        tags,
        valueThemeIds,
        audioId,
        imageAssetId,
        acceptableResponses,
        reviewContexts,
        reviewStatus,
        metadata,
      ];
}
