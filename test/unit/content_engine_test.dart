import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/content_engine/data/local_content_repository.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/activity_type.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/content_item.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/curriculum_package.dart';
import 'package:kids_english_adventure/features/content_engine/domain/services/activity_renderer_registry.dart';
import 'package:kids_english_adventure/features/content_engine/domain/services/content_validator.dart';

void main() {
  group('Content Engine Domain & Validation Tests', () {
    test('ContentItem serializes and deserializes cleanly', () {
      const item = ContentItem(
        id: 'food_apple_01',
        activityType: ActivityType.vocabularyDiscovery,
        title: 'Apple',
        description: 'Learn sweet red apple',
        skill: SkillType.vocabulary,
        learningObjective: 'Identify apple and pronunciation',
        contentData: {'word': 'Apple', 'emoji': '🍎'},
      );

      final json = item.toJson();
      final fromJson = ContentItem.fromJson(json);

      expect(fromJson.id, equals('food_apple_01'));
      expect(fromJson.activityType, equals(ActivityType.vocabularyDiscovery));
      expect(fromJson.contentData['word'], equals('Apple'));
    });

    test('CurriculumPackage holds versioned content and serializes properly', () {
      final now = DateTime(2026, 8, 22);
      final pkg = CurriculumPackage(
        id: 'pkg_world_food_v1',
        worldId: 'world_food',
        version: 1,
        title: 'Delicious Food World Curriculum',
        description: 'Food fundamentals and sharing',
        createdAt: now,
        updatedAt: now,
        contentItems: const [
          ContentItem(
            id: 'food_banana_02',
            activityType: ActivityType.vocabularyDiscovery,
            title: 'Banana',
            description: 'Learn yellow banana',
            skill: SkillType.vocabulary,
            learningObjective: 'Identify banana',
            contentData: {'word': 'Banana', 'emoji': '🍌'},
          ),
        ],
      );

      final json = pkg.toJson();
      final fromJson = CurriculumPackage.fromJson(json);

      expect(fromJson.id, equals('pkg_world_food_v1'));
      expect(fromJson.version, equals(1));
      expect(fromJson.contentItems.length, equals(1));
      expect(fromJson.contentItems.first.title, equals('Banana'));
    });

    test('ContentValidator detects missing required fields and invalid age ranges', () {
      const invalidItem = ContentItem(
        id: '',
        activityType: ActivityType.vocabularyDiscovery,
        title: '',
        description: 'Invalid',
        ageMin: 15,
        ageMax: 2,
        skill: SkillType.vocabulary,
        learningObjective: '',
        contentData: {},
      );

      final errors = ContentValidator.validateContentItem(invalidItem);
      expect(errors, isNotEmpty);
      expect(errors.any((e) => e.contains('ID cannot be empty')), isTrue);
      expect(errors.any((e) => e.contains('invalid age range')), isTrue);
      expect(errors.any((e) => e.contains('empty contentData')), isTrue);
    });

    test('ContentValidator validates Islamic source metadata completeness', () {
      const itemWithMissingSourceRef = ContentItem(
        id: 'food_manners_test',
        activityType: ActivityType.scenarioChoice,
        title: 'Dining Manners',
        description: 'Bismillah test',
        skill: SkillType.manners,
        learningObjective: 'Say Bismillah',
        contentData: {'test': true},
        sourceType: 'hadith_authentic',
        sourceReference: '', // Missing
      );

      final errors = ContentValidator.validateContentItem(itemWithMissingSourceRef);
      expect(errors.any((e) => e.contains('missing sourceReference')), isTrue);
    });

    test('ActivityRendererRegistry maps all 18 supported ActivityTypes', () {
      expect(ActivityRendererRegistry.supportedTypes.length, equals(18));
      for (final type in ActivityType.values) {
        expect(ActivityRendererRegistry.hasRenderer(type), isTrue);
        expect(ActivityRendererRegistry.getRendererName(type), isNotEmpty);
      }
    });

    test('LocalContentRepository loads seeded Food package and items', () async {
      final repo = LocalContentRepository();
      final pkg = await repo.getPackageForWorld('world_food');

      expect(pkg, isNotNull);
      expect(pkg!.worldId, equals('world_food'));
      expect(pkg.contentItems.length, greaterThanOrEqualTo(5));

      final appleItem = await repo.getContentItemById('food_apple_01');
      expect(appleItem, isNotNull);
      expect(appleItem!.title, equals('Apple'));
      expect(appleItem.valueIds, contains('value_gratitude'));
    });
  });
}
