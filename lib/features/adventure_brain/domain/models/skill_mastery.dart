import 'package:equatable/equatable.dart';
import 'learning_signal.dart';

/// Aggregated skill-level mastery across an entire skill dimension.
class SkillMastery extends Equatable {
  final SkillType skill;
  final double score; // 0.0 to 1.0 (e.g. 0.82 for 82%)
  final int totalItemsTracked;
  final int masteredItemsCount;
  final int weakItemsCount;
  final DateTime lastUpdated;

  const SkillMastery({
    required this.skill,
    required this.score,
    this.totalItemsTracked = 0,
    this.masteredItemsCount = 0,
    this.weakItemsCount = 0,
    required this.lastUpdated,
  });

  int get percentage => (score * 100).round();

  Map<String, dynamic> toJson() => {
        'skill': skill.name,
        'score': score,
        'totalItemsTracked': totalItemsTracked,
        'masteredItemsCount': masteredItemsCount,
        'weakItemsCount': weakItemsCount,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory SkillMastery.fromJson(Map<String, dynamic> json) => SkillMastery(
        skill: SkillType.values.firstWhere(
          (e) => e.name == json['skill'],
          orElse: () => SkillType.vocabulary,
        ),
        score: (json['score'] as num?)?.toDouble() ?? 0.0,
        totalItemsTracked: json['totalItemsTracked'] as int? ?? 0,
        masteredItemsCount: json['masteredItemsCount'] as int? ?? 0,
        weakItemsCount: json['weakItemsCount'] as int? ?? 0,
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );

  @override
  List<Object?> get props => [
        skill,
        score,
        totalItemsTracked,
        masteredItemsCount,
        weakItemsCount,
        lastUpdated,
      ];
}
