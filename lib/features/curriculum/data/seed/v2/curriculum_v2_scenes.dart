import 'package:flutter/material.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene_object.dart';

/// Pre-configured production scenes for CURRICULUM_CONTENT_V2 across all 5 age tracks.
class CurriculumV2Scenes {
  // ── 1. Hello & Me Scene ──
  static InteractiveScene helloMeScene() {
    return const InteractiveScene(
      sceneId: 'scene_v2_hello_me',
      title: 'Hello & Me 🌟',
      category: SceneCategory.dailyLife,
      backgroundColor: Color(0xFFFFF9C4), // Soft sunny morning yellow
      backgroundIcon: '👋',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_pip_greeter',
          conceptId: 'concept_pip',
          label: 'Pip',
          emoji: '🦜',
          initialPosition: Offset(0.5, 0.45),
          tappable: true,
          speakTrigger: 'hello',
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Hello friend! Pip is so happy to see you! 🦜👋',
        ),
        InteractiveSceneObject(
          objectId: 'obj_happy_face',
          conceptId: 'concept_happy',
          label: 'Happy',
          emoji: '😊',
          initialPosition: Offset(0.25, 0.7),
          tappable: true,
          draggable: true,
          validDropTargets: ['obj_pip_greeter'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'I am happy! Big smile! 😊✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_sad_face',
          conceptId: 'concept_sad',
          label: 'Sad',
          emoji: '😢',
          initialPosition: Offset(0.75, 0.7),
          tappable: true,
          reactionType: SceneReactionType.sound,
          reactionPrompt: 'Feeling sad? A kind friend helps you feel better! 💙',
        ),
        InteractiveSceneObject(
          objectId: 'obj_avatar_mirror',
          conceptId: 'concept_me',
          label: 'Mirror',
          emoji: '🪞',
          initialPosition: Offset(0.5, 0.2),
          tappable: true,
          speakTrigger: 'my name',
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Look at you! You are wonderful! 🪞✨',
        ),
      ],
    );
  }

  // ── 2. My Body Scene ──
  static InteractiveScene myBodyScene() {
    return const InteractiveScene(
      sceneId: 'scene_v2_body',
      title: 'My Body 🧒',
      category: SceneCategory.dailyLife,
      backgroundColor: Color(0xFFE1F5FE), // Soft sky blue
      backgroundIcon: '🧒',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_body_eyes',
          conceptId: 'concept_eyes',
          label: 'Eyes',
          emoji: '👀',
          initialPosition: Offset(0.5, 0.25),
          tappable: true,
          speakTrigger: 'eyes',
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Two bright eyes to see the world! 👀✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_body_ears',
          conceptId: 'concept_ears',
          label: 'Ears',
          emoji: '👂',
          initialPosition: Offset(0.2, 0.3),
          tappable: true,
          speakTrigger: 'ears',
          reactionType: SceneReactionType.sound,
          reactionPrompt: 'Ears to listen to good words! 👂🎶',
        ),
        InteractiveSceneObject(
          objectId: 'obj_body_nose',
          conceptId: 'concept_nose',
          label: 'Nose',
          emoji: '👃',
          initialPosition: Offset(0.5, 0.4),
          tappable: true,
          speakTrigger: 'touch your nose',
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Touch your nose! 👃✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_body_mouth',
          conceptId: 'concept_mouth',
          label: 'Mouth',
          emoji: '👄',
          initialPosition: Offset(0.5, 0.52),
          tappable: true,
          speakTrigger: 'mouth',
          reactionType: SceneReactionType.sound,
          reactionPrompt: 'Mouth for speaking kind words! 👄💬',
        ),
        InteractiveSceneObject(
          objectId: 'obj_body_hands',
          conceptId: 'concept_hands',
          label: 'Hands',
          emoji: '🙌',
          initialPosition: Offset(0.2, 0.65),
          tappable: true,
          draggable: true,
          validDropTargets: ['obj_body_feet'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Clean hands help others and share! 🙌🧼',
        ),
        InteractiveSceneObject(
          objectId: 'obj_body_feet',
          conceptId: 'concept_feet',
          label: 'Feet',
          emoji: '🦶',
          initialPosition: Offset(0.8, 0.8),
          tappable: true,
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Feet to walk gently and run happily! 🦶🏃',
        ),
      ],
    );
  }

  // ── 3. Colors Studio Scene ──
  static InteractiveScene colorsScene() {
    return const InteractiveScene(
      sceneId: 'scene_v2_colors',
      title: 'Rainbow Colors 🎨',
      category: SceneCategory.dailyLife,
      backgroundColor: Color(0xFFF3E5F5), // Lavender
      backgroundIcon: '🎨',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_color_red_ball',
          conceptId: 'concept_red',
          label: 'Red Ball',
          emoji: '🔴',
          initialPosition: Offset(0.2, 0.4),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_color_red_basket'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Bright red! Like a sweet red apple! 🔴🍎',
        ),
        InteractiveSceneObject(
          objectId: 'obj_color_red_basket',
          conceptId: 'concept_basket',
          label: 'Red Basket',
          emoji: '🧺',
          initialPosition: Offset(0.2, 0.75),
          tappable: true,
          validDropTargets: ['obj_color_red_basket'],
          reactionPrompt: 'Red ball in the red basket! Perfect! 🧺🔴',
        ),
        InteractiveSceneObject(
          objectId: 'obj_color_blue_block',
          conceptId: 'concept_blue',
          label: 'Blue Block',
          emoji: '🟦',
          initialPosition: Offset(0.5, 0.4),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_color_blue_basket'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Calm blue! Like the clear sky! 🟦☁️',
        ),
        InteractiveSceneObject(
          objectId: 'obj_color_blue_basket',
          conceptId: 'concept_basket',
          label: 'Blue Basket',
          emoji: '🧺',
          initialPosition: Offset(0.5, 0.75),
          tappable: true,
          validDropTargets: ['obj_color_blue_basket'],
          reactionPrompt: 'Blue block in the blue basket! Super! 🧺🟦',
        ),
        InteractiveSceneObject(
          objectId: 'obj_color_yellow_bubble',
          conceptId: 'concept_yellow',
          label: 'Yellow Bubble',
          emoji: '🟡',
          initialPosition: Offset(0.8, 0.35),
          tappable: true,
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Pop! Warm yellow like the morning sun! 🟡☀️',
        ),
        InteractiveSceneObject(
          objectId: 'obj_color_green_leaf',
          conceptId: 'concept_green',
          label: 'Green Leaf',
          emoji: '🟢',
          initialPosition: Offset(0.8, 0.6),
          tappable: true,
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Fresh green like the grass! 🟢🌱',
        ),
      ],
    );
  }

  // ── 4. Animals Farm & Meadow Scene ──
  static InteractiveScene animalsFarmScene() {
    return const InteractiveScene(
      sceneId: 'scene_v2_animals',
      title: 'Friendly Animals Farm 🐾',
      category: SceneCategory.animals,
      backgroundColor: Color(0xFFE8F5E9), // Meadow green
      backgroundIcon: '🌾',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_animal_cat',
          conceptId: 'concept_cat',
          label: 'Cat',
          emoji: '🐱',
          initialPosition: Offset(0.2, 0.5),
          tappable: true,
          speakTrigger: 'cat',
          validDropTargets: ['obj_animal_cat'],
          reactionType: SceneReactionType.sound,
          reactionSound: 'Meow! 🐱',
          reactionPrompt: 'Meow! The friendly cat purrs softly! 🐱❤️',
        ),
        InteractiveSceneObject(
          objectId: 'obj_animal_dog',
          conceptId: 'concept_dog',
          label: 'Dog',
          emoji: '🐶',
          initialPosition: Offset(0.5, 0.65),
          tappable: true,
          speakTrigger: 'dog',
          validDropTargets: ['obj_animal_dog'],
          reactionType: SceneReactionType.sound,
          reactionSound: 'Woof! 🐶',
          reactionPrompt: 'Woof woof! The loyal dog wags its tail! 🐶🐾',
        ),
        InteractiveSceneObject(
          objectId: 'obj_animal_bird',
          conceptId: 'concept_bird',
          label: 'Bird',
          emoji: '🐦',
          initialPosition: Offset(0.75, 0.3),
          tappable: true,
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Chirp chirp! Beautiful little bird! 🐦✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_animal_rabbit',
          conceptId: 'concept_rabbit',
          label: 'Rabbit',
          emoji: '🐰',
          initialPosition: Offset(0.8, 0.65),
          tappable: true,
          validDropTargets: ['obj_animal_rabbit'],
          reactionType: SceneReactionType.eatAnimation,
          reactionPrompt: 'Hop hop! The soft rabbit munches happily! 🐰🥕',
        ),
        InteractiveSceneObject(
          objectId: 'obj_animal_duck',
          conceptId: 'concept_duck',
          label: 'Duck',
          emoji: '🦆',
          initialPosition: Offset(0.3, 0.3),
          tappable: true,
          reactionType: SceneReactionType.waterRipple,
          reactionPrompt: 'Quack quack! Swimming in the clean water! 🦆💧',
        ),
        InteractiveSceneObject(
          objectId: 'obj_animal_food_carrot',
          conceptId: 'concept_carrot',
          label: 'Carrot',
          emoji: '🥕',
          initialPosition: Offset(0.5, 0.4),
          draggable: true,
          validDropTargets: ['obj_animal_rabbit'],
          reactionPrompt: 'Kindness to animals! Feeding the hungry rabbit! 🥕🐰',
        ),
      ],
    );
  }

  // ── 5. Food & Kitchen Dining Scene ──
  static InteractiveScene foodKitchenScene() {
    return const InteractiveScene(
      sceneId: 'scene_v2_food_kitchen',
      title: 'Kitchen & Dining Table 🍽️',
      category: SceneCategory.food,
      backgroundColor: Color(0xFFFFF3E0), // Warm apricot
      backgroundIcon: '🍽️',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_food_apple',
          conceptId: 'concept_apple',
          label: 'Apple',
          emoji: '🍎',
          initialPosition: Offset(0.2, 0.6),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_dining_table', 'obj_dining_pip'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Crisp red apple! Say Bismillah before eating! 🍎✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_food_banana',
          conceptId: 'concept_banana',
          label: 'Banana',
          emoji: '🍌',
          initialPosition: Offset(0.4, 0.6),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_dining_table', 'obj_dining_pip'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Sweet yellow banana! Alhamdulillah for good food! 🍌😋',
        ),
        InteractiveSceneObject(
          objectId: 'obj_food_water',
          conceptId: 'concept_water',
          label: 'Water',
          emoji: '💧',
          initialPosition: Offset(0.6, 0.6),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_dining_pip', 'obj_dining_table'],
          reactionType: SceneReactionType.waterRipple,
          reactionPrompt: 'Refreshing clean water! Sit down to drink! 💧🥤',
        ),
        InteractiveSceneObject(
          objectId: 'obj_food_bread',
          conceptId: 'concept_bread',
          label: 'Bread',
          emoji: '🍞',
          initialPosition: Offset(0.8, 0.6),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_dining_table', 'obj_dining_pip'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Warm bread to share with family! 🍞🤝',
        ),
        InteractiveSceneObject(
          objectId: 'obj_dining_table',
          conceptId: 'concept_table',
          label: 'Table',
          emoji: '🪵',
          initialPosition: Offset(0.5, 0.78),
          tappable: true,
          validDropTargets: ['obj_dining_table'],
          reactionPrompt: 'Placed neatly on the clean dining table! ✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_dining_pip',
          conceptId: 'concept_pip',
          label: 'Pip',
          emoji: '🦜',
          initialPosition: Offset(0.5, 0.3),
          tappable: true,
          validDropTargets: ['obj_dining_pip'],
          reactionType: SceneReactionType.eatAnimation,
          reactionPrompt: 'Pip says: "Thank you! JazakAllahu khayran!" 🦜❤️',
        ),
      ],
    );
  }

  // ── 6. My Home Room Scene ──
  static InteractiveScene myHomeRoomScene() {
    return const InteractiveScene(
      sceneId: 'scene_v2_home_room',
      title: 'My Clean Room 🏠',
      category: SceneCategory.home,
      backgroundColor: Color(0xFFEDE7F6), // Cozy soft violet
      backgroundIcon: '🛋️',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_room_door',
          conceptId: 'concept_door',
          label: 'Door',
          emoji: '🚪',
          initialPosition: Offset(0.18, 0.4),
          tappable: true,
          speakTrigger: 'open the door',
          reactionType: SceneReactionType.doorOpen,
          reactionPrompt: 'The door opened! Welcome home! 🚪✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_room_bed',
          conceptId: 'concept_bed',
          label: 'Bed',
          emoji: '🛏️',
          initialPosition: Offset(0.8, 0.45),
          tappable: true,
          validDropTargets: ['obj_room_bed'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'A tidy bed for restful sleep! Cleanliness is faith! 🛏️💤',
        ),
        InteractiveSceneObject(
          objectId: 'obj_room_chair',
          conceptId: 'concept_chair',
          label: 'Chair',
          emoji: '🪑',
          initialPosition: Offset(0.4, 0.65),
          tappable: true,
          speakTrigger: 'sit down',
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Sit down comfortably! 🪑',
        ),
        InteractiveSceneObject(
          objectId: 'obj_room_table',
          conceptId: 'concept_table',
          label: 'Table',
          emoji: '🪵',
          initialPosition: Offset(0.6, 0.65),
          tappable: true,
          validDropTargets: ['obj_room_table'],
          reactionPrompt: 'Clean study table! 🪵✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_room_book',
          conceptId: 'concept_book',
          label: 'Book',
          emoji: '📖',
          initialPosition: Offset(0.3, 0.8),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_room_table', 'obj_room_bed'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Put the book on the table neatly! 📖✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_room_light',
          conceptId: 'concept_light',
          label: 'Lamp',
          emoji: '💡',
          initialPosition: Offset(0.5, 0.15),
          tappable: true,
          speakTrigger: 'turn on the light',
          reactionType: SceneReactionType.lightOn,
          reactionPrompt: 'The room is bright and welcoming! 💡✨',
        ),
      ],
    );
  }

  // ── 7. Toys & Playroom Scene ──
  static InteractiveScene toysPlaygroundScene() {
    return const InteractiveScene(
      sceneId: 'scene_v2_toys_play',
      title: 'Playroom & Toys 🧸',
      category: SceneCategory.dailyLife,
      backgroundColor: Color(0xFFFFFDE7), // Buttercream
      backgroundIcon: '🧸',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_toy_ball',
          conceptId: 'concept_ball',
          label: 'Ball',
          emoji: '⚽',
          initialPosition: Offset(0.2, 0.65),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_toy_box', 'obj_toy_pip'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Roll the ball! Playing together and taking turns! ⚽🤝',
        ),
        InteractiveSceneObject(
          objectId: 'obj_toy_car',
          conceptId: 'concept_car',
          label: 'Car',
          emoji: '🚗',
          initialPosition: Offset(0.45, 0.65),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_toy_box'],
          reactionType: SceneReactionType.carDrive,
          reactionPrompt: 'Vroom! The little toy car goes fast! 🚗💨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_toy_blocks',
          conceptId: 'concept_blocks',
          label: 'Blocks',
          emoji: '🧱',
          initialPosition: Offset(0.7, 0.65),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_toy_box'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Build a high tower together with patience! 🧱🏰',
        ),
        InteractiveSceneObject(
          objectId: 'obj_toy_kite',
          conceptId: 'concept_kite',
          label: 'Kite',
          emoji: '🪁',
          initialPosition: Offset(0.75, 0.25),
          tappable: true,
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'The kite flies high in the gentle breeze! 🪁🌤️',
        ),
        InteractiveSceneObject(
          objectId: 'obj_toy_box',
          conceptId: 'concept_box',
          label: 'Toy Box',
          emoji: '📦',
          initialPosition: Offset(0.85, 0.8),
          tappable: true,
          validDropTargets: ['obj_toy_box'],
          reactionPrompt: 'Tidying up toys after playing! Clean and organized! 📦⭐',
        ),
        InteractiveSceneObject(
          objectId: 'obj_toy_pip',
          conceptId: 'concept_pip',
          label: 'Pip',
          emoji: '🦜',
          initialPosition: Offset(0.3, 0.3),
          tappable: true,
          validDropTargets: ['obj_toy_pip'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Pip says: "Let\'s share our toys! Sharing brings joy!" 🦜❤️',
        ),
      ],
    );
  }

  // ── 8. School & Classroom Scene ──
  static InteractiveScene schoolClassroomScene() {
    return const InteractiveScene(
      sceneId: 'scene_v2_school',
      title: 'Classroom & Learning 🏫',
      category: SceneCategory.school,
      backgroundColor: Color(0xFFE0F2F1), // Mint teal
      backgroundIcon: '🏫',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_school_board',
          conceptId: 'concept_board',
          label: 'Whiteboard',
          emoji: '📋',
          initialPosition: Offset(0.5, 0.25),
          tappable: true,
          speakTrigger: 'good morning teacher',
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Good morning, class! Knowledge is light! 📋💡',
        ),
        InteractiveSceneObject(
          objectId: 'obj_school_desk',
          conceptId: 'concept_desk',
          label: 'Desk',
          emoji: '🪑',
          initialPosition: Offset(0.5, 0.7),
          tappable: true,
          validDropTargets: ['obj_school_desk'],
          reactionPrompt: 'A neat student desk ready for study! 🪑✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_school_pencil',
          conceptId: 'concept_pencil',
          label: 'Pencil',
          emoji: '✏️',
          initialPosition: Offset(0.25, 0.6),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_school_desk'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Write neatly and speak with honesty! ✏️📝',
        ),
        InteractiveSceneObject(
          objectId: 'obj_school_book',
          conceptId: 'concept_book',
          label: 'Book',
          emoji: '📚',
          initialPosition: Offset(0.75, 0.6),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_school_desk'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Open the book to discover wonders! 📚🌟',
        ),
        InteractiveSceneObject(
          objectId: 'obj_school_backpack',
          conceptId: 'concept_backpack',
          label: 'Bag',
          emoji: '🎒',
          initialPosition: Offset(0.15, 0.8),
          tappable: true,
          validDropTargets: ['obj_school_backpack'],
          reactionPrompt: 'Packed and ready for school on time! 🎒⏰',
        ),
      ],
    );
  }

  // ── 9. Town Market Scene ──
  static InteractiveScene townMarketScene() {
    return const InteractiveScene(
      sceneId: 'scene_v2_town_market',
      title: 'Town Market & Shops 🏪',
      category: SceneCategory.dailyLife,
      backgroundColor: Color(0xFFFBE9E7), // Light peach
      backgroundIcon: '🏪',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_market_pip_vendor',
          conceptId: 'concept_pip',
          label: 'Shopkeeper Pip',
          emoji: '🦜',
          initialPosition: Offset(0.5, 0.35),
          tappable: true,
          speakTrigger: 'can i help you',
          validDropTargets: ['obj_market_pip_vendor'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Pip: "Welcome! What would you like today?" 🦜🛍️',
        ),
        InteractiveSceneObject(
          objectId: 'obj_market_apples',
          conceptId: 'concept_apple',
          label: 'Fresh Apples',
          emoji: '🍎',
          initialPosition: Offset(0.2, 0.65),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_market_cart', 'obj_market_pip_vendor'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Fresh sweet apples from the orchard! 🍎✨',
        ),
        InteractiveSceneObject(
          objectId: 'obj_market_cart',
          conceptId: 'concept_cart',
          label: 'Shopping Cart',
          emoji: '🛒',
          initialPosition: Offset(0.8, 0.7),
          tappable: true,
          validDropTargets: ['obj_market_cart'],
          reactionPrompt: 'Item added to the cart! Polite shopping! 🛒⭐',
        ),
        InteractiveSceneObject(
          objectId: 'obj_market_bread',
          conceptId: 'concept_bread',
          label: 'Fresh Bread',
          emoji: '🥖',
          initialPosition: Offset(0.5, 0.65),
          draggable: true,
          tappable: true,
          validDropTargets: ['obj_market_cart'],
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Warm bakery bread! 🥖✨',
        ),
      ],
    );
  }

  // ── 10. Nature Park Scene ──
  static InteractiveScene natureParkScene() {
    return const InteractiveScene(
      sceneId: 'scene_v2_nature_park',
      title: 'Outdoor Nature Park 🌳',
      category: SceneCategory.dailyLife,
      backgroundColor: Color(0xFFE8F5E9), // Fresh leafy green
      backgroundIcon: '🌳',
      objects: [
        InteractiveSceneObject(
          objectId: 'obj_park_tree',
          conceptId: 'concept_tree',
          label: 'Big Tree',
          emoji: '🌳',
          initialPosition: Offset(0.2, 0.4),
          tappable: true,
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'A strong green tree providing cooling shade! SubhanAllah! 🌳☀️',
        ),
        InteractiveSceneObject(
          objectId: 'obj_park_flower',
          conceptId: 'concept_flower',
          label: 'Flower',
          emoji: '🌸',
          initialPosition: Offset(0.4, 0.75),
          tappable: true,
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'Beautiful blooming flower! Care for nature! 🌸🐝',
        ),
        InteractiveSceneObject(
          objectId: 'obj_park_trash_bin',
          conceptId: 'concept_bin',
          label: 'Recycle Bin',
          emoji: '🗑️',
          initialPosition: Offset(0.8, 0.75),
          tappable: true,
          validDropTargets: ['obj_park_trash_bin'],
          reactionPrompt: 'Keeping the park clean! Cleanliness is part of faith! 🗑️💚',
        ),
        InteractiveSceneObject(
          objectId: 'obj_park_sun',
          conceptId: 'concept_sun',
          label: 'Sun',
          emoji: '☀️',
          initialPosition: Offset(0.75, 0.2),
          tappable: true,
          speakTrigger: 'it is sunny',
          reactionType: SceneReactionType.bounce,
          reactionPrompt: 'The sun shines warm and bright! ☀️🌈',
        ),
      ],
    );
  }

  /// Maps world domain to its primary interactive scene.
  static InteractiveScene getSceneForDomain(String domain) {
    switch (domain.toLowerCase()) {
      case 'hello':
      case 'me':
      case 'identity':
        return helloMeScene();
      case 'body':
      case 'health':
        return myBodyScene();
      case 'colors':
        return colorsScene();
      case 'animals':
        return animalsFarmScene();
      case 'food':
      case 'drinks':
        return foodKitchenScene();
      case 'home':
        return myHomeRoomScene();
      case 'toys':
      case 'play':
      case 'sports':
      case 'hobbies':
        return toysPlaygroundScene();
      case 'school':
      case 'friends':
        return schoolClassroomScene();
      case 'market':
      case 'shopping':
      case 'town':
        return townMarketScene();
      case 'nature':
      case 'weather':
      case 'community':
      default:
        return natureParkScene();
    }
  }
}
