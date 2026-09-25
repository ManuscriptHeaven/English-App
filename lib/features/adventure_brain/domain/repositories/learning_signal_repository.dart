import '../models/content_mastery.dart';
import '../models/learning_signal.dart';
import '../models/skill_mastery.dart';

/// Repository interface for learning signals and mastery data.
abstract class ILearningSignalRepository {
  Future<void> recordSignal(LearningSignal signal);
  Future<List<LearningSignal>> getSignalsForChild(String childId);
  Future<List<ContentMastery>> getContentMasteriesForChild(String childId);
  Future<ContentMastery?> getContentMastery(String childId, String contentId);
  Future<void> saveContentMastery(String childId, ContentMastery mastery);
  Future<Map<SkillType, SkillMastery>> getSkillMasteriesForChild(String childId);
}
