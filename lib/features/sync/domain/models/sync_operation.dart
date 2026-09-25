import 'package:equatable/equatable.dart';

enum SyncOperationType {
  create,
  update,
  delete,
}

enum SyncOpStatus {
  pending,
  syncing,
  synced,
  failed,
}

/// An individual operation in the offline synchronization queue.
class SyncOperation extends Equatable {
  final String id;
  final String childId;
  final String entityType; // 'learning_signal', 'content_mastery', 'learning_session', 'reward_transaction', 'child_profile'
  final String entityId;
  final SyncOperationType operationType;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;
  final DateTime? lastAttemptAt;
  final SyncOpStatus syncStatus;

  const SyncOperation({
    required this.id,
    required this.childId,
    required this.entityType,
    required this.entityId,
    required this.operationType,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.lastAttemptAt,
    this.syncStatus = SyncOpStatus.pending,
  });

  SyncOperation copyWith({
    String? id,
    String? childId,
    String? entityType,
    String? entityId,
    SyncOperationType? operationType,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    int? retryCount,
    DateTime? lastAttemptAt,
    SyncOpStatus? syncStatus,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'childId': childId,
        'entityType': entityType,
        'entityId': entityId,
        'operationType': operationType.name,
        'payload': payload,
        'createdAt': createdAt.toIso8601String(),
        'retryCount': retryCount,
        'lastAttemptAt': lastAttemptAt?.toIso8601String(),
        'syncStatus': syncStatus.name,
      };

  factory SyncOperation.fromJson(Map<String, dynamic> json) => SyncOperation(
        id: json['id'] as String,
        childId: json['childId'] as String,
        entityType: json['entityType'] as String,
        entityId: json['entityId'] as String,
        operationType: SyncOperationType.values.firstWhere(
          (e) => e.name == json['operationType'],
          orElse: () => SyncOperationType.create,
        ),
        payload: (json['payload'] as Map<String, dynamic>?) ?? {},
        createdAt: DateTime.parse(json['createdAt'] as String),
        retryCount: json['retryCount'] as int? ?? 0,
        lastAttemptAt: json['lastAttemptAt'] != null
            ? DateTime.parse(json['lastAttemptAt'] as String)
            : null,
        syncStatus: SyncOpStatus.values.firstWhere(
          (e) => e.name == json['syncStatus'],
          orElse: () => SyncOpStatus.pending,
        ),
      );

  @override
  List<Object?> get props => [
        id,
        childId,
        entityType,
        entityId,
        operationType,
        payload,
        createdAt,
        retryCount,
        lastAttemptAt,
        syncStatus,
      ];
}
