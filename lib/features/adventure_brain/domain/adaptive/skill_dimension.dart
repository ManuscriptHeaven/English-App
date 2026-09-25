import 'package:equatable/equatable.dart';

/// Discrete English ability dimensions measured by Adventure Brain.
///
/// Avoids combining all skills into a single global percentage so that
/// visual recognition strength does not mask listening or pronunciation weaknesses.
enum SkillDimension {
  vocabularyRecognition,
  vocabularyRecall,
  listening,
  speaking,
  pronunciation,
  sentenceComprehension,
  storyComprehension,
}

extension SkillDimensionExtension on SkillDimension {
  String get displayName {
    switch (this) {
      case SkillDimension.vocabularyRecognition:
        return 'Word Recognition';
      case SkillDimension.vocabularyRecall:
        return 'Word Recall';
      case SkillDimension.listening:
        return 'Listening & Ear Training';
      case SkillDimension.speaking:
        return 'Speaking & Dialogue';
      case SkillDimension.pronunciation:
        return 'Pronunciation & Phonics';
      case SkillDimension.sentenceComprehension:
        return 'Sentence Understanding';
      case SkillDimension.storyComprehension:
        return 'Story Comprehension';
    }
  }

  String get iconEmoji {
    switch (this) {
      case SkillDimension.vocabularyRecognition:
        return '👀';
      case SkillDimension.vocabularyRecall:
        return '🧠';
      case SkillDimension.listening:
        return '🎧';
      case SkillDimension.speaking:
        return '🗣️';
      case SkillDimension.pronunciation:
        return '🎙️';
      case SkillDimension.sentenceComprehension:
        return '📝';
      case SkillDimension.storyComprehension:
        return '📖';
    }
  }
}

/// Strongly-typed competency score for a single [SkillDimension].
class SkillCompetency extends Equatable {
  final SkillDimension dimension;
  final double score; // 0.0 to 1.0
  final int totalInteractions;
  final int successfulInteractions;
  final DateTime lastAssessedAt;

  const SkillCompetency({
    required this.dimension,
    required this.score,
    this.totalInteractions = 0,
    this.successfulInteractions = 0,
    required this.lastAssessedAt,
  });

  bool get isProficient => score >= 0.70;
  bool get needsSupport => score < 0.50 && totalInteractions >= 3;

  SkillCompetency copyWith({
    SkillDimension? dimension,
    double? score,
    int? totalInteractions,
    int? successfulInteractions,
    DateTime? lastAssessedAt,
  }) {
    return SkillCompetency(
      dimension: dimension ?? this.dimension,
      score: score ?? this.score,
      totalInteractions: totalInteractions ?? this.totalInteractions,
      successfulInteractions:
          successfulInteractions ?? this.successfulInteractions,
      lastAssessedAt: lastAssessedAt ?? this.lastAssessedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'dimension': dimension.name,
        'score': score,
        'totalInteractions': totalInteractions,
        'successfulInteractions': successfulInteractions,
        'lastAssessedAt': lastAssessedAt.toIso8601String(),
      };

  factory SkillCompetency.fromJson(Map<String, dynamic> json) => SkillCompetency(
        dimension: SkillDimension.values.firstWhere(
          (d) => d.name == json['dimension'],
          orElse: () => SkillDimension.vocabularyRecognition,
        ),
        score: (json['score'] as num?)?.toDouble() ?? 0.0,
        totalInteractions: json['totalInteractions'] as int? ?? 0,
        successfulInteractions: json['successfulInteractions'] as int? ?? 0,
        lastAssessedAt: DateTime.parse(
          json['lastAssessedAt'] as String? ??
              DateTime.now().toIso8601String(),
        ),
      );

  @override
  List<Object?> get props => [
        dimension,
        score,
        totalInteractions,
        successfulInteractions,
        lastAssessedAt,
      ];
}
