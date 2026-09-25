import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'interactive_scene_object.dart';

/// Pre-configured mini-world scenes housing contextual concepts.
enum SceneCategory {
  home,
  food,
  animals,
  school,
  dailyLife,
}

/// A cohesive interactive scene that embeds curriculum concepts into meaningful visual contexts.
class InteractiveScene extends Equatable {
  final String sceneId;
  final String title;
  final SceneCategory category;
  final Color backgroundColor;
  final String backgroundIcon;
  final List<InteractiveSceneObject> objects;

  const InteractiveScene({
    required this.sceneId,
    required this.title,
    required this.category,
    required this.backgroundColor,
    required this.backgroundIcon,
    required this.objects,
  });

  /// The Home Scene (bedroom / living room context).
  factory InteractiveScene.myHome() {
    return const InteractiveScene(
      sceneId: 'scene_home',
      title: 'My Warm Home 🏡',
      category: SceneCategory.home,
      backgroundColor: Color(0xFFF3E5F5), // Soft pastel lavender
      backgroundIcon: '🏠',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_door',
          conceptId: 'concept_door',
          label: 'Door',
          emoji: '🚪',
          initialPosition: Offset(0.2, 0.4),
          tappable: true,
          speakTrigger: 'open the door',
          reactionType: SceneReactionType.doorOpen,
          reactionPrompt: 'The door opened! 🚪✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_table',
          conceptId: 'concept_table',
          label: 'Table',
          emoji: '✨',
          visualAsset: 'table',
          initialPosition: Offset(0.6, 0.6),
          tappable: true,
          validDropTargets: ['target_table_top'],
        ),
        InteractiveSceneObject(
          objectId: 'obj_book',
          conceptId: 'concept_book',
          label: 'Book',
          emoji: '📖',
          initialPosition: Offset(0.4, 0.7),
          draggable: true,
          validDropTargets: ['target_on_table', 'target_table_top'],
          reactionType: SceneReactionType.bounce,
        ),
        InteractiveSceneObject(
          objectId: 'obj_chair',
          conceptId: 'concept_chair',
          label: 'Chair',
          emoji: '🪑',
          initialPosition: Offset(0.8, 0.6),
          tappable: true,
          speakTrigger: 'turn on the light',
          reactionType: SceneReactionType.lightOn,
          reactionPrompt: 'The room is bright! 💡✨',
        ),
      ],
    );
  }

  /// Food & Drinks Scene (picnic / kitchen context).
  factory InteractiveScene.foodAndDrinks() {
    return const InteractiveScene(
      sceneId: 'scene_food',
      title: 'Picnic & Kitchen 🧺',
      category: SceneCategory.food,
      backgroundColor: Color(0xFFFFF3E0), // Soft warm peach
      backgroundIcon: '🧺',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_apple',
          conceptId: 'concept_apple',
          label: 'Apple',
          emoji: '🍎',
          initialPosition: Offset(0.3, 0.5),
          draggable: true,
          tappable: true,
          validDropTargets: ['target_basket', 'target_rabbit', 'target_table'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Mmm, delicious red apple! 🍎',
        ),
        InteractiveSceneObject(
          objectId: 'obj_water',
          conceptId: 'concept_water',
          label: 'Water',
          emoji: '💧',
          initialPosition: Offset(0.5, 0.5),
          draggable: true,
          tappable: true,
          validDropTargets: ['target_bird', 'target_cup'],
          reactionType: SceneReactionType.waterRipple,
          reactionPrompt: 'Cool, refreshing water! 💧',
        ),
        InteractiveSceneObject(
          objectId: 'obj_basket',
          conceptId: 'concept_basket',
          label: 'Basket',
          emoji: '🧺',
          initialPosition: Offset(0.7, 0.6),
          tappable: true,
          validDropTargets: ['target_basket'],
        ),
      ],
    );
  }

  /// Production Pip's Picnic persistent scene with stable object IDs and semantic bindings.
  factory InteractiveScene.picnicScene() {
    return const InteractiveScene(
      sceneId: 'picnic_scene',
      title: "Pip's Picnic 🧺",
      category: SceneCategory.food,
      backgroundColor: Color(0xFFFFF8E1), // Warm sunny outdoor picnic amber-cream
      backgroundIcon: '🧺',
      objects: [
        InteractiveSceneObject(
          objectId: 'picnic_apple_01',
          conceptId: 'concept_apple',
          label: 'Apple',
          emoji: '🍎',
          initialPosition: Offset(0.3, 0.65),
          draggable: true,
          tappable: true,
          validDropTargets: ['picnic_basket_01', 'picnic_rabbit_01', 'picnic_table_01'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Delicious crisp red apple! 🍎',
        ),
        InteractiveSceneObject(
          objectId: 'picnic_basket_01',
          conceptId: 'concept_basket',
          label: 'Basket',
          emoji: '🧺',
          initialPosition: Offset(0.7, 0.4),
          tappable: true,
          validDropTargets: ['picnic_basket_01'],
          reactionPrompt: 'In the picnic basket! 🧺✨',
        ),
        InteractiveSceneObject(
          objectId: 'picnic_rabbit_01',
          conceptId: 'concept_rabbit',
          label: 'Rabbit',
          emoji: '🐰',
          initialPosition: Offset(0.75, 0.45),
          tappable: true,
          validDropTargets: ['picnic_rabbit_01'],
          reactionType: SceneReactionType.eatAnimation,
          reactionPrompt: 'Nom nom! The rabbit happily munches the apple! 🐰😋',
        ),
        InteractiveSceneObject(
          objectId: 'picnic_water_01',
          conceptId: 'concept_water',
          label: 'Water',
          emoji: '💧',
          initialPosition: Offset(0.3, 0.65),
          draggable: true,
          tappable: true,
          validDropTargets: ['picnic_pip_01', 'picnic_basket_01', 'picnic_table_01'],
          reactionType: SceneReactionType.waterRipple,
          reactionPrompt: 'Cool, refreshing water! 💧',
        ),
        InteractiveSceneObject(
          objectId: 'picnic_pip_01',
          conceptId: 'concept_pip',
          label: 'Pip',
          emoji: '🐥',
          initialPosition: Offset(0.7, 0.45),
          tappable: true,
          validDropTargets: ['picnic_pip_01'],
          reactionType: SceneReactionType.sound,
          reactionPrompt: 'Ah, refreshing water! Thank you! 🐥✨',
        ),
        InteractiveSceneObject(
          objectId: 'picnic_table_01',
          conceptId: 'concept_table',
          label: 'Table',
          emoji: '✨',
          visualAsset: 'table',
          initialPosition: Offset(0.65, 0.45),
          tappable: true,
          validDropTargets: ['picnic_table_01'],
          reactionPrompt: 'Neatly placed on the picnic table! ✨',
        ),
        InteractiveSceneObject(
          objectId: 'picnic_book_01',
          conceptId: 'concept_book',
          label: 'Book',
          emoji: '📖',
          initialPosition: Offset(0.3, 0.65),
          draggable: true,
          tappable: true,
          validDropTargets: ['picnic_table_01'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'The book is neatly on the table! 📖',
        ),
        InteractiveSceneObject(
          objectId: 'picnic_door_01',
          conceptId: 'concept_door',
          label: 'Door',
          emoji: '🚪',
          initialPosition: Offset(0.5, 0.5),
          tappable: true,
          speakTrigger: 'open the door',
          reactionType: SceneReactionType.doorOpen,
          reactionPrompt: 'The door opened wide! 🚪✨',
        ),
      ],
    );
  }

  /// Animals & Nature Scene (meadow / park context).
  factory InteractiveScene.animalsAndNature() {
    return const InteractiveScene(
      sceneId: 'scene_animals',
      title: 'Sunny Meadow 🌿',
      category: SceneCategory.animals,
      backgroundColor: Color(0xFFE8F5E9), // Soft meadow green
      backgroundIcon: '🌳',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_rabbit',
          conceptId: 'concept_rabbit',
          label: 'Rabbit',
          emoji: '🐰',
          initialPosition: Offset(0.7, 0.5),
          tappable: true,
          validDropTargets: ['target_rabbit'],
          reactionType: SceneReactionType.eatAnimation,
          reactionPrompt: 'Nom nom! The rabbit is eating! 🐰🥕',
        ),
        InteractiveSceneObject(
          objectId: 'obj_cat',
          conceptId: 'concept_cat',
          label: 'Cat',
          emoji: '🐱',
          initialPosition: Offset(0.3, 0.6),
          tappable: true,
          reactionType: SceneReactionType.sound,
          reactionSound: 'Meow! 🐱',
          reactionPrompt: 'The friendly cat purrs: Meow! 🐱',
        ),
        InteractiveSceneObject(
          objectId: 'obj_bird',
          conceptId: 'concept_bird',
          label: 'Bird',
          emoji: '🐦',
          initialPosition: Offset(0.5, 0.3),
          tappable: true,
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Chirp chirp! The bird hops! 🐦',
        ),
      ],
    );
  }

  @override
  List<Object?> get props => [
        sceneId,
        title,
        category,
        backgroundColor,
        backgroundIcon,
        objects,
      ];
}
