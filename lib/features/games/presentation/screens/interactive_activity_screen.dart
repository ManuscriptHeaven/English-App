import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/experience/age_experience_profile.dart';
import '../../../../core/experience/child_experience_controller.dart';
import '../../../../core/experience/interactive_activity_engine.dart';
import '../../../../core/experience/interactive_scene_object.dart';
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

/// Production-grade, age-adaptive interactive screen hosting the 7 Core Mechanics.
class InteractiveActivityScreen extends ConsumerStatefulWidget {
  final InteractiveActivityConfig config;

  const InteractiveActivityScreen({
    super.key,
    required this.config,
  });

  @override
  ConsumerState<InteractiveActivityScreen> createState() =>
      _InteractiveActivityScreenState();
}

class _InteractiveActivityScreenState
    extends ConsumerState<InteractiveActivityScreen>
    with SingleTickerProviderStateMixin {
  bool _isCompleted = false;
  bool _hasTappedOrDropped = false;
  bool _isActionActive = false;
  int _attemptCount = 0;
  String _pipMessage = '';
  PipState _pipState = PipState.idle;

  // 5-Step Speaking Fallback State
  SpeakingFallbackStep _speakingStep = SpeakingFallbackStep.initialPrompt;
  bool _isMicListening = false;

  late AnimationController _reactionCtrl;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _reactionCtrl = AnimationController(
      vsync: this,
      duration: AppMotion.characterReaction,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 0.94), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.94, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _reactionCtrl, curve: Curves.easeOut));

    _initializePrompt();
  }

  @override
  void dispose() {
    _reactionCtrl.dispose();
    super.dispose();
  }

  void _initializePrompt() {
    final profile = widget.config.ageProfile;
    switch (widget.config.mechanicType) {
      case ActivityMechanicType.listenAndTouch:
        _pipMessage = profile.adaptPrompt('apple');
        _pipState = PipState.speaking;
        break;
      case ActivityMechanicType.dragAndDrop:
        _pipMessage = profile.ageBand == LearningAgeBand.bandPreALittleListeners
            ? 'Put the apple in the basket! 🍎'
            : 'Drag the apple into the basket. 🧺';
        _pipState = PipState.speaking;
        break;
      case ActivityMechanicType.feedCharacter:
        _pipMessage = 'The rabbit is hungry! Give it an apple. 🐰🍎';
        _pipState = PipState.speaking;
        break;
      case ActivityMechanicType.scenePlacement:
        _pipMessage = 'Put the ball under the table. ⚽';
        _pipState = PipState.speaking;
        break;
      case ActivityMechanicType.speakToMakeSomethingHappen:
        _pipMessage = profile.ageBand == LearningAgeBand.bandPreALittleListeners
            ? 'Say: Open the door! 🚪'
            : 'Say "Open the door" to walk inside! 🎙️';
        _pipState = PipState.speaking;
        break;
      case ActivityMechanicType.interactiveStory:
        _pipMessage = widget.config.storySegmentText ?? 'Help the little bird drink water! 🐦💧';
        _pipState = PipState.speaking;
        break;
      case ActivityMechanicType.conversationRolePlay:
        _pipMessage = widget.config.rolePlayPipPrompt ?? 'What would you like? 🧺';
        _pipState = PipState.speaking;
        break;
    }
  }

  void _triggerSuccessReaction({String? customMessage}) {
    if (_isCompleted) return; // Debounce rapid taps
    _isCompleted = true;
    _isActionActive = true;

    _reactionCtrl.forward(from: 0.0);

    final exp = ref.read(childExperienceControllerProvider);
    exp.onCorrectAnswer(
      isIndependent: _attemptCount == 0,
      conceptId: widget.config.conceptId,
      attempts: _attemptCount + 1,
      ageBand: widget.config.ageProfile.ageBand,
    );

    setState(() {
      _pipState = PipState.happy;
      _pipMessage = customMessage ?? 'You did it! 🌟';
    });

    // Save learning progress safely
    ref.read(activeChildProfileProvider.notifier).completeActivity(
          widget.config.id,
          xp: 20,
          coins: 10,
          stars: 3,
        );
  }

  void _handleObjectTap(InteractiveSceneObject object) {
    if (_isCompleted) return;
    _hasTappedOrDropped = true;

    if (object.objectId == widget.config.targetObjectId) {
      _triggerSuccessReaction(
        customMessage: object.reactionPrompt ?? 'Great touch! 🌟',
      );
    } else {
      _attemptCount++;
      ref.read(childExperienceControllerProvider).onGentleRetry(
            ageBand: widget.config.ageProfile.ageBand,
          );
      setState(() {
        _pipState = PipState.encouraging;
        _pipMessage = widget.config.ageProfile.ageBand == LearningAgeBand.bandPreALittleListeners
            ? 'Listen! 👂'
            : 'Almost! Let\'s try again. 😊';
      });
    }
  }

  void _handleSuccessfulDrop() {
    if (_isCompleted) return;
    _hasTappedOrDropped = true;

    String customMsg = 'Wonderful! 🌟';
    if (widget.config.mechanicType == ActivityMechanicType.feedCharacter) {
      customMsg = 'Nom nom! The rabbit is eating an apple! 🐰🍎';
    } else if (widget.config.mechanicType == ActivityMechanicType.scenePlacement) {
      customMsg = 'The ball is under the table! ⚽';
    } else if (widget.config.mechanicType == ActivityMechanicType.interactiveStory) {
      customMsg = 'The bird drinks the cool water! Chirp chirp! 🐦💧';
    }

    _triggerSuccessReaction(customMessage: customMsg);
  }

  void _handleSpeechAttempt() {
    if (_isCompleted) return;
    setState(() {
      _isMicListening = true;
      _pipState = PipState.listening;
      _pipMessage = 'Listening to your voice... 🎙️✨';
    });

    // Simulated graceful evaluation with fallback progression
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isMicListening = false;
      });

      // Advance fallback steps if struggling
      if (_attemptCount == 0) {
        _triggerSuccessReaction(customMessage: 'The door opened! Come inside! 🚪✨');
      } else {
        setState(() {
          _speakingStep = SpeakingFallbackStep.touchFallback;
          _pipMessage = 'You can also tap the door! 🚪👆';
          _pipState = PipState.encouraging;
        });
      }
    });
  }

  void _safeEarlyExit() {
    // Section 38: Never punish short sessions for young children; save progress silently
    if (_hasTappedOrDropped) {
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            widget.config.id,
            xp: 10,
            coins: 5,
            stars: 1,
          );
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.config.ageProfile;
    final scene = widget.config.scene;

    // Limit visible objects according to profile's numberOfChoices
    final visibleObjects = scene.objects
        .take(profile.numberOfChoices.clamp(2, scene.objects.length))
        .toList();

    return Scaffold(
      backgroundColor: scene.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Action Bar with Pre-A Safety Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Safe Exit Button (No penalty, saves progress)
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 28),
                        onPressed: _safeEarlyExit,
                        tooltip: 'Safe Exit',
                      ),
                      // Concept Badge (Non-reading style for Pre-A)
                      if (profile.textDensity != TextDensity.zero)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
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
                            scene.title,
                            style: AppTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        Text(
                          scene.backgroundIcon,
                          style: const TextStyle(fontSize: 28),
                        ),
                      // Replay Audio Button
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, size: 28),
                        onPressed: () {
                          ref.read(audioServiceProvider).playWordPronunciation(
                                widget.config.conceptId,
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
                  padding: const EdgeInsets.all(12),
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
                        characterSize: profile.ageBand == LearningAgeBand.bandPreALittleListeners ? 64 : 52,
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
                                )
                              : AppTypography.titleLarge.copyWith(
                                  color: AppColors.earthDark,
                                  fontSize: 17,
                                ),
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
                      child: _buildMechanicStage(profile, visibleObjects),
                    ),
                  ),
                ),

                // Action Confirmation / Continue Button
                if (_isCompleted)
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
                        onPressed: () => context.pop(),
                        child: Text(
                          profile.ageBand == LearningAgeBand.bandPreALittleListeners
                              ? 'Yay! ⭐'
                              : 'Next Adventure 🚀',
                          style: AppTypography.buttonText,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Celebration Burst
            if (_isCompleted)
              Positioned.fill(
                child: IgnorePointer(
                  child: RewardBurst(
                    title: profile.ageBand == LearningAgeBand.bandPreALittleListeners
                        ? 'Yay! 🌟'
                        : 'Adventure Complete! 🎉',
                    stars: 3,
                    coins: 10,
                    xp: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMechanicStage(
    AgeExperienceProfile profile,
    List<InteractiveSceneObject> objects,
  ) {
    switch (widget.config.mechanicType) {
      case ActivityMechanicType.listenAndTouch:
        return _buildTouchStage(profile, objects);
      case ActivityMechanicType.dragAndDrop:
      case ActivityMechanicType.feedCharacter:
      case ActivityMechanicType.scenePlacement:
      case ActivityMechanicType.interactiveStory:
        return _buildDragAndDropStage(profile, objects);
      case ActivityMechanicType.speakToMakeSomethingHappen:
        return _buildSpeakToMakeSomethingHappenStage(profile);
      case ActivityMechanicType.conversationRolePlay:
        return _buildRolePlayStage(profile);
    }
  }

  Widget _buildTouchStage(
    AgeExperienceProfile profile,
    List<InteractiveSceneObject> objects,
  ) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.center,
        children: objects.map((obj) {
          final isTarget = obj.objectId == widget.config.targetObjectId;
          return GestureDetector(
            onTap: () => _handleObjectTap(obj),
            child: Container(
              width: profile.visualTargetSize,
              height: profile.visualTargetSize,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isTarget && _isCompleted
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        fontSize: 14,
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

  Widget _buildDragAndDropStage(
    AgeExperienceProfile profile,
    List<InteractiveSceneObject> objects,
  ) {
    final draggableObj = widget.config.draggableObject ??
        widget.config.requestedObject ??
        widget.config.scene.objects.firstWhere(
          (o) => o.objectId == widget.config.targetObjectId,
          orElse: () => objects.first,
        );
    final targetDestination = widget.config.dropTarget ??
        widget.config.sceneActor ??
        widget.config.scene.objects.firstWhere(
          (o) => o.objectId == widget.config.targetDestinationId,
          orElse: () => objects.last,
        );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Drop Destination Area
        DragTarget<String>(
          onWillAcceptWithDetails: (details) => !_isCompleted,
          onAcceptWithDetails: (details) => _handleSuccessfulDrop(),
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;
            return Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: isHovering
                    ? AppColors.secondaryLight
                    : Colors.white.withAlpha(220),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: isHovering ? AppColors.secondary : AppColors.primary,
                  width: isHovering ? 4 : 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (targetDestination.conceptId == 'concept_table')
                    ChildTableVisual(
                      width: 140,
                      height: 95,
                      hasBookOnTop: _isCompleted,
                      isHovered: isHovering,
                    )
                  else
                    Text(
                      _isActionActive && widget.config.mechanicType == ActivityMechanicType.feedCharacter
                          ? '😋'
                          : targetDestination.emoji,
                      style: const TextStyle(fontSize: 56),
                    ),
                  if (profile.textDensity != TextDensity.zero)
                    Text(
                      targetDestination.label,
                      style: AppTypography.labelLarge,
                    ),
                ],
              ),
            );
          },
        ),

        const Icon(Icons.keyboard_double_arrow_up_rounded, size: 32, color: AppColors.secondary),

        // Draggable Object
        if (!_isCompleted)
          Draggable<String>(
            data: draggableObj.objectId,
            feedback: Material(
              color: Colors.transparent,
              child: Container(
                width: profile.visualTargetSize,
                height: profile.visualTargetSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    draggableObj.emoji,
                    style: TextStyle(fontSize: profile.visualTargetSize * 0.45),
                  ),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _buildCardIcon(profile, draggableObj),
            ),
            child: _buildCardIcon(profile, draggableObj),
          )
        else
          // Settled state
          Text('✨ Done! ✨', style: AppTypography.headlineLarge),
      ],
    );
  }

  Widget _buildCardIcon(AgeExperienceProfile profile, InteractiveSceneObject obj) {
    return Container(
      width: profile.visualTargetSize,
      height: profile.visualTargetSize,
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
      child: Center(
        child: obj.conceptId == 'concept_table'
            ? ChildTableVisual(
                width: profile.visualTargetSize * 0.85,
                height: profile.visualTargetSize * 0.60,
              )
            : Text(
                obj.emoji,
                style: TextStyle(fontSize: profile.visualTargetSize * 0.45),
              ),
      ),
    );
  }

  Widget _buildSpeakToMakeSomethingHappenStage(AgeExperienceProfile profile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Interactive Scene Element (Door)
        Container(
          width: 140,
          height: 180,
          decoration: BoxDecoration(
            color: _isCompleted ? const Color(0xFFC8E6C9) : const Color(0xFFFFE0B2),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isCompleted ? AppColors.secondary : Colors.brown,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isCompleted ? '🚪🔓' : '🚪🔒',
                style: const TextStyle(fontSize: 60),
              ),
              const SizedBox(height: 8),
              Text(
                _isCompleted ? 'OPEN!' : 'CLOSED',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _isCompleted ? AppColors.secondaryDark : Colors.brown,
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
                  color: (_isMicListening ? Colors.redAccent : AppColors.primary)
                      .withAlpha(90),
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
        Text(
          'Say: "Open the door"',
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),

        // Step 5: Direct Touch Fallback (Section 21)
        if (_speakingStep == SpeakingFallbackStep.touchFallback || profile.ageBand == LearningAgeBand.bandPreALittleListeners) ...[
          const SizedBox(height: 16),
          TextButton.icon(
            icon: const Icon(Icons.touch_app_rounded, color: AppColors.secondaryDark),
            label: const Text('Or tap here to open the door'),
            onPressed: () {
              _triggerSuccessReaction(customMessage: 'The door opened! 🚪✨');
            },
          ),
        ],
      ],
    );
  }

  Widget _buildRolePlayStage(AgeExperienceProfile profile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pip serving / roleplay scene
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
                'Picnic Role-Play',
                style: AppTypography.titleLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Child's response choices
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
              customMessage: 'Here is your fresh water! 💧 Enjoy!',
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💧', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                'Water, please. 😊',
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
