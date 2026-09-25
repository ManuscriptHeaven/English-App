import '../models/content_item.dart';
import '../models/curriculum_package.dart';

/// Validation engine ensuring content integrity, safety, and source verification.
class ContentValidator {
  /// Validates a single ContentItem.
  static List<String> validateContentItem(ContentItem item) {
    final List<String> errors = [];

    if (item.id.trim().isEmpty) {
      errors.add('ContentItem ID cannot be empty.');
    }

    if (item.title.trim().isEmpty) {
      errors.add('ContentItem "${item.id}" must have a title.');
    }

    if (item.ageMin < 3 || item.ageMax > 12 || item.ageMin > item.ageMax) {
      errors.add('ContentItem "${item.id}" has an invalid age range (${item.ageMin}-${item.ageMax}).');
    }

    if (item.contentData.isEmpty) {
      errors.add('ContentItem "${item.id}" has empty contentData payload.');
    }

    // Religious source verification
    if (item.sourceType != null && item.sourceType!.isNotEmpty) {
      if (item.sourceReference == null || item.sourceReference!.trim().isEmpty) {
        errors.add('ContentItem "${item.id}" has a sourceType (${item.sourceType}) but is missing sourceReference.');
      }
    }

    return errors;
  }

  /// Validates an entire CurriculumPackage.
  static List<String> validatePackage(CurriculumPackage package) {
    final List<String> errors = [];

    if (package.id.trim().isEmpty) {
      errors.add('CurriculumPackage ID cannot be empty.');
    }

    if (package.worldId.trim().isEmpty) {
      errors.add('CurriculumPackage "${package.id}" must reference a worldId.');
    }

    if (package.version < 1) {
      errors.add('CurriculumPackage "${package.id}" version must be >= 1.');
    }

    if (package.contentItems.isEmpty) {
      errors.add('CurriculumPackage "${package.id}" contains no content items.');
    }

    for (final item in package.contentItems) {
      final itemErrors = validateContentItem(item);
      errors.addAll(itemErrors);
    }

    return errors;
  }

  /// Returns true if the package passes all validation checks without errors.
  static bool isValidPackage(CurriculumPackage package) {
    return validatePackage(package).isEmpty;
  }
}
