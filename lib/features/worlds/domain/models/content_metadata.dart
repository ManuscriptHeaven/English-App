import 'package:equatable/equatable.dart';

/// Review and publication status for educational and Islamic content safety.
enum PublishedStatus {
  draft,
  reviewed,
  published;

  static PublishedStatus fromString(String value) {
    return PublishedStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PublishedStatus.draft,
    );
  }
}

/// Difficulty levels for adaptive curriculum progression.
enum DifficultyLevel {
  beginner(1, 'Beginner', 'One-word prompts and simple visuals'),
  elementary(2, 'Elementary', 'Short phrases and basic listening'),
  intermediate(3, 'Intermediate', 'Complete sentences and basic grammar'),
  advanced(4, 'Advanced', 'Paragraphs, questions, and writing');

  final int rank;
  final String label;
  final String description;

  const DifficultyLevel(this.rank, this.label, this.description);

  static DifficultyLevel fromRank(int rank) {
    return DifficultyLevel.values.firstWhere(
      (e) => e.rank == rank,
      orElse: () => DifficultyLevel.beginner,
    );
  }
}

/// Rich metadata attached to every world, chapter, unit, lesson, activity, and story
/// to enable adaptive filtering and child safety auditing.
class ContentMetadata extends Equatable {
  final int minAge;
  final int maxAge;
  final DifficultyLevel difficulty;
  final String languageLevel; // CEFR: Pre-A1, A1, A2
  final String learningObjective;
  final List<String> vocabularyTags;
  final List<String> grammarTags;
  final List<String> valueTags;
  final List<String> mannerTags;
  final String? worldId;
  final String? unitId;
  final PublishedStatus status;

  const ContentMetadata({
    this.minAge = 3,
    this.maxAge = 10,
    this.difficulty = DifficultyLevel.beginner,
    this.languageLevel = 'Pre-A1',
    required this.learningObjective,
    this.vocabularyTags = const [],
    this.grammarTags = const [],
    this.valueTags = const [],
    this.mannerTags = const [],
    this.worldId,
    this.unitId,
    this.status = PublishedStatus.published,
  });

  bool isAppropriateForAge(int age) => age >= minAge && age <= maxAge;

  Map<String, dynamic> toJson() => {
        'minAge': minAge,
        'maxAge': maxAge,
        'difficulty': difficulty.rank,
        'languageLevel': languageLevel,
        'learningObjective': learningObjective,
        'vocabularyTags': vocabularyTags,
        'grammarTags': grammarTags,
        'valueTags': valueTags,
        'mannerTags': mannerTags,
        'worldId': worldId,
        'unitId': unitId,
        'status': status.name,
      };

  factory ContentMetadata.fromJson(Map<String, dynamic> json) => ContentMetadata(
        minAge: json['minAge'] as int? ?? 3,
        maxAge: json['maxAge'] as int? ?? 10,
        difficulty: DifficultyLevel.fromRank(json['difficulty'] as int? ?? 1),
        languageLevel: json['languageLevel'] as String? ?? 'Pre-A1',
        learningObjective: json['learningObjective'] as String? ?? '',
        vocabularyTags: (json['vocabularyTags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        grammarTags: (json['grammarTags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        valueTags: (json['valueTags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        mannerTags: (json['mannerTags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        worldId: json['worldId'] as String?,
        unitId: json['unitId'] as String?,
        status: PublishedStatus.fromString(json['status'] as String? ?? 'published'),
      );

  @override
  List<Object?> get props => [
        minAge,
        maxAge,
        difficulty,
        languageLevel,
        learningObjective,
        vocabularyTags,
        grammarTags,
        valueTags,
        mannerTags,
        worldId,
        unitId,
        status,
      ];
}
