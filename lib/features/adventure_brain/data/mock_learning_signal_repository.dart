import '../domain/models/content_mastery.dart';
import '../domain/models/learning_signal.dart';
import '../domain/models/skill_mastery.dart';
import '../domain/repositories/learning_signal_repository.dart';
import '../domain/services/mastery_calculator.dart';

/// In-memory local repository storing learning signals and calculated masteries.
class MockLearningSignalRepository implements ILearningSignalRepository {
  final Map<String, List<LearningSignal>> _signals = {};
  final Map<String, Map<String, ContentMastery>> _masteries = {};

  MockLearningSignalRepository() {
    _seedDefaultSignals();
  }

  void _seedDefaultSignals() {
    final now = DateTime.now();
    const childId = 'child_ayaan';

    _masteries[childId] = {
      'vocab_elephant': ContentMastery(
        contentId: 'vocab_elephant',
        skill: SkillType.vocabulary,
        masteryScore: 0.85,
        confidence: 0.80,
        attemptCount: 4,
        correctCount: 4,
        incorrectCount: 0,
        lastAttemptAt: now.subtract(const Duration(days: 1)),
        nextReviewAt: now.add(const Duration(days: 6)),
      ),
      'vocab_lion': ContentMastery(
        contentId: 'vocab_lion',
        skill: SkillType.vocabulary,
        masteryScore: 0.80,
        confidence: 0.75,
        attemptCount: 3,
        correctCount: 3,
        incorrectCount: 0,
        lastAttemptAt: now.subtract(const Duration(days: 1)),
        nextReviewAt: now.add(const Duration(days: 5)),
      ),
      'vocab_cat': ContentMastery(
        contentId: 'vocab_cat',
        skill: SkillType.vocabulary,
        masteryScore: 0.95,
        confidence: 0.90,
        attemptCount: 5,
        correctCount: 5,
        incorrectCount: 0,
        lastAttemptAt: now.subtract(const Duration(days: 2)),
        nextReviewAt: now.add(const Duration(days: 12)),
      ),
      'grammar_is_are': ContentMastery(
        contentId: 'grammar_is_are',
        skill: SkillType.grammar,
        masteryScore: 0.75,
        confidence: 0.70,
        attemptCount: 3,
        correctCount: 2,
        incorrectCount: 1,
        lastAttemptAt: now.subtract(const Duration(hours: 12)),
        nextReviewAt: now.add(const Duration(days: 3)),
      ),
      'vocab_room': ContentMastery(
        contentId: 'vocab_room',
        skill: SkillType.vocabulary,
        masteryScore: 0.80,
        confidence: 0.75,
        attemptCount: 3,
        correctCount: 3,
        incorrectCount: 0,
        lastAttemptAt: now.subtract(const Duration(days: 1)),
        nextReviewAt: now.add(const Duration(days: 6)),
      ),
      'manner_cleanliness': ContentMastery(
        contentId: 'manner_cleanliness',
        skill: SkillType.manners,
        masteryScore: 0.90,
        confidence: 0.85,
        attemptCount: 3,
        correctCount: 3,
        incorrectCount: 0,
        lastAttemptAt: now.subtract(const Duration(days: 1)),
        nextReviewAt: now.add(const Duration(days: 10)),
      ),
    };
  }

  @override
  Future<void> recordSignal(LearningSignal signal) async {
    _signals.putIfAbsent(signal.childId, () => []).add(signal);

    final childMap = _masteries.putIfAbsent(signal.childId, () => {});
    final current = childMap[signal.contentId];

    final updated = MasteryCalculator.updateContentMastery(
      currentMastery: current,
      signal: signal,
      now: DateTime.now(),
    );

    childMap[signal.contentId] = updated;
  }

  @override
  Future<List<LearningSignal>> getSignalsForChild(String childId) async {
    return _signals[childId] ?? [];
  }

  @override
  Future<List<ContentMastery>> getContentMasteriesForChild(String childId) async {
    final map = _masteries[childId] ?? {};
    final now = DateTime.now();
    return map.values.map((cm) => MasteryCalculator.applyTimeDecay(mastery: cm, currentDate: now)).toList();
  }

  @override
  Future<ContentMastery?> getContentMastery(String childId, String contentId) async {
    final map = _masteries[childId];
    if (map == null) return null;
    final cm = map[contentId];
    if (cm == null) return null;
    return MasteryCalculator.applyTimeDecay(mastery: cm, currentDate: DateTime.now());
  }

  @override
  Future<void> saveContentMastery(String childId, ContentMastery mastery) async {
    final map = _masteries.putIfAbsent(childId, () => {});
    map[mastery.contentId] = mastery;
  }

  @override
  Future<Map<SkillType, SkillMastery>> getSkillMasteriesForChild(String childId) async {
    final contentMasteries = await getContentMasteriesForChild(childId);
    return MasteryCalculator.calculateSkillMasteries(
      contentMasteries: contentMasteries,
      now: DateTime.now(),
    );
  }
}
