import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/world_themes.dart';
import '../../../../core/widgets/adventure_button.dart';
import '../../../../core/widgets/adventure_scaffold.dart';
import '../../../../core/widgets/audio_play_button.dart';
import '../../../../core/widgets/pip_character_guide.dart';
import '../../../../core/widgets/reward_burst.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../adventure_brain/domain/adaptive/mastery_engine.dart';
import '../../../adventure_brain/domain/adaptive/skill_dimension.dart';
import '../../../adventure_brain/presentation/providers/adventure_brain_providers.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../providers/story_providers.dart';

/// Premium Picture Book Story Reader for Children (Ages 3–10).
///
/// Design:
/// - 60-70% visual illustration scene with interactive hotspots
/// - Highlighted sentence narration with auto/manual audio
/// - Picture-book page turning
/// - Tactile comprehension quiz with RewardBurst celebration
class StoryReaderScreen extends ConsumerStatefulWidget {
  final String storyId;

  const StoryReaderScreen({super.key, required this.storyId});

  @override
  ConsumerState<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends ConsumerState<StoryReaderScreen>
    with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  bool _showingQuiz = false;
  int _quizQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool? _isAnswerCorrect;
  int _quizScore = 0;

  late AnimationController _sceneCtrl;
  late Animation<double> _sceneBounce;

  final List<String> _pageEmojis = [
    '🌳 🏞️ ☀️', // Page 1: Park entrance
    '🐘 💧 🌿', // Page 2: Elephant
    '🐱 🌳 🌸', // Page 3: Kitten near tree
    '🐱 ☀️ 🏜️', // Page 4: Thirsty kitten
    '🥣 💧 ✨', // Page 5: Clean water bowl
    '🤲 ❤️ 🐱', // Page 6: Gentle hands
    '🐱 💧 🎶', // Page 7: Drinking happily
    '🌟 🕌 💖', // Page 8: Alhamdulillah & kindness
  ];

  @override
  void initState() {
    super.initState();
    _sceneCtrl = AnimationController(
      vsync: this,
      duration: AppMotion.characterReaction,
    );
    _sceneBounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.95), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _sceneCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _sceneCtrl.dispose();
    super.dispose();
  }

  void _onTapHotspot(int pageNumber) {
    _sceneCtrl.reset();
    _sceneCtrl.forward();

    if (pageNumber == 3 || pageNumber == 4 || pageNumber == 7) {
      ref.read(audioServiceProvider).playSoundEffect(SoundEffect.correct);
      ref.read(audioServiceProvider).playWordPronunciation('Meow, purr! The kitten is happy.');
    } else if (pageNumber == 2 || pageNumber == 5) {
      ref.read(audioServiceProvider).playSoundEffect(SoundEffect.click);
      ref.read(audioServiceProvider).playWordPronunciation('Splash! Clean cool water.');
    } else {
      ref.read(audioServiceProvider).playSoundEffect(SoundEffect.click);
    }
  }

  void _onQuizAnswer(int selectedIndex, int correctIndex) {
    if (_selectedAnswerIndex != null && _isAnswerCorrect == true) return;

    final isRight = (selectedIndex == correctIndex);
    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _isAnswerCorrect = isRight;
      if (isRight) {
        _quizScore += 25;
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.correct);
      } else {
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.tryAgain);
      }
    });

    final activeChild = ref.read(activeChildProfileProvider);
    if (activeChild != null) {
      final repo = ref.read(vocabularyMasteryRepositoryProvider);
      final vocabId = 'story_${widget.storyId}';
      repo.getMastery(childId: activeChild.id, vocabularyId: vocabId).then((currentMastery) {
        final evidence = LearningEvidence(
          childId: activeChild.id,
          vocabularyId: vocabId,
          word: widget.storyId,
          isCorrect: isRight,
          dimension: SkillDimension.storyComprehension,
          comprehensionTested: true,
          comprehensionSuccess: isRight,
          timestamp: DateTime.now(),
        );
        final updatedMastery = const MasteryEngine().recordAttempt(
          currentMastery: currentMastery,
          evidence: evidence,
        );
        repo.saveMastery(updatedMastery);
      });
    }
  }

  void _nextQuizQuestion(int totalQuestions, int rewardXp, int rewardCoins, int rewardStars) {
    if (_quizQuestionIndex + 1 < totalQuestions) {
      setState(() {
        _quizQuestionIndex++;
        _selectedAnswerIndex = null;
        _isAnswerCorrect = null;
      });
    } else {
      // Completed full story and quiz!
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_story_read',
            nextActivityId: 'activity_listen_speak',
            xp: rewardXp,
            coins: rewardCoins,
            stars: rewardStars,
          );
      ref.read(audioServiceProvider).playSoundEffect(SoundEffect.levelComplete);
      RewardBurst.show(
        context,
        title: 'Story Master! 📖🌟',
        subtitle: 'Score: $_quizScore on the quiz!',
        xp: rewardXp,
        coins: rewardCoins,
        stars: rewardStars,
        onDismiss: () {
          Navigator.of(context).pop();
          context.pushReplacement(RouteNames.listeningPractice);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyAsync = ref.watch(storyDetailProvider(widget.storyId));
    final activeChild = ref.watch(activeChildProfileProvider);
    final worldTheme = WorldTheme.forActivityId(widget.storyId);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: worldTheme.backgroundColor,
      body: Stack(
        children: [
          // Background Painter
          Positioned.fill(
            child: ExcludeSemantics(
              excluding: true,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: WorldScenePainter(
                    theme: worldTheme,
                    groundHeightFraction: 0.28,
                  ),
                ),
              ),
            ),
          ),

          // Child AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ChildAppBar(
              title: _showingQuiz ? 'Story Quiz 🎯' : 'Story Time 📖',
              showBack: true,
              stars: activeChild?.stars ?? 0,
              coins: activeChild?.coins ?? 0,
              worldTheme: worldTheme,
            ),
          ),

          SafeArea(
            child: storyAsync.when(
              loading: () => const LoadingView(message: 'Opening storybook...'),
              error: (err, _) => ErrorView(message: err.toString()),
              data: (story) {
                if (story == null) {
                  return const EmptyView(title: 'Story Not Found', subtitle: 'Could not load story data.');
                }

                // ══════════════════════════════════════════════
                // QUIZ MODE
                // ══════════════════════════════════════════════
                if (_showingQuiz && story.comprehensionQuestions.isNotEmpty) {
                  final question = story.comprehensionQuestions[_quizQuestionIndex];

                  return Column(
                    children: [
                      const SizedBox(height: 68),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: worldTheme.accentColor, width: 2),
                              ),
                              child: Text(
                                'Question ${_quizQuestionIndex + 1} of ${story.comprehensionQuestions.length} ⭐',
                                style: AppTypography.labelLarge.copyWith(color: worldTheme.accentColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.mintLight,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '🌿 Rahmah',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.mintDark, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Pip asking question
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PipCharacterGuide(
                          state: _isAnswerCorrect == true ? PipState.celebrating : (_isAnswerCorrect == false ? PipState.encouraging : PipState.speaking),
                          speechBubbleText: question.prompt,
                          characterSize: 76,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Quiz Choice Options
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: question.options.length,
                          itemBuilder: (context, idx) {
                            final opt = question.options[idx];
                            final isSelected = _selectedAnswerIndex == idx;
                            Color bg = Colors.white;
                            Color border = AppColors.cardBorder;

                            if (isSelected) {
                              if (_isAnswerCorrect == true) {
                                bg = AppColors.correctGreen.withAlpha(40);
                                border = AppColors.correctGreen;
                              } else {
                                bg = AppColors.tryAgainOrange.withAlpha(40);
                                border = AppColors.tryAgainOrange;
                              }
                            }

                            return GestureDetector(
                              onTap: () => _onQuizAnswer(idx, question.correctOptionIndex),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: border, width: isSelected ? 3 : 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: border.withAlpha(isSelected ? 60 : 30),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: isSelected && _isAnswerCorrect == true
                                          ? AppColors.correctGreen
                                          : worldTheme.skyColorBottom,
                                      child: Text(
                                        String.fromCharCode(65 + idx),
                                        style: AppTypography.badgeText.copyWith(
                                          color: isSelected && _isAnswerCorrect == true
                                              ? Colors.white
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        opt,
                                        style: AppTypography.sentenceText.copyWith(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Next question button
                      AnimatedSwitcher(
                        duration: AppMotion.slideIn,
                        child: _isAnswerCorrect == true
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                                child: AdventureButton(
                                  text: _quizQuestionIndex + 1 < story.comprehensionQuestions.length
                                      ? 'Next Question ▶'
                                      : 'Finish Story Adventure! 🌟',
                                  backgroundColor: AppColors.meadowGreen,
                                  height: 62,
                                  childAge: activeChild?.age ?? 6,
                                  onPressed: () => _nextQuizQuestion(
                                    story.comprehensionQuestions.length,
                                    story.rewardXp,
                                    story.rewardCoins,
                                    story.rewardStars,
                                  ),
                                ),
                              )
                            : const SizedBox(height: 60),
                      ),
                    ],
                  );
                }

                // ══════════════════════════════════════════════
                // PICTURE BOOK READING MODE
                // ══════════════════════════════════════════════
                final page = story.pages[_currentPageIndex];
                final emojiScene = _currentPageIndex < _pageEmojis.length
                    ? _pageEmojis[_currentPageIndex]
                    : '🌳 🐱 💧';

                return Column(
                  children: [
                    const SizedBox(height: 68),

                    // Page progress pill + narration audio button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: worldTheme.accentColor, width: 2),
                            ),
                            child: Text(
                              'Page ${page.pageNumber} of ${story.pages.length} 📖',
                              style: AppTypography.labelLarge.copyWith(color: AppColors.earthDark, fontWeight: FontWeight.bold),
                            ),
                          ),
                          AudioPlayButton(
                            textToSpeak: page.text,
                            size: 46,
                            priority: AudioPriority.storyNarration,
                          ),
                        ],
                      ),
                    ),

                    // Picture book illustration stage
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: GestureDetector(
                          onTap: () => _onTapHotspot(page.pageNumber),
                          child: ScaleTransition(
                            scale: _sceneCtrl.isAnimating ? _sceneBounce : const AlwaysStoppedAnimation(1.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(220),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(color: worldTheme.groundColorDark, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: worldTheme.accentColor.withAlpha(40),
                                    offset: const Offset(0, 6),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(emojiScene, style: TextStyle(fontSize: size.width * 0.16)),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.sunLight,
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: const Text('✨ Tap picture to explore!', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Story Narration Text Card
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (page.dialogueSpeaker != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: worldTheme.skyColorBottom,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '${page.dialogueSpeaker}: "${page.characterDialogue}"',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.earthDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              Text(
                                page.text,
                                style: AppTypography.sentenceText.copyWith(
                                  fontSize: (activeChild?.age ?? 6) <= 4 ? 22 : 18,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Navigation Controls
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Row(
                        children: [
                          if (_currentPageIndex > 0) ...[
                            Expanded(
                              child: AdventureButton(
                                text: '◀ Back',
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.textPrimary,
                                height: 56,
                                childAge: activeChild?.age ?? 6,
                                onPressed: () => setState(() => _currentPageIndex--),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            flex: 2,
                            child: AdventureButton(
                              text: _currentPageIndex + 1 < story.pages.length ? 'Next Page ▶' : 'Story Quiz 🎯 ▶',
                              backgroundColor: AppColors.sunYellow,
                              height: 60,
                              childAge: activeChild?.age ?? 6,
                              onPressed: () {
                                if (_currentPageIndex + 1 < story.pages.length) {
                                  setState(() => _currentPageIndex++);
                                  ref.read(audioServiceProvider).playNarration(story.pages[_currentPageIndex].text);
                                } else {
                                  setState(() => _showingQuiz = true);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
