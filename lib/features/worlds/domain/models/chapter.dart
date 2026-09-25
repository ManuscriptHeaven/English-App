import 'package:equatable/equatable.dart';
import 'content_metadata.dart';
import 'unit.dart';

/// A major chapter inside a themed adventure world.
class Chapter extends Equatable {
  final String id;
  final String worldId;
  final String title;
  final String description;
  final int orderIndex;
  final ContentMetadata metadata;
  final List<Unit> units;
  final bool isUnlocked;

  const Chapter({
    required this.id,
    required this.worldId,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.metadata,
    required this.units,
    this.isUnlocked = false,
  });

  Chapter copyWith({
    String? id,
    String? worldId,
    String? title,
    String? description,
    int? orderIndex,
    ContentMetadata? metadata,
    List<Unit>? units,
    bool? isUnlocked,
  }) {
    return Chapter(
      id: id ?? this.id,
      worldId: worldId ?? this.worldId,
      title: title ?? this.title,
      description: description ?? this.description,
      orderIndex: orderIndex ?? this.orderIndex,
      metadata: metadata ?? this.metadata,
      units: units ?? this.units,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'worldId': worldId,
        'title': title,
        'description': description,
        'orderIndex': orderIndex,
        'metadata': metadata.toJson(),
        'units': units.map((u) => u.toJson()).toList(),
        'isUnlocked': isUnlocked,
      };

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json['id'] as String,
        worldId: json['worldId'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        orderIndex: json['orderIndex'] as int,
        metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
        units: (json['units'] as List<dynamic>)
            .map((u) => Unit.fromJson(u as Map<String, dynamic>))
            .toList(),
        isUnlocked: json['isUnlocked'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [
        id,
        worldId,
        title,
        description,
        orderIndex,
        metadata,
        units,
        isUnlocked,
      ];
}
