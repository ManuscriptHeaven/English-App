import 'package:equatable/equatable.dart';

/// A cohesive educational unit focused on a concrete, functional communicative outcome.
class CurriculumUnit extends Equatable {
  final String id;
  final String worldId;
  final String levelId;
  final String title;
  final String description;
  final String speakingOutcome; // e.g. "Child can identify common foods and say simple request sentences"
  final String listeningOutcome; // e.g. "Child recognizes names of 6 foods when spoken in context"
  final List<String> canDoStatementIds;
  final List<String> vocabularyConceptIds;
  final List<String> sentencePatternIds;
  final List<String> conversationPatternIds;
  final List<String> storyIds;
  final List<String> valueThemeIds;
  final List<String> lessonIds;
  final List<String> prerequisites;
  final Map<String, dynamic> completionRequirements;
  final Map<String, dynamic> masteryRequirements;
  final String? finalMissionId;
  final Map<String, dynamic> ageBandAdaptations;
  final Map<String, dynamic> metadata;

  const CurriculumUnit({
    required this.id,
    required this.worldId,
    required this.levelId,
    required this.title,
    required this.description,
    required this.speakingOutcome,
    required this.listeningOutcome,
    this.canDoStatementIds = const [],
    this.vocabularyConceptIds = const [],
    this.sentencePatternIds = const [],
    this.conversationPatternIds = const [],
    this.storyIds = const [],
    this.valueThemeIds = const [],
    this.lessonIds = const [],
    this.prerequisites = const [],
    this.completionRequirements = const {},
    this.masteryRequirements = const {},
    this.finalMissionId,
    this.ageBandAdaptations = const {},
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'worldId': worldId,
        'levelId': levelId,
        'title': title,
        'description': description,
        'speakingOutcome': speakingOutcome,
        'listeningOutcome': listeningOutcome,
        'canDoStatementIds': canDoStatementIds,
        'vocabularyConceptIds': vocabularyConceptIds,
        'sentencePatternIds': sentencePatternIds,
        'conversationPatternIds': conversationPatternIds,
        'storyIds': storyIds,
        'valueThemeIds': valueThemeIds,
        'lessonIds': lessonIds,
        'prerequisites': prerequisites,
        'completionRequirements': completionRequirements,
        'masteryRequirements': masteryRequirements,
        'finalMissionId': finalMissionId,
        'ageBandAdaptations': ageBandAdaptations,
        'metadata': metadata,
      };

  factory CurriculumUnit.fromJson(Map<String, dynamic> json) => CurriculumUnit(
        id: json['id'] as String,
        worldId: json['worldId'] as String,
        levelId: json['levelId'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        speakingOutcome: json['speakingOutcome'] as String,
        listeningOutcome: json['listeningOutcome'] as String,
        canDoStatementIds:
            (json['canDoStatementIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        vocabularyConceptIds:
            (json['vocabularyConceptIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        sentencePatternIds:
            (json['sentencePatternIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        conversationPatternIds:
            (json['conversationPatternIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        storyIds: (json['storyIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        valueThemeIds: (json['valueThemeIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        lessonIds: (json['lessonIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        prerequisites: (json['prerequisites'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        completionRequirements: json['completionRequirements'] as Map<String, dynamic>? ?? const {},
        masteryRequirements: json['masteryRequirements'] as Map<String, dynamic>? ?? const {},
        finalMissionId: json['finalMissionId'] as String?,
        ageBandAdaptations: json['ageBandAdaptations'] as Map<String, dynamic>? ?? const {},
        metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      );

  @override
  List<Object?> get props => [
        id,
        worldId,
        levelId,
        title,
        description,
        speakingOutcome,
        listeningOutcome,
        canDoStatementIds,
        vocabularyConceptIds,
        sentencePatternIds,
        conversationPatternIds,
        storyIds,
        valueThemeIds,
        lessonIds,
        prerequisites,
        completionRequirements,
        masteryRequirements,
        finalMissionId,
        ageBandAdaptations,
        metadata,
      ];
}
