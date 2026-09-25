import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import '../feedback/pip_dialogue_pool.dart';
import '../models/content_review_status.dart';
import '../models/learning_age_band.dart';
import '../repositories/curriculum_repository.dart';

/// Detailed result report from the expanded static curriculum validation.
class ExpandedValidationReport {
  final List<String> errors;
  final List<String> warnings;

  const ExpandedValidationReport({
    this.errors = const [],
    this.warnings = const [],
  });

  bool get isValid => errors.isEmpty;

  @override
  String toString() {
    final errStr = errors.isEmpty ? 'No Errors' : 'Errors:\n  - ${errors.join("\n  - ")}';
    final warnStr = warnings.isEmpty ? 'No Warnings' : 'Warnings:\n  - ${warnings.join("\n  - ")}';
    return 'ExpandedValidationReport(isValid: $isValid, errors: ${errors.length}, warnings: ${warnings.length})\n$errStr\n$warnStr';
  }
}

/// Comprehensive static integrity validator preventing corrupted, circular, unreviewed,
/// or unreachable curriculum structures from reaching learners.
class CurriculumValidatorExpanded {
  const CurriculumValidatorExpanded();

  ExpandedValidationReport validateAll(ICurriculumRepository repo) => validate(repo);

  static ExpandedValidationReport validate(ICurriculumRepository repo) {
    final errors = <String>[];
    final warnings = <String>[];

    final levels = repo.getAllLevels();
    final worlds = repo.getAllWorlds();
    final units = repo.getAllUnits();
    final lessons = repo.getAllLessons();
    final concepts = repo.getAllConcepts();
    final objectives = repo.getAllObjectives();
    final sentencePatterns = repo.getAllSentencePatterns();
    final stories = repo.getAllStories();
    final templates = repo.getAllActivityTemplates();

    // 1. Level Integrity Checks
    if (levels.isEmpty) {
      errors.add('Curriculum has zero defined levels.');
    } else {
      // Check level order continuity (1, 2, 3...)
      for (int i = 0; i < levels.length; i++) {
        if (levels[i].order != i + 1) {
          errors.add('Level order gap or mismatch: Level "${levels[i].id}" has order ${levels[i].order}, expected ${i + 1}.');
        }
      }
    }

    final levelIds = levels.map((l) => l.id).toSet();
    final worldIds = worlds.map((w) => w.id).toSet();
    final unitIds = units.map((u) => u.id).toSet();
    final lessonIds = lessons.map((l) => l.id).toSet();
    final conceptIds = concepts.map((c) => c.id).toSet();
    final objectiveIds = objectives.map((o) => o.id).toSet();
    final patternIds = sentencePatterns.map((p) => p.id).toSet();

    // 2. World Integrity
    for (final w in worlds) {
      for (final lvlId in w.levelIds) {
        if (!levelIds.contains(lvlId)) {
          errors.add('World "${w.id}" references nonexistent levelId "$lvlId".');
        }
      }
      for (final uId in w.unitIds) {
        if (!unitIds.contains(uId)) {
          errors.add('World "${w.id}" references nonexistent unitId "$uId".');
        }
      }
      if (w.unitIds.isEmpty) {
        warnings.add('World "${w.id}" contains zero registered unitIds.');
      }
    }

    // 3. Unit Integrity
    for (final u in units) {
      if (!worldIds.contains(u.worldId)) {
        errors.add('Unit "${u.id}" references nonexistent worldId "${u.worldId}".');
      }
      if (!levelIds.contains(u.levelId)) {
        errors.add('Unit "${u.id}" references nonexistent levelId "${u.levelId}".');
      }
      if (u.speakingOutcome.trim().isEmpty) {
        errors.add('Unit "${u.id}" is missing a required functional speakingOutcome.');
      }
      if (u.listeningOutcome.trim().isEmpty) {
        errors.add('Unit "${u.id}" is missing a required functional listeningOutcome.');
      }
      for (final lId in u.lessonIds) {
        if (!lessonIds.contains(lId)) {
          errors.add('Unit "${u.id}" references nonexistent lessonId "$lId".');
        }
      }
      for (final cId in u.vocabularyConceptIds) {
        if (!conceptIds.contains(cId)) {
          errors.add('Unit "${u.id}" references nonexistent conceptId "$cId".');
        }
      }
    }

    // 4. Lesson Integrity
    for (final l in lessons) {
      if (!unitIds.contains(l.unitId)) {
        errors.add('Lesson "${l.id}" references nonexistent unitId "${l.unitId}".');
      }
      if (!levelIds.contains(l.levelId)) {
        errors.add('Lesson "${l.id}" references nonexistent levelId "${l.levelId}".');
      }
      for (final objId in l.learningObjectiveIds) {
        if (!objectiveIds.contains(objId)) {
          errors.add('Lesson "${l.id}" references nonexistent learningObjectiveId "$objId".');
        }
      }
      for (final cId in l.targetConceptIds) {
        if (!conceptIds.contains(cId)) {
          errors.add('Lesson "${l.id}" references nonexistent targetConceptId "$cId".');
        }
      }
      for (final pId in l.sentencePatternIds) {
        if (!patternIds.contains(pId)) {
          errors.add('Lesson "${l.id}" references nonexistent sentencePatternId "$pId".');
        }
      }
      for (final prereqLessonId in l.prerequisiteLessonIds) {
        if (prereqLessonId == l.id) {
          errors.add('Lesson "${l.id}" lists itself as a prerequisite (self-dependency).');
        } else if (!lessonIds.contains(prereqLessonId)) {
          errors.add('Lesson "${l.id}" references nonexistent prerequisite lesson "$prereqLessonId".');
        }
      }
      if (l.targetConceptIds.length > 7) {
        warnings.add('Lesson "${l.id}" has ${l.targetConceptIds.length} concepts (exceeds recommended cognitive limit of 7).');
      }
    }

    // 5. Objective Integrity
    for (final obj in objectives) {
      if (obj.evidenceTypes.isEmpty) {
        errors.add('Objective "${obj.id}" has no evidenceTypes specified.');
      }
      for (final cId in obj.targetConceptIds) {
        if (!conceptIds.contains(cId)) {
          errors.add('Objective "${obj.id}" references nonexistent conceptId "$cId".');
        }
      }
    }

    // 6. Sentence Pattern Slot Verification
    for (final sp in sentencePatterns) {
      final slotRegex = RegExp(r'\{([a-zA-Z0-9_]+)\}');
      final matches = slotRegex.allMatches(sp.template).map((m) => m.group(1)!).toSet();

      for (final slot in sp.variableSlots) {
        if (!matches.contains(slot)) {
          errors.add('SentencePattern "${sp.id}" declares variable slot "$slot" not found in template "${sp.template}".');
        }
      }
    }

    // 7. Concept Dependency Cycle Detection
    final visited = <String, int>{}; // 0=unvisited, 1=visiting, 2=visited
    final conceptMap = {for (final c in concepts) c.id: c};

    bool hasCycle(String currentId, List<String> path) {
      visited[currentId] = 1;
      path.add(currentId);

      final concept = conceptMap[currentId];
      if (concept != null) {
        for (final prereq in concept.prerequisites) {
          if (!conceptMap.containsKey(prereq)) {
            errors.add('Concept "$currentId" references undefined prerequisite "$prereq".');
            continue;
          }
          final state = visited[prereq] ?? 0;
          if (state == 1) {
            errors.add('Circular prerequisite cycle detected: ${[...path, prereq].join(' -> ')}');
            return true;
          } else if (state == 0) {
            if (hasCycle(prereq, path)) return true;
          }
        }
      }

      path.removeLast();
      visited[currentId] = 2;
      return false;
    }

    for (final id in conceptMap.keys) {
      if ((visited[id] ?? 0) == 0) {
        hasCycle(id, []);
      }
    }

    // 8. Religious Content Review Safety Enforcement
    for (final st in stories) {
      if (st.religiousContentType.requiresScholarReview && st.reviewStatus == ContentReviewStatus.approved) {
        errors.add('Story "${st.id}" contains direct religious content (${st.religiousContentType.name}) but is marked approved without explicit Islamic scholar review.');
      }
      for (final cId in st.targetConceptIds) {
        if (!conceptIds.contains(cId)) {
          errors.add('Story "${st.id}" references nonexistent targetConceptId "$cId".');
        }
      }
    }

    // 9. Sentence Pattern Prerequisite Vocabulary Check (Section 44)
    for (final sp in sentencePatterns) {
      for (final prereqId in sp.prerequisiteConceptIds) {
        if (!conceptIds.contains(prereqId)) {
          errors.add('SentencePattern "${sp.id}" references nonexistent prerequisite concept "$prereqId".');
        }
      }
    }

    // 10. Conversation Function Pattern & Objective Linkage (Section 44)
    for (final cf in repo.getAllConversationFunctions()) {
      for (final patId in cf.prerequisitePatternIds) {
        if (!patternIds.contains(patId)) {
          errors.add('ConversationFunction "${cf.id}" references nonexistent prerequisitePatternId "$patId".');
        }
      }
      for (final objId in cf.speakingObjectiveIds) {
        if (!objectiveIds.contains(objId)) {
          errors.add('ConversationFunction "${cf.id}" references nonexistent speakingObjectiveId "$objId".');
        }
      }
    }

    // 11. Speaking & Listening Modality Alignment (Section 44)
    final templateMap = {for (final t in templates) t.id: t};
    for (final l in lessons) {
      final lessonTemplates = l.activityTemplateIds.map((id) => templateMap[id]).whereType<dynamic>().toList();
      final hasSpeakingTemplate = lessonTemplates.any((t) => t.requiresSpeech == true);
      final hasAudioTemplate = lessonTemplates.any((t) => t.requiresAudio == true);

      for (final objId in l.learningObjectiveIds) {
        final obj = objectives.firstWhere((o) => o.id == objId, orElse: () => objectives.first);
        if (obj.skillDimension == SkillDimension.speaking && !hasSpeakingTemplate && lessonTemplates.isNotEmpty) {
          warnings.add('Lesson "${l.id}" has speaking objective "$objId" but no activity templates requiring speech.');
        }
        if (obj.skillDimension == SkillDimension.listening && !hasAudioTemplate && lessonTemplates.isNotEmpty) {
          warnings.add('Lesson "${l.id}" has listening objective "$objId" but no activity templates requiring audio.');
        }
      }
    }

    // 12. Duplication Detection (Section 46)
    final textSeenByLevel = <int, Set<String>>{};
    for (final c in concepts) {
      final normalized = c.canonicalText.trim().toLowerCase();
      final levelSet = textSeenByLevel.putIfAbsent(c.levelOrder, () => <String>{});
      if (levelSet.contains(normalized)) {
        warnings.add('Potential semantic duplicate concept "${c.canonicalText}" (id: ${c.id}) in Level ${c.levelOrder}.');
      } else {
        levelSet.add(normalized);
      }
    }

    final seenExamples = <String>{};
    for (final sp in sentencePatterns) {
      for (final ex in sp.examples) {
        final normEx = ex.trim().toLowerCase();
        if (seenExamples.contains(normEx)) {
          warnings.add('Duplicate sentence pattern example "$ex" across patterns.');
        } else {
          seenExamples.add(normEx);
        }
      }
    }

    // 13. Orphan Template Check
    if (templates.isEmpty) {
      warnings.add('No ActivityTemplates registered in curriculum repository.');
    }

    // ========================================================================
    // 14. PHASE 15.7 CURRICULUM LOCK VALIDATOR PASS
    // ========================================================================

    // 14.1 Canonical Concept ID Uniqueness & Count Consistency
    if (concepts.length != conceptIds.length) {
      errors.add('Duplicate canonical concept IDs detected: total concepts (${concepts.length}) != unique IDs (${conceptIds.length}).');
    }

    // 14.2 Progression Integrity: Ensure "read" strictly maps to reading concepts, never "eat bread"
    final readConcepts = concepts.where((c) => c.id == 'concept_read').toList();
    if (readConcepts.isNotEmpty) {
      final eatBread = concepts.where((c) => c.id == 'concept_p2_eat_bread').toList();
      if (eatBread.isNotEmpty && eatBread.first.prerequisites.contains('concept_read')) {
        errors.add('Progression defect: "concept_read" is listed as a prerequisite for "eat bread".');
      }
    }

    // 14.3 Unit Outcomes Vocabulary Prerequisite Check
    for (final u in units) {
      final outcomeLower = u.speakingOutcome.toLowerCase();
      // Ensure unit outcome does not demand untaught adjectives in Level 1
      if (u.levelId == 'level_1_first_words' && (outcomeLower.contains('gentle') || outcomeLower.contains('big or gentle'))) {
        errors.add('Unit "${u.id}" outcome references untaught vocabulary ("gentle").');
      }
    }

    // 14.4 Conversation Function Foundation & Integrity
    final convFunctions = repo.getAllConversationFunctions();
    final convIds = convFunctions.map((f) => f.id).toSet();
    if (convFunctions.length != convIds.length) {
      errors.add('Duplicate conversation function IDs detected.');
    }
    if (convFunctions.length < 10) {
      warnings.add('Conversation functions count (${convFunctions.length}) is below Phase 15.7 recommendation (10-14).');
    }
    for (final cf in convFunctions) {
      if (cf.exampleTurns.isEmpty) {
        errors.add('ConversationFunction "${cf.id}" has no exampleTurns.');
      }
      // Verify no automatic religious praise in generic family intro
      if (cf.id == 'func_who_is_this') {
        for (final turn in cf.exampleTurns) {
          if (turn.toLowerCase().contains('mashaallah')) {
            errors.add('ConversationFunction "func_who_is_this" contains automatic religious praise in generic identification.');
          }
        }
      }
    }

    // 14.5 Pip Dialogue Anti-Robotic & Tone Integrity (Bands C & D)
    final bannedBandC = [
      "that's accurate",
      'solid answer',
      'review the sentence context',
      'natural delivery and clear diction',
      'unit objective completed',
      'curriculum level achievement unlocked',
    ];
    final bannedBandD = [
      're-evaluate the phrasing',
      'great listening comprehension',
      'milestone reached',
      'advanced speaker milestone achieved',
    ];

    for (final bandEntry in PipDialoguePool.pools.entries) {
      final band = bandEntry.key;
      for (final typeEntry in bandEntry.value.entries) {
        for (final line in typeEntry.value) {
          final lower = line.toLowerCase();
          if (band == LearningAgeBand.bandCGrowingSpeakers) {
            for (final banned in bannedBandC) {
              if (lower.contains(banned)) {
                errors.add('Pip Band C pool contains banned robotic phrase: "$banned" in line "$line".');
              }
            }
          }
          if (band == LearningAgeBand.bandDConfidentSpeakers) {
            for (final banned in bannedBandD) {
              if (lower.contains(banned)) {
                errors.add('Pip Band D pool contains banned formal phrase: "$banned" in line "$line".');
              }
            }
          }
          // Generic praise must not contain automatic religious invocations on trivial taps
          if (lower.contains('mashaallah') || lower.contains('alhamdulillah')) {
            errors.add('Pip dialogue pool must not contain religious invocation on trivial correct taps: "$line".');
          }
        }
      }
    }

    // 14.6 Religious Content Review Status
    for (final c in concepts) {
      if (c.tags.contains('islamic') && c.reviewStatus != ContentReviewStatus.pendingQualifiedIslamicReview) {
        errors.add('Islamic concept "${c.id}" must be marked pendingQualifiedIslamicReview.');
      }
    }

    // 14.7 Internal Definitions Natural Child English Audit
    final bannedAcademicTerms = [
      'feline pet',
      'ruminant mammal',
      'limbless water creature',
      'canine animal',
    ];
    for (final c in concepts) {
      final meaningLower = c.meaning.toLowerCase();
      for (final term in bannedAcademicTerms) {
        if (meaningLower.contains(term)) {
          errors.add('Concept "${c.id}" contains overly academic definition term: "$term".');
        }
      }
    }

    return ExpandedValidationReport(
      errors: List.unmodifiable(errors),
      warnings: List.unmodifiable(warnings),
    );
  }
}
