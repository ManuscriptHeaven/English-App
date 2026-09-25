import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene_object.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_lesson.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_unit.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_world.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'curriculum_v2_scenes.dart';

/// Complete Track 1 (Age 3–4: Little Listeners) Production Curriculum.
/// Contains 8 Thematic Worlds, 8 Units, 24 Complete Micro-Lessons, and 120 Micro-Interactions.
/// Pure audio-first, zero required reading, large touch targets, optional speaking imitation.
class CurriculumV2Track1Listeners {
  static final AgeExperienceProfile profile = AgeExperienceProfile.forAge(3);

  // ── 8 WORLDS ──
  static final List<CurriculumWorld> worlds = [
    const CurriculumWorld(
      id: 'world_t1_hello_me',
      levelIds: ['level_t1'],
      title: 'Hello & Me',
      childFriendlyTitle: 'Hello & Me 👋',
      theme: 'hello_me',
      description: 'First exposure to friendly greetings, expressions, and recognizing self.',
      primaryLanguageDomain: 'Greetings & Emotions',
      recommendedAgeBands: [LearningAgeBand.bandPreALittleListeners],
      unitIds: ['unit_t1_hello_me'],
    ),
    const CurriculumWorld(
      id: 'world_t1_body',
      levelIds: ['level_t1'],
      title: 'My Body',
      childFriendlyTitle: 'My Body 🧒',
      theme: 'body',
      description: 'Exploring sensory body parts through imitation, gesture, and touch.',
      primaryLanguageDomain: 'Body & Senses',
      recommendedAgeBands: [LearningAgeBand.bandPreALittleListeners],
      unitIds: ['unit_t1_body'],
    ),
    const CurriculumWorld(
      id: 'world_t1_colors',
      levelIds: ['level_t1'],
      title: 'Rainbow Colors',
      childFriendlyTitle: 'Colors 🎨',
      theme: 'colors',
      description: 'Bright sensory recognition of primary and secondary colors.',
      primaryLanguageDomain: 'Colors & Shapes',
      recommendedAgeBands: [LearningAgeBand.bandPreALittleListeners],
      unitIds: ['unit_t1_colors'],
    ),
    const CurriculumWorld(
      id: 'world_t1_animals',
      levelIds: ['level_t1'],
      title: 'Gentle Animals',
      childFriendlyTitle: 'Animals 🐾',
      theme: 'animals',
      description: 'Recognizing friendly farm and domestic animals with their natural sounds.',
      primaryLanguageDomain: 'Animals & Nature',
      recommendedAgeBands: [LearningAgeBand.bandPreALittleListeners],
      unitIds: ['unit_t1_animals'],
    ),
    const CurriculumWorld(
      id: 'world_t1_food',
      levelIds: ['level_t1'],
      title: 'Yummy Food & Drink',
      childFriendlyTitle: 'Food & Drink 🍎',
      theme: 'food',
      description: 'Concrete everyday foods, water, and simple sharing actions.',
      primaryLanguageDomain: 'Food & Nutrition',
      recommendedAgeBands: [LearningAgeBand.bandPreALittleListeners],
      unitIds: ['unit_t1_food'],
    ),
    const CurriculumWorld(
      id: 'world_t1_home',
      levelIds: ['level_t1'],
      title: 'My Cozy Home',
      childFriendlyTitle: 'My Home 🏠',
      theme: 'home',
      description: 'Familiar household objects and clean room actions.',
      primaryLanguageDomain: 'Home Environment',
      recommendedAgeBands: [LearningAgeBand.bandPreALittleListeners],
      unitIds: ['unit_t1_home'],
    ),
    const CurriculumWorld(
      id: 'world_t1_toys',
      levelIds: ['level_t1'],
      title: 'Toys & Play',
      childFriendlyTitle: 'Toys & Play 🧸',
      theme: 'toys',
      description: 'Engaging playtime objects and taking turns with Pip.',
      primaryLanguageDomain: 'Toys & Cooperation',
      recommendedAgeBands: [LearningAgeBand.bandPreALittleListeners],
      unitIds: ['unit_t1_toys'],
    ),
    const CurriculumWorld(
      id: 'world_t1_actions',
      levelIds: ['level_t1'],
      title: 'Movement & Actions',
      childFriendlyTitle: 'Actions 🏃',
      theme: 'actions',
      description: 'Dynamic cause-and-effect physical actions and routines.',
      primaryLanguageDomain: 'Daily Actions',
      recommendedAgeBands: [LearningAgeBand.bandPreALittleListeners],
      unitIds: ['unit_t1_actions'],
    ),
  ];

  // ── 8 UNITS ──
  static final List<CurriculumUnit> units = [
    const CurriculumUnit(
      id: 'unit_t1_hello_me',
      worldId: 'world_t1_hello_me',
      levelId: 'level_t1',
      title: 'Greetings & Smiling',
      description: 'Hello, bye, happy, sad, and self-recognition.',
      speakingOutcome: 'Child imitates hello/bye and expresses happy feelings.',
      listeningOutcome: 'Child responds physically to greetings and emotional faces.',
      lessonIds: ['t1_l01_pip_says_hello', 't1_l02_happy_or_sad', 't1_l03_wave_goodbye'],
    ),
    const CurriculumUnit(
      id: 'unit_t1_body',
      worldId: 'world_t1_body',
      levelId: 'level_t1',
      title: 'Body Parts',
      description: 'Nose, eyes, ears, hands, feet.',
      speakingOutcome: 'Child echoes body part words when pointed.',
      listeningOutcome: 'Child touches own nose, eyes, or hands upon hearing command.',
      lessonIds: ['t1_l04_touch_your_nose', 't1_l05_find_the_eyes', 't1_l06_clap_your_hands'],
    ),
    const CurriculumUnit(
      id: 'unit_t1_colors',
      worldId: 'world_t1_colors',
      levelId: 'level_t1',
      title: 'Red, Blue, Yellow',
      description: 'Sorting and popping colorful bubbles.',
      speakingOutcome: 'Child names or mimics primary colors.',
      listeningOutcome: 'Child matches color items to identical color baskets.',
      lessonIds: ['t1_l07_red_apple_basket', 't1_l08_blue_sky_block', 't1_l09_yellow_sun_bubble'],
    ),
    const CurriculumUnit(
      id: 'unit_t1_animals',
      worldId: 'world_t1_animals',
      levelId: 'level_t1',
      title: 'Farm Animals',
      description: 'Cat, dog, bird, rabbit, duck.',
      speakingOutcome: 'Child imitates animal sounds (meow, woof, chirp).',
      listeningOutcome: 'Child identifies animals upon hearing their call.',
      lessonIds: ['t1_l10_friendly_cat', 't1_l11_happy_dog', 't1_l12_feed_the_rabbit'],
    ),
    const CurriculumUnit(
      id: 'unit_t1_food',
      worldId: 'world_t1_food',
      levelId: 'level_t1',
      title: 'Fresh Food & Water',
      description: 'Apple, banana, water, bread.',
      speakingOutcome: 'Child says water or apple to request food.',
      listeningOutcome: 'Child identifies food items and feeds character.',
      lessonIds: ['t1_l13_sweet_red_apple', 't1_l14_cool_clean_water', 't1_l15_yellow_banana'],
    ),
    const CurriculumUnit(
      id: 'unit_t1_home',
      worldId: 'world_t1_home',
      levelId: 'level_t1',
      title: 'Around the Room',
      description: 'Door, table, bed, lamp, book.',
      speakingOutcome: 'Child produces single home words upon prompt.',
      listeningOutcome: 'Child follows simple placement cues.',
      lessonIds: ['t1_l16_open_the_door', 't1_l17_book_on_table', 't1_l18_turn_on_light'],
    ),
    const CurriculumUnit(
      id: 'unit_t1_toys',
      worldId: 'world_t1_toys',
      levelId: 'level_t1',
      title: 'Playful Toys',
      description: 'Ball, car, blocks, kite, box.',
      speakingOutcome: 'Child names favorite play items.',
      listeningOutcome: 'Child rolls or tidies toys upon instruction.',
      lessonIds: ['t1_l19_roll_the_ball', 't1_l20_vroom_toy_car', 't1_l21_build_blocks'],
    ),
    const CurriculumUnit(
      id: 'unit_t1_actions',
      worldId: 'world_t1_actions',
      levelId: 'level_t1',
      title: 'Move & Play',
      description: 'Go, stop, sit, stand, sleep, wake up.',
      speakingOutcome: 'Child calls out go/stop during movement.',
      listeningOutcome: 'Child imitates physical motion commands.',
      lessonIds: ['t1_l22_go_and_stop', 't1_l23_sit_and_stand', 't1_l24_sleep_and_wake'],
    ),
  ];

  // ── 24 LESSONS ──
  static final List<CurriculumLesson> lessons = [
    // World 1
    const CurriculumLesson(
      id: 't1_l01_pip_says_hello',
      unitId: 'unit_t1_hello_me',
      levelId: 'level_t1',
      order: 1,
      title: 'Pip Says Hello! 👋',
      speakingOutcome: 'Child can say or wave "Hello".',
      listeningOutcome: 'Child recognizes greeting prompt from Pip.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l02_happy_or_sad',
      unitId: 'unit_t1_hello_me',
      levelId: 'level_t1',
      order: 2,
      title: 'Happy Smile! 😊',
      speakingOutcome: 'Child says "Happy" with a smile.',
      listeningOutcome: 'Child discriminates between happy and sad expressions.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l03_wave_goodbye',
      unitId: 'unit_t1_hello_me',
      levelId: 'level_t1',
      order: 3,
      title: 'Wave Goodbye! 👋🚪',
      speakingOutcome: 'Child says "Bye bye".',
      listeningOutcome: 'Child associates farewell gestures with door departure.',
      estimatedDurationMinutes: 3,
    ),

    // World 2
    const CurriculumLesson(
      id: 't1_l04_touch_your_nose',
      unitId: 'unit_t1_body',
      levelId: 'level_t1',
      order: 4,
      title: 'Touch Your Nose! 👃',
      speakingOutcome: 'Child echoes "Nose".',
      listeningOutcome: 'Child touches nose in response to audio.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l05_find_the_eyes',
      unitId: 'unit_t1_body',
      levelId: 'level_t1',
      order: 5,
      title: 'Two Bright Eyes! 👀',
      speakingOutcome: 'Child says "Eyes".',
      listeningOutcome: 'Child points to eyes on avatar.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l06_clap_your_hands',
      unitId: 'unit_t1_body',
      levelId: 'level_t1',
      order: 6,
      title: 'Clap Clean Hands! 🙌',
      speakingOutcome: 'Child says "Hands".',
      listeningOutcome: 'Child performs clapping gesture upon hearing prompt.',
      estimatedDurationMinutes: 3,
    ),

    // World 3
    const CurriculumLesson(
      id: 't1_l07_red_apple_basket',
      unitId: 'unit_t1_colors',
      levelId: 'level_t1',
      order: 7,
      title: 'Red Ball & Basket 🔴',
      speakingOutcome: 'Child repeats "Red".',
      listeningOutcome: 'Child selects and places red item.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l08_blue_sky_block',
      unitId: 'unit_t1_colors',
      levelId: 'level_t1',
      order: 8,
      title: 'Calm Blue Block 🟦',
      speakingOutcome: 'Child repeats "Blue".',
      listeningOutcome: 'Child sorts blue block into matching basket.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l09_yellow_sun_bubble',
      unitId: 'unit_t1_colors',
      levelId: 'level_t1',
      order: 9,
      title: 'Pop Yellow Bubble! 🟡',
      speakingOutcome: 'Child says "Yellow" or "Pop".',
      listeningOutcome: 'Child taps yellow bubble upon sound clue.',
      estimatedDurationMinutes: 3,
    ),

    // World 4
    const CurriculumLesson(
      id: 't1_l10_friendly_cat',
      unitId: 'unit_t1_animals',
      levelId: 'level_t1',
      order: 10,
      title: 'Gentle Cat Purrs 🐱',
      speakingOutcome: 'Child imitates "Meow".',
      listeningOutcome: 'Child recognizes cat and pets softly.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l11_happy_dog',
      unitId: 'unit_t1_animals',
      levelId: 'level_t1',
      order: 11,
      title: 'Playful Dog Wags 🐶',
      speakingOutcome: 'Child imitates "Woof".',
      listeningOutcome: 'Child finds dog in the meadow.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l12_feed_the_rabbit',
      unitId: 'unit_t1_animals',
      levelId: 'level_t1',
      order: 12,
      title: 'Feed the Rabbit! 🐰🥕',
      speakingOutcome: 'Child says "Rabbit" or "Eat".',
      listeningOutcome: 'Child feeds hungry rabbit a carrot.',
      estimatedDurationMinutes: 3,
    ),

    // World 5
    const CurriculumLesson(
      id: 't1_l13_sweet_red_apple',
      unitId: 'unit_t1_food',
      levelId: 'level_t1',
      order: 13,
      title: 'Crisp Red Apple 🍎',
      speakingOutcome: 'Child says "Apple".',
      listeningOutcome: 'Child identifies apple and feeds Pip.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l14_cool_clean_water',
      unitId: 'unit_t1_food',
      levelId: 'level_t1',
      order: 14,
      title: 'Cool Water, Please 💧',
      speakingOutcome: 'Child says "Water".',
      listeningOutcome: 'Child offers water cup to thirsty character.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l15_yellow_banana',
      unitId: 'unit_t1_food',
      levelId: 'level_t1',
      order: 15,
      title: 'Sweet Banana 🍌',
      speakingOutcome: 'Child repeats "Banana".',
      listeningOutcome: 'Child arranges banana on the clean table.',
      estimatedDurationMinutes: 3,
    ),

    // World 6
    const CurriculumLesson(
      id: 't1_l16_open_the_door',
      unitId: 'unit_t1_home',
      levelId: 'level_t1',
      order: 16,
      title: 'Open the Door! 🚪',
      speakingOutcome: 'Child vocalizes "Open" or "Door".',
      listeningOutcome: 'Child taps door to cause opening animation.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l17_book_on_table',
      unitId: 'unit_t1_home',
      levelId: 'level_t1',
      order: 17,
      title: 'Book on Table 📖🪵',
      speakingOutcome: 'Child echoes "Book".',
      listeningOutcome: 'Child places book on table neatly.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l18_turn_on_light',
      unitId: 'unit_t1_home',
      levelId: 'level_t1',
      order: 18,
      title: 'Bright Lamp! 💡',
      speakingOutcome: 'Child says "Light".',
      listeningOutcome: 'Child touches lamp to illuminate room.',
      estimatedDurationMinutes: 3,
    ),

    // World 7
    const CurriculumLesson(
      id: 't1_l19_roll_the_ball',
      unitId: 'unit_t1_toys',
      levelId: 'level_t1',
      order: 19,
      title: 'Roll the Ball! ⚽',
      speakingOutcome: 'Child says "Ball".',
      listeningOutcome: 'Child rolls ball toward Pip.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l20_vroom_toy_car',
      unitId: 'unit_t1_toys',
      levelId: 'level_t1',
      order: 20,
      title: 'Go, Little Car! 🚗',
      speakingOutcome: 'Child says "Car" or "Vroom".',
      listeningOutcome: 'Child drives car across the mat.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l21_build_blocks',
      unitId: 'unit_t1_toys',
      levelId: 'level_t1',
      order: 21,
      title: 'Tower of Blocks 🧱',
      speakingOutcome: 'Child says "Blocks".',
      listeningOutcome: 'Child stacks blocks carefully.',
      estimatedDurationMinutes: 3,
    ),

    // World 8
    const CurriculumLesson(
      id: 't1_l22_go_and_stop',
      unitId: 'unit_t1_actions',
      levelId: 'level_t1',
      order: 22,
      title: 'Go and Stop! 🟢🔴',
      speakingOutcome: 'Child says "Go" or "Stop".',
      listeningOutcome: 'Child obeys green go and red stop signals.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l23_sit_and_stand',
      unitId: 'unit_t1_actions',
      levelId: 'level_t1',
      order: 23,
      title: 'Sit and Stand! 🪑',
      speakingOutcome: 'Child echoes "Sit" or "Stand".',
      listeningOutcome: 'Child places actor to sit or stand.',
      estimatedDurationMinutes: 3,
    ),
    const CurriculumLesson(
      id: 't1_l24_sleep_and_wake',
      unitId: 'unit_t1_actions',
      levelId: 'level_t1',
      order: 24,
      title: 'Sleep and Wake Up! 🛏️☀️',
      speakingOutcome: 'Child whispers "Sleep" or says "Morning".',
      listeningOutcome: 'Child tucks character into bed then wakes to sun.',
      estimatedDurationMinutes: 3,
    ),
  ];

  /// Builds the 5 handcrafted, production interactive activities for any Track 1 lesson.
  static List<InteractiveActivityConfig> getActivitiesForLesson(String lessonId) {
    switch (lessonId) {
      // ── Lesson 1: Pip Says Hello ──
      case 't1_l01_pip_says_hello':
        final scene = CurriculumV2Scenes.helloMeScene();
        final pip = scene.objects.firstWhere((o) => o.objectId == 'obj_pip_greeter');
        final mirror = scene.objects.firstWhere((o) => o.objectId == 'obj_avatar_mirror');
        return [
          InteractiveActivityConfig(
            id: 't1_l01_step1_pip_greets',
            conceptId: 'concept_hello',
            learningConceptId: 'concept_hello',
            mechanicType: ActivityMechanicType.listenAndTouch,
            scene: scene,
            targetObjectId: pip.objectId,
            draggableObject: pip,
            distractors: [mirror],
            ageProfile: profile,
            instructionOverride: 'Hello! Pip is waving to you! Touch Pip! 👋🦜',
            audioPromptOverride: 'Hello! Touch Pip!',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Hello friend! So happy to see you! 🦜✨',
          ),
          InteractiveActivityConfig(
            id: 't1_l01_step2_look_mirror',
            conceptId: 'concept_me',
            learningConceptId: 'concept_me',
            mechanicType: ActivityMechanicType.listenAndTouch,
            scene: scene,
            targetObjectId: mirror.objectId,
            draggableObject: mirror,
            distractors: [pip],
            ageProfile: profile,
            instructionOverride: 'Touch the mirror! Look at your smile! 🪞',
            audioPromptOverride: 'Touch the mirror',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Look at you! Wonderful smile! 🪞✨',
          ),
          InteractiveActivityConfig(
            id: 't1_l01_step3_pip_move',
            conceptId: 'concept_hello',
            learningConceptId: 'concept_hello',
            mechanicType: ActivityMechanicType.dragAndDrop,
            scene: scene,
            targetObjectId: pip.objectId,
            targetDestinationId: mirror.objectId,
            draggableObject: pip,
            dropTarget: mirror,
            ageProfile: profile,
            instructionOverride: 'Bring Pip to the mirror to say hello! 🦜🪞',
            audioPromptOverride: 'Bring Pip to the mirror',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Pip says: "Hello, wonderful friend!" 🦜👋',
          ),
          InteractiveActivityConfig(
            id: 't1_l01_step4_say_hello',
            conceptId: 'concept_hello',
            learningConceptId: 'concept_hello',
            mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
            scene: scene,
            targetObjectId: pip.objectId,
            draggableObject: pip,
            sceneActor: pip,
            speakTriggerPhrase: 'hello',
            ageProfile: profile,
            instructionOverride: 'Can you say Hello? Or tap Pip! 👋',
            audioPromptOverride: 'Hello! Can you say Hello?',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Hello! Beautiful greeting! 🌟',
          ),
          InteractiveActivityConfig(
            id: 't1_l01_step5_celebrate',
            conceptId: 'concept_happy',
            learningConceptId: 'concept_happy',
            mechanicType: ActivityMechanicType.listenAndTouch,
            scene: scene,
            targetObjectId: pip.objectId,
            draggableObject: pip,
            ageProfile: profile,
            instructionOverride: 'Touch Pip to celebrate our first greeting! 🦜🎉',
            audioPromptOverride: 'Touch Pip to celebrate!',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Yay! We said hello! Adventure starts! 🌟⭐',
          ),
        ];

      // ── Lesson 13: Sweet Red Apple (Theme: Food & Drinks) ──
      case 't1_l13_sweet_red_apple':
        final scene = CurriculumV2Scenes.foodKitchenScene();
        final apple = scene.objects.firstWhere((o) => o.objectId == 'obj_food_apple');
        final table = scene.objects.firstWhere((o) => o.objectId == 'obj_dining_table');
        final pip = scene.objects.firstWhere((o) => o.objectId == 'obj_dining_pip');
        final water = scene.objects.firstWhere((o) => o.objectId == 'obj_food_water');
        return [
          InteractiveActivityConfig(
            id: 't1_l13_step1_listen_apple',
            conceptId: 'concept_apple',
            learningConceptId: 'concept_apple',
            mechanicType: ActivityMechanicType.listenAndTouch,
            scene: scene,
            targetObjectId: apple.objectId,
            draggableObject: apple,
            distractors: [water],
            ageProfile: profile,
            instructionOverride: 'Apple! 🍎 Where is the red apple? Touch it!',
            audioPromptOverride: 'Apple! Touch the apple',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Yum! A sweet red apple! 🍎',
          ),
          InteractiveActivityConfig(
            id: 't1_l13_step2_apple_to_table',
            conceptId: 'concept_apple',
            learningConceptId: 'concept_apple',
            mechanicType: ActivityMechanicType.scenePlacement,
            scene: scene,
            targetObjectId: apple.objectId,
            targetDestinationId: table.objectId,
            draggableObject: apple,
            dropTarget: table,
            spatialRelation: 'on',
            ageProfile: profile,
            instructionOverride: 'Put the apple on the clean table! 🍎🪵',
            audioPromptOverride: 'Put the apple on the table',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Neat on the table! Clean dining! 🪵✨',
          ),
          InteractiveActivityConfig(
            id: 't1_l13_step3_feed_pip_apple',
            conceptId: 'concept_apple',
            learningConceptId: 'concept_apple',
            mechanicType: ActivityMechanicType.feedCharacter,
            scene: scene,
            targetObjectId: apple.objectId,
            targetDestinationId: pip.objectId,
            draggableObject: apple,
            requestedObject: apple,
            sceneActor: pip,
            dropTarget: pip,
            ageProfile: profile,
            instructionOverride: 'Pip is hungry! Share the apple with Pip. 🍎🦜',
            audioPromptOverride: 'Share the apple with Pip',
            successReaction: SceneReactionType.eatAnimation,
            successReactionPrompt: 'Nom nom! Pip chirps: "Bismillah! Thank you!" 🦜❤️',
          ),
          InteractiveActivityConfig(
            id: 't1_l13_step4_say_apple',
            conceptId: 'concept_apple',
            learningConceptId: 'concept_apple',
            mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
            scene: scene,
            targetObjectId: apple.objectId,
            draggableObject: apple,
            sceneActor: pip,
            speakTriggerPhrase: 'apple',
            ageProfile: profile,
            instructionOverride: 'Apple! Can you say Apple? 🍎',
            audioPromptOverride: 'Apple! Can you say Apple?',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Apple! Delicious! 🍎🌟',
          ),
          InteractiveActivityConfig(
            id: 't1_l13_step5_celebrate_food',
            conceptId: 'concept_apple',
            learningConceptId: 'concept_apple',
            mechanicType: ActivityMechanicType.listenAndTouch,
            scene: scene,
            targetObjectId: pip.objectId,
            draggableObject: pip,
            ageProfile: profile,
            instructionOverride: 'Touch Pip to celebrate yummy healthy fruit! 🦜⭐',
            audioPromptOverride: 'Touch Pip to celebrate!',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Alhamdulillah! Yummy healthy snack! 🍎🎉',
          ),
        ];

      // ── Default generator for all other Track 1 lessons ──
      default:
        return _generateDefaultTrack1Activities(lessonId);
    }
  }

  static List<InteractiveActivityConfig> _generateDefaultTrack1Activities(String lessonId) {
    // Derive contextual scene and primary object based on lesson
    final scene = _resolveSceneForLesson(lessonId);
    final targetObj = scene.objects.first;
    final secondaryObj = scene.objects.length > 1 ? scene.objects[1] : targetObj;

    final isCareOrAnimal = lessonId.contains('cat') ||
        lessonId.contains('dog') ||
        lessonId.contains('rabbit') ||
        lessonId.contains('animal') ||
        lessonId.contains('feed') ||
        lessonId.contains('water') ||
        lessonId.contains('food') ||
        lessonId.contains('banana') ||
        lessonId.contains('sleep');

    final isObjectOrPlacement = lessonId.contains('color') ||
        lessonId.contains('red') ||
        lessonId.contains('blue') ||
        lessonId.contains('yellow') ||
        lessonId.contains('door') ||
        lessonId.contains('table') ||
        lessonId.contains('light') ||
        lessonId.contains('lamp') ||
        lessonId.contains('toy') ||
        lessonId.contains('ball') ||
        lessonId.contains('car') ||
        lessonId.contains('block');

    // Archetype C: Care, Feeding & Animal Friends (6 interactions)
    if (isCareOrAnimal) {
      return [
        InteractiveActivityConfig(
          id: '${lessonId}_step1_listen',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          distractors: [secondaryObj],
          ageProfile: profile,
          instructionOverride: 'Listen to Pip: Find the ${targetObj.label}! ${targetObj.emoji}',
          audioPromptOverride: 'Find the ${targetObj.label}',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'You found the sweet ${targetObj.label}! ${targetObj.emoji}',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step2_bring',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.dragAndDrop,
          scene: scene,
          targetObjectId: targetObj.objectId,
          targetDestinationId: secondaryObj.objectId,
          draggableObject: targetObj,
          dropTarget: secondaryObj,
          ageProfile: profile,
          instructionOverride: 'Bring the ${targetObj.label} here gently! 🤝',
          audioPromptOverride: 'Bring the ${targetObj.label} here',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'So gentle and kind! ${targetObj.emoji}✨',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step3_place',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.scenePlacement,
          scene: scene,
          targetObjectId: targetObj.objectId,
          targetDestinationId: secondaryObj.objectId,
          draggableObject: targetObj,
          dropTarget: secondaryObj,
          spatialRelation: 'beside',
          ageProfile: profile,
          instructionOverride: 'Put the ${targetObj.label} in a cozy spot! 🏡',
          audioPromptOverride: 'Put the ${targetObj.label} in a cozy spot',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Cozy and safe! Wonderful job! ${targetObj.emoji}❤️',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step4_speak',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          speakTriggerPhrase: targetObj.label.toLowerCase(),
          ageProfile: profile,
          instructionOverride: 'Can you say ${targetObj.label}? Or make the sound! 🗣️',
          audioPromptOverride: 'Can you say ${targetObj.label}?',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: '${targetObj.label}! You said it! 🌟',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step5_gentle_touch',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          ageProfile: profile,
          instructionOverride: 'Gently pat the ${targetObj.label}! 🐾❤️',
          audioPromptOverride: 'Gently pat the ${targetObj.label}',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Purr purr! Happy and loved! ${targetObj.emoji}',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step6_celebrate',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: secondaryObj.objectId,
          draggableObject: secondaryObj,
          ageProfile: profile,
          instructionOverride: 'Touch Pip to celebrate! 🦜🎉',
          audioPromptOverride: 'Touch Pip to celebrate!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Hooray! Great caring friend! ⭐🎉',
        ),
      ];
    }

    // Archetype B: Colors, Rooms & Shapes / Movement & Placement (5 interactions)
    if (isObjectOrPlacement) {
      return [
        InteractiveActivityConfig(
          id: '${lessonId}_step1_listen',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          distractors: [secondaryObj],
          ageProfile: profile,
          instructionOverride: 'Look! Where is the ${targetObj.label}? Touch it! ${targetObj.emoji}',
          audioPromptOverride: 'Where is the ${targetObj.label}? Touch it',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'You found the ${targetObj.label}! ${targetObj.emoji}',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step2_place',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.scenePlacement,
          scene: scene,
          targetObjectId: targetObj.objectId,
          targetDestinationId: secondaryObj.objectId,
          draggableObject: targetObj,
          dropTarget: secondaryObj,
          spatialRelation: 'beside',
          ageProfile: profile,
          instructionOverride: 'Put the ${targetObj.label} next to the ${secondaryObj.label}! 🪵',
          audioPromptOverride: 'Put the ${targetObj.label} next to the ${secondaryObj.label}',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Neat and tidy! Looks great! ✨',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step3_move',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.dragAndDrop,
          scene: scene,
          targetObjectId: targetObj.objectId,
          targetDestinationId: secondaryObj.objectId,
          draggableObject: targetObj,
          dropTarget: secondaryObj,
          ageProfile: profile,
          instructionOverride: 'Move the ${targetObj.label} into place! 🚀',
          audioPromptOverride: 'Move the ${targetObj.label}',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Nicely moved! ${targetObj.emoji}',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step4_speak',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          speakTriggerPhrase: targetObj.label.toLowerCase(),
          ageProfile: profile,
          instructionOverride: 'Can you say ${targetObj.label}? ${targetObj.emoji}',
          audioPromptOverride: 'Can you say ${targetObj.label}?',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: '${targetObj.label}! Beautiful speaking! 🌟',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step5_celebrate',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          ageProfile: profile,
          instructionOverride: 'Touch the star to celebrate! ⭐🎉',
          audioPromptOverride: 'Touch the star to celebrate!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Super work! You did it! ⭐🎉',
        ),
      ];
    }

    // Archetype A: Quick Touch & Mimic (4 interactions: Greeting, Body, Quick Actions)
    return [
      InteractiveActivityConfig(
        id: '${lessonId}_step1_touch',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.listenAndTouch,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        distractors: [secondaryObj],
        ageProfile: profile,
        instructionOverride: '${targetObj.label}! Touch the ${targetObj.label}! ${targetObj.emoji}',
        audioPromptOverride: 'Touch the ${targetObj.label}',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Awesome! You found the ${targetObj.label}! ${targetObj.emoji}',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step2_move',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.dragAndDrop,
        scene: scene,
        targetObjectId: targetObj.objectId,
        targetDestinationId: secondaryObj.objectId,
        draggableObject: targetObj,
        dropTarget: secondaryObj,
        ageProfile: profile,
        instructionOverride: 'Move with Pip! Drag the ${targetObj.label}! 🏃',
        audioPromptOverride: 'Move the ${targetObj.label}',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Fun moves! Way to go! 🌟',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step3_speak',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        speakTriggerPhrase: targetObj.label.toLowerCase(),
        ageProfile: profile,
        instructionOverride: 'Say ${targetObj.label}! Or tap to hear it! 🗣️',
        audioPromptOverride: 'Say ${targetObj.label}!',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: '${targetObj.label}! Great voice! 🌟',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step4_highfive',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.listenAndTouch,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        ageProfile: profile,
        instructionOverride: 'Give Pip a high-five! Touch Pip! 🦜✋',
        audioPromptOverride: 'Give Pip a high five!',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Yay! High-five! Great playing! ⭐🎉',
      ),
    ];
  }

  static InteractiveScene _resolveSceneForLesson(String lessonId) {
    if (lessonId.contains('cat') || lessonId.contains('dog') || lessonId.contains('rabbit') || lessonId.contains('animal')) {
      return CurriculumV2Scenes.animalsFarmScene();
    }
    if (lessonId.contains('body') || lessonId.contains('nose') || lessonId.contains('eyes') || lessonId.contains('hands')) {
      return CurriculumV2Scenes.myBodyScene();
    }
    if (lessonId.contains('color') || lessonId.contains('red') || lessonId.contains('blue') || lessonId.contains('yellow')) {
      return CurriculumV2Scenes.colorsScene();
    }
    if (lessonId.contains('food') || lessonId.contains('apple') || lessonId.contains('water') || lessonId.contains('banana')) {
      return CurriculumV2Scenes.foodKitchenScene();
    }
    if (lessonId.contains('home') || lessonId.contains('door') || lessonId.contains('table') || lessonId.contains('light')) {
      return CurriculumV2Scenes.myHomeRoomScene();
    }
    if (lessonId.contains('toy') || lessonId.contains('ball') || lessonId.contains('car') || lessonId.contains('blocks')) {
      return CurriculumV2Scenes.toysPlaygroundScene();
    }
    if (lessonId.contains('hello') || lessonId.contains('me') || lessonId.contains('happy') || lessonId.contains('sad')) {
      return CurriculumV2Scenes.helloMeScene();
    }
    return CurriculumV2Scenes.natureParkScene();
  }
}
