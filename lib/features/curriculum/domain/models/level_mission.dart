import 'package:equatable/equatable.dart';

/// Capstone communicative adventure validating that a child can demonstrate functional
/// language competence before completing a curriculum level.
class LevelMission extends Equatable {
  final String id;
  final String levelId;
  final String title;
  final String childFriendlyTitle;
  final String description;
  final List<String> assessedObjectiveIds;
  final String requiredEvidenceDescription;
  final int rewardStars;
  final int rewardXp;
  final String celebrationBadgeId;
  final Map<String, dynamic> metadata;

  const LevelMission({
    required this.id,
    required this.levelId,
    required this.title,
    required this.childFriendlyTitle,
    required this.description,
    this.assessedObjectiveIds = const [],
    required this.requiredEvidenceDescription,
    this.rewardStars = 5,
    this.rewardXp = 50,
    this.celebrationBadgeId = 'badge_level_complete',
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'levelId': levelId,
        'title': title,
        'childFriendlyTitle': childFriendlyTitle,
        'description': description,
        'assessedObjectiveIds': assessedObjectiveIds,
        'requiredEvidenceDescription': requiredEvidenceDescription,
        'rewardStars': rewardStars,
        'rewardXp': rewardXp,
        'celebrationBadgeId': celebrationBadgeId,
        'metadata': metadata,
      };

  factory LevelMission.fromJson(Map<String, dynamic> json) => LevelMission(
        id: json['id'] as String,
        levelId: json['levelId'] as String,
        title: json['title'] as String,
        childFriendlyTitle: json['childFriendlyTitle'] as String,
        description: json['description'] as String,
        assessedObjectiveIds:
            (json['assessedObjectiveIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        requiredEvidenceDescription: json['requiredEvidenceDescription'] as String? ?? '',
        rewardStars: json['rewardStars'] as int? ?? 5,
        rewardXp: json['rewardXp'] as int? ?? 50,
        celebrationBadgeId: json['celebrationBadgeId'] as String? ?? 'badge_level_complete',
        metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      );

  @override
  List<Object?> get props => [
        id,
        levelId,
        title,
        childFriendlyTitle,
        description,
        assessedObjectiveIds,
        requiredEvidenceDescription,
        rewardStars,
        rewardXp,
        celebrationBadgeId,
        metadata,
      ];
}
