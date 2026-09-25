import 'package:equatable/equatable.dart';

/// Reward item types (Avatar items, Pet items, Stickers, Badges, World unlocks).
enum RewardType {
  avatarItem,
  petItem,
  sticker,
  badge,
  worldUnlock,
  mysteryBox,
}

/// Generic reward item.
class Reward extends Equatable {
  final String id;
  final String title;
  final String description;
  final RewardType type;
  final String iconAssetPath;
  final int xpValue;
  final int coinValue;
  final int starValue;

  const Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.iconAssetPath,
    this.xpValue = 0,
    this.coinValue = 0,
    this.starValue = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type.name,
        'iconAssetPath': iconAssetPath,
        'xpValue': xpValue,
        'coinValue': coinValue,
        'starValue': starValue,
      };

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        type: RewardType.values.firstWhere((e) => e.name == json['type']),
        iconAssetPath: json['iconAssetPath'] as String,
        xpValue: json['xpValue'] as int? ?? 0,
        coinValue: json['coinValue'] as int? ?? 0,
        starValue: json['starValue'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        iconAssetPath,
        xpValue,
        coinValue,
        starValue,
      ];
}
