import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene_object.dart';

/// Explicit per-lesson production content specification.
/// Completely removes generic heuristics and binds each lesson directly to its
/// intended pedagogical objectives and interactive scene elements.
class CurriculumLessonSpec extends Equatable {
  final String lessonId;
  final String primaryConceptId;
  final String primaryConceptLabel;
  final String secondaryConceptId;
  final String secondaryConceptLabel;
  final String sceneId;
  final InteractiveScene Function() sceneFactory;
  final String targetObjectId;
  final String draggableObjectId;
  final String targetDestinationId;
  final String speakingTarget;
  final String dialoguePrompt;
  final String dialogueResponse;
  final List<ActivityMechanicType> activitySequence;
  final String? customInstruction1;
  final String? customInstruction2;
  final String? customInstruction3;
  final String? customInstruction4;
  final String? customInstruction5;
  final String? successMessage;

  const CurriculumLessonSpec({
    required this.lessonId,
    required this.primaryConceptId,
    required this.primaryConceptLabel,
    required this.secondaryConceptId,
    required this.secondaryConceptLabel,
    required this.sceneId,
    required this.sceneFactory,
    required this.targetObjectId,
    required this.draggableObjectId,
    required this.targetDestinationId,
    required this.speakingTarget,
    required this.dialoguePrompt,
    required this.dialogueResponse,
    this.activitySequence = const [
      ActivityMechanicType.listenAndTouch,
      ActivityMechanicType.dragAndDrop,
      ActivityMechanicType.speakToMakeSomethingHappen,
      ActivityMechanicType.conversationRolePlay,
      ActivityMechanicType.listenAndTouch,
    ],
    this.customInstruction1,
    this.customInstruction2,
    this.customInstruction3,
    this.customInstruction4,
    this.customInstruction5,
    this.successMessage,
  });

  /// Handcrafts the 5 concrete, validated [InteractiveActivityConfig] instances
  /// strictly adhering to this lesson's explicit specification.
  List<InteractiveActivityConfig> buildActivities(AgeExperienceProfile profile) {
    final scene = sceneFactory();

    // Verify target objects exist in scene
    final targetObj = scene.objects.firstWhere(
      (o) => o.objectId == targetObjectId,
      orElse: () => throw StateError(
        'Spec error in lesson $lessonId: targetObjectId "$targetObjectId" not found in scene ${scene.sceneId}',
      ),
    );

    final draggableObj = scene.objects.firstWhere(
      (o) => o.objectId == draggableObjectId,
      orElse: () => targetObj,
    );

    final destinationObj = targetDestinationId.isNotEmpty
        ? scene.objects.firstWhere(
            (o) => o.objectId == targetDestinationId,
            orElse: () => throw StateError(
              'Spec error in lesson $lessonId: targetDestinationId "$targetDestinationId" not found in scene ${scene.sceneId}',
            ),
          )
        : targetObj;

    final distractorObj = scene.objects.firstWhere(
      (o) => o.objectId == secondaryConceptId || (o.objectId != targetObjectId && o.objectId != destinationObj.objectId),
      orElse: () => destinationObj,
    );

    final List<InteractiveActivityConfig> activities = [];

    // Age-differentiated default instructions to prevent cross-age repetition
    final String defaultInst1;
    final String defaultInst2;
    final String defaultInst3;
    final String defaultInst4;
    final String defaultInst5;

    final step2Mechanic = activitySequence.length > 1 ? activitySequence[1] : ActivityMechanicType.dragAndDrop;
    final step3Mechanic = activitySequence.length > 2 ? activitySequence[2] : ActivityMechanicType.speakToMakeSomethingHappen;
    final step4Mechanic = activitySequence.length > 3 ? activitySequence[3] : ActivityMechanicType.conversationRolePlay;
    final step5Mechanic = activitySequence.length > 4 ? activitySequence[4] : ActivityMechanicType.listenAndTouch;

    switch (profile.age) {
      case 3:
      case 4:
        defaultInst1 = 'Listen! Touch the $primaryConceptLabel! 🌟';
        defaultInst2 = step2Mechanic == ActivityMechanicType.speakToMakeSomethingHappen
            ? 'Say "$speakingTarget"! 🎙️'
            : 'Move the ${draggableObj.label} gently to the ${destinationObj.label}! ✨';
        defaultInst3 = 'Say "$speakingTarget"! Or tap! 🎙️';
        defaultInst4 = '$dialoguePrompt Say: "$dialogueResponse" 💬';
        defaultInst5 = 'Tap the $primaryConceptLabel to finish this lesson! 🎊';
        break;
      case 5:
      case 6:
        defaultInst1 = 'Can you find and touch the $primaryConceptLabel? 🌟';
        defaultInst2 = step2Mechanic == ActivityMechanicType.speakToMakeSomethingHappen
            ? 'Speak out loud: "$speakingTarget"! 🎙️'
            : 'Help place the ${draggableObj.label} by the ${destinationObj.label}! ✨';
        defaultInst3 = 'Speak out loud: "$speakingTarget"! 🎙️';
        defaultInst4 = '$dialoguePrompt Answer with: "$dialogueResponse" 💬';
        defaultInst5 = 'Star reward! Touch the $primaryConceptLabel to finish! 🌟🎉';
        break;
      case 7:
      case 8:
        defaultInst1 = 'Identify and select the $primaryConceptLabel. 🌟';
        defaultInst2 = step2Mechanic == ActivityMechanicType.speakToMakeSomethingHappen
            ? 'Articulate clearly: "$speakingTarget" 🎙️'
            : 'Arrange the ${draggableObj.label} with the ${destinationObj.label}. ✨';
        defaultInst3 = 'Clearly articulate: "$speakingTarget" 🎙️';
        defaultInst4 = '$dialoguePrompt Respond: "$dialogueResponse" 💬';
        defaultInst5 = 'Well done! Confirm your progress on $primaryConceptLabel! 🏅';
        break;
      case 9:
      case 10:
        defaultInst1 = 'Examine the scene and locate the $primaryConceptLabel. 🌟';
        defaultInst2 = step2Mechanic == ActivityMechanicType.speakToMakeSomethingHappen
            ? 'Express this perspective: "$speakingTarget" 🎙️'
            : 'Position the ${draggableObj.label} with the ${destinationObj.label}. ✨';
        defaultInst3 = 'Express this perspective: "$speakingTarget" 🎙️';
        defaultInst4 = '$dialoguePrompt Propose: "$dialogueResponse" 💬';
        defaultInst5 = 'Objective achieved! Complete module for $primaryConceptLabel! 🏆';
        break;
      default: // 11-12
        defaultInst1 = 'Analyze the setting and designate the $primaryConceptLabel. 🌟';
        defaultInst2 = step2Mechanic == ActivityMechanicType.speakToMakeSomethingHappen
            ? 'Articulate the principle: "$speakingTarget" 🎙️'
            : 'Align the ${draggableObj.label} toward the ${destinationObj.label}. ✨';
        defaultInst3 = 'Articulate the core principle: "$speakingTarget" 🎙️';
        defaultInst4 = '$dialoguePrompt Discuss: "$dialogueResponse" 💬';
        defaultInst5 = 'Mastery accomplished! Solidify insight on $primaryConceptLabel! 🎖️';
        break;
    }

    // Step 1: Listen and Touch (Identify target concept)
    activities.add(
      InteractiveActivityConfig(
        id: '${lessonId}_step1_listen',
        conceptId: primaryConceptId,
        learningConceptId: primaryConceptId,
        mechanicType: activitySequence.isNotEmpty ? activitySequence[0] : ActivityMechanicType.listenAndTouch,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        distractors: [distractorObj],
        ageProfile: profile,
        instructionOverride: customInstruction1 ?? defaultInst1,
        audioPromptOverride: primaryConceptLabel,
        successReaction: targetObj.reactionType,
        successReactionPrompt: targetObj.reactionPrompt ?? 'Great job finding the $primaryConceptLabel! ⭐',
      ),
    );

    // Step 2: Manipulation / Spatial Placement / Feed / Action / Early Speaking
    activities.add(
      InteractiveActivityConfig(
        id: '${lessonId}_step2_interact',
        conceptId: primaryConceptId,
        learningConceptId: primaryConceptId,
        mechanicType: step2Mechanic,
        scene: scene,
        targetObjectId: draggableObj.objectId,
        targetDestinationId: destinationObj.objectId,
        draggableObject: draggableObj,
        requestedObject: draggableObj,
        dropTarget: destinationObj,
        sceneActor: destinationObj,
        speakTriggerPhrase: step2Mechanic == ActivityMechanicType.speakToMakeSomethingHappen
            ? speakingTarget.toLowerCase().trim()
            : null,
        ageProfile: profile,
        instructionOverride: customInstruction2 ?? defaultInst2,
        audioPromptOverride: step2Mechanic == ActivityMechanicType.speakToMakeSomethingHappen
            ? speakingTarget
            : 'Move the ${draggableObj.label}',
        successReaction: step2Mechanic == ActivityMechanicType.feedCharacter
            ? SceneReactionType.eatAnimation
            : destinationObj.reactionType,
        successReactionPrompt: destinationObj.reactionPrompt ?? 'Nicely placed! Perfect! 🌟',
      ),
    );

    // Step 3: Speaking Expression or Manipulation
    final bool isStep3Manipulation = step3Mechanic == ActivityMechanicType.dragAndDrop ||
        step3Mechanic == ActivityMechanicType.scenePlacement ||
        step3Mechanic == ActivityMechanicType.feedCharacter;

    activities.add(
      InteractiveActivityConfig(
        id: '${lessonId}_step3_speak',
        conceptId: primaryConceptId,
        learningConceptId: primaryConceptId,
        mechanicType: step3Mechanic,
        scene: scene,
        targetObjectId: isStep3Manipulation ? draggableObj.objectId : targetObj.objectId,
        targetDestinationId: isStep3Manipulation ? destinationObj.objectId : null,
        draggableObject: isStep3Manipulation ? draggableObj : targetObj,
        requestedObject: isStep3Manipulation ? draggableObj : null,
        dropTarget: isStep3Manipulation ? destinationObj : null,
        sceneActor: isStep3Manipulation ? destinationObj : targetObj,
        speakTriggerPhrase: isStep3Manipulation ? null : speakingTarget.toLowerCase().trim(),
        ageProfile: profile,
        instructionOverride: customInstruction3 ??
            (isStep3Manipulation
                ? (step3Mechanic == ActivityMechanicType.feedCharacter
                    ? 'Feed the ${draggableObj.label} to ${destinationObj.label}! 🍎🦜'
                    : 'Place the ${draggableObj.label} by the ${destinationObj.label}! ✨')
                : defaultInst3),
        audioPromptOverride: speakingTarget,
        successReaction: step3Mechanic == ActivityMechanicType.feedCharacter
            ? SceneReactionType.eatAnimation
            : destinationObj.reactionType,
        successReactionPrompt: isStep3Manipulation
            ? (destinationObj.reactionPrompt ?? 'Great job! 🌟')
            : 'Wonderful! You said "$speakingTarget"! 🌟🎉',
      ),
    );

    // Step 4: Dialogue / Conversation Turn / Review
    activities.add(
      InteractiveActivityConfig(
        id: '${lessonId}_step4_dialogue',
        conceptId: primaryConceptId,
        learningConceptId: primaryConceptId,
        mechanicType: step4Mechanic,
        scene: scene,
        targetObjectId: destinationObj.objectId,
        draggableObject: destinationObj,
        sceneActor: destinationObj,
        rolePlayPipPrompt: dialoguePrompt,
        rolePlayExpectedResponse: dialogueResponse,
        speakTriggerPhrase: step4Mechanic == ActivityMechanicType.speakToMakeSomethingHappen
            ? speakingTarget.toLowerCase().trim()
            : dialogueResponse.toLowerCase().trim(),
        ageProfile: profile,
        instructionOverride: customInstruction4 ?? defaultInst4,
        audioPromptOverride: dialoguePrompt,
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: 'Pip smiles: "$dialogueResponse! Excellent!" 🦜❤️',
      ),
    );

    // Step 5: Reinforcement & Celebration
    activities.add(
      InteractiveActivityConfig(
        id: '${lessonId}_step5_celebrate',
        conceptId: primaryConceptId,
        learningConceptId: primaryConceptId,
        mechanicType: step5Mechanic,
        scene: scene,
        targetObjectId: targetObj.objectId,
        draggableObject: targetObj,
        ageProfile: profile,
        instructionOverride: customInstruction5 ?? defaultInst5,
        audioPromptOverride: 'Tap to finish!',
        successReaction: SceneReactionType.bounce,
        successReactionPrompt: successMessage ?? 'MashaAllah! You learned $primaryConceptLabel! 🌟⭐',
      ),
    );

    return activities;
  }

  @override
  List<Object?> get props => [
        lessonId,
        primaryConceptId,
        primaryConceptLabel,
        secondaryConceptId,
        secondaryConceptLabel,
        sceneId,
        targetObjectId,
        draggableObjectId,
        targetDestinationId,
        speakingTarget,
        dialoguePrompt,
        dialogueResponse,
        activitySequence,
      ];
}
