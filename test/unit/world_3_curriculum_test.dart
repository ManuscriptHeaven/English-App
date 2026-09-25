import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/stories/data/mock_story_repository.dart';
import 'package:kids_english_adventure/features/values/data/mock_islamic_values_repository.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';

void main() {
  group('World 3: School & Classroom Curriculum & Values Tests', () {
    late MockWorldRepository worldRepo;
    late MockIslamicValuesRepository valuesRepo;
    late MockStoryRepository storyRepo;

    setUp(() {
      worldRepo = MockWorldRepository();
      valuesRepo = MockIslamicValuesRepository();
      storyRepo = MockStoryRepository();
    });

    test('World 3 (School & Classroom) is unlocked and contains 12 sequential activities', () async {
      final world = await worldRepo.getWorldById('world_school');
      expect(world, isNotNull);
      expect(world!.isUnlocked, isTrue);
      expect(world.theme, equals('school'));

      final chapter = world.chapters.first;
      expect(chapter.units.first.lessons.length, equals(12));

      final lessonIds = chapter.units.first.lessons.map((l) => l.id).toList();
      expect(lessonIds, contains('activity_school_vocab'));
      expect(lessonIds, contains('activity_classroom_hunt'));
      expect(lessonIds, contains('activity_teacher_friend_vocab'));
      expect(lessonIds, contains('activity_listen_and_do_school'));
      expect(lessonIds, contains('activity_school_actions'));
      expect(lessonIds, contains('activity_polite_requests'));
      expect(lessonIds, contains('activity_grammar_plurals'));
      expect(lessonIds, contains('activity_honesty_challenge'));
      expect(lessonIds, contains('activity_story_school'));
      expect(lessonIds, contains('activity_story_quiz_school'));
      expect(lessonIds, contains('activity_speaking_school'));
      expect(lessonIds, contains('activity_school_challenge'));
    });

    test('World 3 Islamic Values contain valid references and verified status', () async {
      final honestyValue = await valuesRepo.getValueById('value_honesty');
      expect(honestyValue, isNotNull);
      expect(honestyValue!.arabicPhrase, contains('Sidq'));
      expect(honestyValue.sourceReference, equals('Sahih al-Bukhari 6094'));
      expect(honestyValue.reviewStatus, equals('verified_child_safe'));

      final teacherRespect = await valuesRepo.getValueById('value_respect_teachers');
      expect(teacherRespect, isNotNull);
      expect(teacherRespect!.sourceReference, equals('Jami` at-Tirmidhi 1985'));
      expect(teacherRespect.reviewStatus, equals('verified_child_safe'));
    });

    test('Story 3 "The Honest Pencil" contains 8 illustrated pages and comprehension questions', () async {
      final story = await storyRepo.getStoryById('story_honest_pencil');
      expect(story, isNotNull);
      expect(story!.title, equals('The Honest Pencil'));
      expect(story.pages.length, equals(8));
      expect(story.comprehensionQuestions.length, greaterThanOrEqualTo(4));
      expect(story.connectedIslamicValueIds, contains('value_honesty'));
    });
  });
}
