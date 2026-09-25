import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import '../models/activity_template.dart';
import '../models/can_do_statement.dart';
import '../models/curriculum_lesson.dart';
import '../models/curriculum_level.dart';
import '../models/curriculum_unit.dart';
import '../models/curriculum_version.dart';
import '../models/curriculum_world.dart';
import '../models/islamic_value_theme.dart';
import '../models/learning_age_band.dart';
import '../models/learning_concept.dart';
import '../models/learning_objective.dart';
import '../models/learning_story.dart';
import '../models/level_mission.dart';
import '../models/sentence_pattern.dart';
import '../models/conversation_function.dart';

/// Contract for accessing the complete curriculum hierarchy offline.
abstract class ICurriculumRepository {
  CurriculumVersion get version;

  List<CurriculumLevel> getAllLevels();
  CurriculumLevel? getLevelById(String id);
  CurriculumLevel? getLevelByOrder(int order);

  List<CurriculumWorld> getAllWorlds();
  CurriculumWorld? getWorldById(String id);
  List<CurriculumWorld> getWorldsForLevel(String levelId);

  List<CurriculumUnit> getAllUnits();
  CurriculumUnit? getUnitById(String id);
  List<CurriculumUnit> getUnitsForWorld(String worldId);

  List<CurriculumLesson> getAllLessons();
  CurriculumLesson? getLessonById(String id);
  List<CurriculumLesson> getLessonsForUnit(String unitId);

  List<LearningConcept> getAllConcepts();
  LearningConcept? getConceptById(String id);
  List<LearningConcept> getConceptsForLevel(int levelOrder);
  List<LearningConcept> getConceptsForSkill(SkillDimension skill);
  List<LearningConcept> getConceptsForAgeBand(LearningAgeBand ageBand);
  List<LearningConcept> getConceptsForValueTheme(String valueThemeId);
  List<LearningConcept> getApprovedConcepts();

  List<SentencePattern> getAllSentencePatterns();
  SentencePattern? getSentencePatternById(String id);

  List<ConversationFunction> getAllConversationFunctions();
  ConversationFunction? getConversationFunctionById(String id);

  List<IslamicValueTheme> getAllValueThemes();
  IslamicValueTheme? getValueThemeById(String id);

  List<LearningObjective> getAllObjectives();
  LearningObjective? getObjectiveById(String id);

  List<CanDoStatement> getAllCanDoStatements();
  CanDoStatement? getCanDoStatementById(String id);

  List<LearningStory> getAllStories();
  LearningStory? getStoryById(String id);

  List<LevelMission> getAllLevelMissions();
  LevelMission? getLevelMissionById(String id);

  List<ActivityTemplate> getAllActivityTemplates();
  ActivityTemplate? getActivityTemplateById(String id);
}

/// In-memory indexed curriculum repository guaranteeing $O(1)$ fast lookups across
/// levels, worlds, units, lessons, and concepts.
class CurriculumRepository implements ICurriculumRepository {
  @override
  final CurriculumVersion version;

  final Map<String, CurriculumLevel> _levelsById = {};
  final Map<int, CurriculumLevel> _levelsByOrder = {};

  final Map<String, CurriculumWorld> _worldsById = {};
  final Map<String, List<String>> _worldIdsByLevelId = {};

  final Map<String, CurriculumUnit> _unitsById = {};
  final Map<String, List<String>> _unitIdsByWorldId = {};

  final Map<String, CurriculumLesson> _lessonsById = {};
  final Map<String, List<String>> _lessonIdsByUnitId = {};

  final Map<String, LearningConcept> _conceptsById = {};
  final Map<int, List<String>> _conceptIdsByLevel = {};
  final Map<SkillDimension, List<String>> _conceptIdsBySkill = {};
  final Map<LearningAgeBand, List<String>> _conceptIdsByAgeBand = {};
  final Map<String, List<String>> _conceptIdsByValueTheme = {};

  final Map<String, SentencePattern> _sentencePatternsById = {};
  final Map<String, ConversationFunction> _conversationFunctionsById = {};
  final Map<String, IslamicValueTheme> _valueThemesById = {};
  final Map<String, LearningObjective> _objectivesById = {};
  final Map<String, CanDoStatement> _canDoStatementsById = {};
  final Map<String, LearningStory> _storiesById = {};
  final Map<String, LevelMission> _levelMissionsById = {};
  final Map<String, ActivityTemplate> _activityTemplatesById = {};

  CurriculumRepository({
    required this.version,
    List<CurriculumLevel> levels = const [],
    List<CurriculumWorld> worlds = const [],
    List<CurriculumUnit> units = const [],
    List<CurriculumLesson> lessons = const [],
    List<LearningConcept> concepts = const [],
    List<SentencePattern> sentencePatterns = const [],
    List<ConversationFunction> conversationFunctions = const [],
    List<IslamicValueTheme> valueThemes = const [],
    List<LearningObjective> objectives = const [],
    List<CanDoStatement> canDoStatements = const [],
    List<LearningStory> stories = const [],
    List<LevelMission> levelMissions = const [],
    List<ActivityTemplate> activityTemplates = const [],
  }) {
    for (final l in levels) {
      _levelsById[l.id] = l;
      _levelsByOrder[l.order] = l;
    }

    for (final w in worlds) {
      _worldsById[w.id] = w;
      for (final lvlId in w.levelIds) {
        _worldIdsByLevelId.putIfAbsent(lvlId, () => []).add(w.id);
      }
    }

    for (final u in units) {
      _unitsById[u.id] = u;
      _unitIdsByWorldId.putIfAbsent(u.worldId, () => []).add(u.id);
    }

    for (final l in lessons) {
      _lessonsById[l.id] = l;
      _lessonIdsByUnitId.putIfAbsent(l.unitId, () => []).add(l.id);
    }

    for (final c in concepts) {
      _conceptsById[c.id] = c;
      _conceptIdsByLevel.putIfAbsent(c.levelOrder, () => []).add(c.id);

      for (final skill in c.skillDimensions) {
        _conceptIdsBySkill.putIfAbsent(skill, () => []).add(c.id);
      }

      for (final ageBand in c.ageBands) {
        _conceptIdsByAgeBand.putIfAbsent(ageBand, () => []).add(c.id);
      }

      for (final v in c.valueThemeIds) {
        _conceptIdsByValueTheme.putIfAbsent(v, () => []).add(c.id);
      }
    }

    for (final sp in sentencePatterns) {
      _sentencePatternsById[sp.id] = sp;
    }

    for (final cf in conversationFunctions) {
      _conversationFunctionsById[cf.id] = cf;
    }

    for (final vt in valueThemes) {
      _valueThemesById[vt.id] = vt;
    }

    for (final obj in objectives) {
      _objectivesById[obj.id] = obj;
    }

    for (final cd in canDoStatements) {
      _canDoStatementsById[cd.id] = cd;
    }

    for (final st in stories) {
      _storiesById[st.id] = st;
    }

    for (final lm in levelMissions) {
      _levelMissionsById[lm.id] = lm;
    }

    for (final at in activityTemplates) {
      _activityTemplatesById[at.id] = at;
    }
  }

  @override
  List<CurriculumLevel> getAllLevels() => _levelsById.values.toList()
    ..sort((a, b) => a.order.compareTo(b.order));

  @override
  CurriculumLevel? getLevelById(String id) => _levelsById[id];

  @override
  CurriculumLevel? getLevelByOrder(int order) => _levelsByOrder[order];

  @override
  List<CurriculumWorld> getAllWorlds() => _worldsById.values.toList();

  @override
  CurriculumWorld? getWorldById(String id) => _worldsById[id];

  @override
  List<CurriculumWorld> getWorldsForLevel(String levelId) {
    final worldIds = _worldIdsByLevelId[levelId] ?? [];
    return worldIds.map((id) => _worldsById[id]!).toList();
  }

  @override
  List<CurriculumUnit> getAllUnits() => _unitsById.values.toList();

  @override
  CurriculumUnit? getUnitById(String id) => _unitsById[id];

  @override
  List<CurriculumUnit> getUnitsForWorld(String worldId) {
    final unitIds = _unitIdsByWorldId[worldId] ?? [];
    return unitIds.map((id) => _unitsById[id]!).toList();
  }

  @override
  List<CurriculumLesson> getAllLessons() => _lessonsById.values.toList()
    ..sort((a, b) => a.order.compareTo(b.order));

  @override
  CurriculumLesson? getLessonById(String id) => _lessonsById[id];

  @override
  List<CurriculumLesson> getLessonsForUnit(String unitId) {
    final lessonIds = _lessonIdsByUnitId[unitId] ?? [];
    final lessons = lessonIds.map((id) => _lessonsById[id]!).toList();
    lessons.sort((a, b) => a.order.compareTo(b.order));
    return lessons;
  }

  @override
  List<LearningConcept> getAllConcepts() => _conceptsById.values.toList();

  @override
  LearningConcept? getConceptById(String id) => _conceptsById[id];

  @override
  List<LearningConcept> getConceptsForLevel(int levelOrder) {
    final ids = _conceptIdsByLevel[levelOrder] ?? [];
    return ids.map((id) => _conceptsById[id]!).toList();
  }

  @override
  List<LearningConcept> getConceptsForSkill(SkillDimension skill) {
    final ids = _conceptIdsBySkill[skill] ?? [];
    return ids.map((id) => _conceptsById[id]!).toList();
  }

  @override
  List<LearningConcept> getConceptsForAgeBand(LearningAgeBand ageBand) {
    final ids = _conceptIdsByAgeBand[ageBand] ?? [];
    return ids.map((id) => _conceptsById[id]!).toList();
  }

  @override
  List<LearningConcept> getConceptsForValueTheme(String valueThemeId) {
    final ids = _conceptIdsByValueTheme[valueThemeId] ?? [];
    return ids.map((id) => _conceptsById[id]!).toList();
  }

  @override
  List<LearningConcept> getApprovedConcepts() {
    return _conceptsById.values.toList();
  }

  @override
  List<SentencePattern> getAllSentencePatterns() => _sentencePatternsById.values.toList();

  @override
  SentencePattern? getSentencePatternById(String id) => _sentencePatternsById[id];

  @override
  List<ConversationFunction> getAllConversationFunctions() =>
      _conversationFunctionsById.values.toList();

  @override
  ConversationFunction? getConversationFunctionById(String id) =>
      _conversationFunctionsById[id];

  @override
  List<IslamicValueTheme> getAllValueThemes() => _valueThemesById.values.toList();

  @override
  IslamicValueTheme? getValueThemeById(String id) => _valueThemesById[id];

  @override
  List<LearningObjective> getAllObjectives() => _objectivesById.values.toList();

  @override
  LearningObjective? getObjectiveById(String id) => _objectivesById[id];

  @override
  List<CanDoStatement> getAllCanDoStatements() => _canDoStatementsById.values.toList();

  @override
  CanDoStatement? getCanDoStatementById(String id) => _canDoStatementsById[id];

  @override
  List<LearningStory> getAllStories() => _storiesById.values.toList();

  @override
  LearningStory? getStoryById(String id) => _storiesById[id];

  @override
  List<LevelMission> getAllLevelMissions() => _levelMissionsById.values.toList();

  @override
  LevelMission? getLevelMissionById(String id) => _levelMissionsById[id];

  @override
  List<ActivityTemplate> getAllActivityTemplates() => _activityTemplatesById.values.toList();

  @override
  ActivityTemplate? getActivityTemplateById(String id) => _activityTemplatesById[id];
}
