import 'package:kids_english_adventure/features/curriculum/data/seed/v2/curriculum_content_v2.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_lesson.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_track.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_unit.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_world.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/chapter.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/lesson.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/unit.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';
import 'package:kids_english_adventure/features/worlds/domain/repositories/world_repository.dart';

/// Production World Repository serving CURRICULUM_CONTENT_V2 data.
/// Bridges CurriculumTrack, CurriculumWorld, CurriculumUnit, and CurriculumLesson
/// into the application's World, Chapter, Unit, and Lesson domain models.
/// Preserves MockWorldRepository as a migration/debug fallback for legacy IDs.
class V2CurriculumWorldRepository implements IWorldRepository {
  final Map<String, World> _worldsMap = {};
  final Map<String, Chapter> _chaptersMap = {};
  final Map<String, Unit> _unitsMap = {};
  final Map<String, Lesson> _lessonsMap = {};
  final Map<CurriculumTrack, List<World>> _trackWorldsMap = {};
  final MockWorldRepository _fallbackRepo = MockWorldRepository();

  V2CurriculumWorldRepository() {
    _buildV2Content();
  }

  void _buildV2Content() {
    for (final track in CurriculumTrack.values) {
      final List<World> trackWorlds = [];
      final v2Worlds = CurriculumContentV2.getWorldsForTrack(track);

      for (int wIdx = 0; wIdx < v2Worlds.length; wIdx++) {
        final CurriculumWorld cw = v2Worlds[wIdx];

        // Each CurriculumWorld has unitIds
        final List<Unit> convertedUnits = [];
        for (final unitId in cw.unitIds) {
          final CurriculumUnit? cu = CurriculumContentV2.getUnitById(unitId);
          if (cu == null) continue;

          // Each CurriculumUnit has lessonIds
          final List<Lesson> convertedLessons = [];
          for (final lessonId in cu.lessonIds) {
            final CurriculumLesson? cl = CurriculumContentV2.getLessonById(lessonId);
            if (cl == null) continue;

            final lesson = Lesson(
              id: cl.id,
              unitId: cu.id,
              title: cl.title,
              subtitle: cl.speakingOutcome.isNotEmpty ? cl.speakingOutcome : cl.listeningOutcome,
              orderIndex: cl.order,
              metadata: ContentMetadata(
                minAge: track.minAge,
                maxAge: track.maxAge,
                difficulty: _mapTrackDifficulty(track),
                languageLevel: _mapTrackLanguageLevel(track),
                learningObjective:
                    cl.speakingOutcome.isNotEmpty ? cl.speakingOutcome : cl.listeningOutcome,
                vocabularyTags: cl.targetConceptIds,
                worldId: cw.id,
                unitId: cu.id,
                status: PublishedStatus.published,
              ),
              targetVocabularyIds: cl.targetConceptIds,
              activities: const [],
              rewardXp: 20,
              rewardCoins: 10,
              rewardStars: 3,
              isUnlocked: true,
            );

            convertedLessons.add(lesson);
            _lessonsMap[lesson.id] = lesson;
          }

          final unit = Unit(
            id: cu.id,
            chapterId: 'chapter_${cw.id}',
            title: cu.title,
            subtitle: cu.speakingOutcome,
            orderIndex: 1,
            metadata: ContentMetadata(
              minAge: track.minAge,
              maxAge: track.maxAge,
              difficulty: _mapTrackDifficulty(track),
              learningObjective: cu.speakingOutcome,
              worldId: cw.id,
              unitId: cu.id,
              status: PublishedStatus.published,
            ),
            lessons: convertedLessons,
            isUnlocked: true,
          );

          convertedUnits.add(unit);
          _unitsMap[unit.id] = unit;
        }

        final chapter = Chapter(
          id: 'chapter_${cw.id}',
          worldId: cw.id,
          title: cw.title,
          description: cw.description,
          orderIndex: 1,
          metadata: ContentMetadata(
            minAge: track.minAge,
            maxAge: track.maxAge,
            difficulty: _mapTrackDifficulty(track),
            learningObjective: cw.description,
            worldId: cw.id,
            status: PublishedStatus.published,
          ),
          units: convertedUnits,
          isUnlocked: true,
        );
        _chaptersMap[chapter.id] = chapter;

        final world = World(
          id: cw.id,
          title: cw.childFriendlyTitle.isNotEmpty ? cw.childFriendlyTitle : cw.title,
          theme: cw.theme,
          description: cw.description,
          bannerAssetPath: 'assets/images/worlds/${cw.theme}.png',
          primaryColorHex: _colorHexForTrack(track),
          orderIndex: wIdx + 1,
          metadata: ContentMetadata(
            minAge: track.minAge,
            maxAge: track.maxAge,
            difficulty: _mapTrackDifficulty(track),
            learningObjective: cw.description,
            worldId: cw.id,
            status: PublishedStatus.published,
          ),
          chapters: [chapter],
          featuredValues: cw.valueThemes,
          isUnlocked: true,
        );

        trackWorlds.add(world);
        _worldsMap[world.id] = world;
      }

      _trackWorldsMap[track] = trackWorlds;
    }
  }

  /// Returns the initial world ID for a given curriculum track.
  static String defaultWorldIdForTrack(CurriculumTrack track) {
    switch (track) {
      case CurriculumTrack.track1LittleListeners:
        return 'world_t1_hello_me';
      case CurriculumTrack.track2LittleSpeakers:
        return 'world_t2_me';
      case CurriculumTrack.track3YoungSpeakers:
        return 'world_t3_me_family';
      case CurriculumTrack.track4GrowingCommunicators:
        return 'world_t4_identity';
      case CurriculumTrack.track5ConfidentCommunicators:
        return 'world_t5_identity';
    }
  }

  /// Synchronously or asynchronously retrieve worlds scoped to a track.
  List<World> getWorldsForTrack(CurriculumTrack track) {
    return _trackWorldsMap[track] ?? [];
  }

  @override
  Future<List<World>> getAllWorlds() async {
    return _worldsMap.values.toList();
  }

  @override
  Future<World?> getWorldById(String id) async {
    if (_worldsMap.containsKey(id)) {
      return _worldsMap[id];
    }
    return _fallbackRepo.getWorldById(id);
  }

  @override
  Future<Chapter?> getChapterById(String chapterId) async {
    if (_chaptersMap.containsKey(chapterId)) {
      return _chaptersMap[chapterId];
    }
    return _fallbackRepo.getChapterById(chapterId);
  }

  @override
  Future<Unit?> getUnitById(String unitId) async {
    if (_unitsMap.containsKey(unitId)) {
      return _unitsMap[unitId];
    }
    return _fallbackRepo.getUnitById(unitId);
  }

  @override
  Future<Lesson?> getLessonById(String lessonId) async {
    if (_lessonsMap.containsKey(lessonId)) {
      return _lessonsMap[lessonId];
    }
    return _fallbackRepo.getLessonById(lessonId);
  }

  static DifficultyLevel _mapTrackDifficulty(CurriculumTrack track) {
    switch (track) {
      case CurriculumTrack.track1LittleListeners:
      case CurriculumTrack.track2LittleSpeakers:
        return DifficultyLevel.beginner;
      case CurriculumTrack.track3YoungSpeakers:
        return DifficultyLevel.elementary;
      case CurriculumTrack.track4GrowingCommunicators:
        return DifficultyLevel.intermediate;
      case CurriculumTrack.track5ConfidentCommunicators:
        return DifficultyLevel.advanced;
    }
  }

  static String _mapTrackLanguageLevel(CurriculumTrack track) {
    switch (track) {
      case CurriculumTrack.track1LittleListeners:
      case CurriculumTrack.track2LittleSpeakers:
        return 'Pre-A1';
      case CurriculumTrack.track3YoungSpeakers:
        return 'A1';
      case CurriculumTrack.track4GrowingCommunicators:
        return 'A2';
      case CurriculumTrack.track5ConfidentCommunicators:
        return 'B1';
    }
  }

  static String _colorHexForTrack(CurriculumTrack track) {
    switch (track) {
      case CurriculumTrack.track1LittleListeners:
        return '0xFFFF7043';
      case CurriculumTrack.track2LittleSpeakers:
        return '0xFFFFCA28';
      case CurriculumTrack.track3YoungSpeakers:
        return '0xFF66BB6A';
      case CurriculumTrack.track4GrowingCommunicators:
        return '0xFF42A5F5';
      case CurriculumTrack.track5ConfidentCommunicators:
        return '0xFFAB47BC';
    }
  }
}
