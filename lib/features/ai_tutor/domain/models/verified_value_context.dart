import 'package:equatable/equatable.dart';

/// Pre-verified, review-approved Islamic value context passed to the AI Tutor.
/// The AI is strictly restricted to reinforcing approvedPhrases and cannot invent citations.
class VerifiedValueContext extends Equatable {
  final String valueId;
  final String title;
  final String childFriendlyExplanation;
  final List<String> approvedPhrases;
  final String sourceType;
  final String sourceReference;
  final String reviewStatus;

  const VerifiedValueContext({
    required this.valueId,
    required this.title,
    required this.childFriendlyExplanation,
    required this.approvedPhrases,
    required this.sourceType,
    required this.sourceReference,
    this.reviewStatus = 'verified_child_safe',
  });

  Map<String, dynamic> toJson() => {
        'valueId': valueId,
        'title': title,
        'childFriendlyExplanation': childFriendlyExplanation,
        'approvedPhrases': approvedPhrases,
        'sourceType': sourceType,
        'sourceReference': sourceReference,
        'reviewStatus': reviewStatus,
      };

  factory VerifiedValueContext.fromJson(Map<String, dynamic> json) => VerifiedValueContext(
        valueId: json['valueId'] as String,
        title: json['title'] as String,
        childFriendlyExplanation: json['childFriendlyExplanation'] as String,
        approvedPhrases: (json['approvedPhrases'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        sourceType: json['sourceType'] as String? ?? 'general_value',
        sourceReference: json['sourceReference'] as String? ?? '',
        reviewStatus: json['reviewStatus'] as String? ?? 'verified_child_safe',
      );

  @override
  List<Object?> get props => [
        valueId,
        title,
        childFriendlyExplanation,
        approvedPhrases,
        sourceType,
        sourceReference,
        reviewStatus,
      ];
}
