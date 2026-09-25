import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/guide_character.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';

class WordMatchGameScreen extends ConsumerStatefulWidget {
  const WordMatchGameScreen({super.key});

  @override
  ConsumerState<WordMatchGameScreen> createState() => _WordMatchGameScreenState();
}

class _WordMatchGameScreenState extends ConsumerState<WordMatchGameScreen> {
  final List<Map<String, dynamic>> _pairs = [
    {'id': 'elephant', 'word': 'Elephant', 'emoji': '🐘'},
    {'id': 'lion', 'word': 'Lion', 'emoji': '🦁'},
    {'id': 'cat', 'word': 'Cat', 'emoji': '🐱'},
    {'id': 'bird', 'word': 'Bird', 'emoji': '🐦'},
  ];

  String? _selectedPictureId;
  String? _selectedWordId;
  final Set<String> _matchedIds = {};

  void _onPictureTap(String id) {
    if (_matchedIds.contains(id)) return;
    setState(() {
      _selectedPictureId = id;
      _checkMatch();
    });
  }

  void _onWordTap(String id) {
    if (_matchedIds.contains(id)) return;
    setState(() {
      _selectedWordId = id;
      _checkMatch();
    });
  }

  void _checkMatch() {
    if (_selectedPictureId != null && _selectedWordId != null) {
      if (_selectedPictureId == _selectedWordId) {
        // Matched pair!
        final matchedWord = _pairs.firstWhere((p) => p['id'] == _selectedPictureId)['word'];
        _matchedIds.add(_selectedPictureId!);
        _selectedPictureId = null;
        _selectedWordId = null;
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.correct);
        ref.read(audioServiceProvider).playWordPronunciation(matchedWord as String);

        if (_matchedIds.length == _pairs.length) {
          // All matched!
          ref.read(activeChildProfileProvider.notifier).completeActivity(
                'activity_word_match',
                nextActivityId: 'activity_grammar_this_is',
                xp: 25,
                coins: 15,
                stars: 3,
              );
          ref.read(audioServiceProvider).playSoundEffect(SoundEffect.levelComplete);
          Future.delayed(const Duration(milliseconds: 600), _showVictoryDialog);
        }
      } else {
        // Mismatched
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.tryAgain);
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _selectedPictureId = null;
              _selectedWordId = null;
            });
          }
        });
      }
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
              const Icon(Icons.style_rounded, size: 72, color: AppColors.secondary),
              const SizedBox(height: 12),
              Text('Card Matcher Star! 🃏🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You matched all the animals with their words!\nNext up: Sentence Builder!',
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
                text: 'Learn "This is..." ✍️ ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.grammarThisIs);
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Word Match (${_matchedIds.length}/${_pairs.length})',
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
              message: 'Tap an animal picture on the left, then tap its name on the right!',
            ),
            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pictures Column
                Expanded(
                  child: Column(
                    children: _pairs.map((item) {
                      final id = item['id'] as String;
                      final isMatched = _matchedIds.contains(id);
                      final isSelected = _selectedPictureId == id;

                      Color bg = Colors.white;
                      Color border = AppColors.cardBorder;

                      if (isMatched) {
                        bg = AppColors.correctGreen.withValues(alpha: 0.2);
                        border = AppColors.correctGreen;
                      } else if (isSelected) {
                        bg = AppColors.primaryLight;
                        border = AppColors.primary;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: AppCard(
                          backgroundColor: bg,
                          borderColor: border,
                          onTap: isMatched ? null : () => _onPictureTap(id),
                          child: Center(
                            child: isMatched
                                ? const Icon(Icons.check_circle_rounded, color: AppColors.correctGreen, size: 40)
                                : Text(item['emoji'] as String, style: const TextStyle(fontSize: 44)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),

                // Words Column (shuffled layout)
                Expanded(
                  child: Column(
                    children: [
                      _pairs[2], // Cat
                      _pairs[0], // Elephant
                      _pairs[3], // Bird
                      _pairs[1], // Lion
                    ].map((item) {
                      final id = item['id'] as String;
                      final isMatched = _matchedIds.contains(id);
                      final isSelected = _selectedWordId == id;

                      Color bg = Colors.white;
                      Color border = AppColors.cardBorder;

                      if (isMatched) {
                        bg = AppColors.correctGreen.withValues(alpha: 0.2);
                        border = AppColors.correctGreen;
                      } else if (isSelected) {
                        bg = AppColors.primaryLight;
                        border = AppColors.primary;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: AppCard(
                          backgroundColor: bg,
                          borderColor: border,
                          onTap: isMatched ? null : () => _onWordTap(id),
                          child: Center(
                            child: isMatched
                                ? Text(
                                    item['word'] as String,
                                    style: AppTypography.titleLarge.copyWith(
                                      color: AppColors.correctGreen,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  )
                                : Text(
                                    item['word'] as String,
                                    style: AppTypography.headlineMedium,
                                  ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
