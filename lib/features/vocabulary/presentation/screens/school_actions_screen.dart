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

class SchoolActionItem {
  final String verb;
  final String emoji;
  final String sentence;
  final String sunnahManner;

  const SchoolActionItem({
    required this.verb,
    required this.emoji,
    required this.sentence,
    required this.sunnahManner,
  });
}

/// "School Actions" interactive verb exploration screen for World 3.
class SchoolActionsScreen extends ConsumerStatefulWidget {
  const SchoolActionsScreen({super.key});

  @override
  ConsumerState<SchoolActionsScreen> createState() => _SchoolActionsScreenState();
}

class _SchoolActionsScreenState extends ConsumerState<SchoolActionsScreen> {
  int _currentIndex = 0;
  bool _isCompleted = false;

  final List<SchoolActionItem> _actions = const [
    SchoolActionItem(
      verb: 'Read',
      emoji: '📖',
      sentence: 'We read beneficial books in the library.',
      sunnahManner: 'Seeking beneficial knowledge is rewarded by Allah. 🌟',
    ),
    SchoolActionItem(
      verb: 'Write',
      emoji: '✍️',
      sentence: 'I write my lesson with a clean pencil.',
      sunnahManner: 'Writing down knowledge preserves it. 📝',
    ),
    SchoolActionItem(
      verb: 'Listen',
      emoji: '👂',
      sentence: 'We listen politely when our teacher speaks.',
      sunnahManner: 'Good listening is a sign of respect and Adab. 🤲',
    ),
    SchoolActionItem(
      verb: 'Share',
      emoji: '🤝',
      sentence: 'I share my colored pencils with my classmate.',
      sunnahManner: 'Sharing brings blessings and friendship! 💖',
    ),
    SchoolActionItem(
      verb: 'Help',
      emoji: '🤲',
      sentence: 'We help our friends pick up their books.',
      sunnahManner: 'Allah helps those who help others. 🌟',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playCurrentAction();
    });
  }

  void _playCurrentAction() {
    final action = _actions[_currentIndex];
    ref.read(audioServiceProvider).playSentence('${action.verb}! ${action.sentence}');
  }

  void _nextAction() {
    final action = _actions[_currentIndex];
    final activeChild = ref.read(activeChildProfileProvider);

    if (activeChild != null) {
      ref.read(learningSignalRepositoryProvider).recordSignal(
            LearningSignal(
              id: 'sig_action_${DateTime.now().microsecondsSinceEpoch}',
              childId: activeChild.id,
              skill: SkillType.vocabulary,
              contentId: 'action_${action.verb.toLowerCase()}',
              activityId: 'activity_school_actions',
              worldId: 'world_school',
              score: 1.0,
              attempts: 1,
              responseTimeMs: 1200,
              timestamp: DateTime.now(),
            ),
          );
    }

    ref.read(audioServiceProvider).playSuccess();

    if (_currentIndex + 1 < _actions.length) {
      setState(() {
        _currentIndex++;
      });
      _playCurrentAction();
    } else {
      setState(() {
        _isCompleted = true;
      });
      ref.read(audioServiceProvider).playReward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Action Star! ⭐'),
          backgroundColor: AppColors.primary,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppCard(
              borderColor: AppColors.primary,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎒🎉', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text('Awesome Action Verbs!', style: AppTypography.displayMedium),
                  const SizedBox(height: 8),
                  Text(
                    'You learned how to Read, Write, Listen, Share, and Help at school!',
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
                            'activity_school_actions',
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

    final action = _actions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('School Actions 🏃‍♂️'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _actions.length,
              backgroundColor: AppColors.cardBorder,
              color: AppColors.primary,
              minHeight: 8,
              borderRadius: AppRadius.roundedSm,
            ),
            const SizedBox(height: 20),

            // Main Action Card
            Expanded(
              child: AppCard(
                borderColor: AppColors.primary,
                borderWidth: 2,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(action.emoji, style: const TextStyle(fontSize: 64)),
                        const SizedBox(height: 8),
                        Text(action.verb, style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark)),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            action.sentence,
                            style: AppTypography.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        IconButton(
                          icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 32),
                          onPressed: _playCurrentAction,
                        ),
                        const SizedBox(height: 10),

                        // Islamic Sunnah Manner Box
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight,
                            borderRadius: AppRadius.roundedMd,
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Text(
                            action.sunnahManner,
                            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.secondaryDark),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Next Action Button
            AppButton(
              text: _currentIndex + 1 < _actions.length ? 'Next Action ➡️' : 'Finish Actions ⭐',
              minWidth: double.infinity,
              height: 54,
              onPressed: _nextAction,
            ),
          ],
        ),
      ),
    );
  }
}
