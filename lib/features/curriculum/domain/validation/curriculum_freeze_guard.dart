import 'dart:convert';
import '../repositories/curriculum_repository.dart';

/// Validation result for the curriculum freeze integrity check.
class FreezeVerificationResult {
  final bool isFrozen;
  final String currentHash;
  final String expectedHash;
  final List<String> discrepancies;
  final Map<String, int> counts;

  const FreezeVerificationResult({
    required this.isFrozen,
    required this.currentHash,
    required this.expectedHash,
    required this.discrepancies,
    required this.counts,
  });

  @override
  String toString() {
    if (isFrozen) {
      return 'FreezeVerificationResult: FROZEN_OK (hash: $currentHash, counts: $counts)';
    }
    return 'FreezeVerificationResult: MUTATION_DETECTED!\n'
        'Expected: $expectedHash\n'
        'Actual:   $currentHash\n'
        'Discrepancies:\n  ${discrepancies.join('\n  ')}';
  }
}

/// Guard mechanism to ensure Levels 1–3 curriculum data remains completely
/// frozen and protected against accidental mutations during Phase 16 polish passes.
class CurriculumFreezeGuard {
  /// Generates a sorted, deterministic canonical string representation of the
  /// entire Levels 1–3 curriculum hierarchy.
  static String buildCanonicalString(ICurriculumRepository repo) {
    final buffer = StringBuffer();

    // 1. All Concepts (Sorted by ID)
    final concepts = List.of(repo.getAllConcepts())
      ..sort((a, b) => a.id.compareTo(b.id));
    buffer.writeln('=== CONCEPTS (${concepts.length}) ===');
    for (final c in concepts) {
      final prereqs = List.of(c.prerequisites)..sort();
      final tags = List.of(c.tags)..sort();
      final responses = List.of(c.acceptableResponses)..sort();
      buffer.writeln(
        '${c.id}|${c.levelOrder}|${c.type.name}|${c.canonicalText}|${c.meaning}|'
        'prereqs:[${prereqs.join(',')}]|tags:[${tags.join(',')}]|'
        'responses:[${responses.join(',')}]|review:${c.reviewStatus.name}',
      );
    }

    // 2. Sentence Patterns (Sorted by ID)
    final patterns = List.of(repo.getAllSentencePatterns())
      ..sort((a, b) => a.id.compareTo(b.id));
    buffer.writeln('=== PATTERNS (${patterns.length}) ===');
    for (final p in patterns) {
      final prereqs = List.of(p.prerequisiteConceptIds)..sort();
      final examples = List.of(p.examples)..sort();
      buffer.writeln(
        '${p.id}|${p.levelOrder}|${p.template}|prereqs:[${prereqs.join(',')}]|examples:[${examples.join(',')}]',
      );
    }

    // 3. Conversation Functions (Sorted by ID)
    final functions = List.of(repo.getAllConversationFunctions())
      ..sort((a, b) => a.id.compareTo(b.id));
    buffer.writeln('=== CONVERSATION_FUNCTIONS (${functions.length}) ===');
    for (final f in functions) {
      final prereqs = List.of(f.prerequisitePatternIds)..sort();
      final values = List.of(f.valueThemes)..sort();
      buffer.writeln(
        '${f.id}|${f.levelOrder}|${f.intent.name}|${f.purpose}|${f.pipOpening}|'
        '${f.simplerResponse}|${f.targetResponse}|${f.strongerResponse}|${f.pipFollowUp}|'
        '${f.recoveryPrompt}|prereqs:[${prereqs.join(',')}]|values:[${values.join(',')}]|'
        'turns:[${f.exampleTurns.join(';;;')}]',
      );
    }

    // 4. Stories (Sorted by ID)
    final stories = List.of(repo.getAllStories())
      ..sort((a, b) => a.id.compareTo(b.id));
    buffer.writeln('=== STORIES (${stories.length}) ===');
    for (final s in stories) {
      buffer.writeln(
        '${s.id}|${s.levelOrder}|${s.title}|review:${s.reviewStatus.name}|'
        'simple:[${s.simpleTextSegments.join(';;;')}]|'
        'rich:[${s.richNarrativeTextSegments.join(';;;')}]',
      );
    }

    // 5. Units (Sorted by ID)
    final units = List.of(repo.getAllUnits())
      ..sort((a, b) => a.id.compareTo(b.id));
    buffer.writeln('=== UNITS (${units.length}) ===');
    for (final u in units) {
      final vocab = List.of(u.vocabularyConceptIds)..sort();
      buffer.writeln(
        '${u.id}|${u.worldId}|${u.levelId}|${u.title}|${u.speakingOutcome}|'
        'vocab:[${vocab.join(',')}]',
      );
    }

    // 6. Lessons (Sorted by ID)
    final lessons = List.of(repo.getAllLessons())
      ..sort((a, b) => a.id.compareTo(b.id));
    buffer.writeln('=== LESSONS (${lessons.length}) ===');
    for (final l in lessons) {
      final acts = List.of(l.activityTemplateIds)..sort();
      buffer.writeln('${l.id}|${l.unitId}|${l.order}|${l.title}|acts:[${acts.join(',')}]');
    }

    // 7. Missions (Sorted by ID)
    final missions = List.of(repo.getAllLevelMissions())
      ..sort((a, b) => a.id.compareTo(b.id));
    buffer.writeln('=== MISSIONS (${missions.length}) ===');
    for (final m in missions) {
      final objectives = List.of(m.assessedObjectiveIds)..sort();
      buffer.writeln('${m.id}|${m.levelId}|${m.title}|objectives:[${objectives.join(',')}]');
    }

    // 8. Can-Do Statements (Sorted by ID)
    final canDos = List.of(repo.getAllCanDoStatements())
      ..sort((a, b) => a.id.compareTo(b.id));
    buffer.writeln('=== CAN_DO (${canDos.length}) ===');
    for (final cd in canDos) {
      buffer.writeln('${cd.id}|${cd.levelOrder}|${cd.text}|evidence:${cd.requiredEvidence}');
    }

    return buffer.toString();
  }

  /// Calculates a deterministic 64-bit hex hash (FNV-1a 64-bit) from string content.
  static String calculateHash(String content) {
    final fnvPrime = BigInt.parse('1099511628211');
    final fnvOffsetBasis = BigInt.parse('14695981039346656037');
    final mask64 = BigInt.parse('18446744073709551615');

    BigInt hash = fnvOffsetBasis;
    final bytes = utf8.encode(content);
    for (final byte in bytes) {
      hash = (hash ^ BigInt.from(byte)) & mask64;
      hash = (hash * fnvPrime) & mask64;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }

  /// Baseline deterministic hash of the frozen Levels 1–3 curriculum.
  static const String frozenBaselineHash = '02f9e00cbd1c1c52';

  /// Verifies that the curriculum in [repo] exactly matches the frozen state.
  static FreezeVerificationResult verify(
    ICurriculumRepository repo, {
    String expectedHash = frozenBaselineHash,
  }) {
    final canonical = buildCanonicalString(repo);
    final actualHash = calculateHash(canonical);

    final allConcepts = repo.getAllConcepts();
    final l1 = allConcepts.where((c) => c.levelOrder == 1).length;
    final l2 = allConcepts.where((c) => c.levelOrder == 2).length;
    final patterns = repo.getAllSentencePatterns().length;
    final functions = repo.getAllConversationFunctions().length;
    final stories = repo.getAllStories().length;
    final units = repo.getAllUnits().length;
    final lessons = repo.getAllLessons().length;
    final missions = repo.getAllLevelMissions().length;
    final canDos = repo.getAllCanDoStatements().length;

    final counts = {
      'level1Concepts': l1,
      'level2Phrases': l2,
      'totalConcepts': allConcepts.length,
      'sentencePatterns': patterns,
      'conversationFunctions': functions,
      'stories': stories,
      'units': units,
      'lessons': lessons,
      'missions': missions,
      'canDoStatements': canDos,
    };

    final discrepancies = <String>[];
    if (l1 != 144) discrepancies.add('Expected 144 Level 1 concepts, found $l1');
    if (l2 != 64) discrepancies.add('Expected 64 Level 2 phrases, found $l2');
    if (allConcepts.length != 208) discrepancies.add('Expected 208 total concepts, found ${allConcepts.length}');
    if (patterns != 26) discrepancies.add('Expected 26 sentence patterns, found $patterns');
    if (functions != 13) discrepancies.add('Expected 13 conversation functions, found $functions');
    if (stories != 3) discrepancies.add('Expected 3 stories, found $stories');
    if (units != 16) discrepancies.add('Expected 16 units, found $units');
    if (lessons != 18) discrepancies.add('Expected 18 lessons, found $lessons');
    if (missions != 3) discrepancies.add('Expected 3 missions, found $missions');
    if (canDos != 12) discrepancies.add('Expected 12 Can-Do statements, found $canDos');

    if (actualHash != expectedHash) {
      discrepancies.add('Canonical hash mismatch: expected $expectedHash, got $actualHash');
    }

    return FreezeVerificationResult(
      isFrozen: discrepancies.isEmpty && actualHash == expectedHash,
      currentHash: actualHash,
      expectedHash: expectedHash,
      discrepancies: discrepancies,
      counts: counts,
    );
  }
}
