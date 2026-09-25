import 'package:equatable/equatable.dart';
import 'content_metadata.dart';
import 'activity.dart';

/// Distinct step in the 7-stage learning loop.
enum LearningLoopStep {
  discover,
  practice,
  play,
  recall,
  use,
  review,
  reward;

  String get displayName {
    switch (this) {
      case LearningLoopStep.discover:
        return 'Discover';
      case LearningLoopStep.practice:
        return 'Practice';
      case LearningLoopStep.play:
        return 'Play';
      case LearningLoopStep.recall:
        return 'Recall';
      case LearningLoopStep.use:
        return 'Use in Life';
      case LearningLoopStep.review:
        return 'Review';
      case LearningLoopStep.reward:
        return 'Reward';
    }
  }
}

/// A structured lesson composed of sequenced activities, vocabulary words, grammar rules,
/// and associated Islamic values/manners.
class Lesson extends Equatable {
  final String id;
  final String unitId;
  final String title;
  final String subtitle;
  final int orderIndex;
  final ContentMetadata metadata;
  final List<String> targetVocabularyIds;
  final String? targetGrammarId;
  final String? targetPhonicsId;
  final String? connectedValueId;
  final String? connectedMannerId;
  final List<Activity> activities;
  final int rewardXp;
  final int rewardCoins;
  final int rewardStars;
  final bool isUnlocked;

  const Lesson({
    required this.id,
    required this.unitId,
    required this.title,
    required this.subtitle,
    required this.orderIndex,
    required this.metadata,
    this.targetVocabularyIds = const [],
    this.targetGrammarId,
    this.targetPhonicsId,
    this.connectedValueId,
    this.connectedMannerId,
    required this.activities,
    this.rewardXp = 30,
    this.rewardCoins = 15,
    this.rewardStars = 3,
    this.isUnlocked = false,
  });

  Lesson copyWith({
    String? id,
    String? unitId,
    String? title,
    String? subtitle,
    int? orderIndex,
    ContentMetadata? metadata,
    List<String>? targetVocabularyIds,
    String? targetGrammarId,
    String? targetPhonicsId,
    String? connectedValueId,
    String? connectedMannerId,
    List<Activity>? activities,
    int? rewardXp,
    int? rewardCoins,
    int? rewardStars,
    bool? isUnlocked,
  }) {
    return Lesson(
      id: id ?? this.id,
      unitId: unitId ?? this.unitId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      orderIndex: orderIndex ?? this.orderIndex,
      metadata: metadata ?? this.metadata,
      targetVocabularyIds: targetVocabularyIds ?? this.targetVocabularyIds,
      targetGrammarId: targetGrammarId ?? this.targetGrammarId,
      targetPhonicsId: targetPhonicsId ?? this.targetPhonicsId,
      connectedValueId: connectedValueId ?? this.connectedValueId,
      connectedMannerId: connectedMannerId ?? this.connectedMannerId,
      activities: activities ?? this.activities,
      rewardXp: rewardXp ?? this.rewardXp,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      rewardStars: rewardStars ?? this.rewardStars,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'unitId': unitId,
        'title': title,
        'subtitle': subtitle,
        'orderIndex': orderIndex,
        'metadata': metadata.toJson(),
        'targetVocabularyIds': targetVocabularyIds,
        'targetGrammarId': targetGrammarId,
        'targetPhonicsId': targetPhonicsId,
        'connectedValueId': connectedValueId,
        'connectedMannerId': connectedMannerId,
        'activities': activities.map((a) => a.toJson()).toList(),
        'rewardXp': rewardXp,
        'rewardCoins': rewardCoins,
        'rewardStars': rewardStars,
        'isUnlocked': isUnlocked,
      };

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'] as String,
        unitId: json['unitId'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        orderIndex: json['orderIndex'] as int,
        metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
        targetVocabularyIds: (json['targetVocabularyIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        targetGrammarId: json['targetGrammarId'] as String?,
        targetPhonicsId: json['targetPhonicsId'] as String?,
        connectedValueId: json['connectedValueId'] as String?,
        connectedMannerId: json['connectedMannerId'] as String?,
        activities: (json['activities'] as List<dynamic>)
            .map((a) => Activity.fromJson(a as Map<String, dynamic>))
            .toList(),
        rewardXp: json['rewardXp'] as int? ?? 30,
        rewardCoins: json['rewardCoins'] as int? ?? 15,
        rewardStars: json['rewardStars'] as int? ?? 3,
        isUnlocked: json['isUnlocked'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [
        id,
        unitId,
        title,
        subtitle,
        orderIndex,
        metadata,
        targetVocabularyIds,
        targetGrammarId,
        targetPhonicsId,
        connectedValueId,
        connectedMannerId,
        activities,
        rewardXp,
        rewardCoins,
        rewardStars,
        isUnlocked,
      ];
}
