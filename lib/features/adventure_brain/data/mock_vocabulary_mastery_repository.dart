import '../domain/adaptive/vocabulary_mastery.dart';
import '../domain/repositories/vocabulary_mastery_repository.dart';

/// Thread-safe in-memory implementation of [IVocabularyMasteryRepository]
/// enforcing strict child profile isolation.
class MockVocabularyMasteryRepository implements IVocabularyMasteryRepository {
  final Map<String, Map<String, VocabularyMastery>> _storage = {};

  MockVocabularyMasteryRepository() {
    _initSampleData();
  }

  void _initSampleData() {
    final now = DateTime.now();

    // Default masteries for Ayaan
    final ayaanWords = {
      'vocab_elephant': VocabularyMastery(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_elephant',
        word: 'Elephant',
        exposureCount: 4,
        correctAttempts: 3,
        incorrectAttempts: 1,
        consecutiveCorrect: 2,
        lastSeenAt: now.subtract(const Duration(hours: 4)),
        nextReviewAt: now.add(const Duration(days: 2)),
        masteryScore: 0.65,
        confidenceLevel: 0.70,
        currentLearningState: VocabularyLearningState.familiar,
      ),
      'vocab_lion': VocabularyMastery(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_lion',
        word: 'Lion',
        exposureCount: 3,
        correctAttempts: 2,
        incorrectAttempts: 1,
        consecutiveCorrect: 1,
        lastSeenAt: now.subtract(const Duration(hours: 5)),
        nextReviewAt: now.add(const Duration(hours: 20)),
        masteryScore: 0.50,
        confidenceLevel: 0.60,
        currentLearningState: VocabularyLearningState.practicing,
      ),
    };

    // Default masteries for Maryam (completely isolated)
    final maryamWords = {
      'vocab_cat': VocabularyMastery(
        childId: 'child_maryam',
        vocabularyId: 'vocab_cat',
        word: 'Cat',
        exposureCount: 7,
        correctAttempts: 6,
        incorrectAttempts: 0,
        consecutiveCorrect: 6,
        lastSeenAt: now.subtract(const Duration(days: 1)),
        nextReviewAt: now.add(const Duration(days: 10)),
        masteryScore: 0.90,
        confidenceLevel: 0.95,
        currentLearningState: VocabularyLearningState.mastered,
      ),
    };

    _storage['child_ayaan'] = ayaanWords;
    _storage['child_maryam'] = maryamWords;
  }

  @override
  Future<List<VocabularyMastery>> getMasteriesForChild(String childId) async {
    final childMap = _storage[childId];
    if (childMap == null) return [];
    return childMap.values.toList();
  }

  @override
  Future<VocabularyMastery?> getMastery({
    required String childId,
    required String vocabularyId,
  }) async {
    return _storage[childId]?[vocabularyId];
  }

  @override
  Future<void> saveMastery(VocabularyMastery mastery) async {
    final childMap = _storage.putIfAbsent(mastery.childId, () => {});
    childMap[mastery.vocabularyId] = mastery;
  }

  @override
  Future<void> saveAll(List<VocabularyMastery> masteries) async {
    for (final m in masteries) {
      await saveMastery(m);
    }
  }

  @override
  Future<void> clearMasteriesForChild(String childId) async {
    _storage.remove(childId);
  }
}
