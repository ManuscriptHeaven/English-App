import 'vocabulary_mastery.dart';

/// Types of supportive interventions designed to protect a child's confidence and joy.
enum ConfidenceInterventionType {
  none,
  provideEasyWin,
  switchActivityType,
  pipDemonstration,
  simplifyQuestion,
}

/// Structured decision from [ConfidenceGuardian].
class ConfidenceIntervention {
  final ConfidenceInterventionType type;
  final String? recommendedVocabularyId;
  final String reason;
  final String pipEncouragingDialogue;

  const ConfidenceIntervention({
    required this.type,
    this.recommendedVocabularyId,
    required this.reason,
    required this.pipEncouragingDialogue,
  });

  static const ConfidenceIntervention none = ConfidenceIntervention(
    type: ConfidenceInterventionType.none,
    reason: 'Normal learning flow; no struggle detected.',
    pipEncouragingDialogue: '',
  );
}

/// Pure domain service monitoring short-term struggle and prescribing emotional safeguards.
///
/// Ensures young children never disengage from frustration or perceived failure,
/// while strictly preserving truthful scoring integrity.
class ConfidenceGuardian {
  const ConfidenceGuardian();

  /// Evaluates recent signals and returns a [ConfidenceIntervention] if needed.
  ConfidenceIntervention assessConfidence({
    required int consecutiveErrors,
    required int hintUsageInSession,
    required int micFailureCount,
    required List<VocabularyMastery> masteries,
  }) {
    // 1. Critical struggle: multiple consecutive errors
    if (consecutiveErrors >= 3) {
      // Find an already-mastered word the child loves to provide an easy, confidence-restoring win
      final familiarWords = masteries.where((m) => m.isMastered || m.accuracyRatio >= 0.85).toList();
      final easyWinId = familiarWords.isNotEmpty ? familiarWords.first.vocabularyId : null;

      return ConfidenceIntervention(
        type: ConfidenceInterventionType.provideEasyWin,
        recommendedVocabularyId: easyWinId,
        reason: 'Child encountered $consecutiveErrors consecutive mistakes. Offering an easy win with familiar content.',
        pipEncouragingDialogue: 'Pip is right here with you! Let\'s say hello to a friendly animal! 🐾',
      );
    }

    // 2. Persistent microphone / speaking struggle
    if (micFailureCount >= 2) {
      return const ConfidenceIntervention(
        type: ConfidenceInterventionType.switchActivityType,
        reason: 'Microphone recognition difficulty encountered twice. Switching to tap/listening to avoid frustration.',
        pipEncouragingDialogue: 'Let\'s use our listening ears and tap the right picture! 🎧✨',
      );
    }

    // 3. Repeated hint usage (child feeling uncertain)
    if (hintUsageInSession >= 3) {
      return const ConfidenceIntervention(
        type: ConfidenceInterventionType.pipDemonstration,
        reason: 'Child requested multiple hints. Having Pip demonstrate pronunciation and clue.',
        pipEncouragingDialogue: 'Listen closely! Pip will show you how it sounds! 🦜🎵',
      );
    }

    // 4. Minor struggle (2 errors)
    if (consecutiveErrors == 2) {
      return const ConfidenceIntervention(
        type: ConfidenceInterventionType.simplifyQuestion,
        reason: 'Two consecutive mistakes. Temporarily reducing distractor choices.',
        pipEncouragingDialogue: 'Pip has a special clue for you! Take a gentle look! 💡',
      );
    }

    return ConfidenceIntervention.none;
  }
}
