import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/routing/route_names.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/widgets/app_button.dart';
import 'package:kids_english_adventure/core/widgets/app_card.dart';
import 'package:kids_english_adventure/core/widgets/app_scaffold.dart';
import 'package:kids_english_adventure/core/widgets/child_table_visual.dart';
import 'package:kids_english_adventure/core/widgets/guide_character.dart';
import 'package:kids_english_adventure/core/widgets/reward_badge.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/settings/presentation/providers/settings_providers.dart';

class ListenAndFindSchoolScreen extends ConsumerStatefulWidget {
  const ListenAndFindSchoolScreen({super.key});

  @override
  ConsumerState<ListenAndFindSchoolScreen> createState() => _ListenAndFindSchoolScreenState();
}

class _ListenAndFindSchoolScreenState extends ConsumerState<ListenAndFindSchoolScreen> {
  int _currentStep = 0;
  String? _selectedOption;
  bool? _isCorrect;

  final List<Map<String, dynamic>> _steps = [
    {
      'audioPrompt': 'Find the pencil.',
      'target': 'Pencil',
      'options': [
        {'id': 'Book', 'label': 'Book', 'emoji': '📚'},
        {'id': 'Pencil', 'label': 'Pencil', 'emoji': '✏️'},
        {'id': 'Desk', 'label': 'Desk', 'emoji': ''},
      ],
    },
    {
      'audioPrompt': 'Find the teacher.',
      'target': 'Teacher',
      'options': [
        {'id': 'Teacher', 'label': 'Teacher', 'emoji': '👨‍🏫'},
        {'id': 'Student', 'label': 'Student', 'emoji': '🧒'},
        {'id': 'Bag', 'label': 'School Bag', 'emoji': '🎒'},
      ],
    },
    {
      'audioPrompt': 'Find the book on the desk.',
      'target': 'Book',
      'options': [
        {'id': 'Chair', 'label': 'Chair', 'emoji': '🪑'},
        {'id': 'Book', 'label': 'Book', 'emoji': '📚'},
        {'id': 'Door', 'label': 'Door', 'emoji': '🚪'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _playCurrentAudio());
  }

  void _playCurrentAudio() {
    final step = _steps[_currentStep];
    ref.read(audioServiceProvider).playGamePrompt(step['audioPrompt'] as String);
  }

  void _onOptionTap(String id) {
    if (_selectedOption != null && _isCorrect == true) return;

    final step = _steps[_currentStep];
    final isRight = (id == step['target']);

    setState(() {
      _selectedOption = id;
      _isCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSuccess();
      } else {
        ref.read(audioServiceProvider).playRetry();
      }
    });
  }

  void _onNext() {
    if (_currentStep + 1 < _steps.length) {
      setState(() {
        _currentStep++;
        _selectedOption = null;
        _isCorrect = null;
      });
      _playCurrentAudio();
    } else {
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_listen_find_school',
            nextActivityId: 'activity_teacher_friend_vocab',
            xp: 25,
            coins: 15,
            stars: 3,
          );
      ref.read(audioServiceProvider).playReward();
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedXl),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.headphones_rounded, size: 72, color: AppColors.primary),
              const SizedBox(height: 12),
              Text('Sharp School Ears! 🎧🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You listened and found every school object!\nNext up: Teacher & Friend Words!',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RewardBadge(type: BadgeType.xp, count: 25),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.coin, count: 15),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.star, count: 3),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Learn Teacher & Friend Words ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.teacherFriendVocabulary);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final step = _steps[_currentStep];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Listen & Find (${_currentStep + 1}/${_steps.length})',
        stars: activeChild?.stars ?? 0,
        coins: activeChild?.coins ?? 0,
        streak: activeChild?.streakDays ?? 0,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GuideCharacterBanner(
              message: 'Listen carefully with Pip and tap the right picture!',
              onSpeakTap: _playCurrentAudio,
            ),
            const SizedBox(height: 16),

            AppCard(
              borderColor: AppColors.primary,
              child: Column(
                children: [
                  IconButton(
                    iconSize: 56,
                    icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                    onPressed: _playCurrentAudio,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '🎧 Tap button to listen again',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: (step['options'] as List).length,
              itemBuilder: (context, idx) {
                final opt = step['options'][idx];
                final isSelected = _selectedOption == opt['id'];

                Color bg = Colors.white;
                Color border = AppColors.cardBorder;

                if (isSelected) {
                  if (_isCorrect == true) {
                    bg = AppColors.correctGreen.withValues(alpha: 0.2);
                    border = AppColors.correctGreen;
                  } else {
                    bg = AppColors.tryAgainOrange.withValues(alpha: 0.2);
                    border = AppColors.tryAgainOrange;
                  }
                }

                return AppCard(
                  backgroundColor: bg,
                  borderColor: border,
                  onTap: () => _onOptionTap(opt['id'] as String),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      opt['id'] == 'Desk'
                          ? const ChildTableVisual(width: 58, height: 42)
                          : Text(opt['emoji'] as String, style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 6),
                      Text(
                        opt['label'] as String,
                        style: AppTypography.titleLarge.copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            if (_isCorrect == true)
              AppButton(
                text: 'Next Challenge ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.correctGreen,
                foregroundColor: Colors.white,
                onPressed: _onNext,
              ),
          ],
        ),
      ),
    );
  }
}
