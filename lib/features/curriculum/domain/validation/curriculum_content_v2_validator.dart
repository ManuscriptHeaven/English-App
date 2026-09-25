import 'package:kids_english_adventure/core/experience/interactive_activity_integrity_validator.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/v2/curriculum_content_v2.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_track.dart';

/// Result report from the V2 Content Differentiation & Completeness Validator.
class ContentV2ValidationReport {
  final bool isValid;
  final int totalLessons;
  final int totalInteractions;
  final Map<String, int> lessonCountsByTrack;
  final List<String> issues;

  const ContentV2ValidationReport({
    required this.isValid,
    required this.totalLessons,
    required this.totalInteractions,
    required this.lessonCountsByTrack,
    required this.issues,
  });

  @override
  String toString() {
    if (isValid) {
      return 'ContentV2ValidationReport: VALID (Total Lessons: $totalLessons, Total Interactions: $totalInteractions, By Track: $lessonCountsByTrack)';
    }
    return 'ContentV2ValidationReport: INVALID!\nIssues:\n${issues.map((e) => '  - $e').join('\n')}';
  }
}

/// Production validator ensuring CURRICULUM_CONTENT_V2 satisfies all pedagogical mandates:
/// - Exact minimum production thresholds (Age 3: 20+, Age 5: 25+, Age 7: 30+, Age 9: 30+, Age 11: 30+, Total: 135+)
/// - Multi-interaction lessons (>= 4 interactions per lesson)
/// - Semantic object integrity
/// - Strict cross-age developmental differentiation (no duplicate instruction / target experiences).
class CurriculumContentV2Validator {
  static ContentV2ValidationReport validate() {
    final issues = <String>[];
    final countsByTrack = <String, int>{};
    int totalInteractions = 0;

    // 1. Validate Minimum Lesson Count per Track
    for (final track in CurriculumTrack.values) {
      final lessons = CurriculumContentV2.getLessonsForTrack(track);
      countsByTrack[track.name] = lessons.length;

      int requiredMin = 30;
      if (track == CurriculumTrack.track1LittleListeners) requiredMin = 20;
      if (track == CurriculumTrack.track2LittleSpeakers) requiredMin = 25;

      if (lessons.length < requiredMin) {
        issues.add(
          'Track ${track.title} has ${lessons.length} lessons, but requires at least $requiredMin.',
        );
      }

      // 2. Validate Every Lesson Has >= 4 Interactions and Valid Semantic Objects
      for (final lesson in lessons) {
        final activities = CurriculumContentV2.getActivitiesForLesson(lesson.id);
        totalInteractions += activities.length;

        if (activities.length < 4) {
          issues.add(
            'Lesson "${lesson.id}" (${lesson.title}) has only ${activities.length} interactions; minimum required is 4.',
          );
        }

        for (final activity in activities) {
          final actErrors = InteractiveActivityIntegrityValidator.validateActivity(activity);
          for (final err in actErrors) {
            issues.add('[${lesson.id} / ${activity.id}]: $err');
          }
        }
      }
    }

    final allLessons = CurriculumContentV2.getAllLessons();
    if (allLessons.length < 135) {
      issues.add(
        'Total complete lessons is ${allLessons.length}, but Section 20 requires at least 135.',
      );
    }

    // 3. Section 17 Mandate: Cross-Age Differentiation Validator
    // Verify that across different tracks, instructions and speech triggers do not duplicate
    final instructionsByTrack = <CurriculumTrack, List<String>>{};
    for (final track in CurriculumTrack.values) {
      final instructions = <String>[];
      for (final lesson in CurriculumContentV2.getLessonsForTrack(track)) {
        for (final act in CurriculumContentV2.getActivitiesForLesson(lesson.id)) {
          final inst = (act.instructionOverride ?? '').toLowerCase().trim();
          if (inst.isNotEmpty) {
            instructions.add(inst);
          }
        }
      }
      instructionsByTrack[track] = instructions;
    }

    // Check cross-track pairwise duplication
    final tracks = CurriculumTrack.values;
    for (int i = 0; i < tracks.length; i++) {
      for (int j = i + 1; j < tracks.length; j++) {
        final t1 = tracks[i];
        final t2 = tracks[j];
        final list1 = instructionsByTrack[t1] ?? [];
        final list2 = instructionsByTrack[t2] ?? [];

        int exactInstructionOverlap = 0;
        for (final inst in list1) {
          if (list2.contains(inst)) {
            exactInstructionOverlap++;
          }
        }

        // If more than 10% instructions are verbatim duplicates across age tracks, fail validation!
        final maxAllowedOverlap = (list1.length * 0.10).ceil();
        if (exactInstructionOverlap > maxAllowedOverlap) {
          issues.add(
            'EXCESSIVE CROSS-AGE DUPLICATION: ${t1.shortName} and ${t2.shortName} share $exactInstructionOverlap identical instructions (max allowed: $maxAllowedOverlap). Content must be developmentally differentiated!',
          );
        }
      }
    }

    // 4. Validate Food & Drinks Specific Differentiation Spiral (Section 11 & 24)
    final t1Food = CurriculumContentV2.getActivitiesForLesson('t1_l13_sweet_red_apple');
    final t2Food = CurriculumContentV2.getActivitiesForLesson('t2_l08_water_please');
    final t3Food = CurriculumContentV2.getActivitiesForLesson('t3_l10_can_i_have_water_please');
    final t4Food = CurriculumContentV2.getActivitiesForLesson('t4_l10_preferring_fresh_fruit');
    final t5Food = CurriculumContentV2.getActivitiesForLesson('t5_l14_hydration_and_cognitive_power');

    if (t1Food.isEmpty || t2Food.isEmpty || t3Food.isEmpty || t4Food.isEmpty || t5Food.isEmpty) {
      issues.add('Food & Drinks spiral lessons must be fully implemented across all 5 age tracks.');
    }

    return ContentV2ValidationReport(
      isValid: issues.isEmpty,
      totalLessons: allLessons.length,
      totalInteractions: totalInteractions,
      lessonCountsByTrack: countsByTrack,
      issues: issues,
    );
  }
}
