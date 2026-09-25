import 'package:equatable/equatable.dart';
import 'learning_age_band.dart';

/// Pragmatic communicative functions in social English exchanges.
enum CommunicativeIntent {
  greeting,
  requesting,
  thanking,
  askingForHelp,
  introducingOneself,
  answeringPreferenceQuestion,
  describing,
  explaining,
  agreeing,
  disagreeingPolitely,
  apologizing,
  askingClarification;

  String get displayName {
    switch (this) {
      case CommunicativeIntent.greeting:
        return 'Greetings & Welcome';
      case CommunicativeIntent.requesting:
        return 'Polite Requests';
      case CommunicativeIntent.thanking:
        return 'Gratitude & Thanks';
      case CommunicativeIntent.askingForHelp:
        return 'Asking for Assistance';
      case CommunicativeIntent.introducingOneself:
        return 'Personal Introductions';
      case CommunicativeIntent.answeringPreferenceQuestion:
        return 'Stating Preferences';
      case CommunicativeIntent.describing:
        return 'Describing Objects & Animals';
      case CommunicativeIntent.explaining:
        return 'Giving Reasons (because...)';
      case CommunicativeIntent.agreeing:
        return 'Expressing Agreement';
      case CommunicativeIntent.disagreeingPolitely:
        return 'Polite Disagreement';
      case CommunicativeIntent.apologizing:
        return 'Apologizing & Repair';
      case CommunicativeIntent.askingClarification:
        return 'Clarification & Questions';
    }
  }
}

/// A structured communicative capability modeling a social speech turn.
class ConversationFunction extends Equatable {
  final String id;
  final int levelOrder;
  final CommunicativeIntent intent;
  final List<String> exampleTurns; // e.g. ["Can you help me, please?", "Sure, here it is!"]
  final List<String> prerequisitePatternIds;
  final List<LearningAgeBand> ageBands;
  final List<String> valueThemes;
  final List<String> speakingObjectiveIds;

  // Structured conversation design attributes (Phase 15.7 / Section 8)
  final String purpose;
  final String pipOpening;
  final String simplerResponse;
  final String targetResponse;
  final String strongerResponse;
  final String pipFollowUp;
  final String recoveryPrompt;
  final String ageAdaptationNotes;
  final String completionEvidence;

  const ConversationFunction({
    required this.id,
    required this.levelOrder,
    required this.intent,
    required this.exampleTurns,
    this.prerequisitePatternIds = const [],
    this.ageBands = const [
      LearningAgeBand.bandALittleExplorers,
      LearningAgeBand.bandBYoungAdventurers,
      LearningAgeBand.bandCGrowingSpeakers,
      LearningAgeBand.bandDConfidentSpeakers,
    ],
    this.valueThemes = const [],
    this.speakingObjectiveIds = const [],
    this.purpose = '',
    this.pipOpening = '',
    this.simplerResponse = '',
    this.targetResponse = '',
    this.strongerResponse = '',
    this.pipFollowUp = '',
    this.recoveryPrompt = '',
    this.ageAdaptationNotes = '',
    this.completionEvidence = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'levelOrder': levelOrder,
        'intent': intent.name,
        'exampleTurns': exampleTurns,
        'prerequisitePatternIds': prerequisitePatternIds,
        'ageBands': ageBands.map((b) => b.name).toList(),
        'valueThemes': valueThemes,
        'speakingObjectiveIds': speakingObjectiveIds,
        'purpose': purpose,
        'pipOpening': pipOpening,
        'simplerResponse': simplerResponse,
        'targetResponse': targetResponse,
        'strongerResponse': strongerResponse,
        'pipFollowUp': pipFollowUp,
        'recoveryPrompt': recoveryPrompt,
        'ageAdaptationNotes': ageAdaptationNotes,
        'completionEvidence': completionEvidence,
      };

  factory ConversationFunction.fromJson(Map<String, dynamic> json) => ConversationFunction(
        id: json['id'] as String,
        levelOrder: json['levelOrder'] as int? ?? 1,
        intent: CommunicativeIntent.values.firstWhere(
          (i) => i.name == json['intent'],
          orElse: () => CommunicativeIntent.greeting,
        ),
        exampleTurns: (json['exampleTurns'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        prerequisitePatternIds:
            (json['prerequisitePatternIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        ageBands: (json['ageBands'] as List<dynamic>?)
                ?.map((b) => LearningAgeBand.values.firstWhere(
                      (e) => e.name == b,
                      orElse: () => LearningAgeBand.bandBYoungAdventurers,
                    ))
                .toList() ??
            const [],
        valueThemes: (json['valueThemes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        speakingObjectiveIds:
            (json['speakingObjectiveIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        purpose: json['purpose'] as String? ?? '',
        pipOpening: json['pipOpening'] as String? ?? '',
        simplerResponse: json['simplerResponse'] as String? ?? '',
        targetResponse: json['targetResponse'] as String? ?? '',
        strongerResponse: json['strongerResponse'] as String? ?? '',
        pipFollowUp: json['pipFollowUp'] as String? ?? '',
        recoveryPrompt: json['recoveryPrompt'] as String? ?? '',
        ageAdaptationNotes: json['ageAdaptationNotes'] as String? ?? '',
        completionEvidence: json['completionEvidence'] as String? ?? '',
      );

  @override
  List<Object?> get props => [
        id,
        levelOrder,
        intent,
        exampleTurns,
        prerequisitePatternIds,
        ageBands,
        valueThemes,
        speakingObjectiveIds,
        purpose,
        pipOpening,
        simplerResponse,
        targetResponse,
        strongerResponse,
        pipFollowUp,
        recoveryPrompt,
        ageAdaptationNotes,
        completionEvidence,
      ];
}
