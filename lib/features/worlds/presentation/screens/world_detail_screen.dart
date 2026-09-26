import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/world_themes.dart';
import '../../../../core/widgets/adventure_scaffold.dart';
import '../../../../core/widgets/adventure_trail_map.dart';
import '../../../../core/widgets/pip_character_guide.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../domain/models/lesson.dart';
import '../providers/world_providers.dart';

/// Illustrated Adventure Map Screen displaying interactive trail nodes for children.
class WorldDetailScreen extends ConsumerWidget {
  final String worldId;

  const WorldDetailScreen({super.key, required this.worldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worldAsync = ref.watch(worldDetailProvider(worldId));
    final activeChild = ref.watch(activeChildProfileProvider);
    final worldTheme = WorldTheme.forWorldId(worldId);

    return Scaffold(
      backgroundColor: worldTheme.backgroundColor,
      body: Stack(
        children: [
          // Background Painter
          Positioned.fill(
            child: ExcludeSemantics(
              excluding: true,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: WorldScenePainter(
                    theme: worldTheme,
                    groundHeightFraction: 0.20,
                  ),
                ),
              ),
            ),
          ),

          // Child AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ChildAppBar(
              title: '${worldTheme.displayName} 🗺️',
              showBack: true,
              stars: activeChild?.stars ?? 0,
              coins: activeChild?.coins ?? 0,
              worldTheme: worldTheme,
            ),
          ),

          SafeArea(
            child: worldAsync.when(
              loading: () => const LoadingView(message: 'Loading adventure trail...'),
              error: (err, _) => ErrorView(message: err.toString()),
              data: (world) {
                if (world == null) {
                  return const EmptyView(title: 'World Not Found', subtitle: 'This world has not yet been discovered.');
                }

                final completedIds = activeChild?.completedLessonIds ?? [];
                final activities = world.chapters.isNotEmpty && world.chapters.first.units.isNotEmpty
                    ? world.chapters.first.units.first.lessons
                    : <Lesson>[];

                // Calculate world-local progress
                final completedInThisWorld = activities.where((l) => completedIds.contains(l.id)).length;
                final totalInThisWorld = activities.length;
                final isWorldCompleted = totalInThisWorld > 0 && completedInThisWorld == totalInThisWorld;

                // Find current active lesson index
                int currentIndex = 0;
                if (isWorldCompleted) {
                  // Do not reset visually to Step 1: all nodes are marked completed
                  currentIndex = activities.length;
                } else {
                  for (int i = 0; i < activities.length; i++) {
                    if (!completedIds.contains(activities[i].id)) {
                      currentIndex = i;
                      break;
                    }
                  }
                }

                return Column(
                  children: [
                    const SizedBox(height: 68),

                    // World Illustrated Banner with Pip Character Guide
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(230),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: worldTheme.accentColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: worldTheme.accentColor.withAlpha(40),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          PipCharacterGuide(
                            state: isWorldCompleted ? PipState.celebrating : PipState.speaking,
                            characterSize: 58,
                            showSpeechBubble: false,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(world.title, style: AppTypography.headlineMedium.copyWith(color: AppColors.earthDark)),
                                Text(
                                  world.description,
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isWorldCompleted ? const Color(0xFFE8F5E9) : AppColors.sunLight,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: isWorldCompleted ? const Color(0xFF4CAF50) : AppColors.sunYellow,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              '$completedInThisWorld/$totalInThisWorld ⭐',
                              style: AppTypography.labelLarge.copyWith(
                                color: isWorldCompleted ? const Color(0xFF2E7D32) : AppColors.sunDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // World Completed Celebration Banner
                    if (isWorldCompleted)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Text('🎉', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'World Completed! Excellent work! 🌟',
                                style: AppTypography.bodySmall.copyWith(
                                  color: const Color(0xFF2E7D32),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => context.push(RouteNames.trackMap),
                              icon: const Icon(Icons.map_rounded, size: 18, color: Color(0xFF2E7D32)),
                              label: const Text(
                                'Track Map',
                                style: TextStyle(
                                  color: Color(0xFF2E7D32),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Illustrated Winding Trail Map
                    Expanded(
                      child: RepaintBoundary(
                        child: AdventureTrailMap(
                          lessons: activities.cast(),
                          currentLessonIndex: currentIndex,
                          onLessonTap: (lesson) => _navigateToActivity(context, lesson.id),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToActivity(BuildContext context, String activityId) {
    if (activityId.startsWith('t1_') ||
        activityId.startsWith('t2_') ||
        activityId.startsWith('t3_') ||
        activityId.startsWith('t4_') ||
        activityId.startsWith('t5_') ||
        activityId.endsWith('_vocab') ||
        activityId == 'activity_animal_vocab' ||
        activityId == 'activity_animal_hunt' ||
        activityId == 'activity_listen_tap') {
      context.push(RouteNames.interactiveSessionPath(activityId));
      return;
    }

    switch (activityId) {
      case 'activity_animal_vocab':
        context.push(RouteNames.interactiveSessionPath(activityId));
        break;
      case 'activity_animal_hunt':
        context.push(RouteNames.interactiveSessionPath(activityId));
        break;
      case 'activity_listen_tap':
        context.push(RouteNames.interactiveSessionPath(activityId));
        break;
      case 'activity_word_match':
        context.push(RouteNames.wordMatch);
        break;
      case 'activity_grammar_this_is':
        context.push(RouteNames.grammarThisIs);
        break;
      case 'activity_grammar_is_are':
        context.push(RouteNames.isAreQuiz);
        break;
      case 'activity_value_moment':
        context.push(RouteNames.valueMoment);
        break;
      case 'activity_story_read':
        context.push(RouteNames.storyPath('story_animal_park'));
        break;
      case 'activity_listen_speak':
        context.push(RouteNames.listeningPractice);
        break;
      case 'activity_final_challenge':
        context.push(RouteNames.worldChallenge);
        break;

      // World 2: Home & Family Activities
      case 'activity_home_vocab':
        context.push(RouteNames.homeVocabulary);
        break;
      case 'activity_home_hunt':
        context.push(RouteNames.homeHunt);
        break;
      case 'activity_family_vocab':
        context.push(RouteNames.familyVocabulary);
        break;
      case 'activity_listen_find_home':
        context.push(RouteNames.listenAndFindHome);
        break;
      case 'activity_grammar_my_your':
        context.push(RouteNames.myYourGrammar);
        break;
      case 'activity_sentence_builder_home':
        context.push(RouteNames.sentenceBuilder);
        break;
      case 'activity_cleanliness_sort':
        context.push(RouteNames.cleanlinessSort);
        break;
      case 'activity_story_home':
        context.push(RouteNames.storyPath('story_helping_home'));
        break;
      case 'activity_speaking_home':
        context.push(RouteNames.speakingPractice);
        break;
      case 'activity_home_challenge':
        context.push(RouteNames.homeChallenge);
        break;

      // World 3: School & Classroom Activities
      case 'activity_school_vocab':
        context.push(RouteNames.schoolVocabulary);
        break;
      case 'activity_classroom_hunt':
        context.push(RouteNames.classroomHunt);
        break;
      case 'activity_listen_find_school':
        context.push(RouteNames.listenAndFindSchool);
        break;
      case 'activity_listen_and_do_school':
        context.push(RouteNames.listenAndDoSchool);
        break;
      case 'activity_teacher_friend_vocab':
        context.push(RouteNames.teacherFriendVocabulary);
        break;
      case 'activity_school_actions':
        context.push(RouteNames.schoolActions);
        break;
      case 'activity_grammar_plurals':
        context.push(RouteNames.pluralsGrammar);
        break;
      case 'activity_polite_requests':
        context.push(RouteNames.politeRequests);
        break;
      case 'activity_honesty_challenge':
        context.push(RouteNames.honestyChallenge);
        break;
      case 'activity_story_school':
        context.push(RouteNames.storyPath('story_honest_pencil'));
        break;
      case 'activity_story_quiz_school':
        context.push(RouteNames.storyQuizSchool);
        break;
      case 'activity_speaking_school':
        context.push(RouteNames.speakingPractice);
        break;
      case 'activity_school_challenge':
        context.push(RouteNames.schoolChallenge);
        break;

      // World 4: Delicious Food Activities
      case 'activity_food_vocab':
        context.push(RouteNames.foodVocabulary);
        break;
      case 'activity_food_hunt':
        context.push(RouteNames.foodHunt);
        break;
      case 'activity_listen_find_food':
        context.push(RouteNames.listenAndFindFood);
        break;
      case 'activity_food_match':
        context.push(RouteNames.foodMatch);
        break;
      case 'activity_grammar_i_have_food':
        context.push(RouteNames.grammarIHaveFood);
        break;
      case 'activity_food_count':
        context.push(RouteNames.foodCount);
        break;
      case 'activity_hungry_thirsty':
        context.push(RouteNames.hungryThirsty);
        break;
      case 'activity_eating_manners':
        context.push(RouteNames.eatingManners);
        break;
      case 'activity_food_sharing':
        context.push(RouteNames.foodSharing);
        break;
      case 'activity_story_food':
      case 'activity_story_food_quiz':
        context.push(RouteNames.storyPath('story_picnic_sharing'));
        break;
      case 'activity_food_challenge':
        context.push(RouteNames.foodChallenge);
        break;

      // World 5: Nature & Weather Activities
      case 'activity_nature_vocab':
        context.push(RouteNames.natureVocabulary);
        break;
      case 'activity_nature_hunt':
        context.push(RouteNames.natureHunt);
        break;
      case 'activity_weather_listen':
        context.push(RouteNames.weatherListen);
        break;
      case 'activity_nature_match':
        context.push(RouteNames.natureMatch);
        break;
      case 'activity_sunny_rainy':
        context.push(RouteNames.sunnyRainy);
        break;
      case 'activity_there_is_are':
        context.push(RouteNames.thereIsAre);
        break;
      case 'activity_weather_conversation':
        context.push(RouteNames.weatherConversation);
        break;
      case 'activity_care_for_nature':
        context.push(RouteNames.careForNature);
        break;
      case 'activity_story_nature':
      case 'activity_story_nature_quiz':
        context.push(RouteNames.storyPath('story_rainy_adventure'));
        break;
      case 'activity_speaking_nature':
        context.push(RouteNames.speakingNature);
        break;
      case 'activity_nature_challenge':
        context.push(RouteNames.natureChallenge);
        break;

      default:
        context.push(RouteNames.vocabularyDiscovery);
    }
  }
}
