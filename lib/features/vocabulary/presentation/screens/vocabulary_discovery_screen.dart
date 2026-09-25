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
import '../../../../core/widgets/pip_character_guide.dart';
import '../../../../core/widgets/reward_burst.dart';
import '../../../adventure_brain/domain/adaptive/mastery_engine.dart';
import '../../../adventure_brain/domain/adaptive/skill_dimension.dart';
import '../../../adventure_brain/presentation/providers/adventure_brain_providers.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';

/// Progressive vocabulary discovery screen.
///
/// BEFORE: White AppCard with word + phonetic + definition + sentence + value tip all visible.
/// AFTER: Illustrated scene. ONE large emoji creature. Word revealed big. Info layers revealed on tap.
///
/// Progressive reveal order:
///   1. Emoji creature (tappable → plays sound)
///   2. Word in heroWord style (shown immediately)
///   3. Example sentence (revealed after first audio play)
///   4. Islamic value tip (revealed after sentence is shown)
///   5. Next button appears last
class VocabularyDiscoveryScreen extends ConsumerStatefulWidget {
  final List<String>? targetVocabularyIds;

  const VocabularyDiscoveryScreen({super.key, this.targetVocabularyIds});

  @override
  ConsumerState<VocabularyDiscoveryScreen> createState() =>
      _VocabularyDiscoveryScreenState();
}

class _VocabularyDiscoveryScreenState
    extends ConsumerState<VocabularyDiscoveryScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _sentenceRevealed = false;
  bool _valueTipRevealed = false;

  late AnimationController _revealCtrl;
  late Animation<double> _creatureBounce;

  final List<Map<String, dynamic>> _vocabularyList = [
    {
      'id': 'vocab_elephant',
      'word': 'Elephant',
      'phonetic': '/ˈel.ɪ.fənt/',
      'emoji': '🐘',
      'definition': 'A very big animal with a long trunk.',
      'sentence': 'This is an elephant. It is big and gentle.',
      'colorHex': 0xFF52C97F,
      'valueTip': 'Elephants are gentle giants — just like us when we are kind.',
    },
    {
      'id': 'vocab_lion',
      'word': 'Lion',
      'phonetic': '/ˈlaɪ.ən/',
      'emoji': '🦁',
      'definition': 'The brave king of the jungle.',
      'sentence': 'This is a lion. The lion is brave.',
      'colorHex': 0xFFFF9F43,
      'valueTip': 'Courage and kindness make a true leader.',
    },
    {
      'id': 'vocab_cat',
      'word': 'Cat',
      'phonetic': '/kæt/',
      'emoji': '🐱',
      'definition': 'A soft, friendly pet that says meow.',
      'sentence': 'This is a cat. The cat is thirsty.',
      'colorHex': 0xFFFFD166,
      'valueTip': 'We speak softly to cats and never hurt them.',
    },
    {
      'id': 'vocab_bird',
      'word': 'Bird',
      'phonetic': '/bɜːd/',
      'emoji': '🐦',
      'definition': 'A beautiful animal with wings that sings.',
      'sentence': 'This is a bird. The bird is flying in the sky.',
      'colorHex': 0xFF4A9FD6,
      'valueTip': 'Birds sing beautifully every morning.',
    },
    {
      'id': 'vocab_water',
      'word': 'Water',
      'phonetic': '/ˈwɔː.tər/',
      'emoji': '💧',
      'definition': 'Clean liquid we drink to stay healthy.',
      'sentence': 'The kitten drinks clean water.',
      'colorHex': 0xFF4DB6AC,
      'valueTip': 'Giving water to a thirsty animal is an act of kindness.',
    },
    {
      'id': 'vocab_clean',
      'word': 'Clean',
      'phonetic': '/kliːn/',
      'emoji': '🧼',
      'definition': 'Not dirty — fresh and pure.',
      'sentence': 'We wash our hands with clean water.',
      'colorHex': 0xFF72D7A8,
      'valueTip': 'Keeping clean is a sign of care for ourselves.',
    },
    {
      'id': 'vocab_gentle',
      'word': 'Gentle',
      'phonetic': '/ˈdʒen.təl/',
      'emoji': '🤲',
      'definition': 'Kind, soft, and careful with others.',
      'sentence': 'We use gentle hands with little animals.',
      'colorHex': 0xFFB8A9F0,
      'valueTip': 'Gentleness makes everything more beautiful.',
    },
    {
      'id': 'vocab_big',
      'word': 'Big',
      'phonetic': '/bɪɡ/',
      'emoji': '🏔️',
      'definition': 'Large in size.',
      'sentence': 'The elephant is big.',
      'colorHex': 0xFF7E57C2,
      'valueTip': 'Big and small creatures all deserve love and care.',
    },
    {
      'id': 'vocab_small',
      'word': 'Small',
      'phonetic': '/smɔːl/',
      'emoji': '🐜',
      'definition': 'Little in size.',
      'sentence': 'The kitten is small.',
      'colorHex': 0xFF52C97F,
      'valueTip': 'Even the smallest creatures matter.',
    },
  ];

  List<Map<String, dynamic>> get _activeVocabularyList {
    if (widget.targetVocabularyIds != null && widget.targetVocabularyIds!.isNotEmpty) {
      final targets = widget.targetVocabularyIds!.toSet();
      final filtered = _vocabularyList.where((v) => targets.contains(v['id'])).toList();
      if (filtered.isNotEmpty) return filtered;
    }
    return _vocabularyList;
  }

  Map<String, dynamic> get _current =>
      _activeVocabularyList[_currentIndex.clamp(0, _activeVocabularyList.length - 1)];

  @override
  void initState() {
    super.initState();
    _revealCtrl = AnimationController(
        vsync: this, duration: AppMotion.characterReaction);
    _creatureBounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.20), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.20, end: 0.95), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _revealCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _revealCtrl.dispose();
    super.dispose();
  }

  void _onCreatureTap() {
    final item = _current;
    final vocabId = item['id'] as String;
    ref.read(audioServiceProvider).playWordPronunciation(
        '${item['word']}. ${item['sentence']}');
    _revealCtrl.reset();
    _revealCtrl.forward();
    setState(() {
      _sentenceRevealed = true;
    });
    // Value tip appears a moment after sentence
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _valueTipRevealed = true);
    });

    final activeChild = ref.read(activeChildProfileProvider);
    if (activeChild != null) {
      final repo = ref.read(vocabularyMasteryRepositoryProvider);
      final word = item['word'] as String;
      repo.getMastery(childId: activeChild.id, vocabularyId: vocabId).then((currentMastery) {
        final evidence = LearningEvidence(
          childId: activeChild.id,
          vocabularyId: vocabId,
          word: word,
          isCorrect: true,
          usedHint: false,
          dimension: SkillDimension.listening,
          listeningTested: true,
          listeningSuccess: true,
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

  void _onNext() {
    if (_currentIndex + 1 < _activeVocabularyList.length) {
      setState(() {
        _currentIndex++;
        _sentenceRevealed = false;
        _valueTipRevealed = false;
      });
      _revealCtrl.reset();
    } else {
      ref
          .read(activeChildProfileProvider.notifier)
          .completeActivity(
            'activity_animal_vocab',
            nextActivityId: 'activity_animal_hunt',
            xp: 20,
            coins: 10,
            stars: 3,
          );
      ref.read(audioServiceProvider).playSoundEffect(SoundEffect.levelComplete);
      RewardBurst.show(
        context,
        title: 'Word Explorer! 🌟',
        subtitle: 'You discovered all animal words!',
        xp: 20,
        coins: 10,
        stars: 3,
        onDismiss: () {
          Navigator.of(context).pop();
          context.pushReplacement(RouteNames.animalHunt);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final item = _current;
    final color = Color(item['colorHex'] as int);
    final worldTheme = WorldTheme.animalAdventure;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: worldTheme.backgroundColor,
      body: Stack(
        children: [
          // Scene background
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

          // ChildAppBar overlay
          Positioned(
            top: 0, left: 0, right: 0,
            child: ChildAppBar(
              title: 'Word ${_currentIndex + 1} of ${_activeVocabularyList.length}',
              showBack: true,
              stars: activeChild?.stars ?? 0,
              coins: activeChild?.coins ?? 0,
              worldTheme: worldTheme,
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 68), // below appBar

                // Pip instruction
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: PipCharacterGuide(
                    state: _sentenceRevealed ? PipState.happy : PipState.speaking,
                    speechBubbleText: _sentenceRevealed
                        ? 'Great! Hear the word again 🔊'
                        : 'Tap the ${item['emoji']} to hear the word!',
                    characterSize: 76,
                    showSpeechBubble: true,
                    onTap: _onCreatureTap,
                  ),
                ),

                const SizedBox(height: 12),

                // CREATURE — the hero of this screen
                Expanded(
                  child: Center(
                    child: ScaleTransition(
                      scale: _revealCtrl.isAnimating
                          ? _creatureBounce
                          : const AlwaysStoppedAnimation(1.0),
                      child: GestureDetector(
                        onTap: _onCreatureTap,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Large emoji creature
                              Container(
                                width: (size.width * 0.35).clamp(110.0, 160.0),
                                height: (size.width * 0.35).clamp(110.0, 160.0),
                                decoration: BoxDecoration(
                                  color: color.withAlpha(30),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: color.withAlpha(120), width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withAlpha(60),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  item['emoji'] as String,
                                  style: TextStyle(fontSize: (size.width * 0.18).clamp(56.0, 80.0)),
                                ),
                              ),
                              const SizedBox(height: 12),

                            // Word in heroWord style
                            Text(
                              item['word'] as String,
                              style: AppTypography.wordForAge(
                                      activeChild?.age ?? 6)
                                  .copyWith(color: color),
                            ),

                            // Phonetic (only for older ages)
                            if ((activeChild?.age ?? 6) >= 7) ...[
                              const SizedBox(height: 4),
                              Text(
                                item['phonetic'] as String,
                                style: AppTypography.phoneticText,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

                // PROGRESSIVE REVEAL: sentence
                AnimatedSwitcher(
                  duration: AppMotion.slideIn,
                  transitionBuilder: (child, anim) => SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(anim),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: _sentenceRevealed
                      ? Container(
                          key: ValueKey('sentence_$_currentIndex'),
                          margin:
                              const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(220),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: color.withAlpha(80), width: 1.5),
                          ),
                          child: Text(
                            '🗣️ "${item['sentence']}"',
                            style: AppTypography.sentenceText.copyWith(
                                color: AppColors.textPrimary),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SizedBox(key: ValueKey('empty_$_currentIndex'), height: 8),
                ),

                // PROGRESSIVE REVEAL: value tip
                AnimatedSwitcher(
                  duration: AppMotion.slideIn,
                  child: _valueTipRevealed
                      ? Container(
                          key: ValueKey('tip_$_currentIndex'),
                          margin:
                              const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.mintLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Text('🌿', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item['valueTip'] as String,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.mintDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(key: ValueKey('noTip_$_currentIndex'), height: 4),
                ),

                // Bottom navigation: back + next
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Row(
                    children: [
                      if (_currentIndex > 0) ...[
                        Expanded(
                          child: AdventureButton(
                            text: '◀ Back',
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textPrimary,
                            height: 56,
                            childAge: activeChild?.age ?? 6,
                            onPressed: () {
                              setState(() {
                                _currentIndex--;
                                _sentenceRevealed = false;
                                _valueTipRevealed = false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        flex: 2,
                        child: AdventureButton(
                          text: _sentenceRevealed
                              ? (_currentIndex + 1 < _vocabularyList.length
                                  ? 'Next Word ▶'
                                  : 'Play the Game! 🎮')
                              : 'Tap the ${item['emoji']} first!',
                          backgroundColor: _sentenceRevealed
                              ? AppColors.meadowGreen
                              : AppColors.lockGrey,
                          height: 60,
                          childAge: activeChild?.age ?? 6,
                          onPressed: _sentenceRevealed ? _onNext : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
