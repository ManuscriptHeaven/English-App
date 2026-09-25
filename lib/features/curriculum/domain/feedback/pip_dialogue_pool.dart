import '../models/learning_age_band.dart';

/// Categories of pedagogical interaction moments where Pip provides vocal/text cues.
enum PipDialogueType {
  standardCorrect,
  independentRecall,
  recoverySuccess,
  struggleRecovery,
  gentleRetry,
  streakPraise,
  listeningPraise,
  speakingPraise,
  lessonComplete,
  levelComplete,
}

/// Curated dialogue templates for Pip across learning events and developmental age bands.
/// Strictly prevents monotonic "Great job!" repetition and childish tones for older learners.
class PipDialoguePool {
  static final Map<LearningAgeBand, Map<PipDialogueType, List<String>>> _pools = {
    // ------------------------------------------------------------------------
    // Pre-A: Little Listeners (Ages 3–4) — Ultra-short, musical, warm, playful
    // ------------------------------------------------------------------------
    LearningAgeBand.bandPreALittleListeners: {
      PipDialogueType.standardCorrect: [
        'Yay! 🌟',
        'Look! 🐥',
        'Peek-a-boo! 🎈',
        'Pop! ⭐',
        'Good touch! 💖',
      ],
      PipDialogueType.independentRecall: [
        'Wow! 🌟',
        'You found it! 🐥',
        'Super! ✨',
      ],
      PipDialogueType.recoverySuccess: [
        'Yay! 🌟',
        'Got it! ⭐',
        'Nice! 🎈',
      ],
      PipDialogueType.struggleRecovery: [
        'Yay! Together! 💖',
        'Good trying! 🌟',
        'Look at that! 🐥',
      ],
      PipDialogueType.gentleRetry: [
        'Listen! 👂',
        'Touch here! 👆',
        'Almost! 🐥',
        'Let\'s try again! 🎈',
      ],
      PipDialogueType.streakPraise: [
        'Wow! 🌟',
        'Look at you! 🎈',
      ],
      PipDialogueType.listeningPraise: [
        'Listen! 👂',
        'Pip hears you! 🎶',
      ],
      PipDialogueType.speakingPraise: [
        'Say it! 🎙️',
        'Pip loves your voice! 🦜',
      ],
      PipDialogueType.lessonComplete: [
        'Yay! Star! ⭐',
        'Hooray! 🎈',
      ],
      PipDialogueType.levelComplete: [
        'Big star! 🏆',
        'Yay! 🌟',
      ],
    },

    // ------------------------------------------------------------------------
    // Band A: Little Explorers (Ages 4–5) — Warm, playful, very short
    // ------------------------------------------------------------------------
    LearningAgeBand.bandALittleExplorers: {
      PipDialogueType.standardCorrect: [
        'Yay! You got it! 🌟',
        'Look at that! High five! ✋',
        'Super! 🎈',
        'You did it! 🐥',
        'Nice! ⭐',
      ],
      PipDialogueType.independentRecall: [
        'All by yourself! 🚀',
        'You remembered! Super star! ✨',
        'Great remembering! 🌟',
      ],
      PipDialogueType.recoverySuccess: [
        'Yay! You got it! 🌟',
        'You did it! 🎈',
        'Nice! ⭐',
      ],
      PipDialogueType.struggleRecovery: [
        'You kept trying and did it! 💖',
        'Yay! We got it together! 🤝',
        'Wonderful try! Look at you go! 🌈',
      ],
      PipDialogueType.gentleRetry: [
        'Almost! Let\'s listen again! 👂',
        'Try again! Pip is right here! 😊',
        'Good try! Touch this one! 👆',
      ],
      PipDialogueType.streakPraise: [
        'Three in a row! Wow! 🔥',
        'On a roll! Keep going! 🎈',
      ],
      PipDialogueType.listeningPraise: [
        'Great listening! 👂',
        'Pip heard that! Nice! 🎶',
      ],
      PipDialogueType.speakingPraise: [
        'Nice speaking! Say it again! 🎙️',
        'Pip loved hearing your voice! 🦜',
      ],
      PipDialogueType.lessonComplete: [
        'You finished the adventure! 🌟',
        'Yay! Star earned! Let\'s celebrate! 🎈',
      ],
      PipDialogueType.levelComplete: [
        'You finished the whole world! 🏆',
      ],
    },

    // ------------------------------------------------------------------------
    // Band B: Young Adventurers (Ages 6–7) — Lively, encouraging, word-focused
    // ------------------------------------------------------------------------
    LearningAgeBand.bandBYoungAdventurers: {
      PipDialogueType.standardCorrect: [
        'Well done! That\'s right! ✅',
        'You got it! 🌟',
        'Nice work! 🚀',
        'That\'s the word! 🎯',
        'Spot on! 👍',
      ],
      PipDialogueType.independentRecall: [
        'You remembered that on your own! 💡',
        'Sharp memory! 🧠',
        'You knew it right away! ✨',
      ],
      PipDialogueType.recoverySuccess: [
        'You got it! 🌟',
        'Nice correction! 👍',
        'Nicely done! 🛡️',
      ],
      PipDialogueType.struggleRecovery: [
        'You kept trying and got it! 💖',
        'Great recovery! 🛡️',
        'That\'s the spirit! Fantastic! 🌈',
      ],
      PipDialogueType.gentleRetry: [
        'Almost! Listen to the clue again. 👂',
        'Good attempt! Take your time and try again. ⏳',
        'Close! Let\'s check together. 🔍',
      ],
      PipDialogueType.streakPraise: [
        'Great streak! 🔥',
        'You are in the zone! ⚡',
      ],
      PipDialogueType.listeningPraise: [
        'Great ears! Excellent listening! 🎧',
        'You caught that sound! 🎶',
      ],
      PipDialogueType.speakingPraise: [
        'Clear pronunciation! Great speaking! 🗣️',
        'Wonderful voice! Keep speaking aloud! 🎙️',
      ],
      PipDialogueType.lessonComplete: [
        'Lesson complete! Wonderful progress! 🎉',
        'You are growing into a confident speaker! 🌟',
      ],
      PipDialogueType.levelComplete: [
        'Incredible milestone reached! 🏆',
      ],
    },

    // ------------------------------------------------------------------------
    // Band C: Growing Speakers (Ages 8–10) — Respectful, mature, conversational
    // ------------------------------------------------------------------------
    LearningAgeBand.bandCGrowingSpeakers: {
      PipDialogueType.standardCorrect: [
        'Exactly right!',
        'Nice.',
        'Yes!',
        "That's it.",
        'Nice work!',
      ],
      PipDialogueType.independentRecall: [
        'You remembered it!',
        'You said that really well.',
        'Nice work on your own.',
      ],
      PipDialogueType.recoverySuccess: [
        'You got it this time!',
        'Nice correction.',
        'Nicely done.',
      ],
      PipDialogueType.struggleRecovery: [
        'You kept trying and got it!',
        'Great effort! Practice makes progress.',
      ],
      PipDialogueType.gentleRetry: [
        'Try that one again.',
        'Listen once more.',
        'Close try! Take another look.',
      ],
      PipDialogueType.streakPraise: [
        'Great streak! Keep your focus.',
        'Strong momentum!',
      ],
      PipDialogueType.listeningPraise: [
        'Great listening!',
        'Nice catch!',
      ],
      PipDialogueType.speakingPraise: [
        'Great speaking!',
        'Nice sentence!',
      ],
      PipDialogueType.lessonComplete: [
        'Adventure complete! Great job today!',
        'Solid progress today.',
      ],
      PipDialogueType.levelComplete: [
        'You finished this level! 🏆',
      ],
    },

    // ------------------------------------------------------------------------
    // Band D: Confident Speakers (Ages 10–12+) — Engaging, mature child tone
    // ------------------------------------------------------------------------
    LearningAgeBand.bandDConfidentSpeakers: {
      PipDialogueType.standardCorrect: [
        'Nice.',
        'Yes!',
        'Exactly right.',
        'Spot on.',
      ],
      PipDialogueType.independentRecall: [
        'You remembered it!',
        'Great speaking.',
      ],
      PipDialogueType.recoverySuccess: [
        'You got it this time!',
        'Nice correction.',
      ],
      PipDialogueType.struggleRecovery: [
        'You kept working at it. Well done.',
        'Great perseverance.',
      ],
      PipDialogueType.gentleRetry: [
        'Try that sentence again.',
        'Listen once more.',
      ],
      PipDialogueType.streakPraise: [
        'Strong streak! Great focus.',
      ],
      PipDialogueType.listeningPraise: [
        'Great listening.',
        'That was clear.',
      ],
      PipDialogueType.speakingPraise: [
        'Nice speaking.',
        'Great speaking.',
      ],
      PipDialogueType.lessonComplete: [
        'Great progress today! You completed the challenge.',
      ],
      PipDialogueType.levelComplete: [
        'Challenge completed! Level finished! 🏆',
      ],
    },
  };

  // State index tracking to prevent repeating the same prompt consecutively
  static final Map<String, int> _lastIndex = {};

  /// Exposes dialogue pools for testing, verification, and editorial audit.
  static Map<LearningAgeBand, Map<PipDialogueType, List<String>>> get pools => _pools;

  /// Retrieves a varied, non-repetitive dialogue prompt for the specified event and age band.
  static String getPrompt({
    required PipDialogueType type,
    LearningAgeBand ageBand = LearningAgeBand.bandBYoungAdventurers,
  }) {
    final bandPool = _pools[ageBand] ?? _pools[LearningAgeBand.bandBYoungAdventurers]!;
    final prompts = bandPool[type] ?? _pools[LearningAgeBand.bandBYoungAdventurers]![type]!;

    if (prompts.isEmpty) return 'Well done!';

    final key = '${ageBand.name}_${type.name}';
    final prev = _lastIndex[key] ?? -1;
    final next = (prev + 1) % prompts.length;
    _lastIndex[key] = next;

    return prompts[next];
  }

  /// Retrieves a calibrated recovery prompt based on attempt count.
  /// - attempts <= 2 (single immediate mistake): short, prompt response like "You got it!"
  /// - attempts >= 3 (genuine repeated struggle): effort-oriented praise like "You kept trying and did it!"
  static String getRecoveryPrompt({
    LearningAgeBand ageBand = LearningAgeBand.bandBYoungAdventurers,
    int attempts = 2,
  }) {
    final type = attempts >= 3
        ? PipDialogueType.struggleRecovery
        : PipDialogueType.recoverySuccess;
    return getPrompt(type: type, ageBand: ageBand);
  }
}
