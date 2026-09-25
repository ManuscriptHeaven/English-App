import 'interactive_activity_engine.dart';
import 'interactive_session_composer.dart';
import 'interactive_scene_object.dart';

/// Exception thrown when an interactive activity fails semantic or role integrity.
class ActivityIntegrityException implements Exception {
  final String message;
  final List<String> details;

  ActivityIntegrityException(this.message, [this.details = const []]);

  @override
  String toString() {
    if (details.isEmpty) {
      return 'ActivityIntegrityException: $message';
    }
    return 'ActivityIntegrityException: $message\nDetails:\n${details.map((d) => '  - $d').join('\n')}';
  }
}

/// Automated validator that verifies activity configurations obey strict semantic contracts.
/// Rejects activities where instructions, learning concepts, and bound objects mismatch.
class InteractiveActivityIntegrityValidator {
  /// Validates a single [activity]. Returns a list of error descriptions (empty if valid).
  static List<String> validateActivity(InteractiveActivityConfig activity) {
    final List<String> errors = [];

    // Basic validity
    if (activity.id.isEmpty) {
      errors.add('Activity id must not be empty.');
    }
    if (activity.conceptId.isEmpty) {
      errors.add('Activity conceptId must not be empty.');
    }

    final instruction = (activity.instructionOverride ?? '').toLowerCase();

    switch (activity.mechanicType) {
      case ActivityMechanicType.dragAndDrop:
        _validateDragAndDrop(activity, instruction, errors);
        break;

      case ActivityMechanicType.feedCharacter:
        _validateFeedCharacter(activity, instruction, errors);
        break;

      case ActivityMechanicType.scenePlacement:
        _validateScenePlacement(activity, instruction, errors);
        break;

      case ActivityMechanicType.speakToMakeSomethingHappen:
        _validateSpeakToMakeSomethingHappen(activity, instruction, errors);
        break;

      case ActivityMechanicType.listenAndTouch:
        _validateListenAndTouch(activity, instruction, errors);
        break;

      case ActivityMechanicType.conversationRolePlay:
        _validateConversationRolePlay(activity, instruction, errors);
        break;

      case ActivityMechanicType.interactiveStory:
        _validateInteractiveStory(activity, instruction, errors);
        break;
    }

    return errors;
  }

  /// Validates an entire [session]. Throws [ActivityIntegrityException] on failure.
  static void validateSession(InteractiveLessonSession session) {
    final List<String> sessionErrors = [];

    if (session.activities.isEmpty) {
      sessionErrors.add('Session contains zero activities.');
    }

    for (int i = 0; i < session.activities.length; i++) {
      final activity = session.activities[i];
      final errors = validateActivity(activity);
      for (final err in errors) {
        sessionErrors.add('[Step ${i + 1} (${activity.id})]: $err');
      }
    }

    if (sessionErrors.isNotEmpty) {
      throw ActivityIntegrityException(
        'Session "${session.sessionId}" failed integrity validation.',
        sessionErrors,
      );
    }
  }

  static void _validateDragAndDrop(
    InteractiveActivityConfig activity,
    String instruction,
    List<String> errors,
  ) {
    final draggable = activity.draggableObject ??
        _findObject(activity, activity.targetObjectId);
    final target = activity.dropTarget ??
        _findObject(activity, activity.targetDestinationId);

    if (draggable == null) {
      errors.add('DragAndDrop requires a valid draggableObject.');
      return;
    }
    if (target == null) {
      errors.add('DragAndDrop requires a valid dropTarget.');
      return;
    }

    if (draggable.objectId == target.objectId) {
      errors.add(
        'Draggable (${draggable.objectId}) cannot be identical to dropTarget (${target.objectId}).',
      );
    }

    // Semantic instruction matching
    if (instruction.contains('apple') && draggable.conceptId != 'concept_apple') {
      errors.add(
        'Instruction asks for apple, but draggable is ${draggable.conceptId} (${draggable.label}).',
      );
    }
    if (instruction.contains('water') &&
        !instruction.contains('water bowl') &&
        !instruction.contains('water cup') &&
        draggable.conceptId != 'concept_water') {
      errors.add(
        'Instruction asks for water, but draggable is ${draggable.conceptId} (${draggable.label}).',
      );
    }
    if (instruction.contains('basket') && target.conceptId != 'concept_basket') {
      errors.add(
        'Instruction asks for basket, but dropTarget is ${target.conceptId} (${target.label}).',
      );
    }
    if (instruction.contains('table') &&
        draggable.conceptId != 'concept_table' &&
        target.conceptId != 'concept_table') {
      errors.add(
        'Instruction asks for table, but dropTarget is ${target.conceptId} (${target.label}).',
      );
    }
  }

  static void _validateFeedCharacter(
    InteractiveActivityConfig activity,
    String instruction,
    List<String> errors,
  ) {
    final draggable = activity.draggableObject ??
        activity.requestedObject ??
        _findObject(activity, activity.targetObjectId);
    final receiver = activity.sceneActor ??
        activity.dropTarget ??
        _findObject(activity, activity.targetDestinationId);

    if (draggable == null) {
      errors.add('FeedCharacter requires a valid food/drink draggableObject.');
      return;
    }
    if (receiver == null) {
      errors.add('FeedCharacter requires a valid receiver/sceneActor.');
      return;
    }

    // Contract: Child must NEVER be asked to drag rabbit -> rabbit or receiver -> receiver!
    if (draggable.objectId == receiver.objectId) {
      errors.add(
        'CRITICAL DEFECT: FeedCharacter cannot drag receiver onto itself (${draggable.objectId} -> ${receiver.objectId}).',
      );
    }

    if (instruction.contains('rabbit') && receiver.conceptId != 'concept_rabbit') {
      errors.add(
        'Instruction asks to feed rabbit, but receiver is ${receiver.conceptId} (${receiver.label}).',
      );
    }
    if (instruction.contains('pip') && receiver.conceptId != 'concept_pip') {
      errors.add(
        'Instruction asks to give to Pip, but receiver is ${receiver.conceptId} (${receiver.label}).',
      );
    }
    if (instruction.contains('apple') && draggable.conceptId != 'concept_apple') {
      errors.add(
        'Instruction asks for apple, but draggable is ${draggable.conceptId} (${draggable.label}).',
      );
    }
    if (instruction.contains('water') &&
        !instruction.contains('water bowl') &&
        !instruction.contains('water cup') &&
        draggable.conceptId != 'concept_water') {
      errors.add(
        'Instruction asks for water, but draggable is ${draggable.conceptId} (${draggable.label}).',
      );
    }
  }

  static void _validateScenePlacement(
    InteractiveActivityConfig activity,
    String instruction,
    List<String> errors,
  ) {
    final draggable = activity.draggableObject ??
        _findObject(activity, activity.targetObjectId);
    final target = activity.dropTarget ??
        _findObject(activity, activity.targetDestinationId);

    if (draggable == null || target == null) {
      errors.add('ScenePlacement requires draggableObject and dropTarget.');
      return;
    }
    if (draggable.objectId == target.objectId) {
      errors.add('ScenePlacement draggable cannot be same as target.');
    }
    if (instruction.contains('book') && draggable.conceptId != 'concept_book') {
      errors.add('Instruction mentions book, but draggable is ${draggable.conceptId}.');
    }
    if (instruction.contains('table') &&
        draggable.conceptId != 'concept_table' &&
        target.conceptId != 'concept_table') {
      errors.add('Instruction mentions table, but target is ${target.conceptId}.');
    }
  }

  static void _validateSpeakToMakeSomethingHappen(
    InteractiveActivityConfig activity,
    String instruction,
    List<String> errors,
  ) {
    if (activity.speakTriggerPhrase == null || activity.speakTriggerPhrase!.isEmpty) {
      errors.add('SpeakToMakeSomethingHappen requires speakTriggerPhrase.');
    }
    final target = _findObject(activity, activity.targetObjectId) ??
        activity.sceneActor ??
        activity.dropTarget;
    if (target == null) {
      errors.add('SpeakToMakeSomethingHappen requires target scene object.');
    } else if (RegExp(r'\bdoor\b').hasMatch(instruction) && target.conceptId != 'concept_door') {
      errors.add('Instruction mentions door, but target object is ${target.conceptId}.');
    }
  }

  static void _validateListenAndTouch(
    InteractiveActivityConfig activity,
    String instruction,
    List<String> errors,
  ) {
    final target = _findObject(activity, activity.targetObjectId);
    if (target == null) {
      errors.add('ListenAndTouch targetObjectId "${activity.targetObjectId}" not found in scene.');
      return;
    }
    if (instruction.contains('apple') && target.conceptId != 'concept_apple') {
      errors.add('Instruction mentions apple, but target is ${target.conceptId}.');
    }
    if (instruction.contains('water') && target.conceptId != 'concept_water') {
      errors.add('Instruction mentions water, but target is ${target.conceptId}.');
    }
  }

  static void _validateConversationRolePlay(
    InteractiveActivityConfig activity,
    String instruction,
    List<String> errors,
  ) {
    if (activity.rolePlayPipPrompt == null || activity.rolePlayPipPrompt!.isEmpty) {
      errors.add('ConversationRolePlay requires rolePlayPipPrompt.');
    }
    if (activity.rolePlayExpectedResponse == null ||
        activity.rolePlayExpectedResponse!.isEmpty) {
      errors.add('ConversationRolePlay requires rolePlayExpectedResponse.');
    }
  }

  static void _validateInteractiveStory(
    InteractiveActivityConfig activity,
    String instruction,
    List<String> errors,
  ) {
    if (activity.storySegmentText == null || activity.storySegmentText!.isEmpty) {
      errors.add('InteractiveStory requires storySegmentText.');
    }
  }

  static InteractiveSceneObject? _findObject(
    InteractiveActivityConfig activity,
    String? objectId,
  ) {
    if (objectId == null) return null;
    for (final obj in activity.scene.objects) {
      if (obj.objectId == objectId) return obj;
    }
    return null;
  }
}
