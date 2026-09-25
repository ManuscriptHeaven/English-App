import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import 'learning_age_band.dart';

/// Language development stages across the progressive English curriculum.
enum LanguageStage {
  firstWords,
  firstPhrases,
  firstSentences,
  everydaySpeaker,
  conversationBuilder,
  storySpeaker,
  confidentCommunicator,
  advancedYoungSpeaker;

  String get displayName {
    switch (this) {
      case LanguageStage.firstWords:
        return 'First Words (Foundations)';
      case LanguageStage.firstPhrases:
        return 'First Phrases (Word Combining)';
      case LanguageStage.firstSentences:
        return 'First Sentences (Sentence Patterns)';
      case LanguageStage.everydaySpeaker:
        return 'Everyday Speaker (Functional Situations)';
      case LanguageStage.conversationBuilder:
        return 'Conversation Builder (Social Dialogue)';
      case LanguageStage.storySpeaker:
        return 'Story Speaker (Narrative & Retelling)';
      case LanguageStage.confidentCommunicator:
        return 'Confident Communicator (Opinions & Reasons)';
      case LanguageStage.advancedYoungSpeaker:
        return 'Advanced Young Speaker (Extended Discourse)';
    }
  }
}

/// A first-class curriculum stage defining WHAT the child is learning,
/// strictly separated from adaptive difficulty (HOW challenging the experience is).
class CurriculumLevel extends Equatable {
  final String id;
  final int order; // 1 to 8
  final String title;
  final String childFriendlyTitle;
  final String description;
  final String primarySpeakingGoal;
  final LanguageStage languageStage;
  final List<LearningAgeBand> recommendedAgeBands;
  final List<String> entryRequirements;
  final List<String> exitRequirements;
  final List<SkillDimension> requiredSkillCompetencies;
  final List<String> coreConceptIds;
  final List<String> worldIds;
  final int minimumEvidenceCount;
  final String? levelMissionId;
  final Map<String, dynamic> metadata;

  const CurriculumLevel({
    required this.id,
    required this.order,
    required this.title,
    required this.childFriendlyTitle,
    required this.description,
    required this.primarySpeakingGoal,
    required this.languageStage,
    this.recommendedAgeBands = const [
      LearningAgeBand.bandALittleExplorers,
      LearningAgeBand.bandBYoungAdventurers,
      LearningAgeBand.bandCGrowingSpeakers,
      LearningAgeBand.bandDConfidentSpeakers,
    ],
    this.entryRequirements = const [],
    this.exitRequirements = const [],
    this.requiredSkillCompetencies = const [
      SkillDimension.vocabularyRecognition,
      SkillDimension.vocabularyRecall,
      SkillDimension.pronunciation,
    ],
    this.coreConceptIds = const [],
    this.worldIds = const [],
    this.minimumEvidenceCount = 10,
    this.levelMissionId,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'order': order,
        'title': title,
        'childFriendlyTitle': childFriendlyTitle,
        'description': description,
        'primarySpeakingGoal': primarySpeakingGoal,
        'languageStage': languageStage.name,
        'recommendedAgeBands': recommendedAgeBands.map((b) => b.name).toList(),
        'entryRequirements': entryRequirements,
        'exitRequirements': exitRequirements,
        'requiredSkillCompetencies': requiredSkillCompetencies.map((s) => s.name).toList(),
        'coreConceptIds': coreConceptIds,
        'worldIds': worldIds,
        'minimumEvidenceCount': minimumEvidenceCount,
        'levelMissionId': levelMissionId,
        'metadata': metadata,
      };

  factory CurriculumLevel.fromJson(Map<String, dynamic> json) => CurriculumLevel(
        id: json['id'] as String,
        order: json['order'] as int,
        title: json['title'] as String,
        childFriendlyTitle: json['childFriendlyTitle'] as String,
        description: json['description'] as String,
        primarySpeakingGoal: json['primarySpeakingGoal'] as String,
        languageStage: LanguageStage.values.firstWhere(
          (s) => s.name == json['languageStage'],
          orElse: () => LanguageStage.firstWords,
        ),
        recommendedAgeBands: (json['recommendedAgeBands'] as List<dynamic>?)
                ?.map((b) => LearningAgeBand.values.firstWhere(
                      (e) => e.name == b,
                      orElse: () => LearningAgeBand.bandALittleExplorers,
                    ))
                .toList() ??
            const [],
        entryRequirements: (json['entryRequirements'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        exitRequirements: (json['exitRequirements'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        requiredSkillCompetencies: (json['requiredSkillCompetencies'] as List<dynamic>?)
                ?.map((s) => SkillDimension.values.firstWhere(
                      (e) => e.name == s,
                      orElse: () => SkillDimension.vocabularyRecall,
                    ))
                .toList() ??
            const [],
        coreConceptIds: (json['coreConceptIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        worldIds: (json['worldIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        minimumEvidenceCount: json['minimumEvidenceCount'] as int? ?? 10,
        levelMissionId: json['levelMissionId'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      );

  @override
  List<Object?> get props => [
        id,
        order,
        title,
        childFriendlyTitle,
        description,
        primarySpeakingGoal,
        languageStage,
        recommendedAgeBands,
        entryRequirements,
        exitRequirements,
        requiredSkillCompetencies,
        coreConceptIds,
        worldIds,
        minimumEvidenceCount,
        levelMissionId,
        metadata,
      ];
}
