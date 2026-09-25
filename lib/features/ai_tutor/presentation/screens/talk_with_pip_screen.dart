import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/theme/world_themes.dart';
import 'package:kids_english_adventure/core/widgets/adventure_scaffold.dart';
import 'package:kids_english_adventure/core/widgets/audio_play_button.dart';
import 'package:kids_english_adventure/core/widgets/microphone_button.dart';
import 'package:kids_english_adventure/core/widgets/pip_character_guide.dart';
import 'package:kids_english_adventure/core/widgets/reward_burst.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import 'package:kids_english_adventure/features/adventure_brain/presentation/providers/adventure_brain_providers.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_conversation_turn.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/scripted_dialogue_engine.dart';
import 'package:kids_english_adventure/features/ai_tutor/presentation/controllers/ai_conversation_controller.dart';
import 'package:kids_english_adventure/features/ai_tutor/presentation/providers/ai_tutor_providers.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';

/// "Talk with Pip" 🦜 Animated Character Dialogue Stage for Children.
///
/// Visual Layout:
/// - Painted adventure world background
/// - Pip center-stage with animated speech bubbles
/// - Audio repeat button
/// - Large microphone + quick response choice pills
/// - RewardBurst celebration at completion
class TalkWithPipScreen extends ConsumerStatefulWidget {
  final AiCurriculumContext context;
  final String? initialPrompt;

  const TalkWithPipScreen({
    super.key,
    required this.context,
    this.initialPrompt,
  });

  @override
  ConsumerState<TalkWithPipScreen> createState() => _TalkWithPipScreenState();
}

class _TalkWithPipScreenState extends ConsumerState<TalkWithPipScreen> {
  late AiConversationController _controller;

  @override
  void initState() {
    super.initState();
    final tutorService = ref.read(aiTutorServiceProvider);
    final settings = ref.read(aiParentSettingsProvider);
    final activeChild = ref.read(activeChildProfileProvider);

    final session = tutorService.startSession(
      childId: activeChild?.id ?? 'child_default',
      context: widget.context,
      settings: settings,
    );

    final defaultScriptedPrompt = ScriptedDialogueEngine.getInitialPrompt(widget.context);

    _controller = AiConversationController(
      tutorService: tutorService,
      context: widget.context,
      settings: settings,
      initialSession: session,
      initialPrompt: widget.initialPrompt ?? defaultScriptedPrompt.text,
    );

    _controller.addListener((_) {
      if (mounted) setState(() {});
    });

    // Speak initial prompt automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lastTurn = _controller.currentState.turns.lastOrNull;
      if (lastTurn != null && lastTurn.speaker == AiSpeaker.character) {
        ref.read(audioServiceProvider).playDialogue('Pip', lastTurn.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSpeechResult(String spokenText, double similarity) {
    _controller.submitChildInput(
      text: spokenText,
      inputType: AiInputType.speech,
    );
    ref.read(audioServiceProvider).playSuccess();

    final activeChild = ref.read(activeChildProfileProvider);
    if (activeChild != null && widget.context.targetVocabulary.isNotEmpty) {
      final repo = ref.read(vocabularyMasteryRepositoryProvider);
      final vocabId = widget.context.targetVocabulary.first;
      repo.getMastery(childId: activeChild.id, vocabularyId: vocabId).then((currentMastery) {
        final evidence = LearningEvidence(
          childId: activeChild.id,
          vocabularyId: vocabId,
          word: vocabId.replaceFirst('vocab_', ''),
          isCorrect: similarity >= 0.5,
          dimension: SkillDimension.speaking,
          practicedPronunciation: true,
          pronunciationAccurate: similarity >= 0.7,
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

  void _onSendTapChoice(String choice) {
    _controller.submitChildInput(
      text: choice,
      inputType: AiInputType.tapChoice,
    );
    ref.read(audioServiceProvider).playSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.currentState;
    final activeChild = ref.watch(activeChildProfileProvider);
    final worldTheme = WorldTheme.schoolClassroom;

    if (state.isSessionComplete) {
      final summary = state.sessionSummary;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        RewardBurst.show(
          context,
          title: summary?.childTitle ?? 'Awesome Speaking! 🦜🎉',
          subtitle: summary?.childEncouragement ?? 'You practiced speaking with Pip like a champion!',
          xp: 35,
          coins: 20,
          stars: 3,
          onDismiss: () {
            ref.read(activeChildProfileProvider.notifier).completeActivity(
                  'activity_talk_with_pip',
                  xp: 35,
                  coins: 20,
                  stars: 3,
                );
            context.pop();
          },
        );
      });

      return Scaffold(
        backgroundColor: worldTheme.backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Get current Pip turn text and suggested responses
    final lastPipTurn = state.turns.where((t) => t.speaker == AiSpeaker.character).lastOrNull;
    final pipText = lastPipTurn?.text ?? "Hello! Let's practice English together!";
    final suggestedChoices = const ['Yes, I do!', 'It is sunny ☀️', 'Thank you! 😊'];

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
              title: 'Talk with Pip 🦜',
              showBack: true,
              stars: activeChild?.stars ?? 0,
              coins: activeChild?.coins ?? 0,
              worldTheme: worldTheme,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  const SizedBox(height: 68),

                  // Turns indicator pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: worldTheme.accentColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: worldTheme.accentColor.withAlpha(40),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Turn ${state.session.turnCount + 1} ✨ (${widget.context.mode.displayName})',
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: worldTheme.accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Center Pip Character Guide with Speech Bubble
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PipCharacterGuide(
                              state: state.isGenerating
                                  ? PipState.hinting
                                  : (_controller.currentState.turns.length > 2 ? PipState.happy : PipState.speaking),
                              speechBubbleText: pipText,
                              characterSize: 100,
                            ),
                            const SizedBox(height: 12),
                            AudioPlayButton(
                              textToSpeak: pipText,
                              label: 'Hear Pip 🔊',
                              size: 46,
                              priority: AudioPriority.characterDialogue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Reply Stage: Big Microphone or Quick Response Choices
                  if (state.isGenerating)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(color: AppColors.lavenderDark),
                    )
                  else ...[
                    // Suggested Reply Buttons
                    Column(
                      children: suggestedChoices.map((choice) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () => _onSendTapChoice(choice),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: worldTheme.accentColor.withAlpha(120), width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: worldTheme.accentColor.withAlpha(30),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Text('💬', style: TextStyle(fontSize: 20)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(choice, style: AppTypography.headlineMedium.copyWith(fontSize: 18)),
                                  ),
                                  Icon(Icons.touch_app_rounded, color: worldTheme.accentColor),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),

                    // Microphone Button
                    MicrophoneButton(
                      targetPhrase: suggestedChoices.isNotEmpty ? suggestedChoices.first : 'Hello Pip',
                      size: 76,
                      onSpeechResult: _onSpeechResult,
                      onHearAlternative: () => ref.read(audioServiceProvider).playSentence(pipText),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
