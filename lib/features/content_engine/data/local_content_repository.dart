import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import '../domain/models/activity_type.dart';
import '../domain/models/content_item.dart';
import '../domain/models/curriculum_package.dart';
import '../domain/repositories/content_repository.dart';

/// Local offline-first content repository managing curriculum packages across all worlds.
class LocalContentRepository implements IContentRepository {
  final Map<String, CurriculumPackage> _packages = {};

  LocalContentRepository() {
    _seedPackages();
  }

  void _seedPackages() {
    final now = DateTime(2026, 8, 22);

    // ----------------------------------------------------
    // WORLD 4: DELICIOUS FOOD CURRICULUM PACKAGE
    // ----------------------------------------------------
    final foodItems = [
      const ContentItem(
        id: 'food_apple_01',
        activityType: ActivityType.vocabularyDiscovery,
        title: 'Apple',
        description: 'Learn apple, color, and fruit recognition',
        skill: SkillType.vocabulary,
        learningObjective: 'Identify apple and say "This is an apple."',
        contentData: {
          'word': 'Apple',
          'phonetic': '/ˈæp.əl/',
          'emoji': '🍎',
          'sentence': 'This is a sweet red apple.',
          'colorHex': 0xFFEF5350,
          'valueTip': 'Say Alhamdulillah for healthy, sweet fruit created by Allah.',
        },
        valueIds: ['value_gratitude'],
        mannerIds: ['manner_eating_sunnah'],
      ),
      const ContentItem(
        id: 'food_banana_02',
        activityType: ActivityType.vocabularyDiscovery,
        title: 'Banana',
        description: 'Learn banana, color yellow, and peeling fruit',
        skill: SkillType.vocabulary,
        learningObjective: 'Identify banana and say "I have a banana."',
        contentData: {
          'word': 'Banana',
          'phonetic': '/bəˈnɑː.nə/',
          'emoji': '🍌',
          'sentence': 'I have a ripe yellow banana.',
          'colorHex': 0xFFFFA726,
          'valueTip': 'Share fresh fruit with your brothers, sisters, and friends.',
        },
        valueIds: ['value_sharing'],
        mannerIds: ['manner_sharing_food'],
      ),
      const ContentItem(
        id: 'food_milk_03',
        activityType: ActivityType.vocabularyDiscovery,
        title: 'Milk',
        description: 'Learn milk, healthy drinks, and energy',
        skill: SkillType.vocabulary,
        learningObjective: 'Identify milk and understand healthy drinking habits.',
        contentData: {
          'word': 'Milk',
          'phonetic': '/mɪlk/',
          'emoji': '🥛',
          'sentence': 'I drink pure white milk in the morning.',
          'colorHex': 0xFF42A5F5,
          'valueTip': 'Drink with your right hand and remember to say Bismillah.',
        },
        valueIds: ['value_gratitude'],
        mannerIds: ['manner_eating_sunnah'],
      ),
      const ContentItem(
        id: 'food_bread_04',
        activityType: ActivityType.vocabularyDiscovery,
        title: 'Bread',
        description: 'Learn bread, bakery food, and sharing meals',
        skill: SkillType.vocabulary,
        learningObjective: 'Identify bread and practice sharing portions.',
        contentData: {
          'word': 'Bread',
          'phonetic': '/bred/',
          'emoji': '🍞',
          'sentence': 'We share fresh warm bread at breakfast.',
          'colorHex': 0xFF8D6E63,
          'valueTip': 'Never waste bread or food; take only what you will eat.',
        },
        valueIds: ['value_avoid_waste'],
        mannerIds: ['manner_eating_sunnah'],
      ),
      const ContentItem(
        id: 'food_hunt_05',
        activityType: ActivityType.imageHunt,
        title: 'Food Hunt',
        description: 'Find fruit and healthy food in the kitchen market',
        skill: SkillType.vocabulary,
        learningObjective: 'Identify healthy food items from visual prompts.',
        contentData: {
          'targetWord': 'Apple',
          'prompt': 'Find the Apple! 🍎',
          'options': [
            {'word': 'Banana', 'emoji': '🍌'},
            {'word': 'Apple', 'emoji': '🍎'},
            {'word': 'Milk', 'emoji': '🥛'},
          ],
        },
      ),
      const ContentItem(
        id: 'food_grammar_06',
        activityType: ActivityType.fillBlank,
        title: 'Plurals: I Have Two Apples',
        description: 'Form countable plural nouns for food items',
        difficulty: DifficultyLevel.elementary,
        skill: SkillType.grammar,
        learningObjective: 'Form plural sentences like "I have two apples."',
        contentData: {
          'sentencePrefix': 'I have two',
          'visualEmoji': '🍎 🍎',
          'correctWord': 'apples',
          'options': ['apple', 'apples'],
          'rule': 'One apple ➜ Two apples (add "s")',
        },
      ),
      const ContentItem(
        id: 'food_hungry_thirsty_07',
        activityType: ActivityType.multipleChoice,
        title: 'Hungry vs Thirsty',
        description: 'Differentiate hunger (food) from thirst (drinks)',
        skill: SkillType.listening,
        learningObjective: 'Connect "hungry" to food and "thirsty" to water/milk.',
        contentData: {
          'prompt': 'Ayaan says: "I am thirsty!" What should he drink?',
          'options': ['Fresh Water 💧', 'A pencil ✏️', 'A book 📚'],
          'correctIndex': 0,
        },
      ),
      const ContentItem(
        id: 'food_manners_08',
        activityType: ActivityType.scenarioChoice,
        title: 'Dining Sunnah & Gratitude',
        description: 'Remember Bismillah and eating with the right hand',
        skill: SkillType.manners,
        learningObjective: 'Practice Islamic dining etiquette with positive reinforcement.',
        contentData: {
          'prompt': 'What do we say before taking our first bite of food?',
          'options': ['Bismillah 🍽️', 'Goodbye 👋', 'Nothing 😶'],
          'correctIndex': 0,
          'lesson': 'Saying Bismillah invites barakah and blessings into our food!',
        },
        sourceType: 'hadith_authentic',
        sourceReference: 'Sahih al-Bukhari 5376',
      ),
      const ContentItem(
        id: 'food_sharing_09',
        activityType: ActivityType.scenarioChoice,
        title: 'Sharing Fruit with Friends',
        description: 'Practice sharing extra fruit and generosity (Ithaar)',
        skill: SkillType.manners,
        learningObjective: 'Demonstrate generosity and sharing with classmates.',
        contentData: {
          'prompt': 'You have two bananas and your friend has none. What is the kind choice?',
          'options': ['Share one banana with your friend 🤝', 'Eat both quickly 🙈', 'Hide them 🎒'],
          'correctIndex': 0,
          'lesson': 'Sharing our food and blessings brings joy and love!',
        },
        sourceType: 'hadith_authentic',
        sourceReference: 'Sahih Muslim 2059',
      ),
    ];

    final foodPackage = CurriculumPackage(
      id: 'pkg_world_food_v1',
      worldId: 'world_food',
      version: 1,
      title: 'Delicious Food World Curriculum',
      description: 'Food vocabulary, counting, hungry/thirsty, dining Sunnah, and sharing.',
      learningObjectives: const [
        'Identify common fruits, healthy drinks, and tableware.',
        'Construct sentences with "I have..." and plural countables.',
        'Apply Islamic dining etiquette (Bismillah, right hand, Alhamdulillah, sharing).',
      ],
      valueObjectives: const ['Gratitude (Shukr)', 'Sharing (Ithaar)', 'Avoiding Waste (Hifz al-Ni\'mah)'],
      contentItems: foodItems,
      createdAt: now,
      updatedAt: now,
    );

    // ----------------------------------------------------
    // WORLD 5 CONTENT: Nature & Weather Items
    // ----------------------------------------------------
    final natureItems = [
      const ContentItem(
        id: 'nature_tree_01',
        activityType: ActivityType.vocabularyDiscovery,
        title: 'Tree',
        description: 'Learn tall green trees in the park',
        skill: SkillType.vocabulary,
        learningObjective: 'Identify and pronounce "tree".',
        contentData: {
          'word': 'Tree',
          'emoji': '🌳',
          'phonetic': '/triː/',
          'sentence': 'There is a tall green tree in the park.',
          'valueTip': 'Allah made beautiful trees to give shade and fresh air.',
        },
        valueIds: ['value_creation_gratitude'],
        mannerIds: ['manner_gentle_with_plants'],
      ),
      const ContentItem(
        id: 'nature_flower_02',
        activityType: ActivityType.vocabularyDiscovery,
        title: 'Flower',
        description: 'Learn colorful blooming flowers',
        skill: SkillType.vocabulary,
        learningObjective: 'Identify and pronounce "flower".',
        contentData: {
          'word': 'Flower',
          'emoji': '🌸',
          'phonetic': '/ˈflaʊ.ər/',
          'sentence': 'There are colorful flowers blooming in the garden.',
          'valueTip': 'Say SubhanAllah when looking at beautiful flowers!',
        },
        valueIds: ['value_creation_gratitude'],
        mannerIds: ['manner_gentle_with_plants'],
      ),
      const ContentItem(
        id: 'nature_sun_03',
        activityType: ActivityType.vocabularyDiscovery,
        title: 'Sun',
        description: 'Learn bright warm sun',
        skill: SkillType.vocabulary,
        learningObjective: 'Identify and pronounce "sun".',
        contentData: {
          'word': 'Sun',
          'emoji': '☀️',
          'phonetic': '/sʌn/',
          'sentence': 'The sun is hot and bright in the sky.',
          'valueTip': 'The sun warms the earth and helps plants grow big.',
        },
        valueIds: ['value_creation_gratitude'],
      ),
      const ContentItem(
        id: 'nature_rain_04',
        activityType: ActivityType.vocabularyDiscovery,
        title: 'Rain',
        description: 'Learn fresh cooling raindrops',
        skill: SkillType.vocabulary,
        learningObjective: 'Identify and pronounce "rain".',
        contentData: {
          'word': 'Rain',
          'emoji': '🌧️',
          'phonetic': '/reɪn/',
          'sentence': 'It is raining outside. Fresh raindrops fall from the sky.',
          'valueTip': 'Rain is a blessed gift (Barakah) that gives water to nature.',
        },
        valueIds: ['value_creation_gratitude'],
      ),
      const ContentItem(
        id: 'nature_hunt_05',
        activityType: ActivityType.imageHunt,
        title: 'Nature Hunt',
        description: 'Find trees, flowers, and natural elements',
        skill: SkillType.vocabulary,
        learningObjective: 'Locate nature elements from visual prompts.',
        contentData: {
          'targetWord': 'Tree',
          'prompt': 'Find the Tree! 🌳',
          'options': [
            {'word': 'Flower', 'emoji': '🌸'},
            {'word': 'Tree', 'emoji': '🌳'},
            {'word': 'Sun', 'emoji': '☀️'},
          ],
        },
      ),
      const ContentItem(
        id: 'weather_sunny_rainy_06',
        activityType: ActivityType.multipleChoice,
        title: 'Sunny or Rainy?',
        description: 'Discriminate daily weather conditions',
        skill: SkillType.listening,
        learningObjective: 'Answer "How is the weather?" correctly.',
        contentData: {
          'prompt': 'Pip asks: "Look at the dark clouds and raindrops. How is the weather?"',
          'options': ['It is raining! 🌧️', 'It is sunny! ☀️', 'It is snowing! ❄️'],
          'correctIndex': 0,
        },
      ),
      const ContentItem(
        id: 'grammar_there_is_are_07',
        activityType: ActivityType.fillBlank,
        title: 'Grammar: There is vs There are',
        description: 'Use "There is" for one item and "There are" for multiple items',
        difficulty: DifficultyLevel.elementary,
        skill: SkillType.grammar,
        learningObjective: 'Construct sentences with "There is a..." and "There are...".',
        contentData: {
          'sentencePrefix': 'There ___ three flowers in the grass.',
          'visualEmoji': '🌸 🌸 🌸',
          'correctWord': 'are',
          'options': ['is', 'are'],
          'rule': 'One tree ➜ "There is". Multiple flowers ➜ "There are".',
        },
      ),
      const ContentItem(
        id: 'nature_care_scenario_08',
        activityType: ActivityType.scenarioChoice,
        title: 'Keeping the Park Clean',
        description: 'Practice outdoor responsibility (Taharah) and avoiding littering',
        skill: SkillType.manners,
        learningObjective: 'Choose clean habits when outside in public parks.',
        contentData: {
          'prompt': 'You see an empty juice box on the park grass. What is the clean and kind action?',
          'options': ['Put it in the recycling bin 🗑️', 'Leave it on the grass', 'Kick it'],
          'correctIndex': 0,
          'lesson': 'Keeping outdoor places clean is part of faith and good manners!',
        },
        sourceType: 'hadith_authentic',
        sourceReference: 'Sahih Muslim 223',
      ),
    ];

    final naturePackage = CurriculumPackage(
      id: 'pkg_world_nature_v1',
      worldId: 'world_nature',
      version: 1,
      title: 'Nature & Weather World Curriculum',
      description: 'Nature vocabulary, weather expressions, There is/are, and care for creation.',
      learningObjectives: const [
        'Identify core nature nouns (tree, flower, sun, rain, cloud, bird).',
        'Describe weather conditions (sunny, rainy, cloudy, windy).',
        'Apply "There is / There are" accurately.',
        'Practice outdoor cleanliness and care for living creation.',
      ],
      valueObjectives: const ['Gratitude for Creation (Tafakkur)', 'Care for Nature (Taharah & Ihsan)'],
      contentItems: natureItems,
      createdAt: now,
      updatedAt: now,
    );

    _packages[foodPackage.worldId] = foodPackage;
    _packages[naturePackage.worldId] = naturePackage;
  }

  @override
  Future<List<CurriculumPackage>> getAllPackages() async => _packages.values.toList();

  @override
  Future<CurriculumPackage?> getPackageForWorld(String worldId) async => _packages[worldId];

  @override
  Future<ContentItem?> getContentItemById(String contentId) async {
    for (final pkg in _packages.values) {
      for (final item in pkg.contentItems) {
        if (item.id == contentId) return item;
      }
    }
    return null;
  }

  @override
  Future<List<ContentItem>> getContentItemsForWorld(String worldId) async {
    final pkg = _packages[worldId];
    return pkg?.contentItems ?? [];
  }

  @override
  Future<void> savePackage(CurriculumPackage package) async {
    _packages[package.worldId] = package;
  }
}
