/// Pedagogical age groupings defining presentation style, reading scaffolding,
/// and cognitive affordances — strictly separated from English proficiency / curriculum level.
enum LearningAgeBand {
  /// Ages 3–4: Zero required reading, pure audio-first, huge touch targets, optional speaking.
  bandPreALittleListeners,

  /// Ages 4–5: Minimal text, heavy audio imitation, high visual support, short instructions.
  bandALittleExplorers,

  /// Ages 6–7: Emerging reading support, question-and-answer, simple sentences, phonics.
  bandBYoungAdventurers,

  /// Ages 8–10: Richer reading, contextual grammar, conversational English, storytelling.
  bandCGrowingSpeakers,

  /// Ages 10–12+: Longer discourse, reasoning, comparison, debate, social problem solving.
  bandDConfidentSpeakers;

  String get displayName {
    switch (this) {
      case LearningAgeBand.bandPreALittleListeners:
        return 'Little Listeners (Ages 3–4)';
      case LearningAgeBand.bandALittleExplorers:
        return 'Little Explorers (Ages 4–5)';
      case LearningAgeBand.bandBYoungAdventurers:
        return 'Young Adventurers (Ages 6–7)';
      case LearningAgeBand.bandCGrowingSpeakers:
        return 'Growing Speakers (Ages 8–10)';
      case LearningAgeBand.bandDConfidentSpeakers:
        return 'Confident Speakers (Ages 10–12+)';
    }
  }

  int get minAge {
    switch (this) {
      case LearningAgeBand.bandPreALittleListeners:
        return 3;
      case LearningAgeBand.bandALittleExplorers:
        return 4;
      case LearningAgeBand.bandBYoungAdventurers:
        return 6;
      case LearningAgeBand.bandCGrowingSpeakers:
        return 8;
      case LearningAgeBand.bandDConfidentSpeakers:
        return 10;
    }
  }

  int get maxAge {
    switch (this) {
      case LearningAgeBand.bandPreALittleListeners:
        return 4;
      case LearningAgeBand.bandALittleExplorers:
        return 5;
      case LearningAgeBand.bandBYoungAdventurers:
        return 7;
      case LearningAgeBand.bandCGrowingSpeakers:
        return 10;
      case LearningAgeBand.bandDConfidentSpeakers:
        return 14;
    }
  }

  /// Resolves the appropriate age band for a child's chronological age.
  /// Defaults age 4 to bandALittleExplorers for backward compatibility unless preferPreAForAge4 is set.
  static LearningAgeBand fromAge(int age, {bool preferPreAForAge4 = false}) {
    if (age <= 3 || (age == 4 && preferPreAForAge4)) {
      return LearningAgeBand.bandPreALittleListeners;
    }
    if (age <= 5) return LearningAgeBand.bandALittleExplorers;
    if (age <= 7) return LearningAgeBand.bandBYoungAdventurers;
    if (age <= 10) return LearningAgeBand.bandCGrowingSpeakers;
    return LearningAgeBand.bandDConfidentSpeakers;
  }

  /// Recommended maximum session duration in minutes for this developmental band.
  int get recommendedSessionMinutes {
    switch (this) {
      case LearningAgeBand.bandPreALittleListeners:
        return 4; // 3–6 minutes target
      case LearningAgeBand.bandALittleExplorers:
        return 5;
      case LearningAgeBand.bandBYoungAdventurers:
        return 8;
      case LearningAgeBand.bandCGrowingSpeakers:
        return 12;
      case LearningAgeBand.bandDConfidentSpeakers:
        return 15;
    }
  }

  /// Whether text labels require supplementary audio auto-play.
  bool get requiresAudioAutoplay =>
      this == LearningAgeBand.bandPreALittleListeners ||
      this == LearningAgeBand.bandALittleExplorers;

  /// Amount of reading expected in UI interactions.
  String get readingExpectation {
    switch (this) {
      case LearningAgeBand.bandPreALittleListeners:
        return 'Zero (Pure audio-visual, zero required reading)';
      case LearningAgeBand.bandALittleExplorers:
        return 'Minimal (Pre-literate, relies on iconography and speech)';
      case LearningAgeBand.bandBYoungAdventurers:
        return 'Emergent (Single words and 2-3 word captions)';
      case LearningAgeBand.bandCGrowingSpeakers:
        return 'Functional (Short paragraphs, speech bubbles)';
      case LearningAgeBand.bandDConfidentSpeakers:
        return 'Independent (Extended stories, multi-turn dialogues)';
    }
  }
}
