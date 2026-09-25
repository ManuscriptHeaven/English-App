import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'story_page.dart';
import 'story_question.dart';

/// Story domain entity connecting rich illustrations, narration, English vocabulary,
/// grammar targets, and Islamic values.
class Story extends Equatable {
  final String id;
  final String worldId;
  final String? unitId;
  final String title;
  final String subtitle;
  final String coverAssetPath;
  final ContentMetadata metadata;
  final List<StoryPage> pages;
  final List<String> targetVocabularyIds;
  final List<String> targetGrammarTopicIds;
  final List<String> connectedIslamicValueIds;
  final List<String> connectedMannerIds;
  final List<StoryQuestion> comprehensionQuestions;
  final int rewardXp;
  final int rewardCoins;
  final int rewardStars;
  final bool isUnlocked;

  const Story({
    required this.id,
    required this.worldId,
    this.unitId,
    required this.title,
    required this.subtitle,
    required this.coverAssetPath,
    required this.metadata,
    required this.pages,
    this.targetVocabularyIds = const [],
    this.targetGrammarTopicIds = const [],
    this.connectedIslamicValueIds = const [],
    this.connectedMannerIds = const [],
    this.comprehensionQuestions = const [],
    this.rewardXp = 40,
    this.rewardCoins = 20,
    this.rewardStars = 3,
    this.isUnlocked = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'worldId': worldId,
        'unitId': unitId,
        'title': title,
        'subtitle': subtitle,
        'coverAssetPath': coverAssetPath,
        'metadata': metadata.toJson(),
        'pages': pages.map((p) => p.toJson()).toList(),
        'targetVocabularyIds': targetVocabularyIds,
        'targetGrammarTopicIds': targetGrammarTopicIds,
        'connectedIslamicValueIds': connectedIslamicValueIds,
        'connectedMannerIds': connectedMannerIds,
        'comprehensionQuestions': comprehensionQuestions.map((q) => q.toJson()).toList(),
        'rewardXp': rewardXp,
        'rewardCoins': rewardCoins,
        'rewardStars': rewardStars,
        'isUnlocked': isUnlocked,
      };

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json['id'] as String,
        worldId: json['worldId'] as String,
        unitId: json['unitId'] as String?,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        coverAssetPath: json['coverAssetPath'] as String,
        metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
        pages: (json['pages'] as List<dynamic>)
            .map((p) => StoryPage.fromJson(p as Map<String, dynamic>))
            .toList(),
        targetVocabularyIds: (json['targetVocabularyIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        targetGrammarTopicIds: (json['targetGrammarTopicIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        connectedIslamicValueIds: (json['connectedIslamicValueIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        connectedMannerIds: (json['connectedMannerIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        comprehensionQuestions: (json['comprehensionQuestions'] as List<dynamic>?)
                ?.map((q) => StoryQuestion.fromJson(q as Map<String, dynamic>))
                .toList() ??
            const [],
        rewardXp: json['rewardXp'] as int? ?? 40,
        rewardCoins: json['rewardCoins'] as int? ?? 20,
        rewardStars: json['rewardStars'] as int? ?? 3,
        isUnlocked: json['isUnlocked'] as bool? ?? true,
      );

  @override
  List<Object?> get props => [
        id,
        worldId,
        unitId,
        title,
        subtitle,
        coverAssetPath,
        metadata,
        pages,
        targetVocabularyIds,
        targetGrammarTopicIds,
        connectedIslamicValueIds,
        connectedMannerIds,
        comprehensionQuestions,
        rewardXp,
        rewardCoins,
        rewardStars,
        isUnlocked,
      ];
}
