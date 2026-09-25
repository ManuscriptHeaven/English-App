import '../domain/models/avatar.dart';
import '../domain/models/child_profile.dart';
import '../domain/models/parent_profile.dart';
import '../domain/models/pet.dart';
import '../domain/repositories/child_profile_repository.dart';

/// Seeded in-memory / local mock repository for profiles in Phase 01.
class MockChildProfileRepository implements IChildProfileRepository {
  final Map<String, ChildProfile> _childProfiles = {};
  ParentProfile? _parentProfile;

  MockChildProfileRepository() {
    _seedInitialData();
  }

  void _seedInitialData() {
    _parentProfile = ParentProfile(
      id: 'parent_1',
      email: 'parent@example.com',
      name: 'Dr. Fatima',
      pinHash: '1234',
      dailyScreenTimeMinutes: 30,
      childIds: const ['child_ayaan', 'child_maryam'],
      createdAt: DateTime.now(),
    );

    _childProfiles['child_ayaan'] = ChildProfile(
      id: 'child_ayaan',
      parentId: 'parent_1',
      name: 'Ayaan',
      age: 5,
      gender: 'boy',
      avatar: const Avatar(
        id: 'avatar_boy_1',
        name: 'Little Ayaan',
        assetPath: 'assets/avatars/boy_1.png',
      ),
      pet: const Pet(
        id: 'pet_ayaan',
        name: 'Max',
        type: 'falcon',
        level: 1,
        happiness: 95,
        energy: 100,
        assetPath: 'assets/pets/falcon.png',
      ),
      level: 1,
      xp: 40,
      coins: 80,
      stars: 6,
      streakDays: 3,
      unlockedWorldIds: const ['world_animal'],
      completedLessonIds: const [],
      interests: const ['animals', 'adventure'],
    );

    _childProfiles['child_maryam'] = ChildProfile(
      id: 'child_maryam',
      parentId: 'parent_1',
      name: 'Maryam',
      age: 8,
      gender: 'girl',
      avatar: const Avatar(
        id: 'avatar_girl_1',
        name: 'Explorer Maryam',
        assetPath: 'assets/avatars/girl_1.png',
      ),
      pet: const Pet(
        id: 'pet_maryam',
        name: 'Luna',
        type: 'kitten',
        level: 2,
        happiness: 100,
        energy: 90,
        assetPath: 'assets/pets/kitten.png',
      ),
      level: 3,
      xp: 220,
      coins: 160,
      stars: 18,
      streakDays: 7,
      unlockedWorldIds: const ['world_animal', 'world_home'],
      completedLessonIds: const ['lesson_animal_vocab_1'],
      interests: const ['nature', 'stories', 'kindness'],
    );
  }

  @override
  Future<List<ChildProfile>> getChildProfiles() async {
    return _childProfiles.values.toList();
  }

  @override
  Future<ChildProfile?> getChildProfileById(String id) async {
    return _childProfiles[id];
  }

  @override
  Future<void> saveChildProfile(ChildProfile profile) async {
    _childProfiles[profile.id] = profile;
  }

  @override
  Future<void> deleteChildProfile(String id) async {
    _childProfiles.remove(id);
  }

  @override
  Future<ParentProfile?> getParentProfile() async {
    return _parentProfile;
  }

  @override
  Future<void> saveParentProfile(ParentProfile parent) async {
    _parentProfile = parent;
  }
}
