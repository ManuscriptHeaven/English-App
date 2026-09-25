import '../models/child_profile.dart';
import '../models/parent_profile.dart';

/// Abstract repository interface for child & parent profile persistence.
abstract class IChildProfileRepository {
  Future<List<ChildProfile>> getChildProfiles();
  Future<ChildProfile?> getChildProfileById(String id);
  Future<void> saveChildProfile(ChildProfile profile);
  Future<void> deleteChildProfile(String id);
  Future<ParentProfile?> getParentProfile();
  Future<void> saveParentProfile(ParentProfile parent);
}
