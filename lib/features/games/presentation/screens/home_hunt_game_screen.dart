import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/child_table_visual.dart';
import '../../../../core/widgets/guide_character.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

class HomeHuntGameScreen extends ConsumerStatefulWidget {
  const HomeHuntGameScreen({super.key});

  @override
  ConsumerState<HomeHuntGameScreen> createState() => _HomeHuntGameScreenState();
}

class _HomeHuntGameScreenState extends ConsumerState<HomeHuntGameScreen> {
  int _currentRound = 0;
  String? _selectedCard;
  bool? _isCorrect;

  final List<Map<String, dynamic>> _rounds = [
    {
      'targetWord': 'Bed',
      'prompt': 'Find the Bed! 🛏️',
      'options': [
        {'word': 'Chair', 'emoji': '🪑'},
        {'word': 'Bed', 'emoji': '🛏️'},
        {'word': 'Book', 'emoji': '📚'},
      ],
      'clue': 'Look for where you sleep cozy at night!',
    },
    {
      'targetWord': 'Chair',
      'prompt': 'Find the Chair! 🪑',
      'options': [
        {'word': 'Chair', 'emoji': '🪑'},
        {'word': 'Table', 'emoji': ''},
        {'word': 'Door', 'emoji': '🚪'},
      ],
      'clue': 'Look for what you sit on comfortably!',
    },
    {
      'targetWord': 'Book',
      'prompt': 'Find the Book! 📚',
      'options': [
        {'word': 'Table', 'emoji': ''},
        {'word': 'Bed', 'emoji': '🛏️'},
        {'word': 'Book', 'emoji': '📚'},
      ],
      'clue': 'Look for the colorful story with pages!',
    },
    {
      'targetWord': 'Table',
      'prompt': 'Find the Table! ✨',
      'options': [
        {'word': 'Door', 'emoji': '🚪'},
        {'word': 'Table', 'emoji': ''},
        {'word': 'Chair', 'emoji': '🪑'},
      ],
      'clue': 'Look for where we set delicious food and say Bismillah!',
    },
  ];

  void _onCardTap(String word) {
    if (_selectedCard != null && _isCorrect == true) return;

    final round = _rounds[_currentRound];
    final isRight = (word == round['targetWord']);

    setState(() {
      _selectedCard = word;
      _isCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSuccess();
      } else {
        ref.read(audioServiceProvider).playRetry();
      }
    });
  }

  void _onNextRound() {
    if (_currentRound + 1 < _rounds.length) {
      setState(() {
        _currentRound++;
        _selectedCard = null;
        _isCorrect = null;
      });
    } else {
      // Completed game!
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_home_hunt',
            nextActivityId: 'activity_family_vocab',
            xp: 25,
            coins: 15,
            stars: 3,
          );
      ref.read(audioServiceProvider).playReward();
      _showVictoryDialog();
    }
  }

  void _showVictoryDialog() {
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
              const Icon(Icons.celebration_rounded, size: 72, color: AppColors.worldHomeOrange),
              const SizedBox(height: 12),
              Text('Home Hunter Champion! 🏡🏆', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'Super job finding all household items!\nNext up: Family Words Discovery!',
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
                text: 'Learn Family Words 👨‍👩‍👧‍👦 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.familyVocabulary);
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
    final round = _rounds[_currentRound];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Home Hunt (${_currentRound + 1}/${_rounds.length})',
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
              message: _isCorrect == false
                  ? 'Good try! ${round['clue']}'
                  : 'Can you spot which card has the ${round['targetWord']}?',
              onSpeakTap: () {
                ref.read(audioServiceProvider).playGamePrompt(round['prompt'] as String);
              },
            ),
            const SizedBox(height: 16),

            AppCard(
              borderColor: AppColors.worldHomeOrange,
              child: Text(
                round['prompt'] as String,
                style: AppTypography.displayMedium.copyWith(color: AppColors.worldHomeOrange),
                textAlign: TextAlign.center,
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
              itemCount: (round['options'] as List).length,
              itemBuilder: (context, idx) {
                final opt = round['options'][idx];
                final isSelected = _selectedCard == opt['word'];

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
                  onTap: () => _onCardTap(opt['word'] as String),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      opt['word'] == 'Table'
                          ? const ChildTableVisual(width: 58, height: 42)
                          : Text(opt['emoji'] as String, style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 6),
                      Text(
                        opt['word'] as String,
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
                text: 'Awesome! Next Round ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.correctGreen,
                foregroundColor: Colors.white,
                onPressed: _onNextRound,
              ),
          ],
        ),
      ),
    );
  }
}
