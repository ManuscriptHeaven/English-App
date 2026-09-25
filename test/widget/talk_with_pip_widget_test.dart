import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_mode.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_tutor_service.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_usage_manager.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/mock_ai_provider.dart';
import 'package:kids_english_adventure/features/ai_tutor/presentation/providers/ai_tutor_providers.dart';
import 'package:kids_english_adventure/features/ai_tutor/presentation/screens/talk_with_pip_screen.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';

void main() {
  late ProviderContainer container;
  final child = ChildProfile(
    id: 'child_ayaan',
    parentId: 'parent_1',
    name: 'Ayaan',
    age: 6,
    avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
  );

  final context = AiCurriculumContext.forChild(
    childAge: 6,
    currentWorldId: 'world_food',
    currentLessonId: 'activity_food_vocab',
    mode: AiMode.vocabularyTalk,
    targetSkill: SkillType.vocabulary,
    targetVocabulary: const ['apple', 'banana'],
    conversationObjective: 'Learn food words',
  );

  setUp(() {
    container = ProviderContainer(
      overrides: [
        aiTutorServiceProvider.overrideWithValue(
          AiTutorService(
            provider: const MockAiProvider(simulateLatency: false),
            usageManager: AiUsageManager(),
          ),
        ),
      ],
    );
    container.read(activeChildProfileProvider.notifier).selectChild(child);
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('TalkWithPipScreen renders Pip avatar, mode badge, dialogue bubble, and mic button', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: TalkWithPipScreen(
            context: context,
            initialPrompt: "Hello! I am Pip! Let's talk about food!",
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Talk with Pip'), findsOneWidget);
    expect(find.textContaining(AiMode.vocabularyTalk.displayName), findsOneWidget);
    expect(find.text("Hello! I am Pip! Let's talk about food!"), findsOneWidget);
    expect(find.text('Hear Pip 🔊'), findsOneWidget);
  });
}
