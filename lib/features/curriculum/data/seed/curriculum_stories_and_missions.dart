import '../../domain/models/content_review_status.dart';
import '../../domain/models/learning_age_band.dart';
import '../../domain/models/learning_story.dart';
import '../../domain/models/level_mission.dart';
import '../../domain/models/religious_content_safety.dart';

/// Gold-standard short stories and capstone communicative missions for Levels 1–3.
class CurriculumStoriesAndMissions {
  // ==========================================================================
  // STORIES
  // ==========================================================================
  static final List<LearningStory> stories = [
    const LearningStory(
      id: 'story_sharing_apples',
      title: 'Sharing the Sweet Apples 🍎',
      levelOrder: 3,
      worldId: 'world_food',
      unitId: 'unit_food_blessings',
      textSegments: [
        'Ayaan finds two big red apples on the kitchen table.',
        'He is hungry after playing outside in the green garden.',
        'His little sister Maryam comes in. She is hungry too!',
        'Ayaan smiles kindly and hands the largest apple to Maryam.',
        '"Here you are, Maryam!" he says with a smile.',
        '"Thank you, Ayaan! Alhamdulillah!" Maryam says happily.',
      ],
      simpleTextSegments: [
        'Ayaan has two apples.',
        'Ayaan is hungry.',
        'Maryam is hungry too.',
        'Ayaan gives an apple.',
        '"Here you are, Maryam!"',
        '"Thank you, Ayaan!"',
      ],
      richNarrativeTextSegments: [
        'Ayaan finds two big red apples on the kitchen table.',
        'He is hungry after playing outside in the green garden.',
        'His little sister Maryam comes in. She is hungry too!',
        'Ayaan smiles kindly and hands the largest apple to Maryam.',
        '"Here you are, Maryam!" he says with a smile.',
        '"Thank you, Ayaan! Alhamdulillah!" Maryam says happily.',
      ],
      targetConceptIds: ['concept_apple', 'concept_hungry', 'concept_table', 'concept_smile'],
      targetSentencePatterns: ['pattern_i_am', 'pattern_this_is_a'],
      valueThemes: ['value_sharing', 'value_gratitude', 'value_family_care'],
      religiousContentType: ReligiousContentType.generalMoralValue,
      reviewStatus: ContentReviewStatus.pendingQualifiedIslamicReview,
      ageBands: [
        LearningAgeBand.bandALittleExplorers,
        LearningAgeBand.bandBYoungAdventurers,
        LearningAgeBand.bandCGrowingSpeakers,
      ],
      estimatedDurationMinutes: 4,
    ),
    const LearningStory(
      id: 'story_helping_mother',
      title: 'Helping Mother at Home 🏡',
      levelOrder: 2,
      worldId: 'world_home',
      unitId: 'unit_home_living',
      textSegments: [
        'Mother is tidying the living room after breakfast.',
        'Little Zayd looks at the toys on the floor.',
        '"Can I help you, Mother?" asks Zayd politely.',
        'Zayd puts his books on the desk and tidies his room.',
        '"Thank you, my helpful boy! MashaAllah!" says Mother.',
        'The room is clean, and everyone is happy.',
      ],
      simpleTextSegments: [
        'Mother is in the room.',
        'Toys are on the floor.',
        '"Can I help you, Mother?" asks Zayd.',
        'Zayd puts books on the desk.',
        '"Thank you, Zayd!" says Mother.',
        'The room is clean.',
      ],
      richNarrativeTextSegments: [
        'Mother is tidying the living room after breakfast.',
        'Little Zayd looks at the toys on the floor.',
        '"Can I help you, Mother?" asks Zayd politely.',
        'Zayd puts his books on the desk and tidies his room.',
        '"Thank you, my helpful boy! MashaAllah!" says Mother.',
        'The room is clean, and everyone is happy.',
      ],
      targetConceptIds: ['concept_mother', 'concept_room', 'concept_book', 'concept_desk', 'concept_clean'],
      targetSentencePatterns: ['pattern_can_you_help_me', 'pattern_it_is'],
      valueThemes: ['value_helping_parents', 'value_cleanliness', 'value_family_care'],
      religiousContentType: ReligiousContentType.generalMoralValue,
      reviewStatus: ContentReviewStatus.pendingQualifiedIslamicReview,
      ageBands: [
        LearningAgeBand.bandALittleExplorers,
        LearningAgeBand.bandBYoungAdventurers,
        LearningAgeBand.bandCGrowingSpeakers,
      ],
      estimatedDurationMinutes: 4,
    ),
    const LearningStory(
      id: 'story_thirsty_bird',
      title: 'The Thirsty Little Bird 🐦',
      levelOrder: 1,
      worldId: 'world_animal',
      unitId: 'unit_animal_savannah',
      textSegments: [
        'The sun is hot.',
        'A bird is thirsty.',
        'The bird wants water.',
        'Here is water.',
        'The bird drinks water.',
        'The bird is happy.',
        'Ayaan smiles as the little bird flies away.',
      ],
      simpleTextSegments: [
        'It is hot.',
        'The sun is hot.',
        'A bird is thirsty.',
        'The bird wants water.',
        'Here is water.',
        'The bird drinks water.',
        'The bird is happy.',
      ],
      richNarrativeTextSegments: [
        'The hot yellow sun shines brightly in the sky.',
        'A small blue bird sits quietly on the green tree branch.',
        'The bird is thirsty and chirps softly for water.',
        'Ayaan fills a clean little cup with cool water and sets it outside.',
        'The bird drinks the cool water happily and chirps a cheerful song.',
        'Ayaan smiles warmly as the little bird flies happily away into the sky.',
      ],
      targetConceptIds: ['concept_bird', 'concept_sun', 'concept_tree', 'concept_water', 'concept_cup'],
      targetSentencePatterns: ['pattern_that_is_a', 'pattern_i_see_a'],
      valueThemes: ['value_caring_creation', 'value_kindness', 'value_gratitude'],
      religiousContentType: ReligiousContentType.generalMoralValue,
      reviewStatus: ContentReviewStatus.pendingQualifiedIslamicReview,
      ageBands: [
        LearningAgeBand.bandALittleExplorers,
        LearningAgeBand.bandBYoungAdventurers,
        LearningAgeBand.bandCGrowingSpeakers,
      ],
      estimatedDurationMinutes: 3,
    ),
  ];

  // ==========================================================================
  // LEVEL MISSIONS (CAPSTONES)
  // ==========================================================================
  static final List<LevelMission> levelMissions = [
    const LevelMission(
      id: 'mission_level_1',
      levelId: 'level_1_first_words',
      title: 'First Words Safari with Pip 🦜',
      childFriendlyTitle: 'First Words Safari 🎒',
      description: 'Demonstrate foundational listening recognition and say everyday words for family, food, and animals.',
      assessedObjectiveIds: ['obj_l1_family_identify', 'obj_l1_family_speaking', 'obj_l1_food_identify', 'obj_l1_animals_identify'],
      requiredEvidenceDescription: 'Auditory recognition >= 75% across core domains and 4 spoken words verified.',
      rewardStars: 5,
      rewardXp: 50,
      celebrationBadgeId: 'badge_first_words_master',
    ),
    const LevelMission(
      id: 'mission_level_2',
      levelId: 'level_2_first_phrases',
      title: 'Word Combiner Quest 🧩',
      childFriendlyTitle: 'Word Combiner Quest 🗺️',
      description: 'Combine words into meaningful descriptions, actions, and polite phrases with Pip.',
      assessedObjectiveIds: ['obj_l2_phrases_description', 'obj_l2_polite_phrases', 'obj_l2_greeting_exchange'],
      requiredEvidenceDescription: 'Phrase construction >= 80% and polite greeting dialogue completed.',
      rewardStars: 7,
      rewardXp: 75,
      celebrationBadgeId: 'badge_phrase_builder_master',
    ),
    const LevelMission(
      id: 'mission_level_3',
      levelId: 'level_3_first_sentences',
      title: 'Junior Speaker Showcase 🎙️',
      childFriendlyTitle: 'Junior Speaker Showcase 🌟',
      description: 'Speak in complete sentences: introduce yourself, state preferences, and make polite requests in dialogue.',
      assessedObjectiveIds: ['obj_l3_food_polite_request', 'obj_l3_express_preference', 'obj_l3_self_intro'],
      requiredEvidenceDescription: 'Multi-turn Pip dialogue completed with clear spoken responses and 100% syntactic validity.',
      rewardStars: 10,
      rewardXp: 100,
      celebrationBadgeId: 'badge_junior_speaker_master',
    ),
  ];
}
