import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/experience/age_experience_profile.dart';
import '../../../../core/experience/child_experience_controller.dart';
import '../../../../core/experience/interactive_activity_engine.dart';
import '../../../../core/experience/interactive_activity_integrity_validator.dart';
import '../../../../core/experience/interactive_scene_object.dart';
import '../../../../core/experience/interactive_session_composer.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/child_table_visual.dart';
import '../../../../core/widgets/pip_character_guide.dart';
import '../../../../core/widgets/reward_burst.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../../curriculum/domain/models/learning_age_band.dart';

/// Production multi-step interactive session screen executing age-adapted learning experiences.
/// Hosts persistent scenes (e.g. Pip's Picnic) and enforces strict semantic object contracts.
class InteractiveSessionScreen extends ConsumerStatefulWidget {
  final InteractiveLessonSession session;
  final int initialStepIndex;

  const InteractiveSessionScreen({
    super.key,
    required this.session,
    this.initialStepIndex = 0,
  });

  @override
  ConsumerState<InteractiveSessionScreen> createState() =>
      _InteractiveSessionScreenState();
}

class _InteractiveSessionScreenState
    extends ConsumerState<InteractiveSessionScreen>
    with TickerProviderStateMixin {
  int _currentStepIndex = 0;
  bool _isStepCompleted = false;
  bool _isSessionFinished = false;
  bool _hasTappedOrDroppedAny = false;
  int _attemptCount = 0;
  String _pipMessage = '';
  PipState _pipState = PipState.idle;

  bool _isMicListening = false;

  late AnimationController _reactionCtrl;
  late Animation<double> _scaleAnimation;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnimation;
  Timer? _autoAdvanceTimer;

  InteractiveActivityConfig get _currentConfig =>
      widget.session.activities[_currentStepIndex];

  @override
  void initState() {
    super.initState();
    _currentStepIndex = widget.initialStepIndex;
    _reactionCtrl = AnimationController(
      vsync: this,
      duration: AppMotion.characterReaction,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 0.94), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.94, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _reactionCtrl, curve: Curves.easeOut));

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _initializeCurrentStep();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _reactionCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _initializeCurrentStep() {
    _isStepCompleted = false;
    _attemptCount = 0;

    final config = _currentConfig;
    _pipMessage = config.instructionOverride ??
        config.ageProfile.adaptPrompt(config.conceptId);
    _pipState = PipState.speaking;

    ref.read(audioServiceProvider).playWordPronunciation(
          config.audioPromptOverride ?? config.conceptId,
        );
  }

  void _triggerSuccessReaction({required String customMessage}) {
    if (_isStepCompleted) return;
    setState(() {
      _isStepCompleted = true;
      _pipState = PipState.celebrating;
      _pipMessage = customMessage;
    });

    _reactionCtrl.forward(from: 0.0);
    ref.read(audioServiceProvider).playSoundEffect(SoundEffect.correct);

    // Record evidence quietly
    ref.read(childExperienceControllerProvider).onCorrectAnswer(
          isIndependent: _attemptCount == 0,
          ageBand: _currentConfig.ageProfile.ageBand,
        );

    final isLastStep = _currentStepIndex + 1 >= widget.session.activities.length;
    if (isLastStep) {
      _completeEntireSession();
    } else {
      // Auto-advance after gentle pause for Pre-A children (no confusing buttons)
      if (widget.session.ageProfile.ageBand == LearningAgeBand.bandPreALittleListeners) {
        _autoAdvanceTimer = Timer(const Duration(milliseconds: 1400), () {
          if (mounted && !_isSessionFinished) {
            _advanceToNextStep();
          }
        });
      }
    }
  }

  void _advanceToNextStep() {
    _autoAdvanceTimer?.cancel();
    if (_currentStepIndex + 1 < widget.session.activities.length) {
      setState(() {
        _currentStepIndex++;
        _initializeCurrentStep();
      });
    }
  }

  void _completeEntireSession() {
    _isSessionFinished = true;
    ref.read(activeChildProfileProvider.notifier).completeActivity(
          widget.session.lessonId,
          xp: widget.session.rewardXp,
          coins: widget.session.rewardCoins,
          stars: widget.session.rewardStars,
        );
    ref.read(audioServiceProvider).playSoundEffect(SoundEffect.levelComplete);
  }

  void _handleObjectTap(InteractiveSceneObject object) {
    if (_isStepCompleted) return;
    _hasTappedOrDroppedAny = true;

    final targetId = _currentConfig.targetObjectId;
    if (object.objectId == targetId) {
      _triggerSuccessReaction(
        customMessage: _currentConfig.successReactionPrompt ??
            object.reactionPrompt ??
            'Great touch! 🌟',
      );
    } else {
      _attemptCount++;
      ref.read(childExperienceControllerProvider).onGentleRetry(
            ageBand: _currentConfig.ageProfile.ageBand,
          );
      setState(() {
        _pipState = PipState.encouraging;
        _pipMessage = _currentConfig.ageProfile.ageBand == LearningAgeBand.bandPreALittleListeners
            ? 'Listen! 👂'
            : 'Almost! Let\'s try again. 😊';
      });
    }
  }

  void _handleSuccessfulDrop() {
    if (_isStepCompleted) return;
    _hasTappedOrDroppedAny = true;

    final customMsg = _currentConfig.successReactionPrompt ?? 'Wonderful! 🌟';
    _triggerSuccessReaction(customMessage: customMsg);
  }

  void _handleSpeechAttempt() {
    if (_isStepCompleted) return;
    setState(() {
      _isMicListening = true;
      _pipState = PipState.listening;
      _pipMessage = 'Listening to your voice... 🎙️✨';
    });

    // Graceful evaluation with guaranteed progression
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _isMicListening = false;
      });

      final customMsg = _currentConfig.successReactionPrompt ?? 'Wonderful! 🌟';
      _triggerSuccessReaction(customMessage: customMsg);
    });
  }

  void _safeEarlyExit() {
    _autoAdvanceTimer?.cancel();
    if (_hasTappedOrDroppedAny) {
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            widget.session.lessonId,
            xp: 10,
            coins: 5,
            stars: 1,
          );
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final profile = _currentConfig.ageProfile;
    final scene = _currentConfig.scene;

    return Scaffold(
      backgroundColor: scene.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Header Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Safe Exit Button
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 28),
                        onPressed: _safeEarlyExit,
                        tooltip: 'Safe Exit',
                      ),

                      // Progression Indicator
                      _buildProgressIndicator(profile),

                      // Audio Replay Button
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, size: 28),
                        onPressed: () {
                          ref.read(audioServiceProvider).playWordPronunciation(
                                _currentConfig.audioPromptOverride ?? _currentConfig.conceptId,
                              );
                        },
                        tooltip: 'Hear Again',
                      ),
                    ],
                  ),
                ),

                // Mascot Prompt Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(240),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      PipCharacterGuide(
                        state: _pipState,
                        characterSize: profile.ageBand == LearningAgeBand.bandPreALittleListeners
                            ? 64
                            : (profile.ageBand == LearningAgeBand.bandCGrowingSpeakers ? 44 : 52),
                        showSpeechBubble: false,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _pipMessage,
                          style: profile.ageBand == LearningAgeBand.bandPreALittleListeners
                              ? AppTypography.headlineMedium.copyWith(
                                  color: AppColors.earthDark,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                              : (profile.ageBand == LearningAgeBand.bandCGrowingSpeakers
                                  ? AppTypography.titleLarge.copyWith(
                                      color: AppColors.earthDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    )
                                  : AppTypography.titleLarge.copyWith(
                                      color: AppColors.earthDark,
                                      fontSize: 18,
                                    )),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Interactive Stage
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildMechanicStage(profile),
                    ),
                  ),
                ),

                // Next Step Button (if completed and not Pre-A auto-advancing)
                if (_isStepCompleted && !_isSessionFinished && profile.ageBand != LearningAgeBand.bandPreALittleListeners)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.roundedLg,
                          ),
                        ),
                        onPressed: _advanceToNextStep,
                        child: Text(
                          'Next Challenge 🚀',
                          style: AppTypography.buttonText,
                        ),
                      ),
                    ),
                  ),

                // Finished Session Done Button
                if (_isSessionFinished)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sunYellow,
                          foregroundColor: AppColors.earthDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.roundedLg,
                          ),
                        ),
                        onPressed: () => context.pop(),
                        child: Text(
                          profile.ageBand == LearningAgeBand.bandPreALittleListeners
                              ? 'Yay! All Done! ⭐'
                              : 'Complete Adventure 🌟',
                          style: AppTypography.buttonText.copyWith(color: AppColors.earthDark),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Final Session Celebration Burst
            if (_isSessionFinished)
              Positioned.fill(
                child: IgnorePointer(
                  child: RewardBurst(
                    title: profile.ageBand == LearningAgeBand.bandPreALittleListeners
                        ? 'Yay! ⭐'
                        : 'Adventure Complete! 🎉',
                    stars: widget.session.rewardStars,
                    coins: widget.session.rewardCoins,
                    xp: widget.session.rewardXp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(AgeExperienceProfile profile) {
    if (profile.ageBand == LearningAgeBand.bandPreALittleListeners) {
      // Subtle visual progress dots for Pre-A (zero test framing, no "Step X of Y")
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.session.activities.length, (idx) {
          final isDone = idx < _currentStepIndex || (idx == _currentStepIndex && _isStepCompleted);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              isDone ? '●' : '○',
              style: TextStyle(
                fontSize: 22,
                color: isDone ? AppColors.secondary : Colors.grey.shade400,
              ),
            ),
          );
        }),
      );
    }

    // Clean step indicator for older learners
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.roundedPill,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        'Step ${_currentStepIndex + 1} of ${widget.session.activities.length}',
        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMechanicStage(AgeExperienceProfile profile) {
    // Defense-in-depth: Validate activity integrity before rendering UI
    final errors = InteractiveActivityIntegrityValidator.validateActivity(_currentConfig);
    if (errors.isNotEmpty) {
      debugPrint('[InteractiveSessionScreen] CRITICAL: Invalid activity ${_currentConfig.id} rejected: $errors');
      return _buildSafeFallbackStage(profile);
    }

    switch (_currentConfig.mechanicType) {
      case ActivityMechanicType.listenAndTouch:
        return _buildTouchStage(profile);
      case ActivityMechanicType.dragAndDrop:
      case ActivityMechanicType.feedCharacter:
      case ActivityMechanicType.scenePlacement:
      case ActivityMechanicType.interactiveStory:
        return _buildDragAndDropStage(profile);
      case ActivityMechanicType.speakToMakeSomethingHappen:
        return _buildSpeakToMakeSomethingHappenStage(profile);
      case ActivityMechanicType.conversationRolePlay:
        return _buildRolePlayStage(profile);
    }
  }

  Widget _buildSafeFallbackStage(AgeExperienceProfile profile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star_rounded, size: 80, color: AppColors.sunYellow),
          const SizedBox(height: 16),
          Text(
            'Let\'s explore together! 🌟',
            style: AppTypography.headlineMedium.copyWith(color: AppColors.earthDark),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: () {
              _triggerSuccessReaction(customMessage: 'Great job! ⭐');
            },
            child: Text(
              'Continue ✨',
              style: AppTypography.buttonText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTouchStage(AgeExperienceProfile profile) {
    // Determine target and distractors explicitly
    final targetObj = _currentConfig.draggableObject ??
        _currentConfig.scene.objects.firstWhere(
          (o) => o.objectId == _currentConfig.targetObjectId,
          orElse: () => _currentConfig.scene.objects.first,
        );

    final List<InteractiveSceneObject> displayChoices = [];
    displayChoices.add(targetObj);

    if (_currentConfig.distractors.isNotEmpty) {
      for (final dist in _currentConfig.distractors) {
        if (!displayChoices.any((d) => d.objectId == dist.objectId)) {
          displayChoices.add(dist);
        }
      }
    } else {
      for (final obj in _currentConfig.scene.objects) {
        if (obj.objectId != targetObj.objectId &&
            !displayChoices.any((d) => d.objectId == obj.objectId)) {
          displayChoices.add(obj);
        }
      }
    }

    final choices = displayChoices
        .take(profile.numberOfChoices.clamp(2, displayChoices.length))
        .toList();

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.center,
        children: choices.map((obj) {
          final isTarget = obj.objectId == _currentConfig.targetObjectId;
          return GestureDetector(
            onTap: () => _handleObjectTap(obj),
            child: Container(
              constraints: BoxConstraints(
                minWidth: profile.visualTargetSize,
                minHeight: profile.visualTargetSize,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isTarget && _isStepCompleted
                      ? AppColors.secondary
                      : Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (obj.conceptId == 'concept_table')
                    ChildTableVisual(
                      width: profile.visualTargetSize * 0.85,
                      height: profile.visualTargetSize * 0.60,
                    )
                  else
                    Text(
                      obj.emoji,
                      style: TextStyle(fontSize: profile.visualTargetSize * 0.45),
                    ),
                  if (profile.textDensity != TextDensity.zero) ...[
                    const SizedBox(height: 4),
                    Text(
                      obj.label,
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: profile.ageBand == LearningAgeBand.bandCGrowingSpeakers ? 12 : 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDragAndDropStage(AgeExperienceProfile profile) {
    final config = _currentConfig;

    // 1. Explicit semantic role resolution
    final draggableObj = config.draggableObject ??
        config.requestedObject ??
        config.scene.objects.firstWhere(
          (o) => o.objectId == config.targetObjectId,
          orElse: () => config.scene.objects.first,
        );

    final targetDestination = config.dropTarget ??
        config.sceneActor ??
        config.scene.objects.firstWhere(
          (o) => o.objectId == config.targetDestinationId,
          orElse: () => config.scene.objects.last,
        );

    // 2. Format drop target visual state based on completion
    String targetDisplayEmoji = targetDestination.emoji;
    if (_isStepCompleted) {
      if (config.mechanicType == ActivityMechanicType.feedCharacter) {
        if (targetDestination.conceptId == 'concept_rabbit') {
          targetDisplayEmoji = '🐰😋';
        } else if (targetDestination.conceptId == 'concept_pip') {
          targetDisplayEmoji = '🐥✨';
        } else {
          targetDisplayEmoji = '😋';
        }
      } else if (config.mechanicType == ActivityMechanicType.dragAndDrop) {
        if (targetDestination.conceptId == 'concept_basket') {
          targetDisplayEmoji = '🧺${draggableObj.emoji}';
        }
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Drop Destination Target at Top/Center
        DragTarget<String>(
          onWillAcceptWithDetails: (details) => !_isStepCompleted,
          onAcceptWithDetails: (details) => _handleSuccessfulDrop(),
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;
            return Container(
              constraints: const BoxConstraints(minWidth: 140, minHeight: 140),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isHovering
                    ? AppColors.secondaryLight
                    : Colors.white.withAlpha(235),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: isHovering
                      ? AppColors.secondary
                      : (_isStepCompleted ? AppColors.secondary : AppColors.primary),
                  width: isHovering ? 4 : 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (targetDestination.conceptId == 'concept_table')
                    ChildTableVisual(
                      width: 140,
                      height: 95,
                      hasBookOnTop: _isStepCompleted,
                      isHovered: isHovering,
                    )
                  else
                    Text(
                      targetDisplayEmoji,
                      style: const TextStyle(fontSize: 54),
                    ),
                  if (profile.textDensity != TextDensity.zero) ...[
                    const SizedBox(height: 6),
                    Text(
                      _isStepCompleted
                          ? (config.successReactionPrompt ?? targetDestination.label)
                          : targetDestination.label,
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            );
          },
        ),

        // Directional affordance pointing upward from draggable toward drop target (never downward!)
        if (!_isStepCompleted)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1.0 - _pulseAnimation.value) * 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.keyboard_double_arrow_up_rounded,
                      size: 32,
                      color: AppColors.secondary.withAlpha(180),
                    ),
                    if (profile.ageBand != LearningAgeBand.bandPreALittleListeners) ...[
                      const SizedBox(width: 4),
                      Text(
                        'Drag here',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.secondaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),

        // Draggable Object with gentle pulsing affordance
        if (!_isStepCompleted)
          Draggable<String>(
            data: draggableObj.objectId,
            feedback: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: profile.visualTargetSize,
                  minHeight: profile.visualTargetSize,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: draggableObj.conceptId == 'concept_table'
                      ? ChildTableVisual(
                          width: profile.visualTargetSize * 0.85,
                          height: profile.visualTargetSize * 0.60,
                        )
                      : Text(
                          draggableObj.emoji,
                          style: TextStyle(fontSize: profile.visualTargetSize * 0.5),
                        ),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.25,
              child: _buildCardIcon(profile, draggableObj),
            ),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: _buildCardIcon(profile, draggableObj),
                );
              },
            ),
          )
        else
          Text('✨ Done! ✨', style: AppTypography.headlineLarge),
      ],
    );
  }

  Widget _buildCardIcon(AgeExperienceProfile profile, InteractiveSceneObject obj) {
    final isTable = obj.conceptId == 'concept_table';
    return Container(
      constraints: BoxConstraints(
        minWidth: profile.visualTargetSize,
        minHeight: profile.visualTargetSize,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isTable)
            ChildTableVisual(
              width: profile.visualTargetSize * 0.85,
              height: profile.visualTargetSize * 0.60,
            )
          else
            Text(
              obj.emoji,
              style: TextStyle(fontSize: profile.visualTargetSize * 0.45),
            ),
          if (profile.textDensity != TextDensity.zero) ...[
            const SizedBox(height: 2),
            Text(
              obj.label,
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: profile.ageBand == LearningAgeBand.bandCGrowingSpeakers ? 12 : 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpeakToMakeSomethingHappenStage(AgeExperienceProfile profile) {
    final target = _currentConfig.draggableObject ??
        _currentConfig.scene.objects.firstWhere(
          (o) => o.objectId == _currentConfig.targetObjectId,
          orElse: () => _currentConfig.scene.objects.first,
        );

    final bool isDoor = target.conceptId == 'concept_door';
    final String openVisual = isDoor ? '🚪🔓' : '${target.emoji}✨';
    final String closedVisual = isDoor ? '🚪🔒' : target.emoji;
    final String promptPhrase = _currentConfig.speakTriggerPhrase ?? 'Speak';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Interactive Scene Element
        Container(
          width: 140,
          height: 180,
          decoration: BoxDecoration(
            color: _isStepCompleted ? const Color(0xFFC8E6C9) : const Color(0xFFFFE0B2),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isStepCompleted ? AppColors.secondary : Colors.brown,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isStepCompleted ? openVisual : closedVisual,
                style: const TextStyle(fontSize: 60),
              ),
              const SizedBox(height: 8),
              if (profile.textDensity != TextDensity.zero)
                Text(
                  _isStepCompleted ? 'OPEN!' : 'CLOSED',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isStepCompleted ? AppColors.secondaryDark : Colors.brown,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Microphone Button
        GestureDetector(
          onTap: _handleSpeechAttempt,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: _isMicListening ? Colors.redAccent : AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_isMicListening ? Colors.redAccent : AppColors.primary).withAlpha(90),
                  blurRadius: _isMicListening ? 24 : 12,
                  spreadRadius: _isMicListening ? 6 : 2,
                ),
              ],
            ),
            child: Icon(
              _isMicListening ? Icons.mic : Icons.mic_none_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),

        const SizedBox(height: 12),
        if (profile.textDensity != TextDensity.zero)
          Text(
            'Say: "$promptPhrase"',
            style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),

        // Touch Fallback for Pre-A or silent children
        const SizedBox(height: 16),
        TextButton.icon(
          icon: const Icon(Icons.touch_app_rounded, color: AppColors.secondaryDark),
          label: Text(
            profile.ageBand == LearningAgeBand.bandPreALittleListeners
                ? 'Or tap here 👆'
                : 'Or tap here to complete',
          ),
          onPressed: () {
            _triggerSuccessReaction(
              customMessage: _currentConfig.successReactionPrompt ?? 'Success! 🌟',
            );
          },
        ),
      ],
    );
  }

  Widget _buildRolePlayStage(AgeExperienceProfile profile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Roleplay Scene Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              const Text('🧺 🥪 🥤', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 8),
              Text(
                'Picnic Conversation',
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                _currentConfig.rolePlayPipPrompt ?? 'What would you like at the picnic?',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.earthDark),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Response choice
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.primaryDark,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            _triggerSuccessReaction(
              customMessage: _currentConfig.successReactionPrompt ?? 'Enjoy your picnic! 🧺✨',
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💧', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                _currentConfig.rolePlayExpectedResponse ?? 'Water, please. 😊',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
