import 'package:equatable/equatable.dart';
import 'content_metadata.dart';
import 'chapter.dart';

/// Top-level themed learning world in the adventure map.
class World extends Equatable {
  final String id;
  final String title;
  final String theme; // e.g. 'animal', 'home', 'school', 'food', 'adventure'
  final String description;
  final String bannerAssetPath;
  final String primaryColorHex;
  final int orderIndex;
  final ContentMetadata metadata;
  final List<Chapter> chapters;
  final List<String> featuredValues;
  final bool isUnlocked;

  const World({
    required this.id,
    required this.title,
    required this.theme,
    required this.description,
    required this.bannerAssetPath,
    required this.primaryColorHex,
    required this.orderIndex,
    required this.metadata,
    required this.chapters,
    this.featuredValues = const [],
    this.isUnlocked = false,
  });

  World copyWith({
    String? id,
    String? title,
    String? theme,
    String? description,
    String? bannerAssetPath,
    String? primaryColorHex,
    int? orderIndex,
    ContentMetadata? metadata,
    List<Chapter>? chapters,
    List<String>? featuredValues,
    bool? isUnlocked,
  }) {
    return World(
      id: id ?? this.id,
      title: title ?? this.title,
      theme: theme ?? this.theme,
      description: description ?? this.description,
      bannerAssetPath: bannerAssetPath ?? this.bannerAssetPath,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      orderIndex: orderIndex ?? this.orderIndex,
      metadata: metadata ?? this.metadata,
      chapters: chapters ?? this.chapters,
      featuredValues: featuredValues ?? this.featuredValues,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'theme': theme,
        'description': description,
        'bannerAssetPath': bannerAssetPath,
        'primaryColorHex': primaryColorHex,
        'orderIndex': orderIndex,
        'metadata': metadata.toJson(),
        'chapters': chapters.map((c) => c.toJson()).toList(),
        'featuredValues': featuredValues,
        'isUnlocked': isUnlocked,
      };

  factory World.fromJson(Map<String, dynamic> json) => World(
        id: json['id'] as String,
        title: json['title'] as String,
        theme: json['theme'] as String,
        description: json['description'] as String,
        bannerAssetPath: json['bannerAssetPath'] as String,
        primaryColorHex: json['primaryColorHex'] as String? ?? '0xFF66BB6A',
        orderIndex: json['orderIndex'] as int,
        metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
        chapters: (json['chapters'] as List<dynamic>)
            .map((c) => Chapter.fromJson(c as Map<String, dynamic>))
            .toList(),
        featuredValues: (json['featuredValues'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        isUnlocked: json['isUnlocked'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        theme,
        description,
        bannerAssetPath,
        primaryColorHex,
        orderIndex,
        metadata,
        chapters,
        featuredValues,
        isUnlocked,
      ];
}
