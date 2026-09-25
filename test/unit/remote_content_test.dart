import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/activity_type.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/content_item.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/curriculum_package.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/remote_content_package.dart';
import 'package:kids_english_adventure/features/content_engine/domain/services/remote_content_manager.dart';

void main() {
  group('Remote Content Platform & Rollback Tests', () {
    late RemoteContentManager manager;
    final now = DateTime(2026, 8, 22);

    final initialFoodV1 = CurriculumPackage(
      id: 'pkg_world_food_v1',
      worldId: 'world_food',
      version: 1,
      title: 'Delicious Food V1',
      description: 'Initial Food curriculum',
      contentItems: const [
        ContentItem(
          id: 'food_apple_01',
          activityType: ActivityType.vocabularyDiscovery,
          title: 'Apple',
          description: 'Learn sweet red apple',
          skill: SkillType.vocabulary,
          learningObjective: 'Identify apple',
          contentData: {'word': 'Apple'},
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );

    setUp(() {
      manager = RemoteContentManager();
      manager.registerPackage(initialFoodV1);
    });

    test('Validates and upgrades to valid RemoteContentPackage V2', () {
      final validRemoteV2 = RemoteContentPackage(
        packageId: 'pkg_world_food_v2',
        worldId: 'world_food',
        version: 2,
        checksum: 'sha256_abcdef123456',
        title: 'Delicious Food V2 Expanded',
        description: 'Expanded Food curriculum with snacks',
        status: ReviewStatus.published,
        contentItems: const [
          ContentItem(
            id: 'food_apple_01',
            activityType: ActivityType.vocabularyDiscovery,
            title: 'Apple',
            description: 'Learn sweet red apple',
            skill: SkillType.vocabulary,
            learningObjective: 'Identify apple',
            contentData: {'word': 'Apple'},
          ),
          ContentItem(
            id: 'food_orange_03',
            activityType: ActivityType.vocabularyDiscovery,
            title: 'Orange',
            description: 'Learn juicy orange',
            skill: SkillType.vocabulary,
            learningObjective: 'Identify orange',
            contentData: {'word': 'Orange'},
          ),
        ],
        publishedAt: now,
        updatedAt: now,
      );

      final success = manager.applyRemotePackage(validRemoteV2);
      expect(success, isTrue);

      final active = manager.getActivePackage('world_food');
      expect(active, isNotNull);
      expect(active!.version, equals(2));
      expect(active.contentItems.length, equals(2));

      // Backup preserved
      final backup = manager.getBackupPackage('world_food');
      expect(backup, isNotNull);
      expect(backup!.version, equals(1));
    });

    test('Rejects invalid remote package and maintains current version', () {
      final invalidRemote = RemoteContentPackage(
        packageId: 'pkg_world_food_v2_broken',
        worldId: 'world_food',
        version: 2,
        checksum: 'invalid', // Too short checksum
        title: 'Broken Food Package',
        description: 'Missing fields',
        status: ReviewStatus.published,
        contentItems: const [],
        publishedAt: now,
        updatedAt: now,
      );

      final success = manager.applyRemotePackage(invalidRemote);
      expect(success, isFalse);

      final active = manager.getActivePackage('world_food');
      expect(active!.version, equals(1)); // Kept version 1
    });

    test('Strictly rejects Draft and Unreviewed content from child mode', () {
      final draftRemote = RemoteContentPackage(
        packageId: 'pkg_world_food_v3_draft',
        worldId: 'world_food',
        version: 3,
        checksum: 'sha256_validchecksum123',
        title: 'Draft Food Package',
        description: 'Unreviewed draft',
        status: ReviewStatus.draft, // Draft status must not reach child runtime
        contentItems: const [],
        publishedAt: now,
        updatedAt: now,
      );

      final success = manager.applyRemotePackage(draftRemote);
      expect(success, isFalse);
    });

    test('Rolls back to previous valid version on demand', () {
      // First upgrade to V2
      final validRemoteV2 = RemoteContentPackage(
        packageId: 'pkg_world_food_v2',
        worldId: 'world_food',
        version: 2,
        checksum: 'sha256_abcdef123456',
        title: 'Delicious Food V2',
        description: 'Updated food',
        status: ReviewStatus.published,
        contentItems: const [
          ContentItem(
            id: 'food_apple_01',
            activityType: ActivityType.vocabularyDiscovery,
            title: 'Apple',
            description: 'Learn sweet red apple',
            skill: SkillType.vocabulary,
            learningObjective: 'Identify apple',
            contentData: {'word': 'Apple'},
          ),
        ],
        publishedAt: now,
        updatedAt: now,
      );

      manager.applyRemotePackage(validRemoteV2);
      expect(manager.getActivePackage('world_food')!.version, equals(2));

      // Trigger rollback
      final rollbackSuccess = manager.rollback('world_food');
      expect(rollbackSuccess, isTrue);
      expect(manager.getActivePackage('world_food')!.version, equals(1));
    });
  });
}
