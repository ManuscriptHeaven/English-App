import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/database/local_database.dart';
import 'package:kids_english_adventure/core/storage/local_storage_service.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_session.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';

void main() {
  group('LocalDatabase Persistence & Child Isolation Tests', () {
    late ILocalStorageService storage;
    late ILocalDatabase db;

    setUp(() async {
      storage = InMemoryStorageService();
      db = LocalDatabase(storage: storage);
      await db.init();
    });

    test('Saves and loads ChildProfile across simulated app restarts', () async {
      final childCol = db.collection('child_profiles');
      final child = ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 6,
        xp: 150,
        coins: 80,
        stars: 12,
        avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        completedLessonIds: const ['activity_animal_vocab', 'activity_home_vocab'],
      );

      // Save
      await childCol.put(child.id, child.toJson());

      // Simulate restart with new DB instance backed by same storage
      final newDb = LocalDatabase(storage: storage);
      await newDb.init();
      final loadedJson = await newDb.collection('child_profiles').get('child_ayaan');

      expect(loadedJson, isNotNull);
      final loadedChild = ChildProfile.fromJson(loadedJson!);
      expect(loadedChild.id, equals('child_ayaan'));
      expect(loadedChild.name, equals('Ayaan'));
      expect(loadedChild.xp, equals(150));
      expect(loadedChild.completedLessonIds, contains('activity_home_vocab'));
    });

    test('Guarantees strict child data isolation between multiple children', () async {
      final signalsCol = db.collection('learning_signals');

      // Child 1 (Ayaan)
      await signalsCol.put('sig_ayaan_1', {
        'id': 'sig_ayaan_1',
        'childId': 'child_ayaan',
        'skill': 'vocabulary',
        'contentId': 'vocab_pencil',
        'score': 1.0,
      });

      // Child 2 (Maryam)
      await signalsCol.put('sig_maryam_1', {
        'id': 'sig_maryam_1',
        'childId': 'child_maryam',
        'skill': 'grammar',
        'contentId': 'grammar_plurals',
        'score': 0.8,
      });

      // Query Ayaan
      final ayaanSignals = await signalsCol.queryByField('childId', 'child_ayaan');
      expect(ayaanSignals.length, equals(1));
      expect(ayaanSignals.first['contentId'], equals('vocab_pencil'));

      // Query Maryam
      final maryamSignals = await signalsCol.queryByField('childId', 'child_maryam');
      expect(maryamSignals.length, equals(1));
      expect(maryamSignals.first['contentId'], equals('grammar_plurals'));
    });

    test('Saves and loads LearningSession history', () async {
      final sessionCol = db.collection('learning_sessions');
      final now = DateTime(2026, 8, 22, 10, 0);

      final session = LearningSession(
        id: 'session_ayaan_20260822',
        childId: 'child_ayaan',
        createdAt: now,
        totalEstimatedMinutes: 20,
        activities: const [],
        completedActivityIds: const ['activity_school_vocab', 'activity_classroom_hunt'],
        primaryFocusSkill: SkillType.vocabulary,
        primaryFocusValue: 'Honesty / Sidq',
        isCompleted: true,
      );

      await sessionCol.put(session.id, session.toJson());

      final loadedJson = await sessionCol.get('session_ayaan_20260822');
      expect(loadedJson, isNotNull);
      final loadedSession = LearningSession.fromJson(loadedJson!);
      expect(loadedSession.id, equals('session_ayaan_20260822'));
      expect(loadedSession.totalEstimatedMinutes, equals(20));
      expect(loadedSession.primaryFocusValue, equals('Honesty / Sidq'));
      expect(loadedSession.isCompleted, isTrue);
    });

    test('Executes atomic transaction across multiple collections', () async {
      await db.runTransaction(() async {
        await db.collection('rewards').put('tx_1', {
          'id': 'tx_1',
          'childId': 'child_ayaan',
          'xp': 25,
          'coins': 15,
        });
        await db.collection('completed_activities').put('act_1', {
          'id': 'act_1',
          'childId': 'child_ayaan',
          'activityId': 'activity_classroom_hunt',
          'completedAt': DateTime.now().toIso8601String(),
        });
      });

      final reward = await db.collection('rewards').get('tx_1');
      final act = await db.collection('completed_activities').get('act_1');

      expect(reward, isNotNull);
      expect(act, isNotNull);
      expect(reward!['xp'], equals(25));
      expect(act!['activityId'], equals('activity_classroom_hunt'));
    });
  });
}
