import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';

class GameShellScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GameShellScreen({super.key, required this.gameId});

  @override
  ConsumerState<GameShellScreen> createState() => _GameShellScreenState();
}

class _GameShellScreenState extends ConsumerState<GameShellScreen> {
  int _score = 0;
  final int _targetMatches = 3;
  int _currentMatches = 0;

  final List<Map<String, String>> _mockPairs = [
    {'word': 'Elephant', 'icon': '🐘'},
    {'word': 'Lion', 'icon': '🦁'},
    {'word': 'Cat', 'icon': '🐱'},
  ];

  void _tapCard(String word) {
    setState(() {
      _currentMatches++;
      _score += 20;
      ref.read(audioServiceProvider).playSoundEffect(SoundEffect.correct);
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final isDone = _currentMatches >= _targetMatches;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Word Match Arcade 🎮',
        stars: activeChild?.stars ?? 0,
        coins: activeChild?.coins ?? 0,
        streak: activeChild?.streakDays ?? 0,
        showBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Game Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RewardBadge(type: BadgeType.xp, count: _score),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: AppRadius.roundedPill,
                    border: Border.all(color: AppColors.secondaryDark),
                  ),
                  child: Text(
                    'Matched: $_currentMatches / $_targetMatches',
                    style: AppTypography.badgeText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (isDone) ...[
              const Spacer(),
              const Icon(Icons.celebration_rounded, size: 80, color: AppColors.secondary),
              const SizedBox(height: 16),
              Text('Arcade Complete! 🎉', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text('You earned 50 XP and 25 Coins!', style: AppTypography.titleLarge),
              const Spacer(),
              AppButton(
                text: 'Collect Rewards & Exit 🚀',
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  ref.read(activeChildProfileProvider.notifier).addRewards(
                        xp: 50,
                        coins: 25,
                        stars: 2,
                      );
                  context.pop();
                },
              ),
            ] else ...[
              Text(
                'Tap the animal cards to match the words!',
                style: AppTypography.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _mockPairs.length,
                  itemBuilder: (context, index) {
                    final item = _mockPairs[index];
                    return AppCard(
                      borderColor: AppColors.primary,
                      onTap: () => _tapCard(item['word']!),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item['icon']!, style: const TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(item['word']!, style: AppTypography.headlineMedium),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
