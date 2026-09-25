import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene_object.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_lesson.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_unit.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_world.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'curriculum_v2_scenes.dart';

/// Complete Track 2 (Age 5–6: Little Speakers) Production Curriculum.
/// Contains 10 Thematic Worlds, 10 Units, 30 Complete Lessons, and 150 Interactions.
/// Vocabulary -> 2–3 word phrases -> first functional sentences ("I like...", "Can I have...?", "Help me, please").
class CurriculumV2Track2Speakers {
  static final AgeExperienceProfile profile = AgeExperienceProfile.forAge(5);

  // ── 10 WORLDS ──
  static final List<CurriculumWorld> worlds = [
    const CurriculumWorld(
      id: 'world_t2_me',
      levelIds: ['level_t2'],
      title: 'Me & My Feelings',
      childFriendlyTitle: 'Me & Feelings 😊',
      theme: 'me',
      description: 'First functional sentences describing self, name, and emotions.',
      primaryLanguageDomain: 'Personal Identity & Feelings',
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers],
      unitIds: ['unit_t2_me'],
    ),
    const CurriculumWorld(
      id: 'world_t2_family',
      levelIds: ['level_t2'],
      title: 'My Loving Family',
      childFriendlyTitle: 'My Family 👨‍👩‍👧',
      theme: 'family',
      description: 'Identifying family members and expressing love and respect.',
      primaryLanguageDomain: 'Family & Relationships',
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers],
      unitIds: ['unit_t2_family'],
    ),
    const CurriculumWorld(
      id: 'world_t2_food',
      levelIds: ['level_t2'],
      title: 'Food & Dining Manners',
      childFriendlyTitle: 'Food & Manners 🍎',
      theme: 'food',
      description: 'Making polite food requests, expressing hunger, and dining etiquette.',
      primaryLanguageDomain: 'Dining & Requests',
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers],
      unitIds: ['unit_t2_food'],
    ),
    const CurriculumWorld(
      id: 'world_t2_home',
      levelIds: ['level_t2'],
      title: 'Around My House',
      childFriendlyTitle: 'My House 🏡',
      theme: 'home',
      description: 'Prepositions of place and asking "Where is...?" around the home.',
      primaryLanguageDomain: 'Home & Prepositions',
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers],
      unitIds: ['unit_t2_home'],
    ),
    const CurriculumWorld(
      id: 'world_t2_animals',
      levelIds: ['level_t2'],
      title: 'Animals & Nature Care',
      childFriendlyTitle: 'Animals & Care 🐾',
      theme: 'animals',
      description: 'Describing animals with adjectives and practicing kind care.',
      primaryLanguageDomain: 'Animals & Adjectives',
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers],
      unitIds: ['unit_t2_animals'],
    ),
    const CurriculumWorld(
      id: 'world_t2_school',
      levelIds: ['level_t2'],
      title: 'School & Classroom',
      childFriendlyTitle: 'My School 🏫',
      theme: 'school',
      description: 'Classroom items, asking for help, and saying "Thank you".',
      primaryLanguageDomain: 'Classroom & Polite Words',
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers],
      unitIds: ['unit_t2_school'],
    ),
    const CurriculumWorld(
      id: 'world_t2_clothes',
      levelIds: ['level_t2'],
      title: 'Clothes & Colors',
      childFriendlyTitle: 'My Clothes 👕',
      theme: 'clothes',
      description: 'Naming garments, colors, and getting dressed independently.',
      primaryLanguageDomain: 'Dressing & Colors',
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers],
      unitIds: ['unit_t2_clothes'],
    ),
    const CurriculumWorld(
      id: 'world_t2_weather',
      levelIds: ['level_t2'],
      title: 'Weather & Seasons',
      childFriendlyTitle: 'Weather 🌤️',
      theme: 'weather',
      description: 'Observing sunny, rainy, and windy skies with gratitude.',
      primaryLanguageDomain: 'Weather & Environment',
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers],
      unitIds: ['unit_t2_weather'],
    ),
    const CurriculumWorld(
      id: 'world_t2_actions',
      levelIds: ['level_t2'],
      title: 'Healthy Daily Habits',
      childFriendlyTitle: 'Daily Habits 🧼',
      theme: 'habits',
      description: 'Washing hands, brushing teeth, and clean routines.',
      primaryLanguageDomain: 'Hygiene & Daily Actions',
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers],
      unitIds: ['unit_t2_actions'],
    ),
    const CurriculumWorld(
      id: 'world_t2_numbers',
      levelIds: ['level_t2'],
      title: 'Numbers & Sharing',
      childFriendlyTitle: 'Numbers 1–10 🔢',
      theme: 'numbers',
      description: 'Counting toys and objects, and sharing with friends.',
      primaryLanguageDomain: 'Counting & Sharing',
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers],
      unitIds: ['unit_t2_numbers'],
    ),
  ];

  // ── 10 UNITS ──
  static final List<CurriculumUnit> units = [
    const CurriculumUnit(
      id: 'unit_t2_me',
      worldId: 'world_t2_me',
      levelId: 'level_t2',
      title: 'Expressing Myself',
      description: 'I am happy, I am sad, What is this?',
      speakingOutcome: 'Child speaks short phrases: "I am happy", "This is me".',
      listeningOutcome: 'Child identifies emotions and responds to "Who is this?".',
      lessonIds: ['t2_l01_i_am_happy', 't2_l02_my_name_is', 't2_l03_who_is_this'],
    ),
    const CurriculumUnit(
      id: 'unit_t2_family',
      worldId: 'world_t2_family',
      levelId: 'level_t2',
      title: 'My Family Members',
      description: 'This is my mother, This is my father, I love my family.',
      speakingOutcome: 'Child introduces family members using "This is my...".',
      listeningOutcome: 'Child points to family portraits upon audio cue.',
      lessonIds: ['t2_l04_this_is_my_mother', 't2_l05_this_is_my_father', 't2_l06_i_love_my_family'],
    ),
    const CurriculumUnit(
      id: 'unit_t2_food',
      worldId: 'world_t2_food',
      levelId: 'level_t2',
      title: 'Food Requests & Likes',
      description: 'I like apples, Can I have water?, I am hungry.',
      speakingOutcome: 'Child asks politely: "Can I have... please?" and states "I like...".',
      listeningOutcome: 'Child understands food offers and answers with manners.',
      lessonIds: ['t2_l07_i_like_apples', 't2_l08_water_please', 't2_l09_i_am_hungry'],
    ),
    const CurriculumUnit(
      id: 'unit_t2_home',
      worldId: 'world_t2_home',
      levelId: 'level_t2',
      title: 'Where Is It?',
      description: 'In, on, under prepositions and finding lost toys.',
      speakingOutcome: 'Child says location phrases: "On the table", "Under the bed".',
      listeningOutcome: 'Child locates items according to spatial directions.',
      lessonIds: ['t2_l10_where_is_my_ball', 't2_l11_on_the_table', 't2_l12_under_the_bed'],
    ),
    const CurriculumUnit(
      id: 'unit_t2_animals',
      worldId: 'world_t2_animals',
      levelId: 'level_t2',
      title: 'Describing Animals',
      description: 'Big dog, small cat, gentle rabbit.',
      speakingOutcome: 'Child uses adjective + noun: "Big dog", "Gentle cat".',
      listeningOutcome: 'Child selects animal matching descriptive audio.',
      lessonIds: ['t2_l13_i_see_a_cat', 't2_l14_the_big_dog', 't2_l15_gentle_rabbit'],
    ),
    const CurriculumUnit(
      id: 'unit_t2_school',
      worldId: 'world_t2_school',
      levelId: 'level_t2',
      title: 'Classroom Polite Words',
      description: 'Help me please, Here you are, Thank you.',
      speakingOutcome: 'Child exchanges polite classroom phrases with Pip.',
      listeningOutcome: 'Child identifies classroom tools and responds to requests.',
      lessonIds: ['t2_l16_this_is_my_pencil', 't2_l17_help_me_please', 't2_l18_here_you_are_thank_you'],
    ),
    const CurriculumUnit(
      id: 'unit_t2_clothes',
      worldId: 'world_t2_clothes',
      levelId: 'level_t2',
      title: 'Getting Dressed',
      description: 'Red coat, blue shoes, yellow hat.',
      speakingOutcome: 'Child states: "I have a blue shirt", "Put on shoes".',
      listeningOutcome: 'Child dresses avatar according to spoken instructions.',
      lessonIds: ['t2_l19_my_red_coat', 't2_l20_blue_shoes', 't2_l21_put_on_your_hat'],
    ),
    const CurriculumUnit(
      id: 'unit_t2_weather',
      worldId: 'world_t2_weather',
      levelId: 'level_t2',
      title: 'How Is the Weather?',
      description: 'It is sunny, It is rainy, I see clouds.',
      speakingOutcome: 'Child says: "It is sunny today", "It is rainy".',
      listeningOutcome: 'Child matches outdoor clothing to current weather.',
      lessonIds: ['t2_l22_it_is_sunny_today', 't2_l23_i_see_the_rain', 't2_l24_the_cool_wind'],
    ),
    const CurriculumUnit(
      id: 'unit_t2_actions',
      worldId: 'world_t2_actions',
      levelId: 'level_t2',
      title: 'Cleanliness & Routines',
      description: 'I wash my hands, I brush my teeth, Clean and tidy.',
      speakingOutcome: 'Child describes habit: "I wash my hands with soap".',
      listeningOutcome: 'Child sequences personal hygiene routines.',
      lessonIds: ['t2_l25_i_wash_my_hands', 't2_l26_i_brush_my_teeth', 't2_l27_clean_and_tidy'],
    ),
    const CurriculumUnit(
      id: 'unit_t2_numbers',
      worldId: 'world_t2_numbers',
      levelId: 'level_t2',
      title: 'Counting & Taking Turns',
      description: 'One, two, three cars; Let us share.',
      speakingOutcome: 'Child counts aloud up to ten items.',
      listeningOutcome: 'Child gives requested number of toys to Pip.',
      lessonIds: ['t2_l28_count_three_cars', 't2_l29_five_shiny_stars', 't2_l30_let_us_share_toys'],
    ),
  ];

  // ── 30 LESSONS ──
  static final List<CurriculumLesson> lessons = [
    // World 1
    const CurriculumLesson(
      id: 't2_l01_i_am_happy',
      unitId: 'unit_t2_me',
      levelId: 'level_t2',
      order: 1,
      title: 'I am Happy! 😊',
      speakingOutcome: 'Child says: "I am happy today!"',
      listeningOutcome: 'Child identifies happy character.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l02_my_name_is',
      unitId: 'unit_t2_me',
      levelId: 'level_t2',
      order: 2,
      title: 'My Name Is... 🪞',
      speakingOutcome: 'Child states own name: "My name is Ali."',
      listeningOutcome: 'Child recognizes self-introduction prompt.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l03_who_is_this',
      unitId: 'unit_t2_me',
      levelId: 'level_t2',
      order: 3,
      title: 'Who Is This? 🦜',
      speakingOutcome: 'Child answers: "This is Pip!"',
      listeningOutcome: 'Child identifies friendly characters upon question.',
      estimatedDurationMinutes: 5,
    ),

    // World 2
    const CurriculumLesson(
      id: 't2_l04_this_is_my_mother',
      unitId: 'unit_t2_family',
      levelId: 'level_t2',
      order: 4,
      title: 'This Is My Mother 👩',
      speakingOutcome: 'Child says: "This is my mother."',
      listeningOutcome: 'Child selects mother icon in family photo.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l05_this_is_my_father',
      unitId: 'unit_t2_family',
      levelId: 'level_t2',
      order: 5,
      title: 'This Is My Father 👨',
      speakingOutcome: 'Child says: "This is my father."',
      listeningOutcome: 'Child selects father icon in family photo.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l06_i_love_my_family',
      unitId: 'unit_t2_family',
      levelId: 'level_t2',
      order: 6,
      title: 'I Love My Family ❤️',
      speakingOutcome: 'Child expresses: "I love my family."',
      listeningOutcome: 'Child gathers family members together at home.',
      estimatedDurationMinutes: 5,
    ),

    // World 3
    const CurriculumLesson(
      id: 't2_l07_i_like_apples',
      unitId: 'unit_t2_food',
      levelId: 'level_t2',
      order: 7,
      title: 'I Like Apples! 🍎',
      speakingOutcome: 'Child says: "I like red apples."',
      listeningOutcome: 'Child identifies fruit preferences.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l08_water_please',
      unitId: 'unit_t2_food',
      levelId: 'level_t2',
      order: 8,
      title: 'Water, Please! 💧',
      speakingOutcome: 'Child says polite request: "Can I have water, please?"',
      listeningOutcome: 'Child responds to dining question: "Are you thirsty?"',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l09_i_am_hungry',
      unitId: 'unit_t2_food',
      levelId: 'level_t2',
      order: 9,
      title: 'I Am Hungry! 🍞',
      speakingOutcome: 'Child says: "I am hungry, I want bread."',
      listeningOutcome: 'Child offers food to hungry character.',
      estimatedDurationMinutes: 5,
    ),

    // World 4
    const CurriculumLesson(
      id: 't2_l10_where_is_my_ball',
      unitId: 'unit_t2_home',
      levelId: 'level_t2',
      order: 10,
      title: 'Where Is My Ball? ⚽🔍',
      speakingOutcome: 'Child asks: "Where is the ball?"',
      listeningOutcome: 'Child searches and points to ball in room.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l11_on_the_table',
      unitId: 'unit_t2_home',
      levelId: 'level_t2',
      order: 11,
      title: 'It Is on the Table 🪵',
      speakingOutcome: 'Child says: "It is on the table."',
      listeningOutcome: 'Child places book on the table.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l12_under_the_bed',
      unitId: 'unit_t2_home',
      levelId: 'level_t2',
      order: 12,
      title: 'Under the Bed 🛏️',
      speakingOutcome: 'Child says: "The toy is under the bed."',
      listeningOutcome: 'Child finds item hidden underneath furniture.',
      estimatedDurationMinutes: 5,
    ),

    // World 5
    const CurriculumLesson(
      id: 't2_l13_i_see_a_cat',
      unitId: 'unit_t2_animals',
      levelId: 'level_t2',
      order: 13,
      title: 'I See a Cat! 🐱',
      speakingOutcome: 'Child says: "I see a gentle cat."',
      listeningOutcome: 'Child identifies cat in garden scene.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l14_the_big_dog',
      unitId: 'unit_t2_animals',
      levelId: 'level_t2',
      order: 14,
      title: 'The Big Friendly Dog 🐶',
      speakingOutcome: 'Child says: "This is a big dog."',
      listeningOutcome: 'Child distinguishes big dog from small puppy.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l15_gentle_rabbit',
      unitId: 'unit_t2_animals',
      levelId: 'level_t2',
      order: 15,
      title: 'Caring for Rabbit 🐰🥕',
      speakingOutcome: 'Child says: "Eat the carrot, rabbit."',
      listeningOutcome: 'Child brings food to rabbit gently.',
      estimatedDurationMinutes: 5,
    ),

    // World 6
    const CurriculumLesson(
      id: 't2_l16_this_is_my_pencil',
      unitId: 'unit_t2_school',
      levelId: 'level_t2',
      order: 16,
      title: 'This Is My Pencil ✏️',
      speakingOutcome: 'Child says: "This is my yellow pencil."',
      listeningOutcome: 'Child puts pencil on desk.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l17_help_me_please',
      unitId: 'unit_t2_school',
      levelId: 'level_t2',
      order: 17,
      title: 'Help Me, Please! 🤝',
      speakingOutcome: 'Child asks: "Help me, please Pip."',
      listeningOutcome: 'Child responds to Pip asking for help.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l18_here_you_are_thank_you',
      unitId: 'unit_t2_school',
      levelId: 'level_t2',
      order: 18,
      title: 'Here You Are! Thank You! ✨',
      speakingOutcome: 'Child says: "Here you are!" and "Thank you!"',
      listeningOutcome: 'Child completes polite item exchange.',
      estimatedDurationMinutes: 5,
    ),

    // World 7
    const CurriculumLesson(
      id: 't2_l19_my_red_coat',
      unitId: 'unit_t2_clothes',
      levelId: 'level_t2',
      order: 19,
      title: 'My Warm Red Coat 🧥',
      speakingOutcome: 'Child says: "I wear my red coat."',
      listeningOutcome: 'Child selects coat when getting ready.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l20_blue_shoes',
      unitId: 'unit_t2_clothes',
      levelId: 'level_t2',
      order: 20,
      title: 'Tying Blue Shoes 👟',
      speakingOutcome: 'Child says: "These are my blue shoes."',
      listeningOutcome: 'Child places shoes near door.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l21_put_on_your_hat',
      unitId: 'unit_t2_clothes',
      levelId: 'level_t2',
      order: 21,
      title: 'Put on Your Hat! 🧢',
      speakingOutcome: 'Child says: "I have a sun hat."',
      listeningOutcome: 'Child places hat on avatar.',
      estimatedDurationMinutes: 5,
    ),

    // World 8
    const CurriculumLesson(
      id: 't2_l22_it_is_sunny_today',
      unitId: 'unit_t2_weather',
      levelId: 'level_t2',
      order: 22,
      title: 'It Is Sunny Today ☀️',
      speakingOutcome: 'Child says: "It is sunny today!"',
      listeningOutcome: 'Child observes sunny sky.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l23_i_see_the_rain',
      unitId: 'unit_t2_weather',
      levelId: 'level_t2',
      order: 23,
      title: 'I See the Rain 🌧️',
      speakingOutcome: 'Child says: "I see the rain falling."',
      listeningOutcome: 'Child hears raindrop sounds.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l24_the_cool_wind',
      unitId: 'unit_t2_weather',
      levelId: 'level_t2',
      order: 24,
      title: 'The Gentle Wind 🍃',
      speakingOutcome: 'Child says: "The wind is blowing."',
      listeningOutcome: 'Child flies kite in gentle wind.',
      estimatedDurationMinutes: 5,
    ),

    // World 9
    const CurriculumLesson(
      id: 't2_l25_i_wash_my_hands',
      unitId: 'unit_t2_actions',
      levelId: 'level_t2',
      order: 25,
      title: 'I Wash My Hands 🧼',
      speakingOutcome: 'Child says: "I wash my hands clean."',
      listeningOutcome: 'Child uses soap and water before eating.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l26_i_brush_my_teeth',
      unitId: 'unit_t2_actions',
      levelId: 'level_t2',
      order: 26,
      title: 'I Brush My Teeth 🪥',
      speakingOutcome: 'Child says: "I brush my teeth every morning."',
      listeningOutcome: 'Child mimics tooth brushing rhythm.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l27_clean_and_tidy',
      unitId: 'unit_t2_actions',
      levelId: 'level_t2',
      order: 27,
      title: 'Clean Room, Happy Heart 🧹',
      speakingOutcome: 'Child says: "I keep my room tidy."',
      listeningOutcome: 'Child places toys into toy box.',
      estimatedDurationMinutes: 5,
    ),

    // World 10
    const CurriculumLesson(
      id: 't2_l28_count_three_cars',
      unitId: 'unit_t2_numbers',
      levelId: 'level_t2',
      order: 28,
      title: 'Count Three Cars 🚗🔢',
      speakingOutcome: 'Child counts: "One, two, three cars!"',
      listeningOutcome: 'Child taps three cars in order.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l29_five_shiny_stars',
      unitId: 'unit_t2_numbers',
      levelId: 'level_t2',
      order: 29,
      title: 'Five Shiny Stars ⭐🔢',
      speakingOutcome: 'Child counts: "Four, five stars!"',
      listeningOutcome: 'Child collects five stars.',
      estimatedDurationMinutes: 5,
    ),
    const CurriculumLesson(
      id: 't2_l30_let_us_share_toys',
      unitId: 'unit_t2_numbers',
      levelId: 'level_t2',
      order: 30,
      title: 'Let Us Share Toys 🤝🧸',
      speakingOutcome: 'Child says: "Let us share! Take turns!"',
      listeningOutcome: 'Child passes toy to Pip and smiles.',
      estimatedDurationMinutes: 5,
    ),
  ];

  /// Builds the 5 handcrafted, production interactive activities for any Track 2 lesson.
  static List<InteractiveActivityConfig> getActivitiesForLesson(String lessonId) {
    switch (lessonId) {
      // ── Lesson 8: Water, Please! (Theme: Food & Drinks) ──
      case 't2_l08_water_please':
        final scene = CurriculumV2Scenes.foodKitchenScene();
        final water = scene.objects.firstWhere((o) => o.objectId == 'obj_food_water');
        final pip = scene.objects.firstWhere((o) => o.objectId == 'obj_dining_pip');
        final table = scene.objects.firstWhere((o) => o.objectId == 'obj_dining_table');
        return [
          InteractiveActivityConfig(
            id: 't2_l08_step1_listen_water',
            conceptId: 'concept_water',
            learningConceptId: 'concept_water',
            mechanicType: ActivityMechanicType.listenAndTouch,
            scene: scene,
            targetObjectId: water.objectId,
            draggableObject: water,
            distractors: [table],
            ageProfile: profile,
            instructionOverride: 'Pip is thirsty! Listen and find the fresh water. 💧',
            audioPromptOverride: 'Pip is thirsty! Find the fresh water.',
            successReaction: SceneReactionType.waterRipple,
            successReactionPrompt: 'Cool, clean water! Alhamdulillah! 💧✨',
          ),
          InteractiveActivityConfig(
            id: 't2_l08_step2_give_water',
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
            ageProfile: profile,
            instructionOverride: 'Give the glass of water to Pip. Say Bismillah! 💧🦜',
            audioPromptOverride: 'Give the water to Pip',
            successReaction: SceneReactionType.sound,
            successReactionPrompt: 'Pip drinks gently: "Thank you, friend!" 🦜❤️',
          ),
          InteractiveActivityConfig(
            id: 't2_l08_step3_speak_water_please',
            conceptId: 'concept_p2_drink_water',
            learningConceptId: 'concept_p2_drink_water',
            mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
            scene: scene,
            targetObjectId: water.objectId,
            draggableObject: water,
            sceneActor: pip,
            speakTriggerPhrase: 'water please',
            ageProfile: profile,
            instructionOverride: 'When you are thirsty, say: "Water, please!" 💧',
            audioPromptOverride: 'Can you say: Water, please?',
            successReaction: SceneReactionType.waterRipple,
            successReactionPrompt: '"Water, please!" Wonderful polite words! 🌟',
          ),
          InteractiveActivityConfig(
            id: 't2_l08_step4_roleplay_dining',
            conceptId: 'concept_p2_thank_you',
            learningConceptId: 'concept_p2_thank_you',
            mechanicType: ActivityMechanicType.conversationRolePlay,
            scene: scene,
            targetObjectId: pip.objectId,
            draggableObject: pip,
            rolePlayPipPrompt: 'Here is your water, friend! 🦜💧',
            rolePlayExpectedResponse: 'thank you',
            ageProfile: profile,
            instructionOverride: 'Pip says: "Here you are!" What do you say? "Thank you!" ✨',
            audioPromptOverride: 'Here you are! What do you say?',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: '"Thank you!" Beautiful manners! JazakAllahu khayran! ❤️',
          ),
          InteractiveActivityConfig(
            id: 't2_l08_step5_table_placement',
            conceptId: 'concept_table',
            learningConceptId: 'concept_table',
            mechanicType: ActivityMechanicType.scenePlacement,
            scene: scene,
            targetObjectId: water.objectId,
            targetDestinationId: table.objectId,
            draggableObject: water,
            dropTarget: table,
            spatialRelation: 'on',
            ageProfile: profile,
            instructionOverride: 'Place the cup gently on the table. Tidy dining! 🪵💧',
            audioPromptOverride: 'Put the cup on the table',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Neat and polite! Fantastic manners today! ⭐🎉',
          ),
        ];

      default:
        return _generateDefaultTrack2Activities(lessonId);
    }
  }

  static List<InteractiveActivityConfig> _generateDefaultTrack2Activities(String lessonId) {
    final scene = _resolveSceneForLesson(lessonId);
    final targetObj = scene.objects.first;
    final secondaryObj = scene.objects.length > 1 ? scene.objects[1] : targetObj;
    final pip = scene.objects.firstWhere(
      (o) => o.objectId.toLowerCase().contains('pip') || o.label.toLowerCase().contains('pip'),
      orElse: () => secondaryObj,
    );

    final isDiscovery = lessonId.contains('find') ||
        lessonId.contains('look') ||
        lessonId.contains('color') ||
        lessonId.contains('ball') ||
        lessonId.contains('animal') ||
        lessonId.contains('room') ||
        lessonId.contains('toy') ||
        lessonId.contains('pet');

    final isSocialOrManners = lessonId.contains('share') ||
        lessonId.contains('please') ||
        lessonId.contains('thank') ||
        lessonId.contains('tidy') ||
        lessonId.contains('help') ||
        lessonId.contains('water') ||
        lessonId.contains('eat') ||
        lessonId.contains('food') ||
        lessonId.contains('kind');

    // Archetype B: Sharing, Manners & Routines (6 interactions)
    if (isSocialOrManners) {
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
          instructionOverride: 'Listen to Pip: Find the ${targetObj.label}. ${targetObj.emoji}',
          audioPromptOverride: 'Find the ${targetObj.label}.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'You found the ${targetObj.label}! ${targetObj.emoji}',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step2_share',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.dragAndDrop,
          scene: scene,
          targetObjectId: targetObj.objectId,
          targetDestinationId: secondaryObj.objectId,
          draggableObject: targetObj,
          dropTarget: secondaryObj,
          ageProfile: profile,
          instructionOverride: 'Share with a friend: Move the ${targetObj.label} to ${secondaryObj.label}. 🤝',
          audioPromptOverride: 'Move the ${targetObj.label} to ${secondaryObj.label}',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Sharing brings joy to everyone! ✨',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step3_speak_manners',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          speakTriggerPhrase: 'please and thank you',
          ageProfile: profile,
          instructionOverride: 'Say the polite words: "Please and thank you!" 🗣️',
          audioPromptOverride: 'Say: Please and thank you!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: '"Please and thank you!" Beautiful polite words! 🌟',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step4_dialogue',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.conversationRolePlay,
          scene: scene,
          targetObjectId: secondaryObj.objectId,
          draggableObject: secondaryObj,
          rolePlayPipPrompt: 'Pip says: "Here you are, friend!" What do you say? 🦜',
          rolePlayExpectedResponse: 'thank you pip',
          ageProfile: profile,
          instructionOverride: 'Pip says here you are. Answer: "Thank you, Pip!" 💬',
          audioPromptOverride: 'Answer: Thank you, Pip!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: '"Thank you, Pip!" Wonderful manners! ❤️',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step5_tidy_place',
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
          instructionOverride: 'Place the ${targetObj.label} gently in its spot. Tidy habits! 🪵✨',
          audioPromptOverride: 'Place the ${targetObj.label} in its spot',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Clean and tidy! Placed perfectly! ✨',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step6_celebrate',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: pip.objectId,
          draggableObject: pip,
          ageProfile: profile,
          instructionOverride: 'Touch Pip to celebrate having wonderful manners! ⭐🎉',
          audioPromptOverride: 'Touch Pip to celebrate!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Hooray! Fantastic manners and great English today! 🌟🏆',
        ),
      ];
    }

    // Archetype C: Object Discovery & Move (5 interactions)
    if (isDiscovery) {
      return [
        InteractiveActivityConfig(
          id: '${lessonId}_step1_find',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          distractors: [secondaryObj],
          ageProfile: profile,
          instructionOverride: 'Look and listen: Can you find the ${targetObj.label}? ${targetObj.emoji}',
          audioPromptOverride: 'Find the ${targetObj.label}.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'You found the ${targetObj.label}! ${targetObj.emoji}',
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
          instructionOverride: 'Move the ${targetObj.label} over here! ${targetObj.emoji}',
          audioPromptOverride: 'Move the ${targetObj.label}',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Nicely moved! ${targetObj.emoji}✨',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step3_speak',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          speakTriggerPhrase: 'this is a ${targetObj.label.toLowerCase()}',
          ageProfile: profile,
          instructionOverride: 'Say it clearly: "This is a ${targetObj.label}!" 🗣️',
          audioPromptOverride: 'Say: This is a ${targetObj.label}!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Awesome! "This is a ${targetObj.label}!" 🌟',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step4_chat',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.conversationRolePlay,
          scene: scene,
          targetObjectId: secondaryObj.objectId,
          draggableObject: secondaryObj,
          rolePlayPipPrompt: 'Do you see the ${targetObj.label}? 🦜',
          rolePlayExpectedResponse: 'yes i see it',
          ageProfile: profile,
          instructionOverride: 'Pip asks: "Do you see the ${targetObj.label}?" Answer: "Yes, I see it!" 💬',
          audioPromptOverride: 'Answer: Yes, I see it!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: '"Yes, I see it!" Great chat! ❤️',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step5_cheer',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: pip.objectId,
          draggableObject: pip,
          ageProfile: profile,
          instructionOverride: 'Touch Pip to finish your lesson! ⭐🎉',
          audioPromptOverride: 'Touch Pip to finish!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Great job! You are becoming a wonderful speaker! 🌟🏆',
        ),
      ];
    }

    // Archetype A: Phrase Practice & Placement (5 interactions)
    return [
      InteractiveActivityConfig(
        id: '${lessonId}_step1_observe',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.listenAndTouch,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        distractors: [secondaryObj],
        ageProfile: profile,
        instructionOverride: 'Listen carefully: "I see the ${targetObj.label}." Touch it! ${targetObj.emoji}',
        audioPromptOverride: 'I see the ${targetObj.label}. Touch it!',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Excellent! You found the ${targetObj.label}! ${targetObj.emoji}',
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
        spatialRelation: 'on',
        ageProfile: profile,
        instructionOverride: 'Put the ${targetObj.label} nicely with ${secondaryObj.label}! ✨',
        audioPromptOverride: 'Put the ${targetObj.label} with ${secondaryObj.label}',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Clean and tidy! Placed perfectly! ✨',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step3_speak_phrase',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        speakTriggerPhrase: 'this is my ${targetObj.label.toLowerCase()}',
        ageProfile: profile,
        instructionOverride: 'Say the full phrase: "This is my ${targetObj.label}!" 🗣️',
        audioPromptOverride: 'Say: This is my ${targetObj.label}!',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Super! "This is my ${targetObj.label}!" Great speaking! 🌟',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step4_dialogue',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.conversationRolePlay,
        scene: scene,
        targetObjectId: secondaryObj.objectId,
        draggableObject: secondaryObj,
        rolePlayPipPrompt: 'Do you like the ${targetObj.label}? 🦜',
        rolePlayExpectedResponse: 'yes i like it',
        ageProfile: profile,
        instructionOverride: 'Pip asks: "Do you like the ${targetObj.label}?" Answer: "Yes, I like it!" 💬',
        audioPromptOverride: 'Do you like the ${targetObj.label}? Say: Yes, I like it!',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: '"Yes, I like it!" What a nice chat! ❤️',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step5_review_celebrate',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.listenAndTouch,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        ageProfile: profile,
        instructionOverride: 'Touch the star to complete your lesson! ⭐🎉',
        audioPromptOverride: 'Touch the star to complete!',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Lesson complete! You are becoming a great speaker! 🌟🏆',
      ),
    ];
  }

  static InteractiveScene _resolveSceneForLesson(String lessonId) {
    if (lessonId.contains('me') || lessonId.contains('happy') || lessonId.contains('who')) {
      return CurriculumV2Scenes.helloMeScene();
    }
    if (lessonId.contains('family') || lessonId.contains('mother') || lessonId.contains('father')) {
      return CurriculumV2Scenes.myHomeRoomScene();
    }
    if (lessonId.contains('food') || lessonId.contains('apple') || lessonId.contains('water') || lessonId.contains('hungry')) {
      return CurriculumV2Scenes.foodKitchenScene();
    }
    if (lessonId.contains('home') || lessonId.contains('ball') || lessonId.contains('table') || lessonId.contains('bed')) {
      return CurriculumV2Scenes.myHomeRoomScene();
    }
    if (lessonId.contains('animal') || lessonId.contains('cat') || lessonId.contains('dog') || lessonId.contains('rabbit')) {
      return CurriculumV2Scenes.animalsFarmScene();
    }
    if (lessonId.contains('school') || lessonId.contains('pencil') || lessonId.contains('help')) {
      return CurriculumV2Scenes.schoolClassroomScene();
    }
    if (lessonId.contains('weather') || lessonId.contains('sunny') || lessonId.contains('rain')) {
      return CurriculumV2Scenes.natureParkScene();
    }
    return CurriculumV2Scenes.toysPlaygroundScene();
  }
}
