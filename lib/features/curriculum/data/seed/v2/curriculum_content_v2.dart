import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_lesson.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_track.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_unit.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_version.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_world.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_story.dart';
import 'curriculum_v2_conversations.dart';
import 'curriculum_v2_stories.dart';
import 'curriculum_v2_track1_listeners.dart';
import 'curriculum_v2_track2_speakers.dart';
import 'curriculum_v2_track3_young_speakers.dart';
import 'curriculum_v2_track4_growing_communicators.dart';
import 'curriculum_v2_track5_confident_communicators.dart';

/// Master Production Repository Aggregator for CURRICULUM_CONTENT_V2.
/// Unites 5 Production Learning Tracks, 48 Worlds, 48 Units, 150 Complete Lessons,
/// 750+ Micro-Interactions, 19 Functional Conversations, and 10 Curated Stories.
class CurriculumContentV2 {
  static final CurriculumVersion version = CurriculumVersion.v2;

  // ── 1. Tracks ──
  static List<CurriculumTrack> getAllTracks() => CurriculumTrack.values;

  static CurriculumTrack? getTrackById(String id) {
    for (final t in CurriculumTrack.values) {
      if (t.id == id) return t;
    }
    return null;
  }

  static CurriculumTrack getTrackForAge(int age) => CurriculumTrack.forAge(age);

  // ── 2. Worlds ──
  static List<CurriculumWorld> getAllWorlds() {
    return [
      ...CurriculumV2Track1Listeners.worlds,
      ...CurriculumV2Track2Speakers.worlds,
      ...CurriculumV2Track3YoungSpeakers.worlds,
      ...CurriculumV2Track4GrowingCommunicators.worlds,
      ...CurriculumV2Track5ConfidentCommunicators.worlds,
    ];
  }

  static CurriculumWorld? getWorldById(String id) {
    for (final w in getAllWorlds()) {
      if (w.id == id) return w;
    }
    return null;
  }

  static List<CurriculumWorld> getWorldsForTrack(CurriculumTrack track) {
    switch (track) {
      case CurriculumTrack.track1LittleListeners:
        return CurriculumV2Track1Listeners.worlds;
      case CurriculumTrack.track2LittleSpeakers:
        return CurriculumV2Track2Speakers.worlds;
      case CurriculumTrack.track3YoungSpeakers:
        return CurriculumV2Track3YoungSpeakers.worlds;
      case CurriculumTrack.track4GrowingCommunicators:
        return CurriculumV2Track4GrowingCommunicators.worlds;
      case CurriculumTrack.track5ConfidentCommunicators:
        return CurriculumV2Track5ConfidentCommunicators.worlds;
    }
  }

  // ── 3. Units ──
  static List<CurriculumUnit> getAllUnits() {
    return [
      ...CurriculumV2Track1Listeners.units,
      ...CurriculumV2Track2Speakers.units,
      ...CurriculumV2Track3YoungSpeakers.units,
      ...CurriculumV2Track4GrowingCommunicators.units,
      ...CurriculumV2Track5ConfidentCommunicators.units,
    ];
  }

  static CurriculumUnit? getUnitById(String id) {
    for (final u in getAllUnits()) {
      if (u.id == id) return u;
    }
    return null;
  }

  static List<CurriculumUnit> getUnitsForWorld(String worldId) {
    return getAllUnits().where((u) => u.worldId == worldId).toList();
  }

  // ── 4. Lessons ──
  static List<CurriculumLesson> getAllLessons() {
    return [
      ...CurriculumV2Track1Listeners.lessons,
      ...CurriculumV2Track2Speakers.lessons,
      ...CurriculumV2Track3YoungSpeakers.lessons,
      ...CurriculumV2Track4GrowingCommunicators.lessons,
      ...CurriculumV2Track5ConfidentCommunicators.lessons,
    ];
  }

  static CurriculumLesson? getLessonById(String id) {
    for (final l in getAllLessons()) {
      if (l.id == id) return l;
    }
    return null;
  }

  static List<CurriculumLesson> getLessonsForUnit(String unitId) {
    return getAllLessons().where((l) => l.unitId == unitId).toList();
  }

  static List<CurriculumLesson> getLessonsForTrack(CurriculumTrack track) {
    switch (track) {
      case CurriculumTrack.track1LittleListeners:
        return CurriculumV2Track1Listeners.lessons;
      case CurriculumTrack.track2LittleSpeakers:
        return CurriculumV2Track2Speakers.lessons;
      case CurriculumTrack.track3YoungSpeakers:
        return CurriculumV2Track3YoungSpeakers.lessons;
      case CurriculumTrack.track4GrowingCommunicators:
        return CurriculumV2Track4GrowingCommunicators.lessons;
      case CurriculumTrack.track5ConfidentCommunicators:
        return CurriculumV2Track5ConfidentCommunicators.lessons;
    }
  }

  // ── 5. Activities ──
  static List<InteractiveActivityConfig> getActivitiesForLesson(String lessonId) {
    if (lessonId.startsWith('t1_')) {
      return CurriculumV2Track1Listeners.getActivitiesForLesson(lessonId);
    }
    if (lessonId.startsWith('t2_')) {
      return CurriculumV2Track2Speakers.getActivitiesForLesson(lessonId);
    }
    if (lessonId.startsWith('t3_')) {
      return CurriculumV2Track3YoungSpeakers.getActivitiesForLesson(lessonId);
    }
    if (lessonId.startsWith('t4_')) {
      return CurriculumV2Track4GrowingCommunicators.getActivitiesForLesson(lessonId);
    }
    if (lessonId.startsWith('t5_')) {
      return CurriculumV2Track5ConfidentCommunicators.getActivitiesForLesson(lessonId);
    }
    return [];
  }

  // ── 6. Stories & Conversations ──
  static List<LearningStory> getAllStories() => CurriculumV2Stories.stories;

  static LearningStory? getStoryById(String id) {
    for (final s in CurriculumV2Stories.stories) {
      if (s.id == id) return s;
    }
    return null;
  }

  static List<FunctionalConversationTurn> getAllConversations() =>
      CurriculumV2Conversations.conversations;

  static FunctionalConversationTurn? getConversationById(String id) {
    for (final c in CurriculumV2Conversations.conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  // ── 7. Detailed Live Analytics / Counts ──
  static Map<String, dynamic> generateLiveStats() {
    final allLessons = getAllLessons();
    int totalInteractions = 0;
    int speakingCount = 0;
    int listeningCount = 0;
    int dragDropCount = 0;
    int scenePlacementCount = 0;
    int rolePlayCount = 0;
    int feedCount = 0;

    for (final lesson in allLessons) {
      final activities = getActivitiesForLesson(lesson.id);
      totalInteractions += activities.length;
      for (final a in activities) {
        switch (a.mechanicType) {
          case ActivityMechanicType.speakToMakeSomethingHappen:
            speakingCount++;
            break;
          case ActivityMechanicType.listenAndTouch:
            listeningCount++;
            break;
          case ActivityMechanicType.dragAndDrop:
            dragDropCount++;
            break;
          case ActivityMechanicType.scenePlacement:
            scenePlacementCount++;
            break;
          case ActivityMechanicType.conversationRolePlay:
            rolePlayCount++;
            break;
          case ActivityMechanicType.feedCharacter:
            feedCount++;
            break;
          case ActivityMechanicType.interactiveStory:
            break;
        }
      }
    }

    final trackStats = <String, Map<String, int>>{};
    for (final track in CurriculumTrack.values) {
      final lessons = getLessonsForTrack(track);
      int trackInteractions = 0;
      int tSpeaking = 0;
      int tListening = 0;
      int tDrag = 0;
      int tPlacement = 0;
      int tRolePlay = 0;

      for (final l in lessons) {
        final acts = getActivitiesForLesson(l.id);
        trackInteractions += acts.length;
        for (final a in acts) {
          if (a.mechanicType == ActivityMechanicType.speakToMakeSomethingHappen) tSpeaking++;
          if (a.mechanicType == ActivityMechanicType.listenAndTouch) tListening++;
          if (a.mechanicType == ActivityMechanicType.dragAndDrop) tDrag++;
          if (a.mechanicType == ActivityMechanicType.scenePlacement) tPlacement++;
          if (a.mechanicType == ActivityMechanicType.conversationRolePlay) tRolePlay++;
        }
      }

      trackStats[track.name] = {
        'worlds': getWorldsForTrack(track).length,
        'units': getWorldsForTrack(track).length, // each world has dedicated unit
        'lessons': lessons.length,
        'interactions': trackInteractions,
        'speakingActivities': tSpeaking,
        'listeningActivities': tListening,
        'dragDropActivities': tDrag,
        'scenePlacementActivities': tPlacement,
        'rolePlayActivities': tRolePlay,
      };
    }

    return {
      'totalTracks': CurriculumTrack.values.length,
      'totalWorlds': getAllWorlds().length,
      'totalUnits': getAllUnits().length,
      'totalLessons': allLessons.length,
      'totalInteractions': totalInteractions,
      'totalStories': getAllStories().length,
      'totalConversations': getAllConversations().length,
      'speakingCount': speakingCount,
      'listeningCount': listeningCount,
      'dragDropCount': dragDropCount,
      'scenePlacementCount': scenePlacementCount,
      'rolePlayCount': rolePlayCount,
      'feedCount': feedCount,
      'byTrack': trackStats,
    };
  }
}
