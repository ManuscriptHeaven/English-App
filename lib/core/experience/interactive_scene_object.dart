import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../features/curriculum/domain/models/learning_age_band.dart';

/// Semantic reaction types triggered by child interaction.
enum SceneReactionType {
  bounce,
  sound,
  eatAnimation,
  doorOpen,
  carDrive,
  lightOn,
  waterRipple,
  hideShow,
  colorChange,
}

/// Reusable domain model for interactive objects placed in scenes.
class InteractiveSceneObject extends Equatable {
  final String objectId;
  final String conceptId;
  final String label;
  final String emoji;
  final String? visualAsset;
  final String? audioAsset;
  final Offset initialPosition;
  final bool draggable;
  final bool tappable;
  final String? speakTrigger;
  final List<String> validDropTargets;
  final SceneReactionType reactionType;
  final String? reactionSound;
  final String? reactionPrompt;
  final List<LearningAgeBand> ageVisibility;
  final Map<String, dynamic> interactionRules;

  const InteractiveSceneObject({
    required this.objectId,
    required this.conceptId,
    required this.label,
    required this.emoji,
    this.visualAsset,
    this.audioAsset,
    this.initialPosition = Offset.zero,
    this.draggable = false,
    this.tappable = true,
    this.speakTrigger,
    this.validDropTargets = const [],
    this.reactionType = SceneReactionType.bounce,
    this.reactionSound,
    this.reactionPrompt,
    this.ageVisibility = const [
      LearningAgeBand.bandPreALittleListeners,
      LearningAgeBand.bandALittleExplorers,
      LearningAgeBand.bandBYoungAdventurers,
      LearningAgeBand.bandCGrowingSpeakers,
      LearningAgeBand.bandDConfidentSpeakers,
    ],
    this.interactionRules = const {},
  });

  InteractiveSceneObject copyWith({
    String? objectId,
    String? conceptId,
    String? label,
    String? emoji,
    String? visualAsset,
    String? audioAsset,
    Offset? initialPosition,
    bool? draggable,
    bool? tappable,
    String? speakTrigger,
    List<String>? validDropTargets,
    SceneReactionType? reactionType,
    String? reactionSound,
    String? reactionPrompt,
    List<LearningAgeBand>? ageVisibility,
    Map<String, dynamic>? interactionRules,
  }) {
    return InteractiveSceneObject(
      objectId: objectId ?? this.objectId,
      conceptId: conceptId ?? this.conceptId,
      label: label ?? this.label,
      emoji: emoji ?? this.emoji,
      visualAsset: visualAsset ?? this.visualAsset,
      audioAsset: audioAsset ?? this.audioAsset,
      initialPosition: initialPosition ?? this.initialPosition,
      draggable: draggable ?? this.draggable,
      tappable: tappable ?? this.tappable,
      speakTrigger: speakTrigger ?? this.speakTrigger,
      validDropTargets: validDropTargets ?? this.validDropTargets,
      reactionType: reactionType ?? this.reactionType,
      reactionSound: reactionSound ?? this.reactionSound,
      reactionPrompt: reactionPrompt ?? this.reactionPrompt,
      ageVisibility: ageVisibility ?? this.ageVisibility,
      interactionRules: interactionRules ?? this.interactionRules,
    );
  }

  @override
  List<Object?> get props => [
        objectId,
        conceptId,
        label,
        emoji,
        visualAsset,
        audioAsset,
        initialPosition,
        draggable,
        tappable,
        speakTrigger,
        validDropTargets,
        reactionType,
        reactionSound,
        reactionPrompt,
        ageVisibility,
        interactionRules,
      ];
}
