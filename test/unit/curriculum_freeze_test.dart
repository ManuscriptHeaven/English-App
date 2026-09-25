import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/curriculum_seed_data.dart';
import 'package:kids_english_adventure/features/curriculum/domain/repositories/curriculum_repository.dart';
import 'package:kids_english_adventure/features/curriculum/domain/validation/curriculum_freeze_guard.dart';

void main() {
  group('Curriculum Freeze Guard (FROZEN_LEVELS_1_TO_3)', () {
    late CurriculumRepository repo;

    setUp(() {
      repo = CurriculumSeedData.createRepository();
    });

    test('1. Validates exact baseline counts across all frozen dimensions', () {
      final allConcepts = repo.getAllConcepts();
      final l1Concepts = allConcepts.where((c) => c.levelOrder == 1).toList();
      final l2Concepts = allConcepts.where((c) => c.levelOrder == 2).toList();
      final patterns = repo.getAllSentencePatterns();
      final functions = repo.getAllConversationFunctions();
      final units = repo.getAllUnits();
      final lessons = repo.getAllLessons();
      final stories = repo.getAllStories();
      final missions = repo.getAllLevelMissions();
      final canDos = repo.getAllCanDoStatements();

      expect(l1Concepts.length, 144, reason: 'Level 1 concepts must be exactly 144');
      expect(l2Concepts.length, 64, reason: 'Level 2 phrases must be exactly 64');
      expect(allConcepts.length, 208, reason: 'Total concepts must be exactly 208');
      expect(patterns.length, 26, reason: 'Sentence patterns must be exactly 26');
      expect(functions.length, 13, reason: 'Conversation functions must be exactly 13');
      expect(units.length, 16, reason: 'Curriculum units must be exactly 16');
      expect(lessons.length, 18, reason: 'Curriculum lessons must be exactly 18');
      expect(stories.length, 3, reason: 'Curriculum stories must be exactly 3');
      expect(missions.length, 3, reason: 'Level missions must be exactly 3');
      expect(canDos.length, 12, reason: 'Can-Do statements must be exactly 12');
    });

    test('2. Deterministic canonical hash matches frozen baseline exactly', () {
      final canonical = CurriculumFreezeGuard.buildCanonicalString(repo);
      final hash = CurriculumFreezeGuard.calculateHash(canonical);
      expect(hash, CurriculumFreezeGuard.frozenBaselineHash);

      final result = CurriculumFreezeGuard.verify(repo);
      expect(result.isFrozen, isTrue, reason: result.toString());
      expect(result.discrepancies.isEmpty, isTrue);
      expect(result.currentHash, CurriculumFreezeGuard.frozenBaselineHash);
    });

    test('3. Simulated accidental mutation triggers immediate verification failure', () {
      final originalCanonical = CurriculumFreezeGuard.buildCanonicalString(repo);
      final originalHash = CurriculumFreezeGuard.calculateHash(originalCanonical);

      // Simulate accidental content alteration
      final mutatedCanonical = originalCanonical.replaceAll('red apple', 'crimson apple');
      final mutatedHash = CurriculumFreezeGuard.calculateHash(mutatedCanonical);

      expect(mutatedHash, isNot(equals(originalHash)),
          reason: 'Any string modification must produce a different hash');
    });
  });
}
