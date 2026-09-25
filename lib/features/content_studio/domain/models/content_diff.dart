import 'package:equatable/equatable.dart';

/// Structured comparison between two versions of a content package.
class ContentDiff extends Equatable {
  final String packageId;
  final int fromVersion;
  final int toVersion;
  final List<String> addedItemIds;
  final List<String> removedItemIds;
  final List<String> modifiedItemIds;
  final List<String> modifiedIslamicSources;
  final List<String> summaryChanges;

  const ContentDiff({
    required this.packageId,
    required this.fromVersion,
    required this.toVersion,
    this.addedItemIds = const [],
    this.removedItemIds = const [],
    this.modifiedItemIds = const [],
    this.modifiedIslamicSources = const [],
    this.summaryChanges = const [],
  });

  bool get hasChanges =>
      addedItemIds.isNotEmpty ||
      removedItemIds.isNotEmpty ||
      modifiedItemIds.isNotEmpty ||
      modifiedIslamicSources.isNotEmpty ||
      summaryChanges.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'packageId': packageId,
        'fromVersion': fromVersion,
        'toVersion': toVersion,
        'addedItemIds': addedItemIds,
        'removedItemIds': removedItemIds,
        'modifiedItemIds': modifiedItemIds,
        'modifiedIslamicSources': modifiedIslamicSources,
        'summaryChanges': summaryChanges,
      };

  factory ContentDiff.fromJson(Map<String, dynamic> json) => ContentDiff(
        packageId: json['packageId'] as String,
        fromVersion: json['fromVersion'] as int? ?? 1,
        toVersion: json['toVersion'] as int? ?? 2,
        addedItemIds: List<String>.from(json['addedItemIds'] as List? ?? []),
        removedItemIds: List<String>.from(json['removedItemIds'] as List? ?? []),
        modifiedItemIds: List<String>.from(json['modifiedItemIds'] as List? ?? []),
        modifiedIslamicSources:
            List<String>.from(json['modifiedIslamicSources'] as List? ?? []),
        summaryChanges: List<String>.from(json['summaryChanges'] as List? ?? []),
      );

  @override
  List<Object?> get props => [
        packageId,
        fromVersion,
        toVersion,
        addedItemIds,
        removedItemIds,
        modifiedItemIds,
        modifiedIslamicSources,
        summaryChanges,
      ];
}
