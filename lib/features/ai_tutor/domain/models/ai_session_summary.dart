import 'package:equatable/equatable.dart';
import 'ai_mode.dart';

/// Summary of an AI conversation session separating child-friendly praise from parent diagnostics.
class AiSessionSummary extends Equatable {
  final String sessionId;
  final String childId;
  final AiMode mode;
  final DateTime completedAt;
  final int totalTurns;
  final int spokenTurns;
  final int starsEarned;
  final int xpEarned;
  final int coinsEarned;

  // Child-facing presentation
  final String childTitle;
  final String childEncouragement;
  final String characterEmoji;

  // Parent-facing educational diagnostics (No raw private transcripts)
  final double speakingAccuracy; // 0.0 to 1.0
  final int vocabularySuccessCount;
  final int vocabularyTotalTargetCount;
  final List<String> practicedVocabulary;
  final String? grammarPracticed;
  final bool grammarAccurate;
  final List<String> needsPracticeItems;
  final String growthRecommendation;
  final bool fallbackUsed;

  const AiSessionSummary({
    required this.sessionId,
    required this.childId,
    required this.mode,
    required this.completedAt,
    required this.totalTurns,
    required this.spokenTurns,
    this.starsEarned = 3,
    this.xpEarned = 25,
    this.coinsEarned = 10,
    required this.childTitle,
    required this.childEncouragement,
    this.characterEmoji = '🦜',
    required this.speakingAccuracy,
    required this.vocabularySuccessCount,
    required this.vocabularyTotalTargetCount,
    required this.practicedVocabulary,
    this.grammarPracticed,
    this.grammarAccurate = true,
    this.needsPracticeItems = const [],
    required this.growthRecommendation,
    this.fallbackUsed = false,
  });

  /// Factory creating an educational summary from session performance metrics.
  factory AiSessionSummary.generate({
    required String sessionId,
    required String childId,
    required AiMode mode,
    required int totalTurns,
    required int spokenTurns,
    required int successfulTurns,
    required List<String> targetVocabulary,
    String? targetGrammar,
    List<String> repeatedMistakes = const [],
    bool fallbackUsed = false,
  }) {
    final double accuracy = totalTurns > 0 ? (successfulTurns / totalTurns).clamp(0.0, 1.0) : 1.0;
    final int vocabSuccess = (targetVocabulary.length * accuracy).round();

    // Friendly child messaging
    final String title;
    final String encouragement;
    if (accuracy >= 0.8) {
      title = 'Super Chat with Pip! ⭐';
      encouragement = 'MashaAllah! Your English speaking was so clear and confident!';
    } else if (accuracy >= 0.5) {
      title = 'Great Practice! 🌟';
      encouragement = "You're getting better and better every time we talk!";
    } else {
      title = 'Good Effort! 🎈';
      encouragement = "Let's keep practicing these fun words together!";
    }

    // Parent growth recommendation
    final String recommendation;
    if (repeatedMistakes.isNotEmpty) {
      recommendation = 'Suggest practicing "${repeatedMistakes.first}" with a short game or review card.';
    } else if (spokenTurns < totalTurns) {
      recommendation = 'Encourage using the microphone button for more active speaking practice.';
    } else {
      recommendation = 'Excellent speaking confidence! Ready for the next adventure lesson.';
    }

    return AiSessionSummary(
      sessionId: sessionId,
      childId: childId,
      mode: mode,
      completedAt: DateTime.now(),
      totalTurns: totalTurns,
      spokenTurns: spokenTurns,
      starsEarned: accuracy >= 0.7 ? 3 : 2,
      xpEarned: 25,
      coinsEarned: 10,
      childTitle: title,
      childEncouragement: encouragement,
      speakingAccuracy: accuracy,
      vocabularySuccessCount: vocabSuccess,
      vocabularyTotalTargetCount: targetVocabulary.length,
      practicedVocabulary: targetVocabulary,
      grammarPracticed: targetGrammar,
      grammarAccurate: repeatedMistakes.isEmpty,
      needsPracticeItems: repeatedMistakes,
      growthRecommendation: recommendation,
      fallbackUsed: fallbackUsed,
    );
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'childId': childId,
        'mode': mode.name,
        'completedAt': completedAt.toIso8601String(),
        'totalTurns': totalTurns,
        'spokenTurns': spokenTurns,
        'starsEarned': starsEarned,
        'xpEarned': xpEarned,
        'coinsEarned': coinsEarned,
        'childTitle': childTitle,
        'childEncouragement': childEncouragement,
        'characterEmoji': characterEmoji,
        'speakingAccuracy': speakingAccuracy,
        'vocabularySuccessCount': vocabularySuccessCount,
        'vocabularyTotalTargetCount': vocabularyTotalTargetCount,
        'practicedVocabulary': practicedVocabulary,
        'grammarPracticed': grammarPracticed,
        'grammarAccurate': grammarAccurate,
        'needsPracticeItems': needsPracticeItems,
        'growthRecommendation': growthRecommendation,
        'fallbackUsed': fallbackUsed,
      };

  @override
  List<Object?> get props => [
        sessionId,
        childId,
        mode,
        completedAt,
        totalTurns,
        spokenTurns,
        starsEarned,
        xpEarned,
        coinsEarned,
        childTitle,
        childEncouragement,
        characterEmoji,
        speakingAccuracy,
        vocabularySuccessCount,
        vocabularyTotalTargetCount,
        practicedVocabulary,
        grammarPracticed,
        grammarAccurate,
        needsPracticeItems,
        growthRecommendation,
        fallbackUsed,
      ];
}
