import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_integrity_validator.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene_object.dart';
import 'package:kids_english_adventure/core/experience/interactive_session_composer.dart';

void main() {
  group('InteractiveActivityIntegrityValidator Unit Tests', () {
    test('1. Production sessions for Ages 3, 5, 7, and 9 pass 100% integrity validation', () {
      final ages = [3, 5, 7, 9];
      for (final age in ages) {
        final profile = AgeExperienceProfile.forAge(age);
        final session = InteractiveSessionComposer.composeSession(
          ageProfile: profile,
          lessonId: 'activity_picnic_vocab',
          targetConceptWords: ['apple', 'water'],
        );

        // Must not throw ActivityIntegrityException
        expect(() => InteractiveActivityIntegrityValidator.validateSession(session), returnsNormally);
        expect(session.activities.isNotEmpty, isTrue);

        for (final act in session.activities) {
          final errors = InteractiveActivityIntegrityValidator.validateActivity(act);
          expect(errors, isEmpty, reason: 'Activity ${act.id} has errors: $errors');
        }
      }
    });

    test('2. Catches Critical Defect: Rabbit -> Rabbit in feedCharacter', () {
      final profile = AgeExperienceProfile.forAge(3);
      final scene = InteractiveScene.picnicScene();
      final rabbit = scene.objects.firstWhere((o) => o.objectId == 'picnic_rabbit_01');

      final invalidFeedConfig = InteractiveActivityConfig(
        id: 'invalid_feed_rabbit_to_rabbit',
        conceptId: 'concept_rabbit',
        mechanicType: ActivityMechanicType.feedCharacter,
        scene: scene,
        targetObjectId: rabbit.objectId,
        targetDestinationId: rabbit.objectId,
        draggableObject: rabbit, // Rabbit dragging onto rabbit!
        sceneActor: rabbit,
        dropTarget: rabbit,
        ageProfile: profile,
        instructionOverride: 'The rabbit is hungry! Give it an apple. 🐰🍎',
      );

      final errors = InteractiveActivityIntegrityValidator.validateActivity(invalidFeedConfig);
      expect(errors, isNotEmpty);
      expect(errors.any((e) => e.contains('CRITICAL DEFECT') && e.contains('receiver onto itself')), isTrue);
    });

    test('3. Catches Mismatched Instruction Nouns: Apple instruction with Water draggable', () {
      final profile = AgeExperienceProfile.forAge(3);
      final scene = InteractiveScene.picnicScene();
      final water = scene.objects.firstWhere((o) => o.objectId == 'picnic_water_01');
      final basket = scene.objects.firstWhere((o) => o.objectId == 'picnic_basket_01');

      final invalidDragConfig = InteractiveActivityConfig(
        id: 'invalid_drag_water_apple_mismatch',
        conceptId: 'concept_water',
        mechanicType: ActivityMechanicType.dragAndDrop,
        scene: scene,
        targetObjectId: water.objectId,
        targetDestinationId: basket.objectId,
        draggableObject: water, // Water when instruction asks for Apple!
        dropTarget: basket,
        ageProfile: profile,
        instructionOverride: 'Drag the apple into the basket.',
      );

      final errors = InteractiveActivityIntegrityValidator.validateActivity(invalidDragConfig);
      expect(errors, isNotEmpty);
      expect(errors.any((e) => e.contains('Instruction asks for apple, but draggable is concept_water')), isTrue);
    });

    test('4. Catches Mismatched Drop Target: Basket instruction with Table dropTarget', () {
      final profile = AgeExperienceProfile.forAge(3);
      final scene = InteractiveScene.picnicScene();
      final apple = scene.objects.firstWhere((o) => o.objectId == 'picnic_apple_01');
      final table = scene.objects.firstWhere((o) => o.objectId == 'picnic_table_01');

      final invalidTargetConfig = InteractiveActivityConfig(
        id: 'invalid_drop_target_mismatch',
        conceptId: 'concept_apple',
        mechanicType: ActivityMechanicType.dragAndDrop,
        scene: scene,
        targetObjectId: apple.objectId,
        targetDestinationId: table.objectId,
        draggableObject: apple,
        dropTarget: table, // Table when instruction asks for Basket!
        ageProfile: profile,
        instructionOverride: 'Put the apple in the basket! 🍎',
      );

      final errors = InteractiveActivityIntegrityValidator.validateActivity(invalidTargetConfig);
      expect(errors, isNotEmpty);
      expect(errors.any((e) => e.contains('Instruction asks for basket, but dropTarget is concept_table')), isTrue);
    });

    test('5. Catches Identical Draggable and Drop Target in scenePlacement', () {
      final profile = AgeExperienceProfile.forAge(7);
      final scene = InteractiveScene.picnicScene();
      final book = scene.objects.firstWhere((o) => o.objectId == 'picnic_book_01');

      final invalidPlacement = InteractiveActivityConfig(
        id: 'invalid_placement_same_object',
        conceptId: 'concept_book',
        mechanicType: ActivityMechanicType.scenePlacement,
        scene: scene,
        targetObjectId: book.objectId,
        targetDestinationId: book.objectId,
        draggableObject: book,
        dropTarget: book,
        ageProfile: profile,
        instructionOverride: 'Put the book on the table. 📖',
      );

      final errors = InteractiveActivityIntegrityValidator.validateActivity(invalidPlacement);
      expect(errors, isNotEmpty);
      expect(errors.any((e) => e.contains('draggable cannot be same as target')), isTrue);
    });

    test('6. Catches SpeakToMakeSomethingHappen missing trigger phrase', () {
      final profile = AgeExperienceProfile.forAge(3);
      final scene = InteractiveScene.picnicScene();
      final door = scene.objects.firstWhere((o) => o.objectId == 'picnic_door_01');

      final invalidSpeak = InteractiveActivityConfig(
        id: 'invalid_speak_missing_phrase',
        conceptId: 'concept_door',
        mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
        scene: scene,
        targetObjectId: door.objectId,
        ageProfile: profile,
        speakTriggerPhrase: '', // Empty trigger phrase!
        instructionOverride: 'Say: Open the door! 🚪',
      );

      final errors = InteractiveActivityIntegrityValidator.validateActivity(invalidSpeak);
      expect(errors, isNotEmpty);
      expect(errors.any((e) => e.contains('requires speakTriggerPhrase')), isTrue);
    });

    test('7. Production pipeline: Intentionally corrupted water -> apple activity is rejected', () {
      final profile = AgeExperienceProfile.forAge(3);
      final scene = InteractiveScene.picnicScene();
      final water = scene.objects.firstWhere((o) => o.objectId == 'picnic_water_01');
      final apple = scene.objects.firstWhere((o) => o.objectId == 'picnic_apple_01');

      // Intentionally corrupted activity: Prompt asks for apple into basket, but draggable is water!
      final corruptedActivity = InteractiveActivityConfig(
        id: 'corrupted_water_to_apple',
        conceptId: 'concept_water',
        mechanicType: ActivityMechanicType.dragAndDrop,
        scene: scene,
        targetObjectId: water.objectId,
        targetDestinationId: apple.objectId,
        draggableObject: water,
        dropTarget: apple,
        ageProfile: profile,
        instructionOverride: 'Drag the apple into the basket.',
      );

      final corruptedSession = InteractiveLessonSession(
        sessionId: 'test_corrupted_session',
        lessonId: 'activity_picnic_vocab',
        title: 'Corrupted Test Session',
        ageProfile: profile,
        activities: [corruptedActivity],
        totalEstimatedMinutes: 3,
      );

      // Must be rejected by production validator with ActivityIntegrityException
      expect(
        () => InteractiveActivityIntegrityValidator.validateSession(corruptedSession),
        throwsA(isA<ActivityIntegrityException>()),
      );
    });

    test('8. Validates exact Phase 16.8 Production Semantic Bindings', () {
      // Age 3 Session (Pip's Picnic)
      final profileAge3 = AgeExperienceProfile.forAge(3);
      final sessionAge3 = InteractiveSessionComposer.composeSession(
        ageProfile: profileAge3,
        lessonId: 'activity_picnic_vocab',
      );

      // Age 3 Interaction 2: draggable = APPLE, target = BASKET
      final act2 = sessionAge3.activities[1];
      expect(act2.draggableObject?.objectId, equals('picnic_apple_01'),
          reason: 'Interaction 2 draggable must be APPLE');
      expect(act2.dropTarget?.objectId, equals('picnic_basket_01'),
          reason: 'Interaction 2 dropTarget must be BASKET');
      expect(act2.learningConceptId, equals('concept_apple'));

      // Age 3 Interaction 3: requestedObject = APPLE, receiver = RABBIT
      final act3 = sessionAge3.activities[2];
      expect(act3.requestedObject?.objectId, equals('picnic_apple_01'),
          reason: 'Interaction 3 requestedObject must be APPLE');
      expect(act3.sceneActor?.objectId, equals('picnic_rabbit_01'),
          reason: 'Interaction 3 receiver must be RABBIT');
      expect(act3.dropTarget?.objectId, equals('picnic_rabbit_01'),
          reason: 'Interaction 3 dropTarget must be RABBIT');

      // Age 3 Interaction 4: draggable/requestedObject = WATER, receiver = PIP
      final act4 = sessionAge3.activities[3];
      expect(act4.draggableObject?.objectId, equals('picnic_water_01'),
          reason: 'Interaction 4 draggable must be WATER');
      expect(act4.requestedObject?.objectId, equals('picnic_water_01'),
          reason: 'Interaction 4 requestedObject must be WATER');
      expect(act4.sceneActor?.objectId, equals('picnic_pip_01'),
          reason: 'Interaction 4 receiver must be PIP');
      expect(act4.dropTarget?.objectId, equals('picnic_pip_01'),
          reason: 'Interaction 4 dropTarget must be PIP');

      // Age 7 Session (Band B Young Adventurers)
      final profileAge7 = AgeExperienceProfile.forAge(7);
      final sessionAge7 = InteractiveSessionComposer.composeSession(
        ageProfile: profileAge7,
        lessonId: 'activity_picnic_vocab',
      );

      // Age 7 Interaction 2: book -> table
      final actBookTable = sessionAge7.activities[1];
      expect(actBookTable.draggableObject?.objectId, equals('picnic_book_01'),
          reason: 'Age 7 Interaction 2 draggable must be BOOK');
      expect(actBookTable.dropTarget?.objectId, equals('picnic_table_01'),
          reason: 'Age 7 Interaction 2 dropTarget must be TABLE');
      expect(actBookTable.spatialRelation, equals('on'));

      // Age 7 Interaction 7: door closed -> door open
      final actDoor = sessionAge7.activities[6];
      expect(actDoor.targetObjectId, equals('picnic_door_01'));
      final doorObj = actDoor.scene.objects.firstWhere((o) => o.objectId == 'picnic_door_01');
      expect(doorObj.emoji, equals('🚪'));
      expect(doorObj.reactionType, equals(SceneReactionType.doorOpen));
      expect(actDoor.successReaction, equals(SceneReactionType.doorOpen),
          reason: 'Success reaction must trigger doorOpen');
      expect(actDoor.speakTriggerPhrase, equals('open the door'));
    });
  });
}
