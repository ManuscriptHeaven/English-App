import 'package:kids_english_adventure/features/content_engine/domain/models/curriculum_package.dart';
import '../models/content_diff.dart';
import '../models/content_draft.dart';

/// Engine to compute structured differences between curriculum package versions.
class ContentDiffEngine {
  static ContentDiff calculateDiff({
    required CurriculumPackage previousPackage,
    required ContentDraft draft,
  }) {
    final prevIds = previousPackage.contentItems.map((e) => e.id).toSet();
    final draftIds = draft.contentItems.map((e) => e.id).toSet();

    final addedIds = draftIds.difference(prevIds).toList();
    final removedIds = prevIds.difference(draftIds).toList();
    final commonIds = prevIds.intersection(draftIds);

    final modifiedIds = <String>[];
    final modifiedIslamicSources = <String>[];
    final summary = <String>[];

    final prevMap = {for (final e in previousPackage.contentItems) e.id: e};
    final draftMap = {for (final e in draft.contentItems) e.id: e};

    for (final id in commonIds) {
      final prev = prevMap[id]!;
      final next = draftMap[id]!;

      if (prev != next) {
        modifiedIds.add(id);

        if (prev.sourceReference != next.sourceReference ||
            prev.sourceType != next.sourceType) {
          modifiedIslamicSources.add(id);
          summary.add('Islamic source updated for item: $id');
        } else if (prev.title != next.title) {
          summary.add('Title updated for item $id: "${prev.title}" -> "${next.title}"');
        } else {
          summary.add('Content payload modified for item: $id');
        }
      }
    }

    if (addedIds.isNotEmpty) {
      summary.add('Added ${addedIds.length} new content items: ${addedIds.join(", ")}');
    }
    if (removedIds.isNotEmpty) {
      summary.add('Removed ${removedIds.length} items: ${removedIds.join(", ")}');
    }

    return ContentDiff(
      packageId: draft.contentPackageId,
      fromVersion: previousPackage.version,
      toVersion: draft.version,
      addedItemIds: addedIds,
      removedItemIds: removedIds,
      modifiedItemIds: modifiedIds,
      modifiedIslamicSources: modifiedIslamicSources,
      summaryChanges: summary,
    );
  }
}
