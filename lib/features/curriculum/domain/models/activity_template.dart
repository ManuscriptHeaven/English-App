import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import 'learning_age_band.dart';
import 'learning_concept.dart';

/// Interaction templates defining delivery mechanics, decoupled from individual learning objectives.
enum ActivityTemplateType {
  pictureChoice,
  listenAndChoose,
  repeatAfterPip,
  sentenceBuilder,
  matching,
  animalHunt,
  storyChoice,
  conversationPrompt,
  listenAndAct,
  pictureDescription,
  rolePlay,
  storyRetell,
  missingWord,
  sorting,
  memoryMatch,
  speakToContinue;

  String get displayName {
    switch (this) {
      case ActivityTemplateType.pictureChoice:
        return 'Picture Choice (Visual Selection)';
      case ActivityTemplateType.listenAndChoose:
        return 'Listen & Choose (Auditory Matching)';
      case ActivityTemplateType.repeatAfterPip:
        return 'Repeat After Pip (Speech Imitation)';
      case ActivityTemplateType.sentenceBuilder:
        return 'Sentence Builder (Slot Substitution)';
      case ActivityTemplateType.matching:
        return 'Word & Picture Matching';
      case ActivityTemplateType.animalHunt:
        return 'Adventure Hunt (Search & Tap)';
      case ActivityTemplateType.storyChoice:
        return 'Story Comprehension Choice';
      case ActivityTemplateType.conversationPrompt:
        return 'Talk with Pip (Turn-Taking)';
      case ActivityTemplateType.listenAndAct:
        return 'Listen & Act (TPR Instruction)';
      case ActivityTemplateType.pictureDescription:
        return 'Picture Description (Open Speech)';
      case ActivityTemplateType.rolePlay:
        return 'Dialogic Role Play';
      case ActivityTemplateType.storyRetell:
        return 'Story Retelling';
      case ActivityTemplateType.missingWord:
        return 'Missing Word Cloze';
      case ActivityTemplateType.sorting:
        return 'Category Sorting';
      case ActivityTemplateType.memoryMatch:
        return 'Memory Pair Match';
      case ActivityTemplateType.speakToContinue:
        return 'Voice Gate (Say It to Proceed)';
    }
  }
}

/// Abstract delivery blueprint matching pedagogy to interactive mechanics.
class ActivityTemplate extends Equatable {
  final String id;
  final ActivityTemplateType type;
  final List<SkillDimension> supportedSkillDimensions;
  final List<int> supportedLevels; // 1 to 8
  final List<LearningAgeBand> supportedAgeBands;
  final List<ConceptType> compatibleConceptTypes;
  final String interactionType; // 'tap', 'drag', 'voice', 'multipleChoice'
  final bool requiresAudio;
  final bool requiresSpeech;
  final bool offlineCapable;
  final int minimumChoices;
  final int maximumChoices;
  final Map<String, dynamic> metadata;

  const ActivityTemplate({
    required this.id,
    required this.type,
    this.supportedSkillDimensions = const [
      SkillDimension.vocabularyRecognition,
      SkillDimension.vocabularyRecall,
    ],
    this.supportedLevels = const [1, 2, 3, 4, 5, 6, 7, 8],
    this.supportedAgeBands = const [
      LearningAgeBand.bandALittleExplorers,
      LearningAgeBand.bandBYoungAdventurers,
      LearningAgeBand.bandCGrowingSpeakers,
      LearningAgeBand.bandDConfidentSpeakers,
    ],
    this.compatibleConceptTypes = const [ConceptType.vocabulary],
    this.interactionType = 'tap',
    this.requiresAudio = true,
    this.requiresSpeech = false,
    this.offlineCapable = true,
    this.minimumChoices = 2,
    this.maximumChoices = 4,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'supportedSkillDimensions': supportedSkillDimensions.map((s) => s.name).toList(),
        'supportedLevels': supportedLevels,
        'supportedAgeBands': supportedAgeBands.map((b) => b.name).toList(),
        'compatibleConceptTypes': compatibleConceptTypes.map((c) => c.name).toList(),
        'interactionType': interactionType,
        'requiresAudio': requiresAudio,
        'requiresSpeech': requiresSpeech,
        'offlineCapable': offlineCapable,
        'minimumChoices': minimumChoices,
        'maximumChoices': maximumChoices,
        'metadata': metadata,
      };

  factory ActivityTemplate.fromJson(Map<String, dynamic> json) => ActivityTemplate(
        id: json['id'] as String,
        type: ActivityTemplateType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => ActivityTemplateType.pictureChoice,
        ),
        supportedSkillDimensions: (json['supportedSkillDimensions'] as List<dynamic>?)
                ?.map((s) => SkillDimension.values.firstWhere(
                      (e) => e.name == s,
                      orElse: () => SkillDimension.vocabularyRecognition,
                    ))
                .toList() ??
            const [],
        supportedLevels: (json['supportedLevels'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
        supportedAgeBands: (json['supportedAgeBands'] as List<dynamic>?)
                ?.map((b) => LearningAgeBand.values.firstWhere(
                      (e) => e.name == b,
                      orElse: () => LearningAgeBand.bandALittleExplorers,
                    ))
                .toList() ??
            const [],
        compatibleConceptTypes: (json['compatibleConceptTypes'] as List<dynamic>?)
                ?.map((c) => ConceptType.values.firstWhere(
                      (e) => e.name == c,
                      orElse: () => ConceptType.vocabulary,
                    ))
                .toList() ??
            const [],
        interactionType: json['interactionType'] as String? ?? 'tap',
        requiresAudio: json['requiresAudio'] as bool? ?? true,
        requiresSpeech: json['requiresSpeech'] as bool? ?? false,
        offlineCapable: json['offlineCapable'] as bool? ?? true,
        minimumChoices: json['minimumChoices'] as int? ?? 2,
        maximumChoices: json['maximumChoices'] as int? ?? 4,
        metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      );

  @override
  List<Object?> get props => [
        id,
        type,
        supportedSkillDimensions,
        supportedLevels,
        supportedAgeBands,
        compatibleConceptTypes,
        interactionType,
        requiresAudio,
        requiresSpeech,
        offlineCapable,
        minimumChoices,
        maximumChoices,
        metadata,
      ];
}
