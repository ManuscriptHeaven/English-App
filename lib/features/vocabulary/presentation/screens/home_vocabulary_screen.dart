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

class HomeVocabularyScreen extends ConsumerStatefulWidget {
  const HomeVocabularyScreen({super.key});

  @override
  ConsumerState<HomeVocabularyScreen> createState() => _HomeVocabularyScreenState();
}

class _HomeVocabularyScreenState extends ConsumerState<HomeVocabularyScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _homeWords = [
    {
      'id': 'vocab_room',
      'word': 'Room',
      'phonetic': '/ruːm/',
      'emoji': '🚪',
      'sentence': 'This is my room. It is tidy and bright.',
      'colorHex': 0xFFFFA726,
      'valueTip': 'Keeping our room clean brings peace to our home.',
    },
    {
      'id': 'vocab_bed',
      'word': 'Bed',
      'phonetic': '/bed/',
      'emoji': '🛏️',
      'sentence': 'I make my bed every morning.',
      'colorHex': 0xFF42A5F5,
      'valueTip': 'Arranging our bed neatly is a great morning habit.',
    },
    {
      'id': 'vocab_table',
      'word': 'Table',
      'phonetic': '/ˈteɪ.bəl/',
      'emoji': '🪑',
      'sentence': 'We sit around the table and say Bismillah.',
      'colorHex': 0xFF66BB6A,
      'valueTip': 'Sharing meals with family with gratitude and good manners.',
    },
    {
      'id': 'vocab_chair',
      'word': 'Chair',
      'phonetic': '/tʃeər/',
      'emoji': '🪑',
      'sentence': 'This is a comfortable chair.',
      'colorHex': 0xFF7E57C2,
      'valueTip': 'Offer your chair kindly to guests and elders.',
    },
    {
      'id': 'vocab_book',
      'word': 'Book',
      'phonetic': '/bʊk/',
      'emoji': '📚',
      'sentence': 'I have a colorful storybook on my shelf.',
      'colorHex': 0xFFEF5350,
      'valueTip': 'Knowledge is a gift from Allah; treat books gently.',
    },
    {
      'id': 'vocab_clean',
      'word': 'Clean',
      'phonetic': '/kliːn/',
      'emoji': '🧼',
      'sentence': 'We keep our house clean and pure.',
      'colorHex': 0xFF00897B,
      'valueTip': 'Cleanliness (Taharah) is half of faith.',
    },
    {
      'id': 'vocab_help',
      'word': 'Help',
      'phonetic': '/help/',
      'emoji': '🤲',
      'sentence': 'Ayaan and Maryam help their Mother.',
      'colorHex': 0xFFFF6584,
      'valueTip': 'Helping parents brings immense blessings from Allah.',
    },
    {
      'id': 'vocab_food',
      'word': 'Food',
      'phonetic': '/fuːd/',
      'emoji': '🍎',
      'sentence': 'We enjoy delicious food and say Alhamdulillah.',
      'colorHex': 0xFFFFB800,
      'valueTip': 'Never waste food, and thank Allah with a joyful heart.',
    },
  ];

  void _speakCurrentWord() {
    final item = _homeWords[_currentIndex];
    final text = '${item['word']}. ${item['sentence']}';
    ref.read(audioServiceProvider).playWord(text);
  }

  void _onNext() {
    if (_currentIndex + 1 < _homeWords.length) {
      setState(() => _currentIndex++);
      _speakCurrentWord();
    } else {
      // Completed home vocab!
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_home_vocab',
            nextActivityId: 'activity_home_hunt',
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
              const Icon(Icons.home_rounded, size: 72, color: AppColors.worldHomeOrange),
              const SizedBox(height: 12),
              Text('Home Explorer! 🏡🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You discovered all Home & Family words!\nNext up: Home Hunt Game!',
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
                text: 'Play Home Hunt 🔍 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.homeHunt);
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
    final item = _homeWords[_currentIndex];
    final color = Color(item['colorHex'] as int);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Home Words (${_currentIndex + 1}/${_homeWords.length})',
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
              message: 'Welcome to our cozy Home! Tap the speaker to hear "${item['word']}"!',
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
                    title: 'Home Value',
                    description: item['valueTip'] as String,
                    arabicPhrase: 'Barakah',
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
                    text: _currentIndex + 1 < _homeWords.length ? 'Next Word ▶' : 'Play Home Hunt! 🚀',
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
