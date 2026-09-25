import 'package:equatable/equatable.dart';
import 'content_metadata.dart';
import 'lesson.dart';

/// A learning unit containing a series of lessons, practice games, and a storybook.
class Unit extends Equatable {
  final String id;
  final String chapterId;
  final String title;
  final String subtitle;
  final int orderIndex;
  final ContentMetadata metadata;
  final List<Lesson> lessons;
  final String? featuredStoryId;
  final String? primaryIslamicValueId;
  final bool isUnlocked;

  const Unit({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.subtitle,
    required this.orderIndex,
    required this.metadata,
    required this.lessons,
    this.featuredStoryId,
    this.primaryIslamicValueId,
    this.isUnlocked = false,
  });

  Unit copyWith({
    String? id,
    String? chapterId,
    String? title,
    String? subtitle,
    int? orderIndex,
    ContentMetadata? metadata,
    List<Lesson>? lessons,
    String? featuredStoryId,
    String? primaryIslamicValueId,
    bool? isUnlocked,
  }) {
    return Unit(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      orderIndex: orderIndex ?? this.orderIndex,
      metadata: metadata ?? this.metadata,
      lessons: lessons ?? this.lessons,
      featuredStoryId: featuredStoryId ?? this.featuredStoryId,
      primaryIslamicValueId: primaryIslamicValueId ?? this.primaryIslamicValueId,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chapterId': chapterId,
        'title': title,
        'subtitle': subtitle,
        'orderIndex': orderIndex,
        'metadata': metadata.toJson(),
        'lessons': lessons.map((l) => l.toJson()).toList(),
        'featuredStoryId': featuredStoryId,
        'primaryIslamicValueId': primaryIslamicValueId,
        'isUnlocked': isUnlocked,
      };

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json['id'] as String,
        chapterId: json['chapterId'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        orderIndex: json['orderIndex'] as int,
        metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
        lessons: (json['lessons'] as List<dynamic>)
            .map((l) => Lesson.fromJson(l as Map<String, dynamic>))
            .toList(),
        featuredStoryId: json['featuredStoryId'] as String?,
        primaryIslamicValueId: json['primaryIslamicValueId'] as String?,
        isUnlocked: json['isUnlocked'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [
        id,
        chapterId,
        title,
        subtitle,
        orderIndex,
        metadata,
        lessons,
        featuredStoryId,
        primaryIslamicValueId,
        isUnlocked,
      ];
}
