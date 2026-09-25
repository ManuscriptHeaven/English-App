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

class CleanlinessSortScreen extends ConsumerStatefulWidget {
  const CleanlinessSortScreen({super.key});

  @override
  ConsumerState<CleanlinessSortScreen> createState() => _CleanlinessSortScreenState();
}

class _CleanlinessSortScreenState extends ConsumerState<CleanlinessSortScreen> {
  int _roundIndex = 0;
  String? _selectedCategory;
  bool? _isCorrect;

  final List<Map<String, dynamic>> _items = [
    {
      'title': 'Books neatly arranged on the shelf 📚',
      'correctCategory': 'Tidy & Clean',
      'explanation': 'MashaAllah! Keeping our books in order protects knowledge and honors our home.',
    },
    {
      'title': 'Toys scattered on the floor 🧸',
      'correctCategory': 'Needs Tidying',
      'explanation': 'We pick up our toys and put them into the toy basket to keep our room clean (Taharah)!',
    },
    {
      'title': 'Saying Bismillah before taking a bite 🍽️',
      'correctCategory': 'Sunnah Habit',
      'explanation': 'Saying Bismillah brings barakah and happiness to our meal.',
    },
    {
      'title': 'Making our bed neatly in the morning 🛏️',
      'correctCategory': 'Tidy & Clean',
      'explanation': 'Arranging our pillows and blankets is a wonderful habit of a Muslim explorer!',
    },
  ];

  void _onSelect(String category) {
    if (_selectedCategory != null && _isCorrect == true) return;

    final item = _items[_roundIndex];
    final isRight = (category == item['correctCategory']);

    setState(() {
      _selectedCategory = category;
      _isCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSuccess();
      } else {
        ref.read(audioServiceProvider).playRetry();
      }
    });
  }

  void _onNext() {
    if (_roundIndex + 1 < _items.length) {
      setState(() {
        _roundIndex++;
        _selectedCategory = null;
        _isCorrect = null;
      });
    } else {
      // Completed activity!
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_cleanliness_sort',
            nextActivityId: 'activity_story_home',
            xp: 25,
            coins: 20,
            stars: 3,
          );
      ref.read(audioServiceProvider).playReward();
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
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
              const Icon(Icons.cleaning_services_rounded, size: 72, color: AppColors.valueEmerald),
              const SizedBox(height: 12),
              Text('Tidiness Master! 🧺🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You sorted every habit and practiced Taharah & Sunnah manners!\nNext: Story "Helping at Home"!',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RewardBadge(type: BadgeType.xp, count: 25),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.coin, count: 20),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.star, count: 3),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Read "Helping at Home" 📖 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.storyPath('story_helping_home'));
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
    final item = _items[_roundIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Clean & Tidy Sorting (${_roundIndex + 1}/${_items.length})',
        stars: activeChild?.stars ?? 0,
        coins: activeChild?.coins ?? 0,
        streak: activeChild?.streakDays ?? 0,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const ValueBanner(
              title: 'Cleanliness is Faith',
              description: 'Our Prophet ﷺ taught us that Taharah (cleanliness and neatness) brings beauty and blessings to our lives.',
              arabicPhrase: 'Taharah',
            ),
            const SizedBox(height: 16),

            GuideCharacterBanner(
              message: 'Look at the situation below and decide how to categorize it!',
            ),
            const SizedBox(height: 20),

            // Item Card
            AppCard(
              borderColor: AppColors.worldHomeOrange,
              padding: const EdgeInsets.all(24),
              child: Text(
                item['title'] as String,
                style: AppTypography.displayMedium.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Category Options
            ...['Tidy & Clean', 'Needs Tidying', 'Sunnah Habit'].map((cat) {
              final isSelected = _selectedCategory == cat;
              Color bg = Colors.white;
              Color border = AppColors.cardBorder;

              if (isSelected) {
                if (_isCorrect == true) {
                  bg = AppColors.correctGreen.withValues(alpha: 0.15);
                  border = AppColors.correctGreen;
                } else {
                  bg = AppColors.tryAgainOrange.withValues(alpha: 0.15);
                  border = AppColors.tryAgainOrange;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: AppCard(
                  backgroundColor: bg,
                  borderColor: border,
                  onTap: () => _onSelect(cat),
                  child: Row(
                    children: [
                      Icon(
                        isSelected && _isCorrect == true
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: isSelected && _isCorrect == true ? AppColors.correctGreen : AppColors.textSecondary,
                        size: 26,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(cat, style: AppTypography.headlineMedium.copyWith(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              );
            }),

            if (_isCorrect != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _isCorrect == true
                      ? AppColors.valueMint
                      : AppColors.tryAgainOrange.withValues(alpha: 0.15),
                  borderRadius: AppRadius.roundedMd,
                ),
                child: Text(
                  item['explanation'] as String,
                  style: AppTypography.bodyMedium.copyWith(
                    color: _isCorrect == true ? AppColors.valueEmerald : AppColors.errorRed,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (_isCorrect == true)
              AppButton(
                text: 'Next Habit ▶',
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
