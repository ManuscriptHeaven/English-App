import 'learning_age_band.dart';

/// The 5 Production Learning Tracks separating chronological age and cognitive affordances
/// from English proficiency level.
enum CurriculumTrack {
  track1LittleListeners(
    id: 'track_1_listeners',
    title: 'Track 1 — Little Listeners',
    shortName: 'Little Listeners',
    ageRange: 'Age 3–4',
    minAge: 3,
    maxAge: 4,
    ageBand: LearningAgeBand.bandPreALittleListeners,
    pedagogicalGoal: 'First exposure to English through listening, visual recognition, movement, imitation and play. Zero required reading, zero formal grammar, speaking optional.',
    speakingOutcomeTarget: 'Imitative sounds, single words, greetings, emotional choices.',
    listeningOutcomeTarget: 'Word recognition, sound association, following 1-step physical actions.',
  ),
  track2LittleSpeakers(
    id: 'track_2_speakers',
    title: 'Track 2 — Little Speakers',
    shortName: 'Little Speakers',
    ageRange: 'Age 5–6',
    minAge: 5,
    maxAge: 6,
    ageBand: LearningAgeBand.bandALittleExplorers,
    pedagogicalGoal: 'Vocabulary to phrases to first functional sentences. Minimal text, high visual support, polite functional expressions.',
    speakingOutcomeTarget: '2–3 word phrases, simple requests ("Water please", "I like apples"), identifying items.',
    listeningOutcomeTarget: 'Phrases, short directives, simple question recognition.',
  ),
  track3YoungSpeakers(
    id: 'track_3_young_speakers',
    title: 'Track 3 — Young Speakers',
    shortName: 'Young Speakers',
    ageRange: 'Age 7–8',
    minAge: 7,
    maxAge: 8,
    ageBand: LearningAgeBand.bandBYoungAdventurers,
    pedagogicalGoal: 'Build real beginner spoken English. Complete sentence patterns, wh-questions, functional polite language in school, home, and play.',
    speakingOutcomeTarget: 'Full simple sentences ("I can...", "There is..."), asking and answering basic questions, polite requests.',
    listeningOutcomeTarget: 'Short dialogues, multi-step directions, conversational questions.',
  ),
  track4GrowingCommunicators(
    id: 'track_4_growing_communicators',
    title: 'Track 4 — Growing Communicators',
    shortName: 'Growing Communicators',
    ageRange: 'Age 9–10',
    minAge: 9,
    maxAge: 10,
    ageBand: LearningAgeBand.bandCGrowingSpeakers,
    pedagogicalGoal: 'Move from beginner sentences into real conversation. Multi-turn dialogues, simple reasons, describing experiences, authentic non-toddler UI.',
    speakingOutcomeTarget: 'Expressing preferences with reasons ("I prefer... because..."), describing routines, asking follow-up questions.',
    listeningOutcomeTarget: 'Contextual stories, conversational turns, inference from dialogues.',
  ),
  track5ConfidentCommunicators(
    id: 'track_5_confident_communicators',
    title: 'Track 5 — Confident Communicators',
    shortName: 'Confident Communicators',
    ageRange: 'Age 11–12',
    minAge: 11,
    maxAge: 12,
    ageBand: LearningAgeBand.bandDConfidentSpeakers,
    pedagogicalGoal: 'Confident practical spoken English. Nuanced opinions, past/present/future usage in context, collaborative scenarios, problem solving.',
    speakingOutcomeTarget: 'Expressing opinions ("In my opinion...", "I agree because..."), future plans, storytelling, resolving daily dilemmas.',
    listeningOutcomeTarget: 'Extended discourse, complex problem narratives, conversational subtleties.',
  );

  final String id;
  final String title;
  final String shortName;
  final String ageRange;
  final int minAge;
  final int maxAge;
  final LearningAgeBand ageBand;
  final String pedagogicalGoal;
  final String speakingOutcomeTarget;
  final String listeningOutcomeTarget;

  const CurriculumTrack({
    required this.id,
    required this.title,
    required this.shortName,
    required this.ageRange,
    required this.minAge,
    required this.maxAge,
    required this.ageBand,
    required this.pedagogicalGoal,
    required this.speakingOutcomeTarget,
    required this.listeningOutcomeTarget,
  });

  /// Resolves the corresponding track for a child's chronological age.
  static CurriculumTrack forAge(int age) {
    if (age <= 4) return CurriculumTrack.track1LittleListeners;
    if (age <= 6) return CurriculumTrack.track2LittleSpeakers;
    if (age <= 8) return CurriculumTrack.track3YoungSpeakers;
    if (age <= 10) return CurriculumTrack.track4GrowingCommunicators;
    return CurriculumTrack.track5ConfidentCommunicators;
  }
}
