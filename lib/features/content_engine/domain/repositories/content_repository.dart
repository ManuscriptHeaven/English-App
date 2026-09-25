import '../models/content_item.dart';
import '../models/curriculum_package.dart';

/// Abstract repository interface for loading and querying versioned curriculum packages.
abstract class IContentRepository {
  Future<List<CurriculumPackage>> getAllPackages();
  Future<CurriculumPackage?> getPackageForWorld(String worldId);
  Future<ContentItem?> getContentItemById(String contentId);
  Future<List<ContentItem>> getContentItemsForWorld(String worldId);
  Future<void> savePackage(CurriculumPackage package);
}
