import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/rewards/presentation/providers/progress_providers.dart';
import 'package:kids_english_adventure/features/settings/presentation/providers/settings_providers.dart';
import 'package:kids_english_adventure/features/worlds/presentation/providers/world_providers.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/lesson.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import '../../data/mock_learning_signal_repository.dart';
import '../../data/mock_vocabulary_mastery_repository.dart';
import '../../data/mock_learning_session_repository.dart';
import '../../domain/adaptive/child_learning_profile.dart';
import '../../domain/adaptive/curriculum_graph.dart';
import '../../domain/adaptive/curriculum_progression_engine.dart';
import '../../domain/adaptive/learning_recommendation.dart';
import '../../domain/adaptive/learning_session.dart' as adaptive;
import '../../domain/adaptive/learning_session_orchestrator.dart';
import '../../domain/adaptive/session_pip_guide.dart';
import '../../domain/adaptive/vocabulary_mastery.dart';
import '../../domain/models/content_mastery.dart';
import '../../domain/models/learning_session.dart';
import '../../domain/models/learning_signal.dart';
import '../../domain/models/recommendation.dart';
import '../../domain/models/skill_mastery.dart';
import '../../domain/repositories/learning_session_repository.dart';
import '../../domain/repositories/learning_signal_repository.dart';
import '../../domain/repositories/vocabulary_mastery_repository.dart';
import '../../domain/services/adventure_recommendation_engine.dart';
import '../../domain/services/daily_adventure_planner.dart';
import '../controllers/session_runtime_controller.dart';

final learningSignalRepositoryProvider = Provider<ILearningSignalRepository>((ref) {
  return MockLearningSignalRepository();
});

final contentMasteriesProvider = FutureProvider<List<ContentMastery>>((ref) async {
  final child = ref.watch(activeChildProfileProvider);
  if (child == null) return [];
  final repo = ref.watch(learningSignalRepositoryProvider);
  return repo.getContentMasteriesForChild(child.id);
});

final skillMasteriesProvider = FutureProvider<Map<SkillType, SkillMastery>>((ref) async {
  final child = ref.watch(activeChildProfileProvider);
  if (child == null) return {};
  final repo = ref.watch(learningSignalRepositoryProvider);
  return repo.getSkillMasteriesForChild(child.id);
});

final vocabularyMasteryRepositoryProvider = Provider<IVocabularyMasteryRepository>((ref) {
  return MockVocabularyMasteryRepository();
});

final childVocabularyMasteriesProvider = FutureProvider<List<VocabularyMastery>>((ref) async {
  final child = ref.watch(activeChildProfileProvider);
  if (child == null) return [];
  final repo = ref.watch(vocabularyMasteryRepositoryProvider);
  return repo.getMasteriesForChild(child.id);
});

final childLearningProfileProvider = FutureProvider<ChildLearningProfile?>((ref) async {
  final child = ref.watch(activeChildProfileProvider);
  if (child == null) return null;
  final masteries = await ref.watch(childVocabularyMasteriesProvider.future);
  return ChildLearningProfile.fromMasteries(
    childId: child.id,
    masteries: masteries,
    currentWorldId: child.unlockedWorldIds.isNotEmpty ? child.unlockedWorldIds.last : 'world_animal',
    streakDays: child.streakDays,
  );
});

final adaptiveRecommendationProvider = FutureProvider<LearningRecommendation>((ref) async {
  final child = ref.watch(activeChildProfileProvider);
  final currentWorld = ref.watch(selectedWorldProvider).value ?? _fallbackWorld;
  final masteries = await ref.watch(childVocabularyMasteriesProvider.future);

  final lessons = currentWorld.chapters.isNotEmpty && currentWorld.chapters.first.units.isNotEmpty
      ? currentWorld.chapters.first.units.first.lessons
      : <Lesson>[];

  if (child == null) {
    return LearningRecommendation(
      childId: 'anonymous',
      type: LearningRecommendationType.introduceNewVocabulary,
      targetVocabularyIds: const ['vocab_elephant', 'vocab_lion'],
      worldId: 'world_animal',
      activityId: 'activity_animal_vocab',
      internalReason: 'Initial onboarding exploration.',
      childFriendlyPrompt: 'Let\'s start our learning journey! 🚀',
      generatedAt: DateTime.now(),
      routePath: '/activity/vocabulary',
      title: 'Animal Words Discovery',
      subtitle: 'Discover animals',
    );
  }

  return AdventureRecommendationEngine.getAdaptiveRecommendation(
    child: child,
    vocabularyMasteries: masteries,
    currentWorld: currentWorld,
    availableActivities: lessons,
    now: DateTime.now(),
  );
});

final currentRecommendationProvider = FutureProvider<Recommendation>((ref) async {
  final child = ref.watch(activeChildProfileProvider);
  final progress = ref.watch(activeChildProgressProvider).value;
  final contentMasteries = ref.watch(contentMasteriesProvider).value ?? [];
  final skillMasteries = ref.watch(skillMasteriesProvider).value ?? {};
  final currentWorld = ref.watch(selectedWorldProvider).value ?? _fallbackWorld;
  final settings = ref.watch(appSettingsProvider);

  final lessons = currentWorld.chapters.isNotEmpty && currentWorld.chapters.first.units.isNotEmpty
      ? currentWorld.chapters.first.units.first.lessons
      : <Lesson>[];

  if (child == null) {
    return const Recommendation(
      activityId: 'activity_animal_vocab',
      activityType: 'vocab',
      worldId: 'world_animal',
      skill: SkillType.vocabulary,
      reason: 'Initial onboarding exploration.',
      childFriendlyPrompt: 'Let\'s start our learning journey! 🚀',
      title: 'Animal Words Discovery',
      subtitle: 'Discover animals',
      routePath: '/activity/vocabulary',
    );
  }

  return AdventureRecommendationEngine.getNextRecommendation(
    child: child,
    progress: progress,
    contentMasteries: contentMasteries,
    skillMasteries: skillMasteries,
    currentWorld: currentWorld,
    availableActivities: lessons,
    dailyScreenTimeLimitMinutes: settings.dailyScreenTimeLimitMinutes,
    now: DateTime.now(),
  );
});

final dailyAdventurePlanProvider = FutureProvider<LearningSession>((ref) async {
  final child = ref.watch(activeChildProfileProvider);
  final progress = ref.watch(activeChildProgressProvider).value;
  final contentMasteries = ref.watch(contentMasteriesProvider).value ?? [];
  final skillMasteries = ref.watch(skillMasteriesProvider).value ?? {};
  final currentWorld = ref.watch(selectedWorldProvider).value ?? _fallbackWorld;
  final settings = ref.watch(appSettingsProvider);

  final lessons = currentWorld.chapters.isNotEmpty && currentWorld.chapters.first.units.isNotEmpty
      ? currentWorld.chapters.first.units.first.lessons
      : <Lesson>[];

  if (child == null) {
    return LearningSession(
      id: 'default_session',
      childId: 'default',
      createdAt: DateTime.now(),
      totalEstimatedMinutes: 15,
      activities: const [],
      primaryFocusSkill: SkillType.vocabulary,
      primaryFocusValue: 'Kindness',
    );
  }

  return DailyAdventurePlanner.generateDailySession(
    child: child,
    progress: progress,
    contentMasteries: contentMasteries,
    skillMasteries: skillMasteries,
    currentWorld: currentWorld,
    availableActivities: lessons,
    dailyScreenTimeLimitMinutes: settings.dailyScreenTimeLimitMinutes,
    now: DateTime.now(),
  );
});

const World _fallbackWorld = World(
  id: 'world_animal',
  title: 'Animal Adventure',
  theme: 'animal',
  description: 'Animal adventure world',
  bannerAssetPath: 'assets/images/worlds/animal_adventure/banner.png',
  primaryColorHex: '0xFF66BB6A',
  orderIndex: 1,
  metadata: ContentMetadata(
    learningObjective: 'Animal adventure baseline.',
    worldId: 'world_animal',
  ),
  chapters: [],
  isUnlocked: true,
);

final learningSessionRepositoryProvider = Provider<ILearningSessionRepository>((ref) {
  return MockLearningSessionRepository();
});

final curriculumGraphProvider = Provider<CurriculumGraph>((ref) {
  return CurriculumGraph.standard();
});

final curriculumProgressionEngineProvider = Provider<CurriculumProgressionEngine>((ref) {
  return const CurriculumProgressionEngine();
});

final sessionPipGuideProvider = Provider<SessionPipGuide>((ref) {
  return const SessionPipGuide();
});

final learningSessionOrchestratorProvider = Provider<LearningSessionOrchestrator>((ref) {
  return const LearningSessionOrchestrator();
});

final sessionRuntimeControllerProvider =
    StateNotifierProvider<SessionRuntimeController, SessionRuntimeState>((ref) {
  final sessionRepo = ref.watch(learningSessionRepositoryProvider);
  final masteryRepo = ref.watch(vocabularyMasteryRepositoryProvider);
  final pipGuide = ref.watch(sessionPipGuideProvider);

  return SessionRuntimeController(
    sessionRepository: sessionRepo,
    masteryRepository: masteryRepo,
    pipGuide: pipGuide,
  );
});

final activeLearningSessionProvider = Provider<adaptive.LearningSession?>((ref) {
  final runtimeState = ref.watch(sessionRuntimeControllerProvider);
  return runtimeState.session;
});

final adaptiveLearningSessionPlanProvider = FutureProvider<adaptive.LearningSession?>((ref) async {
  final child = ref.watch(activeChildProfileProvider);
  if (child == null) return null;

  final masteries = await ref.watch(childVocabularyMasteriesProvider.future);
  final currentWorld = ref.watch(selectedWorldProvider).value ?? _fallbackWorld;
  final settings = ref.watch(appSettingsProvider);
  final orchestrator = ref.watch(learningSessionOrchestratorProvider);
  final graph = ref.watch(curriculumGraphProvider);

  return orchestrator.assembleSession(
    child: child,
    masteries: masteries,
    graph: graph,
    currentWorld: currentWorld,
    dailyScreenTimeLimitMinutes: settings.dailyScreenTimeLimitMinutes,
  );
});

