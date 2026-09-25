import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_lesson_spec.dart';
import 'curriculum_v2_lesson_specs_track1.dart';
import 'curriculum_v2_lesson_specs_track2.dart';
import 'curriculum_v2_lesson_specs_track3.dart';
import 'curriculum_v2_lesson_specs_track4.dart';
import 'curriculum_v2_lesson_specs_track5.dart';

/// Central registry of explicit handcrafted specifications for all 150 CURRICULUM_CONTENT_V2 lessons.
/// Generic heuristics and fallback generators are strictly forbidden.
class CurriculumV2LessonSpecs {
  static final Map<String, CurriculumLessonSpec> _allSpecs = {
    ...CurriculumV2LessonSpecsTrack1.specs,
    ...CurriculumV2LessonSpecsTrack2.specs,
    ...CurriculumV2LessonSpecsTrack3.specs,
    ...CurriculumV2LessonSpecsTrack4.specs,
    ...CurriculumV2LessonSpecsTrack5.specs,
  };

  /// Returns unmodifiable view of all 150 lesson specifications.
  static Map<String, CurriculumLessonSpec> get specs => Map.unmodifiable(_allSpecs);

  /// Total number of explicitly specified lessons.
  static int get count => _allSpecs.length;

  /// Checks if an explicit specification exists for [lessonId].
  static bool hasSpec(String lessonId) => _allSpecs.containsKey(lessonId);

  /// Retrieves the explicit specification for [lessonId], or null if not found.
  static CurriculumLessonSpec? getSpec(String lessonId) => _allSpecs[lessonId];

  /// Builds concrete interactive activity configs for [lessonId].
  /// Throws [StateError] if the lesson does not have an explicit handcrafted specification.
  static List<InteractiveActivityConfig> buildActivities(
    String lessonId,
    AgeExperienceProfile profile,
  ) {
    final spec = _allSpecs[lessonId];
    if (spec == null) {
      throw StateError(
        'Production curriculum error: Lesson "$lessonId" has no explicit CurriculumLessonSpec. '
        'Generic fallback is strictly disallowed in V2 production.',
      );
    }
    return spec.buildActivities(profile);
  }
}
