import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/core/experience/interactive_session_composer.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';

void main() {
  group('InteractiveSessionComposer Unit Tests (Phase 16.8)', () {
    late ActivityVarietyEngine varietyEngine;

    setUp(() {
      varietyEngine = ActivityVarietyEngine(maxConsecutiveAllowed: 2);
    });

    test('1. Age 3 Session: 6 interactions in Pip\'s Picnic, exact semantic payloads', () {
      final profile = AgeExperienceProfile.forAge(3);
      final session = InteractiveSessionComposer.composeSession(
        ageProfile: profile,
        lessonId: 'activity_animal_vocab',
        targetConceptWords: ['apple', 'water'],
        varietyEngine: varietyEngine,
      );

      expect(session.ageProfile.ageBand, LearningAgeBand.bandPreALittleListeners);
      expect(session.ageProfile.textDensity, TextDensity.zero);
      expect(session.ageProfile.readingRequirement, ReadingRequirement.none);
      expect(session.ageProfile.speakingRequirement, SpeakingRequirement.optionalImitation);
      expect(session.ageProfile.numberOfChoices, 2);
      expect(session.ageProfile.visualTargetSize, 120.0);
      expect(session.totalEstimatedMinutes, inInclusiveRange(3, 4));

      // Bounded session: 6 short interactions
      expect(session.activities.length, 6);

      // Activity 1: Find Apple
      final act1 = session.activities[0];
      expect(act1.mechanicType, ActivityMechanicType.listenAndTouch);
      expect(act1.conceptId, 'concept_apple');
      expect(act1.targetObjectId, 'picnic_apple_01');

      // Activity 2: Move Apple to Basket (Contract: apple -> basket)
      final act2 = session.activities[1];
      expect(act2.mechanicType, ActivityMechanicType.dragAndDrop);
      expect(act2.draggableObject, isNotNull);
      expect(act2.draggableObject!.conceptId, 'concept_apple');
      expect(act2.draggableObject!.objectId, 'picnic_apple_01');
      expect(act2.dropTarget, isNotNull);
      expect(act2.dropTarget!.conceptId, 'concept_basket');
      expect(act2.dropTarget!.objectId, 'picnic_basket_01');
      expect(act2.targetDestinationId, 'picnic_basket_01');

      // Activity 3: Help Rabbit (Contract: requestedObject apple -> receiver rabbit)
      final act3 = session.activities[2];
      expect(act3.mechanicType, ActivityMechanicType.feedCharacter);
      expect(act3.draggableObject, isNotNull);
      expect(act3.draggableObject!.conceptId, 'concept_apple');
      expect(act3.requestedObject, isNotNull);
      expect(act3.requestedObject!.conceptId, 'concept_apple');
      expect(act3.sceneActor, isNotNull);
      expect(act3.sceneActor!.conceptId, 'concept_rabbit');
      expect(act3.sceneActor!.objectId, 'picnic_rabbit_01');
      expect(act3.draggableObject!.objectId != act3.sceneActor!.objectId, isTrue,
          reason: 'CRITICAL: Must NEVER drag rabbit to rabbit');

      // Activity 4: Help Pip (Contract: water -> Pip)
      final act4 = session.activities[3];
      expect(act4.mechanicType, ActivityMechanicType.feedCharacter);
      expect(act4.draggableObject!.conceptId, 'concept_water');
      expect(act4.sceneActor!.conceptId, 'concept_pip');

      // Activity 5: Optional Speaking "Water"
      final act5 = session.activities[4];
      expect(act5.mechanicType, ActivityMechanicType.speakToMakeSomethingHappen);
      expect(act5.speakTriggerPhrase, 'water');

      // Activity 6: Picnic Celebration
      final act6 = session.activities[5];
      expect(act6.mechanicType, ActivityMechanicType.listenAndTouch);
      expect(act6.targetObjectId, 'picnic_basket_01');

      // Verify Variety rule
      final mechanics = session.activities.map((a) => a.mechanicType).toList();
      for (int i = 0; i < mechanics.length - 2; i++) {
        final repeated = mechanics[i] == mechanics[i + 1] && mechanics[i] == mechanics[i + 2];
        expect(repeated, isFalse, reason: 'Variety rule violated at index $i');
      }
    });

    test('2. Age 5 Session: 6 interactions, 3 choices, visual exploration & drag', () {
      final profile = AgeExperienceProfile.forAge(5);
      final session = InteractiveSessionComposer.composeSession(
        ageProfile: profile,
        lessonId: 'activity_animal_vocab',
        targetConceptWords: ['apple', 'water'],
        varietyEngine: varietyEngine,
      );

      expect(session.ageProfile.ageBand, LearningAgeBand.bandALittleExplorers);
      expect(session.ageProfile.textDensity, TextDensity.minimal);
      expect(session.ageProfile.readingRequirement, ReadingRequirement.emergent);
      expect(session.ageProfile.speakingRequirement, SpeakingRequirement.encouragedRepetition);
      expect(session.ageProfile.numberOfChoices, 3);
      expect(session.ageProfile.visualTargetSize, 96.0);
      expect(session.activities.length, 6);

      // Check feed character
      final feed = session.activities.firstWhere((a) => a.id.contains('feed_hungry_rabbit'));
      expect(feed.draggableObject!.conceptId, 'concept_apple');
      expect(feed.sceneActor!.conceptId, 'concept_rabbit');
    });

    test('3. Age 7 Session: 7 interactions, prepositions & role-play', () {
      final profile = AgeExperienceProfile.forAge(7);
      final session = InteractiveSessionComposer.composeSession(
        ageProfile: profile,
        lessonId: 'activity_animal_vocab',
        targetConceptWords: ['apple', 'water'],
        varietyEngine: varietyEngine,
      );

      expect(session.ageProfile.ageBand, LearningAgeBand.bandBYoungAdventurers);
      expect(session.ageProfile.textDensity, TextDensity.moderate);
      expect(session.ageProfile.readingRequirement, ReadingRequirement.supported);
      expect(session.ageProfile.speakingRequirement, SpeakingRequirement.expectedProduction);
      expect(session.ageProfile.numberOfChoices, 4);
      expect(session.ageProfile.visualTargetSize, 76.0);
      expect(session.activities.length, 7);

      // Verify scene placement book on table
      final placement = session.activities.firstWhere((a) => a.mechanicType == ActivityMechanicType.scenePlacement);
      expect(placement.draggableObject!.conceptId, 'concept_book');
      expect(placement.dropTarget!.conceptId, 'concept_table');
      expect(placement.spatialRelation, 'on');

      // Verify role play
      final rolePlay = session.activities.firstWhere((a) => a.mechanicType == ActivityMechanicType.conversationRolePlay);
      expect(rolePlay.rolePlayPipPrompt, 'What would you like at the picnic?');
      expect(rolePlay.rolePlayExpectedResponse, 'Water, please.');
    });

    test('4. Age 9 Session: 7 interactions, contextual problem, mature 58px layout', () {
      final profile = AgeExperienceProfile.forAge(9);
      final session = InteractiveSessionComposer.composeSession(
        ageProfile: profile,
        lessonId: 'activity_animal_vocab',
        targetConceptWords: ['water', 'apple'],
        varietyEngine: varietyEngine,
      );

      expect(session.ageProfile.ageBand, LearningAgeBand.bandCGrowingSpeakers);
      expect(session.ageProfile.textDensity, TextDensity.rich);
      expect(session.ageProfile.readingRequirement, ReadingRequirement.independent);
      expect(session.ageProfile.speakingRequirement, SpeakingRequirement.conversationalDiscourse);
      expect(session.ageProfile.numberOfChoices, 4);
      expect(session.ageProfile.visualTargetSize, 58.0);
      expect(session.activities.length, 7);

      // Activity 1: Contextual problem
      final act1 = session.activities[0];
      expect(act1.contextualProblemPrompt, isNotNull);
      expect(act1.contextualChoices, isNotNull);
      expect(act1.targetObjectId, 'picnic_water_01');

      // Activity 2: Pack water in basket
      final act2 = session.activities[1];
      expect(act2.draggableObject!.conceptId, 'concept_water');
      expect(act2.dropTarget!.conceptId, 'concept_basket');
    });
  });
}
