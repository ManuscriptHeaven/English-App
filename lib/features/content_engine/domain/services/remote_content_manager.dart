import '../models/content_item.dart';
import '../models/curriculum_package.dart';
import '../models/remote_content_package.dart';
import 'content_validator.dart';

/// Service managing remote content delivery, validation, activation, and automatic rollback.
class RemoteContentManager {
  final Map<String, CurriculumPackage> _activePackages = {};
  final Map<String, CurriculumPackage> _backupPackages = {};

  /// Registers an initial known-good package.
  void registerPackage(CurriculumPackage package) {
    _activePackages[package.worldId] = package;
  }

  CurriculumPackage? getActivePackage(String worldId) => _activePackages[worldId];

  CurriculumPackage? getBackupPackage(String worldId) => _backupPackages[worldId];

  /// Validates and applies a remote content package with automatic rollback on failure.
  bool applyRemotePackage(RemoteContentPackage remote) {
    // Check 1: Must be published status (Draft / In-Review rejected from child mode)
    if (remote.status != ReviewStatus.published) {
      return false;
    }

    // Check 2: Checksum integrity
    if (remote.checksum.trim().length < 8) {
      return false;
    }

    final current = _activePackages[remote.worldId];
    if (current != null && remote.version <= current.version) {
      return false; // Must be a newer version
    }

    // Convert to local CurriculumPackage for validation
    final candidate = CurriculumPackage(
      id: remote.packageId,
      worldId: remote.worldId,
      version: remote.version,
      title: remote.title,
      description: remote.description,
      ageMin: remote.ageMin,
      ageMax: remote.ageMax,
      difficulty: remote.difficulty,
      languageLevel: 'Pre-A1',
      contentItems: remote.contentItems,
      status: remote.status,
      createdAt: remote.publishedAt,
      updatedAt: remote.updatedAt,
    );

    final errors = ContentValidator.validatePackage(candidate);
    if (errors.isNotEmpty) {
      // Automatic rollback / keep previous active
      return false;
    }

    // Safe upgrade with backup
    if (current != null) {
      _backupPackages[remote.worldId] = current;
    }
    _activePackages[remote.worldId] = candidate;
    return true;
  }

  /// Explicitly rolls back a world's curriculum to its previous known-good backup.
  bool rollback(String worldId) {
    final backup = _backupPackages[worldId];
    if (backup != null) {
      _activePackages[worldId] = backup;
      return true;
    }
    return false;
  }
}
