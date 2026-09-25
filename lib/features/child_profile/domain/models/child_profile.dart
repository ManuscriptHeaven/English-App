import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/age_group_config.dart';
import 'avatar.dart';
import 'pet.dart';

/// Primary domain model representing a child explorer profile.
class ChildProfile extends Equatable {
  final String id;
  final String parentId;
  final String name;
  final int age;
  final String gender; // 'boy' or 'girl'
  final Avatar avatar;
  final Pet? pet;
  final int level;
  final int xp;
  final int coins;
  final int stars;
  final int streakDays;
  final DateTime? lastActiveDate;
  final List<String> unlockedWorldIds;
  final List<String> completedLessonIds;
  final List<String> unlockedAchievementIds;
  final List<String> inventoryItemIds;
  final List<String> interests; // e.g. ['animals', 'space', 'sports']
  final String currentCurriculumLevelId;
  final List<String> activeUnitIds;
  final List<String> completedObjectiveIds;
  final List<String> demonstratedCanDoIds;

  const ChildProfile({
    required this.id,
    required this.parentId,
    required this.name,
    required this.age,
    this.gender = 'boy',
    required this.avatar,
    this.pet,
    this.level = 1,
    this.xp = AppConstants.defaultStartingXp,
    this.coins = AppConstants.defaultStartingCoins,
    this.stars = AppConstants.defaultStartingStars,
    this.streakDays = 1,
    this.lastActiveDate,
    this.unlockedWorldIds = const ['world_animal'],
    this.completedLessonIds = const [],
    this.unlockedAchievementIds = const [],
    this.inventoryItemIds = const [],
    this.interests = const ['animals'],
    this.currentCurriculumLevelId = 'level_1_first_words',
    this.activeUnitIds = const [],
    this.completedObjectiveIds = const [],
    this.demonstratedCanDoIds = const [],
  });

  AgeGroupType get ageGroup => AgeGroupType.fromAge(age);
  AgeGroupConfig get uiConfig => AgeGroupConfig.forAge(age);

  ChildProfile copyWith({
    String? id,
    String? parentId,
    String? name,
    int? age,
    String? gender,
    Avatar? avatar,
    Pet? pet,
    int? level,
    int? xp,
    int? coins,
    int? stars,
    int? streakDays,
    DateTime? lastActiveDate,
    List<String>? unlockedWorldIds,
    List<String>? completedLessonIds,
    List<String>? unlockedAchievementIds,
    List<String>? inventoryItemIds,
    List<String>? interests,
    String? currentCurriculumLevelId,
    List<String>? activeUnitIds,
    List<String>? completedObjectiveIds,
    List<String>? demonstratedCanDoIds,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      pet: pet ?? this.pet,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      stars: stars ?? this.stars,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      unlockedWorldIds: unlockedWorldIds ?? this.unlockedWorldIds,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      unlockedAchievementIds: unlockedAchievementIds ?? this.unlockedAchievementIds,
      inventoryItemIds: inventoryItemIds ?? this.inventoryItemIds,
      interests: interests ?? this.interests,
      currentCurriculumLevelId: currentCurriculumLevelId ?? this.currentCurriculumLevelId,
      activeUnitIds: activeUnitIds ?? this.activeUnitIds,
      completedObjectiveIds: completedObjectiveIds ?? this.completedObjectiveIds,
      demonstratedCanDoIds: demonstratedCanDoIds ?? this.demonstratedCanDoIds,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'parentId': parentId,
        'name': name,
        'age': age,
        'gender': gender,
        'avatar': avatar.toJson(),
        'pet': pet?.toJson(),
        'level': level,
        'xp': xp,
        'coins': coins,
        'stars': stars,
        'streakDays': streakDays,
        'lastActiveDate': lastActiveDate?.toIso8601String(),
        'unlockedWorldIds': unlockedWorldIds,
        'completedLessonIds': completedLessonIds,
        'unlockedAchievementIds': unlockedAchievementIds,
        'inventoryItemIds': inventoryItemIds,
        'interests': interests,
        'currentCurriculumLevelId': currentCurriculumLevelId,
        'activeUnitIds': activeUnitIds,
        'completedObjectiveIds': completedObjectiveIds,
        'demonstratedCanDoIds': demonstratedCanDoIds,
      };

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
        id: json['id'] as String,
        parentId: json['parentId'] as String? ?? 'default_parent',
        name: json['name'] as String,
        age: json['age'] as int,
        gender: json['gender'] as String? ?? 'boy',
        avatar: Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
        pet: json['pet'] != null ? Pet.fromJson(json['pet'] as Map<String, dynamic>) : null,
        level: json['level'] as int? ?? 1,
        xp: json['xp'] as int? ?? AppConstants.defaultStartingXp,
        coins: json['coins'] as int? ?? AppConstants.defaultStartingCoins,
        stars: json['stars'] as int? ?? AppConstants.defaultStartingStars,
        streakDays: json['streakDays'] as int? ?? 1,
        lastActiveDate: json['lastActiveDate'] != null
            ? DateTime.tryParse(json['lastActiveDate'] as String)
            : null,
        unlockedWorldIds: (json['unlockedWorldIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const ['world_animal'],
        completedLessonIds: (json['completedLessonIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        unlockedAchievementIds: (json['unlockedAchievementIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        inventoryItemIds: (json['inventoryItemIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        interests: (json['interests'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const ['animals'],
        currentCurriculumLevelId:
            json['currentCurriculumLevelId'] as String? ?? 'level_1_first_words',
        activeUnitIds: (json['activeUnitIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        completedObjectiveIds: (json['completedObjectiveIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        demonstratedCanDoIds: (json['demonstratedCanDoIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
      );

  @override
  List<Object?> get props => [
        id,
        parentId,
        name,
        age,
        gender,
        avatar,
        pet,
        level,
        xp,
        coins,
        stars,
        streakDays,
        lastActiveDate,
        unlockedWorldIds,
        completedLessonIds,
        unlockedAchievementIds,
        inventoryItemIds,
        interests,
        currentCurriculumLevelId,
        activeUnitIds,
        completedObjectiveIds,
        demonstratedCanDoIds,
      ];
}
