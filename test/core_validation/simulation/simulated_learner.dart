import 'dart:math' as math;
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';

/// Deterministic, probabilistic agent simulating child learner behavior.
class SimulatedLearner {
  final ChildProfile profile;
  final math.Random random;
  final int seed;

  final double accuracyRate;
  final double hintUsageRate;
  final double independentRecallRate;
  final double micFailureRate;
  final double pronunciationAccuracyRate;
  final double listeningAccuracyRate;
  final double comprehensionAccuracyRate;
  final double abandonmentRate;

  SimulatedLearner({
    required this.profile,
    required this.seed,
    required this.accuracyRate,
    this.hintUsageRate = 0.20,
    this.independentRecallRate = 0.80,
    this.micFailureRate = 0.05,
    this.pronunciationAccuracyRate = 0.75,
    this.listeningAccuracyRate = 0.80,
    this.comprehensionAccuracyRate = 0.80,
    this.abandonmentRate = 0.0,
  }) : random = math.Random(seed);

  String get id => profile.id;
  String get name => profile.name;
  int get age => profile.age;

  /// Simulates a single question attempt on a vocabulary item given context.
  LearningEvidence simulateAttempt({
    required String vocabularyId,
    required String word,
    required DateTime timestamp,
    LearningEvidenceSource source = LearningEvidenceSource.unpromptedRecall,
    bool isPronunciationContext = false,
    bool isListeningContext = false,
    bool isComprehensionContext = false,
  }) {
    final isCorrect = random.nextDouble() < accuracyRate;
    final usedHint = random.nextDouble() < hintUsageRate;
    final isIndependentRecall = !usedHint && (random.nextDouble() < independentRecallRate);

    final pronunciationAccurate = isPronunciationContext && (random.nextDouble() < pronunciationAccuracyRate);
    final listeningSuccess = isListeningContext && (random.nextDouble() < listeningAccuracyRate);
    final comprehensionSuccess = isComprehensionContext && (random.nextDouble() < comprehensionAccuracyRate);

    return LearningEvidence(
      childId: id,
      vocabularyId: vocabularyId,
      word: word,
      isCorrect: isCorrect,
      usedHint: usedHint,
      source: source,
      dimension: isPronunciationContext
          ? SkillDimension.pronunciation
          : (isListeningContext
              ? SkillDimension.listening
              : (isComprehensionContext ? SkillDimension.storyComprehension : SkillDimension.vocabularyRecall)),
      isIndependentRecall: isIndependentRecall,
      practicedPronunciation: isPronunciationContext,
      pronunciationAccurate: pronunciationAccurate,
      listeningTested: isListeningContext,
      listeningSuccess: listeningSuccess,
      comprehensionTested: isComprehensionContext,
      comprehensionSuccess: comprehensionSuccess,
      responseDurationMs: 1500 + random.nextInt(3500),
      timestamp: timestamp,
    );
  }

  bool shouldAbandonSession() {
    if (abandonmentRate <= 0.0) return false;
    return random.nextDouble() < abandonmentRate;
  }

  // --- Primary Profile Factories ---

  factory SimulatedLearner.brandNew({
    required String id,
    required String name,
    int age = 5,
    int seed = 101,
  }) {
    return SimulatedLearner(
      profile: ChildProfile(
        id: id,
        parentId: 'parent_1',
        name: name,
        age: age,
        avatar: Avatar(id: 'av_$name', name: name, assetPath: 'assets/$name.png'),
        unlockedWorldIds: const ['world_animal'],
      ),
      seed: seed,
      accuracyRate: 0.65,
      hintUsageRate: 0.25,
      independentRecallRate: 0.70,
    );
  }

  factory SimulatedLearner.struggling({
    required String id,
    required String name,
    int age = 5,
    int seed = 202,
  }) {
    return SimulatedLearner(
      profile: ChildProfile(
        id: id,
        parentId: 'parent_1',
        name: name,
        age: age,
        avatar: Avatar(id: 'av_$name', name: name, assetPath: 'assets/$name.png'),
        unlockedWorldIds: const ['world_animal'],
      ),
      seed: seed,
      accuracyRate: 0.35,
      hintUsageRate: 0.65,
      independentRecallRate: 0.30,
      micFailureRate: 0.25,
      pronunciationAccuracyRate: 0.40,
      listeningAccuracyRate: 0.50,
      comprehensionAccuracyRate: 0.45,
    );
  }

  factory SimulatedLearner.average({
    required String id,
    required String name,
    int age = 6,
    int seed = 303,
  }) {
    return SimulatedLearner(
      profile: ChildProfile(
        id: id,
        parentId: 'parent_1',
        name: name,
        age: age,
        avatar: Avatar(id: 'av_$name', name: name, assetPath: 'assets/$name.png'),
        unlockedWorldIds: const ['world_animal'],
      ),
      seed: seed,
      accuracyRate: 0.75,
      hintUsageRate: 0.20,
      independentRecallRate: 0.75,
      micFailureRate: 0.05,
      pronunciationAccuracyRate: 0.75,
      listeningAccuracyRate: 0.80,
      comprehensionAccuracyRate: 0.80,
    );
  }

  factory SimulatedLearner.fast({
    required String id,
    required String name,
    int age = 7,
    int seed = 404,
  }) {
    return SimulatedLearner(
      profile: ChildProfile(
        id: id,
        parentId: 'parent_1',
        name: name,
        age: age,
        avatar: Avatar(id: 'av_$name', name: name, assetPath: 'assets/$name.png'),
        unlockedWorldIds: const ['world_animal'],
        streakDays: 5,
      ),
      seed: seed,
      accuracyRate: 0.95,
      hintUsageRate: 0.05,
      independentRecallRate: 0.95,
      micFailureRate: 0.02,
      pronunciationAccuracyRate: 0.92,
      listeningAccuracyRate: 0.95,
      comprehensionAccuracyRate: 0.92,
    );
  }

  factory SimulatedLearner.returning({
    required String id,
    required String name,
    int age = 6,
    int seed = 505,
  }) {
    return SimulatedLearner(
      profile: ChildProfile(
        id: id,
        parentId: 'parent_1',
        name: name,
        age: age,
        avatar: Avatar(id: 'av_$name', name: name, assetPath: 'assets/$name.png'),
        unlockedWorldIds: const ['world_animal'],
      ),
      seed: seed,
      accuracyRate: 0.80,
      hintUsageRate: 0.15,
      independentRecallRate: 0.80,
    );
  }

  factory SimulatedLearner.perfect({
    required String id,
    required String name,
    int age = 8,
    int seed = 606,
  }) {
    return SimulatedLearner(
      profile: ChildProfile(
        id: id,
        parentId: 'parent_1',
        name: name,
        age: age,
        avatar: Avatar(id: 'av_$name', name: name, assetPath: 'assets/$name.png'),
        unlockedWorldIds: const ['world_animal'],
      ),
      seed: seed,
      accuracyRate: 1.0,
      hintUsageRate: 0.0,
      independentRecallRate: 1.0,
      micFailureRate: 0.0,
      pronunciationAccuracyRate: 1.0,
      listeningAccuracyRate: 1.0,
      comprehensionAccuracyRate: 1.0,
    );
  }

  factory SimulatedLearner.almostAlwaysWrong({
    required String id,
    required String name,
    int age = 4,
    int seed = 707,
  }) {
    return SimulatedLearner(
      profile: ChildProfile(
        id: id,
        parentId: 'parent_1',
        name: name,
        age: age,
        avatar: Avatar(id: 'av_$name', name: name, assetPath: 'assets/$name.png'),
        unlockedWorldIds: const ['world_animal'],
      ),
      seed: seed,
      accuracyRate: 0.08,
      hintUsageRate: 0.85,
      independentRecallRate: 0.05,
      micFailureRate: 0.30,
      pronunciationAccuracyRate: 0.10,
      listeningAccuracyRate: 0.20,
      comprehensionAccuracyRate: 0.15,
    );
  }

  factory SimulatedLearner.heavyHintUser({
    required String id,
    required String name,
    int age = 5,
    int seed = 808,
  }) {
    return SimulatedLearner(
      profile: ChildProfile(
        id: id,
        parentId: 'parent_1',
        name: name,
        age: age,
        avatar: Avatar(id: 'av_$name', name: name, assetPath: 'assets/$name.png'),
        unlockedWorldIds: const ['world_animal'],
      ),
      seed: seed,
      accuracyRate: 0.85,
      hintUsageRate: 1.0, // Always requests hints
      independentRecallRate: 0.0,
    );
  }

  factory SimulatedLearner.frequentAbandoner({
    required String id,
    required String name,
    int age = 5,
    int seed = 909,
  }) {
    return SimulatedLearner(
      profile: ChildProfile(
        id: id,
        parentId: 'parent_1',
        name: name,
        age: age,
        avatar: Avatar(id: 'av_$name', name: name, assetPath: 'assets/$name.png'),
        unlockedWorldIds: const ['world_animal'],
      ),
      seed: seed,
      accuracyRate: 0.70,
      abandonmentRate: 0.40, // Drops out 40% of sessions
    );
  }
}
