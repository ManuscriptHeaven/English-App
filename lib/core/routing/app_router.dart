import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/routing/route_names.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/screens/child_selection_screen.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/screens/create_child_screen.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_mode.dart';
import 'package:kids_english_adventure/features/ai_tutor/presentation/screens/talk_with_pip_screen.dart';
import 'package:kids_english_adventure/features/content_engine/presentation/screens/generic_activity_screen.dart';
import 'package:kids_english_adventure/features/content_studio/presentation/screens/content_preview_screen.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/conversation.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/conversation_option.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/conversation_turn.dart';
import 'package:kids_english_adventure/features/conversation/presentation/screens/conversation_screen.dart';
import 'package:kids_english_adventure/features/curriculum/presentation/screens/curriculum_browser_screen.dart';
import 'package:kids_english_adventure/features/diagnostics/presentation/screens/voice_diagnostics_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/animal_hunt_game_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/classroom_hunt_game_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/cleanliness_sort_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/home_hunt_game_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/honesty_challenge_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/is_are_quiz_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/listen_and_find_home_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/listen_and_do_school_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/listen_and_find_school_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/listen_and_tap_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/core/experience/interactive_session_composer.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/interactive_activity_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/interactive_session_screen.dart';
import 'package:kids_english_adventure/features/worlds/presentation/providers/world_providers.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/sentence_builder_game_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/word_match_game_screen.dart';
import 'package:kids_english_adventure/features/grammar/presentation/screens/grammar_lesson_screen.dart';
import 'package:kids_english_adventure/features/grammar/presentation/screens/my_your_grammar_screen.dart';
import 'package:kids_english_adventure/features/grammar/presentation/screens/plurals_grammar_screen.dart';
import 'package:kids_english_adventure/features/home/presentation/screens/adventure_home_screen.dart';
import 'package:kids_english_adventure/features/learning/presentation/screens/listening_practice_screen.dart';
import 'package:kids_english_adventure/features/learning/presentation/screens/polite_requests_dialogue_screen.dart';
import 'package:kids_english_adventure/features/learning/presentation/screens/speaking_practice_screen.dart';
import 'package:kids_english_adventure/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:kids_english_adventure/features/parent/presentation/screens/parent_account_settings_screen.dart';
import 'package:kids_english_adventure/features/parent/presentation/screens/parent_dashboard_screen.dart';
import 'package:kids_english_adventure/features/parent/presentation/screens/parent_learning_reports_screen.dart';
import 'package:kids_english_adventure/features/rewards/presentation/screens/adaptive_review_screen.dart';
import 'package:kids_english_adventure/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:kids_english_adventure/features/settings/presentation/screens/settings_screen.dart';
import 'package:kids_english_adventure/features/stories/presentation/screens/story_quiz_school_screen.dart';
import 'package:kids_english_adventure/features/stories/presentation/screens/story_reader_screen.dart';
import 'package:kids_english_adventure/features/values/presentation/screens/value_moment_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/family_vocabulary_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/home_vocabulary_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/school_actions_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/school_vocabulary_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/teacher_friend_vocabulary_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/vocabulary_discovery_screen.dart';
import 'package:kids_english_adventure/features/worlds/presentation/screens/home_challenge_screen.dart';
import 'package:kids_english_adventure/features/worlds/presentation/screens/school_challenge_screen.dart';
import 'package:kids_english_adventure/features/worlds/presentation/screens/world_challenge_screen.dart';
import 'package:kids_english_adventure/features/worlds/presentation/screens/world_detail_screen.dart';

/// Top-level GoRouter instance configured for kids app navigation.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.welcome,
    routes: [
      GoRoute(
        path: RouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.childSelection,
        builder: (context, state) => const ChildSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.createChild,
        builder: (context, state) => const CreateChildScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const AdventureHomeScreen(),
      ),
      GoRoute(
        path: RouteNames.worldDetail,
        builder: (context, state) {
          final worldId = state.pathParameters['id'] ?? 'world_animal';
          return WorldDetailScreen(worldId: worldId);
        },
      ),
      GoRoute(
        path: RouteNames.story,
        builder: (context, state) {
          final storyId = state.pathParameters['id'] ?? 'story_animal_park';
          return StoryReaderScreen(storyId: storyId);
        },
      ),
      GoRoute(
        path: RouteNames.rewards,
        builder: (context, state) => const RewardsScreen(),
      ),
      GoRoute(
        path: RouteNames.parent,
        builder: (context, state) => const ParentDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.parentReports,
        builder: (context, state) => const ParentLearningReportsScreen(),
      ),
      GoRoute(
        path: RouteNames.parentAccount,
        builder: (context, state) => const ParentAccountSettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Generic Activity Route powered by Content Engine
      GoRoute(
        path: RouteNames.genericActivity,
        builder: (context, state) {
          final contentId = state.pathParameters['id'] ?? 'food_apple_01';
          return GenericActivityScreen(contentId: contentId);
        },
      ),

      // Phase 02 Interactive Activity Routes (World 1: Animal Adventure)
      GoRoute(
        path: RouteNames.vocabularyDiscovery,
        builder: (context, state) => const VocabularyDiscoveryScreen(),
      ),
      GoRoute(
        path: RouteNames.animalHunt,
        builder: (context, state) => const AnimalHuntGameScreen(),
      ),
      GoRoute(
        path: RouteNames.listenAndTap,
        builder: (context, state) => const ListenAndTapGameScreen(),
      ),
      GoRoute(
        path: RouteNames.wordMatch,
        builder: (context, state) => const WordMatchGameScreen(),
      ),
      GoRoute(
        path: RouteNames.grammarThisIs,
        builder: (context, state) => const GrammarLessonScreen(),
      ),
      GoRoute(
        path: RouteNames.sentenceBuilder,
        builder: (context, state) => const SentenceBuilderGameScreen(),
      ),
      GoRoute(
        path: RouteNames.isAreQuiz,
        builder: (context, state) => const IsAreQuizScreen(),
      ),
      GoRoute(
        path: RouteNames.valueMoment,
        builder: (context, state) => const ValueMomentScreen(),
      ),
      GoRoute(
        path: RouteNames.listeningPractice,
        builder: (context, state) => const ListeningPracticeScreen(),
      ),
      GoRoute(
        path: RouteNames.speakingPractice,
        builder: (context, state) => const SpeakingPracticeScreen(),
      ),
      GoRoute(
        path: RouteNames.worldChallenge,
        builder: (context, state) => const WorldChallengeScreen(),
      ),
      GoRoute(
        path: RouteNames.interactiveActivity,
        builder: (context, state) {
          final mechanicStr = state.uri.queryParameters['mechanic'] ?? 'listenAndTouch';
          final ageStr = state.uri.queryParameters['age'] ?? '3';
          final age = int.tryParse(ageStr) ?? 3;
          final concept = state.uri.queryParameters['concept'] ?? 'apple';

          ActivityMechanicType mechanic = ActivityMechanicType.listenAndTouch;
          for (final m in ActivityMechanicType.values) {
            if (m.name == mechanicStr) {
              mechanic = m;
              break;
            }
          }

          final config = InteractiveActivityConfig.createSample(
            conceptWord: concept,
            mechanic: mechanic,
            childAge: age,
          );
          return InteractiveActivityScreen(config: config);
        },
      ),
      GoRoute(
        path: RouteNames.interactiveSession,
        builder: (context, state) {
          final lessonId = state.pathParameters['id'] ?? 'activity_animal_vocab';
          return Consumer(
            builder: (context, ref, child) {
              final activeChild = ref.watch(activeChildProfileProvider);
              final age = activeChild?.age ?? 5;
              final profile = AgeExperienceProfile.forAge(age);
              final lessonAsync = ref.watch(lessonDetailProvider(lessonId));

              return lessonAsync.when(
                data: (lesson) {
                  final concepts = lesson?.targetVocabularyIds ?? [];
                  final title = lesson?.title;
                  final session = InteractiveSessionComposer.composeSession(
                    ageProfile: profile,
                    lessonId: lessonId,
                    title: title,
                    targetConceptWords: concepts,
                  );
                  return InteractiveSessionScreen(session: session);
                },
                loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) {
                  final session = InteractiveSessionComposer.composeSession(
                    ageProfile: profile,
                    lessonId: lessonId,
                  );
                  return InteractiveSessionScreen(session: session);
                },
              );
            },
          );
        },
      ),

      // Phase 03 Interactive Activity Routes (World 2: Home & Family)
      GoRoute(
        path: RouteNames.homeVocabulary,
        builder: (context, state) => const HomeVocabularyScreen(),
      ),
      GoRoute(
        path: RouteNames.homeHunt,
        builder: (context, state) => const HomeHuntGameScreen(),
      ),
      GoRoute(
        path: RouteNames.familyVocabulary,
        builder: (context, state) => const FamilyVocabularyScreen(),
      ),
      GoRoute(
        path: RouteNames.listenAndFindHome,
        builder: (context, state) => const ListenAndFindHomeScreen(),
      ),
      GoRoute(
        path: RouteNames.myYourGrammar,
        builder: (context, state) => const MyYourGrammarScreen(),
      ),
      GoRoute(
        path: RouteNames.cleanlinessSort,
        builder: (context, state) => const CleanlinessSortScreen(),
      ),
      GoRoute(
        path: RouteNames.homeChallenge,
        builder: (context, state) => const HomeChallengeScreen(),
      ),
      GoRoute(
        path: RouteNames.adaptiveReview,
        builder: (context, state) => const AdaptiveReviewScreen(),
      ),

      // Phase 05 Interactive Activity Routes (World 3: School & Classroom)
      GoRoute(
        path: RouteNames.schoolVocabulary,
        builder: (context, state) => const SchoolVocabularyScreen(),
      ),
      GoRoute(
        path: RouteNames.classroomHunt,
        builder: (context, state) => const ClassroomHuntGameScreen(),
      ),
      GoRoute(
        path: RouteNames.listenAndFindSchool,
        builder: (context, state) => const ListenAndFindSchoolScreen(),
      ),
      GoRoute(
        path: RouteNames.listenAndDoSchool,
        builder: (context, state) => const ListenAndDoSchoolScreen(),
      ),
      GoRoute(
        path: RouteNames.teacherFriendVocabulary,
        builder: (context, state) => const TeacherFriendVocabularyScreen(),
      ),
      GoRoute(
        path: RouteNames.schoolActions,
        builder: (context, state) => const SchoolActionsScreen(),
      ),
      GoRoute(
        path: RouteNames.pluralsGrammar,
        builder: (context, state) => const PluralsGrammarScreen(),
      ),
      GoRoute(
        path: RouteNames.politeRequests,
        builder: (context, state) => const PoliteRequestsDialogueScreen(),
      ),
      GoRoute(
        path: RouteNames.honestyChallenge,
        builder: (context, state) => const HonestyChallengeScreen(),
      ),
      GoRoute(
        path: RouteNames.storyQuizSchool,
        builder: (context, state) => const StoryQuizSchoolScreen(),
      ),
      GoRoute(
        path: RouteNames.schoolChallenge,
        builder: (context, state) => const SchoolChallengeScreen(),
      ),

      // Phase 06 Interactive Activity Routes (World 4: Delicious Food & Content Engine)
      GoRoute(
        path: RouteNames.foodVocabulary,
        builder: (context, state) => const GenericActivityScreen(contentId: 'food_apple_01'),
      ),
      GoRoute(
        path: RouteNames.foodHunt,
        builder: (context, state) => const GenericActivityScreen(contentId: 'food_hunt_05'),
      ),
      GoRoute(
        path: RouteNames.listenAndFindFood,
        builder: (context, state) => const GenericActivityScreen(contentId: 'food_apple_01'),
      ),
      GoRoute(
        path: RouteNames.foodMatch,
        builder: (context, state) => const GenericActivityScreen(contentId: 'food_banana_02'),
      ),
      GoRoute(
        path: RouteNames.grammarIHaveFood,
        builder: (context, state) => const GenericActivityScreen(contentId: 'food_grammar_06'),
      ),
      GoRoute(
        path: RouteNames.foodCount,
        builder: (context, state) => const GenericActivityScreen(contentId: 'food_grammar_06'),
      ),
      GoRoute(
        path: RouteNames.hungryThirsty,
        builder: (context, state) => const GenericActivityScreen(contentId: 'food_hungry_thirsty_07'),
      ),
      GoRoute(
        path: RouteNames.eatingManners,
        builder: (context, state) => const GenericActivityScreen(contentId: 'food_manners_08'),
      ),
      GoRoute(
        path: RouteNames.foodSharing,
        builder: (context, state) => const GenericActivityScreen(contentId: 'food_sharing_09'),
      ),
      GoRoute(
        path: RouteNames.foodChallenge,
        builder: (context, state) => const GenericActivityScreen(contentId: 'food_sharing_09'),
      ),

      // Phase 08 Routes: Studio Preview, Conversations, World 5 Nature
      GoRoute(
        path: RouteNames.contentPreview,
        builder: (context, state) {
          final contentId = state.pathParameters['id'] ?? 'nature_tree_01';
          return ContentPreviewScreen(contentId: contentId);
        },
      ),
      GoRoute(
        path: RouteNames.natureVocabulary,
        builder: (context, state) => const GenericActivityScreen(contentId: 'nature_tree_01'),
      ),
      GoRoute(
        path: RouteNames.natureHunt,
        builder: (context, state) => const GenericActivityScreen(contentId: 'nature_hunt_05'),
      ),
      GoRoute(
        path: RouteNames.weatherListen,
        builder: (context, state) => const GenericActivityScreen(contentId: 'nature_rain_04'),
      ),
      GoRoute(
        path: RouteNames.natureMatch,
        builder: (context, state) => const GenericActivityScreen(contentId: 'nature_flower_02'),
      ),
      GoRoute(
        path: RouteNames.sunnyRainy,
        builder: (context, state) => const GenericActivityScreen(contentId: 'weather_sunny_rainy_06'),
      ),
      GoRoute(
        path: RouteNames.thereIsAre,
        builder: (context, state) => const GenericActivityScreen(contentId: 'grammar_there_is_are_07'),
      ),
      GoRoute(
        path: RouteNames.weatherConversation,
        builder: (context, state) => const ConversationScreen(
          conversation: Conversation(
            id: 'conv_weather_pip',
            title: 'Weather Chat with Pip 💬',
            description: 'Talk with Pip about the sunny skies and flowers in the park',
            learningObjective: 'Engage in simple weather dialogue and observations.',
            valueIds: ['value_creation_gratitude'],
            turns: [
              ConversationTurn(
                turnIndex: 0,
                speakerName: 'Pip',
                speakerEmoji: '🦜',
                promptText: 'Hello! How is the weather today?',
                expectedResponse: 'It is sunny',
                options: [
                  ConversationOption(
                    id: 'opt_w1',
                    text: 'It is sunny! ☀️',
                    isCorrect: true,
                    feedback: 'Great! The sun is shining warm and bright!',
                  ),
                  ConversationOption(
                    id: 'opt_w2',
                    text: 'My name is Pip 🦜',
                    isCorrect: false,
                    feedback: 'Pip asked about the weather! Try again.',
                  ),
                ],
              ),
              ConversationTurn(
                turnIndex: 1,
                speakerName: 'Pip',
                speakerEmoji: '🦜',
                promptText: 'Do you see flowers in the garden?',
                expectedResponse: 'Yes I see flowers',
                options: [
                  ConversationOption(
                    id: 'opt_w3',
                    text: 'Yes, I see flowers! 🌸',
                    isCorrect: true,
                    feedback: 'Wonderful! SubhanAllah, beautiful creation!',
                  ),
                  ConversationOption(
                    id: 'opt_w4',
                    text: 'I have an apple 🍎',
                    isCorrect: false,
                    feedback: 'Look at the pretty blossoms!',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.careForNature,
        builder: (context, state) => const GenericActivityScreen(contentId: 'nature_care_scenario_08'),
      ),
      GoRoute(
        path: RouteNames.speakingNature,
        builder: (context, state) => const SpeakingPracticeScreen(),
      ),
      GoRoute(
        path: RouteNames.natureChallenge,
        builder: (context, state) => const GenericActivityScreen(contentId: 'nature_care_scenario_08'),
      ),

      // Phase 09 Route: Talk With Pip (AI Tutor Practice)
      GoRoute(
        path: RouteNames.talkWithPip,
        builder: (context, state) {
          final defaultContext = AiCurriculumContext.forChild(
            childAge: 6,
            currentWorldId: 'world_nature',
            currentLessonId: 'activity_weather_conversation',
            mode: AiMode.speakingChallenge,
            targetSkill: SkillType.speaking,
            targetVocabulary: const ['sun', 'rain', 'tree', 'flower'],
            targetGrammar: 'The sun is bright',
            conversationObjective: 'Practice speaking full sentences about weather and outdoor nature.',
          );
          return TalkWithPipScreen(context: defaultContext);
        },
      ),

      // P0 Quality Recovery Route: Voice & Audio Diagnostics
      GoRoute(
        path: RouteNames.voiceDiagnostics,
        builder: (context, state) => const VoiceDiagnosticsScreen(),
      ),

      // Developer & QA Screen: Curriculum Content V2 Browser
      GoRoute(
        path: RouteNames.curriculumBrowser,
        builder: (context, state) => const CurriculumBrowserScreen(),
      ),
    ],
  );
}
