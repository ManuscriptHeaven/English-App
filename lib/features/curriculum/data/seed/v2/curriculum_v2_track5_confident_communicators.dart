import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene_object.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_lesson.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_unit.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_world.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'curriculum_v2_scenes.dart';

/// Complete Track 5 (Age 11–12: Confident Communicators) Production Curriculum.
/// Contains 10 Thematic Worlds, 10 Units, 32 Complete Lessons, and 160 Interactions.
/// Confident practical spoken English: nuanced opinions ("In my opinion...", "I agree because..."),
/// hypothetical reasoning ("If I could..."), plans ("Next weekend I am going to..."), and problem solving.
class CurriculumV2Track5ConfidentCommunicators {
  static final AgeExperienceProfile profile = AgeExperienceProfile.forAge(11);

  // ── 10 WORLDS ──
  static final List<CurriculumWorld> worlds = [
    const CurriculumWorld(
      id: 'world_t5_identity',
      levelIds: ['level_t5'],
      title: 'Identity, Purpose & Future Dreams',
      childFriendlyTitle: 'Identity & Dreams 🧭',
      theme: 'identity',
      description: 'Articulating long-term aspirations, values, and character development.',
      primaryLanguageDomain: 'Personal Philosophy & Aspirations',
      recommendedAgeBands: [LearningAgeBand.bandDConfidentSpeakers],
      unitIds: ['unit_t5_identity'],
    ),
    const CurriculumWorld(
      id: 'world_t5_school',
      levelIds: ['level_t5'],
      title: 'Academic Projects & Civil Debate',
      childFriendlyTitle: 'Academic Projects 🔬',
      theme: 'school',
      description: 'Collaborative STEM research, defending hypotheses, respectful debate.',
      primaryLanguageDomain: 'Scientific Discussion & Clear Reasoning',
      recommendedAgeBands: [LearningAgeBand.bandDConfidentSpeakers],
      unitIds: ['unit_t5_school'],
    ),
    const CurriculumWorld(
      id: 'world_t5_friendship',
      levelIds: ['level_t5'],
      title: 'True Friendship & Moral Courage',
      childFriendlyTitle: 'True Friendship 🤝',
      theme: 'friendship',
      description: 'Resolving disputes with consultation (Shura), resisting peer pressure.',
      primaryLanguageDomain: 'Interpersonal Ethics & Consultation',
      recommendedAgeBands: [LearningAgeBand.bandDConfidentSpeakers],
      unitIds: ['unit_t5_friendship'],
    ),
    const CurriculumWorld(
      id: 'world_t5_technology',
      levelIds: ['level_t5'],
      title: 'Technology & Digital Wisdom',
      childFriendlyTitle: 'Tech & Innovation 💻',
      theme: 'technology',
      description: 'Artificial intelligence ethics, screen-time balance, purposeful invention.',
      primaryLanguageDomain: 'Digital Literacy & Modern Ethics',
      recommendedAgeBands: [LearningAgeBand.bandDConfidentSpeakers],
      unitIds: ['unit_t5_technology'],
    ),
    const CurriculumWorld(
      id: 'world_t5_health',
      levelIds: ['level_t5'],
      title: 'Holistic Health & Stewardship',
      childFriendlyTitle: 'Healthy Living 🏃',
      theme: 'health',
      description: 'Body as a divine trust, nutrition, sleep cycles, mental focus.',
      primaryLanguageDomain: 'Wellness & Health Stewardship',
      recommendedAgeBands: [LearningAgeBand.bandDConfidentSpeakers],
      unitIds: ['unit_t5_health'],
    ),
    const CurriculumWorld(
      id: 'world_t5_community',
      levelIds: ['level_t5'],
      title: 'Community Leadership & Social Impact',
      childFriendlyTitle: 'Community Impact 🏛️',
      theme: 'community',
      description: 'Initiating social welfare campaigns, volunteering, mutual support.',
      primaryLanguageDomain: 'Civic Leadership & Social Responsibility',
      recommendedAgeBands: [LearningAgeBand.bandDConfidentSpeakers],
      unitIds: ['unit_t5_community'],
    ),
    const CurriculumWorld(
      id: 'world_t5_nature',
      levelIds: ['level_t5'],
      title: 'Global Ecology & Conservation',
      childFriendlyTitle: 'Global Nature 🌍',
      theme: 'nature',
      description: 'Renewable energy, ecosystem balance, ethical responsibility.',
      primaryLanguageDomain: 'Environmental Science & Global Ethics',
      recommendedAgeBands: [LearningAgeBand.bandDConfidentSpeakers],
      unitIds: ['unit_t5_nature'],
    ),
    const CurriculumWorld(
      id: 'world_t5_travel',
      levelIds: ['level_t5'],
      title: 'World Cultures & Exploration',
      childFriendlyTitle: 'World Cultures ✈️',
      theme: 'travel',
      description: 'Cross-cultural appreciation, historical architecture, travel journals.',
      primaryLanguageDomain: 'Cultural Geography & Travel Narratives',
      recommendedAgeBands: [LearningAgeBand.bandDConfidentSpeakers],
      unitIds: ['unit_t5_travel'],
    ),
    const CurriculumWorld(
      id: 'world_t5_problems',
      levelIds: ['level_t5'],
      title: 'Complex Problem Solving',
      childFriendlyTitle: 'Problem Solving 🧩',
      theme: 'problems',
      description: 'Negotiation, balancing competing priorities, evaluating trade-offs.',
      primaryLanguageDomain: 'Conflict Resolution & Strategic Thinking',
      recommendedAgeBands: [LearningAgeBand.bandDConfidentSpeakers],
      unitIds: ['unit_t5_problems'],
    ),
    const CurriculumWorld(
      id: 'world_t5_opinions',
      levelIds: ['level_t5'],
      title: 'Nuanced Opinions & Civil Dialogue',
      childFriendlyTitle: 'Opinions & Debates 🗣️',
      theme: 'opinions',
      description: 'Polite disagreement ("I agree because...", "In my opinion..."), diplomacy.',
      primaryLanguageDomain: 'Persuasion & Civil Dialogue',
      recommendedAgeBands: [LearningAgeBand.bandDConfidentSpeakers],
      unitIds: ['unit_t5_opinions'],
    ),
  ];

  // ── 10 UNITS ──
  static final List<CurriculumUnit> units = [
    const CurriculumUnit(
      id: 'unit_t5_identity',
      worldId: 'world_t5_identity',
      levelId: 'level_t5',
      title: 'Values, Vision & Purpose',
      description: 'Expressing life philosophy, moral values, and long-term aims.',
      speakingOutcome: 'Student expresses thoughtful perspectives: "In my opinion, true success lies in helping others."',
      listeningOutcome: 'Student understands persuasive spoken discussions.',
      lessonIds: ['t5_l01_personal_philosophy', 't5_l02_role_models_and_virtues', 't5_l03_long_term_aspirations'],
    ),
    const CurriculumUnit(
      id: 'unit_t5_school',
      worldId: 'world_t5_school',
      levelId: 'level_t5',
      title: 'Scientific Collaboration & Logic',
      description: 'Hypotheses, evidence-based reasoning, peer review.',
      speakingOutcome: 'Student argues: "I agree with this hypothesis because the experimental data supports it."',
      listeningOutcome: 'Student identifies logical fallacies and valid counter-arguments.',
      lessonIds: ['t5_l04_evaluating_scientific_evidence', 't5_l05_constructive_peer_critique', 't5_l06_interdisciplinary_thinking'],
    ),
    const CurriculumUnit(
      id: 'unit_t5_friendship',
      worldId: 'world_t5_friendship',
      levelId: 'level_t5',
      title: 'Navigating Social Dynamics',
      description: 'Consultation, mutual respect, overcoming peer pressure.',
      speakingOutcome: 'Student discusses: "When friends disagree, we should practice Shura and seek common ground."',
      listeningOutcome: 'Student interprets emotional nuance in group discussions.',
      lessonIds: ['t5_l07_consultation_over_conflict', 't5_l08_resisting_peer_pressure', 't5_l09_loyalty_and_honest_advice'],
    ),
    const CurriculumUnit(
      id: 'unit_t5_technology',
      worldId: 'world_t5_technology',
      levelId: 'level_t5',
      title: 'Digital Wellness & Innovation',
      description: 'AI ethics, digital consumption habits, purposeful creation.',
      speakingOutcome: 'Student debates: "Technology is a powerful tool, but we must protect our time and focus."',
      listeningOutcome: 'Student critiques technology podcasts and debates.',
      lessonIds: ['t5_l10_ai_and_human_wisdom', 't5_l11_digital_balance_in_daily_life', 't5_l12_coding_for_social_good', 't5_l13_protecting_privacy_online'],
    ),
    const CurriculumUnit(
      id: 'unit_t5_health',
      worldId: 'world_t5_health',
      levelId: 'level_t5',
      title: 'Physical & Cognitive Wellness',
      description: 'Hydration science, sleep hygiene, nutrition as stewardship.',
      speakingOutcome: 'Student explains: "Why is drinking water important? In my opinion, our body is an Amanah."',
      listeningOutcome: 'Student analyzes nutritional and physiological reports.',
      lessonIds: ['t5_l14_hydration_and_cognitive_power', 't5_l15_nutrition_as_divine_trust', 't5_l16_sleep_and_memory_consolidation'],
    ),
    const CurriculumUnit(
      id: 'unit_t5_community',
      worldId: 'world_t5_community',
      levelId: 'level_t5',
      title: 'Youth Leadership & Social Action',
      description: 'Designing neighborhood programs, youth mentorship.',
      speakingOutcome: 'Student proposes: "Next weekend we are going to launch a tutoring club for younger students."',
      listeningOutcome: 'Student summarizes municipal meeting records.',
      lessonIds: ['t5_l17_launching_youth_mentorship', 't5_l18_community_food_pantry', 't5_l19_advocating_for_public_parks'],
    ),
    const CurriculumUnit(
      id: 'unit_t5_nature',
      worldId: 'world_t5_nature',
      levelId: 'level_t5',
      title: 'Stewardship of Creation',
      description: 'Renewable energy, biodiversity, ethical conservation.',
      speakingOutcome: 'Student presents: "If we transition to solar energy, we reduce carbon emissions drastically."',
      listeningOutcome: 'Student evaluates environmental impact assessments.',
      lessonIds: ['t5_l20_renewable_energy_solutions', 't5_l21_preserving_biodiversity', 't5_l22_ethical_consumerism'],
    ),
    const CurriculumUnit(
      id: 'unit_t5_travel',
      worldId: 'world_t5_travel',
      levelId: 'level_t5',
      title: 'Historical Exploration & Culture',
      description: 'Architectural marvels, historical travel memoirs, global brotherhood.',
      speakingOutcome: 'Student retells: "Yesterday we studied how Cordoba was a center of science and coexistence."',
      listeningOutcome: 'Student follows historical documentaries.',
      lessonIds: ['t5_l23_the_heritage_of_cordoba', 't5_l24_cross_cultural_exchange', 't5_l25_the_lessons_of_travel'],
    ),
    const CurriculumUnit(
      id: 'unit_t5_problems',
      worldId: 'world_t5_problems',
      levelId: 'level_t5',
      title: 'Diplomacy & Strategic Decisions',
      description: 'Evaluating trade-offs, finding win-win agreements.',
      speakingOutcome: 'Student negotiates: "I propose a compromise where both groups achieve their primary priorities."',
      listeningOutcome: 'Student analyzes multi-party conflict scenarios.',
      lessonIds: ['t5_l26_identifying_root_causes', 't5_l27_negotiating_win_win_solutions', 't5_l28_long_term_impact_analysis'],
    ),
    const CurriculumUnit(
      id: 'unit_t5_opinions',
      levelId: 'level_t5',
      worldId: 'world_t5_opinions',
      title: 'The Art of Persuasion & Courtesy',
      description: 'Nuanced agreement, respectful divergence, reasoned advocacy.',
      speakingOutcome: 'Student defends thesis: "While that perspective is understandable, evidence indicates otherwise."',
      listeningOutcome: 'Student decodes rhetorical nuances in public debates.',
      lessonIds: ['t5_l29_the_etiquette_of_disagreement', 't5_l30_evidence_versus_emotion', 't5_l31_building_consensus', 't5_l32_speaking_truth_with_gentleness'],
    ),
  ];

  // ── 32 LESSONS ──
  static final List<CurriculumLesson> lessons = [
    // World 1
    const CurriculumLesson(
      id: 't5_l01_personal_philosophy',
      unitId: 'unit_t5_identity',
      levelId: 'level_t5',
      order: 1,
      title: 'Defining Personal Principles 🧭',
      speakingOutcome: 'Student explains personal core values with real-life examples.',
      listeningOutcome: 'Student listens to and compares different viewpoints on character.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l02_role_models_and_virtues',
      unitId: 'unit_t5_identity',
      levelId: 'level_t5',
      order: 2,
      title: 'Inspiring Role Models 🌟',
      speakingOutcome: 'Student describes qualities of an inspiring role model.',
      listeningOutcome: 'Student identifies character virtues in historical narratives.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l03_long_term_aspirations',
      unitId: 'unit_t5_identity',
      levelId: 'level_t5',
      order: 3,
      title: 'Long-Term Vision for My Life 🎯',
      speakingOutcome: 'Student outlines educational and career aspirations.',
      listeningOutcome: 'Student asks constructive questions about future plans.',
      estimatedDurationMinutes: 10,
    ),

    // World 2
    const CurriculumLesson(
      id: 't5_l04_evaluating_scientific_evidence',
      unitId: 'unit_t5_school',
      levelId: 'level_t5',
      order: 4,
      title: 'Evaluating Scientific Data 🔬',
      speakingOutcome: 'Student explains correlation vs causation in simple terms.',
      listeningOutcome: 'Student follows technical data presentations.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l05_constructive_peer_critique',
      unitId: 'unit_t5_school',
      levelId: 'level_t5',
      order: 5,
      title: 'Giving Constructive Feedback 📝',
      speakingOutcome: 'Student delivers positive, actionable peer critique.',
      listeningOutcome: 'Student receives critique gracefully.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l06_interdisciplinary_thinking',
      unitId: 'unit_t5_school',
      levelId: 'level_t5',
      order: 6,
      title: 'Connecting Science and Humanities 🌐',
      speakingOutcome: 'Student links scientific ethics to human welfare.',
      listeningOutcome: 'Student identifies cross-disciplinary themes.',
      estimatedDurationMinutes: 10,
    ),

    // World 3
    const CurriculumLesson(
      id: 't5_l07_consultation_over_conflict',
      unitId: 'unit_t5_friendship',
      levelId: 'level_t5',
      order: 7,
      title: 'Consultation Over Conflict 🤝',
      speakingOutcome: 'Student demonstrates how mutual Shura resolves deadlocks.',
      listeningOutcome: 'Student detects conflict de-escalation strategies.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l08_resisting_peer_pressure',
      unitId: 'unit_t5_friendship',
      levelId: 'level_t5',
      order: 8,
      title: 'Moral Courage Against Peer Pressure 🛡️',
      speakingOutcome: 'Student uses polite but firm refusal techniques.',
      listeningOutcome: 'Student analyzes peer pressure dialogue.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l09_loyalty_and_honest_advice',
      unitId: 'unit_t5_friendship',
      levelId: 'level_t5',
      order: 9,
      title: 'Loyalty and Sincere Advice (Nasiha) ❤️',
      speakingOutcome: 'Student shares how to counsel a friend privately and gently.',
      listeningOutcome: 'Student appreciates confidentiality in friendship.',
      estimatedDurationMinutes: 10,
    ),

    // World 4
    const CurriculumLesson(
      id: 't5_l10_ai_and_human_wisdom',
      unitId: 'unit_t5_technology',
      levelId: 'level_t5',
      order: 10,
      title: 'Artificial Intelligence & Ethics 🤖',
      speakingOutcome: 'Student debates benefits and ethical risks of AI tools.',
      listeningOutcome: 'Student evaluates arguments regarding digital ethics.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l11_digital_balance_in_daily_life',
      unitId: 'unit_t5_technology',
      levelId: 'level_t5',
      order: 11,
      title: 'Digital Wellness & Focus 📱⚖️',
      speakingOutcome: 'Student proposes personal guidelines for screen moderation.',
      listeningOutcome: 'Student evaluates daily screen schedules.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l12_coding_for_social_good',
      unitId: 'unit_t5_technology',
      levelId: 'level_t5',
      order: 12,
      title: 'Technology for Social Welfare 💻',
      speakingOutcome: 'Student presents an app idea that serves community needs.',
      listeningOutcome: 'Student grasps social entrepreneurship pitches.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l13_protecting_privacy_online',
      unitId: 'unit_t5_technology',
      levelId: 'level_t5',
      order: 13,
      title: 'Safeguarding Digital Privacy 🔒',
      speakingOutcome: 'Student advises peers on secure passwords and digital footprint.',
      listeningOutcome: 'Student identifies online security vulnerabilities.',
      estimatedDurationMinutes: 10,
    ),

    // World 5
    const CurriculumLesson(
      id: 't5_l14_hydration_and_cognitive_power',
      unitId: 'unit_t5_health',
      levelId: 'level_t5',
      order: 14,
      title: 'Why Drinking Water Matters 💧🧠',
      speakingOutcome: 'Student explains with clear reasons: "Why is drinking water important? In my opinion..."',
      listeningOutcome: 'Student understands health and hydration explanations.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l15_nutrition_as_divine_trust',
      unitId: 'unit_t5_health',
      levelId: 'level_t5',
      order: 15,
      title: 'Nourishment as an Amanah 🥗',
      speakingOutcome: 'Student discusses mindful eating and gratitude for clean food.',
      listeningOutcome: 'Student follows health and nutrition explanations.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l16_sleep_and_memory_consolidation',
      unitId: 'unit_t5_health',
      levelId: 'level_t5',
      order: 16,
      title: 'The Science of Restful Sleep 🛏️🌙',
      speakingOutcome: 'Student explains how adequate sleep enhances learning and mood.',
      listeningOutcome: 'Student understands recommendations for good sleep habits.',
      estimatedDurationMinutes: 10,
    ),

    // World 6
    const CurriculumLesson(
      id: 't5_l17_launching_youth_mentorship',
      unitId: 'unit_t5_community',
      levelId: 'level_t5',
      order: 17,
      title: 'Organizing Youth Mentorship 🤝',
      speakingOutcome: 'Student shares plans for tutoring younger students.',
      listeningOutcome: 'Student coordinates group volunteer schedules.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l18_community_food_pantry',
      unitId: 'unit_t5_community',
      levelId: 'level_t5',
      order: 18,
      title: 'Supporting Community Food Drives 🍞',
      speakingOutcome: 'Student advocates for hunger relief and food preservation.',
      listeningOutcome: 'Student follows distribution logistics.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l19_advocating_for_public_parks',
      unitId: 'unit_t5_community',
      levelId: 'level_t5',
      order: 19,
      title: 'Advocating for Green Public Spaces 🌳',
      speakingOutcome: 'Student presents petition for planting shade trees.',
      listeningOutcome: 'Student identifies civic advocacy tools.',
      estimatedDurationMinutes: 10,
    ),

    // World 7
    const CurriculumLesson(
      id: 't5_l20_renewable_energy_solutions',
      unitId: 'unit_t5_nature',
      levelId: 'level_t5',
      order: 20,
      title: 'Renewable Energy for Clean Tomorrow ☀️💨',
      speakingOutcome: 'Student compares solar and wind power efficiency.',
      listeningOutcome: 'Student follows renewable energy reports.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l21_preserving_biodiversity',
      unitId: 'unit_t5_nature',
      levelId: 'level_t5',
      order: 21,
      title: 'Preserving Endangered Species 🐾🌿',
      speakingOutcome: 'Student explains the balance of ecosystems (Mizan).',
      listeningOutcome: 'Student grasps biodiversity interdependence.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l22_ethical_consumerism',
      unitId: 'unit_t5_nature',
      levelId: 'level_t5',
      order: 22,
      title: 'Ethical Consumption and Anti-Waste 🛍️♻️',
      speakingOutcome: 'Student argues against wasteful consumerism (Israf).',
      listeningOutcome: 'Student understands how recycling helps the environment.',
      estimatedDurationMinutes: 10,
    ),

    // World 8
    const CurriculumLesson(
      id: 't5_l23_the_heritage_of_cordoba',
      unitId: 'unit_t5_travel',
      levelId: 'level_t5',
      order: 23,
      title: 'Lessons from Historic Cordoba 🏛️',
      speakingOutcome: 'Student summarizes historical golden age achievements in sciences.',
      listeningOutcome: 'Student tracks historical chronology.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l24_cross_cultural_exchange',
      unitId: 'unit_t5_travel',
      levelId: 'level_t5',
      order: 24,
      title: 'Cross-Cultural Understanding 🌍🤝',
      speakingOutcome: 'Student explains how travel dispels misconceptions.',
      listeningOutcome: 'Student appreciates diverse cultural traditions.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l25_the_lessons_of_travel',
      unitId: 'unit_t5_travel',
      levelId: 'level_t5',
      order: 25,
      title: 'Travel as a School of Humility ✈️',
      speakingOutcome: 'Student reflects on personal growth through travel.',
      listeningOutcome: 'Student understands lessons learned from exploring new places.',
      estimatedDurationMinutes: 10,
    ),

    // World 9
    const CurriculumLesson(
      id: 't5_l26_identifying_root_causes',
      unitId: 'unit_t5_problems',
      levelId: 'level_t5',
      order: 26,
      title: 'Diagnosing the Root Cause 🔍',
      speakingOutcome: 'Student distinguishes surface symptoms from core problems.',
      listeningOutcome: 'Student identifies practical steps in problem solving.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l27_negotiating_win_win_solutions',
      unitId: 'unit_t5_problems',
      levelId: 'level_t5',
      order: 27,
      title: 'Negotiating Win-Win Solutions 🤝',
      speakingOutcome: 'Student suggests fair solutions that help both sides.',
      listeningOutcome: 'Student tracks diplomatic negotiation stages.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l28_long_term_impact_analysis',
      unitId: 'unit_t5_problems',
      levelId: 'level_t5',
      order: 28,
      title: 'Anticipating Future Consequences 🔮',
      speakingOutcome: 'Student models: "If we choose option A, the secondary impact will be..."',
      listeningOutcome: 'Student evaluates scenario forecasting.',
      estimatedDurationMinutes: 10,
    ),

    // World 10
    const CurriculumLesson(
      id: 't5_l29_the_etiquette_of_disagreement',
      unitId: 'unit_t5_opinions',
      levelId: 'level_t5',
      order: 29,
      title: 'The Noble Art of Disagreeing 🕊️',
      speakingOutcome: 'Student demonstrates polite divergence without emotional acrimony.',
      listeningOutcome: 'Student identifies respectful debate formulations.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l30_evidence_versus_emotion',
      unitId: 'unit_t5_opinions',
      levelId: 'level_t5',
      order: 30,
      title: 'Balancing Logic and Empathy ⚖️',
      speakingOutcome: 'Student integrates empirical evidence with compassionate delivery.',
      listeningOutcome: 'Student evaluates emotional appeal vs logical proof.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l31_building_consensus',
      unitId: 'unit_t5_opinions',
      levelId: 'level_t5',
      order: 31,
      title: 'Forging Consensus in Diverse Teams 🤝',
      speakingOutcome: 'Student facilitates dialogue uniting disparate viewpoints.',
      listeningOutcome: 'Student identifies consensus-building phrases.',
      estimatedDurationMinutes: 10,
    ),
    const CurriculumLesson(
      id: 't5_l32_speaking_truth_with_gentleness',
      unitId: 'unit_t5_opinions',
      levelId: 'level_t5',
      order: 32,
      title: 'Truth Spoken with Gentleness (Hikmah) 🌟',
      speakingOutcome: 'Student summarizes: "Courage is speaking truth, and wisdom is delivering it with gentleness."',
      listeningOutcome: 'Student recognizes diplomatic communication excellence.',
      estimatedDurationMinutes: 10,
    ),
  ];

  /// Builds the 5 handcrafted, production interactive activities for any Track 5 lesson.
  static List<InteractiveActivityConfig> getActivitiesForLesson(String lessonId) {
    switch (lessonId) {
      // ── Lesson 14: Why Drinking Water Matters (Theme: Food & Drinks) ──
      case 't5_l14_hydration_and_cognitive_power':
        final scene = CurriculumV2Scenes.foodKitchenScene();
        final water = scene.objects.firstWhere((o) => o.objectId == 'obj_food_water');
        final table = scene.objects.firstWhere((o) => o.objectId == 'obj_dining_table');
        final pip = scene.objects.firstWhere((o) => o.objectId == 'obj_dining_pip');
        final apple = scene.objects.firstWhere((o) => o.objectId == 'obj_food_apple');
        return [
          InteractiveActivityConfig(
            id: 't5_l14_step1_scientific_listening',
            conceptId: 'concept_water',
            learningConceptId: 'concept_water',
            mechanicType: ActivityMechanicType.listenAndTouch,
            scene: scene,
            targetObjectId: water.objectId,
            draggableObject: water,
            distractors: [apple, table],
            ageProfile: profile,
            instructionOverride: 'Pip explains: "Drinking clean water helps our brain focus and keeps our body healthy!" Touch the fresh water! 💧',
            audioPromptOverride: 'Touch the fresh water that keeps our body hydrated.',
            successReaction: SceneReactionType.waterRipple,
            successReactionPrompt: 'Fresh, cool water! Essential for keeping our body and mind alert! 💧✨',
          ),
          InteractiveActivityConfig(
            id: 't5_l14_step2_reasoned_opinion_speech',
            conceptId: 'concept_water',
            learningConceptId: 'concept_water',
            mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
            scene: scene,
            targetObjectId: water.objectId,
            draggableObject: water,
            sceneActor: pip,
            speakTriggerPhrase: 'why is drinking water important i think',
            ageProfile: profile,
            instructionOverride: 'Share your opinion: "Why is drinking water important? I think it helps our body stay healthy and active." 🗣️',
            audioPromptOverride: 'Say: Why is drinking water important? I think it helps our body stay healthy.',
            successReaction: SceneReactionType.waterRipple,
            successReactionPrompt: '"I think it helps our body stay healthy..." Clear and thoughtful answer! 🌟',
          ),
          InteractiveActivityConfig(
            id: 't5_l14_step3_stewardship_scenario',
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
            instructionOverride: 'Put a glass of fresh water on your study desk so you remember to drink. 🪵💧',
            audioPromptOverride: 'Place the water on the study desk',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Great habit! Having water nearby helps you stay alert while studying! 🪵✨',
          ),
          InteractiveActivityConfig(
            id: 't5_l14_step4_philosophical_discussion',
            conceptId: 'concept_water',
            learningConceptId: 'concept_water',
            mechanicType: ActivityMechanicType.conversationRolePlay,
            scene: scene,
            targetObjectId: pip.objectId,
            draggableObject: pip,
            rolePlayPipPrompt: 'Why is taking care of our health so important? 🦜',
            rolePlayExpectedResponse: 'our body is a trust from allah',
            ageProfile: profile,
            instructionOverride: 'Pip asks about taking care of ourselves. Answer: "Our body is a trust from Allah, so we must take care of it." 💬',
            audioPromptOverride: 'Answer: Our body is a trust from Allah, so we must take care of it.',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Wonderful thought! Taking care of our health is a great blessing and trust! ❤️',
          ),
          InteractiveActivityConfig(
            id: 't5_l14_step5_synthesis_mastery',
            conceptId: 'concept_water',
            learningConceptId: 'concept_water',
            mechanicType: ActivityMechanicType.listenAndTouch,
            scene: scene,
            targetObjectId: pip.objectId,
            draggableObject: pip,
            ageProfile: profile,
            instructionOverride: 'Tap Pip to complete today\'s discussion! 🎓',
            audioPromptOverride: 'Tap Pip to complete the activity!',
            successReaction: SceneReactionType.bounce,
            successReactionPrompt: 'Fantastic discussion! You shared thoughtful and mature ideas! 🌟🏆',
          ),
        ];

      default:
        return _generateDefaultTrack5Activities(lessonId);
    }
  }

  static List<InteractiveActivityConfig> _generateDefaultTrack5Activities(String lessonId) {
    final scene = _resolveSceneForLesson(lessonId);
    final targetObj = scene.objects.firstWhere(
      (o) => !o.objectId.toLowerCase().contains('pip'),
      orElse: () => scene.objects.first,
    );
    final secondaryObj = scene.objects.firstWhere(
      (o) => o.objectId != targetObj.objectId,
      orElse: () => targetObj,
    );
    final pip = scene.objects.firstWhere(
      (o) => o.objectId.toLowerCase().contains('pip') || o.label.toLowerCase().contains('pip'),
      orElse: () => secondaryObj,
    );

    final isProblemSolving = lessonId.contains('solve') ||
        lessonId.contains('agree') ||
        lessonId.contains('negotiat') ||
        lessonId.contains('team') ||
        lessonId.contains('friend') ||
        lessonId.contains('conflict') ||
        lessonId.contains('causes') ||
        lessonId.contains('mentor');

    final isProjectPlanning = lessonId.contains('plan') ||
        lessonId.contains('project') ||
        lessonId.contains('future') ||
        lessonId.contains('steward') ||
        lessonId.contains('travel') ||
        lessonId.contains('cordoba') ||
        lessonId.contains('waste') ||
        lessonId.contains('impact') ||
        lessonId.contains('habit');

    // Archetype B: Collaborative Problem Solving & Dialogue (6 interactions)
    if (isProblemSolving) {
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
          instructionOverride: 'Listen to the situation: Find the ${targetObj.label}. ${targetObj.emoji}',
          audioPromptOverride: 'Listen to the situation and select the ${targetObj.label}.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Great listening! Found the ${targetObj.label}! ${targetObj.emoji}',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step2_cooperate',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.dragAndDrop,
          scene: scene,
          targetObjectId: targetObj.objectId,
          targetDestinationId: secondaryObj.objectId,
          draggableObject: targetObj,
          dropTarget: secondaryObj,
          ageProfile: profile,
          instructionOverride: 'Work together: Move the ${targetObj.label} over to ${secondaryObj.label} to share. 🤝',
          audioPromptOverride: 'Move the ${targetObj.label} to share with ${secondaryObj.label}',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Cooperation makes solving problems easier! ✨',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step3_propose_solution',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          speakTriggerPhrase: 'why do we not share and work together',
          ageProfile: profile,
          instructionOverride: 'Suggest a helpful idea: "Why don\'t we share and work together?" 🗣️',
          audioPromptOverride: 'Suggest: Why don\'t we share and work together?',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Great suggestion! Working together is always the best solution! 🌟',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step4_dialogue_compromise',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.conversationRolePlay,
          scene: scene,
          targetObjectId: secondaryObj.objectId,
          draggableObject: secondaryObj,
          rolePlayPipPrompt: 'How should our team resolve this situation fairly? 🦜',
          rolePlayExpectedResponse: 'we listen with respect and find common ground',
          ageProfile: profile,
          instructionOverride: 'Pip asks how to resolve it fairly. Answer: "We listen with respect and find common ground." 💬',
          audioPromptOverride: 'Answer: We listen with respect and find common ground.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Very wise! Listening with respect helps everyone feel valued! ❤️',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step5_arrange_solution',
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
          instructionOverride: 'Put the ${targetObj.label} neatly beside ${secondaryObj.label}. 🧩',
          audioPromptOverride: 'Place the ${targetObj.label} beside ${secondaryObj.label}',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Everything is in order! Great teamwork! ✨',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step6_celebrate_teamwork',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: pip.objectId,
          draggableObject: pip,
          ageProfile: profile,
          instructionOverride: 'Tap Pip to celebrate solving this problem together! ⭐🎉',
          audioPromptOverride: 'Tap Pip to finish!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Hooray! Outstanding communication and problem solving! 🌟🏆',
        ),
      ];
    }

    // Archetype C: Project Planning & Case Study (7 interactions)
    if (isProjectPlanning) {
      return [
        InteractiveActivityConfig(
          id: '${lessonId}_step1_story_intro',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.interactiveStory,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          ageProfile: profile,
          storySegmentText: 'Planning ahead helps our projects succeed and benefits our community.',
          instructionOverride: 'Listen to the project scenario: We are preparing a helpful plan! 📋',
          audioPromptOverride: 'Listen to the project plan.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Great focus! Planning makes our work purposeful! 🌟',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step2_identify_tool',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          distractors: [secondaryObj],
          ageProfile: profile,
          instructionOverride: 'Identify the key item for our project: Find the ${targetObj.label}. 🔍',
          audioPromptOverride: 'Find the ${targetObj.label}.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Target identified! We have our key resource! ${targetObj.emoji}',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step3_present_plan',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
          scene: scene,
          targetObjectId: targetObj.objectId,
          draggableObject: targetObj,
          speakTriggerPhrase: 'next week we are going to start our project',
          ageProfile: profile,
          instructionOverride: 'State your plan clearly: "Next week, we are going to start our project." 🗣️',
          audioPromptOverride: 'Say: Next week, we are going to start our project.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Clear and confident plan! Well spoken! 🌟',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step4_setup_workspace',
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
          instructionOverride: 'Set up the work area: Place the ${targetObj.label} on the workspace. 🪵',
          audioPromptOverride: 'Place the ${targetObj.label} on the table',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Workspace organized neatly! Ready for action! ✨',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step5_discuss_first_goal',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.conversationRolePlay,
          scene: scene,
          targetObjectId: secondaryObj.objectId,
          draggableObject: secondaryObj,
          rolePlayPipPrompt: 'What is our first goal for this project? 🦜',
          rolePlayExpectedResponse: 'our first goal is to plan carefully and work together',
          ageProfile: profile,
          instructionOverride: 'Pip asks about your goal. Answer: "Our first goal is to plan carefully and work together." 💬',
          audioPromptOverride: 'Answer: Our first goal is to plan carefully and work together.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Excellent goal! Setting clear aims keeps everyone focused! ❤️',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step6_discuss_community_impact',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.conversationRolePlay,
          scene: scene,
          targetObjectId: pip.objectId,
          draggableObject: pip,
          rolePlayPipPrompt: 'How will our project help our community? 🦜',
          rolePlayExpectedResponse: 'it will help our school and neighbors',
          ageProfile: profile,
          instructionOverride: 'Pip asks about the impact. Answer: "It will help our school and neighbors." 💬',
          audioPromptOverride: 'Answer: It will help our school and neighbors.',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Wonderful spirit of service! True leadership in action! ❤️',
        ),
        InteractiveActivityConfig(
          id: '${lessonId}_step7_conclude_project',
          conceptId: targetObj.conceptId,
          learningConceptId: targetObj.conceptId,
          mechanicType: ActivityMechanicType.listenAndTouch,
          scene: scene,
          targetObjectId: pip.objectId,
          draggableObject: pip,
          ageProfile: profile,
          instructionOverride: 'Tap Pip to complete your project plan! 🎓🏆',
          audioPromptOverride: 'Tap Pip to complete the activity!',
          successReaction: SceneReactionType.bounce,
          successReactionPrompt: 'Fantastic work! You demonstrated mature planning and communication! 🌟🎉',
        ),
      ];
    }

    // Archetype A: Opinion & Reasoned Discussion (5 interactions)
    return [
      InteractiveActivityConfig(
        id: '${lessonId}_step1_listen_clue',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.listenAndTouch,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        distractors: [secondaryObj],
        ageProfile: profile,
        instructionOverride: 'Listen to the clues and find the ${targetObj.label}. ${targetObj.emoji}',
        audioPromptOverride: 'Find the ${targetObj.label}.',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Great listening! You found the ${targetObj.label}! ${targetObj.emoji}',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step2_express_opinion',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.speakToMakeSomethingHappen,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        speakTriggerPhrase: 'in my opinion the ${targetObj.label.toLowerCase()} is very important',
        ageProfile: profile,
        instructionOverride: 'Share your view: "In my opinion, the ${targetObj.label} is very important." 🗣️',
        audioPromptOverride: 'Say: In my opinion, the ${targetObj.label} is very important.',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: '"In my opinion..." Thoughtful and articulate opinion! 🌟',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step3_context_placement',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.scenePlacement,
        scene: scene,
        targetObjectId: targetObj.objectId,
        targetDestinationId: secondaryObj.objectId,
        draggableObject: targetObj,
        dropTarget: secondaryObj,
        spatialRelation: 'with',
        ageProfile: profile,
        instructionOverride: 'Put the ${targetObj.label} in place with ${secondaryObj.label}. 🧩',
        audioPromptOverride: 'Place the ${targetObj.label} with ${secondaryObj.label}',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Placed in the right spot! Context complete! ✨',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step4_discussion_turn',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.conversationRolePlay,
        scene: scene,
        targetObjectId: secondaryObj.objectId,
        draggableObject: secondaryObj,
        rolePlayPipPrompt: 'Why do you think that choice is helpful? 🦜',
        rolePlayExpectedResponse: 'because it helps people and makes things better',
        ageProfile: profile,
        instructionOverride: 'Pip asks why. Answer: "Because it helps people and makes things better." 💬',
        audioPromptOverride: 'Answer: Because it helps people and makes things better.',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Very thoughtful reasoning! That makes a lot of sense! ❤️',
      ),
      InteractiveActivityConfig(
        id: '${lessonId}_step5_wrap_up',
        conceptId: targetObj.conceptId,
        learningConceptId: targetObj.conceptId,
        mechanicType: ActivityMechanicType.listenAndTouch,
        scene: scene,
        targetObjectId: pip.objectId,
        draggableObject: pip,
        ageProfile: profile,
        instructionOverride: 'Tap Pip to complete today\'s discussion! ⭐🎓',
        audioPromptOverride: 'Tap Pip to finish!',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Wonderful job today! Great speaking and thoughtful ideas! 🌟🏆',
      ),
    ];
  }

  static InteractiveScene _resolveSceneForLesson(String lessonId) {
    if (lessonId.contains('identity') || lessonId.contains('philosophy') || lessonId.contains('virtues') || lessonId.contains('aspirations')) {
      return CurriculumV2Scenes.helloMeScene();
    }
    if (lessonId.contains('school') || lessonId.contains('evidence') || lessonId.contains('critique') || lessonId.contains('thinking')) {
      return CurriculumV2Scenes.schoolClassroomScene();
    }
    if (lessonId.contains('friendship') || lessonId.contains('consultation') || lessonId.contains('pressure') || lessonId.contains('advice')) {
      return CurriculumV2Scenes.helloMeScene();
    }
    if (lessonId.contains('technology') || lessonId.contains('ai') || lessonId.contains('balance') || lessonId.contains('coding') || lessonId.contains('privacy')) {
      return CurriculumV2Scenes.schoolClassroomScene();
    }
    if (lessonId.contains('health') || lessonId.contains('hydration') || lessonId.contains('nutrition') || lessonId.contains('sleep')) {
      return CurriculumV2Scenes.foodKitchenScene();
    }
    if (lessonId.contains('community') || lessonId.contains('mentorship') || lessonId.contains('pantry') || lessonId.contains('parks')) {
      return CurriculumV2Scenes.natureParkScene();
    }
    if (lessonId.contains('nature') || lessonId.contains('energy') || lessonId.contains('biodiversity') || lessonId.contains('consumerism')) {
      return CurriculumV2Scenes.natureParkScene();
    }
    if (lessonId.contains('travel') || lessonId.contains('cordoba') || lessonId.contains('cultural') || lessonId.contains('lessons')) {
      return CurriculumV2Scenes.townMarketScene();
    }
    if (lessonId.contains('problems') || lessonId.contains('causes') || lessonId.contains('solutions') || lessonId.contains('impact')) {
      return CurriculumV2Scenes.schoolClassroomScene();
    }
    if (lessonId.contains('opinions') || lessonId.contains('disagreement') || lessonId.contains('evidence') || lessonId.contains('consensus') || lessonId.contains('truth')) {
      return CurriculumV2Scenes.helloMeScene();
    }
    return CurriculumV2Scenes.natureParkScene();
  }
}
