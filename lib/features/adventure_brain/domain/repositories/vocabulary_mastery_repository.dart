import '../adaptive/vocabulary_mastery.dart';

/// Abstract contract for storing and querying individual child vocabulary masteries.
abstract class IVocabularyMasteryRepository {
  /// Fetches all vocabulary mastery records for a specific child.
  Future<List<VocabularyMastery>> getMasteriesForChild(String childId);

  /// Fetches a specific vocabulary mastery record for a child.
  Future<VocabularyMastery?> getMastery({
    required String childId,
    required String vocabularyId,
  });

  /// Saves or updates a single vocabulary mastery record.
  Future<void> saveMastery(VocabularyMastery mastery);

  /// Bulk saves or updates mastery records.
  Future<void> saveAll(List<VocabularyMastery> masteries);

  /// Purges all stored mastery data for a child (e.g. profile deletion).
  Future<void> clearMasteriesForChild(String childId);
}
