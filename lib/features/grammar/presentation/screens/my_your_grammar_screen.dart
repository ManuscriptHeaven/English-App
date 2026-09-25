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

class MyYourGrammarScreen extends ConsumerStatefulWidget {
  const MyYourGrammarScreen({super.key});

  @override
  ConsumerState<MyYourGrammarScreen> createState() => _MyYourGrammarScreenState();
}

class _MyYourGrammarScreenState extends ConsumerState<MyYourGrammarScreen> {
  int _step = 0;

  final List<Map<String, String>> _examples = [
    {
      'subject': 'My Room',
      'emoji': '🚪',
      'sentence': 'This is my room.',
      'explanation': 'Use "my" when talking about your own room or belongings: "This is my room."',
    },
    {
      'subject': 'My Book',
      'emoji': '📚',
      'sentence': 'I have a book.',
      'explanation': 'Use "I have" when you hold or own something: "I have a book."',
    },
    {
      'subject': 'She is helping',
      'emoji': '👩',
      'sentence': 'She is helping.',
      'explanation': 'We say "She is helping" when describing Mother or Sister doing good work!',
    },
  ];

  void _speakExample() {
    final ex = _examples[_step];
    ref.read(audioServiceProvider).playSentence(ex['sentence']!);
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final ex = _examples[_step];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Grammar: "This is my..." (${_step + 1}/${_examples.length})',
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
              message: 'Let’s learn how to talk about home and family! Listen to these examples.',
              onSpeakTap: _speakExample,
            ),
            const SizedBox(height: 20),

            AppCard(
              borderColor: AppColors.worldHomeOrange,
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: AppColors.worldHomeBg,
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
                        style: AppTypography.displayMedium.copyWith(color: AppColors.worldHomeOrange),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, color: AppColors.worldHomeOrange, size: 32),
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
                    text: _step + 1 < _examples.length ? 'Next Example ▶' : 'Build Home Sentences 🧩 ▶',
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
