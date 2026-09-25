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
import '../../../../core/widgets/guide_character.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../../core/widgets/value_pill.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

class FamilyVocabularyScreen extends ConsumerStatefulWidget {
  const FamilyVocabularyScreen({super.key});

  @override
  ConsumerState<FamilyVocabularyScreen> createState() => _FamilyVocabularyScreenState();
}

class _FamilyVocabularyScreenState extends ConsumerState<FamilyVocabularyScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _familyWords = [
    {
      'id': 'vocab_mother',
      'word': 'Mother',
      'phonetic': '/ˈmʌð.ər/',
      'emoji': '👩',
      'sentence': 'This is my mother. She cares for us with immense love.',
      'colorHex': 0xFFFF6584,
      'valueTip': 'Jannah lies under the feet of mothers; honor her always.',
    },
    {
      'id': 'vocab_father',
      'word': 'Father',
      'phonetic': '/ˈfɑː.ðər/',
      'emoji': '👨',
      'sentence': 'This is my father. He works hard and protects our family.',
      'colorHex': 0xFF42A5F5,
      'valueTip': 'A father’s pleasure brings Allah’s pleasure.',
    },
    {
      'id': 'vocab_brother',
      'word': 'Brother',
      'phonetic': '/ˈbrʌð.ər/',
      'emoji': '👦',
      'sentence': 'This is my brother. We play and share toys together.',
      'colorHex': 0xFF66BB6A,
      'valueTip': 'A smile to your brother is a form of charity (Sadaqah).',
    },
    {
      'id': 'vocab_sister',
      'word': 'Sister',
      'phonetic': '/ˈsɪs.tər/',
      'emoji': '👧',
      'sentence': 'This is my sister. We read storybooks happily.',
      'colorHex': 0xFFFFA726,
      'valueTip': 'Kindness to sisters brings joy and peace to the home.',
    },
  ];

  void _speakCurrentWord() {
    final item = _familyWords[_currentIndex];
    final text = '${item['word']}. ${item['sentence']}';
    ref.read(audioServiceProvider).playWord(text);
  }

  void _onNext() {
    if (_currentIndex + 1 < _familyWords.length) {
      setState(() => _currentIndex++);
      _speakCurrentWord();
    } else {
      // Completed family vocab!
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_family_vocab',
            nextActivityId: 'activity_listen_find_home',
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
              const Icon(Icons.favorite_rounded, size: 72, color: AppColors.accent),
              const SizedBox(height: 12),
              Text('Loving Family Hero! 👨‍👩‍👧‍👦🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You learned all family words and respect for parents!\nNext up: Listen & Find Game!',
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
                text: 'Play Listen & Find 🎧 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.listenAndFindHome);
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
    final item = _familyWords[_currentIndex];
    final color = Color(item['colorHex'] as int);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Family Words (${_currentIndex + 1}/${_familyWords.length})',
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
              message: 'Family is a special gift from Allah! Tap to hear "${item['word']}"!',
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
                      child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 72)),
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
                      color: AppColors.worldHomeBg,
                      borderRadius: AppRadius.roundedLg,
                      border: Border.all(color: AppColors.worldHomeOrange.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '🗣️ "${item['sentence']}"',
                      style: AppTypography.titleLarge.copyWith(color: AppColors.worldHomeOrange),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ValueBanner(
                    title: 'Birr al-Walidayn',
                    description: item['valueTip'] as String,
                    arabicPhrase: 'Loving Family',
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
                    text: _currentIndex + 1 < _familyWords.length ? 'Next Word ▶' : 'Play Listen & Find! 🚀',
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
