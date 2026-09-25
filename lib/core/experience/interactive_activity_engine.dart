import 'package:equatable/equatable.dart';
import 'age_experience_profile.dart';
import 'interactive_scene.dart';
import 'interactive_scene_object.dart';

/// The 7 Core Vertical Slice Activity Mechanics required by Section 44.
enum ActivityMechanicType {
  listenAndTouch, // 1. Touch object upon hearing audio prompt
  dragAndDrop, // 2. Drag item to target destination (e.g. apple -> basket)
  feedCharacter, // 3. Feed character (e.g. drag apple to hungry rabbit)
  scenePlacement, // 4. Spatial preposition placement (e.g. ball under table)
  speakToMakeSomethingHappen, // 5. Spoken action trigger (e.g. "open the door")
  interactiveStory, // 6. Participatory moment inside story context
  conversationRolePlay, // 7. Dialogic role-play with Pip
}

/// Fallback steps for speech recognition gracefully guaranteeing progression.
enum SpeakingFallbackStep {
  initialPrompt,
  replayModel,
  retryEncouraged,
  simplifiedTarget,
  parentAssisted,
  touchFallback,
}

/// Dynamic configuration for an interactive learning activity with explicit semantic roles.
class InteractiveActivityConfig extends Equatable {
  final String id;
  final String conceptId;
  final ActivityMechanicType mechanicType;
  final InteractiveScene scene;
  final String targetObjectId;
  final String? targetDestinationId;
  final String? targetPreposition;
  final String? speakTriggerPhrase;
  final String? rolePlayPipPrompt;
  final String? rolePlayExpectedResponse;
  final String? storySegmentText;
  final AgeExperienceProfile ageProfile;
  final String? instructionOverride;
  final String? audioPromptOverride;

  // Phase 16.8: Explicit semantic roles
  final String? learningConceptId;
  final String? promptConceptId;
  final InteractiveSceneObject? draggableObject;
  final InteractiveSceneObject? dropTarget;
  final InteractiveSceneObject? sceneActor;
  final InteractiveSceneObject? requestedObject;
  final List<InteractiveSceneObject> distractors;
  final SceneReactionType? successReaction;
  final String? successReactionPrompt;
  final String? spatialRelation;
  final String? contextualProblemPrompt;
  final List<String>? contextualChoices;

  const InteractiveActivityConfig({
    required this.id,
    required this.conceptId,
    required this.mechanicType,
    required this.scene,
    required this.targetObjectId,
    this.targetDestinationId,
    this.targetPreposition,
    this.speakTriggerPhrase,
    this.rolePlayPipPrompt,
    this.rolePlayExpectedResponse,
    this.storySegmentText,
    required this.ageProfile,
    this.instructionOverride,
    this.audioPromptOverride,
    this.learningConceptId,
    this.promptConceptId,
    this.draggableObject,
    this.dropTarget,
    this.sceneActor,
    this.requestedObject,
    this.distractors = const [],
    this.successReaction,
    this.successReactionPrompt,
    this.spatialRelation,
    this.contextualProblemPrompt,
    this.contextualChoices,
  });

  /// Factory creating age-adapted vertical slice activities for canonical concepts.
  factory InteractiveActivityConfig.createSample({
    required String conceptWord,
    required ActivityMechanicType mechanic,
    required int childAge,
    bool preferPreAForAge4 = false,
  }) {
    final profile = AgeExperienceProfile.forAge(
      childAge,
      preferPreAForAge4: preferPreAForAge4,
    );

    switch (mechanic) {
      case ActivityMechanicType.listenAndTouch:
        return InteractiveActivityConfig(
          id: 'act_touch_${conceptWord}_$childAge',
          conceptId: 'concept_$conceptWord',
          mechanicType: mechanic,
          scene: InteractiveScene.foodAndDrinks(),
          targetObjectId: 'obj_apple',
          ageProfile: profile,
        );

      case ActivityMechanicType.dragAndDrop:
        return InteractiveActivityConfig(
          id: 'act_drag_${conceptWord}_$childAge',
          conceptId: 'concept_$conceptWord',
          mechanicType: mechanic,
          scene: InteractiveScene.foodAndDrinks(),
          targetObjectId: 'obj_apple',
          targetDestinationId: 'target_basket',
          ageProfile: profile,
        );

      case ActivityMechanicType.feedCharacter:
        return InteractiveActivityConfig(
          id: 'act_feed_${conceptWord}_$childAge',
          conceptId: 'concept_$conceptWord',
          mechanicType: mechanic,
          scene: InteractiveScene.animalsAndNature(),
          targetObjectId: 'obj_apple',
          targetDestinationId: 'target_rabbit',
          ageProfile: profile,
        );

      case ActivityMechanicType.scenePlacement:
        return InteractiveActivityConfig(
          id: 'act_place_${conceptWord}_$childAge',
          conceptId: 'concept_book',
          mechanicType: mechanic,
          scene: InteractiveScene.myHome(),
          targetObjectId: 'obj_book',
          targetDestinationId: 'target_on_table',
          targetPreposition: 'on',
          ageProfile: profile,
        );

      case ActivityMechanicType.speakToMakeSomethingHappen:
        return InteractiveActivityConfig(
          id: 'act_speak_${conceptWord}_$childAge',
          conceptId: 'concept_door',
          mechanicType: mechanic,
          scene: InteractiveScene.myHome(),
          targetObjectId: 'obj_door',
          speakTriggerPhrase: 'open the door',
          ageProfile: profile,
        );

      case ActivityMechanicType.interactiveStory:
        return InteractiveActivityConfig(
          id: 'act_story_${conceptWord}_$childAge',
          conceptId: 'concept_water',
          mechanicType: mechanic,
          scene: InteractiveScene.animalsAndNature(),
          targetObjectId: 'obj_water',
          targetDestinationId: 'target_bird',
          storySegmentText: 'The little bird is thirsty in the warm sun.',
          ageProfile: profile,
        );

      case ActivityMechanicType.conversationRolePlay:
        return InteractiveActivityConfig(
          id: 'act_roleplay_${conceptWord}_$childAge',
          conceptId: 'concept_water',
          mechanicType: mechanic,
          scene: InteractiveScene.foodAndDrinks(),
          targetObjectId: 'obj_water',
          rolePlayPipPrompt: 'What would you like at the picnic?',
          rolePlayExpectedResponse: 'Water, please.',
          ageProfile: profile,
        );
    }
  }

  @override
  List<Object?> get props => [
        id,
        conceptId,
        mechanicType,
        scene,
        targetObjectId,
        targetDestinationId,
        targetPreposition,
        speakTriggerPhrase,
        rolePlayPipPrompt,
        rolePlayExpectedResponse,
        storySegmentText,
        ageProfile,
        instructionOverride,
        audioPromptOverride,
        learningConceptId,
        promptConceptId,
        draggableObject,
        dropTarget,
        sceneActor,
        requestedObject,
        distractors,
        successReaction,
        successReactionPrompt,
        spatialRelation,
        contextualProblemPrompt,
        contextualChoices,
      ];
}

/// Enforces Section 39: Activity Variety Rule.
/// Prevents repeating the same primary mechanic more than approximately 2 consecutive activities.
class ActivityVarietyEngine {
  final List<ActivityMechanicType> _history = [];
  final int maxConsecutiveAllowed;

  ActivityVarietyEngine({this.maxConsecutiveAllowed = 2});

  List<ActivityMechanicType> get history => List.unmodifiable(_history);

  /// Checks if [mechanic] can be safely scheduled without violating the variety rule.
  bool canSchedule(ActivityMechanicType mechanic) {
    if (_history.length < maxConsecutiveAllowed) return true;
    for (int i = 1; i <= maxConsecutiveAllowed; i++) {
      if (_history[_history.length - i] != mechanic) {
        return true;
      }
    }
    return false; // Repeated maxConsecutiveAllowed times consecutively
  }

  /// Records that [mechanic] was executed.
  void recordActivity(ActivityMechanicType mechanic) {
    _history.add(mechanic);
  }

  /// Selects the best candidate mechanic from [candidates] that honors the variety rule.
  ActivityMechanicType selectNextMechanic(List<ActivityMechanicType> candidates) {
    for (final c in candidates) {
      if (canSchedule(c)) return c;
    }
    return candidates.first; // Fallback if all candidates violate rule
  }

  void reset() {
    _history.clear();
  }
}

/// Observes interaction signals for Pre-A children during organic play (Section 43).
/// Gathers ability signals quietly without presenting an intimidating "Placement Test".
class PassivePlacementTracker {
  int totalInteractions = 0;
  int firstTrySuccessCount = 0;
  int replayRequests = 0;
  int hintsTriggered = 0;
  int spokenImitationsAttempted = 0;

  void recordInteraction({
    required bool isFirstTrySuccess,
    bool usedReplay = false,
    bool usedHint = false,
    bool attemptedSpeech = false,
  }) {
    totalInteractions++;
    if (isFirstTrySuccess) firstTrySuccessCount++;
    if (usedReplay) replayRequests++;
    if (usedHint) hintsTriggered++;
    if (attemptedSpeech) spokenImitationsAttempted++;
  }

  double get accuracy =>
      totalInteractions > 0 ? (firstTrySuccessCount / totalInteractions) : 0.0;

  bool get demonstratesEmergentComprehension =>
      totalInteractions >= 2 && accuracy >= 0.50;

  void reset() {
    totalInteractions = 0;
    firstTrySuccessCount = 0;
    replayRequests = 0;
    hintsTriggered = 0;
    spokenImitationsAttempted = 0;
  }
}
