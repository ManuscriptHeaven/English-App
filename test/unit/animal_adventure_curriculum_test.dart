import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';

void main() {
  group('Animal Adventure Curriculum Tests', () {
    late MockWorldRepository repo;

    setUp(() {
      repo = MockWorldRepository();
    });

    test('Animal Adventure contains 10 structured activity steps', () async {
      final world = await repo.getWorldById('world_animal');
      expect(world, isNotNull);
      expect(world!.chapters.isNotEmpty, isTrue);

      final unit = world.chapters.first.units.first;
      expect(unit.lessons.length, equals(10));

      final activityIds = unit.lessons.map((l) => l.id).toList();
      expect(activityIds, containsAll([
        'activity_animal_vocab',
        'activity_animal_hunt',
        'activity_listen_tap',
        'activity_word_match',
        'activity_grammar_this_is',
        'activity_grammar_is_are',
        'activity_value_moment',
        'activity_story_read',
        'activity_listen_speak',
        'activity_final_challenge',
      ]));
    });

    test('All 9 vocabulary words are covered in the curriculum', () async {
      final lesson1 = await repo.getLessonById('activity_animal_vocab');
      expect(lesson1, isNotNull);
      expect(lesson1!.targetVocabularyIds.length, equals(9));
      expect(lesson1.targetVocabularyIds, containsAll([
        'vocab_elephant',
        'vocab_lion',
        'vocab_cat',
        'vocab_bird',
        'vocab_water',
        'vocab_clean',
        'vocab_gentle',
        'vocab_big',
        'vocab_small',
      ]));
    });

    test('Islamic values & manners are integrated into activities', () async {
      final valueActivity = await repo.getLessonById('activity_value_moment');
      expect(valueActivity, isNotNull);
      expect(valueActivity!.connectedValueId, equals('value_kindness_animals'));
      expect(valueActivity.connectedMannerId, equals('manner_gentle_animals'));
    });
  });
}
