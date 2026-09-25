import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/widgets/app_button.dart';
import 'package:kids_english_adventure/core/widgets/app_card.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/adventure_brain/presentation/providers/adventure_brain_providers.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/settings/presentation/providers/settings_providers.dart';

class InstructionTask {
  final String prompt;
  final String targetItemId;
  final String targetItemName;
  final String targetItemEmoji;
  final List<ClassroomItemOption> options;

  const InstructionTask({
    required this.prompt,
    required this.targetItemId,
    required this.targetItemName,
    required this.targetItemEmoji,
    required this.options,
  });
}

class ClassroomItemOption {
  final String id;
  final String name;
  final String emoji;

  const ClassroomItemOption({
    required this.id,
    required this.name,
    required this.emoji,
  });
}

/// "Listen & Do" interactive auditory instruction game for World 3.
class ListenAndDoSchoolScreen extends ConsumerStatefulWidget {
  const ListenAndDoSchoolScreen({super.key});

  @override
  ConsumerState<ListenAndDoSchoolScreen> createState() => _ListenAndDoSchoolScreenState();
}

class _ListenAndDoSchoolScreenState extends ConsumerState<ListenAndDoSchoolScreen> {
  int _currentIndex = 0;
  bool? _isCorrect;
  bool _isCompleted = false;

  final List<InstructionTask> _tasks = const [
    InstructionTask(
      prompt: 'Touch the book! 📖',
      targetItemId: 'item_book',
      targetItemName: 'Book',
      targetItemEmoji: '📖',
      options: [
        ClassroomItemOption(id: 'item_pencil', name: 'Pencil', emoji: '✏️'),
        ClassroomItemOption(id: 'item_book', name: 'Book', emoji: '📖'),
        ClassroomItemOption(id: 'item_desk', name: 'Desk', emoji: '🪑'),
      ],
    ),
    InstructionTask(
      prompt: 'Find the pencil! ✏️',
      targetItemId: 'item_pencil',
      targetItemName: 'Pencil',
      targetItemEmoji: '✏️',
      options: [
        ClassroomItemOption(id: 'item_pencil', name: 'Pencil', emoji: '✏️'),
        ClassroomItemOption(id: 'item_bag', name: 'Bag', emoji: '🎒'),
        ClassroomItemOption(id: 'item_board', name: 'Board', emoji: '📋'),
      ],
    ),
    InstructionTask(
      prompt: 'Tap the desk! 🪑',
      targetItemId: 'item_desk',
      targetItemName: 'Desk',
      targetItemEmoji: '🪑',
      options: [
        ClassroomItemOption(id: 'item_eraser', name: 'Eraser', emoji: '🧼'),
        ClassroomItemOption(id: 'item_desk', name: 'Desk', emoji: '🪑'),
        ClassroomItemOption(id: 'item_book', name: 'Book', emoji: '📖'),
      ],
    ),
    InstructionTask(
      prompt: 'Point to the board! 📋',
      targetItemId: 'item_board',
      targetItemName: 'Board',
      targetItemEmoji: '📋',
      options: [
        ClassroomItemOption(id: 'item_board', name: 'Board', emoji: '📋'),
        ClassroomItemOption(id: 'item_bag', name: 'Bag', emoji: '🎒'),
        ClassroomItemOption(id: 'item_pencil', name: 'Pencil', emoji: '✏️'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playCurrentPrompt();
    });
  }

  void _playCurrentPrompt() {
    final task = _tasks[_currentIndex];
    ref.read(audioServiceProvider).playDialogue('Pip', task.prompt);
  }

  void _selectOption(ClassroomItemOption option) {
    if (_isCorrect == true) return;

    final task = _tasks[_currentIndex];
    final isMatch = option.id == task.targetItemId;

    setState(() {
      _isCorrect = isMatch;
    });

    final activeChild = ref.read(activeChildProfileProvider);
    if (activeChild != null) {
      ref.read(learningSignalRepositoryProvider).recordSignal(
            LearningSignal(
              id: 'sig_listen_do_${DateTime.now().microsecondsSinceEpoch}',
              childId: activeChild.id,
              skill: SkillType.listening,
              contentId: 'school_listen_do_${task.targetItemId}',
              activityId: 'activity_listen_and_do_school',
              worldId: 'world_school',
              score: isMatch ? 1.0 : 0.4,
              attempts: 1,
              responseTimeMs: 1400,
              timestamp: DateTime.now(),
              mistakeType: isMatch ? MistakeType.none : MistakeType.audioMiscomprehension,
            ),
          );
    }

    if (isMatch) {
      ref.read(audioServiceProvider).playSuccess();
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (!mounted) return;
        if (_currentIndex + 1 < _tasks.length) {
          setState(() {
            _currentIndex++;
            _isCorrect = null;
          });
          _playCurrentPrompt();
        } else {
          setState(() {
            _isCompleted = true;
          });
          ref.read(audioServiceProvider).playReward();
        }
      });
    } else {
      ref.read(audioServiceProvider).playRetry();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Listen & Do Champion! 🌟'),
          backgroundColor: AppColors.primary,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppCard(
              borderColor: AppColors.correctGreen,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎧🎉', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text('Amazing Listening!', style: AppTypography.displayMedium),
                  const SizedBox(height: 8),
                  Text(
                    'You followed all the classroom instructions like a true school star!',
                    style: AppTypography.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text('⭐ +3 Stars   🔥 +30 XP   🪙 +15 Coins',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryDark)),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Continue Adventure 🚀',
                    onPressed: () {
                      ref.read(activeChildProfileProvider.notifier).completeActivity(
                            'activity_listen_and_do_school',
                            xp: 30,
                            coins: 15,
                            stars: 3,
                          );
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final task = _tasks[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Listen & Do 🎧'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _tasks.length,
              backgroundColor: AppColors.cardBorder,
              color: AppColors.primary,
              minHeight: 8,
              borderRadius: AppRadius.roundedSm,
            ),
            const SizedBox(height: 20),

            // Prompt Card
            AppCard(
              backgroundColor: AppColors.primaryLight,
              borderColor: AppColors.primary,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(task.prompt, style: AppTypography.headlineLarge),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryDark, size: 30),
                        onPressed: _playCurrentPrompt,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Listen carefully and tap the right item!',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Options Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: task.options.map((option) {
                  return GestureDetector(
                    onTap: () => _selectOption(option),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.roundedLg,
                        border: Border.all(
                          color: AppColors.primary.withAlpha(120),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(option.emoji, style: const TextStyle(fontSize: 56)),
                          const SizedBox(height: 10),
                          Text(option.name, style: AppTypography.headlineMedium),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            if (_isCorrect == false)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text('Good try! Listen again 🎧',
                    style: AppTypography.titleLarge.copyWith(color: AppColors.tryAgainOrange)),
              ),
          ],
        ),
      ),
    );
  }
}
