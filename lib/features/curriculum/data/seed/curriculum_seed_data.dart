import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import '../../domain/models/activity_template.dart';
import '../../domain/models/can_do_statement.dart';
import '../../domain/models/conversation_function.dart';
import '../../domain/models/curriculum_lesson.dart';
import '../../domain/models/curriculum_level.dart';
import '../../domain/models/curriculum_unit.dart';
import '../../domain/models/curriculum_version.dart';
import '../../domain/models/curriculum_world.dart';
import '../../domain/models/islamic_value_theme.dart';
import '../../domain/models/learning_age_band.dart';
import '../../domain/models/learning_concept.dart';
import '../../domain/models/learning_objective.dart';
import '../../domain/models/learning_story.dart';
import '../../domain/models/level_mission.dart';
import '../../domain/models/sentence_pattern.dart';
import '../../domain/repositories/curriculum_repository.dart';
import 'curriculum_level_1_content.dart';
import 'curriculum_level_2_content.dart';
import 'curriculum_level_3_content.dart';
import 'curriculum_stories_and_missions.dart';
import 'curriculum_units_and_lessons.dart';

/// Gold-standard seed data defining the complete 8-level curriculum framework,
/// 15 world domains, 16 Islamic value themes, and curated gold-standard content for Levels 1–3
/// with ~200 foundational concepts, phrases, sentences, 8 active worlds, and age-aware delivery.
class CurriculumSeedData {
  static final CurriculumVersion version = CurriculumVersion(
    schemaVersion: 1,
    contentVersion: 2,
    releaseDate: DateTime(2026, 9, 11),
    migrationVersion: 1,
    minimumAppVersion: '1.0.0',
    changelogSummary: 'Phase 15 Levels 1–3 gold-standard progressive curriculum with 200+ concepts, phrases, sentences, and 8 active worlds.',
  );

  // --------------------------------------------------------------------------
  // 1. Eight High-Level Curriculum Stages
  // --------------------------------------------------------------------------
  static final List<CurriculumLevel> levels = [
    const CurriculumLevel(
      id: 'level_1_first_words',
      order: 1,
      title: 'Level 1: First Words',
      childFriendlyTitle: 'First Words 🎈',
      description: 'Foundational everyday concrete vocabulary. Imitation, recognition, and simple spoken recall.',
      primarySpeakingGoal: 'Recognize, understand, and say foundational everyday words.',
      languageStage: LanguageStage.firstWords,
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers, LearningAgeBand.bandBYoungAdventurers],
      requiredSkillCompetencies: [SkillDimension.vocabularyRecognition, SkillDimension.vocabularyRecall, SkillDimension.pronunciation],
      coreConceptIds: ['concept_mother', 'concept_father', 'concept_happy', 'concept_apple', 'concept_water', 'concept_cat', 'concept_book'],
      worldIds: ['world_family', 'world_home', 'world_food', 'world_animal'],
      minimumEvidenceCount: 8,
    ),
    const CurriculumLevel(
      id: 'level_2_first_phrases',
      order: 2,
      title: 'Level 2: First Phrases',
      childFriendlyTitle: 'Word Combiners 🧩',
      description: 'Combine familiar words into short 2-3 word meaningful phrases (collocations, polite greetings).',
      primarySpeakingGoal: 'Combine familiar words into short meaningful phrases.',
      languageStage: LanguageStage.firstPhrases,
      recommendedAgeBands: [LearningAgeBand.bandALittleExplorers, LearningAgeBand.bandBYoungAdventurers],
      requiredSkillCompetencies: [SkillDimension.vocabularyRecall, SkillDimension.sentenceComprehension, SkillDimension.speaking],
      coreConceptIds: ['concept_p2_red_apple', 'concept_p2_big_dog', 'concept_p2_drink_water', 'concept_p2_thank_you'],
      worldIds: ['world_family', 'world_home', 'world_food', 'world_animal', 'world_school', 'world_play'],
      minimumEvidenceCount: 10,
    ),
    const CurriculumLevel(
      id: 'level_3_first_sentences',
      order: 3,
      title: 'Level 3: First Sentences',
      childFriendlyTitle: 'Sentence Builders ✍️',
      description: 'Use simple complete English sentence patterns (This is a..., I like..., I am...).',
      primarySpeakingGoal: 'Use simple complete English sentence patterns.',
      languageStage: LanguageStage.firstSentences,
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers, LearningAgeBand.bandCGrowingSpeakers],
      requiredSkillCompetencies: [SkillDimension.sentenceComprehension, SkillDimension.speaking],
      coreConceptIds: ['concept_apple', 'concept_banana', 'concept_water', 'concept_hungry'],
      worldIds: ['world_family', 'world_food', 'world_day', 'world_nature'],
      minimumEvidenceCount: 12,
    ),
    const CurriculumLevel(
      id: 'level_4_everyday_speaker',
      order: 4,
      title: 'Level 4: Everyday Speaker',
      childFriendlyTitle: 'Everyday Explorer 🗣️',
      description: 'Functional English in common daily situations (polite requests, asking for help, locations).',
      primarySpeakingGoal: 'Use functional English in common daily situations.',
      languageStage: LanguageStage.everydaySpeaker,
      recommendedAgeBands: [LearningAgeBand.bandBYoungAdventurers, LearningAgeBand.bandCGrowingSpeakers],
      minimumEvidenceCount: 14,
    ),
    const CurriculumLevel(
      id: 'level_5_conversation_builder',
      order: 5,
      title: 'Level 5: Conversation Builder',
      childFriendlyTitle: 'Conversation Star 💬',
      description: 'Participate in multi-turn social dialogues, follow-up questions, and conversational listening.',
      primarySpeakingGoal: 'Participate in short multi-turn conversations.',
      languageStage: LanguageStage.conversationBuilder,
      recommendedAgeBands: [LearningAgeBand.bandCGrowingSpeakers, LearningAgeBand.bandDConfidentSpeakers],
      minimumEvidenceCount: 16,
    ),
    const CurriculumLevel(
      id: 'level_6_story_speaker',
      order: 6,
      title: 'Level 6: Story Speaker',
      childFriendlyTitle: 'Story Teller 📖',
      description: 'Describe sequenced events and retell short stories (first, then, next, finally, simple past).',
      primarySpeakingGoal: 'Describe events and retell short stories.',
      languageStage: LanguageStage.storySpeaker,
      recommendedAgeBands: [LearningAgeBand.bandCGrowingSpeakers, LearningAgeBand.bandDConfidentSpeakers],
      minimumEvidenceCount: 18,
    ),
    const CurriculumLevel(
      id: 'level_7_confident_communicator',
      order: 7,
      title: 'Level 7: Confident Communicator',
      childFriendlyTitle: 'Opinion Champion 💡',
      description: 'Express thoughts, feelings, reasons, preferences, and comparisons (I think... because...).',
      primarySpeakingGoal: 'Express thoughts, feelings, opinions, reasons, preferences, and comparisons.',
      languageStage: LanguageStage.confidentCommunicator,
      recommendedAgeBands: [LearningAgeBand.bandCGrowingSpeakers, LearningAgeBand.bandDConfidentSpeakers],
      minimumEvidenceCount: 20,
    ),
    const CurriculumLevel(
      id: 'level_8_advanced_young_speaker',
      order: 8,
      title: 'Level 8: Advanced Young Speaker',
      childFriendlyTitle: 'Global Young Speaker 🌟',
      description: 'Sustain age-appropriate extended speaking: storytelling, social debate, and problem-solving.',
      primarySpeakingGoal: 'Sustain age-appropriate extended speaking in varied real-world scenarios.',
      languageStage: LanguageStage.advancedYoungSpeaker,
      recommendedAgeBands: [LearningAgeBand.bandDConfidentSpeakers],
      minimumEvidenceCount: 24,
    ),
  ];

  // --------------------------------------------------------------------------
  // 2. Fifteen Language Domains (Worlds)
  // --------------------------------------------------------------------------
  static final List<CurriculumWorld> worlds = [
    const CurriculumWorld(
      id: 'world_family',
      levelIds: ['level_1_first_words', 'level_2_first_phrases', 'level_3_first_sentences'],
      title: 'Me & My Family',
      childFriendlyTitle: 'Family & Home 🏡',
      theme: 'family',
      description: 'Family relationships, home love, respect for parents, and expressing gratitude.',
      primaryLanguageDomain: 'Family & Kinship',
      valueThemes: ['value_family_care', 'value_respect', 'value_gratitude'],
      unitIds: ['unit_family_basics', 'unit_family_phrases'],
    ),
    const CurriculumWorld(
      id: 'world_home',
      levelIds: ['level_1_first_words', 'level_2_first_phrases', 'level_3_first_sentences'],
      title: 'My Happy Home',
      childFriendlyTitle: 'Happy Home 🏠',
      theme: 'home',
      description: 'Rooms, daily items, cleaning up, and helping around the house.',
      primaryLanguageDomain: 'Domestic Living',
      valueThemes: ['value_cleanliness', 'value_responsibility'],
      unitIds: ['unit_home_living', 'unit_home_routines'],
    ),
    const CurriculumWorld(
      id: 'world_food',
      levelIds: ['level_1_first_words', 'level_2_first_phrases', 'level_3_first_sentences', 'level_4_everyday_speaker'],
      title: 'Food & Blessings',
      childFriendlyTitle: 'Food & Blessings 🍎',
      theme: 'food',
      description: 'Everyday foods, dining Sunnah, polite requests, and expressing thankfulness for sustenance.',
      primaryLanguageDomain: 'Food & Nutrition',
      valueThemes: ['value_gratitude', 'value_sharing', 'value_good_manners'],
      unitIds: ['unit_food_blessings_l1', 'unit_food_blessings'],
    ),
    const CurriculumWorld(
      id: 'world_animal',
      levelIds: ['level_1_first_words', 'level_2_first_phrases', 'level_3_first_sentences'],
      title: 'Animal Kingdom',
      childFriendlyTitle: 'Animal Kingdom 🦁',
      theme: 'animals',
      description: 'Creatures of the earth, sounds, traits, caring for animals with mercy.',
      primaryLanguageDomain: 'Animals & Zoology',
      valueThemes: ['value_caring_creation', 'value_kindness'],
      unitIds: ['unit_animal_savannah', 'unit_animal_phrases'],
    ),
    const CurriculumWorld(
      id: 'world_school',
      levelIds: ['level_2_first_phrases', 'level_3_first_sentences', 'level_4_everyday_speaker'],
      title: 'School Adventure',
      childFriendlyTitle: 'School Adventure 🏫',
      theme: 'school',
      description: 'Classroom items, teachers, peers, learning tools, and honesty with property.',
      primaryLanguageDomain: 'Classroom & Study',
      valueThemes: ['value_honesty', 'value_respect'],
      unitIds: ['unit_classroom_tools'],
    ),
    const CurriculumWorld(
      id: 'world_play',
      levelIds: ['level_2_first_phrases', 'level_3_first_sentences'],
      title: 'Play & Friendship',
      childFriendlyTitle: 'Play & Friends ⚽',
      theme: 'play',
      description: 'Games, turn-taking, sportsmanship, and making new friends.',
      primaryLanguageDomain: 'Play & Recreation',
      valueThemes: ['value_friendship', 'value_sharing', 'value_patience'],
      unitIds: ['unit_play_friendship'],
    ),
    const CurriculumWorld(
      id: 'world_day',
      levelIds: ['level_3_first_sentences', 'level_4_everyday_speaker'],
      title: 'My Day',
      childFriendlyTitle: 'Daily Routines ⏰',
      theme: 'routine',
      description: 'Morning to evening activities, prayer times, and healthy habits.',
      primaryLanguageDomain: 'Time & Daily Routine',
      valueThemes: ['value_responsibility', 'value_cleanliness'],
      unitIds: ['unit_my_day_routines'],
    ),
    const CurriculumWorld(
      id: 'world_town',
      levelIds: ['level_4_everyday_speaker', 'level_5_conversation_builder'],
      title: 'Around Town',
      childFriendlyTitle: 'Around Town 🏙️',
      theme: 'community',
      description: 'Shops, mosque, library, asking for directions, and neighborhood manners.',
      primaryLanguageDomain: 'Community Navigation',
      valueThemes: ['value_community_help', 'value_good_manners'],
      unitIds: [],
    ),
    const CurriculumWorld(
      id: 'world_nature',
      levelIds: ['level_3_first_sentences', 'level_4_everyday_speaker'],
      title: 'Nature & Creation',
      childFriendlyTitle: 'Nature Wonders 🌿',
      theme: 'nature',
      description: 'Weather, trees, rain, sky, and reflecting on the beauty of Allah\'s creation.',
      primaryLanguageDomain: 'Earth & Nature',
      valueThemes: ['value_gratitude', 'value_caring_creation'],
      unitIds: ['unit_nature_creation'],
    ),
    const CurriculumWorld(
      id: 'world_manners',
      levelIds: ['level_4_everyday_speaker', 'level_5_conversation_builder'],
      title: 'Good Manners',
      childFriendlyTitle: 'Polite Manners 🤲',
      theme: 'manners',
      description: 'Saying please, thank you, welcoming guests, and apologies.',
      primaryLanguageDomain: 'Etiquette & Adab',
      valueThemes: ['value_good_manners', 'value_forgiveness'],
      unitIds: [],
    ),
    const CurriculumWorld(
      id: 'world_character',
      levelIds: ['level_5_conversation_builder', 'level_6_story_speaker'],
      title: 'Stories of Good Character',
      childFriendlyTitle: 'Heroes of Good Character 🛡️',
      theme: 'character',
      description: 'Moral dilemmas, patience, telling the truth, and helping the vulnerable.',
      primaryLanguageDomain: 'Moral Reasoning',
      valueThemes: ['value_honesty', 'value_patience', 'value_generosity'],
      unitIds: [],
    ),
    const CurriculumWorld(
      id: 'world_conversation',
      levelIds: ['level_5_conversation_builder', 'level_7_confident_communicator'],
      title: 'Conversation City',
      childFriendlyTitle: 'Conversation City 🏙️',
      theme: 'city',
      description: 'Role-playing dialogues, ordering food, interviewing people, social visits.',
      primaryLanguageDomain: 'Interactive Dialogue',
      valueThemes: ['value_friendship', 'value_good_manners'],
      unitIds: [],
    ),
    const CurriculumWorld(
      id: 'world_storytelling',
      levelIds: ['level_6_story_speaker', 'level_7_confident_communicator'],
      title: 'Storytelling Island',
      childFriendlyTitle: 'Story Island 🏝️',
      theme: 'story',
      description: 'Creating stories, narrating adventures, and sequence retelling.',
      primaryLanguageDomain: 'Narrative Speech',
      valueThemes: ['value_kindness', 'value_gratitude'],
      unitIds: [],
    ),
    const CurriculumWorld(
      id: 'world_thinking',
      levelIds: ['level_7_confident_communicator', 'level_8_advanced_young_speaker'],
      title: 'Thinking & Speaking',
      childFriendlyTitle: 'Big Thinkers 🧠',
      theme: 'thinking',
      description: 'Comparing ideas, giving opinions, evaluating choices, and asking why.',
      primaryLanguageDomain: 'Critical Discourse',
      valueThemes: ['value_honesty', 'value_respect'],
      unitIds: [],
    ),
    const CurriculumWorld(
      id: 'world_challenge',
      levelIds: ['level_8_advanced_young_speaker'],
      title: 'Confident Speaker Challenge',
      childFriendlyTitle: 'Champion Speaker 🏆',
      theme: 'challenge',
      description: 'Extended speeches, solving community problems, and advanced presentations.',
      primaryLanguageDomain: 'Public & Expressive Speaking',
      valueThemes: ['value_responsibility', 'value_community_help'],
      unitIds: [],
    ),
  ];

  // --------------------------------------------------------------------------
  // 3. Sixteen Core Islamic Value Themes
  // --------------------------------------------------------------------------
  static final List<IslamicValueTheme> valueThemes = [
    const IslamicValueTheme(
      id: 'value_gratitude',
      title: 'Gratitude (Shukr)',
      childFriendlyTitle: 'Saying Alhamdulillah 🌟',
      description: 'Appreciating Allah\'s blessings and thanking people who help us.',
      authenticReference: 'Hadith: "He who does not thank people does not thank Allah." (Abu Dawud)',
      coreConceptWords: ['thank', 'blessing', 'happy', 'gift'],
      dailyPractices: ['Saying Alhamdulillah after eating', 'Saying thank you to family'],
      languagePhrases: ['Thank you!', 'Alhamdulillah', 'I am so grateful.'],
    ),
    const IslamicValueTheme(
      id: 'value_kindness',
      title: 'Kindness & Mercy (Rahmah)',
      childFriendlyTitle: 'Kind Words & Gentle Hands 🌸',
      description: 'Treating all creatures, siblings, and friends with gentle warmth.',
      authenticReference: 'Hadith: "Kindness is not in anything except that it beautifies it." (Muslim)',
      coreConceptWords: ['kind', 'gentle', 'help', 'care'],
      dailyPractices: ['Using soft hands with pets', 'Speaking gently'],
      languagePhrases: ['Can I help you?', 'You are welcome.'],
    ),
    const IslamicValueTheme(
      id: 'value_honesty',
      title: 'Honesty (Sidq)',
      childFriendlyTitle: 'Truthful Explorer 🛡️',
      description: 'Always speaking the truth even when making a mistake.',
      authenticReference: 'Hadith: "Truthfulness leads to righteousness." (Bukhari)',
      coreConceptWords: ['truth', 'honest', 'promise', 'fair'],
      dailyPractices: ['Admitting accidental spills', 'Returning borrowed toys'],
      languagePhrases: ['I tell the truth.', 'I am sorry.'],
    ),
    const IslamicValueTheme(
      id: 'value_patience',
      title: 'Patience (Sabr)',
      childFriendlyTitle: 'Waiting Patiently ⏳',
      description: 'Waiting calmly for one\'s turn and staying cheerful during challenges.',
      authenticReference: 'Qur\'an: "Indeed, Allah is with the patient." (2:153)',
      coreConceptWords: ['wait', 'calm', 'turn', 'practice'],
      dailyPractices: ['Waiting in line', 'Trying again after failing'],
      languagePhrases: ['Take your time.', 'I can wait.'],
    ),
    const IslamicValueTheme(
      id: 'value_sharing',
      title: 'Sharing & Generosity (Ithar)',
      childFriendlyTitle: 'Sharing is Caring 🤝',
      description: 'Offering food, toys, and joy to siblings and friends.',
      authenticReference: 'Hadith: "None of you believes until he loves for his brother what he loves for himself." (Bukhari)',
      coreConceptWords: ['share', 'give', 'together', 'friend'],
      dailyPractices: ['Sharing treats at lunch', 'Offering toys to friends'],
      languagePhrases: ['Here you are!', 'We can share.', 'Would you like some?'],
    ),
    const IslamicValueTheme(
      id: 'value_respect',
      title: 'Respect (Ihtiram)',
      childFriendlyTitle: 'Respecting Others 🤲',
      description: 'Listening when others speak, respecting elders, and honoring teachers.',
      authenticReference: 'Hadith: "He is not one of us who does not show mercy to our young and respect to our elders." (Tirmidhi)',
      coreConceptWords: ['listen', 'polite', 'teacher', 'parents'],
      dailyPractices: ['Listening without interrupting', 'Looking at the speaker'],
      languagePhrases: ['Yes, please.', 'Excuse me.'],
    ),
    const IslamicValueTheme(
      id: 'value_helping_parents',
      title: 'Helping Parents (Birr al-Walidayn)',
      childFriendlyTitle: 'Helping Mom & Dad 💖',
      description: 'Showing deep love and practical assistance to mother and father.',
      authenticReference: 'Qur\'an: "And be kind to parents..." (17:23)',
      coreConceptWords: ['mother', 'father', 'help', 'clean'],
      dailyPractices: ['Putting shoes away', 'Carrying light groceries'],
      languagePhrases: ['Can I help you, Mom?', 'I love you, Dad.'],
    ),
    const IslamicValueTheme(
      id: 'value_family_care',
      title: 'Family Care (Silat ar-Rahim)',
      childFriendlyTitle: 'Loving My Family 🏡',
      description: 'Caring for brothers, sisters, grandparents, and cousins.',
      authenticReference: 'Hadith: "The best of you is the one who is best to his family." (Tirmidhi)',
      coreConceptWords: ['family', 'brother', 'sister', 'love'],
      dailyPractices: ['Reading with a younger sibling', 'Hugging grandparents'],
      languagePhrases: ['This is my brother.', 'I love my family.'],
    ),
    const IslamicValueTheme(
      id: 'value_cleanliness',
      title: 'Cleanliness (Taharah)',
      childFriendlyTitle: 'Clean & Fresh 🧼',
      description: 'Washing hands, brushing teeth, and keeping spaces tidy.',
      authenticReference: 'Hadith: "Cleanliness is half of faith." (Muslim)',
      coreConceptWords: ['clean', 'wash', 'water', 'tidy'],
      dailyPractices: ['Washing hands before eating', 'Wiping table spills'],
      languagePhrases: ['Clean water', 'My hands are clean.'],
    ),
    const IslamicValueTheme(
      id: 'value_responsibility',
      title: 'Responsibility (Amanah)',
      childFriendlyTitle: 'Taking Care of My Things 🎒',
      description: 'Looking after backpack, books, and completing small chores.',
      authenticReference: 'Hadith: "Each of you is a shepherd and responsible for his flock." (Bukhari)',
      coreConceptWords: ['care', 'keep', 'tidy', 'backpack'],
      dailyPractices: ['Packing books', 'Putting away toys after play'],
      languagePhrases: ['I can do it.', 'Here is my book.'],
    ),
    const IslamicValueTheme(
      id: 'value_forgiveness',
      title: 'Forgiveness (Afw)',
      childFriendlyTitle: 'Forgiving Friends 🌈',
      description: 'Accepting apologies with a cheerful heart.',
      authenticReference: 'Qur\'an: "Let them pardon and overlook." (24:22)',
      coreConceptWords: ['sorry', 'pardon', 'smile', 'friend'],
      dailyPractices: ['Saying "that\'s okay" after someone bumps in'],
      languagePhrases: ['That is okay.', 'I forgive you.'],
    ),
    const IslamicValueTheme(
      id: 'value_generosity',
      title: 'Generosity (Jood)',
      childFriendlyTitle: 'Generous Giving 🎁',
      description: 'Giving willingly from our favorite belongings.',
      authenticReference: 'Qur\'an: "Never will you attain righteousness until you spend from that which you love." (3:92)',
      coreConceptWords: ['give', 'gift', 'joy', 'smile'],
      dailyPractices: ['Giving a drawing to a friend', 'Sharing snacks'],
      languagePhrases: ['This is for you!'],
    ),
    const IslamicValueTheme(
      id: 'value_good_manners',
      title: 'Good Manners (Husn al-Khuluq)',
      childFriendlyTitle: 'Beautiful Manners ✨',
      description: 'Smiling, greeting with Salam, and speaking politely.',
      authenticReference: 'Hadith: "Smiling in the face of your brother is charity." (Tirmidhi)',
      coreConceptWords: ['please', 'thank', 'smile', 'salam'],
      dailyPractices: ['Smiling when greeting', 'Saying please when asking'],
      languagePhrases: ['Assalamu Alaikum!', 'Can I have..., please?'],
    ),
    const IslamicValueTheme(
      id: 'value_caring_creation',
      title: 'Caring for Creation (Ri\'ayah)',
      childFriendlyTitle: 'Caring for Allah\'s World 🌿',
      description: 'Respecting plants, watering flowers, and being kind to birds and animals.',
      authenticReference: 'Hadith: "There is a reward for serving any living being." (Bukhari)',
      coreConceptWords: ['tree', 'water', 'bird', 'gentle'],
      dailyPractices: ['Watering plants', 'Leaving water for birds'],
      languagePhrases: ['The bird drinks water.', 'Look at the green tree.'],
    ),
    const IslamicValueTheme(
      id: 'value_friendship',
      title: 'Good Friendship (Suhbah)',
      childFriendlyTitle: 'Being a Great Friend 🎈',
      description: 'Encouraging friends, playing fairly, and sharing laughter.',
      authenticReference: 'Hadith: "A person is upon the religion of his friend." (Abu Dawud)',
      coreConceptWords: ['friend', 'play', 'together', 'laugh'],
      dailyPractices: ['Inviting someone alone to play', 'Cheering on friends'],
      languagePhrases: ['Let us play together!', 'You can do it!'],
    ),
    const IslamicValueTheme(
      id: 'value_community_help',
      title: 'Community Help (Ta\'awun)',
      childFriendlyTitle: 'Helping Our Neighbors 🏘️',
      description: 'Picking up litter, greeting neighbors, and working together.',
      authenticReference: 'Qur\'an: "And cooperate in righteousness and piety..." (5:2)',
      coreConceptWords: ['neighbor', 'help', 'clean', 'together'],
      dailyPractices: ['Picking up playground litter', 'Holding the door'],
      languagePhrases: ['Let me help you.', 'We can clean together.'],
    ),
  ];

  // --------------------------------------------------------------------------
  // 4. Activity Templates
  // --------------------------------------------------------------------------
  static final List<ActivityTemplate> templates = [
    const ActivityTemplate(
      id: 'template_picture_choice',
      type: ActivityTemplateType.pictureChoice,
      supportedSkillDimensions: [SkillDimension.vocabularyRecognition],
      supportedLevels: [1, 2, 3],
      interactionType: 'tap',
      requiresAudio: true,
      requiresSpeech: false,
    ),
    const ActivityTemplate(
      id: 'template_listen_choose',
      type: ActivityTemplateType.listenAndChoose,
      supportedSkillDimensions: [SkillDimension.listening, SkillDimension.vocabularyRecognition],
      supportedLevels: [1, 2, 3, 4],
      interactionType: 'tap',
      requiresAudio: true,
      requiresSpeech: false,
    ),
    const ActivityTemplate(
      id: 'template_repeat_pip',
      type: ActivityTemplateType.repeatAfterPip,
      supportedSkillDimensions: [SkillDimension.pronunciation, SkillDimension.speaking],
      supportedLevels: [1, 2, 3, 4],
      interactionType: 'voice',
      requiresAudio: true,
      requiresSpeech: true,
    ),
    const ActivityTemplate(
      id: 'template_sentence_builder',
      type: ActivityTemplateType.sentenceBuilder,
      supportedSkillDimensions: [SkillDimension.sentenceComprehension, SkillDimension.speaking],
      supportedLevels: [2, 3, 4, 5],
      interactionType: 'drag',
      requiresAudio: true,
      requiresSpeech: false,
    ),
    const ActivityTemplate(
      id: 'template_matching',
      type: ActivityTemplateType.matching,
      supportedSkillDimensions: [SkillDimension.vocabularyRecall],
      supportedLevels: [1, 2, 3],
      interactionType: 'tap',
    ),
    const ActivityTemplate(
      id: 'template_animal_hunt',
      type: ActivityTemplateType.animalHunt,
      supportedSkillDimensions: [SkillDimension.vocabularyRecognition],
      supportedLevels: [1, 2],
      interactionType: 'tap',
    ),
    const ActivityTemplate(
      id: 'template_conversation_prompt',
      type: ActivityTemplateType.conversationPrompt,
      supportedSkillDimensions: [SkillDimension.speaking],
      supportedLevels: [3, 4, 5, 6, 7, 8],
      interactionType: 'voice',
      requiresAudio: true,
      requiresSpeech: true,
    ),
    const ActivityTemplate(
      id: 'template_speak_continue',
      type: ActivityTemplateType.speakToContinue,
      supportedSkillDimensions: [SkillDimension.speaking],
      supportedLevels: [1, 2, 3, 4],
      interactionType: 'voice',
      requiresAudio: true,
      requiresSpeech: true,
    ),
  ];

  // --------------------------------------------------------------------------
  // 5. Curated Levels 1–3 Gold-Standard Content Modules
  // --------------------------------------------------------------------------
  static final List<LearningConcept> concepts = [
    ...Level1CurriculumContent.concepts,
    ...Level2CurriculumContent.concepts,
  ];

  static final List<SentencePattern> sentencePatterns = Level3CurriculumContent.sentencePatterns;
  static final List<ConversationFunction> conversationFunctions = Level3CurriculumContent.conversationFunctions;
  static final List<CanDoStatement> canDoStatements = CurriculumUnitsAndLessons.canDoStatements;
  static final List<LearningObjective> objectives = CurriculumUnitsAndLessons.objectives;
  static final List<CurriculumUnit> units = CurriculumUnitsAndLessons.units;
  static final List<CurriculumLesson> lessons = CurriculumUnitsAndLessons.lessons;
  static final List<LearningStory> stories = CurriculumStoriesAndMissions.stories;
  static final List<LevelMission> levelMissions = CurriculumStoriesAndMissions.levelMissions;

  /// Creates a ready-to-use, fully populated CurriculumRepository instance.
  static CurriculumRepository createRepository() {
    return CurriculumRepository(
      version: version,
      levels: levels,
      worlds: worlds,
      units: units,
      lessons: lessons,
      concepts: concepts,
      sentencePatterns: sentencePatterns,
      conversationFunctions: conversationFunctions,
      valueThemes: valueThemes,
      objectives: objectives,
      canDoStatements: canDoStatements,
      stories: stories,
      levelMissions: levelMissions,
      activityTemplates: templates,
    );
  }
}
