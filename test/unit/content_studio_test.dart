import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/activity_type.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/content_item.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/curriculum_package.dart';
import 'package:kids_english_adventure/features/content_studio/domain/models/content_review.dart';
import 'package:kids_english_adventure/features/content_studio/domain/services/content_diff_engine.dart';
import 'package:kids_english_adventure/features/content_studio/domain/services/content_studio_service.dart';

void main() {
  group('Content Studio & Governance Tests', () {
    late ContentStudioService service;
    final now = DateTime(2026, 8, 22);

    setUp(() {
      service = ContentStudioService();
    });

    test('Creates draft and progresses through educational and Islamic review pipeline', () {
      final draft = service.createDraft(
        id: 'draft_nature_v1',
        contentPackageId: 'pkg_world_nature_v1',
        authorId: 'curriculum_lead_1',
        version: 1,
        title: 'Nature World Curriculum',
        description: 'Trees, flowers, and weather',
        items: const [
          ContentItem(
            id: 'nature_tree_01',
            activityType: ActivityType.vocabularyDiscovery,
            title: 'Tree',
            description: 'Learn tree in the park',
            skill: SkillType.vocabulary,
            learningObjective: 'Identify tree',
            contentData: {'word': 'Tree'},
            valueIds: ['value_creation_gratitude'],
            sourceType: 'quran_principle',
            sourceReference: 'Surah Ibrahim 14:7',
          ),
        ],
      );

      expect(draft.status, equals(ReviewStatus.draft));

      // 1. Submit for educational review
      final submitted = service.submitForEducationalReview('draft_nature_v1');
      expect(submitted, isTrue);
      expect(service.getDraft('draft_nature_v1')!.status, equals(ReviewStatus.educationalReview));

      // 2. Educational review passes -> transitions to Islamic Review because item has Islamic source
      service.addReview(
        draftId: 'draft_nature_v1',
        reviewerId: 'educator_1',
        reviewType: ReviewType.educational,
        decision: ReviewDecision.approve,
        notes: 'Pedagogical objectives met.',
      );
      expect(service.getDraft('draft_nature_v1')!.status, equals(ReviewStatus.islamicReview));

      // 3. Islamic review passes -> transitions to Approved
      service.addReview(
        draftId: 'draft_nature_v1',
        reviewerId: 'scholar_1',
        reviewType: ReviewType.islamic,
        decision: ReviewDecision.approve,
        notes: 'Authentic Quranic reference verified.',
      );
      expect(service.getDraft('draft_nature_v1')!.status, equals(ReviewStatus.approved));

      // 4. Publish draft -> creates ContentRelease
      final release = service.publishDraft('draft_nature_v1');
      expect(release, isNotNull);
      expect(release!.packageId, equals('pkg_world_nature_v1'));
      expect(release.version, equals(1));
      expect(service.getDraft('draft_nature_v1')!.status, equals(ReviewStatus.published));
    });

    test('ContentDiffEngine computes item differences between package versions', () {
      final prevPkg = CurriculumPackage(
        id: 'pkg_world_nature_v1',
        worldId: 'world_nature',
        version: 1,
        title: 'Nature V1',
        description: 'Initial',
        contentItems: const [
          ContentItem(
            id: 'nature_tree_01',
            activityType: ActivityType.vocabularyDiscovery,
            title: 'Tree',
            description: 'Tree item',
            skill: SkillType.vocabulary,
            learningObjective: 'Identify tree',
            contentData: {'word': 'Tree'},
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final nextDraft = service.createDraft(
        id: 'draft_nature_v2',
        contentPackageId: 'pkg_world_nature_v1',
        authorId: 'curriculum_lead_1',
        version: 2,
        title: 'Nature V2',
        description: 'Added Flower',
        items: const [
          ContentItem(
            id: 'nature_tree_01',
            activityType: ActivityType.vocabularyDiscovery,
            title: 'Tree',
            description: 'Tree item updated',
            skill: SkillType.vocabulary,
            learningObjective: 'Identify tree',
            contentData: {'word': 'Tree', 'sound': 'tree.mp3'},
          ),
          ContentItem(
            id: 'nature_flower_02',
            activityType: ActivityType.vocabularyDiscovery,
            title: 'Flower',
            description: 'Flower item',
            skill: SkillType.vocabulary,
            learningObjective: 'Identify flower',
            contentData: {'word': 'Flower'},
          ),
        ],
      );

      final diff = ContentDiffEngine.calculateDiff(
        previousPackage: prevPkg,
        draft: nextDraft,
      );

      expect(diff.hasChanges, isTrue);
      expect(diff.addedItemIds, contains('nature_flower_02'));
      expect(diff.modifiedItemIds, contains('nature_tree_01'));
      expect(diff.fromVersion, equals(1));
      expect(diff.toVersion, equals(2));
    });
  });
}
