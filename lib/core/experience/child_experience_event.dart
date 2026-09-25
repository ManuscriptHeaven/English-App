import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';

/// Semantic experience event types capturing child actions and milestones.
enum ChildExperienceEventType {
  tap,
  selection,
  answerSubmitted,
  answerCorrect,
  independentRecall,
  pronunciationSuccess,
  speakingAttempt,
  recoverySuccess,
  gentleRetry,
  hintUsed,
  streakMilestone,
  storyMoment,
  dialogueTurnComplete,
  lessonComplete,
  missionComplete,
  worldUnlocked,
  starEarned,
  treasureOpened,
  pipAppears,
}

/// The 4-tier pedagogical feedback intensity model approved for Levels 1–3.
enum FeedbackIntensityTier {
  /// Tier 1 — Small Success
  /// Examples: correct tap, simple recognition, easy matching.
  /// Feedback: tiny sound, subtle visual response, optional short Pip acknowledgment.
  /// NO confetti, NO large screen takeover.
  tier1SmallSuccess,

  /// Tier 2 — Meaningful Success
  /// Examples: independent recall, clear spoken word/phrase, full conversation turn.
  /// Feedback: warm positive sound, Pip smile/bounce, subtle sparkle, concise praise.
  tier2MeaningfulSuccess,

  /// Tier 3 — Recovery Success
  /// Examples: child succeeds after difficulty / retry.
  /// Feedback: warm success sound, Pip supportive reaction, persistence praise. Zero shame.
  tier3RecoverySuccess,

  /// Tier 4 — Major Achievement
  /// Examples: lesson completed, mission completed, world unlocked, level complete.
  /// Feedback: richer animation, musical sting, stars/treasure, Pip celebration.
  tier4MajorAchievement,
}

/// A structured semantic child experience event.
class ChildExperienceEvent extends Equatable {
  final String id;
  final ChildExperienceEventType type;
  final FeedbackIntensityTier intensity;
  final LearningAgeBand ageBand;
  final DateTime timestamp;
  final String? conceptId;
  final int? streakCount;
  final int? stars;
  final String? spokenText;
  final Map<String, dynamic> metadata;

  const ChildExperienceEvent({
    required this.id,
    required this.type,
    this.intensity = FeedbackIntensityTier.tier1SmallSuccess,
    this.ageBand = LearningAgeBand.bandALittleExplorers,
    required this.timestamp,
    this.conceptId,
    this.streakCount,
    this.stars,
    this.spokenText,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
        id,
        type,
        intensity,
        ageBand,
        timestamp,
        conceptId,
        streakCount,
        stars,
        spokenText,
        metadata,
      ];
}
