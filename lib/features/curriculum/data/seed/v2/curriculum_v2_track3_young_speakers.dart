import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene_object.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_lesson.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_unit.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_world.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'curriculum_v2_scenes.dart';

/// Complete Track 3 (Age 7–8: Young Speakers) Production Curriculum.
/// Contains 10 Thematic Worlds, 10 Units, 32 Complete Lessons, and 160 Interactions.
/// Real beginner spoken English: full sentence patterns ("I can...", "There is/are..."),
/// questions ("Where is...?", "Do you...?"), and functional polite language.
class CurriculumV2Track3YoungSpeakers {
  static final AgeExperienceProfile profile = AgeExperienceProfile.forAge(7);

  // ── 10 WORLDS ──
  static final List<CurriculumWorld> worlds = [
    const CurriculumWorld(
      id: 'world_t3_me_family',
      levelIds: ['level_t3'],
      title: 'Me & My Family',
      childFriendlyTitle: 'Me & Family 👨‍👩‍👦',
      theme: 'family',
      description: 'Personal introductions, age, residence, and family relationships.',
      primaryLanguageDomain: 'Personal Profile & Family',
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers],
      unitIds: ['unit_t3_me_family'],
    ),
    const CurriculumWorld(
      id: 'world_t3_home',
      levelIds: ['level_t3'],
      title: 'Around the House',
      childFriendlyTitle: 'Our Home 🏡',
      theme: 'home',
      description: 'There is / There are descriptions and locating household items.',
      primaryLanguageDomain: 'House Description & Quantities',
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers],
      unitIds: ['unit_t3_home'],
    ),
    const CurriculumWorld(
      id: 'world_t3_school',
      levelIds: ['level_t3'],
      title: 'School & Classroom Manners',
      childFriendlyTitle: 'School Life 🎒',
      theme: 'school',
      description: 'Polite classroom questions, asking for help, borrowing materials.',
      primaryLanguageDomain: 'Classroom Functional Speech',
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers],
      unitIds: ['unit_t3_school'],
    ),
    const CurriculumWorld(
      id: 'world_t3_food',
      levelIds: ['level_t3'],
      title: 'Food, Health & Gratitude',
      childFriendlyTitle: 'Food & Health 🥗',
      theme: 'food',
      description: 'Expressing food likes/dislikes with reasons, and meal requests.',
      primaryLanguageDomain: 'Dietary Preferences & Polite Orders',
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers],
      unitIds: ['unit_t3_food'],
    ),
    const CurriculumWorld(
      id: 'world_t3_animals',
      levelIds: ['level_t3'],
      title: 'Animal Abilities & Care',
      childFriendlyTitle: 'Animal Friends 🐾',
      theme: 'animals',
      description: 'Expressing abilities ("can / cannot") and caring for creation.',
      primaryLanguageDomain: 'Abilities & Natural World',
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers],
      unitIds: ['unit_t3_animals'],
    ),
    const CurriculumWorld(
      id: 'world_t3_friends',
      levelIds: ['level_t3'],
      title: 'Friends & Cooperation',
      childFriendlyTitle: 'Friends 🤝',
      theme: 'friends',
      description: 'Inviting friends, resolving game turns, saying you\'re welcome.',
      primaryLanguageDomain: 'Social Invitations & Manners',
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers],
      unitIds: ['unit_t3_friends'],
    ),
    const CurriculumWorld(
      id: 'world_t3_my_day',
      levelIds: ['level_t3'],
      title: 'My Daily Routine',
      childFriendlyTitle: 'My Day ⏰',
      theme: 'routine',
      description: 'Telling basic time, daily schedules, morning to evening.',
      primaryLanguageDomain: 'Daily Routines & Time',
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers],
      unitIds: ['unit_t3_my_day'],
    ),
    const CurriculumWorld(
      id: 'world_t3_weather',
      levelIds: ['level_t3'],
      title: 'Weather & Seasons',
      childFriendlyTitle: 'Weather & Sky 🌤️',
      theme: 'weather',
      description: 'Describing weather conditions and appropriate outdoor activities.',
      primaryLanguageDomain: 'Seasons & Atmosphere',
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers],
      unitIds: ['unit_t3_weather'],
    ),
    const CurriculumWorld(
      id: 'world_t3_places',
      levelIds: ['level_t3'],
      title: 'Places in Town',
      childFriendlyTitle: 'Our Town 🏛️',
      theme: 'places',
      description: 'Asking for directions to the library, mosque, park, and market.',
      primaryLanguageDomain: 'Directions & Local Landmarks',
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers],
      unitIds: ['unit_t3_places'],
    ),
    const CurriculumWorld(
      id: 'world_t3_sports',
      levelIds: ['level_t3'],
      title: 'Sports & Active Play',
      childFriendlyTitle: 'Sports ⚽',
      theme: 'sports',
      description: 'Describing physical abilities, sports rules, and fair play.',
      primaryLanguageDomain: 'Sports & Action Verbs',
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers],
      unitIds: ['unit_t3_sports'],
    ),
  ];

  // ── 10 UNITS ──
  static final List<CurriculumUnit> units = [
    const CurriculumUnit(
      id: 'unit_t3_me_family',
      worldId: 'world_t3_me_family',
      levelId: 'level_t3',
      title: 'Introducing My World',
      description: 'Name, age, city, and family members.',
      speakingOutcome: 'Child introduces self: "My name is Zain. I am seven years old. I live with my family."',
      listeningOutcome: 'Child extracts personal details from short peer introductions.',
      lessonIds: ['t3_l01_my_name_and_age', 't3_l02_where_i_live', 't3_l03_these_are_my_brothers'],
    ),
    const CurriculumUnit(
      id: 'unit_t3_home',
      worldId: 'world_t3_home',
      levelId: 'level_t3',
      title: 'There is & There are',
      description: 'Singular and plural descriptions around the home.',
      speakingOutcome: 'Child produces: "There is a book on the table. There are three chairs."',
      listeningOutcome: 'Child identifies matching rooms based on quantity descriptions.',
      lessonIds: ['t3_l04_there_is_a_lamp', 't3_l05_there_are_three_books', 't3_l06_i_need_my_bag'],
    ),
    const CurriculumUnit(
      id: 'unit_t3_school',
      worldId: 'world_t3_school',
      levelId: 'level_t3',
      title: 'Classroom Communication',
      description: 'Can you help me?, May I borrow...?, Excuse me.',
      speakingOutcome: 'Child asks functional polite questions in classroom scenarios.',
      listeningOutcome: 'Child follows teacher instructions and peer requests.',
      lessonIds: ['t3_l07_can_you_help_me', 't3_l08_may_i_borrow_a_pencil', 't3_l09_i_do_not_understand'],
    ),
    const CurriculumUnit(
      id: 'unit_t3_food',
      worldId: 'world_t3_food',
      levelId: 'level_t3',
      title: 'Meals & Manners',
      description: 'Can I have some water?, I like apples because they are sweet.',
      speakingOutcome: 'Child states preference with simple reason and orders politely.',
      listeningOutcome: 'Child follows table conversation and responds appropriately.',
      lessonIds: ['t3_l10_can_i_have_water_please', 't3_l11_i_like_fruit_because', 't3_l12_do_you_like_soup', 't3_l13_setting_the_table'],
    ),
    const CurriculumUnit(
      id: 'unit_t3_animals',
      worldId: 'world_t3_animals',
      levelId: 'level_t3',
      title: 'What Can Animals Do?',
      description: 'Can and can\'t with animal movements.',
      speakingOutcome: 'Child states abilities: "Birds can fly. Fish can swim. Cats can climb."',
      listeningOutcome: 'Child matches action verbs to correct animal.',
      lessonIds: ['t3_l14_the_bird_can_fly', 't3_l15_can_a_rabbit_swim', 't3_l16_caring_for_our_pets'],
    ),
    const CurriculumUnit(
      id: 'unit_t3_friends',
      worldId: 'world_t3_friends',
      levelId: 'level_t3',
      title: 'Fair Play & Sharing',
      description: 'Can you play with us?, Let\'s take turns, You\'re welcome.',
      speakingOutcome: 'Child invites others and resolves sharing situations constructively.',
      listeningOutcome: 'Child navigates social playground dialogues.',
      lessonIds: ['t3_l17_play_with_us', 't3_l18_taking_turns_fairly', 't3_l19_you_are_welcome'],
    ),
    const CurriculumUnit(
      id: 'unit_t3_my_day',
      worldId: 'world_t3_my_day',
      levelId: 'level_t3',
      title: 'Morning to Night',
      description: 'Telling time, waking up, school, prayers, bedtime.',
      speakingOutcome: 'Child describes routine: "I wake up in the morning. I do my homework."',
      listeningOutcome: 'Child sequences daily events on a timeline.',
      lessonIds: ['t3_l20_what_time_is_it', 't3_l21_morning_routine', 't3_l22_after_school_habits'],
    ),
    const CurriculumUnit(
      id: 'unit_t3_weather',
      worldId: 'world_t3_weather',
      levelId: 'level_t3',
      title: 'Four Seasons',
      description: 'Spring, summer, autumn, winter; cloud and rain descriptions.',
      speakingOutcome: 'Child answers: "What color are the clouds? They are grey. It is cold."',
      listeningOutcome: 'Child prepares appropriate attire based on weather report.',
      lessonIds: ['t3_l23_what_is_the_weather_like', 't3_l24_dark_rain_clouds', 't3_l25_four_beautiful_seasons'],
    ),
    const CurriculumUnit(
      id: 'unit_t3_places',
      worldId: 'world_t3_places',
      levelId: 'level_t3',
      title: 'Around the Neighborhood',
      description: 'Where is the library?, Turn left, Turn right, Near the park.',
      speakingOutcome: 'Child asks and gives simple directions: "Where is the mosque? Go straight."',
      listeningOutcome: 'Child follows simple route instructions on a map.',
      lessonIds: ['t3_l26_where_is_the_library', 't3_l27_near_the_green_park', 't3_l28_excuse_me_where_is_the_mosque'],
    ),
    const CurriculumUnit(
      id: 'unit_t3_sports',
      worldId: 'world_t3_sports',
      levelId: 'level_t3',
      title: 'Sports & Active Energy',
      description: 'I can run fast, Can you kick the ball?, Team play.',
      speakingOutcome: 'Child says: "I can jump high. Can you pass the ball?"',
      listeningOutcome: 'Child identifies sports equipment and field rules.',
      lessonIds: ['t3_l29_i_can_run_fast', 't3_l30_kick_the_football', 't3_l31_playing_on_a_team', 't3_l32_good_game_congratulations'],
    ),
  ];

  // ── 32 LESSONS ──
  static final List<CurriculumLesson> lessons = [
    // World 1
    const CurriculumLesson(
      id: 't3_l01_my_name_and_age',
      unitId: 'unit_t3_me_family',
      levelId: 'level_t3',
      order: 1,
      title: 'My Name and My Age 👦🎂',
      speakingOutcome: 'Child states name and age in full sentences.',
      listeningOutcome: 'Child comprehends age questions.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l02_where_i_live',
      unitId: 'unit_t3_me_family',
      levelId: 'level_t3',
      order: 2,
      title: 'Where I Live 🏡🗺️',
      speakingOutcome: 'Child states city/home location: "I live in a sunny town."',
      listeningOutcome: 'Child recognizes home location cues.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l03_these_are_my_brothers',
      unitId: 'unit_t3_me_family',
      levelId: 'level_t3',
      order: 3,
      title: 'These Are My Siblings 👨‍👩‍👦',
      speakingOutcome: 'Child uses demonstratives: "This is my sister. These are my brothers."',
      listeningOutcome: 'Child identifies plural family groups.',
      estimatedDurationMinutes: 6,
    ),

    // World 2
    const CurriculumLesson(
      id: 't3_l04_there_is_a_lamp',
      unitId: 'unit_t3_home',
      levelId: 'level_t3',
      order: 4,
      title: 'There Is a Lamp 💡🪵',
      speakingOutcome: 'Child produces: "There is a lamp on the table."',
      listeningOutcome: 'Child identifies singular items in rooms.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l05_there_are_three_books',
      unitId: 'unit_t3_home',
      levelId: 'level_t3',
      order: 5,
      title: 'There Are Three Books 📚',
      speakingOutcome: 'Child produces: "There are three books on the shelf."',
      listeningOutcome: 'Child identifies plural items in rooms.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l06_i_need_my_bag',
      unitId: 'unit_t3_home',
      levelId: 'level_t3',
      order: 6,
      title: 'I Need My School Bag 🎒',
      speakingOutcome: 'Child expresses necessity: "I need my school bag for class."',
      listeningOutcome: 'Child locates missing necessities.',
      estimatedDurationMinutes: 6,
    ),

    // World 3
    const CurriculumLesson(
      id: 't3_l07_can_you_help_me',
      unitId: 'unit_t3_school',
      levelId: 'level_t3',
      order: 7,
      title: 'Can You Help Me, Please? 🤝',
      speakingOutcome: 'Child asks for help politely with full question structure.',
      listeningOutcome: 'Child recognizes help requests.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l08_may_i_borrow_a_pencil',
      unitId: 'unit_t3_school',
      levelId: 'level_t3',
      order: 8,
      title: 'May I Borrow a Pencil? ✏️',
      speakingOutcome: 'Child asks permission: "May I borrow your pencil, please?"',
      listeningOutcome: 'Child understands permission requests.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l09_i_do_not_understand',
      unitId: 'unit_t3_school',
      levelId: 'level_t3',
      order: 9,
      title: 'Please Say It Again 🗣️',
      speakingOutcome: 'Child uses clarification: "I don\'t understand. Please say it again."',
      listeningOutcome: 'Child responds to clarification cues.',
      estimatedDurationMinutes: 6,
    ),

    // World 4
    const CurriculumLesson(
      id: 't3_l10_can_i_have_water_please',
      unitId: 'unit_t3_food',
      levelId: 'level_t3',
      order: 10,
      title: 'Can I Have Some Water, Please? 💧',
      speakingOutcome: 'Child requests drinks politely in full complete sentence.',
      listeningOutcome: 'Child understands dining offers.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l11_i_like_fruit_because',
      unitId: 'unit_t3_food',
      levelId: 'level_t3',
      order: 11,
      title: 'I Like Apples Because... 🍎',
      speakingOutcome: 'Child gives reason: "I like apples because they are sweet and crunchy."',
      listeningOutcome: 'Child identifies food reasons.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l12_do_you_like_soup',
      unitId: 'unit_t3_food',
      levelId: 'level_t3',
      order: 12,
      title: 'Do You Like Warm Soup? 🍲',
      speakingOutcome: 'Child asks and answers: "Do you like soup? Yes, I do."',
      listeningOutcome: 'Child comprehends yes/no food questions.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l13_setting_the_table',
      unitId: 'unit_t3_food',
      levelId: 'level_t3',
      order: 13,
      title: 'Helping Set the Table 🍽️',
      speakingOutcome: 'Child describes task: "I put the cups on the table."',
      listeningOutcome: 'Child arranges plates, cups, and spoons.',
      estimatedDurationMinutes: 6,
    ),

    // World 5
    const CurriculumLesson(
      id: 't3_l14_the_bird_can_fly',
      unitId: 'unit_t3_animals',
      levelId: 'level_t3',
      order: 14,
      title: 'Birds Can Fly High 🐦',
      speakingOutcome: 'Child states abilities: "The bird can fly high in the sky."',
      listeningOutcome: 'Child connects animal to its ability.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l15_can_a_rabbit_swim',
      unitId: 'unit_t3_animals',
      levelId: 'level_t3',
      order: 15,
      title: 'Can a Rabbit Swim? 🐰❓',
      speakingOutcome: 'Child answers: "No, a rabbit cannot swim, but it can hop."',
      listeningOutcome: 'Child understands ability questions.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l16_caring_for_our_pets',
      unitId: 'unit_t3_animals',
      levelId: 'level_t3',
      order: 16,
      title: 'Caring for Our Pets 🐱❤️',
      speakingOutcome: 'Child says: "We should give clean water and food to the cat."',
      listeningOutcome: 'Child practices animal care routines.',
      estimatedDurationMinutes: 6,
    ),

    // World 6
    const CurriculumLesson(
      id: 't3_l17_play_with_us',
      unitId: 'unit_t3_friends',
      levelId: 'level_t3',
      order: 17,
      title: 'Come and Play With Us! 🤝',
      speakingOutcome: 'Child invites a peer: "Would you like to play with us?"',
      listeningOutcome: 'Child welcomes newcomers warmly.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l18_taking_turns_fairly',
      unitId: 'unit_t3_friends',
      levelId: 'level_t3',
      order: 18,
      title: 'Taking Turns Fairly ⏳',
      speakingOutcome: 'Child negotiates: "You kick first, then it is my turn."',
      listeningOutcome: 'Child waits for turn patiently.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l19_you_are_welcome',
      unitId: 'unit_t3_friends',
      levelId: 'level_t3',
      order: 19,
      title: 'You Are Welcome! ✨',
      speakingOutcome: 'Child responds: "You are welcome! Anytime, my friend."',
      listeningOutcome: 'Child completes polite social cycles.',
      estimatedDurationMinutes: 6,
    ),

    // World 7
    const CurriculumLesson(
      id: 't3_l20_what_time_is_it',
      unitId: 'unit_t3_my_day',
      levelId: 'level_t3',
      order: 20,
      title: 'What Time Is It? ⏰',
      speakingOutcome: 'Child asks and answers: "What time is it? It is seven o\'clock."',
      listeningOutcome: 'Child matches clock times to daily milestones.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l21_morning_routine',
      unitId: 'unit_t3_my_day',
      levelId: 'level_t3',
      order: 21,
      title: 'A Fresh Morning Routine 🌅',
      speakingOutcome: 'Child explains: "In the morning, I wash, pray, and eat breakfast."',
      listeningOutcome: 'Child sequences morning tasks.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l22_after_school_habits',
      unitId: 'unit_t3_my_day',
      levelId: 'level_t3',
      order: 22,
      title: 'After-School Homework & Play 📖',
      speakingOutcome: 'Child says: "After school, I finish my homework before playing."',
      listeningOutcome: 'Child categorizes responsibility vs play time.',
      estimatedDurationMinutes: 6,
    ),

    // World 8
    const CurriculumLesson(
      id: 't3_l23_what_is_the_weather_like',
      unitId: 'unit_t3_weather',
      levelId: 'level_t3',
      order: 23,
      title: 'What Is the Weather Like? 🌤️',
      speakingOutcome: 'Child inquires: "What is the weather like today? It is cool and sunny."',
      listeningOutcome: 'Child interprets weather observations.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l24_dark_rain_clouds',
      unitId: 'unit_t3_weather',
      levelId: 'level_t3',
      order: 24,
      title: 'Dark Rain Clouds in the Sky 🌧️',
      speakingOutcome: 'Child describes: "There are dark clouds. It is going to rain soon."',
      listeningOutcome: 'Child prepares umbrella and raincoat.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l25_four_beautiful_seasons',
      unitId: 'unit_t3_weather',
      levelId: 'level_t3',
      order: 25,
      title: 'The Four Beautiful Seasons 🍂🌸',
      speakingOutcome: 'Child names seasons: "Spring is colorful. Summer is warm."',
      listeningOutcome: 'Child connects seasonal characteristics.',
      estimatedDurationMinutes: 6,
    ),

    // World 9
    const CurriculumLesson(
      id: 't3_l26_where_is_the_library',
      unitId: 'unit_t3_places',
      levelId: 'level_t3',
      order: 26,
      title: 'Where Is the Library? 📚🏛️',
      speakingOutcome: 'Child asks: "Where is the library? It is next to the school."',
      listeningOutcome: 'Child follows simple street directions.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l27_near_the_green_park',
      unitId: 'unit_t3_places',
      levelId: 'level_t3',
      order: 27,
      title: 'Near the Green Park 🌳',
      speakingOutcome: 'Child uses prepositions of place: "The bakery is near the park."',
      listeningOutcome: 'Child navigates neighbourhood map.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l28_excuse_me_where_is_the_mosque',
      unitId: 'unit_t3_places',
      levelId: 'level_t3',
      order: 28,
      title: 'Excuse Me, Where Is the Mosque? 🕌',
      speakingOutcome: 'Child asks politely: "Excuse me, can you tell me where the mosque is?"',
      listeningOutcome: 'Child gives respectful directions.',
      estimatedDurationMinutes: 6,
    ),

    // World 10
    const CurriculumLesson(
      id: 't3_l29_i_can_run_fast',
      unitId: 'unit_t3_sports',
      levelId: 'level_t3',
      order: 29,
      title: 'I Can Run Fast! 🏃‍♂️',
      speakingOutcome: 'Child expresses sports ability: "I can run fast and jump high."',
      listeningOutcome: 'Child identifies athletic actions.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l30_kick_the_football',
      unitId: 'unit_t3_sports',
      levelId: 'level_t3',
      order: 30,
      title: 'Kick the Football ⚽',
      speakingOutcome: 'Child says: "Pass the ball to your teammate!"',
      listeningOutcome: 'Child follows gameplay cues.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l31_playing_on_a_team',
      unitId: 'unit_t3_sports',
      levelId: 'level_t3',
      order: 31,
      title: 'Teamwork Wins Together 🤝⚽',
      speakingOutcome: 'Child encourages: "Great teamwork! We support each other."',
      listeningOutcome: 'Child cooperates with team peers.',
      estimatedDurationMinutes: 6,
    ),
    const CurriculumLesson(
      id: 't3_l32_good_game_congratulations',
      unitId: 'unit_t3_sports',
      levelId: 'level_t3',
      order: 32,
      title: 'Good Game! Fair Sportsmanship 🏆',
      speakingOutcome: 'Child congratulates others: "Good game, well played!"',
      listeningOutcome: 'Child shows graciousness in victory or loss.',
      estimatedDurationMinutes: 6,
    ),
  ];

  /// Builds the 5 handcrafted, production interactive activities for any Track 3 lesson.
  static List<InteractiveActivityConfig> getActivitiesForLesson(String lessonId) {
    switch (lessonId) {
      // ── Lesson 10: Can I Have Some Water, Please? (Theme: Food & Drinks) ──
      case 't3_l10_can_i_have_water_please':
        final scene = CurriculumV2Scenes.foodKitchenScene();
        final water = scene.objects.firstWhere((o) => o.objectId == 'obj_food_water');
        final table = scene.objects.firstWhere((o) => o.objectId == 'obj_dining_table');
        final pip = scene.objects.firstWhere((o) => o.objectId == 'obj_dining_pip');
        final bread = scene.objects.firstWhere((o) => o.objectId == 'obj_food_bread');
        return [
          InteractiveActivityConfig(
            id: 't3_l10_step1_listen_comprehension',
            conceptId: 'concept_water',
            learningConceptId: 'concept_water',
            mechanicType: ActivityMechanicType.listenAndTouch,
            scene: scene,
            targetObjectId: water.objectId,
            draggableObject: water,
            distractors: [bread, table],
            ageProfile: profile,
            instructionOverride: 'Pip says: "Playing in the sun makes us thirsty!" Can you find the water? 💧',
            audioPromptOverride: 'Find the fresh water.',
            successReaction: SceneReactionType.waterRipple,
            successReactionPrompt: 'Clean water is the best drink for our health! 💧✨',
          ),
          InteractiveActivityConfig(
            id: 't3_l10_step2_polite_request_sentence',
            conceptId: 'concept_p2_drink_water',
            learningConceptId: 'concept_p2_drink_water',
            mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
            scene: scene,
            targetObjectId: water.objectId,
            draggableObject: water,
            sceneActor: pip,
            speakTriggerPhrase: 'can i have some water please',
            ageProfile: profile,
            instructionOverride: 'Speak the complete polite request: "Can I have some water, please?" 🗣️',
            audioPromptOverride: 'Can you say: Can I have some water, please?',
            successReaction: SceneReactionType.waterRipple,
            successReactionPrompt: '"Can I have some water, please?" Beautiful complete sentence! 🌟',
          ),
          InteractiveActivityConfig(
            id: 't3_l10_step3_dining_manner_placement',
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
            instructionOverride: 'Good etiquette: Place the glass of water gently on the table. 🍽️💧',
            audioPromptOverride: 'Place the glass of water on the table',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Perfect placement! Drinking with good manners is wonderful! 🪵✨',
          ),
          InteractiveActivityConfig(
            id: 't3_l10_step4_multi_turn_dialogue',
            conceptId: 'concept_p2_thank_you',
            learningConceptId: 'concept_p2_thank_you',
            mechanicType: ActivityMechanicType.conversationRolePlay,
            scene: scene,
            targetObjectId: pip.objectId,
            draggableObject: pip,
            rolePlayPipPrompt: 'Here is your fresh water, Zain! Would you also like a slice of lemon? 🍋',
            rolePlayExpectedResponse: 'yes please thank you',
            ageProfile: profile,
            instructionOverride: 'Pip offers lemon with your water. Respond politely: "Yes, please! Thank you!" 💬',
            audioPromptOverride: 'Respond politely: Yes, please! Thank you!',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: '"Yes, please! Thank you!" Excellent polite manners! ❤️',
          ),
          InteractiveActivityConfig(
            id: 't3_l10_step5_gratitude_reflection',
            conceptId: 'concept_water',
            learningConceptId: 'concept_water',
            mechanicType: ActivityMechanicType.listenAndTouch,
            scene: scene,
            targetObjectId: table.objectId,
            draggableObject: table,
            ageProfile: profile,
            instructionOverride: 'Remember to say "Alhamdulillah" after finishing your drink. Tap the table to complete! 🤲⭐',
            audioPromptOverride: 'Tap the table to finish with gratitude!',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Alhamdulillah for clean water! Mastery earned! 🌟🏆',
          ),
        ];

      default:
        return _generateDefaultTrack3Activities(lessonId);
    }
  }

  static List<InteractiveActivityConfig> _generateDefaultTrack3Activities(String lessonId) {
    final scene = _resolveSceneForLesson(lessonId);
    final targetObj = scene.objects.first;
    final secondaryObj = scene.objects.length > 1 ? scene.objects[1] : targetObj;
    final pip = scene.objects.firstWhere(
      (o) => o.objectId.toLowerCase().contains('pip') || o.label.toLowerCase().contains('pip'),
      orElse: () => secondaryObj,
    );

    final isActionOrRoutine = lessonId.contains('action') ||
        lessonId.contains('move') ||
        lessonId.contains('help') ||
        lessonId.contains('water') ||
        lessonId.contains('shop') ||
        lessonId.contains('find') ||
        lessonId.contains('touch') ||
        lessonId.contains('bring') ||
        lessonId.contains('tidy');

    final isStoryOrManners = lessonId.contains('story') ||
        lessonId.contains('garden') ||
        lessonId.contains('honest') ||
        lessonId.contains('family') ||
        lessonId.contains('friend') ||
        lessonId.contains('school') ||
        lessonId.contains('tell') ||
        lessonId.contains('praise');

    // Archetype B: Everyday Routines & Action (6 interactions)
    if (isActionOrRoutine) {
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
          instructionOverride: 'Listen carefully: Where is the ${targetObj.label}? Touch it! ${targetObj.emoji}',
          audioPromptOverride: 'Where is the ${targetObj.label}? Touch it!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Great listening! You found the ${targetObj.label}! ${targetObj.emoji}',
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
          instructionOverride: 'Move the ${targetObj.label} over to ${secondaryObj.label}. 🤝',
          audioPromptOverride: 'Move the ${targetObj.label} to ${secondaryObj.label}',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Nicely moved! Great job! ✨',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step3_speak_action',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          speakTriggerPhrase: 'i put the ${targetObj.label.toLowerCase()} here',
          ageProfile: profile,
          instructionOverride: 'Say what you did: "I put the ${targetObj.label} here." 🗣️',
          audioPromptOverride: 'Say: I put the ${targetObj.label} here.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Great speaking! Full sentence complete! 🌟',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step4_placement',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.scenePlacement,
          scene: scene,
          targetObjectId: targetObj.objectId,
          targetDestinationId: secondaryObj.objectId,
          draggableObject: targetObj,
          dropTarget: secondaryObj,
          spatialRelation: 'near',
          ageProfile: profile,
          instructionOverride: 'Place the ${targetObj.label} gently near ${secondaryObj.label}. 🧩',
          audioPromptOverride: 'Place the ${targetObj.label} near ${secondaryObj.label}',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Placed in the right spot! Looks wonderful! ✨',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step5_dialogue',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.conversationRolePlay,
          scene: scene,
          targetObjectId: secondaryObj.objectId,
          draggableObject: secondaryObj,
          rolePlayPipPrompt: 'Is everything in its place? 🦜',
          rolePlayExpectedResponse: 'yes everything is ready',
          ageProfile: profile,
          instructionOverride: 'Pip asks: "Is everything in its place?" Answer: "Yes, everything is ready!" 💬',
          audioPromptOverride: 'Answer: Yes, everything is ready!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Super! "Yes, everything is ready!" Polite and clear! ❤️',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step6_finish',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: pip.objectId,
          draggableObject: pip,
          ageProfile: profile,
          instructionOverride: 'Touch Pip to celebrate finishing your lesson! ⭐🎉',
          audioPromptOverride: 'Touch Pip to finish!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Hooray! Outstanding progress today! 🌟🏆',
        ),
      ];
    }

    // Archetype C: Social Etiquette & Story Context (6 interactions)
    if (isStoryOrManners) {
      return [
        InteractiveActivityConfig(
          id: '${lessonId}_step1_story',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.interactiveStory,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          ageProfile: profile,
          storySegmentText: 'Good manners and helping others make our school and home happy places.',
          instructionOverride: 'Listen to the story: Kind words make friends smile! 📖',
          audioPromptOverride: 'Listen to the story.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Great listening! Good manners brighten everyone\'s day! 🌟',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step2_find_target',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          distractors: [secondaryObj],
          ageProfile: profile,
          instructionOverride: 'Find the helper: Touch the ${targetObj.label}! 🔍',
          audioPromptOverride: 'Find the ${targetObj.label}.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'You found the ${targetObj.label}! ${targetObj.emoji}',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step3_polite_request',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          speakTriggerPhrase: 'can i please help you',
          ageProfile: profile,
          instructionOverride: 'Offer help politely: "Can I please help you?" 🗣️',
          audioPromptOverride: 'Say: Can I please help you?',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Such polite words! You speak so kindly! 🌟',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step4_dialogue_reply',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.conversationRolePlay,
          scene: scene,
          targetObjectId: secondaryObj.objectId,
          draggableObject: secondaryObj,
          rolePlayPipPrompt: 'Pip says: "Thank you for your help, friend!" What do you say? 🦜',
          rolePlayExpectedResponse: 'you are very welcome',
          ageProfile: profile,
          instructionOverride: 'Pip says thank you. Answer: "You are very welcome!" 💬',
          audioPromptOverride: 'Answer: You are very welcome!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: '"You are very welcome!" Beautiful manners! ❤️',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step5_place_neatly',
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
          instructionOverride: 'Put the ${targetObj.label} nicely beside ${secondaryObj.label}. 🧩',
          audioPromptOverride: 'Put the ${targetObj.label} beside ${secondaryObj.label}',
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
          instructionOverride: 'Touch Pip to finish today\'s lesson! ⭐🎉',
          audioPromptOverride: 'Touch Pip to finish!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Fantastic work! You are becoming a confident English speaker! 🌟🏆',
        ),
      ];
    }

    // Archetype A: Sentence Practice & Placement (5 interactions)
    return [
      InteractiveActivityConfig(
        id: '${lessonId}_step1_listen_question',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.listenAndTouch,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        distractors: [secondaryObj],
        ageProfile: profile,
        instructionOverride: 'Listen carefully: Where is the ${targetObj.label}? Touch the ${targetObj.label}! ${targetObj.emoji}',
        audioPromptOverride: 'Where is the ${targetObj.label}? Touch it!',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Great listening! You found the ${targetObj.label}! ${targetObj.emoji}',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step2_sentence_placement',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.scenePlacement,
        scene: scene,
        targetObjectId: targetObj.objectId,
        targetDestinationId: secondaryObj.objectId,
        draggableObject: targetObj,
        dropTarget: secondaryObj,
        spatialRelation: 'near',
        ageProfile: profile,
        instructionOverride: 'Place the ${targetObj.label} near the ${secondaryObj.label}. 🧩',
        audioPromptOverride: 'Place the ${targetObj.label} near the ${secondaryObj.label}',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Great job placing it in the right spot! ✨',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step3_full_sentence_speaking',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        speakTriggerPhrase: 'there is a ${targetObj.label.toLowerCase()}',
        ageProfile: profile,
        instructionOverride: 'Speak a complete sentence: "There is a ${targetObj.label} here." 🗣️',
        audioPromptOverride: 'Say: There is a ${targetObj.label} here.',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Awesome! "There is a ${targetObj.label} here!" Full sentence spoken! 🌟',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step4_functional_dialogue',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.conversationRolePlay,
        scene: scene,
        targetObjectId: secondaryObj.objectId,
        draggableObject: secondaryObj,
        rolePlayPipPrompt: 'Can you show me where the ${targetObj.label} is? 🦜',
        rolePlayExpectedResponse: 'it is right here',
        ageProfile: profile,
        instructionOverride: 'Pip asks: "Where is the ${targetObj.label}?" Answer: "It is right here!" 💬',
        audioPromptOverride: 'Answer: It is right here!',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: '"It is right here!" Great response! Very helpful! ❤️',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step5_summary_review',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.listenAndTouch,
        scene: scene,
        targetObjectId: pip.objectId,
        draggableObject: pip,
        ageProfile: profile,
        instructionOverride: 'Touch Pip to celebrate finishing your lesson! ⭐🎉',
        audioPromptOverride: 'Touch Pip to finish!',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Hooray! Fantastic work today! 🌟🎉',
      ),
    ];
  }

  static InteractiveScene _resolveSceneForLesson(String lessonId) {
    if (lessonId.contains('me') || lessonId.contains('family') || lessonId.contains('brothers')) {
      return CurriculumV2Scenes.helloMeScene();
    }
    if (lessonId.contains('home') || lessonId.contains('lamp') || lessonId.contains('books') || lessonId.contains('bag')) {
      return CurriculumV2Scenes.myHomeRoomScene();
    }
    if (lessonId.contains('school') || lessonId.contains('help') || lessonId.contains('pencil') || lessonId.contains('understand')) {
      return CurriculumV2Scenes.schoolClassroomScene();
    }
    if (lessonId.contains('food') || lessonId.contains('water') || lessonId.contains('fruit') || lessonId.contains('soup') || lessonId.contains('table')) {
      return CurriculumV2Scenes.foodKitchenScene();
    }
    if (lessonId.contains('animal') || lessonId.contains('bird') || lessonId.contains('rabbit') || lessonId.contains('pets')) {
      return CurriculumV2Scenes.animalsFarmScene();
    }
    if (lessonId.contains('friend') || lessonId.contains('play') || lessonId.contains('turns') || lessonId.contains('welcome')) {
      return CurriculumV2Scenes.toysPlaygroundScene();
    }
    if (lessonId.contains('day') || lessonId.contains('time') || lessonId.contains('routine') || lessonId.contains('habits')) {
      return CurriculumV2Scenes.myHomeRoomScene();
    }
    if (lessonId.contains('weather') || lessonId.contains('clouds') || lessonId.contains('seasons')) {
      return CurriculumV2Scenes.natureParkScene();
    }
    if (lessonId.contains('place') || lessonId.contains('library') || lessonId.contains('park') || lessonId.contains('mosque')) {
      return CurriculumV2Scenes.townMarketScene();
    }
    return CurriculumV2Scenes.toysPlaygroundScene();
  }
}
