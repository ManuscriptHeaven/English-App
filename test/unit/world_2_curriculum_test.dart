import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/stories/data/mock_story_repository.dart';
import 'package:kids_english_adventure/features/values/data/mock_islamic_values_repository.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';

void main() {
  group('World 2: Home & Family Curriculum Tests', () {
    late MockWorldRepository worldRepo;
    late MockStoryRepository storyRepo;
    late MockIslamicValuesRepository valuesRepo;

    setUp(() {
      worldRepo = MockWorldRepository();
      storyRepo = MockStoryRepository();
      valuesRepo = MockIslamicValuesRepository();
    });

    test('World 2 is unlocked and contains 10 structured activity steps', () async {
      final world2 = await worldRepo.getWorldById('world_home');
      expect(world2, isNotNull);
      expect(world2!.isUnlocked, isTrue);

      final unit = world2.chapters.first.units.first;
      expect(unit.lessons.length, equals(10));

      final activityIds = unit.lessons.map((l) => l.id).toList();
      expect(activityIds, containsAll([
        'activity_home_vocab',
        'activity_home_hunt',
        'activity_family_vocab',
        'activity_listen_find_home',
        'activity_grammar_my_your',
        'activity_sentence_builder_home',
        'activity_cleanliness_sort',
        'activity_story_home',
        'activity_speaking_home',
        'activity_home_challenge',
      ]));
    });

    test('World 2 includes filial respect (Birr al-Walidayn) and dining Sunnah values', () async {
      final respect = await valuesRepo.getValueById('value_respect_parents');
      expect(respect, isNotNull);
      expect(respect!.sourceType, equals('quran_principle'));
      expect(respect.sourceReference, contains('Luqman'));
      expect(respect.reviewStatus, equals('verified_child_safe'));

      final gratitude = await valuesRepo.getValueById('value_gratitude');
      expect(gratitude, isNotNull);
      expect(gratitude!.arabicPhrase, contains('Bismillah'));
    });

    test('Story 2 "Helping at Home" contains 8 pages and 4 quiz questions', () async {
      final story = await storyRepo.getStoryById('story_helping_home');
      expect(story, isNotNull);
      expect(story!.pages.length, equals(8));
      expect(story.comprehensionQuestions.length, equals(4));

      final q1 = story.comprehensionQuestions[0];
      expect(q1.options[q1.correctOptionIndex], contains('Mother'));

      final q3 = story.comprehensionQuestions[2];
      expect(q3.options[q3.correctOptionIndex], contains('Bismillah'));
    });
  });
}
