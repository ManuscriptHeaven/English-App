import 'package:equatable/equatable.dart';

/// Parent profile with security PIN, screen-time settings, and child profile IDs.
class ParentProfile extends Equatable {
  final String id;
  final String email;
  final String name;
  final String pinHash;
  final int dailyScreenTimeMinutes;
  final bool bedtimeLockEnabled;
  final String bedtimeStart; // e.g. "20:00"
  final String bedtimeEnd;   // e.g. "07:00"
  final List<String> childIds;
  final DateTime createdAt;

  const ParentProfile({
    required this.id,
    required this.email,
    required this.name,
    this.pinHash = '1234',
    this.dailyScreenTimeMinutes = 30,
    this.bedtimeLockEnabled = false,
    this.bedtimeStart = '20:00',
    this.bedtimeEnd = '07:00',
    this.childIds = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'pinHash': pinHash,
        'dailyScreenTimeMinutes': dailyScreenTimeMinutes,
        'bedtimeLockEnabled': bedtimeLockEnabled,
        'bedtimeStart': bedtimeStart,
        'bedtimeEnd': bedtimeEnd,
        'childIds': childIds,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ParentProfile.fromJson(Map<String, dynamic> json) => ParentProfile(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        pinHash: json['pinHash'] as String? ?? '1234',
        dailyScreenTimeMinutes: json['dailyScreenTimeMinutes'] as int? ?? 30,
        bedtimeLockEnabled: json['bedtimeLockEnabled'] as bool? ?? false,
        bedtimeStart: json['bedtimeStart'] as String? ?? '20:00',
        bedtimeEnd: json['bedtimeEnd'] as String? ?? '07:00',
        childIds: (json['childIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        pinHash,
        dailyScreenTimeMinutes,
        bedtimeLockEnabled,
        bedtimeStart,
        bedtimeEnd,
        childIds,
        createdAt,
      ];
}
