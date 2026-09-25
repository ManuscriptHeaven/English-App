import 'package:equatable/equatable.dart';

/// Virtual learning companion for positive behavioral feedback and motivation.
class Pet extends Equatable {
  final String id;
  final String name;
  final String type; // e.g. 'falcon', 'kitten', 'bunny', 'pony'
  final int level;
  final int happiness; // 0 - 100
  final int energy; // 0 - 100
  final String assetPath;
  final List<String> equippedItemIds;

  const Pet({
    required this.id,
    required this.name,
    required this.type,
    this.level = 1,
    this.happiness = 100,
    this.energy = 100,
    required this.assetPath,
    this.equippedItemIds = const [],
  });

  Pet copyWith({
    String? id,
    String? name,
    String? type,
    int? level,
    int? happiness,
    int? energy,
    String? assetPath,
    List<String>? equippedItemIds,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      level: level ?? this.level,
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      assetPath: assetPath ?? this.assetPath,
      equippedItemIds: equippedItemIds ?? this.equippedItemIds,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'level': level,
        'happiness': happiness,
        'energy': energy,
        'assetPath': assetPath,
        'equippedItemIds': equippedItemIds,
      };

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        level: json['level'] as int? ?? 1,
        happiness: json['happiness'] as int? ?? 100,
        energy: json['energy'] as int? ?? 100,
        assetPath: json['assetPath'] as String,
        equippedItemIds: (json['equippedItemIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
      );

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        level,
        happiness,
        energy,
        assetPath,
        equippedItemIds,
      ];
}

/// Accessories or food treats for the pet.
class PetItem extends Equatable {
  final String id;
  final String name;
  final String category; // 'food', 'collar', 'toy', 'bed'
  final String assetPath;
  final int happinessBoost;
  final int costCoins;

  const PetItem({
    required this.id,
    required this.name,
    required this.category,
    required this.assetPath,
    this.happinessBoost = 10,
    required this.costCoins,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'assetPath': assetPath,
        'happinessBoost': happinessBoost,
        'costCoins': costCoins,
      };

  factory PetItem.fromJson(Map<String, dynamic> json) => PetItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        assetPath: json['assetPath'] as String,
        happinessBoost: json['happinessBoost'] as int? ?? 10,
        costCoins: json['costCoins'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [id, name, category, assetPath, happinessBoost, costCoins];
}
