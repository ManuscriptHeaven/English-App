import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'conversation_turn.dart';

/// Conversation curriculum model containing scripted turns and educational objectives.
class Conversation extends Equatable {
  final String id;
  final String title;
  final String description;
  final int ageMin;
  final int ageMax;
  final SkillType skill;
  final String learningObjective;
  final List<String> valueIds;
  final List<String> mannerIds;
  final List<ConversationTurn> turns;
  final int rewardXp;
  final int rewardCoins;
  final int rewardStars;

  const Conversation({
    required this.id,
    required this.title,
    required this.description,
    this.ageMin = 3,
    this.ageMax = 10,
    this.skill = SkillType.speaking,
    required this.learningObjective,
    this.valueIds = const [],
    this.mannerIds = const [],
    this.turns = const [],
    this.rewardXp = 30,
    this.rewardCoins = 15,
    this.rewardStars = 3,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'ageMin': ageMin,
        'ageMax': ageMax,
        'skill': skill.name,
        'learningObjective': learningObjective,
        'valueIds': valueIds,
        'mannerIds': mannerIds,
        'turns': turns.map((t) => t.toJson()).toList(),
        'rewardXp': rewardXp,
        'rewardCoins': rewardCoins,
        'rewardStars': rewardStars,
      };

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        ageMin: json['ageMin'] as int? ?? 3,
        ageMax: json['ageMax'] as int? ?? 10,
        skill: SkillType.values.firstWhere(
          (e) => e.name == json['skill'],
          orElse: () => SkillType.speaking,
        ),
        learningObjective: json['learningObjective'] as String? ?? '',
        valueIds: List<String>.from(json['valueIds'] as List? ?? []),
        mannerIds: List<String>.from(json['mannerIds'] as List? ?? []),
        turns: (json['turns'] as List<dynamic>?)
                ?.map((e) =>
                    ConversationTurn.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        rewardXp: json['rewardXp'] as int? ?? 30,
        rewardCoins: json['rewardCoins'] as int? ?? 15,
        rewardStars: json['rewardStars'] as int? ?? 3,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        ageMin,
        ageMax,
        skill,
        learningObjective,
        valueIds,
        mannerIds,
        turns,
        rewardXp,
        rewardCoins,
        rewardStars,
      ];
}
