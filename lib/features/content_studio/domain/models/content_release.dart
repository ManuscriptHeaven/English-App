import 'package:equatable/equatable.dart';

/// Represents a published production release of a content package.
class ContentRelease extends Equatable {
  final String id;
  final String packageId;
  final int version;
  final String checksum;
  final String title;
  final String releasedBy;
  final DateTime publishedAt;
  final int itemCount;

  const ContentRelease({
    required this.id,
    required this.packageId,
    required this.version,
    required this.checksum,
    required this.title,
    required this.releasedBy,
    required this.publishedAt,
    required this.itemCount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'packageId': packageId,
        'version': version,
        'checksum': checksum,
        'title': title,
        'releasedBy': releasedBy,
        'publishedAt': publishedAt.toIso8601String(),
        'itemCount': itemCount,
      };

  factory ContentRelease.fromJson(Map<String, dynamic> json) => ContentRelease(
        id: json['id'] as String,
        packageId: json['packageId'] as String,
        version: json['version'] as int? ?? 1,
        checksum: json['checksum'] as String,
        title: json['title'] as String,
        releasedBy: json['releasedBy'] as String,
        publishedAt: DateTime.parse(json['publishedAt'] as String),
        itemCount: json['itemCount'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [
        id,
        packageId,
        version,
        checksum,
        title,
        releasedBy,
        publishedAt,
        itemCount,
      ];
}
