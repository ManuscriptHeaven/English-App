import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import 'learning_age_band.dart';

/// Syntactic sentence frame supporting communicative substitution and scaffolded production.
class SentencePattern extends Equatable {
  final String id;
  final String template; // e.g. "I like {noun}." or "Can I have {noun}, please?"
  final List<String> examples;
  final int levelOrder;
  final List<LearningAgeBand> ageBands;
  final List<String> variableSlots; // e.g. ['noun', 'adjective']
  final List<String> prerequisiteConceptIds;
  final SkillDimension targetSkill;
  final List<String> acceptableVariations;
  final List<String> speakingUseCases;
  final List<String> conversationFunctions;
  final Map<String, dynamic> metadata;

  const SentencePattern({
    required this.id,
    required this.template,
    required this.examples,
    this.levelOrder = 3,
    this.ageBands = const [
      LearningAgeBand.bandALittleExplorers,
      LearningAgeBand.bandBYoungAdventurers,
      LearningAgeBand.bandCGrowingSpeakers,
      LearningAgeBand.bandDConfidentSpeakers,
    ],
    this.variableSlots = const [],
    this.prerequisiteConceptIds = const [],
    this.targetSkill = SkillDimension.sentenceComprehension,
    this.acceptableVariations = const [],
    this.speakingUseCases = const [],
    this.conversationFunctions = const [],
    this.metadata = const {},
  });

  /// Populates the sentence pattern template with specific argument values.
  String populate(Map<String, String> slotValues) {
    var result = template;
    for (final entry in slotValues.entries) {
      result = result.replaceAll('{${entry.key}}', entry.value);
    }
    return result;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'template': template,
        'examples': examples,
        'levelOrder': levelOrder,
        'ageBands': ageBands.map((b) => b.name).toList(),
        'variableSlots': variableSlots,
        'prerequisiteConceptIds': prerequisiteConceptIds,
        'targetSkill': targetSkill.name,
        'acceptableVariations': acceptableVariations,
        'speakingUseCases': speakingUseCases,
        'conversationFunctions': conversationFunctions,
        'metadata': metadata,
      };

  factory SentencePattern.fromJson(Map<String, dynamic> json) => SentencePattern(
        id: json['id'] as String,
        template: json['template'] as String,
        examples: (json['examples'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        levelOrder: json['levelOrder'] as int? ?? 3,
        ageBands: (json['ageBands'] as List<dynamic>?)
                ?.map((b) => LearningAgeBand.values.firstWhere(
                      (e) => e.name == b,
                      orElse: () => LearningAgeBand.bandBYoungAdventurers,
                    ))
                .toList() ??
            const [],
        variableSlots:
            (json['variableSlots'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        prerequisiteConceptIds:
            (json['prerequisiteConceptIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        targetSkill: SkillDimension.values.firstWhere(
          (s) => s.name == json['targetSkill'],
          orElse: () => SkillDimension.sentenceComprehension,
        ),
        acceptableVariations:
            (json['acceptableVariations'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        speakingUseCases:
            (json['speakingUseCases'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        conversationFunctions:
            (json['conversationFunctions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      );

  @override
  List<Object?> get props => [
        id,
        template,
        examples,
        levelOrder,
        ageBands,
        variableSlots,
        prerequisiteConceptIds,
        targetSkill,
        acceptableVariations,
        speakingUseCases,
        conversationFunctions,
        metadata,
      ];
}
