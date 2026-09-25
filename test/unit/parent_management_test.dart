import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/child_profile/data/mock_child_profile_repository.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';

void main() {
  group('Parent Management & Data Export Tests', () {
    late MockChildProfileRepository repo;
    final child = ChildProfile(
      id: 'child_ayaan',
      parentId: 'parent_1',
      name: 'Ayaan',
      age: 6,
      xp: 450,
      coins: 120,
      stars: 18,
      streakDays: 5,
      completedLessonIds: const ['activity_animal_vocab', 'activity_food_vocab'],
      unlockedWorldIds: const ['world_animal', 'world_home', 'world_school', 'world_food'],
      avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
    );

    setUp(() {
      repo = MockChildProfileRepository();
    });

    test('Generates valid JSON dataset for learning data export', () {
      final exportData = {
        'exportTimestamp': DateTime.now().toIso8601String(),
        'child': child.toJson(),
        'exportFormatVersion': '1.0',
      };

      final jsonString = jsonEncode(exportData);
      expect(jsonString, isNotEmpty);

      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      expect(decoded['child']['name'], equals('Ayaan'));
      expect(decoded['child']['xp'], equals(450));
      expect(decoded['child']['completedLessonIds'], contains('activity_food_vocab'));
    });

    test('Safely deletes child profile from repository', () async {
      await repo.saveChildProfile(child);
      final initialList = await repo.getChildProfiles();
      expect(initialList.any((c) => c.id == 'child_ayaan'), isTrue);

      await repo.deleteChildProfile('child_ayaan');
      final updatedList = await repo.getChildProfiles();
      expect(updatedList.any((c) => c.id == 'child_ayaan'), isFalse);
    });
  });
}
