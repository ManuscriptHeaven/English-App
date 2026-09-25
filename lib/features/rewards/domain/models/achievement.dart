import 'package:equatable/equatable.dart';

/// An achievement badge awarded for milestones (e.g. "First 10 Words", "Kindness Hero", "7-Day Streak").
class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category; // 'vocabulary', 'stories', 'streak', 'values', 'worlds'
  final String iconAssetPath;
  final int targetGoal;
  final int currentProgress;
  final int rewardCoins;
  final int rewardXp;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.iconAssetPath,
    required this.targetGoal,
    this.currentProgress = 0,
    this.rewardCoins = 50,
    this.rewardXp = 100,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? iconAssetPath,
    int? targetGoal,
    int? currentProgress,
    int? rewardCoins,
    int? rewardXp,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      iconAssetPath: iconAssetPath ?? this.iconAssetPath,
      targetGoal: targetGoal ?? this.targetGoal,
      currentProgress: currentProgress ?? this.currentProgress,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      rewardXp: rewardXp ?? this.rewardXp,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'iconAssetPath': iconAssetPath,
        'targetGoal': targetGoal,
        'currentProgress': currentProgress,
        'rewardCoins': rewardCoins,
        'rewardXp': rewardXp,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        iconAssetPath: json['iconAssetPath'] as String,
        targetGoal: json['targetGoal'] as int,
        currentProgress: json['currentProgress'] as int? ?? 0,
        rewardCoins: json['rewardCoins'] as int? ?? 50,
        rewardXp: json['rewardXp'] as int? ?? 100,
        isUnlocked: json['isUnlocked'] as bool? ?? false,
        unlockedAt: json['unlockedAt'] != null
            ? DateTime.tryParse(json['unlockedAt'] as String)
            : null,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        iconAssetPath,
        targetGoal,
        currentProgress,
        rewardCoins,
        rewardXp,
        isUnlocked,
        unlockedAt,
      ];
}
