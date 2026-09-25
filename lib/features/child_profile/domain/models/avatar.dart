import 'package:equatable/equatable.dart';

/// Supported system avatar identifier or customizable visual asset.
class Avatar extends Equatable {
  final String id;
  final String name;
  final String assetPath;
  final bool isUnlocked;

  const Avatar({
    required this.id,
    required this.name,
    required this.assetPath,
    this.isUnlocked = true,
  });

  Avatar copyWith({
    String? id,
    String? name,
    String? assetPath,
    bool? isUnlocked,
  }) {
    return Avatar(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'assetPath': assetPath,
        'isUnlocked': isUnlocked,
      };

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        id: json['id'] as String,
        name: json['name'] as String,
        assetPath: json['assetPath'] as String,
        isUnlocked: json['isUnlocked'] as bool? ?? true,
      );

  @override
  List<Object?> get props => [id, name, assetPath, isUnlocked];
}

/// Customizable avatar accessories (e.g. hats, glasses, capes).
class AvatarItem extends Equatable {
  final String id;
  final String name;
  final String category; // 'hat', 'glasses', 'cape'
  final String assetPath;
  final int requiredCoins;
  final bool isUnlocked;

  const AvatarItem({
    required this.id,
    required this.name,
    required this.category,
    required this.assetPath,
    required this.requiredCoins,
    this.isUnlocked = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'assetPath': assetPath,
        'requiredCoins': requiredCoins,
        'isUnlocked': isUnlocked,
      };

  factory AvatarItem.fromJson(Map<String, dynamic> json) => AvatarItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        assetPath: json['assetPath'] as String,
        requiredCoins: json['requiredCoins'] as int? ?? 0,
        isUnlocked: json['isUnlocked'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [id, name, category, assetPath, requiredCoins, isUnlocked];
}
