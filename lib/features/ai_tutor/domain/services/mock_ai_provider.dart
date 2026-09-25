import 'dart:async';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_mode.dart';
import 'i_ai_provider.dart';

/// Deterministic mock AI provider for testing, offline simulation, and localized execution.
class MockAiProvider implements IAiProvider {
  final bool simulateLatency;
  final Duration latencyDuration;
  final bool forceTimeout;

  const MockAiProvider({
    this.simulateLatency = false,
    this.latencyDuration = const Duration(milliseconds: 300),
    this.forceTimeout = false,
  });

  @override
  Future<String> generateResponse({
    required String childInput,
    required AiCurriculumContext context,
    required List<String> recentTurnHistory,
  }) async {
    if (forceTimeout) {
      throw TimeoutException('Mock AI timeout exceeded');
    }

    if (simulateLatency) {
      await Future.delayed(latencyDuration);
    }

    final vocabWord = context.targetVocabulary.isNotEmpty ? context.targetVocabulary.first : 'word';

    switch (context.mode) {
      case AiMode.vocabularyTalk:
        return 'Awesome! Can you say the word $vocabWord with me?';

      case AiMode.grammarTalk:
        if (context.targetGrammar != null) {
          return 'Great! Let\'s try saying: "I have a $vocabWord."';
        }
        return 'Nice! Can you form a sentence with $vocabWord?';

      case AiMode.dailyEnglish:
        return 'I am feeling so cheerful today! What is your favorite outdoor color?';

      case AiMode.storyTalk:
        return 'In our story, Ayaan was very helpful! Do you remember who he helped?';

      case AiMode.mannersTalk:
        if (context.approvedIslamicValues.isNotEmpty) {
          final val = context.approvedIslamicValues.first;
          final phrase = val.approvedPhrases.isNotEmpty ? val.approvedPhrases.first : 'Alhamdulillah';
          return 'Remember we always say $phrase with a kind heart! 🤲';
        }
        return 'Being polite and sharing treats brings so much joy! 🤝';

      case AiMode.speakingChallenge:
        return 'Let\'s speak aloud: "The sun is bright!" Ready to try?';

      case AiMode.reviewTalk:
        return 'Let\'s practice and review $vocabWord together to strengthen our brain! 🧠';
    }
  }

  @override
  Future<ChildResponseAnalysis> analyzeChildResponse({
    required String childResponse,
    required String targetPhrase,
    required AiCurriculumContext context,
  }) async {
    if (simulateLatency) {
      await Future.delayed(latencyDuration);
    }

    final normChild = childResponse.toLowerCase().trim();
    final normTarget = targetPhrase.toLowerCase().trim();

    final isExact = normChild == normTarget;
    final isPartial = normChild.contains(normTarget) || normTarget.contains(normChild);

    if (isExact || isPartial) {
      return const ChildResponseAnalysis(
        isAccurate: true,
        score: 0.95,
        encouragingFeedback: 'Fantastic pronunciation! You said it clearly! 🌟',
        nextQuestion: 'Can you try one more sentence?',
      );
    }

    // Friendly scaffolding
    return ChildResponseAnalysis(
      isAccurate: false,
      score: 0.60,
      encouragingFeedback: 'Almost there! You are doing great.',
      suggestedCorrection: 'Let\'s try saying: "$targetPhrase"',
      nextQuestion: 'Would you like to repeat it together?',
    );
  }

  @override
  Future<String> generatePracticeVariation({
    required String baseSentence,
    required AiCurriculumContext context,
  }) async {
    final vocab = context.targetVocabulary.isNotEmpty ? context.targetVocabulary.last : 'apple';
    return 'Look! I see a fresh $vocab in the park!';
  }
}
