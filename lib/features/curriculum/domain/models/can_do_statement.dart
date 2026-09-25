import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';

/// Clear, functional language competency benchmark expressed as an achievable ability
/// (aligned with CEFR Pre-A1/A1 child standards).
class CanDoStatement extends Equatable {
  final String id;
  final String text; // e.g. "Can ask for food politely using 'please' and 'thank you'"
  final SkillDimension skillDimension;
  final int levelOrder;
  final String requiredEvidence; // e.g. "Speaking challenge accuracy >= 0.70 in 2 sessions"
  final String parentFriendlyText;
  final String childFriendlyText;

  const CanDoStatement({
    required this.id,
    required this.text,
    required this.skillDimension,
    required this.levelOrder,
    required this.requiredEvidence,
    required this.parentFriendlyText,
    required this.childFriendlyText,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'skillDimension': skillDimension.name,
        'levelOrder': levelOrder,
        'requiredEvidence': requiredEvidence,
        'parentFriendlyText': parentFriendlyText,
        'childFriendlyText': childFriendlyText,
      };

  factory CanDoStatement.fromJson(Map<String, dynamic> json) => CanDoStatement(
        id: json['id'] as String,
        text: json['text'] as String,
        skillDimension: SkillDimension.values.firstWhere(
          (s) => s.name == json['skillDimension'],
          orElse: () => SkillDimension.speaking,
        ),
        levelOrder: json['levelOrder'] as int? ?? 1,
        requiredEvidence: json['requiredEvidence'] as String? ?? '',
        parentFriendlyText: json['parentFriendlyText'] as String,
        childFriendlyText: json['childFriendlyText'] as String,
      );

  @override
  List<Object?> get props => [
        id,
        text,
        skillDimension,
        levelOrder,
        requiredEvidence,
        parentFriendlyText,
        childFriendlyText,
      ];
}
