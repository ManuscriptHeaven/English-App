import 'package:equatable/equatable.dart';

/// Daily mission task motivating consistent practice (e.g. "Learn 3 new animal words", "Read 1 story").
class DailyMission extends Equatable {
  final String id;
  final String title;
  final String description;
  final int targetCount;
  final int currentCount;
  final int rewardCoins;
  final int rewardStars;
  final bool isCompleted;

  const DailyMission({
    required this.id,
    required this.title,
    required this.description,
    required this.targetCount,
    this.currentCount = 0,
    this.rewardCoins = 15,
    this.rewardStars = 1,
    this.isCompleted = false,
  });

  DailyMission copyWith({
    String? id,
    String? title,
    String? description,
    int? targetCount,
    int? currentCount,
    int? rewardCoins,
    int? rewardStars,
    bool? isCompleted,
  }) {
    return DailyMission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      rewardStars: rewardStars ?? this.rewardStars,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'targetCount': targetCount,
        'currentCount': currentCount,
        'rewardCoins': rewardCoins,
        'rewardStars': rewardStars,
        'isCompleted': isCompleted,
      };

  factory DailyMission.fromJson(Map<String, dynamic> json) => DailyMission(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        targetCount: json['targetCount'] as int,
        currentCount: json['currentCount'] as int? ?? 0,
        rewardCoins: json['rewardCoins'] as int? ?? 15,
        rewardStars: json['rewardStars'] as int? ?? 1,
        isCompleted: json['isCompleted'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        targetCount,
        currentCount,
        rewardCoins,
        rewardStars,
        isCompleted,
      ];
}
