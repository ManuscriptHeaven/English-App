import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import '../domain/models/islamic_value.dart';
import '../domain/models/manner.dart';
import '../domain/models/value_connection.dart';
import '../domain/repositories/islamic_values_repository.dart';

/// Seeded repository for Islamic Values & Manners across Worlds 1, 2, and 3.
class MockIslamicValuesRepository implements IIslamicValuesRepository {
  final Map<String, IslamicValue> _values = {};
  final Map<String, Manner> _manners = {};
  final List<ValueConnection> _connections = [];

  MockIslamicValuesRepository() {
    _seedValues();
  }

  void _seedValues() {
    // ----------------------------------------------------
    // WORLD 1 VALUES
    // ----------------------------------------------------
    _values['value_kindness_animals'] = const IslamicValue(
      id: 'value_kindness_animals',
      title: 'Kindness to Animals',
      arabicPhrase: 'Rahmah (Mercy)',
      englishMeaning: 'Showing gentle love and care to all living creatures',
      childExplanation: 'Allah created animals with love. When we feed them or use gentle hands, Allah is pleased with our kind hearts!',
      positiveActionPrompt: 'Give cool water to a pet or bird today, and stroke gently with soft hands!',
      category: IslamicValueCategory.kindness,
      iconName: 'pets',
      primaryColorHex: '0xFF00897B',
      sourceType: 'sunnah_habit',
      sourceReference: 'Sahih al-Bukhari 3321',
      reviewStatus: 'verified_child_safe',
      metadata: ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Understand empathy, gentleness, and mercy toward animals.',
        valueTags: ['rahmah', 'mercy', 'gentleness'],
        worldId: 'world_animal',
        status: PublishedStatus.published,
      ),
    );

    // ----------------------------------------------------
    // WORLD 2 VALUES
    // ----------------------------------------------------
    _values['value_respect_parents'] = const IslamicValue(
      id: 'value_respect_parents',
      title: 'Respect for Parents',
      arabicPhrase: 'Birr al-Walidayn',
      englishMeaning: 'Loving, helping, and speaking kindly to Mother and Father',
      childExplanation: 'Our parents care for us with so much love. Helping them and speaking with soft, happy voices brings Allah’s blessings!',
      positiveActionPrompt: 'Give your mother or father a big hug and say "Thank you for taking care of me!"',
      category: IslamicValueCategory.respectForParents,
      iconName: 'family_restroom',
      primaryColorHex: '0xFFFFA726',
      sourceType: 'quran_principle',
      sourceReference: 'Surah Luqman 31:14',
      reviewStatus: 'verified_child_safe',
      metadata: ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Develop gratitude, obedience, and loving respect for parents.',
        valueTags: ['birr', 'parents', 'family', 'love'],
        worldId: 'world_home',
        status: PublishedStatus.published,
      ),
    );

    _values['value_cleanliness'] = const IslamicValue(
      id: 'value_cleanliness',
      title: 'Cleanliness & Tidiness',
      arabicPhrase: 'Taharah (Purity)',
      englishMeaning: 'Keeping our bodies, clothes, and homes clean and organized',
      childExplanation: 'Cleanliness is half of faith! Putting toys in boxes and washing our hands keeps our space joyful and bright.',
      positiveActionPrompt: 'Help tidy your room and put your books neatly on the shelf today!',
      category: IslamicValueCategory.cleanliness,
      iconName: 'cleaning_services',
      primaryColorHex: '0xFF42A5F5',
      sourceType: 'sunnah_habit',
      sourceReference: 'Sahih Muslim 223',
      reviewStatus: 'verified_child_safe',
      metadata: ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Adopt daily hygiene, room tidiness, and organizing habits.',
        valueTags: ['taharah', 'cleanliness', 'neatness'],
        worldId: 'world_home',
        status: PublishedStatus.published,
      ),
    );

    _values['value_gratitude'] = const IslamicValue(
      id: 'value_gratitude',
      title: 'Gratitude for Food',
      arabicPhrase: 'Shukr & Bismillah',
      englishMeaning: 'Thanking Allah for delicious food and never wasting',
      childExplanation: 'Saying Bismillah before eating and Alhamdulillah when finished brings barakah and happiness to our meal!',
      positiveActionPrompt: 'Remember to eat with your right hand and say Bismillah with a big smile!',
      category: IslamicValueCategory.gratitude,
      iconName: 'restaurant',
      primaryColorHex: '0xFFEF5350',
      sourceType: 'sunnah_habit',
      sourceReference: 'Sahih al-Bukhari 5376',
      reviewStatus: 'verified_child_safe',
      metadata: ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Practice Islamic dining etiquette and gratitude.',
        valueTags: ['bismillah', 'alhamdulillah', 'gratitude'],
        worldId: 'world_home',
        status: PublishedStatus.published,
      ),
    );

    // ----------------------------------------------------
    // WORLD 3 VALUES (School & Classroom)
    // ----------------------------------------------------
    _values['value_honesty'] = const IslamicValue(
      id: 'value_honesty',
      title: 'Honesty & Truthfulness',
      arabicPhrase: 'Sidq (Truthfulness)',
      englishMeaning: 'Always telling the truth and returning things that belong to others',
      childExplanation: 'Allah loves truthful explorers! When we find something lost, we give it back to its owner with a clean heart.',
      positiveActionPrompt: 'If you find a lost pencil or book at school, hand it to the teacher right away!',
      category: IslamicValueCategory.honesty,
      iconName: 'verified',
      primaryColorHex: '0xFF42A5F5',
      sourceType: 'hadith_authentic',
      sourceReference: 'Sahih al-Bukhari 6094',
      reviewStatus: 'verified_child_safe',
      metadata: ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Practice truthfulness and returning lost items in classroom settings.',
        valueTags: ['sidq', 'honesty', 'trust', 'truthfulness'],
        worldId: 'world_school',
        status: PublishedStatus.published,
      ),
    );

    _values['value_respect_teachers'] = const IslamicValue(
      id: 'value_respect_teachers',
      title: 'Respect for Teachers & Friends',
      arabicPhrase: 'Ihtiram (Respect)',
      englishMeaning: 'Listening respectfully to teachers and speaking kindly to classmates',
      childExplanation: 'Teachers guide us toward knowledge. Greeting them with Salaam and using polite words brings joy to the classroom!',
      positiveActionPrompt: 'Say "Good morning teacher" and "Please / Thank you" to your friends!',
      category: IslamicValueCategory.respectForTeachers,
      iconName: 'school',
      primaryColorHex: '0xFF7E57C2',
      sourceType: 'sunnah_habit',
      sourceReference: 'Jami` at-Tirmidhi 1985',
      reviewStatus: 'verified_child_safe',
      metadata: ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Exhibit polite classroom communication and respect for educators.',
        valueTags: ['respect', 'teachers', 'friendship', 'politeness'],
        worldId: 'world_school',
        status: PublishedStatus.published,
      ),
    );

    // ----------------------------------------------------
    // WORLD 4 VALUES (Delicious Food)
    // ----------------------------------------------------
    _values['value_sharing'] = const IslamicValue(
      id: 'value_sharing',
      title: 'Sharing & Generosity',
      arabicPhrase: 'Ithaar (Generosity)',
      englishMeaning: 'Sharing delicious food and treats gladly with family and friends',
      childExplanation: 'Sharing doubles our happiness! When we offer a piece of fruit or share our snack, Allah fills our hearts with light.',
      positiveActionPrompt: 'Share a piece of sweet fruit or your favorite snack with a friend today!',
      category: IslamicValueCategory.generosityAndSharing,
      iconName: 'volunteer_activism',
      primaryColorHex: '0xFFEF5350',
      sourceType: 'hadith_authentic',
      sourceReference: 'Sahih Muslim 2059',
      reviewStatus: 'verified_child_safe',
      metadata: ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Practice generosity and sharing meals with others.',
        valueTags: ['ithaar', 'sharing', 'generosity', 'food'],
        worldId: 'world_food',
        status: PublishedStatus.published,
      ),
    );

    _values['value_avoid_waste'] = const IslamicValue(
      id: 'value_avoid_waste',
      title: 'Blessing & Avoiding Waste',
      arabicPhrase: 'Hifz al-Ni\'mah',
      englishMeaning: 'Valuing food and never throwing away clean food or water',
      childExplanation: 'Food is a special gift from Allah. Taking just what we need and finishing our plate shows true gratitude!',
      positiveActionPrompt: 'Take small portions so you finish all the food on your plate happily!',
      category: IslamicValueCategory.responsibility,
      iconName: 'eco',
      primaryColorHex: '0xFF66BB6A',
      sourceType: 'quran_principle',
      sourceReference: 'Surah Al-A\'raf 7:31',
      reviewStatus: 'verified_child_safe',
      metadata: ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Avoid food waste and appreciate Allah\'s blessings.',
        valueTags: ['waste', 'gratitude', 'blessing', 'food'],
        worldId: 'world_food',
        status: PublishedStatus.published,
      ),
    );
    _manners['manner_gentle_animals'] = const Manner(
      id: 'manner_gentle_animals',
      title: 'Gentle Hands with Animals',
      practicalHabit: 'Never pull tails, shout loudly, or scare animals. Offer water gently.',
      childFriendlyDuasOrPhrase: 'Bismillah, gentle hands',
      englishTranslation: 'In the name of Allah, with soft care',
      contextualSituation: 'When touching or feeding pets',
      associatedValueId: 'value_kindness_animals',
      metadata: ContentMetadata(
        learningObjective: 'Animal care etiquette.',
        worldId: 'world_animal',
        status: PublishedStatus.published,
      ),
    );

    _manners['manner_help_home'] = const Manner(
      id: 'manner_help_home',
      title: 'Helping at Home',
      practicalHabit: 'Put toys in the basket, arrange books, and help clear the dining table.',
      childFriendlyDuasOrPhrase: 'BarakAllahu Feekum',
      englishTranslation: 'May Allah bless you',
      contextualSituation: 'Tidying room and helping parents',
      associatedValueId: 'value_respect_parents',
      metadata: ContentMetadata(
        learningObjective: 'Home helpfulness and respecting parents.',
        worldId: 'world_home',
        status: PublishedStatus.published,
      ),
    );

    _manners['manner_eating_sunnah'] = const Manner(
      id: 'manner_eating_sunnah',
      title: 'Dining Sunnah',
      practicalHabit: 'Say Bismillah, use your right hand, and do not waste clean food or water.',
      childFriendlyDuasOrPhrase: 'Bismillah / Alhamdulillah',
      englishTranslation: 'In the name of Allah / Praise be to Allah',
      contextualSituation: 'Before and after eating meals',
      associatedValueId: 'value_gratitude',
      metadata: ContentMetadata(
        learningObjective: 'Sunnah eating habits.',
        worldId: 'world_home',
        status: PublishedStatus.published,
      ),
    );

    _manners['manner_honesty_sidq'] = const Manner(
      id: 'manner_honesty_sidq',
      title: 'Truthfulness & Amanah',
      practicalHabit: 'Tell the truth always and hand lost belongings to the teacher.',
      childFriendlyDuasOrPhrase: 'As-Sidqu Najah (Truthfulness is success)',
      englishTranslation: 'Truthfulness leads to success',
      contextualSituation: 'Finding lost items or answering questions in class',
      associatedValueId: 'value_honesty',
      metadata: ContentMetadata(
        learningObjective: 'Honesty in the classroom.',
        worldId: 'world_school',
        status: PublishedStatus.published,
      ),
    );

    _manners['manner_polite_speech'] = const Manner(
      id: 'manner_polite_speech',
      title: 'Polite Requests & Good Speech',
      practicalHabit: 'Say "Please", "Thank you", "Excuse me", and "Can I help you?".',
      childFriendlyDuasOrPhrase: 'JazakAllahu Khayran',
      englishTranslation: 'May Allah reward you with goodness',
      contextualSituation: 'Borrowing items and speaking with classmates',
      associatedValueId: 'value_respect_teachers',
      metadata: ContentMetadata(
        learningObjective: 'Polite English classroom dialogue.',
        worldId: 'world_school',
        status: PublishedStatus.published,
      ),
    );

    _manners['manner_sharing_food'] = const Manner(
      id: 'manner_sharing_food',
      title: 'Sharing Meals & Treats',
      practicalHabit: 'Offer fruit and snacks gladly with brothers, sisters, and classmates.',
      childFriendlyDuasOrPhrase: 'Haniy\'an Mariy\'an',
      englishTranslation: 'May it bring health and joy',
      contextualSituation: 'Eating lunch, snacks, or fruit with others',
      associatedValueId: 'value_sharing',
      metadata: ContentMetadata(
        learningObjective: 'Sharing food etiquette.',
        worldId: 'world_food',
        status: PublishedStatus.published,
      ),
    );

    _manners['manner_avoid_waste'] = const Manner(
      id: 'manner_avoid_waste',
      title: 'Taking Only What You Need',
      practicalHabit: 'Take small portions and finish your plate cleanly to avoid wasting blessings.',
      childFriendlyDuasOrPhrase: 'Alhamdulillah',
      englishTranslation: 'Praise be to Allah',
      contextualSituation: 'Serving meals and eating',
      associatedValueId: 'value_avoid_waste',
      metadata: ContentMetadata(
        learningObjective: 'Avoiding food waste etiquette.',
        worldId: 'world_food',
        status: PublishedStatus.published,
      ),
    );

    // ----------------------------------------------------
    // WORLD 5 VALUES (Nature & Weather)
    // ----------------------------------------------------
    _values['value_creation_gratitude'] = const IslamicValue(
      id: 'value_creation_gratitude',
      title: 'Gratitude for Creation',
      arabicPhrase: 'Tafakkur & Hamd',
      englishMeaning: 'Appreciating the beauty of Allah\'s creation (trees, rain, sky, sun)',
      childExplanation: 'Allah created the beautiful green trees, the bright sun, and the fresh rain for us! We say Alhamdulillah when we see nature.',
      positiveActionPrompt: 'Look at the sky or a green tree and say "SubhanAllah, Alhamdulillah" with a happy heart!',
      category: IslamicValueCategory.gratitude,
      iconName: 'park',
      primaryColorHex: '0xFF4CAF50',
      sourceType: 'quran_principle',
      sourceReference: 'Surah Ibrahim 14:7',
      reviewStatus: 'verified_child_safe',
      metadata: ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Appreciate Allah\'s creation and show gratitude.',
        valueTags: ['tafakkur', 'nature', 'weather', 'gratitude', 'creation'],
        worldId: 'world_nature',
        status: PublishedStatus.published,
      ),
    );

    _values['value_care_for_nature'] = const IslamicValue(
      id: 'value_care_for_nature',
      title: 'Care for Nature & Cleanliness',
      arabicPhrase: 'Taharah & Ihsan',
      englishMeaning: 'Keeping outdoor parks clean, not littering, and caring for plants',
      childExplanation: 'We protect our parks and plants by throwing litter into the bin and walking gently near flowers!',
      positiveActionPrompt: 'Always put your snack wrappers in the bin to keep our outdoor world clean!',
      category: IslamicValueCategory.responsibility,
      iconName: 'eco',
      primaryColorHex: '0xFF2E7D32',
      sourceType: 'hadith_authentic',
      sourceReference: 'Sahih Muslim 223',
      reviewStatus: 'verified_child_safe',
      metadata: ContentMetadata(
        minAge: 3,
        maxAge: 10,
        difficulty: DifficultyLevel.beginner,
        learningObjective: 'Keep outdoor nature clean and care for living plants.',
        valueTags: ['taharah', 'cleanliness', 'nature', 'responsibility'],
        worldId: 'world_nature',
        status: PublishedStatus.published,
      ),
    );

    _manners['manner_avoid_littering'] = const Manner(
      id: 'manner_avoid_littering',
      title: 'Keeping Parks Clean',
      practicalHabit: 'Always put trash in the bin and remove harmful objects from pathways.',
      childFriendlyDuasOrPhrase: 'Alhamdulillah, clean nature',
      englishTranslation: 'Praise be to Allah, clean world',
      contextualSituation: 'In parks, gardens, and outdoor pathways',
      associatedValueId: 'value_care_for_nature',
      metadata: ContentMetadata(
        learningObjective: 'Outdoor cleanliness and anti-littering habit.',
        worldId: 'world_nature',
        status: PublishedStatus.published,
      ),
    );

    _manners['manner_gentle_with_plants'] = const Manner(
      id: 'manner_gentle_with_plants',
      title: 'Gentle Hands with Plants & Animals',
      practicalHabit: 'Watch butterflies gently, water plants, and never snap green branches unnecessarily.',
      childFriendlyDuasOrPhrase: 'SubhanAllah',
      englishTranslation: 'Glory be to Allah',
      contextualSituation: 'Walking in gardens and outdoor exploration',
      associatedValueId: 'value_creation_gratitude',
      metadata: ContentMetadata(
        learningObjective: 'Gentle care for living plants and animals.',
        worldId: 'world_nature',
        status: PublishedStatus.published,
      ),
    );

    // ----------------------------------------------------
    // PEDAGOGICAL BRIDGES (VALUE CONNECTIONS)
    // ----------------------------------------------------
    _connections.add(const ValueConnection(
      id: 'conn_animal_care',
      englishObjective: 'Demonstrative pronouns & describing adjectives (big, gentle, small)',
      targetVocabularyTopic: 'Elephant, Cat, Water, Clean, Gentle',
      exampleSentence: 'This is an elephant. We use gentle hands.',
      islamicValueId: 'value_kindness_animals',
      mannerId: 'manner_gentle_animals',
      pedagogicalNote: 'Learners use English descriptive adjectives while building empathy for living creatures.',
    ));

    _connections.add(const ValueConnection(
      id: 'conn_home_help',
      englishObjective: 'Possessives (my/your) and present verbs (clean, help, read)',
      targetVocabularyTopic: 'Room, Table, Book, Mother, Help, Clean',
      exampleSentence: 'This is my room. I help my mother.',
      islamicValueId: 'value_respect_parents',
      mannerId: 'manner_help_home',
      pedagogicalNote: 'Learners practice "This is my room" and "She is helping" while practicing filial respect and tidiness.',
    ));

    _connections.add(const ValueConnection(
      id: 'conn_school_honesty',
      englishObjective: 'Classroom nouns, plural counting, and polite requests',
      targetVocabularyTopic: 'School, Pencil, Book, Teacher, Friend, Honest',
      exampleSentence: 'I have two pencils. Can I borrow a book? Thank you.',
      islamicValueId: 'value_honesty',
      mannerId: 'manner_honesty_sidq',
      pedagogicalNote: 'Learners practice classroom dialogue and countable plurals while practicing honesty and respect.',
    ));

    _connections.add(const ValueConnection(
      id: 'conn_food_sharing',
      englishObjective: 'Food nouns, plurals, and dining expressions (Bismillah, thirsty/hungry)',
      targetVocabularyTopic: 'Apple, Banana, Milk, Bread, Hungry, Thirsty, Share',
      exampleSentence: 'I have two apples. Bismillah! We share with friends.',
      islamicValueId: 'value_sharing',
      mannerId: 'manner_sharing_food',
      pedagogicalNote: 'Learners practice food plurals and likes/dislikes while learning gratitude (Shukr) and sharing (Ithaar).',
    ));

    _connections.add(const ValueConnection(
      id: 'conn_nature_gratitude',
      englishObjective: 'Nature nouns, There is/are, weather descriptions, and gentle care verbs',
      targetVocabularyTopic: 'Tree, Flower, Sun, Rain, Cloud, Windy, Clean',
      exampleSentence: 'There is a tree. It is raining. Alhamdulillah for creation!',
      islamicValueId: 'value_creation_gratitude',
      mannerId: 'manner_avoid_littering',
      pedagogicalNote: 'Learners practice weather sentences and "There is/are" while expressing gratitude (Tafakkur) and keeping parks clean.',
    ));
  }

  @override
  Future<List<IslamicValue>> getAllValues() async => _values.values.toList();

  @override
  Future<IslamicValue?> getValueById(String id) async => _values[id];

  @override
  Future<List<Manner>> getAllManners() async => _manners.values.toList();

  @override
  Future<Manner?> getMannerById(String id) async => _manners[id];

  @override
  Future<List<ValueConnection>> getValueConnectionsForWorld(String worldId) async => _connections;

  @override
  Future<ValueConnection?> getValueConnectionForLesson(String lessonId) async {
    return _connections.isNotEmpty ? _connections.first : null;
  }
}
