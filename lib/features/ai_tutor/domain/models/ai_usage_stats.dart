import 'package:equatable/equatable.dart';

/// Aggregated usage statistics per child to enforce deterministic daily/monthly limits.
class AiUsageStats extends Equatable {
  final String childId;
  final String dateKey; // 'YYYY-MM-DD'
  final int usedMinutes;
  final int usedTurns;
  final int sessionCount;
  final int successfulResponses;
  final int fallbackCount;

  const AiUsageStats({
    required this.childId,
    required this.dateKey,
    this.usedMinutes = 0,
    this.usedTurns = 0,
    this.sessionCount = 0,
    this.successfulResponses = 0,
    this.fallbackCount = 0,
  });

  AiUsageStats copyWith({
    int? usedMinutes,
    int? usedTurns,
    int? sessionCount,
    int? successfulResponses,
    int? fallbackCount,
  }) {
    return AiUsageStats(
      childId: childId,
      dateKey: dateKey,
      usedMinutes: usedMinutes ?? this.usedMinutes,
      usedTurns: usedTurns ?? this.usedTurns,
      sessionCount: sessionCount ?? this.sessionCount,
      successfulResponses: successfulResponses ?? this.successfulResponses,
      fallbackCount: fallbackCount ?? this.fallbackCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'childId': childId,
        'dateKey': dateKey,
        'usedMinutes': usedMinutes,
        'usedTurns': usedTurns,
        'sessionCount': sessionCount,
        'successfulResponses': successfulResponses,
        'fallbackCount': fallbackCount,
      };

  factory AiUsageStats.fromJson(Map<String, dynamic> json) => AiUsageStats(
        childId: json['childId'] as String,
        dateKey: json['dateKey'] as String,
        usedMinutes: json['usedMinutes'] as int? ?? 0,
        usedTurns: json['usedTurns'] as int? ?? 0,
        sessionCount: json['sessionCount'] as int? ?? 0,
        successfulResponses: json['successfulResponses'] as int? ?? 0,
        fallbackCount: json['fallbackCount'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [
        childId,
        dateKey,
        usedMinutes,
        usedTurns,
        sessionCount,
        successfulResponses,
        fallbackCount,
      ];
}
