import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';

void main() {
  group('MockWorldRepository & Animal Adventure Tests', () {
    late MockWorldRepository repo;

    setUp(() {
      repo = MockWorldRepository();
    });

    test('Loads all 5 planned worlds', () async {
      final worlds = await repo.getAllWorlds();
      expect(worlds.length, equals(5));
      expect(worlds.map((w) => w.id), containsAll(['world_animal', 'world_home', 'world_school', 'world_food', 'world_nature']));
    });

    test('World 1 (Animal Adventure) is unlocked and contains chapters, units, and lessons', () async {
      final world1 = await repo.getWorldById('world_animal');
      expect(world1, isNotNull);
      expect(world1!.isUnlocked, isTrue);
      expect(world1.chapters.isNotEmpty, isTrue);

      final chapter1 = world1.chapters.first;
      expect(chapter1.units.isNotEmpty, isTrue);

      final unit1 = chapter1.units.first;
      expect(unit1.id, equals('unit_animal_adventure'));
      expect(unit1.featuredStoryId, equals('story_animal_park'));
      expect(unit1.lessons.isNotEmpty, isTrue);

      final lesson1 = unit1.lessons.first;
      expect(lesson1.id, equals('activity_animal_vocab'));
      expect(lesson1.targetVocabularyIds, containsAll(['vocab_elephant', 'vocab_cat', 'vocab_bird', 'vocab_lion']));
      expect(lesson1.connectedValueId, equals('value_kindness_animals'));
      expect(lesson1.targetVocabularyIds.isNotEmpty, isTrue);
      expect(unit1.lessons.length, equals(10));
    });

    test('Queries individual lessons by ID', () async {
      final lesson = await repo.getLessonById('activity_animal_vocab');
      expect(lesson, isNotNull);
      expect(lesson!.title, equals('Animal Words Discovery'));
    });
  });
}
