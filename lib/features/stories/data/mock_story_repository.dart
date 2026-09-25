import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import '../domain/models/story.dart';
import '../domain/models/story_page.dart';
import '../domain/models/story_question.dart';
import '../domain/repositories/story_repository.dart';

/// Seeded repository for Illustrated Interactive Stories across Worlds 1, 2, and 3.
class MockStoryRepository implements IStoryRepository {
  final Map<String, Story> _stories = {};

  MockStoryRepository() {
    _seedStories();
  }

  void _seedStories() {
    // ----------------------------------------------------
    // STORY 1: A Friendly Day at the Animal Park (World 1)
    // ----------------------------------------------------
    final story1Pages = [
      const StoryPage(
        pageNumber: 1,
        text: 'Ayaan and Maryam visit the bright and sunny animal park.',
        illustrationAssetPath: 'assets/images/stories/animal_park/page_1.png',
        narrationAudioUrl: 'assets/audio/stories/animal_park/page_1.mp3',
        highlightedWords: ['animal', 'park'],
      ),
      const StoryPage(
        pageNumber: 2,
        text: 'Look! A small white cat is sitting near the garden bench.',
        illustrationAssetPath: 'assets/images/stories/animal_park/page_2.png',
        narrationAudioUrl: 'assets/audio/stories/animal_park/page_2.mp3',
        highlightedWords: ['cat', 'small'],
      ),
      const StoryPage(
        pageNumber: 3,
        text: 'The cat is thirsty. Ayaan brings a bowl of clean water.',
        illustrationAssetPath: 'assets/images/stories/animal_park/page_3.png',
        narrationAudioUrl: 'assets/audio/stories/animal_park/page_3.mp3',
        highlightedWords: ['water', 'clean'],
      ),
      const StoryPage(
        pageNumber: 4,
        text: 'Maryam strokes the gentle cat with soft, kind hands.',
        illustrationAssetPath: 'assets/images/stories/animal_park/page_4.png',
        narrationAudioUrl: 'assets/audio/stories/animal_park/page_4.mp3',
        highlightedWords: ['gentle', 'hands'],
      ),
      const StoryPage(
        pageNumber: 5,
        text: 'High up in the green tree, a colorful bird sings a happy song.',
        illustrationAssetPath: 'assets/images/stories/animal_park/page_5.png',
        narrationAudioUrl: 'assets/audio/stories/animal_park/page_5.mp3',
        highlightedWords: ['bird', 'tree'],
      ),
      const StoryPage(
        pageNumber: 6,
        text: 'Across the wide fence, the big elephant sprays water with its trunk!',
        illustrationAssetPath: 'assets/images/stories/animal_park/page_6.png',
        narrationAudioUrl: 'assets/audio/stories/animal_park/page_6.mp3',
        highlightedWords: ['elephant', 'big'],
      ),
      const StoryPage(
        pageNumber: 7,
        text: 'In the distance, the brave lion rests quietly under the shady rock.',
        illustrationAssetPath: 'assets/images/stories/animal_park/page_7.png',
        narrationAudioUrl: 'assets/audio/stories/animal_park/page_7.mp3',
        highlightedWords: ['lion'],
      ),
      const StoryPage(
        pageNumber: 8,
        text: 'Ayaan and Maryam smile and say: "Alhamdulillah for all of Allah’s wonderful animals!"',
        illustrationAssetPath: 'assets/images/stories/animal_park/page_8.png',
        narrationAudioUrl: 'assets/audio/stories/animal_park/page_8.mp3',
        highlightedWords: ['Alhamdulillah'],
      ),
    ];

    final story1Quiz = [
      const StoryQuestion(
        id: 'q1_cat_water',
        prompt: 'What did Ayaan bring to the thirsty cat?',
        options: ['Clean water 💧', 'A toy car 🚗', 'A hat 🧢'],
        correctOptionIndex: 0,
        explanation: 'Ayaan brought clean water with gentle care!',
      ),
      const StoryQuestion(
        id: 'q2_gentle_hands',
        prompt: 'How did Maryam stroke the little cat?',
        options: ['With loud shouting', 'With soft, gentle hands 🤲', 'By pulling its tail'],
        correctOptionIndex: 1,
        explanation: 'We always use gentle hands with living creatures!',
      ),
      const StoryQuestion(
        id: 'q3_elephant_size',
        prompt: 'Which animal in the story was big and sprayed water?',
        options: ['The bird 🐦', 'The elephant 🐘', 'The cat 🐱'],
        correctOptionIndex: 1,
        explanation: 'The big elephant sprayed water with its trunk!',
      ),
      const StoryQuestion(
        id: 'q4_values_phrase',
        prompt: 'What did the children say to thank Allah at the end?',
        options: ['Alhamdulillah 🌟', 'Goodbye 👋', 'Nothing 😶'],
        correctOptionIndex: 0,
        explanation: 'Saying Alhamdulillah shows gratitude to Allah for His creation.',
      ),
    ];

    final story1 = Story(
      id: 'story_animal_park',
      worldId: 'world_animal',
      title: 'A Friendly Day at the Animal Park',
      subtitle: 'Explore the park, give water to a thirsty cat, and practice Rahmah.',
      coverAssetPath: 'assets/images/stories/animal_park/cover.png',
      pages: story1Pages,
      comprehensionQuestions: story1Quiz,
      metadata: const ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Reading comprehension with animal vocabulary and mercy to animals.',
        vocabularyTags: ['cat', 'water', 'gentle', 'bird', 'elephant', 'lion', 'clean', 'big', 'small'],
        valueTags: ['kindness_to_animals', 'rahmah', 'gratitude'],
        worldId: 'world_animal',
        status: PublishedStatus.published,
      ),
      connectedIslamicValueIds: const ['value_kindness_animals'],
    );

    // ----------------------------------------------------
    // STORY 2: Helping at Home (World 2)
    // ----------------------------------------------------
    final story2Pages = [
      const StoryPage(
        pageNumber: 1,
        text: 'The sun rises and shines into Ayaan and Maryam’s cozy home.',
        illustrationAssetPath: 'assets/images/stories/helping_home/page_1.png',
        narrationAudioUrl: 'assets/audio/stories/helping_home/page_1.mp3',
        highlightedWords: ['home', 'sun'],
      ),
      const StoryPage(
        pageNumber: 2,
        text: 'Ayaan makes his bed neatly and puts his pillows in order.',
        illustrationAssetPath: 'assets/images/stories/helping_home/page_2.png',
        narrationAudioUrl: 'assets/audio/stories/helping_home/page_2.mp3',
        highlightedWords: ['bed', 'neatly'],
      ),
      const StoryPage(
        pageNumber: 3,
        text: 'Maryam picks up her storybooks and arranges them on the wooden shelf.',
        illustrationAssetPath: 'assets/images/stories/helping_home/page_3.png',
        narrationAudioUrl: 'assets/audio/stories/helping_home/page_3.mp3',
        highlightedWords: ['books', 'shelf'],
      ),
      const StoryPage(
        pageNumber: 4,
        text: 'Mother smiles and says: "Thank you for keeping your room so clean and tidy!"',
        illustrationAssetPath: 'assets/images/stories/helping_home/page_4.png',
        narrationAudioUrl: 'assets/audio/stories/helping_home/page_4.mp3',
        highlightedWords: ['mother', 'clean', 'tidy'],
      ),
      const StoryPage(
        pageNumber: 5,
        text: 'It is breakfast time. Ayaan and Maryam help set the spoons on the table.',
        illustrationAssetPath: 'assets/images/stories/helping_home/page_5.png',
        narrationAudioUrl: 'assets/audio/stories/helping_home/page_5.mp3',
        highlightedWords: ['table', 'spoons'],
      ),
      const StoryPage(
        pageNumber: 6,
        text: 'Everyone sits around the table. Father says: "Let us begin with Bismillah."',
        illustrationAssetPath: 'assets/images/stories/helping_home/page_6.png',
        narrationAudioUrl: 'assets/audio/stories/helping_home/page_6.mp3',
        highlightedWords: ['Bismillah', 'father'],
      ),
      const StoryPage(
        pageNumber: 7,
        text: 'They eat with their right hands and share the warm, fresh bread.',
        illustrationAssetPath: 'assets/images/stories/helping_home/page_7.png',
        narrationAudioUrl: 'assets/audio/stories/helping_home/page_7.mp3',
        highlightedWords: ['right hand', 'bread'],
      ),
      const StoryPage(
        pageNumber: 8,
        text: 'They finish their delicious meal and say together: "Alhamdulillah for our loving family!"',
        illustrationAssetPath: 'assets/images/stories/helping_home/page_8.png',
        narrationAudioUrl: 'assets/audio/stories/helping_home/page_8.mp3',
        highlightedWords: ['Alhamdulillah', 'family'],
      ),
    ];

    final story2Quiz = [
      const StoryQuestion(
        id: 'q1_home_help',
        prompt: 'Who did Ayaan and Maryam help at home?',
        options: ['Their Mother and Father 👨‍👩‍👧‍👦', 'Nobody', 'A stranger'],
        correctOptionIndex: 0,
        explanation: 'Helping our parents brings immense joy and blessings to the home.',
      ),
      const StoryQuestion(
        id: 'q2_clean_room',
        prompt: 'Where did Maryam arrange her colorful storybooks?',
        options: ['On the floor', 'On the wooden shelf 📚', 'Under the bed'],
        correctOptionIndex: 1,
        explanation: 'Keeping books neatly on shelves is a great habit of cleanliness (Taharah).',
      ),
      const StoryQuestion(
        id: 'q3_meal_bismillah',
        prompt: 'What did the family say before eating their breakfast?',
        options: ['Goodbye', 'Nothing', 'Bismillah 🍽️'],
        correctOptionIndex: 2,
        explanation: 'Saying Bismillah before eating brings barakah and light to our meal.',
      ),
      const StoryQuestion(
        id: 'q4_sunnah_hand',
        prompt: 'Which hand did the children use to eat politely?',
        options: ['Right hand ✋', 'Left hand', 'Both hands'],
        correctOptionIndex: 0,
        explanation: 'Eating with the right hand is a beautiful Sunnah of our Prophet ﷺ.',
      ),
    ];

    final story2 = Story(
      id: 'story_helping_home',
      worldId: 'world_home',
      title: 'Helping at Home',
      subtitle: 'Tidy rooms, help set the table, and practice filial respect and Sunnah manners.',
      coverAssetPath: 'assets/images/stories/helping_home/cover.png',
      pages: story2Pages,
      comprehensionQuestions: story2Quiz,
      metadata: const ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Household vocabulary, helping at home, and respecting parents.',
        vocabularyTags: ['room', 'table', 'bed', 'book', 'clean', 'mother', 'father', 'food'],
        valueTags: ['respect_for_parents', 'cleanliness', 'bismillah', 'gratitude'],
        worldId: 'world_home',
        status: PublishedStatus.published,
      ),
      connectedIslamicValueIds: const ['value_respect_parents'],
    );

    // ----------------------------------------------------
    // STORY 3: The Honest Pencil (World 3)
    // ----------------------------------------------------
    final story3Pages = [
      const StoryPage(
        pageNumber: 1,
        text: 'Ayaan and Maryam arrive at school carrying their bright school bags.',
        illustrationAssetPath: 'assets/images/stories/honest_pencil/page_1.png',
        narrationAudioUrl: 'assets/audio/stories/honest_pencil/page_1.mp3',
        highlightedWords: ['school', 'bags'],
      ),
      const StoryPage(
        pageNumber: 2,
        text: 'Inside the classroom, the teacher says: "Good morning, students!" Ayaan replies: "Good morning, teacher!"',
        illustrationAssetPath: 'assets/images/stories/honest_pencil/page_2.png',
        narrationAudioUrl: 'assets/audio/stories/honest_pencil/page_2.mp3',
        highlightedWords: ['classroom', 'teacher'],
      ),
      const StoryPage(
        pageNumber: 3,
        text: 'Ayaan sits at his desk. He opens his book and takes out his yellow pencil.',
        illustrationAssetPath: 'assets/images/stories/honest_pencil/page_3.png',
        narrationAudioUrl: 'assets/audio/stories/honest_pencil/page_3.mp3',
        highlightedWords: ['desk', 'book', 'pencil'],
      ),
      const StoryPage(
        pageNumber: 4,
        text: 'On the floor near the bookshelf, Ayaan spots a shiny blue pencil.',
        illustrationAssetPath: 'assets/images/stories/honest_pencil/page_4.png',
        narrationAudioUrl: 'assets/audio/stories/honest_pencil/page_4.mp3',
        highlightedWords: ['pencil', 'floor'],
      ),
      const StoryPage(
        pageNumber: 5,
        text: 'Ayaan holds the blue pencil. He remembers: "Allah loves truthfulness. This is not my pencil."',
        illustrationAssetPath: 'assets/images/stories/honest_pencil/page_5.png',
        narrationAudioUrl: 'assets/audio/stories/honest_pencil/page_5.mp3',
        highlightedWords: ['truthfulness', 'pencil'],
      ),
      const StoryPage(
        pageNumber: 6,
        text: 'Ayaan walks to the teacher and says politely: "Teacher, I found this pencil on the floor."',
        illustrationAssetPath: 'assets/images/stories/honest_pencil/page_6.png',
        narrationAudioUrl: 'assets/audio/stories/honest_pencil/page_6.mp3',
        highlightedWords: ['teacher', 'pencil'],
      ),
      const StoryPage(
        pageNumber: 7,
        text: 'His friend Tariq smiles and says: "That is my pencil! Thank you, Ayaan!" Ayaan replies: "You\'re welcome!"',
        illustrationAssetPath: 'assets/images/stories/honest_pencil/page_7.png',
        narrationAudioUrl: 'assets/audio/stories/honest_pencil/page_7.mp3',
        highlightedWords: ['friend', 'thank you'],
      ),
      const StoryPage(
        pageNumber: 8,
        text: 'The teacher smiles: "MashaAllah! Truthfulness (Sidq) and kindness bring light and trust to our classroom."',
        illustrationAssetPath: 'assets/images/stories/honest_pencil/page_8.png',
        narrationAudioUrl: 'assets/audio/stories/honest_pencil/page_8.mp3',
        highlightedWords: ['Sidq', 'classroom'],
      ),
    ];

    final story3Quiz = [
      const StoryQuestion(
        id: 'q1_found_item',
        prompt: 'What did Ayaan find on the classroom floor?',
        options: ['A shiny blue pencil ✏️', 'A football ⚽', 'An apple 🍎'],
        correctOptionIndex: 0,
        explanation: 'Ayaan found a shiny blue pencil on the classroom floor.',
      ),
      const StoryQuestion(
        id: 'q2_honest_thought',
        prompt: 'What did Ayaan remember when holding the pencil?',
        options: ['Hide it in his pocket', 'Allah loves truthfulness (Sidq) 🌟', 'Throw it away'],
        correctOptionIndex: 1,
        explanation: 'Ayaan remembered that Allah loves honest explorers who return lost items.',
      ),
      const StoryQuestion(
        id: 'q3_tell_teacher',
        prompt: 'Who did Ayaan speak to in order to return the pencil?',
        options: ['The teacher and his friend Tariq 👨‍🏫', 'Nobody', 'He kept it'],
        correctOptionIndex: 0,
        explanation: 'Ayaan told his teacher politely and returned the pencil to Tariq.',
      ),
      const StoryQuestion(
        id: 'q4_polite_reply',
        prompt: 'What polite words did Tariq and Ayaan say to each other?',
        options: ['"Thank you!" and "You\'re welcome!" 🤲', '"Give me that!"', 'Nothing'],
        correctOptionIndex: 0,
        explanation: 'Using polite speech builds friendship and trust in the classroom.',
      ),
    ];

    final story3 = Story(
      id: 'story_honest_pencil',
      worldId: 'world_school',
      title: 'The Honest Pencil',
      subtitle: 'Ayaan finds a lost pencil in class, remembers Allah loves truthfulness (Sidq), and returns it to his friend.',
      coverAssetPath: 'assets/images/stories/honest_pencil/cover.png',
      pages: story3Pages,
      comprehensionQuestions: story3Quiz,
      metadata: const ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Classroom dialogue, truthfulness (Sidq), and respectful peer relationships.',
        vocabularyTags: ['school', 'classroom', 'teacher', 'pencil', 'book', 'desk', 'friend', 'honest', 'thank_you'],
        valueTags: ['honesty', 'sidq', 'respect_for_teachers', 'politeness'],
        worldId: 'world_school',
        status: PublishedStatus.published,
      ),
      connectedIslamicValueIds: const ['value_honesty'],
    );

    // ----------------------------------------------------
    // STORY 4: The Picnic of Sharing (World 4)
    // ----------------------------------------------------
    final story4Pages = [
      const StoryPage(
        pageNumber: 1,
        text: 'Ayaan, Maryam, and Mother pack a picnic basket with fresh fruit, warm bread, and cool water.',
        illustrationAssetPath: 'assets/images/stories/picnic_sharing/page_1.png',
        narrationAudioUrl: 'assets/audio/stories/picnic_sharing/page_1.mp3',
        highlightedWords: ['picnic', 'basket', 'fruit', 'bread'],
      ),
      const StoryPage(
        pageNumber: 2,
        text: 'Before touching any food, Ayaan and Maryam wash their hands cleanly with soap and water.',
        illustrationAssetPath: 'assets/images/stories/picnic_sharing/page_2.png',
        narrationAudioUrl: 'assets/audio/stories/picnic_sharing/page_2.mp3',
        highlightedWords: ['wash', 'hands', 'cleanly'],
      ),
      const StoryPage(
        pageNumber: 3,
        text: 'They sit together on the green grass. Mother smiles and says: "Let us say Bismillah before eating."',
        illustrationAssetPath: 'assets/images/stories/picnic_sharing/page_3.png',
        narrationAudioUrl: 'assets/audio/stories/picnic_sharing/page_3.mp3',
        highlightedWords: ['Bismillah', 'eating'],
      ),
      const StoryPage(
        pageNumber: 4,
        text: 'Ayaan has two sweet red apples. He hands one apple to Maryam with a cheerful smile.',
        illustrationAssetPath: 'assets/images/stories/picnic_sharing/page_4.png',
        narrationAudioUrl: 'assets/audio/stories/picnic_sharing/page_4.mp3',
        highlightedWords: ['apples', 'hands', 'smile'],
      ),
      const StoryPage(
        pageNumber: 5,
        text: 'Maryam shares her ripe yellow banana with Ayaan: "Here you go, brother! Sharing brings joy!"',
        illustrationAssetPath: 'assets/images/stories/picnic_sharing/page_5.png',
        narrationAudioUrl: 'assets/audio/stories/picnic_sharing/page_5.mp3',
        highlightedWords: ['shares', 'banana', 'joy'],
      ),
      const StoryPage(
        pageNumber: 6,
        text: 'They take only what they need so no food is wasted. Maryam drinks water with her right hand.',
        illustrationAssetPath: 'assets/images/stories/picnic_sharing/page_6.png',
        narrationAudioUrl: 'assets/audio/stories/picnic_sharing/page_6.mp3',
        highlightedWords: ['water', 'right hand', 'wasted'],
      ),
      const StoryPage(
        pageNumber: 7,
        text: 'They finish eating and say together: "Alhamdulillah for these delicious blessings!"',
        illustrationAssetPath: 'assets/images/stories/picnic_sharing/page_7.png',
        narrationAudioUrl: 'assets/audio/stories/picnic_sharing/page_7.mp3',
        highlightedWords: ['Alhamdulillah', 'delicious'],
      ),
      const StoryPage(
        pageNumber: 8,
        text: 'Together, they clean the picnic mat and leave the park spotless and tidy.',
        illustrationAssetPath: 'assets/images/stories/picnic_sharing/page_8.png',
        narrationAudioUrl: 'assets/audio/stories/picnic_sharing/page_8.mp3',
        highlightedWords: ['clean', 'tidy', 'spotless'],
      ),
    ];

    final story4Quiz = [
      const StoryQuestion(
        id: 'q1_picnic_basket',
        prompt: 'What healthy items did the family pack in their picnic basket?',
        options: ['Fresh fruit, bread, and water 🍎🥖💧', 'Toys and stones', 'Sandwiches only'],
        correctOptionIndex: 0,
        explanation: 'They packed delicious fresh fruit, bread, and cool water.',
      ),
      const StoryQuestion(
        id: 'q2_wash_hands',
        prompt: 'What did Ayaan and Maryam do before eating?',
        options: ['Washed their hands cleanly 🧼', 'Jumped in the mud', 'Started running'],
        correctOptionIndex: 0,
        explanation: 'Washing hands before eating is a healthy and clean Sunnah habit.',
      ),
      const StoryQuestion(
        id: 'q3_share_fruit',
        prompt: 'What did Ayaan do with his two red apples?',
        options: ['Shared one with Maryam 🤝', 'Hid both apples', 'Ate both quickly'],
        correctOptionIndex: 0,
        explanation: 'Ayaan practiced generosity (Ithaar) by sharing his apple.',
      ),
      const StoryQuestion(
        id: 'q4_avoid_waste',
        prompt: 'How did the children make sure no food was wasted?',
        options: ['They took only what they needed 🍽️', 'They threw food away', 'They left extra food behind'],
        correctOptionIndex: 0,
        explanation: 'Taking what we need protects Allah\'s blessings (Hifz al-Ni\'mah).',
      ),
      const StoryQuestion(
        id: 'q5_after_meal_dua',
        prompt: 'What did they say after finishing their meal?',
        options: ['Alhamdulillah 🌟', 'Goodbye', 'Nothing'],
        correctOptionIndex: 0,
        explanation: 'Saying Alhamdulillah expresses gratitude to Allah for providing our food.',
      ),
    ];

    final story4 = Story(
      id: 'story_picnic_sharing',
      worldId: 'world_food',
      title: 'The Picnic of Sharing',
      subtitle: 'Ayaan and Maryam enjoy a picnic, wash hands, share fruit, avoid waste, and say Alhamdulillah.',
      coverAssetPath: 'assets/images/stories/picnic_sharing/cover.png',
      pages: story4Pages,
      comprehensionQuestions: story4Quiz,
      metadata: const ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Food vocabulary, counting, dining Sunnah, sharing (Ithaar), and avoiding waste.',
        vocabularyTags: ['apple', 'banana', 'fruit', 'bread', 'water', 'wash', 'share', 'clean', 'Alhamdulillah'],
        valueTags: ['gratitude', 'sharing', 'ithaar', 'cleanliness', 'avoiding_waste'],
        worldId: 'world_food',
        status: PublishedStatus.published,
      ),
      connectedIslamicValueIds: const ['value_sharing', 'value_avoid_waste'],
    );

    // ----------------------------------------------------
    // STORY 5: The Rainy Day Adventure (World 5)
    // ----------------------------------------------------
    final story5Pages = [
      const StoryPage(
        pageNumber: 1,
        text: 'Ayaan and Maryam prepare for an outdoor walk. They look up at the sky and see gray clouds.',
        illustrationAssetPath: 'assets/images/stories/rainy_adventure/page_1.png',
        narrationAudioUrl: 'assets/audio/stories/rainy_adventure/page_1.mp3',
        highlightedWords: ['walk', 'sky', 'clouds'],
      ),
      const StoryPage(
        pageNumber: 2,
        text: 'Pip flutters down to a tall green tree. "Look!" chirps Pip, "There is a big oak tree!"',
        illustrationAssetPath: 'assets/images/stories/rainy_adventure/page_2.png',
        narrationAudioUrl: 'assets/audio/stories/rainy_adventure/page_2.mp3',
        highlightedWords: ['tree', 'green', 'look'],
      ),
      const StoryPage(
        pageNumber: 3,
        text: 'Gentle raindrops begin to fall from the sky: Pitter, patter! "It is raining!" says Maryam happily.',
        illustrationAssetPath: 'assets/images/stories/rainy_adventure/page_3.png',
        narrationAudioUrl: 'assets/audio/stories/rainy_adventure/page_3.mp3',
        highlightedWords: ['raindrops', 'raining', 'sky'],
      ),
      const StoryPage(
        pageNumber: 4,
        text: 'Ayaan notices a tiny little flower bent under heavy water. He gently places a big leaf over it to protect it.',
        illustrationAssetPath: 'assets/images/stories/rainy_adventure/page_4.png',
        narrationAudioUrl: 'assets/audio/stories/rainy_adventure/page_4.mp3',
        highlightedWords: ['flower', 'leaf', 'protect'],
      ),
      const StoryPage(
        pageNumber: 5,
        text: 'They spot a cheerful bird singing on a high branch. "Look, there is a bird!" whispers Ayaan gently.',
        illustrationAssetPath: 'assets/images/stories/rainy_adventure/page_5.png',
        narrationAudioUrl: 'assets/audio/stories/rainy_adventure/page_5.mp3',
        highlightedWords: ['bird', 'branch', 'whispers'],
      ),
      const StoryPage(
        pageNumber: 6,
        text: 'On the walking path, Maryam sees an empty snack bag left by someone. She picks it up and puts it in the bin.',
        illustrationAssetPath: 'assets/images/stories/rainy_adventure/page_6.png',
        narrationAudioUrl: 'assets/audio/stories/rainy_adventure/page_6.mp3',
        highlightedWords: ['path', 'bin', 'clean'],
      ),
      const StoryPage(
        pageNumber: 7,
        text: 'The dark rain clouds float away and the bright sun shines warmly. "The sun is hot and bright!" smiles Ayaan.',
        illustrationAssetPath: 'assets/images/stories/rainy_adventure/page_7.png',
        narrationAudioUrl: 'assets/audio/stories/rainy_adventure/page_7.mp3',
        highlightedWords: ['sun', 'hot', 'shines'],
      ),
      const StoryPage(
        pageNumber: 8,
        text: 'A colorful rainbow appears across the clear blue sky! They raise their hands and say: "Alhamdulillah for beautiful nature!"',
        illustrationAssetPath: 'assets/images/stories/rainy_adventure/page_8.png',
        narrationAudioUrl: 'assets/audio/stories/rainy_adventure/page_8.mp3',
        highlightedWords: ['rainbow', 'nature', 'Alhamdulillah'],
      ),
    ];

    final story5Quiz = [
      const StoryQuestion(
        id: 'q_story5_1',
        prompt: 'What did Ayaan and Maryam see up in the sky before the rain started?',
        options: ['Gray clouds ☁️', 'A flying car', 'Stars'],
        correctOptionIndex: 0,
        explanation: 'Gray rain clouds show that rain is coming soon.',
      ),
      const StoryQuestion(
        id: 'q_story5_2',
        prompt: 'How did Ayaan help protect the tiny flower?',
        options: ['He placed a protective leaf over it 🌿', 'He stepped on it', 'He pulled it out'],
        correctOptionIndex: 0,
        explanation: 'Caring for living plants shows gentle kindness to nature.',
      ),
      const StoryQuestion(
        id: 'q_story5_3',
        prompt: 'What did Maryam do when she saw litter on the park pathway?',
        options: ['She picked it up and put it in the bin 🗑️', 'She threw more trash', 'She ignored it'],
        correctOptionIndex: 0,
        explanation: 'Keeping parks clean and picking up trash is part of Taharah and good manners.',
      ),
      const StoryQuestion(
        id: 'q_story5_4',
        prompt: 'How was the weather after the rain clouds floated away?',
        options: ['Sunny and warm ☀️', 'Snowy and freezing', 'Dark night'],
        correctOptionIndex: 0,
        explanation: 'The sun came out bright and warm after the rain.',
      ),
      const StoryQuestion(
        id: 'q_story5_5',
        prompt: 'What colorful wonder appeared across the sky at the end of their walk?',
        options: ['A bright rainbow 🌈', 'A rocket ship', 'A giant kite'],
        correctOptionIndex: 0,
        explanation: 'A rainbow appeared across the sky and they thanked Allah (Alhamdulillah).',
      ),
    ];

    final story5 = Story(
      id: 'story_rainy_adventure',
      worldId: 'world_nature',
      title: 'The Rainy Day Adventure',
      subtitle: 'Ayaan and Maryam explore a rainy park, care for plants, keep pathways clean, and see a rainbow.',
      coverAssetPath: 'assets/images/stories/rainy_adventure/cover.png',
      pages: story5Pages,
      comprehensionQuestions: story5Quiz,
      metadata: const ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Nature & weather vocabulary, There is/are, care for creation, and cleanliness.',
        vocabularyTags: ['tree', 'flower', 'leaf', 'sun', 'rain', 'cloud', 'bird', 'rainbow', 'Alhamdulillah'],
        valueTags: ['gratitude', 'care_for_nature', 'taharah', 'kindness'],
        worldId: 'world_nature',
        status: PublishedStatus.published,
      ),
      connectedIslamicValueIds: const ['value_creation_gratitude', 'value_care_for_nature'],
    );

    _stories[story1.id] = story1;
    _stories[story2.id] = story2;
    _stories[story3.id] = story3;
    _stories[story4.id] = story4;
    _stories[story5.id] = story5;
  }

  List<Story> getAllStories() => _stories.values.toList();

  @override
  Future<Story?> getStoryById(String id) async => _stories[id];

  @override
  Future<List<Story>> getStoriesForWorld(String worldId) async {
    return _stories.values.where((s) => s.metadata.worldId == worldId).toList();
  }
}
