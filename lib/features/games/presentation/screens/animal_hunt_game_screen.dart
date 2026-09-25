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
import '../../../../core/widgets/choice_object.dart';
import '../../../../core/widgets/pip_character_guide.dart';
import '../../../../core/widgets/reward_burst.dart';
import '../../../adventure_brain/domain/adaptive/difficulty_engine.dart';
import '../../../adventure_brain/domain/adaptive/mastery_engine.dart';
import '../../../adventure_brain/domain/adaptive/skill_dimension.dart';
import '../../../adventure_brain/presentation/providers/adventure_brain_providers.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';

/// Animal Hunt Game Screen — redesigned.
///
/// BEFORE: 3 white AppCards in a grid. Looked like a quiz.
/// AFTER: Illustrated jungle/meadow scene. Pip gives the clue. Child taps large ChoiceObject tiles.
///        Correct: ChoiceObject bursts with stars, Pip celebrates.
///        Wrong: ChoiceObject shakes gently, Pip encourages.
class AnimalHuntGameScreen extends ConsumerStatefulWidget {
  final List<String>? targetVocabularyIds;
  final AdaptiveDifficultyTier? difficultyTier;

  const AnimalHuntGameScreen({
    super.key,
    this.targetVocabularyIds,
    this.difficultyTier,
  });

  @override
  ConsumerState<AnimalHuntGameScreen> createState() =>
      _AnimalHuntGameScreenState();
}

class _AnimalHuntGameScreenState extends ConsumerState<AnimalHuntGameScreen>
    with SingleTickerProviderStateMixin {
  int _currentRound = 0;
  int _score = 0;
  int _attempts = 0;
  String? _selectedCard;
  bool? _isCorrect;

  // Pip's state
  PipState _pipState = PipState.speaking;
  String _pipSpeech = '';

  late AnimationController _progressCtrl;

  final List<Map<String, dynamic>> _rounds = [
    {
      'targetWord': 'Elephant',
      'prompt': 'Find the Elephant! 🐘',
      'options': [
        {'word': 'Lion', 'emoji': '🦁', 'color': 0xFFFF9F43},
        {'word': 'Elephant', 'emoji': '🐘', 'color': 0xFF52C97F},
        {'word': 'Cat', 'emoji': '🐱', 'color': 0xFFFFD166},
      ],
      'clue': "I have a long trunk! 🐘",
    },
    {
      'targetWord': 'Cat',
      'prompt': 'Find the Cat! 🐱',
      'options': [
        {'word': 'Cat', 'emoji': '🐱', 'color': 0xFFFFD166},
        {'word': 'Bird', 'emoji': '🐦', 'color': 0xFF4A9FD6},
        {'word': 'Elephant', 'emoji': '🐘', 'color': 0xFF52C97F},
      ],
      'clue': "I say meow! 🐱",
    },
    {
      'targetWord': 'Lion',
      'prompt': 'Find the Lion! 🦁',
      'options': [
        {'word': 'Bird', 'emoji': '🐦', 'color': 0xFF4A9FD6},
        {'word': 'Cat', 'emoji': '🐱', 'color': 0xFFFFD166},
        {'word': 'Lion', 'emoji': '🦁', 'color': 0xFFFF9F43},
      ],
      'clue': "I am the brave king! 🦁",
    },
    {
      'targetWord': 'Bird',
      'prompt': 'Find the Bird! 🐦',
      'options': [
        {'word': 'Elephant', 'emoji': '🐘', 'color': 0xFF52C97F},
        {'word': 'Bird', 'emoji': '🐦', 'color': 0xFF4A9FD6},
        {'word': 'Lion', 'emoji': '🦁', 'color': 0xFFFF9F43},
      ],
      'clue': "I have wings and can fly! 🐦",
    },
  ];

  List<Map<String, dynamic>> get _activeRounds {
    if (widget.targetVocabularyIds != null && widget.targetVocabularyIds!.isNotEmpty) {
      final targets = widget.targetVocabularyIds!
          .map((id) => id.replaceFirst('vocab_', '').toLowerCase())
          .toSet();
      final filtered = _rounds
          .where((r) => targets.contains((r['targetWord'] as String).toLowerCase()))
          .toList();
      if (filtered.isNotEmpty) return filtered;
    }
    return _rounds;
  }

  List<Map<String, dynamic>> _getOptionsForRound(Map<String, dynamic> round) {
    final options = List<Map<String, dynamic>>.from(round['options'] as List);
    if (widget.difficultyTier == AdaptiveDifficultyTier.support && options.length > 2) {
      final target = options.firstWhere((o) => o['word'] == round['targetWord']);
      final distractor = options.firstWhere((o) => o['word'] != round['targetWord']);
      return [target, distractor];
    }
    return options;
  }

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(vsync: this, duration: AppMotion.slideIn);
    _updatePipSpeech();
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  void _updatePipSpeech() {
    final round = _activeRounds[_currentRound.clamp(0, _activeRounds.length - 1)];
    setState(() {
      _pipState = PipState.speaking;
      _pipSpeech = round['clue'] as String;
    });
    ref.read(audioServiceProvider).playWordPronunciation(round['prompt'] as String);
  }

  void _onCardTap(String word) {
    if (_selectedCard != null && _isCorrect == true) return;

    final round = _activeRounds[_currentRound.clamp(0, _activeRounds.length - 1)];
    final isRight = (word == round['targetWord']);

    setState(() {
      _selectedCard = word;
      _isCorrect = isRight;
      _attempts++;
      if (isRight) {
        _score += 25;
        _pipState = PipState.celebrating;
        _pipSpeech = 'Amazing! You found it! 🎉';
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.correct);
      } else {
        _pipState = PipState.encouraging;
        _pipSpeech = 'Almost! Try again — ${round['clue']}';
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.tryAgain);
      }
    });

    final activeChild = ref.read(activeChildProfileProvider);
    if (activeChild != null) {
      final repo = ref.read(vocabularyMasteryRepositoryProvider);
      final targetId = 'vocab_${(round['targetWord'] as String).toLowerCase()}';
      final targetWord = round['targetWord'] as String;
      repo.getMastery(childId: activeChild.id, vocabularyId: targetId).then((currentMastery) {
        final evidence = LearningEvidence(
          childId: activeChild.id,
          vocabularyId: targetId,
          word: targetWord,
          isCorrect: isRight,
          usedHint: _attempts > 1,
          dimension: SkillDimension.vocabularyRecognition,
          isIndependentRecall: _attempts <= 1,
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

  void _onNextRound() {
    if (_currentRound + 1 < _activeRounds.length) {
      setState(() {
        _currentRound++;
        _selectedCard = null;
        _isCorrect = null;
      });
      _updatePipSpeech();
    } else {
      ref
          .read(activeChildProfileProvider.notifier)
          .completeActivity(
            'activity_animal_hunt',
            nextActivityId: 'activity_listen_tap',
            xp: 25,
            coins: 15,
            stars: 3,
          );
      ref.read(audioServiceProvider).playSoundEffect(SoundEffect.levelComplete);
      RewardBurst.show(
        context,
        title: 'Animal Hunt Master! 🏆',
        subtitle: 'Score: $_score in $_attempts taps',
        xp: 25,
        coins: 15,
        stars: 3,
        onDismiss: () {
          Navigator.of(context).pop();
          context.pushReplacement(RouteNames.listenAndTap);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final round = _activeRounds[_currentRound.clamp(0, _activeRounds.length - 1)];
    final worldTheme = WorldTheme.animalAdventure;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: worldTheme.backgroundColor,
      body: Stack(
        children: [
          // Illustrated scene background
          Positioned.fill(
            child: ExcludeSemantics(
              excluding: true,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: WorldScenePainter(
                    theme: worldTheme,
                    groundHeightFraction: 0.30,
                  ),
                ),
              ),
            ),
          ),

          // Environment decorations
          Positioned(bottom: 76, left: 6,
              child: const ExcludeSemantics(child: Text('🌳', style: TextStyle(fontSize: 52)))),
          Positioned(bottom: 72, right: 8,
              child: const ExcludeSemantics(child: Text('🌲', style: TextStyle(fontSize: 44)))),
          Positioned(bottom: 70, left: size.width * 0.42,
              child: const ExcludeSemantics(child: Text('🌻', style: TextStyle(fontSize: 28)))),
          Positioned(top: 70, right: 20,
              child: const ExcludeSemantics(child: Text('🌤️', style: TextStyle(fontSize: 28)))),

          // Child app bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: ChildAppBar(
              title: 'Animal Hunt',
              showBack: true,
              stars: activeChild?.stars ?? 0,
              coins: activeChild?.coins ?? 0,
              worldTheme: worldTheme,
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 68), // below appBar
                // Progress paw prints
                Semantics(
                  label: 'Round ${_currentRound + 1} of ${_activeRounds.length}',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_activeRounds.length, (i) {
                        final done = i < _currentRound;
                        final active = i == _currentRound;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: AnimatedContainer(
                            duration: AppMotion.stateChange,
                            width: active ? 32 : 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: done
                                ? AppColors.sunYellow
                                : active
                                    ? AppColors.meadowGreen
                                    : Colors.white.withAlpha(180),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                  color: active
                                      ? AppColors.meadowDark
                                      : AppColors.earthLight,
                                  width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                done ? '✓' : active ? '🐾' : '·',
                                style: TextStyle(
                                    fontSize: done ? 10 : 12,
                                    color: done ? AppColors.earthDark : Colors.white),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // Pip — gives the clue
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: PipCharacterGuide(
                    state: _pipState,
                    speechBubbleText: _pipSpeech,
                    characterSize: 80,
                    onTap: () => ref.read(audioServiceProvider)
                        .playWordPronunciation(round['prompt'] as String),
                  ),
                ),

                // Prompt label
                Text(
                  round['prompt'] as String,
                  style: AppTypography.displayMedium.copyWith(
                    color: AppColors.earthDark,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Choice Object grid — 3 large illustrated tiles
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: _getOptionsForRound(round)
                          .map((opt) {
                        final word = opt['word'] as String;
                        final isSelected = _selectedCard == word;

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ChoiceObject(
                              emoji: opt['emoji'] as String,
                              label: word,
                              isSelected: isSelected,
                              isCorrect: isSelected ? _isCorrect : null,
                              isDisabled: _isCorrect == true,
                              baseColor: Color(opt['color'] as int),
                              emojiSize: size.width * 0.13,
                              height: size.height * 0.22,
                              onTap: () => _onCardTap(word),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Next round button
                AnimatedSwitcher(
                  duration: AppMotion.slideIn,
                  child: _isCorrect == true
                      ? Padding(
                          key: ValueKey('nextBtn_$_currentRound'),
                          padding:
                              const EdgeInsets.fromLTRB(24, 16, 24, 24),
                          child: AdventureButton(
                            text: _currentRound + 1 < _activeRounds.length
                                ? 'Next Animal! ▶'
                                : 'Finish Game! 🏆',
                            backgroundColor: AppColors.meadowGreen,
                            height: 64,
                            childAge: activeChild?.age ?? 6,
                            onPressed: _onNextRound,
                          ),
                        )
                      : SizedBox(key: ValueKey('spacer_$_currentRound'), height: 80),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
