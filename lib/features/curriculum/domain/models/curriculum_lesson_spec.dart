import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene_object.dart';

/// Explicit handcrafted specification for a single interactive activity step within a lesson.
class CurriculumActivityStepSpec extends Equatable {
  final String stepId;
  final ActivityMechanicType mechanic;
  final String learningConceptId;
  final String targetObjectId;
  final String? draggableObjectId;
  final String? targetDestinationId;
  final String instruction;
  final String audioPrompt;
  final String? speakingTarget;
  final String? dialoguePrompt;
  final String? expectedResponse;
  final SceneReactionType successReaction;
  final String successFeedback;
  final String? fallbackReaction;
  final List<String> distractorObjectIds;

  const CurriculumActivityStepSpec({
    required this.stepId,
    required this.mechanic,
    required this.learningConceptId,
    required this.targetObjectId,
    this.draggableObjectId,
    this.targetDestinationId,
    required this.instruction,
    required this.audioPrompt,
    this.speakingTarget,
    this.dialoguePrompt,
    this.expectedResponse,
    this.successReaction = SceneReactionType.bounce,
    required this.successFeedback,
    this.fallbackReaction,
    this.distractorObjectIds = const [],
  });

  @override
  List<Object?> get props => [
        stepId,
        mechanic,
        learningConceptId,
        targetObjectId,
        draggableObjectId,
        targetDestinationId,
        instruction,
        audioPrompt,
        speakingTarget,
        dialoguePrompt,
        expectedResponse,
        successReaction,
        successFeedback,
        fallbackReaction,
        distractorObjectIds,
      ];
}

/// Explicit per-lesson production content specification.
/// Completely removes generic heuristics and binds each lesson directly to its
/// handcrafted list of [CurriculumActivityStepSpec] steps.
class CurriculumLessonSpec extends Equatable {
  final String lessonId;
  final String primaryConceptId;
  final String primaryConceptLabel;
  final String secondaryConceptId;
  final String secondaryConceptLabel;
  final String sceneId;
  final InteractiveScene Function() sceneFactory;
  final List<CurriculumActivityStepSpec> steps;

  const CurriculumLessonSpec({
    required this.lessonId,
    required this.primaryConceptId,
    required this.primaryConceptLabel,
    required this.secondaryConceptId,
    required this.secondaryConceptLabel,
    required this.sceneId,
    required this.sceneFactory,
    required this.steps,
  });

  // Convenience getters for test compatibility and metadata inspection
  String get targetObjectId => steps.isNotEmpty ? steps.first.targetObjectId : '';
  String get draggableObjectId =>
      steps.firstWhere((s) => s.draggableObjectId != null, orElse: () => steps.first).draggableObjectId ?? targetObjectId;
  String get targetDestinationId =>
      steps.firstWhere((s) => s.targetDestinationId != null, orElse: () => steps.first).targetDestinationId ?? '';
  String get speakingTarget =>
      steps.firstWhere((s) => s.speakingTarget != null, orElse: () => steps.first).speakingTarget ?? '';
  String get dialoguePrompt =>
      steps.firstWhere((s) => s.dialoguePrompt != null, orElse: () => steps.first).dialoguePrompt ?? '';
  String get dialogueResponse =>
      steps.firstWhere((s) => s.expectedResponse != null, orElse: () => steps.first).expectedResponse ?? '';
  List<ActivityMechanicType> get activitySequence => steps.map((s) => s.mechanic).toList();

  /// Validates this specification by building activities against its scene. Throws [StateError] on mismatch.
  void validate([AgeExperienceProfile? profile]) {
    buildActivities(profile ?? AgeExperienceProfile.forAge(5));
  }

  /// Compiles explicit step specs into concrete [InteractiveActivityConfig] instances.
  /// Throws [StateError] immediately if any referenced object or scene is invalid.
  List<InteractiveActivityConfig> buildActivities(AgeExperienceProfile profile) {
    final scene = sceneFactory();
    if (scene.sceneId != sceneId) {
      throw StateError(
        'Spec error in lesson $lessonId: sceneFactory returned sceneId "${scene.sceneId}" but expected "$sceneId"',
      );
    }

    final List<InteractiveActivityConfig> activities = [];

    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];

      // 1. Strict validation: target object must exist in scene
      final targetObj = scene.objects.firstWhere(
        (o) => o.objectId == step.targetObjectId,
        orElse: () => throw StateError(
          'Spec error in lesson $lessonId step ${step.stepId}: targetObjectId "${step.targetObjectId}" not found in scene ${scene.sceneId}',
        ),
      );

      // 2. Strict validation: draggable object (if specified) must exist in scene
      final InteractiveSceneObject? draggableObj = step.draggableObjectId != null
          ? scene.objects.firstWhere(
              (o) => o.objectId == step.draggableObjectId,
              orElse: () => throw StateError(
                'Spec error in lesson $lessonId step ${step.stepId}: draggableObjectId "${step.draggableObjectId}" not found in scene ${scene.sceneId}',
              ),
            )
          : (step.mechanic == ActivityMechanicType.dragAndDrop ||
                  step.mechanic == ActivityMechanicType.feedCharacter ||
                  step.mechanic == ActivityMechanicType.scenePlacement)
              ? targetObj
              : null;

      // 3. Strict validation: destination object (if specified) must exist in scene
      final InteractiveSceneObject? destinationObj =
          (step.targetDestinationId != null && step.targetDestinationId!.isNotEmpty)
              ? scene.objects.firstWhere(
                  (o) => o.objectId == step.targetDestinationId,
                  orElse: () => throw StateError(
                    'Spec error in lesson $lessonId step ${step.stepId}: targetDestinationId "${step.targetDestinationId}" not found in scene ${scene.sceneId}',
                  ),
                )
              : null;

      // 4. Strict validation: distractors (if specified) must exist in scene
      final List<InteractiveSceneObject> distractorObjs = [];
      for (final distractorId in step.distractorObjectIds) {
        final distractor = scene.objects.firstWhere(
          (o) => o.objectId == distractorId,
          orElse: () => throw StateError(
            'Spec error in lesson $lessonId step ${step.stepId}: distractorObjectId "$distractorId" not found in scene ${scene.sceneId}',
          ),
        );
        distractorObjs.add(distractor);
      }
      if (distractorObjs.isEmpty) {
        for (final o in scene.objects) {
          if (o.objectId != targetObj.objectId && (destinationObj == null || o.objectId != destinationObj.objectId)) {
            distractorObjs.add(o);
            break;
          }
        }
      }

      activities.add(
        InteractiveActivityConfig(
          id: '${lessonId}_step${i + 1}_${step.stepId}',
          conceptId: step.learningConceptId,
          learningConceptId: step.learningConceptId,
          mechanicType: step.mechanic,
          scene: scene,
          targetObjectId: targetObj.objectId,
          targetDestinationId: destinationObj?.objectId,
          draggableObject: draggableObj ?? targetObj,
          requestedObject: draggableObj ?? targetObj,
          dropTarget: destinationObj,
          sceneActor: destinationObj ?? targetObj,
          distractors: distractorObjs,
          speakTriggerPhrase: step.mechanic == ActivityMechanicType.speakToMakeSomethingHappen
              ? step.speakingTarget?.toLowerCase().trim()
              : (step.mechanic == ActivityMechanicType.conversationRolePlay && step.expectedResponse != null)
                  ? step.expectedResponse!.toLowerCase().trim()
                  : null,
          rolePlayPipPrompt: step.dialoguePrompt,
          rolePlayExpectedResponse: step.expectedResponse,
          ageProfile: profile,
          instructionOverride: step.instruction,
          audioPromptOverride: step.audioPrompt,
          successReaction: step.successReaction,
          successReactionPrompt: step.successFeedback,
        ),
      );
    }

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
        steps,
      ];
}
