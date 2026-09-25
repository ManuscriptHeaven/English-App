import 'package:equatable/equatable.dart';
import '../../features/curriculum/domain/models/learning_age_band.dart';

/// Reading requirements across developmental age profiles.
enum ReadingRequirement {
  none, // Zero required reading; pure audio & visual icons (Age 3-4)
  emergent, // Single word recognition, optional phonetic hints (Age 4-5)
  supported, // Short captions and supported sentences (Age 6-7)
  independent, // Paragraphs, multi-turn dialogues, unassisted text (Age 8-12+)
}

/// Text density allowed in UI presentation.
enum TextDensity {
  zero, // No text labels on targets (pure icons/emojis)
  minimal, // Target word only
  moderate, // Word + short sentence caption
  rich, // Context paragraph, speech bubbles, narrative cards
}

/// Style of instruction delivery.
enum InstructionStyle {
  audioVisualDemonstration, // Model with sound & motion demonstration (Age 3-4)
  shortSpokenDirective, // 2-4 word direct audio prompt: "Find the cat" (Age 4-5)
  spokenSentenceWithVisual, // Complete question/sentence with visual support (Age 6-7)
  conversationalContext, // Authentic dialogic prompt & reasoning (Age 8-12+)
}

/// Frequency and verbosity of Pip mascot speech.
enum PipSpeechFrequency {
  occasionalMusical, // Ultra-short chirps & sound expressions (Age 3-4)
  friendlyRegular, // Encouraging short prompts on every interaction (Age 4-7)
  supportiveTargeted, // Only speaks on prompts, errors, and completions (Age 8-10)
  minimalConcise, // Unobtrusive, peer-like, never patronizing (Age 10-12+)
}

/// Mascot physical motion intensity.
enum PipAnimationIntensity {
  highPlayful, // Energetic bounce, peek-a-boo, sparkling poses
  gentleBounce, // Steady, reassuring gentle vertical bob
  subtleRefined, // Calm idle and subtle nod/smile
}

/// Speaking requirements and gating behavior.
enum SpeakingRequirement {
  optionalImitation, // Purely optional imitation ("Can you say apple?"), zero penalty if silent
  encouragedRepetition, // Encouraged repetition, easy skip available
  expectedProduction, // Core learning expectation with friendly retry and touch fallback
  conversationalDiscourse, // Multi-turn spoken answers and reasoning
}

/// Hint presentation mechanics.
enum HintIntensity {
  autoPulsingGlow, // Target automatically pulses after brief pause
  pipPromptOnPause, // Pip nudges with audio clue if child pauses
  onDemandButton, // Child explicitly requests hint via lightbulb button
}

/// Cognitive complexity of interaction mechanics.
enum InteractionComplexity {
  directTouchMove, // Single tap or simple direct move
  guidedDragMatch, // Drag item to highlighted matching target
  structuredAssembly, // Multi-step ordering, prepositional placement
  contextualProblemSolving, // Scenario role-play, reasoning choices
}

/// Depth of conversational exchanges.
enum ConversationDepth {
  singleWordEcho, // Child echoes target word ("Apple")
  twoWordPhrase, // Short phrase ("Red apple", "Water, please")
  targetSentence, // Full sentence ("It is an apple", "I have a cat")
  followUpReasoning, // Opinion and reasoning ("I like apples because they are sweet")
  extendedDiscourse, // Multi-turn dialogue with hypothetical choices
}

/// Centralized developmental model defining how learning concepts and activities
/// are delivered to children across chronological ages and developmental bands.
class AgeExperienceProfile extends Equatable {
  final LearningAgeBand ageBand;
  final int age;
  final ReadingRequirement readingRequirement;
  final TextDensity textDensity;
  final InstructionStyle instructionStyle;
  final int instructionLengthWordsMax;
  final double visualTargetSize;
  final int numberOfChoices;
  final PipSpeechFrequency pipSpeechFrequency;
  final PipAnimationIntensity pipAnimationIntensity;
  final int rewardIntensity; // 1 (subtle) to 4 (maximum)
  final Duration activityDuration;
  final Duration sessionDuration;
  final SpeakingRequirement speakingRequirement;
  final double modelAudioFrequency; // 1.0 = every prompt, 0.5 = on-demand
  final bool replayAvailability;
  final HintIntensity hintIntensity;
  final InteractionComplexity interactionComplexity;
  final Duration transitionSpeed;
  final ConversationDepth conversationDepth;

  const AgeExperienceProfile({
    required this.ageBand,
    required this.age,
    required this.readingRequirement,
    required this.textDensity,
    required this.instructionStyle,
    required this.instructionLengthWordsMax,
    required this.visualTargetSize,
    required this.numberOfChoices,
    required this.pipSpeechFrequency,
    required this.pipAnimationIntensity,
    required this.rewardIntensity,
    required this.activityDuration,
    required this.sessionDuration,
    required this.speakingRequirement,
    required this.modelAudioFrequency,
    required this.replayAvailability,
    required this.hintIntensity,
    required this.interactionComplexity,
    required this.transitionSpeed,
    required this.conversationDepth,
  });

  /// Builds the centralized experience profile for a given chronological [age].
  factory AgeExperienceProfile.forAge(int age, {bool preferPreAForAge4 = false}) {
    if (age <= 3 || (age == 4 && preferPreAForAge4)) {
      return const AgeExperienceProfile(
        ageBand: LearningAgeBand.bandPreALittleListeners,
        age: 3,
        readingRequirement: ReadingRequirement.none,
        textDensity: TextDensity.zero,
        instructionStyle: InstructionStyle.audioVisualDemonstration,
        instructionLengthWordsMax: 2,
        visualTargetSize: 120.0,
        numberOfChoices: 2,
        pipSpeechFrequency: PipSpeechFrequency.occasionalMusical,
        pipAnimationIntensity: PipAnimationIntensity.highPlayful,
        rewardIntensity: 3,
        activityDuration: Duration(seconds: 40),
        sessionDuration: Duration(minutes: 4), // 3–6 min target
        speakingRequirement: SpeakingRequirement.optionalImitation,
        modelAudioFrequency: 1.0,
        replayAvailability: true,
        hintIntensity: HintIntensity.autoPulsingGlow,
        interactionComplexity: InteractionComplexity.directTouchMove,
        transitionSpeed: Duration(milliseconds: 600),
        conversationDepth: ConversationDepth.singleWordEcho,
      );
    }

    if (age <= 5) {
      return const AgeExperienceProfile(
        ageBand: LearningAgeBand.bandALittleExplorers,
        age: 5,
        readingRequirement: ReadingRequirement.emergent,
        textDensity: TextDensity.minimal,
        instructionStyle: InstructionStyle.shortSpokenDirective,
        instructionLengthWordsMax: 4,
        visualTargetSize: 96.0,
        numberOfChoices: 3,
        pipSpeechFrequency: PipSpeechFrequency.friendlyRegular,
        pipAnimationIntensity: PipAnimationIntensity.highPlayful,
        rewardIntensity: 3,
        activityDuration: Duration(seconds: 60),
        sessionDuration: Duration(minutes: 6), // 5–8 min target
        speakingRequirement: SpeakingRequirement.encouragedRepetition,
        modelAudioFrequency: 1.0,
        replayAvailability: true,
        hintIntensity: HintIntensity.pipPromptOnPause,
        interactionComplexity: InteractionComplexity.guidedDragMatch,
        transitionSpeed: Duration(milliseconds: 400),
        conversationDepth: ConversationDepth.twoWordPhrase,
      );
    }

    if (age <= 7) {
      return const AgeExperienceProfile(
        ageBand: LearningAgeBand.bandBYoungAdventurers,
        age: 7,
        readingRequirement: ReadingRequirement.supported,
        textDensity: TextDensity.moderate,
        instructionStyle: InstructionStyle.spokenSentenceWithVisual,
        instructionLengthWordsMax: 8,
        visualTargetSize: 76.0,
        numberOfChoices: 4,
        pipSpeechFrequency: PipSpeechFrequency.friendlyRegular,
        pipAnimationIntensity: PipAnimationIntensity.gentleBounce,
        rewardIntensity: 2,
        activityDuration: Duration(seconds: 90),
        sessionDuration: Duration(minutes: 10), // 8–12 min target
        speakingRequirement: SpeakingRequirement.expectedProduction,
        modelAudioFrequency: 0.8,
        replayAvailability: true,
        hintIntensity: HintIntensity.onDemandButton,
        interactionComplexity: InteractionComplexity.structuredAssembly,
        transitionSpeed: Duration(milliseconds: 300),
        conversationDepth: ConversationDepth.targetSentence,
      );
    }

    if (age <= 10) {
      return const AgeExperienceProfile(
        ageBand: LearningAgeBand.bandCGrowingSpeakers,
        age: 9,
        readingRequirement: ReadingRequirement.independent,
        textDensity: TextDensity.rich,
        instructionStyle: InstructionStyle.conversationalContext,
        instructionLengthWordsMax: 14,
        visualTargetSize: 58.0,
        numberOfChoices: 4,
        pipSpeechFrequency: PipSpeechFrequency.supportiveTargeted,
        pipAnimationIntensity: PipAnimationIntensity.subtleRefined,
        rewardIntensity: 1,
        activityDuration: Duration(seconds: 120),
        sessionDuration: Duration(minutes: 12), // 10–15 min target
        speakingRequirement: SpeakingRequirement.conversationalDiscourse,
        modelAudioFrequency: 0.5,
        replayAvailability: true,
        hintIntensity: HintIntensity.onDemandButton,
        interactionComplexity: InteractionComplexity.contextualProblemSolving,
        transitionSpeed: Duration(milliseconds: 200),
        conversationDepth: ConversationDepth.followUpReasoning,
      );
    }

    // Age 11+ (Band D)
    return const AgeExperienceProfile(
      ageBand: LearningAgeBand.bandDConfidentSpeakers,
      age: 11,
      readingRequirement: ReadingRequirement.independent,
      textDensity: TextDensity.rich,
      instructionStyle: InstructionStyle.conversationalContext,
      instructionLengthWordsMax: 20,
      visualTargetSize: 52.0,
      numberOfChoices: 4,
      pipSpeechFrequency: PipSpeechFrequency.minimalConcise,
      pipAnimationIntensity: PipAnimationIntensity.subtleRefined,
      rewardIntensity: 1,
      activityDuration: Duration(seconds: 150),
      sessionDuration: Duration(minutes: 16),
      speakingRequirement: SpeakingRequirement.conversationalDiscourse,
      modelAudioFrequency: 0.3,
      replayAvailability: true,
      hintIntensity: HintIntensity.onDemandButton,
      interactionComplexity: InteractionComplexity.contextualProblemSolving,
      transitionSpeed: Duration(milliseconds: 180),
      conversationDepth: ConversationDepth.extendedDiscourse,
    );
  }

  /// Builds experience profile directly from [LearningAgeBand].
  factory AgeExperienceProfile.forAgeBand(LearningAgeBand band) {
    switch (band) {
      case LearningAgeBand.bandPreALittleListeners:
        return AgeExperienceProfile.forAge(3);
      case LearningAgeBand.bandALittleExplorers:
        return AgeExperienceProfile.forAge(5);
      case LearningAgeBand.bandBYoungAdventurers:
        return AgeExperienceProfile.forAge(7);
      case LearningAgeBand.bandCGrowingSpeakers:
        return AgeExperienceProfile.forAge(9);
      case LearningAgeBand.bandDConfidentSpeakers:
        return AgeExperienceProfile.forAge(11);
    }
  }

  /// Adapts prompt text according to age band and concept.
  String adaptPrompt(String conceptWord) {
    switch (ageBand) {
      case LearningAgeBand.bandPreALittleListeners:
        return '$conceptWord! 🎈';
      case LearningAgeBand.bandALittleExplorers:
        return 'Find the $conceptWord. 🔍';
      case LearningAgeBand.bandBYoungAdventurers:
        return 'What is this? It is a $conceptWord.';
      case LearningAgeBand.bandCGrowingSpeakers:
        return 'Can you use "$conceptWord" in everyday conversation?';
      case LearningAgeBand.bandDConfidentSpeakers:
        return 'What snack would you choose? Explain why.';
    }
  }

  @override
  List<Object?> get props => [
        ageBand,
        age,
        readingRequirement,
        textDensity,
        instructionStyle,
        instructionLengthWordsMax,
        visualTargetSize,
        numberOfChoices,
        pipSpeechFrequency,
        pipAnimationIntensity,
        rewardIntensity,
        activityDuration,
        sessionDuration,
        speakingRequirement,
        modelAudioFrequency,
        replayAvailability,
        hintIntensity,
        interactionComplexity,
        transitionSpeed,
        conversationDepth,
      ];
}
