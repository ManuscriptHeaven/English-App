import 'package:equatable/equatable.dart';

/// Presentation representation of an adaptively scaffolded prompt.
class ScaffoldPrompt extends Equatable {
  final int difficultyLevel; // 1 to 5
  final String promptText;
  final String? audioHint;
  final String? visualHint;
  final List<String> availableTokens;
  final List<String> fixedSlots;
  final bool showAudioAutoPlay;
  final bool showVisualCard;

  const ScaffoldPrompt({
    required this.difficultyLevel,
    required this.promptText,
    this.audioHint,
    this.visualHint,
    this.availableTokens = const [],
    this.fixedSlots = const [],
    this.showAudioAutoPlay = false,
    this.showVisualCard = true,
  });

  @override
  List<Object?> get props => [
        difficultyLevel,
        promptText,
        audioHint,
        visualHint,
        availableTokens,
        fixedSlots,
        showAudioAutoPlay,
        showVisualCard,
      ];
}

/// Dynamic scaffolding engine providing adaptive support levels (1 to 5).
class ScaffoldingEngine {
  /// Steps difficulty level up or down based on recent performance.
  static int adjustDifficultyLevel(
    int currentLevel, {
    required int consecutiveSuccesses,
    required int consecutiveFailures,
  }) {
    if (consecutiveFailures >= 2) {
      // Step down support for struggling child
      return (currentLevel - 1).clamp(1, 5);
    } else if (consecutiveSuccesses >= 3) {
      // Step up challenge for excelling child
      return (currentLevel + 1).clamp(1, 5);
    }
    return currentLevel.clamp(1, 5);
  }

  /// Generates a structured ScaffoldPrompt for a given target sentence/phrase.
  static ScaffoldPrompt scaffoldSentence({
    required String targetSentence,
    required int difficultyLevel,
    String? audioHint,
    String? visualEmoji,
  }) {
    final words = targetSentence.split(' ');

    switch (difficultyLevel) {
      case 1:
        // Level 1: Visual + Audio with full assistance
        return ScaffoldPrompt(
          difficultyLevel: 1,
          promptText: targetSentence,
          audioHint: audioHint ?? targetSentence,
          visualHint: visualEmoji,
          availableTokens: words,
          fixedSlots: words,
          showAudioAutoPlay: true,
          showVisualCard: true,
        );

      case 2:
        // Level 2: Visual + Text (Tap words with visual reminder)
        return ScaffoldPrompt(
          difficultyLevel: 2,
          promptText: targetSentence,
          visualHint: visualEmoji,
          availableTokens: List<String>.from(words)..shuffle(),
          fixedSlots: const [],
          showAudioAutoPlay: false,
          showVisualCard: true,
        );

      case 3:
        // Level 3: Multiple choice recognition with distractors
        final distractors = ['small', 'big', 'water', 'clean'];
        final tokens = [...words, ...distractors.take(2)]..shuffle();
        return ScaffoldPrompt(
          difficultyLevel: 3,
          promptText: 'Build the sentence:',
          visualHint: visualEmoji,
          availableTokens: tokens,
          fixedSlots: const [],
          showAudioAutoPlay: false,
          showVisualCard: true,
        );

      case 4:
        // Level 4: Guided Slot Fill (First parts filled, final part chosen)
        if (words.length > 2) {
          final prefix = words.sublist(0, words.length - 1);
          final lastWord = words.last;
          return ScaffoldPrompt(
            difficultyLevel: 4,
            promptText: '${prefix.join(' ')} [ ? ]',
            availableTokens: [lastWord, 'cat', 'lion', 'room']..shuffle(),
            fixedSlots: prefix,
            showAudioAutoPlay: false,
            showVisualCard: false,
          );
        }
        return ScaffoldPrompt(
          difficultyLevel: 4,
          promptText: targetSentence,
          availableTokens: List<String>.from(words)..shuffle(),
          showAudioAutoPlay: false,
          showVisualCard: false,
        );

      case 5:
      default:
        // Level 5: Independent construction without visual/audio prompts
        return ScaffoldPrompt(
          difficultyLevel: 5,
          promptText: 'Create the sentence:',
          availableTokens: List<String>.from(words)..shuffle(),
          fixedSlots: const [],
          showAudioAutoPlay: false,
          showVisualCard: false,
        );
    }
  }
}
