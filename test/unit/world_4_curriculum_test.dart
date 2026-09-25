import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/stories/data/mock_story_repository.dart';
import 'package:kids_english_adventure/features/values/data/mock_islamic_values_repository.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';

void main() {
  group('World 4: Delicious Food Curriculum & Values Tests', () {
    late MockWorldRepository worldRepo;
    late MockIslamicValuesRepository valuesRepo;
    late MockStoryRepository storyRepo;

    setUp(() {
      worldRepo = MockWorldRepository();
      valuesRepo = MockIslamicValuesRepository();
      storyRepo = MockStoryRepository();
    });

    test('World 4 (Delicious Food) is unlocked and contains 12 sequential activities', () async {
      final world = await worldRepo.getWorldById('world_food');
      expect(world, isNotNull);
      expect(world!.isUnlocked, isTrue);
      expect(world.theme, equals('food'));

      final chapter = world.chapters.first;
      expect(chapter.units.first.lessons.length, equals(12));

      final lessonIds = chapter.units.first.lessons.map((l) => l.id).toList();
      expect(lessonIds, contains('activity_food_vocab'));
      expect(lessonIds, contains('activity_food_hunt'));
      expect(lessonIds, contains('activity_listen_find_food'));
      expect(lessonIds, contains('activity_food_match'));
      expect(lessonIds, contains('activity_grammar_i_have_food'));
      expect(lessonIds, contains('activity_food_count'));
      expect(lessonIds, contains('activity_hungry_thirsty'));
      expect(lessonIds, contains('activity_eating_manners'));
      expect(lessonIds, contains('activity_food_sharing'));
      expect(lessonIds, contains('activity_story_food'));
      expect(lessonIds, contains('activity_story_food_quiz'));
      expect(lessonIds, contains('activity_food_challenge'));
    });

    test('World 4 Islamic Values contain valid authentic references', () async {
      final sharingValue = await valuesRepo.getValueById('value_sharing');
      expect(sharingValue, isNotNull);
      expect(sharingValue!.arabicPhrase, contains('Ithaar'));
      expect(sharingValue.sourceReference, equals('Sahih Muslim 2059'));
      expect(sharingValue.reviewStatus, equals('verified_child_safe'));

      final avoidWaste = await valuesRepo.getValueById('value_avoid_waste');
      expect(avoidWaste, isNotNull);
      expect(avoidWaste!.sourceReference, equals('Surah Al-A\'raf 7:31'));
      expect(avoidWaste.reviewStatus, equals('verified_child_safe'));
    });

    test('Story 4 "The Picnic of Sharing" contains 8 pages and 5 quiz questions', () async {
      final story = await storyRepo.getStoryById('story_picnic_sharing');
      expect(story, isNotNull);
      expect(story!.title, equals('The Picnic of Sharing'));
      expect(story.pages.length, equals(8));
      expect(story.comprehensionQuestions.length, equals(5));
      expect(story.connectedIslamicValueIds, contains('value_sharing'));
      expect(story.connectedIslamicValueIds, contains('value_avoid_waste'));
    });
  });
}
