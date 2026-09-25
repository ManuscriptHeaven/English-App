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
import 'package:kids_english_adventure/core/widgets/value_pill.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/settings/presentation/providers/settings_providers.dart';

class SchoolVocabularyScreen extends ConsumerStatefulWidget {
  const SchoolVocabularyScreen({super.key});

  @override
  ConsumerState<SchoolVocabularyScreen> createState() => _SchoolVocabularyScreenState();
}

class _SchoolVocabularyScreenState extends ConsumerState<SchoolVocabularyScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _schoolWords = [
    {
      'id': 'vocab_school',
      'word': 'School',
      'phonetic': '/skuːl/',
      'emoji': '🏫',
      'sentence': 'This is my school. It is a wonderful place to learn.',
      'colorHex': 0xFF42A5F5,
      'valueTip': 'Seeking knowledge is a noble duty for every Muslim.',
    },
    {
      'id': 'vocab_classroom',
      'word': 'Classroom',
      'phonetic': '/ˈklɑːs.ruːm/',
      'emoji': '🎒',
      'sentence': 'This is our bright and cheerful classroom.',
      'colorHex': 0xFF66BB6A,
      'valueTip': 'Keep your classroom clean and respect your learning space.',
    },
    {
      'id': 'vocab_pencil',
      'word': 'Pencil',
      'phonetic': '/ˈpen.səl/',
      'emoji': '✏️',
      'sentence': 'I have a yellow pencil to write notes.',
      'colorHex': 0xFFFFA726,
      'valueTip': 'Care for your learning tools and return lost items promptly.',
    },
    {
      'id': 'vocab_desk',
      'word': 'Desk',
      'phonetic': '/desk/',
      'emoji': '',
      'sentence': 'I sit at my wooden desk and listen carefully.',
      'colorHex': 0xFF7E57C2,
      'valueTip': 'Keep your desk organized and sit with good posture.',
    },
    {
      'id': 'vocab_bag',
      'word': 'School Bag',
      'phonetic': '/skuːl bæɡ/',
      'emoji': '🎒',
      'sentence': 'I pack my books inside my blue school bag.',
      'colorHex': 0xFFEF5350,
      'valueTip': 'Taking responsibility for your belongings brings ease.',
    },
    {
      'id': 'vocab_friend',
      'word': 'Friend',
      'phonetic': '/frend/',
      'emoji': '🤝',
      'sentence': 'Tariq is my kind classmate and friend.',
      'colorHex': 0xFF00897B,
      'valueTip': 'Smiling and speaking gently to friends is charity (Sadaqah).',
    },
  ];

  void _speakCurrentWord() {
    final item = _schoolWords[_currentIndex];
    final text = '${item['word']}. ${item['sentence']}';
    ref.read(audioServiceProvider).playWord(text);
  }

  void _onNext() {
    if (_currentIndex + 1 < _schoolWords.length) {
      setState(() => _currentIndex++);
      _speakCurrentWord();
    } else {
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_school_vocab',
            nextActivityId: 'activity_classroom_hunt',
            xp: 20,
            coins: 10,
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
              const Icon(Icons.school_rounded, size: 72, color: AppColors.primary),
              const SizedBox(height: 12),
              Text('School Explorer! 🏫🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You learned all classroom and school words!\nNext up: Classroom Hunt Game!',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RewardBadge(type: BadgeType.xp, count: 20),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.coin, count: 10),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.star, count: 3),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Play Classroom Hunt 🔍 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.classroomHunt);
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
    final item = _schoolWords[_currentIndex];
    final color = Color(item['colorHex'] as int);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'School Words (${_currentIndex + 1}/${_schoolWords.length})',
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
              message: 'Welcome to the Classroom! Tap to hear "${item['word']}"!',
              onSpeakTap: _speakCurrentWord,
            ),
            const SizedBox(height: 16),

            AppCard(
              borderColor: color,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _speakCurrentWord,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 3),
                      ),
                      alignment: Alignment.center,
                      child: item['id'] == 'vocab_desk'
                          ? const ChildTableVisual(width: 80, height: 60)
                          : Text(item['emoji'] as String, style: const TextStyle(fontSize: 72)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item['word'] as String, style: AppTypography.displayLarge.copyWith(color: color)),
                      const SizedBox(width: 12),
                      IconButton(
                        iconSize: 36,
                        icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                        onPressed: _speakCurrentWord,
                      ),
                    ],
                  ),
                  Text(
                    item['phonetic'] as String,
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: AppRadius.roundedLg,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '🗣️ "${item['sentence']}"',
                      style: AppTypography.titleLarge.copyWith(color: AppColors.primaryDark),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ValueBanner(
                    title: 'School Value',
                    description: item['valueTip'] as String,
                    arabicPhrase: 'Seeking Knowledge',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                if (_currentIndex > 0)
                  Expanded(
                    child: AppButton(
                      text: '◀ Back',
                      height: 54,
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.textPrimary,
                      onPressed: () {
                        setState(() => _currentIndex--);
                        _speakCurrentWord();
                      },
                    ),
                  )
                else
                  const Spacer(),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: AppButton(
                    text: _currentIndex + 1 < _schoolWords.length ? 'Next Word ▶' : 'Play Classroom Hunt! 🚀',
                    height: 54,
                    backgroundColor: AppColors.secondary,
                    onPressed: _onNext,
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
