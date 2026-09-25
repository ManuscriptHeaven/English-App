import 'package:equatable/equatable.dart';

enum ReviewDecision {
  approve,
  requestChanges,
  reject,
}

enum ReviewType {
  educational,
  islamic,
}

/// A formal review submission on a ContentDraft.
class ContentReview extends Equatable {
  final String id;
  final String draftId;
  final String reviewerId;
  final ReviewType reviewType;
  final ReviewDecision decision;
  final String notes;
  final DateTime reviewedAt;

  const ContentReview({
    required this.id,
    required this.draftId,
    required this.reviewerId,
    required this.reviewType,
    required this.decision,
    required this.notes,
    required this.reviewedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'draftId': draftId,
        'reviewerId': reviewerId,
        'reviewType': reviewType.name,
        'decision': decision.name,
        'notes': notes,
        'reviewedAt': reviewedAt.toIso8601String(),
      };

  factory ContentReview.fromJson(Map<String, dynamic> json) => ContentReview(
        id: json['id'] as String,
        draftId: json['draftId'] as String,
        reviewerId: json['reviewerId'] as String,
        reviewType: ReviewType.values.firstWhere(
          (e) => e.name == json['reviewType'],
          orElse: () => ReviewType.educational,
        ),
        decision: ReviewDecision.values.firstWhere(
          (e) => e.name == json['decision'],
          orElse: () => ReviewDecision.approve,
        ),
        notes: json['notes'] as String? ?? '',
        reviewedAt: DateTime.parse(json['reviewedAt'] as String),
      );

  @override
  List<Object?> get props => [
        id,
        draftId,
        reviewerId,
        reviewType,
        decision,
        notes,
        reviewedAt,
      ];
}
