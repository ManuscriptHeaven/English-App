import 'package:equatable/equatable.dart';
import 'session_activity.dart';

/// Status of a personalized learning session.
enum SessionStatus {
  planned,
  inProgress,
  paused,
  completed,
  abandoned,
}

/// Category defining the length and cognitive budget of a session.
enum SessionLengthCategory {
  micro,    // 1-2 activities (~5 min) - low energy/struggling/toddlers
  short,    // 2-3 activities (~8-10 min) - standard toddlers or quick bursts
  standard, // 3-4 activities (~12-15 min) - early explorers
  extended, // 4-5 activities (~18-20 min) - fluent explorers or high engagement
}

extension SessionLengthCategoryExtension on SessionLengthCategory {
  int get defaultEstimatedMinutes {
    switch (this) {
      case SessionLengthCategory.micro:
        return 5;
      case SessionLengthCategory.short:
        return 10;
      case SessionLengthCategory.standard:
        return 15;
      case SessionLengthCategory.extended:
        return 20;
    }
  }

  int get maxActivities {
    switch (this) {
      case SessionLengthCategory.micro:
        return 2;
      case SessionLengthCategory.short:
        return 3;
      case SessionLengthCategory.standard:
        return 4;
      case SessionLengthCategory.extended:
        return 5;
    }
  }
}

/// First-class domain object representing an orchestrated, personalized learning session.
class LearningSession extends Equatable {
  final String sessionId;
  final String childId;
  final String worldId;
  final String unitId;
  final String primaryGoal;
  final List<String> secondaryGoals;
  final List<String> targetVocabularyIds;
  final List<String> reviewVocabularyIds;
  final List<String> reinforcementVocabularyIds;
  final List<SessionActivity> activities;
  final int currentActivityIndex;
  final SessionStatus status;
  final SessionLengthCategory lengthCategory;
  final int difficultyLevel; // 1 to 5
  final SupportLevel supportLevel;
  final int totalEstimatedMinutes;
  final int actualDurationSeconds;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final Set<String> grantedRewardIds;
  final bool confidenceProtectionApplied;
  final DateTime createdAt;

  const LearningSession({
    required this.sessionId,
    required this.childId,
    required this.worldId,
    this.unitId = 'unit_1',
    required this.primaryGoal,
    this.secondaryGoals = const [],
    this.targetVocabularyIds = const [],
    this.reviewVocabularyIds = const [],
    this.reinforcementVocabularyIds = const [],
    required this.activities,
    this.currentActivityIndex = 0,
    this.status = SessionStatus.planned,
    this.lengthCategory = SessionLengthCategory.standard,
    this.difficultyLevel = 2,
    this.supportLevel = SupportLevel.guided,
    this.totalEstimatedMinutes = 15,
    this.actualDurationSeconds = 0,
    this.startedAt,
    this.completedAt,
    this.grantedRewardIds = const {},
    this.confidenceProtectionApplied = false,
    required this.createdAt,
  });

  /// Alias for backward compatibility with legacy code expecting `id`.
  String get id => sessionId;

  /// Current activity according to [currentActivityIndex].
  SessionActivity? get currentActivity {
    if (activities.isEmpty) return null;
    if (currentActivityIndex >= 0 && currentActivityIndex < activities.length) {
      return activities[currentActivityIndex];
    }
    return nextActivity;
  }

  /// First uncompleted activity in sequence.
  SessionActivity? get nextActivity {
    for (final act in activities) {
      if (!act.isCompleted) {
        return act;
      }
    }
    return null;
  }

  int get completedCount => activities.where((a) => a.isCompleted).length;
  int get totalCount => activities.length;
  double get progressPercentage => totalCount > 0 ? (completedCount / totalCount).clamp(0.0, 1.0) : 0.0;
  bool get isCompleted => status == SessionStatus.completed;

  /// Check if a specific reward key has already been granted to prevent duplicate rewards.
  bool isRewardGranted(String rewardKey) => grantedRewardIds.contains(rewardKey);

  /// Mark session as started.
  LearningSession start({DateTime? now}) {
    final startTime = now ?? DateTime.now();
    return copyWith(
      status: SessionStatus.inProgress,
      startedAt: startedAt ?? startTime,
    );
  }

  /// Pause active session.
  LearningSession pause() {
    return copyWith(status: SessionStatus.paused);
  }

  /// Resume paused session.
  LearningSession resume() {
    return copyWith(status: SessionStatus.inProgress);
  }

  /// Mark current activity as completed and advance pointer.
  LearningSession completeActivity(
    String activityId, {
    double? score,
    DateTime? completedAt,
  }) {
    final completionTime = completedAt ?? DateTime.now();
    final updatedActivities = activities.map((act) {
      if (act.activityId == activityId) {
        return act.markCompleted(score: score, completedAt: completionTime);
      }
      return act;
    }).toList();

    final allDone = updatedActivities.every((a) => a.isCompleted);
    final nextIndex = updatedActivities.indexWhere((a) => !a.isCompleted);

    return copyWith(
      activities: updatedActivities,
      currentActivityIndex: nextIndex != -1 ? nextIndex : updatedActivities.length - 1,
      status: allDone ? SessionStatus.completed : SessionStatus.inProgress,
      completedAt: allDone ? completionTime : this.completedAt,
    );
  }

  /// Grant a specific reward ID to this session in an idempotent manner.
  LearningSession grantReward(String rewardKey) {
    final updated = Set<String>.from(grantedRewardIds)..add(rewardKey);
    return copyWith(grantedRewardIds: updated);
  }

  /// Mark entire session as completed.
  LearningSession markCompleted({DateTime? completedAt}) {
    final time = completedAt ?? DateTime.now();
    final updatedActivities = activities.map((a) => a.isCompleted ? a : a.markCompleted(completedAt: time)).toList();
    return copyWith(
      status: SessionStatus.completed,
      completedAt: time,
      activities: updatedActivities,
      currentActivityIndex: activities.isNotEmpty ? activities.length - 1 : 0,
    );
  }

  /// Mark session as abandoned.
  LearningSession markAbandoned() {
    return copyWith(status: SessionStatus.abandoned);
  }

  LearningSession copyWith({
    String? sessionId,
    String? childId,
    String? worldId,
    String? unitId,
    String? primaryGoal,
    List<String>? secondaryGoals,
    List<String>? targetVocabularyIds,
    List<String>? reviewVocabularyIds,
    List<String>? reinforcementVocabularyIds,
    List<SessionActivity>? activities,
    int? currentActivityIndex,
    SessionStatus? status,
    SessionLengthCategory? lengthCategory,
    int? difficultyLevel,
    SupportLevel? supportLevel,
    int? totalEstimatedMinutes,
    int? actualDurationSeconds,
    DateTime? startedAt,
    DateTime? completedAt,
    Set<String>? grantedRewardIds,
    bool? confidenceProtectionApplied,
    DateTime? createdAt,
  }) {
    return LearningSession(
      sessionId: sessionId ?? this.sessionId,
      childId: childId ?? this.childId,
      worldId: worldId ?? this.worldId,
      unitId: unitId ?? this.unitId,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      secondaryGoals: secondaryGoals ?? this.secondaryGoals,
      targetVocabularyIds: targetVocabularyIds ?? this.targetVocabularyIds,
      reviewVocabularyIds: reviewVocabularyIds ?? this.reviewVocabularyIds,
      reinforcementVocabularyIds: reinforcementVocabularyIds ?? this.reinforcementVocabularyIds,
      activities: activities ?? this.activities,
      currentActivityIndex: currentActivityIndex ?? this.currentActivityIndex,
      status: status ?? this.status,
      lengthCategory: lengthCategory ?? this.lengthCategory,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      supportLevel: supportLevel ?? this.supportLevel,
      totalEstimatedMinutes: totalEstimatedMinutes ?? this.totalEstimatedMinutes,
      actualDurationSeconds: actualDurationSeconds ?? this.actualDurationSeconds,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      grantedRewardIds: grantedRewardIds ?? this.grantedRewardIds,
      confidenceProtectionApplied: confidenceProtectionApplied ?? this.confidenceProtectionApplied,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'childId': childId,
        'worldId': worldId,
        'unitId': unitId,
        'primaryGoal': primaryGoal,
        'secondaryGoals': secondaryGoals,
        'targetVocabularyIds': targetVocabularyIds,
        'reviewVocabularyIds': reviewVocabularyIds,
        'reinforcementVocabularyIds': reinforcementVocabularyIds,
        'activities': activities.map((e) => e.toJson()).toList(),
        'currentActivityIndex': currentActivityIndex,
        'status': status.name,
        'lengthCategory': lengthCategory.name,
        'difficultyLevel': difficultyLevel,
        'supportLevel': supportLevel.name,
        'totalEstimatedMinutes': totalEstimatedMinutes,
        'actualDurationSeconds': actualDurationSeconds,
        'startedAt': startedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'grantedRewardIds': grantedRewardIds.toList(),
        'confidenceProtectionApplied': confidenceProtectionApplied,
        'createdAt': createdAt.toIso8601String(),
      };

  factory LearningSession.fromJson(Map<String, dynamic> json) => LearningSession(
        sessionId: json['sessionId'] as String? ?? json['id'] as String? ?? 'unknown_session',
        childId: json['childId'] as String,
        worldId: json['worldId'] as String? ?? 'world_animal',
        unitId: json['unitId'] as String? ?? 'unit_1',
        primaryGoal: json['primaryGoal'] as String? ?? 'English vocabulary exploration',
        secondaryGoals: (json['secondaryGoals'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        targetVocabularyIds: (json['targetVocabularyIds'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        reviewVocabularyIds: (json['reviewVocabularyIds'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        reinforcementVocabularyIds: (json['reinforcementVocabularyIds'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        activities: (json['activities'] as List<dynamic>?)
                ?.map((e) => SessionActivity.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        currentActivityIndex: json['currentActivityIndex'] as int? ?? 0,
        status: SessionStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => SessionStatus.planned,
        ),
        lengthCategory: SessionLengthCategory.values.firstWhere(
          (e) => e.name == json['lengthCategory'],
          orElse: () => SessionLengthCategory.standard,
        ),
        difficultyLevel: json['difficultyLevel'] as int? ?? 2,
        supportLevel: SupportLevel.values.firstWhere(
          (e) => e.name == json['supportLevel'],
          orElse: () => SupportLevel.guided,
        ),
        totalEstimatedMinutes: json['totalEstimatedMinutes'] as int? ?? 15,
        actualDurationSeconds: json['actualDurationSeconds'] as int? ?? 0,
        startedAt: json['startedAt'] != null
            ? DateTime.tryParse(json['startedAt'] as String)
            : null,
        completedAt: json['completedAt'] != null
            ? DateTime.tryParse(json['completedAt'] as String)
            : null,
        grantedRewardIds: (json['grantedRewardIds'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toSet() ??
            const {},
        confidenceProtectionApplied: json['confidenceProtectionApplied'] as bool? ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
      );

  @override
  List<Object?> get props => [
        sessionId,
        childId,
        worldId,
        unitId,
        primaryGoal,
        secondaryGoals,
        targetVocabularyIds,
        reviewVocabularyIds,
        reinforcementVocabularyIds,
        activities,
        currentActivityIndex,
        status,
        lengthCategory,
        difficultyLevel,
        supportLevel,
        totalEstimatedMinutes,
        actualDurationSeconds,
        startedAt,
        completedAt,
        grantedRewardIds,
        confidenceProtectionApplied,
        createdAt,
      ];
}
