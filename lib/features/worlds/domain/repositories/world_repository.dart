import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/chapter.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/unit.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/lesson.dart';

/// Abstract repository for querying themed worlds, chapters, units, and lessons.
abstract class IWorldRepository {
  Future<List<World>> getAllWorlds();
  Future<World?> getWorldById(String id);
  Future<Chapter?> getChapterById(String chapterId);
  Future<Unit?> getUnitById(String unitId);
  Future<Lesson?> getLessonById(String lessonId);
}
