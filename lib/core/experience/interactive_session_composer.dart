import 'package:equatable/equatable.dart';
import 'age_experience_profile.dart';
import 'interactive_activity_engine.dart';
import 'interactive_activity_integrity_validator.dart';
import 'interactive_scene.dart';
import 'interactive_scene_object.dart';
import '../../features/curriculum/domain/models/learning_age_band.dart';
import '../../features/curriculum/data/seed/v2/curriculum_content_v2.dart';

/// Represents an ordered, cohesive interactive lesson session tailored to a child's age profile.
class InteractiveLessonSession extends Equatable {
  final String sessionId;
  final String lessonId;
  final String title;
  final AgeExperienceProfile ageProfile;
  final List<InteractiveActivityConfig> activities;
  final int totalEstimatedMinutes;
  final int rewardXp;
  final int rewardCoins;
  final int rewardStars;

  const InteractiveLessonSession({
    required this.sessionId,
    required this.lessonId,
    required this.title,
    required this.ageProfile,
    required this.activities,
    required this.totalEstimatedMinutes,
    this.rewardXp = 20,
    this.rewardCoins = 10,
    this.rewardStars = 3,
  });

  @override
  List<Object?> get props => [
        sessionId,
        lessonId,
        title,
        ageProfile,
        activities,
        totalEstimatedMinutes,
        rewardXp,
        rewardCoins,
        rewardStars,
      ];
}

/// Central production composer that transforms curriculum lessons into
/// age-adaptive, highly interactive learning sessions with the 7 Core Mechanics.
class InteractiveSessionComposer {
  /// Composes a developmentally tailored session for a given [lessonId] and [ageProfile].
  static InteractiveLessonSession composeSession({
    required AgeExperienceProfile ageProfile,
    required String lessonId,
    String? title,
    List<String> targetConceptWords = const [],
    ActivityVarietyEngine? varietyEngine,
  }) {
    final engine = varietyEngine ?? ActivityVarietyEngine(maxConsecutiveAllowed: 2);
    final String cleanConcept = _extractPrimaryConcept(targetConceptWords, lessonId);
    final String displayTitle = title ?? _generateSessionTitle(lessonId, cleanConcept);

    // Curriculum Content V2 Integration: If lesson has production handcrafted activities, load directly!
    final v2Activities = CurriculumContentV2.getActivitiesForLesson(lessonId);
    if (v2Activities.isNotEmpty) {
      final v2Lesson = CurriculumContentV2.getLessonById(lessonId);
      final session = InteractiveLessonSession(
        sessionId: 'session_${lessonId}_${ageProfile.age}',
        lessonId: lessonId,
        title: title ?? (v2Lesson?.title ?? displayTitle),
        ageProfile: ageProfile,
        activities: v2Activities,
        totalEstimatedMinutes: v2Lesson?.estimatedDurationMinutes ?? ageProfile.sessionDuration.inMinutes,
        rewardXp: 20,
        rewardCoins: 10,
        rewardStars: 3,
      );
      InteractiveActivityIntegrityValidator.validateSession(session);
      return session;
    }

    final List<InteractiveActivityConfig> activities = [];

    switch (ageProfile.ageBand) {
      case LearningAgeBand.bandPreALittleListeners:
        _composePreALittleListenersSession(
          activities: activities,
          ageProfile: ageProfile,
          lessonId: lessonId,
          primaryConcept: cleanConcept,
          varietyEngine: engine,
        );
        break;

      case LearningAgeBand.bandALittleExplorers:
        _composeBandAExplorersSession(
          activities: activities,
          ageProfile: ageProfile,
          lessonId: lessonId,
          primaryConcept: cleanConcept,
          varietyEngine: engine,
        );
        break;

      case LearningAgeBand.bandBYoungAdventurers:
        _composeBandBAdventurersSession(
          activities: activities,
          ageProfile: ageProfile,
          lessonId: lessonId,
          primaryConcept: cleanConcept,
          varietyEngine: engine,
        );
        break;

      case LearningAgeBand.bandCGrowingSpeakers:
      case LearningAgeBand.bandDConfidentSpeakers:
        _composeBandCSpeakersSession(
          activities: activities,
          ageProfile: ageProfile,
          lessonId: lessonId,
          primaryConcept: cleanConcept,
          varietyEngine: engine,
        );
        break;
    }

    final session = InteractiveLessonSession(
      sessionId: 'session_${lessonId}_${ageProfile.age}',
      lessonId: lessonId,
      title: displayTitle,
      ageProfile: ageProfile,
      activities: activities,
      totalEstimatedMinutes: ageProfile.sessionDuration.inMinutes,
      rewardXp: 20,
      rewardCoins: 10,
      rewardStars: 3,
    );

    // Phase 16.8: Verify 100% semantic and role integrity before returning session
    InteractiveActivityIntegrityValidator.validateSession(session);

    return session;
  }

  /// Extracts or defaults the primary target concept from lesson context.
  static String _extractPrimaryConcept(List<String> targetConceptWords, String lessonId) {
    if (targetConceptWords.isNotEmpty) {
      final first = targetConceptWords.first.toLowerCase().replaceAll('vocab_', '');
      if (first.isNotEmpty) return first;
    }
    if (lessonId.contains('animal') || lessonId.contains('safari')) return 'apple';
    if (lessonId.contains('home') || lessonId.contains('family')) return 'door';
    if (lessonId.contains('food') || lessonId.contains('picnic')) return 'apple';
    if (lessonId.contains('nature') || lessonId.contains('weather')) return 'water';
    if (lessonId.contains('school') || lessonId.contains('classroom')) return 'book';
    return 'apple';
  }

  static String _generateSessionTitle(String lessonId, String concept) {
    final capConcept = concept.isNotEmpty
        ? concept[0].toUpperCase() + concept.substring(1)
        : 'Adventure';
    return "Pip's Picnic: $capConcept 🧺";
  }

  /// AGE 3–4 (Pre-A Little Listeners):
  /// - Persistent Mini-Scene: "Pip's Picnic" (6 short, connected interactions)
  /// - Zero required reading (TextDensity.zero)
  /// - Zero mandatory speech (SpeakingRequirement.optionalImitation with touch fallback)
  /// - Maximum 2 choices
  /// - Huge touch targets (120px)
  /// - Pure audio-first instructions
  /// - Target duration: 3–4 minutes
  static void _composePreALittleListenersSession({
    required List<InteractiveActivityConfig> activities,
    required AgeExperienceProfile ageProfile,
    required String lessonId,
    required String primaryConcept,
    required ActivityVarietyEngine varietyEngine,
  }) {
    final scene = InteractiveScene.picnicScene();
    final apple = scene.objects.firstWhere((o) => o.objectId == 'picnic_apple_01');
    final basket = scene.objects.firstWhere((o) => o.objectId == 'picnic_basket_01');
    final rabbit = scene.objects.firstWhere((o) => o.objectId == 'picnic_rabbit_01');
    final water = scene.objects.firstWhere((o) => o.objectId == 'picnic_water_01');
    final pip = scene.objects.firstWhere((o) => o.objectId == 'picnic_pip_01');

    // 1. Find Apple (Listen & Touch: 2 large visuals, child touches apple)
    final m1 = varietyEngine.selectNextMechanic([ActivityMechanicType.listenAndTouch]);
    varietyEngine.recordActivity(m1);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step1_find_apple',
      conceptId: 'concept_apple',
      learningConceptId: 'concept_apple',
      mechanicType: ActivityMechanicType.listenAndTouch,
      scene: scene,
      targetObjectId: apple.objectId,
      draggableObject: apple,
      distractors: [water],
      ageProfile: ageProfile,
      instructionOverride: 'Apple! 🍎',
      audioPromptOverride: 'Apple',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'Delicious crisp red apple! 🍎',
    ));

    // 2. Move (Drag & Drop: child drags SAME apple into SAME basket)
    final m2 = varietyEngine.selectNextMechanic([ActivityMechanicType.dragAndDrop]);
    varietyEngine.recordActivity(m2);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step2_move_apple_basket',
      conceptId: 'concept_apple',
      learningConceptId: 'concept_apple',
      mechanicType: ActivityMechanicType.dragAndDrop,
      scene: scene,
      targetObjectId: apple.objectId,
      targetDestinationId: basket.objectId,
      draggableObject: apple,
      dropTarget: basket,
      ageProfile: ageProfile,
      instructionOverride: 'Put the apple in the basket! 🍎',
      audioPromptOverride: 'Put the apple in the basket',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'The apple is in the basket! 🧺🍎',
    ));

    // 3. Help Rabbit (Feed Character: Rabbit arrives hungry; move apple to rabbit)
    final m3 = varietyEngine.selectNextMechanic([ActivityMechanicType.feedCharacter]);
    varietyEngine.recordActivity(m3);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step3_feed_rabbit',
      conceptId: 'concept_apple',
      learningConceptId: 'concept_apple',
      mechanicType: ActivityMechanicType.feedCharacter,
      scene: scene,
      targetObjectId: apple.objectId,
      targetDestinationId: rabbit.objectId,
      draggableObject: apple,
      requestedObject: apple,
      sceneActor: rabbit,
      dropTarget: rabbit,
      ageProfile: ageProfile,
      instructionOverride: 'The rabbit is hungry! Give it the apple. 🐰🍎',
      audioPromptOverride: 'Feed the rabbit the apple',
      successReaction: SceneReactionType.eatAnimation,
      successReactionPrompt: 'Nom nom! The rabbit happily eats the apple! 🐰😋',
    ));

    // 4. Help Pip (Feed Character: Pip is thirsty; give Pip water)
    final m4 = varietyEngine.selectNextMechanic([ActivityMechanicType.feedCharacter]);
    varietyEngine.recordActivity(m4);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step4_give_water_pip',
      conceptId: 'concept_water',
      learningConceptId: 'concept_water',
      mechanicType: ActivityMechanicType.feedCharacter,
      scene: scene,
      targetObjectId: water.objectId,
      targetDestinationId: pip.objectId,
      draggableObject: water,
      requestedObject: water,
      sceneActor: pip,
      dropTarget: pip,
      ageProfile: ageProfile,
      instructionOverride: 'Pip is thirsty! Give Pip water. 🐥💧',
      audioPromptOverride: 'Give Pip water',
      successReaction: SceneReactionType.sound,
      successReactionPrompt: 'Ah, refreshing water! Thank you! 🐥✨',
    ));

    // 5. Optional Speaking (Speak to Make Something Happen: "Water" with instant touch fallback)
    final m5 = varietyEngine.selectNextMechanic([ActivityMechanicType.speakToMakeSomethingHappen]);
    varietyEngine.recordActivity(m5);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step5_speak_water',
      conceptId: 'concept_water',
      learningConceptId: 'concept_water',
      mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
      scene: scene,
      targetObjectId: water.objectId,
      draggableObject: water,
      sceneActor: pip,
      speakTriggerPhrase: 'water',
      ageProfile: ageProfile,
      instructionOverride: 'Water. Can you say water? 💧',
      audioPromptOverride: 'Water. Can you say water?',
      successReaction: SceneReactionType.waterRipple,
      successReactionPrompt: 'Water! Good job! 💧✨',
    ));

    // 6. Tiny Picnic Celebration (Listen & Touch on Basket: celebratory wrap-up, no test framing)
    final m6 = varietyEngine.selectNextMechanic([ActivityMechanicType.listenAndTouch]);
    varietyEngine.recordActivity(m6);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step6_celebrate_picnic',
      conceptId: 'concept_basket',
      learningConceptId: 'concept_basket',
      mechanicType: ActivityMechanicType.listenAndTouch,
      scene: scene,
      targetObjectId: basket.objectId,
      draggableObject: basket,
      ageProfile: ageProfile,
      instructionOverride: 'Picnic time! Touch the basket to celebrate! 🧺🎉',
      audioPromptOverride: 'Picnic time!',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'Yay! Picnic adventure complete! 🧺⭐',
    ));
  }

  /// AGE 4–5 (Band A Little Explorers):
  /// - Same persistent picnic scene with increased vocabulary (6 interactions)
  /// - Single word text labels (TextDensity.minimal)
  /// - 3 visual choices
  /// - Encouraged repetition with immediate positive feedback
  /// - Target duration: 5–6 minutes
  static void _composeBandAExplorersSession({
    required List<InteractiveActivityConfig> activities,
    required AgeExperienceProfile ageProfile,
    required String lessonId,
    required String primaryConcept,
    required ActivityVarietyEngine varietyEngine,
  }) {
    final scene = InteractiveScene.picnicScene();
    final apple = scene.objects.firstWhere((o) => o.objectId == 'picnic_apple_01');
    final basket = scene.objects.firstWhere((o) => o.objectId == 'picnic_basket_01');
    final rabbit = scene.objects.firstWhere((o) => o.objectId == 'picnic_rabbit_01');
    final water = scene.objects.firstWhere((o) => o.objectId == 'picnic_water_01');
    final pip = scene.objects.firstWhere((o) => o.objectId == 'picnic_pip_01');
    final table = scene.objects.firstWhere((o) => o.objectId == 'picnic_table_01');
    final book = scene.objects.firstWhere((o) => o.objectId == 'picnic_book_01');

    // 1. Listen & Touch
    final m1 = varietyEngine.selectNextMechanic([ActivityMechanicType.listenAndTouch]);
    varietyEngine.recordActivity(m1);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step1_find_red_apple',
      conceptId: 'concept_apple',
      learningConceptId: 'concept_apple',
      mechanicType: ActivityMechanicType.listenAndTouch,
      scene: scene,
      targetObjectId: apple.objectId,
      draggableObject: apple,
      distractors: [water, basket],
      ageProfile: ageProfile,
      instructionOverride: 'Find the red apple. 🍎',
      audioPromptOverride: 'Find the red apple',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'You found the red apple! 🍎✨',
    ));

    // 2. Drag & Drop
    final m2 = varietyEngine.selectNextMechanic([ActivityMechanicType.dragAndDrop]);
    varietyEngine.recordActivity(m2);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step2_apple_into_basket',
      conceptId: 'concept_apple',
      learningConceptId: 'concept_apple',
      mechanicType: ActivityMechanicType.dragAndDrop,
      scene: scene,
      targetObjectId: apple.objectId,
      targetDestinationId: basket.objectId,
      draggableObject: apple,
      dropTarget: basket,
      ageProfile: ageProfile,
      instructionOverride: 'Put the apple in the basket. 🧺',
      audioPromptOverride: 'Put the apple in the basket',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'Apple neatly in the basket! 🧺🍎',
    ));

    // 3. Feed Character
    final m3 = varietyEngine.selectNextMechanic([ActivityMechanicType.feedCharacter]);
    varietyEngine.recordActivity(m3);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step3_feed_hungry_rabbit',
      conceptId: 'concept_apple',
      learningConceptId: 'concept_apple',
      mechanicType: ActivityMechanicType.feedCharacter,
      scene: scene,
      targetObjectId: apple.objectId,
      targetDestinationId: rabbit.objectId,
      draggableObject: apple,
      requestedObject: apple,
      sceneActor: rabbit,
      dropTarget: rabbit,
      ageProfile: ageProfile,
      instructionOverride: 'The rabbit is hungry! Give it an apple. 🐰🍎',
      audioPromptOverride: 'Give the rabbit an apple',
      successReaction: SceneReactionType.eatAnimation,
      successReactionPrompt: 'Nom nom! The happy rabbit is full! 🐰😋',
    ));

    // 4. Give Pip Water
    final m4 = varietyEngine.selectNextMechanic([ActivityMechanicType.feedCharacter]);
    varietyEngine.recordActivity(m4);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step4_give_pip_water',
      conceptId: 'concept_water',
      learningConceptId: 'concept_water',
      mechanicType: ActivityMechanicType.feedCharacter,
      scene: scene,
      targetObjectId: water.objectId,
      targetDestinationId: pip.objectId,
      draggableObject: water,
      requestedObject: water,
      sceneActor: pip,
      dropTarget: pip,
      ageProfile: ageProfile,
      instructionOverride: 'Pip is thirsty! Give Pip water. 🐥💧',
      audioPromptOverride: 'Give Pip water',
      successReaction: SceneReactionType.sound,
      successReactionPrompt: 'Pip is happy and refreshed! 🐥✨',
    ));

    // 5. Spoken Request
    final m5 = varietyEngine.selectNextMechanic([ActivityMechanicType.speakToMakeSomethingHappen]);
    varietyEngine.recordActivity(m5);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step5_speak_water_please',
      conceptId: 'concept_water',
      learningConceptId: 'concept_water',
      mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
      scene: scene,
      targetObjectId: water.objectId,
      draggableObject: water,
      sceneActor: pip,
      speakTriggerPhrase: 'water please',
      ageProfile: ageProfile,
      instructionOverride: 'Say: Water, please! 💧✨',
      audioPromptOverride: 'Say: Water, please',
      successReaction: SceneReactionType.waterRipple,
      successReactionPrompt: 'Here is your fresh water! 💧✨',
    ));

    // 6. Scene Placement
    final m6 = varietyEngine.selectNextMechanic([ActivityMechanicType.scenePlacement]);
    varietyEngine.recordActivity(m6);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step6_place_book_table',
      conceptId: 'concept_book',
      learningConceptId: 'concept_book',
      mechanicType: ActivityMechanicType.scenePlacement,
      scene: scene,
      targetObjectId: book.objectId,
      targetDestinationId: table.objectId,
      draggableObject: book,
      dropTarget: table,
      spatialRelation: 'on',
      ageProfile: ageProfile,
      instructionOverride: 'Put the book on the table. 📖',
      audioPromptOverride: 'Put the book on the table',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'The book is neatly on the table! 📖',
    ));
  }

  /// AGE 6–7 (Band B Young Adventurers):
  /// - Same picnic domain with deeper grammar, full sentences & spatial interaction (7 interactions)
  /// - Sentence captions (TextDensity.moderate)
  /// - 4 visual choices
  /// - Dialogic role-play with Pip
  /// - Target duration: 8–10 minutes
  static void _composeBandBAdventurersSession({
    required List<InteractiveActivityConfig> activities,
    required AgeExperienceProfile ageProfile,
    required String lessonId,
    required String primaryConcept,
    required ActivityVarietyEngine varietyEngine,
  }) {
    final scene = InteractiveScene.picnicScene();
    final apple = scene.objects.firstWhere((o) => o.objectId == 'picnic_apple_01');
    final basket = scene.objects.firstWhere((o) => o.objectId == 'picnic_basket_01');
    final rabbit = scene.objects.firstWhere((o) => o.objectId == 'picnic_rabbit_01');
    final water = scene.objects.firstWhere((o) => o.objectId == 'picnic_water_01');
    final table = scene.objects.firstWhere((o) => o.objectId == 'picnic_table_01');
    final book = scene.objects.firstWhere((o) => o.objectId == 'picnic_book_01');
    final door = scene.objects.firstWhere((o) => o.objectId == 'picnic_door_01');

    // 1. Sentence Comprehension
    final m1 = varietyEngine.selectNextMechanic([ActivityMechanicType.listenAndTouch]);
    varietyEngine.recordActivity(m1);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step1_sentence_touch',
      conceptId: 'concept_apple',
      learningConceptId: 'concept_apple',
      mechanicType: ActivityMechanicType.listenAndTouch,
      scene: scene,
      targetObjectId: apple.objectId,
      draggableObject: apple,
      distractors: [water, basket, book],
      ageProfile: ageProfile,
      instructionOverride: 'What is this? It is an apple. 🍎',
      audioPromptOverride: 'What is this? It is an apple.',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'Correct! It is a delicious red apple. 🍎',
    ));

    // 2. Spatial Scene Placement
    final m2 = varietyEngine.selectNextMechanic([ActivityMechanicType.scenePlacement]);
    varietyEngine.recordActivity(m2);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step2_book_on_table',
      conceptId: 'concept_book',
      learningConceptId: 'concept_book',
      mechanicType: ActivityMechanicType.scenePlacement,
      scene: scene,
      targetObjectId: book.objectId,
      targetDestinationId: table.objectId,
      draggableObject: book,
      dropTarget: table,
      spatialRelation: 'on',
      ageProfile: ageProfile,
      instructionOverride: 'Put the book on the table. 📖',
      audioPromptOverride: 'Put the book on the table',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'Great job! The book is on the table. 📖',
    ));

    // 3. Drag into Picnic Basket
    final m3 = varietyEngine.selectNextMechanic([ActivityMechanicType.dragAndDrop]);
    varietyEngine.recordActivity(m3);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step3_drag_apple_basket',
      conceptId: 'concept_apple',
      learningConceptId: 'concept_apple',
      mechanicType: ActivityMechanicType.dragAndDrop,
      scene: scene,
      targetObjectId: apple.objectId,
      targetDestinationId: basket.objectId,
      draggableObject: apple,
      dropTarget: basket,
      ageProfile: ageProfile,
      instructionOverride: 'Drag the apple into the picnic basket. 🧺',
      audioPromptOverride: 'Drag the apple into the picnic basket',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'Packed safely inside the picnic basket! 🧺🍎',
    ));

    // 4. Feed Character
    final m4 = varietyEngine.selectNextMechanic([ActivityMechanicType.feedCharacter]);
    varietyEngine.recordActivity(m4);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step4_feed_rabbit_apple',
      conceptId: 'concept_apple',
      learningConceptId: 'concept_apple',
      mechanicType: ActivityMechanicType.feedCharacter,
      scene: scene,
      targetObjectId: apple.objectId,
      targetDestinationId: rabbit.objectId,
      draggableObject: apple,
      requestedObject: apple,
      sceneActor: rabbit,
      dropTarget: rabbit,
      ageProfile: ageProfile,
      instructionOverride: 'The hungry rabbit wants fruit. Feed the rabbit an apple. 🐰🍎',
      audioPromptOverride: 'Feed the rabbit an apple',
      successReaction: SceneReactionType.eatAnimation,
      successReactionPrompt: 'Nom nom! The rabbit happily munches the apple! 🐰😋',
    ));

    // 5. Spoken Action Trigger
    final m5 = varietyEngine.selectNextMechanic([ActivityMechanicType.speakToMakeSomethingHappen]);
    varietyEngine.recordActivity(m5);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step5_speak_water_polite',
      conceptId: 'concept_water',
      learningConceptId: 'concept_water',
      mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
      scene: scene,
      targetObjectId: water.objectId,
      draggableObject: water,
      speakTriggerPhrase: 'can i have some water please',
      ageProfile: ageProfile,
      instructionOverride: 'Say: Can I have some water, please? 🎙️💧',
      audioPromptOverride: 'Can I have some water, please?',
      successReaction: SceneReactionType.waterRipple,
      successReactionPrompt: 'Here is your fresh water! 💧✨',
    ));

    // 6. Conversation Role-Play with Pip
    final m6 = varietyEngine.selectNextMechanic([ActivityMechanicType.conversationRolePlay]);
    varietyEngine.recordActivity(m6);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step6_roleplay_picnic_pip',
      conceptId: 'concept_water',
      learningConceptId: 'concept_water',
      mechanicType: ActivityMechanicType.conversationRolePlay,
      scene: scene,
      targetObjectId: water.objectId,
      rolePlayPipPrompt: 'What would you like at the picnic?',
      rolePlayExpectedResponse: 'Water, please.',
      ageProfile: ageProfile,
      instructionOverride: 'Talk with Pip at the picnic! 🐥',
      audioPromptOverride: 'What would you like at the picnic?',
      successReaction: SceneReactionType.sound,
      successReactionPrompt: 'Wonderful manners! Pip shares the water with you. 🐥💧',
    ));

    // 7. Spoken Exploration (Open the Door)
    final m7 = varietyEngine.selectNextMechanic([ActivityMechanicType.speakToMakeSomethingHappen]);
    varietyEngine.recordActivity(m7);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step7_speak_open_door',
      conceptId: 'concept_door',
      learningConceptId: 'concept_door',
      mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
      scene: scene,
      targetObjectId: door.objectId,
      draggableObject: door,
      speakTriggerPhrase: 'open the door',
      ageProfile: ageProfile,
      instructionOverride: 'Say: Open the door to get the picnic blanket! 🚪✨',
      audioPromptOverride: 'Say: Open the door',
      successReaction: SceneReactionType.doorOpen,
      successReactionPrompt: 'The door opened wide! 🚪✨',
    ));
  }

  /// AGE 8–10 (Band C Growing Speakers) & AGE 11+ (Band D):
  /// - Contextual picnic problem, conversational sequence (7 interactions)
  /// - Rich textual context (TextDensity.rich)
  /// - Refined 58px targets without childish effects
  /// - Restrained Pip guidance (peer-like, subtleRefined)
  /// - Target duration: 10–12 minutes
  static void _composeBandCSpeakersSession({
    required List<InteractiveActivityConfig> activities,
    required AgeExperienceProfile ageProfile,
    required String lessonId,
    required String primaryConcept,
    required ActivityVarietyEngine varietyEngine,
  }) {
    final scene = InteractiveScene.picnicScene();
    final apple = scene.objects.firstWhere((o) => o.objectId == 'picnic_apple_01');
    final basket = scene.objects.firstWhere((o) => o.objectId == 'picnic_basket_01');
    final rabbit = scene.objects.firstWhere((o) => o.objectId == 'picnic_rabbit_01');
    final water = scene.objects.firstWhere((o) => o.objectId == 'picnic_water_01');
    final table = scene.objects.firstWhere((o) => o.objectId == 'picnic_table_01');
    final book = scene.objects.firstWhere((o) => o.objectId == 'picnic_book_01');
    final door = scene.objects.firstWhere((o) => o.objectId == 'picnic_door_01');

    // 1. Contextual Problem Solving
    final m1 = varietyEngine.selectNextMechanic([ActivityMechanicType.listenAndTouch]);
    varietyEngine.recordActivity(m1);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step1_contextual_drink_problem',
      conceptId: 'concept_water',
      learningConceptId: 'concept_water',
      mechanicType: ActivityMechanicType.listenAndTouch,
      scene: scene,
      targetObjectId: water.objectId,
      draggableObject: water,
      distractors: [book, table],
      contextualProblemPrompt: 'We forgot to pack a drink for the picnic. What should we take?',
      contextualChoices: const ['Water 💧', 'Book 📖', 'Table'],
      ageProfile: ageProfile,
      instructionOverride: 'Pip says: "We forgot to pack a drink for the picnic. What should we take?" 🧺',
      audioPromptOverride: 'What drink should we take to the picnic?',
      successReaction: SceneReactionType.waterRipple,
      successReactionPrompt: 'Good thinking. Fresh drinking water is essential for the hike.',
    ));

    // 2. Organization / Packing
    final m2 = varietyEngine.selectNextMechanic([ActivityMechanicType.dragAndDrop]);
    varietyEngine.recordActivity(m2);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step2_pack_water_basket',
      conceptId: 'concept_water',
      learningConceptId: 'concept_water',
      mechanicType: ActivityMechanicType.dragAndDrop,
      scene: scene,
      targetObjectId: water.objectId,
      targetDestinationId: basket.objectId,
      draggableObject: water,
      dropTarget: basket,
      ageProfile: ageProfile,
      instructionOverride: 'Place the water bottle inside the picnic basket. 🧺',
      audioPromptOverride: 'Place the water bottle inside the picnic basket',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'Water bottle securely packed in the basket.',
    ));

    // 3. Spatial Arrangement
    final m3 = varietyEngine.selectNextMechanic([ActivityMechanicType.scenePlacement]);
    varietyEngine.recordActivity(m3);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step3_guidebook_table',
      conceptId: 'concept_book',
      learningConceptId: 'concept_book',
      mechanicType: ActivityMechanicType.scenePlacement,
      scene: scene,
      targetObjectId: book.objectId,
      targetDestinationId: table.objectId,
      draggableObject: book,
      dropTarget: table,
      spatialRelation: 'on',
      ageProfile: ageProfile,
      instructionOverride: 'Arrange the picnic area. Put the guidebook on the table. 📖',
      audioPromptOverride: 'Put the guidebook on the table',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'The field guidebook is placed ready on the table.',
    ));

    // 4. Wildlife Encounter
    final m4 = varietyEngine.selectNextMechanic([ActivityMechanicType.feedCharacter]);
    varietyEngine.recordActivity(m4);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step4_offer_apple_rabbit',
      conceptId: 'concept_apple',
      learningConceptId: 'concept_apple',
      mechanicType: ActivityMechanicType.feedCharacter,
      scene: scene,
      targetObjectId: apple.objectId,
      targetDestinationId: rabbit.objectId,
      draggableObject: apple,
      requestedObject: apple,
      sceneActor: rabbit,
      dropTarget: rabbit,
      ageProfile: ageProfile,
      instructionOverride: 'A friendly rabbit visits our picnic. Offer the apple to the rabbit. 🐰🍎',
      audioPromptOverride: 'Offer the apple to the rabbit',
      successReaction: SceneReactionType.eatAnimation,
      successReactionPrompt: 'The rabbit accepts the fruit with quiet delight.',
    ));

    // 5. Spoken Reasoning
    final m5 = varietyEngine.selectNextMechanic([ActivityMechanicType.speakToMakeSomethingHappen]);
    varietyEngine.recordActivity(m5);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step5_speak_reasoning',
      conceptId: 'concept_apple',
      learningConceptId: 'concept_apple',
      mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
      scene: scene,
      targetObjectId: apple.objectId,
      draggableObject: apple,
      speakTriggerPhrase: 'pip would you like an apple or water',
      ageProfile: ageProfile,
      instructionOverride: 'Say: Pip, would you like an apple or water? 🎙️✨',
      audioPromptOverride: 'Say: Pip, would you like an apple or water?',
      successReaction: SceneReactionType.bounce,
      successReactionPrompt: 'Thoughtful offer! Pip nods thoughtfully.',
    ));

    // 6. Conversational Role-Play
    final m6 = varietyEngine.selectNextMechanic([ActivityMechanicType.conversationRolePlay]);
    varietyEngine.recordActivity(m6);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step6_authentic_dialogue',
      conceptId: 'concept_water',
      learningConceptId: 'concept_water',
      mechanicType: ActivityMechanicType.conversationRolePlay,
      scene: scene,
      targetObjectId: water.objectId,
      rolePlayPipPrompt: 'I would love some fresh water after our long walk!',
      rolePlayExpectedResponse: 'Here is your water, Pip!',
      ageProfile: ageProfile,
      instructionOverride: 'Have a picnic conversation with Pip. 🐥',
      audioPromptOverride: 'I would love some fresh water after our long walk!',
      successReaction: SceneReactionType.sound,
      successReactionPrompt: 'Excellent conversation! Clear and courteous.',
    ));

    // 7. Exploration Action
    final m7 = varietyEngine.selectNextMechanic([ActivityMechanicType.speakToMakeSomethingHappen]);
    varietyEngine.recordActivity(m7);
    activities.add(InteractiveActivityConfig(
      id: '${lessonId}_step7_open_cabin_door',
      conceptId: 'concept_door',
      learningConceptId: 'concept_door',
      mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
      scene: scene,
      targetObjectId: door.objectId,
      draggableObject: door,
      speakTriggerPhrase: 'open the door',
      ageProfile: ageProfile,
      instructionOverride: 'We need supplies from the cabin. Say: Open the door. 🚪✨',
      audioPromptOverride: 'Say: Open the door',
      successReaction: SceneReactionType.doorOpen,
      successReactionPrompt: 'The cabin door opens smoothly.',
    ));
  }
}
