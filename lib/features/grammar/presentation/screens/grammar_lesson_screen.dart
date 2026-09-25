import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/guide_character.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

class GrammarLessonScreen extends ConsumerStatefulWidget {
  const GrammarLessonScreen({super.key});

  @override
  ConsumerState<GrammarLessonScreen> createState() => _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends ConsumerState<GrammarLessonScreen> {
  int _step = 0;

  final List<Map<String, String>> _examples = [
    {
      'subject': 'Cat',
      'emoji': '🐱',
      'sentence': 'This is a cat.',
      'explanation': 'When pointing to an animal close to you, say: "This is a cat."',
    },
    {
      'subject': 'Elephant',
      'emoji': '🐘',
      'sentence': 'This is an elephant.',
      'explanation': 'We say "an elephant" because it begins with the letter E!',
    },
    {
      'subject': 'Lion',
      'emoji': '🦁',
      'sentence': 'This is a lion.',
      'explanation': 'Say "This is a lion" with a brave voice!',
    },
  ];

  void _speakExample() {
    final ex = _examples[_step];
    ref.read(audioServiceProvider).playWordPronunciation(ex['sentence']!);
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final ex = _examples[_step];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Grammar: "This is..." (${_step + 1}/${_examples.length})',
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
              message: 'Let’s learn how to build sentences! Listen to how we point to our friends.',
              onSpeakTap: _speakExample,
            ),
            const SizedBox(height: 20),

            AppCard(
              borderColor: AppColors.primary,
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(ex['emoji']!, style: const TextStyle(fontSize: 64)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ex['sentence']!,
                        style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 32),
                        onPressed: _speakExample,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ex['explanation']!,
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                if (_step > 0)
                  Expanded(
                    child: AppButton(
                      text: '◀ Back',
                      height: 54,
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.textPrimary,
                      onPressed: () => setState(() => _step--),
                    ),
                  )
                else
                  const Spacer(),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: AppButton(
                    text: _step + 1 < _examples.length ? 'Next Example ▶' : 'Build Sentences 🧩 ▶',
                    height: 54,
                    backgroundColor: AppColors.secondary,
                    onPressed: () {
                      if (_step + 1 < _examples.length) {
                        setState(() => _step++);
                        _speakExample();
                      } else {
                        context.pushReplacement(RouteNames.sentenceBuilder);
                      }
                    },
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
