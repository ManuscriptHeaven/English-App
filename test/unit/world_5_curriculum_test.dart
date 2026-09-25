import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/stories/data/mock_story_repository.dart';
import 'package:kids_english_adventure/features/values/data/mock_islamic_values_repository.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';

void main() {
  group('World 5: Nature & Weather Curriculum & Story Tests', () {
    late MockWorldRepository worldRepo;
    late MockIslamicValuesRepository valuesRepo;
    late MockStoryRepository storyRepo;

    setUp(() {
      worldRepo = MockWorldRepository();
      valuesRepo = MockIslamicValuesRepository();
      storyRepo = MockStoryRepository();
    });

    test('World 5 (Nature & Weather) is unlocked and contains 12 sequential activities', () async {
      final world = await worldRepo.getWorldById('world_nature');
      expect(world, isNotNull);
      expect(world!.isUnlocked, isTrue);
      expect(world.theme, equals('nature'));

      final chapter = world.chapters.first;
      expect(chapter.units.first.lessons.length, equals(12));

      final lessonIds = chapter.units.first.lessons.map((l) => l.id).toList();
      expect(lessonIds, contains('activity_nature_vocab'));
      expect(lessonIds, contains('activity_nature_hunt'));
      expect(lessonIds, contains('activity_weather_listen'));
      expect(lessonIds, contains('activity_nature_match'));
      expect(lessonIds, contains('activity_sunny_rainy'));
      expect(lessonIds, contains('activity_there_is_are'));
      expect(lessonIds, contains('activity_weather_conversation'));
      expect(lessonIds, contains('activity_care_for_nature'));
      expect(lessonIds, contains('activity_story_nature'));
      expect(lessonIds, contains('activity_story_nature_quiz'));
      expect(lessonIds, contains('activity_speaking_nature'));
      expect(lessonIds, contains('activity_nature_challenge'));
    });

    test('World 5 Islamic Values contain authentic references (Tafakkur & Taharah)', () async {
      final gratitudeValue = await valuesRepo.getValueById('value_creation_gratitude');
      expect(gratitudeValue, isNotNull);
      expect(gratitudeValue!.arabicPhrase, contains('Tafakkur'));
      expect(gratitudeValue.sourceReference, equals('Surah Ibrahim 14:7'));
      expect(gratitudeValue.reviewStatus, equals('verified_child_safe'));

      final careValue = await valuesRepo.getValueById('value_care_for_nature');
      expect(careValue, isNotNull);
      expect(careValue!.arabicPhrase, contains('Taharah'));
      expect(careValue.sourceReference, equals('Sahih Muslim 223'));
    });

    test('Story 5 "The Rainy Day Adventure" contains 8 pages and 5 quiz questions', () async {
      final story = await storyRepo.getStoryById('story_rainy_adventure');
      expect(story, isNotNull);
      expect(story!.title, equals('The Rainy Day Adventure'));
      expect(story.pages.length, equals(8));
      expect(story.comprehensionQuestions.length, equals(5));
      expect(story.connectedIslamicValueIds, contains('value_creation_gratitude'));
      expect(story.connectedIslamicValueIds, contains('value_care_for_nature'));
    });
  });
}
