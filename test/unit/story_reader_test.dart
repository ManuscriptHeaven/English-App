import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/stories/data/mock_story_repository.dart';

void main() {
  group('Story Reader & Comprehension Tests', () {
    late MockStoryRepository repo;

    setUp(() {
      repo = MockStoryRepository();
    });

    test('Story has 8 illustrated pages with character dialogue', () async {
      final story = await repo.getStoryById('story_animal_park');
      expect(story, isNotNull);
      expect(story!.pages.length, equals(8));

      // Page 1 introduces the park
      expect(story.pages[0].pageNumber, equals(1));
      expect(story.pages[0].text, contains('animal park'));

      // Page 3 shows thirsty cat
      expect(story.pages[2].text, contains('thirsty'));

      // Page 8 shows Alhamdulillah
      expect(story.pages[7].text, contains('Alhamdulillah'));
    });

    test('Story has 4 comprehension questions reinforcing English and values', () async {
      final story = await repo.getStoryById('story_animal_park');
      expect(story!.comprehensionQuestions.length, equals(4));

      final q1 = story.comprehensionQuestions[0];
      expect(q1.options[q1.correctOptionIndex], contains('Clean water'));

      final q2 = story.comprehensionQuestions[1];
      expect(q2.options[q2.correctOptionIndex], contains('soft, gentle hands'));

      final q3 = story.comprehensionQuestions[2];
      expect(q3.options[q3.correctOptionIndex], contains('elephant'));

      final q4 = story.comprehensionQuestions[3];
      expect(q4.options[q4.correctOptionIndex], contains('Alhamdulillah'));
    });
  });
}
