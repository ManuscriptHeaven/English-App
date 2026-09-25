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
import 'package:kids_english_adventure/core/widgets/guide_character.dart';
import 'package:kids_english_adventure/core/widgets/reward_badge.dart';
import 'package:kids_english_adventure/core/widgets/value_pill.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/settings/presentation/providers/settings_providers.dart';

class TeacherFriendVocabularyScreen extends ConsumerStatefulWidget {
  const TeacherFriendVocabularyScreen({super.key});

  @override
  ConsumerState<TeacherFriendVocabularyScreen> createState() => _TeacherFriendVocabularyScreenState();
}

class _TeacherFriendVocabularyScreenState extends ConsumerState<TeacherFriendVocabularyScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _socialWords = [
    {
      'id': 'vocab_teacher',
      'word': 'Teacher',
      'phonetic': '/ˈtiː.tʃər/',
      'emoji': '👨‍🏫',
      'sentence': 'Our kind teacher guides us with wisdom.',
      'colorHex': 0xFF7E57C2,
      'valueTip': 'Listen attentively and greet your teacher with Salaam.',
    },
    {
      'id': 'vocab_student',
      'word': 'Student',
      'phonetic': '/ˈstjuː.dənt/',
      'emoji': '🧒',
      'sentence': 'I am a hardworking student who loves to learn.',
      'colorHex': 0xFF42A5F5,
      'valueTip': 'Put effort into your studies and be honest in your work.',
    },
    {
      'id': 'vocab_read',
      'word': 'Read',
      'phonetic': '/riːd/',
      'emoji': '📖',
      'sentence': 'He is reading a beneficial storybook.',
      'colorHex': 0xFF66BB6A,
      'valueTip': 'Reading good books expands our knowledge and understanding.',
    },
    {
      'id': 'vocab_write',
      'word': 'Write',
      'phonetic': '/raɪt/',
      'emoji': '✍️',
      'sentence': 'She is writing new English words neatly.',
      'colorHex': 0xFFFFA726,
      'valueTip': 'Write with neat handwriting and use clean pages.',
    },
    {
      'id': 'vocab_listen',
      'word': 'Listen',
      'phonetic': '/ˈlɪs.ən/',
      'emoji': '👂',
      'sentence': 'We listen carefully when the teacher speaks.',
      'colorHex': 0xFFEF5350,
      'valueTip': 'Good listeners learn quickly and show deep respect.',
    },
    {
      'id': 'vocab_speak',
      'word': 'Speak',
      'phonetic': '/spiːk/',
      'emoji': '🗣️',
      'sentence': 'They speak politely and say thank you.',
      'colorHex': 0xFF00897B,
      'valueTip': 'Speak good words or remain silent with dignity.',
    },
  ];

  void _speakCurrentWord() {
    final item = _socialWords[_currentIndex];
    final text = '${item['word']}. ${item['sentence']}';
    ref.read(audioServiceProvider).playWord(text);
  }

  void _onNext() {
    if (_currentIndex + 1 < _socialWords.length) {
      setState(() => _currentIndex++);
      _speakCurrentWord();
    } else {
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_teacher_friend_vocab',
            nextActivityId: 'activity_grammar_plurals',
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
              const Icon(Icons.psychology_rounded, size: 72, color: AppColors.primary),
              const SizedBox(height: 12),
              Text('Learning Hero! 👨‍🏫✨', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You learned teacher, student, and learning action words!\nNext up: Plural Counting Grammar!',
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
                text: 'Learn Grammar Plurals ✍️ ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.pluralsGrammar);
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
    final item = _socialWords[_currentIndex];
    final color = Color(item['colorHex'] as int);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Learning Words (${_currentIndex + 1}/${_socialWords.length})',
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
              message: 'Pip says: "Let\'s learn active classroom words! Tap to listen!"',
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
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 3),
                      ),
                      alignment: Alignment.center,
                      child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 68)),
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
                    title: 'Classroom Sunnah',
                    description: item['valueTip'] as String,
                    arabicPhrase: 'Respect & Adab',
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
                    text: _currentIndex + 1 < _socialWords.length ? 'Next Word ▶' : 'Practice Plural Grammar! 🚀',
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
