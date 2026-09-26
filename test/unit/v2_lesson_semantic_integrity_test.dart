import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/v2/curriculum_content_v2.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/v2/curriculum_v2_lesson_specs.dart';

void main() {
  group('P0 #2: V2 Lesson Semantic Integrity & Production Content Coverage', () {
    test('1. Central CurriculumV2LessonSpecs registry contains all 150 lessons with 0 fallbacks', () {
      final allLessons = CurriculumContentV2.getAllLessons();
      expect(allLessons.length, equals(150));

      final allLessonIds = allLessons.map((l) => l.id).toSet();
      final specIds = CurriculumV2LessonSpecs.specs.keys.toSet();

      final missingInSpecs = allLessonIds.difference(specIds);
      final extraInSpecs = specIds.difference(allLessonIds);
      expect(missingInSpecs, isEmpty, reason: 'All curriculum lessons must have specs');
      expect(extraInSpecs, isEmpty, reason: 'No unused specs');
      expect(CurriculumV2LessonSpecs.count, equals(150));

      for (final lesson in allLessons) {
        expect(
          CurriculumV2LessonSpecs.hasSpec(lesson.id),
          isTrue,
          reason: 'Lesson "${lesson.id}" must have an explicit CurriculumLessonSpec.',
        );
        final spec = CurriculumV2LessonSpecs.getSpec(lesson.id)!;
        expect(spec.lessonId, equals(lesson.id));
        expect(spec.primaryConceptId, isNotEmpty);
        expect(spec.targetObjectId, isNotEmpty);
      }
    });

    test('2. Attempting to build activities for an unknown lesson fails fast with StateError', () {
      expect(
        () => CurriculumV2LessonSpecs.buildActivities('unknown_nonexistent_lesson', AgeExperienceProfile.forAge(5)),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('Generic fallback is strictly disallowed in V2 production'),
        )),
      );
    });

    test('3. Semantic correctness of user-flagged Track 1 lessons (No generic object collisions)', () {
      final profile = AgeExperienceProfile.forAge(3);

      // t1_l04: Nose -> must bind to obj_body_nose, not eyes
      final l04Acts = CurriculumV2LessonSpecs.buildActivities('t1_l04_touch_your_nose', profile);
      expect(l04Acts[0].targetObjectId, equals('obj_body_nose'));
      expect(l04Acts[0].conceptId, equals('concept_nose'));
      expect(l04Acts[0].targetObjectId, isNot(equals('obj_body_eyes')));

      // t1_l06: Hands -> must bind to obj_body_hands, not eyes
      final l06Acts = CurriculumV2LessonSpecs.buildActivities('t1_l06_clap_your_hands', profile);
      expect(l06Acts[0].targetObjectId, equals('obj_body_hands'));
      expect(l06Acts[0].conceptId, equals('concept_hands'));
      expect(l06Acts[0].targetObjectId, isNot(equals('obj_body_eyes')));

      // t1_l08: Blue Block -> must bind to obj_color_blue_block, not red ball
      final l08Acts = CurriculumV2LessonSpecs.buildActivities('t1_l08_blue_sky_block', profile);
      expect(l08Acts[0].targetObjectId, equals('obj_color_blue_block'));
      expect(l08Acts[0].conceptId, equals('concept_blue'));
      expect(l08Acts[0].targetObjectId, isNot(equals('obj_color_red_ball')));

      // t1_l09: Yellow -> must bind to obj_color_yellow_bubble, not red ball
      final l09Acts = CurriculumV2LessonSpecs.buildActivities('t1_l09_yellow_sun_bubble', profile);
      expect(l09Acts[0].targetObjectId, equals('obj_color_yellow_bubble'));
      expect(l09Acts[0].conceptId, equals('concept_yellow'));
      expect(l09Acts[0].targetObjectId, isNot(equals('obj_color_red_ball')));

      // t1_l11: Dog -> must bind to obj_animal_dog, not cat
      final l11Acts = CurriculumV2LessonSpecs.buildActivities('t1_l11_happy_dog', profile);
      expect(l11Acts[0].targetObjectId, equals('obj_animal_dog'));
      expect(l11Acts[0].conceptId, equals('concept_dog'));
      expect(l11Acts[0].targetObjectId, isNot(equals('obj_animal_cat')));

      // t1_l12: Rabbit -> must bind to obj_animal_rabbit and obj_animal_carrot
      final l12Acts = CurriculumV2LessonSpecs.buildActivities('t1_l12_feed_the_rabbit', profile);
      expect(l12Acts[0].targetObjectId, equals('obj_animal_rabbit'));
      expect(l12Acts[1].draggableObject!.objectId, equals('obj_animal_food_carrot'));
      expect(l12Acts[1].dropTarget!.objectId, equals('obj_animal_rabbit'));

      // t1_l14: Water -> must bind to obj_food_water, not apple
      final l14Acts = CurriculumV2LessonSpecs.buildActivities('t1_l14_cool_clean_water', profile);
      expect(l14Acts[0].targetObjectId, equals('obj_food_water'));
      expect(l14Acts[0].conceptId, equals('concept_water'));
      expect(l14Acts[0].targetObjectId, isNot(equals('obj_food_apple')));

      // t1_l15: Banana -> must bind to obj_food_banana, not apple
      final l15Acts = CurriculumV2LessonSpecs.buildActivities('t1_l15_yellow_banana', profile);
      expect(l15Acts[0].targetObjectId, equals('obj_food_banana'));
      expect(l15Acts[0].conceptId, equals('concept_banana'));
      expect(l15Acts[0].targetObjectId, isNot(equals('obj_food_apple')));
    });

    test('4. Handcrafted specifications generate age-appropriate step counts (4-9 steps) with zero fallback', () {
      for (int age = 3; age <= 12; age += 2) {
        final profile = AgeExperienceProfile.forAge(age);
        final track = CurriculumContentV2.getTrackForAge(age);
        final lessons = CurriculumContentV2.getLessonsForTrack(track);

        for (final lesson in lessons) {
          final acts = CurriculumContentV2.getActivitiesForLesson(lesson.id);
          final int minSteps = (age <= 4) ? 4 : (age <= 6 ? 5 : (age <= 8 ? 5 : 6));
          final int maxSteps = (age <= 4) ? 6 : (age <= 6 ? 7 : (age <= 8 ? 8 : 9));

          expect(
            acts.length,
            inInclusiveRange(minSteps, maxSteps),
            reason: 'Lesson ${lesson.id} (Age $age) must generate between $minSteps and $maxSteps steps.',
          );
          expect(acts[0].targetObjectId, isNotEmpty);
          expect(acts[0].ageProfile.age, equals(profile.age));
        }
      }
    });

    test('5. Exhaustive semantic validation across ALL 150 lessons (Strict object existence & purged jargon)', () {
      final allLessons = CurriculumContentV2.getAllLessons();
      expect(allLessons.length, equals(150));

      for (final lesson in allLessons) {
        final spec = CurriculumV2LessonSpecs.getSpec(lesson.id)!;
        // 1. Strict validation must pass without throwing
        expect(() => spec.validate(), returnsNormally, reason: 'Spec for ${lesson.id} must be strictly valid');

        final scene = spec.sceneFactory();
        expect(scene.sceneId, equals(spec.sceneId));

        // 2. Step-by-step scene binding checks
        for (final step in spec.steps) {
          expect(
            scene.objects.any((o) => o.objectId == step.targetObjectId),
            isTrue,
            reason: 'Target object ${step.targetObjectId} must exist in ${spec.sceneId}',
          );
          if (step.draggableObjectId != null) {
            expect(
              scene.objects.any((o) => o.objectId == step.draggableObjectId),
              isTrue,
              reason: 'Draggable object ${step.draggableObjectId} must exist in ${spec.sceneId}',
            );
          }
          if (step.targetDestinationId != null && step.targetDestinationId!.isNotEmpty) {
            expect(
              scene.objects.any((o) => o.objectId == step.targetDestinationId),
              isTrue,
              reason: 'Destination object ${step.targetDestinationId} must exist in ${spec.sceneId}',
            );
          }
        }
      }

      // 3. Verify Track 5 purged university jargon
      final t5l04 = CurriculumV2LessonSpecs.getSpec('t5_l04_evaluating_scientific_evidence')!;
      expect(t5l04.speakingTarget.toLowerCase(), isNot(contains('correlation does not imply causation')));
      expect(t5l04.speakingTarget.toLowerCase(), contains('just because two things happen together'));

      final t5l06 = CurriculumV2LessonSpecs.getSpec('t5_l06_interdisciplinary_thinking')!;
      expect(t5l06.speakingTarget.toLowerCase(), isNot(contains('interdisciplinary')));
      expect(t5l06.speakingTarget.toLowerCase(), contains('help people and do good'));

      final t5l10 = CurriculumV2LessonSpecs.getSpec('t5_l10_ai_and_human_wisdom')!;
      expect(t5l10.speakingTarget.toLowerCase(), isNot(contains('moral oversight')));
      expect(t5l10.speakingTarget.toLowerCase(), contains('fairly and safely'));

      final t5l13 = CurriculumV2LessonSpecs.getSpec('t5_l13_protecting_privacy_online')!;
      expect(t5l13.dialoguePrompt.toLowerCase(), isNot(contains('digital footprint')));
      expect(t5l13.speakingTarget.toLowerCase(), contains('what we post online stays there'));

      final t5l16 = CurriculumV2LessonSpecs.getSpec('t5_l16_sleep_and_memory_consolidation')!;
      expect(t5l16.speakingTarget.toLowerCase(), isNot(contains('emotional resilience')));
      expect(t5l16.speakingTarget.toLowerCase(), contains('remember things and keeps us feeling happy'));
    });
  });
}
