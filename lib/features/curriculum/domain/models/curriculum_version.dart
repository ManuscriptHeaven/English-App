import 'package:equatable/equatable.dart';

/// Explicit versioning descriptor guaranteeing safe migration and backward compatibility
/// across content updates without invalidating child mastery evidence.
class CurriculumVersion extends Equatable {
  final int schemaVersion;
  final int contentVersion;
  final DateTime releaseDate;
  final int migrationVersion;
  final String minimumAppVersion;
  final String changelogSummary;

  const CurriculumVersion({
    this.schemaVersion = 1,
    this.contentVersion = 1,
    required this.releaseDate,
    this.migrationVersion = 1,
    this.minimumAppVersion = '1.0.0',
    this.changelogSummary = 'Initial Phase 14 8-stage progressive speaking curriculum schema.',
  });

  /// Production Content Version 2 descriptor: 5 tracks, 150 lessons, 750+ interactions.
  static final CurriculumVersion v2 = CurriculumVersion(
    schemaVersion: 1,
    contentVersion: 2,
    releaseDate: DateTime(2026, 9, 13),
    migrationVersion: 2,
    minimumAppVersion: '1.1.0',
    changelogSummary: 'CURRICULUM_CONTENT_V2: Full production expansion across 5 age tracks with 150 complete lessons and 750+ interactions.',
  );

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'contentVersion': contentVersion,
        'releaseDate': releaseDate.toIso8601String(),
        'migrationVersion': migrationVersion,
        'minimumAppVersion': minimumAppVersion,
        'changelogSummary': changelogSummary,
      };

  factory CurriculumVersion.fromJson(Map<String, dynamic> json) => CurriculumVersion(
        schemaVersion: json['schemaVersion'] as int? ?? 1,
        contentVersion: json['contentVersion'] as int? ?? 1,
        releaseDate: DateTime.parse(json['releaseDate'] as String),
        migrationVersion: json['migrationVersion'] as int? ?? 1,
        minimumAppVersion: json['minimumAppVersion'] as String? ?? '1.0.0',
        changelogSummary: json['changelogSummary'] as String? ?? '',
      );

  @override
  List<Object?> get props => [
        schemaVersion,
        contentVersion,
        releaseDate,
        migrationVersion,
        minimumAppVersion,
        changelogSummary,
      ];
}
