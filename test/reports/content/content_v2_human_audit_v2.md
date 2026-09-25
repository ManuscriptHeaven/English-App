# CURRICULUM_CONTENT_V2 — HUMAN CONTENT AUDIT V2

> Comprehensive Quality Lock Audit verifying natural child language, sequence variation, age calibration, and Islamic governance across all 5 age groups.

## Executive Inventory Snapshot
- **Total Production Lessons**: 150
- **Total Interactive Interactions**: 774 (minimum threshold: >= 750)
- **Total Thematic Worlds**: 48
- **Total Instructional Units**: 48
- **Curated Stories**: 10
- **Conversation Scenarios**: 19
- **QA / Developer Tools in Production**: Strictly gated behind `kDebugMode` (inaccessible in release builds)

---

## 25 Complete Child-Facing Lesson Transcripts (5 per Track)
Every interaction is transcribed unsummarized, showing exact child-facing prompts, audio cues, mechanic types, target response/phrase, and reactions.

### Track Little Listeners (Age 3–4) — Track 1 — Little Listeners
- **Age Band Focus**: First exposure to English through listening, visual recognition, movement, imitation and play. Zero required reading, zero formal grammar, speaking optional.

#### Lesson: Pip Says Hello! 👋 (`t1_l01_pip_says_hello`)
- **Unit**: `unit_t1_hello_me` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child can say or wave "Hello".
- **Listening Target**: Child recognizes greeting prompt from Pip.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Hello! Pip is waving to you! Touch Pip! 👋🦜 | Hello! Touch Pip! | `obj_pip_greeter` | Hello friend! So happy to see you! 🦜✨ |
| Step 2 | `listenAndTouch` | Touch the mirror! Look at your smile! 🪞 | Touch the mirror | `obj_avatar_mirror` | Look at you! Wonderful smile! 🪞✨ |
| Step 3 | `dragAndDrop` | Bring Pip to the mirror to say hello! 🦜🪞 | Bring Pip to the mirror | `obj_pip_greeter` | Pip says: "Hello, wonderful friend!" 🦜👋 |
| Step 4 | `speakToMakeSomethingHappen` | Can you say Hello? Or tap Pip! 👋 | Hello! Can you say Hello? | `hello` | Hello! Beautiful greeting! 🌟 |
| Step 5 | `listenAndTouch` | Touch Pip to celebrate our first greeting! 🦜🎉 | Touch Pip to celebrate! | `obj_pip_greeter` | Yay! We said hello! Adventure starts! 🌟⭐ |

#### Lesson: Touch Your Nose! 👃 (`t1_l04_touch_your_nose`)
- **Unit**: `unit_t1_body` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child echoes "Nose".
- **Listening Target**: Child touches nose in response to audio.
- **Interaction Count**: 4 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Eyes! Touch the Eyes! 👀 | Touch the Eyes | `obj_body_eyes` | Awesome! You found the Eyes! 👀 |
| Step 2 | `dragAndDrop` | Move with Pip! Drag the Eyes! 🏃 | Move the Eyes | `obj_body_eyes` | Fun moves! Way to go! 🌟 |
| Step 3 | `speakToMakeSomethingHappen` | Say Eyes! Or tap to hear it! 🗣️ | Say Eyes! | `eyes` | Eyes! Great voice! 🌟 |
| Step 4 | `listenAndTouch` | Give Pip a high-five! Touch Pip! 🦜✋ | Give Pip a high five! | `obj_body_eyes` | Yay! High-five! Great playing! ⭐🎉 |

#### Lesson: Red Ball & Basket 🔴 (`t1_l07_red_apple_basket`)
- **Unit**: `unit_t1_colors` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child repeats "Red".
- **Listening Target**: Child selects and places red item.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look! Where is the Red Ball? Touch it! 🔴 | Where is the Red Ball? Touch it | `obj_color_red_ball` | You found the Red Ball! 🔴 |
| Step 2 | `scenePlacement` | Put the Red Ball next to the Red Basket! 🪵 | Put the Red Ball next to the Red Basket | `obj_color_red_ball` | Neat and tidy! Looks great! ✨ |
| Step 3 | `dragAndDrop` | Move the Red Ball into place! 🚀 | Move the Red Ball | `obj_color_red_ball` | Nicely moved! 🔴 |
| Step 4 | `speakToMakeSomethingHappen` | Can you say Red Ball? 🔴 | Can you say Red Ball? | `red ball` | Red Ball! Beautiful speaking! 🌟 |
| Step 5 | `listenAndTouch` | Touch the star to celebrate! ⭐🎉 | Touch the star to celebrate! | `obj_color_red_ball` | Super work! You did it! ⭐🎉 |

#### Lesson: Gentle Cat Purrs 🐱 (`t1_l10_friendly_cat`)
- **Unit**: `unit_t1_animals` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child imitates "Meow".
- **Listening Target**: Child recognizes cat and pets softly.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen to Pip: Find the Cat! 🐱 | Find the Cat | `obj_animal_cat` | You found the sweet Cat! 🐱 |
| Step 2 | `dragAndDrop` | Bring the Cat here gently! 🤝 | Bring the Cat here | `obj_animal_cat` | So gentle and kind! 🐱✨ |
| Step 3 | `scenePlacement` | Put the Cat in a cozy spot! 🏡 | Put the Cat in a cozy spot | `obj_animal_cat` | Cozy and safe! Wonderful job! 🐱❤️ |
| Step 4 | `speakToMakeSomethingHappen` | Can you say Cat? Or make the sound! 🗣️ | Can you say Cat? | `cat` | Cat! You said it! 🌟 |
| Step 5 | `listenAndTouch` | Gently pat the Cat! 🐾❤️ | Gently pat the Cat | `obj_animal_cat` | Purr purr! Happy and loved! 🐱 |
| Step 6 | `listenAndTouch` | Touch Pip to celebrate! 🦜🎉 | Touch Pip to celebrate! | `obj_animal_dog` | Hooray! Great caring friend! ⭐🎉 |

#### Lesson: Cool Water, Please 💧 (`t1_l14_cool_clean_water`)
- **Unit**: `unit_t1_food` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child says "Water".
- **Listening Target**: Child offers water cup to thirsty character.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen to Pip: Find the Apple! 🍎 | Find the Apple | `obj_food_apple` | You found the sweet Apple! 🍎 |
| Step 2 | `dragAndDrop` | Bring the Apple here gently! 🤝 | Bring the Apple here | `obj_food_apple` | So gentle and kind! 🍎✨ |
| Step 3 | `scenePlacement` | Put the Apple in a cozy spot! 🏡 | Put the Apple in a cozy spot | `obj_food_apple` | Cozy and safe! Wonderful job! 🍎❤️ |
| Step 4 | `speakToMakeSomethingHappen` | Can you say Apple? Or make the sound! 🗣️ | Can you say Apple? | `apple` | Apple! You said it! 🌟 |
| Step 5 | `listenAndTouch` | Gently pat the Apple! 🐾❤️ | Gently pat the Apple | `obj_food_apple` | Purr purr! Happy and loved! 🍎 |
| Step 6 | `listenAndTouch` | Touch Pip to celebrate! 🦜🎉 | Touch Pip to celebrate! | `obj_food_banana` | Hooray! Great caring friend! ⭐🎉 |

### Track Little Speakers (Age 5–6) — Track 2 — Little Speakers
- **Age Band Focus**: Vocabulary to phrases to first functional sentences. Minimal text, high visual support, polite functional expressions.

#### Lesson: I am Happy! 😊 (`t2_l01_i_am_happy`)
- **Unit**: `unit_t2_me` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "I am happy today!"
- **Listening Target**: Child identifies happy character.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen carefully: "I see the Pip." Touch it! 🦜 | I see the Pip. Touch it! | `obj_pip_greeter` | Excellent! You found the Pip! 🦜 |
| Step 2 | `scenePlacement` | Put the Pip nicely with Happy! ✨ | Put the Pip with Happy | `obj_pip_greeter` | Clean and tidy! Placed perfectly! ✨ |
| Step 3 | `speakToMakeSomethingHappen` | Say the full phrase: "This is my Pip!" 🗣️ | Say: This is my Pip! | `this is my pip` | Super! "This is my Pip!" Great speaking! 🌟 |
| Step 4 | `conversationRolePlay` | Pip asks: "Do you like the Pip?" Answer: "Yes, I like it!" 💬 | Do you like the Pip? Say: Yes, I like it! | `yes i like it` | "Yes, I like it!" What a nice chat! ❤️ |
| Step 5 | `listenAndTouch` | Touch the star to complete your lesson! ⭐🎉 | Touch the star to complete! | `obj_pip_greeter` | Lesson complete! You are becoming a great speaker! 🌟🏆 |

#### Lesson: This Is My Mother 👩 (`t2_l04_this_is_my_mother`)
- **Unit**: `unit_t2_family` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "This is my mother."
- **Listening Target**: Child selects mother icon in family photo.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen carefully: "I see the Door." Touch it! 🚪 | I see the Door. Touch it! | `obj_room_door` | Excellent! You found the Door! 🚪 |
| Step 2 | `scenePlacement` | Put the Door nicely with Bed! ✨ | Put the Door with Bed | `obj_room_door` | Clean and tidy! Placed perfectly! ✨ |
| Step 3 | `speakToMakeSomethingHappen` | Say the full phrase: "This is my Door!" 🗣️ | Say: This is my Door! | `this is my door` | Super! "This is my Door!" Great speaking! 🌟 |
| Step 4 | `conversationRolePlay` | Pip asks: "Do you like the Door?" Answer: "Yes, I like it!" 💬 | Do you like the Door? Say: Yes, I like it! | `yes i like it` | "Yes, I like it!" What a nice chat! ❤️ |
| Step 5 | `listenAndTouch` | Touch the star to complete your lesson! ⭐🎉 | Touch the star to complete! | `obj_room_door` | Lesson complete! You are becoming a great speaker! 🌟🏆 |

#### Lesson: I Like Apples! 🍎 (`t2_l07_i_like_apples`)
- **Unit**: `unit_t2_food` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "I like red apples."
- **Listening Target**: Child identifies fruit preferences.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen carefully: "I see the Apple." Touch it! 🍎 | I see the Apple. Touch it! | `obj_food_apple` | Excellent! You found the Apple! 🍎 |
| Step 2 | `scenePlacement` | Put the Apple nicely with Banana! ✨ | Put the Apple with Banana | `obj_food_apple` | Clean and tidy! Placed perfectly! ✨ |
| Step 3 | `speakToMakeSomethingHappen` | Say the full phrase: "This is my Apple!" 🗣️ | Say: This is my Apple! | `this is my apple` | Super! "This is my Apple!" Great speaking! 🌟 |
| Step 4 | `conversationRolePlay` | Pip asks: "Do you like the Apple?" Answer: "Yes, I like it!" 💬 | Do you like the Apple? Say: Yes, I like it! | `yes i like it` | "Yes, I like it!" What a nice chat! ❤️ |
| Step 5 | `listenAndTouch` | Touch the star to complete your lesson! ⭐🎉 | Touch the star to complete! | `obj_food_apple` | Lesson complete! You are becoming a great speaker! 🌟🏆 |

#### Lesson: Where Is My Ball? ⚽🔍 (`t2_l10_where_is_my_ball`)
- **Unit**: `unit_t2_home` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child asks: "Where is the ball?"
- **Listening Target**: Child searches and points to ball in room.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look and listen: Can you find the Door? 🚪 | Find the Door. | `obj_room_door` | You found the Door! 🚪 |
| Step 2 | `dragAndDrop` | Move the Door over here! 🚪 | Move the Door | `obj_room_door` | Nicely moved! 🚪✨ |
| Step 3 | `speakToMakeSomethingHappen` | Say it clearly: "This is a Door!" 🗣️ | Say: This is a Door! | `this is a door` | Awesome! "This is a Door!" 🌟 |
| Step 4 | `conversationRolePlay` | Pip asks: "Do you see the Door?" Answer: "Yes, I see it!" 💬 | Answer: Yes, I see it! | `yes i see it` | "Yes, I see it!" Great chat! ❤️ |
| Step 5 | `listenAndTouch` | Touch Pip to finish your lesson! ⭐🎉 | Touch Pip to finish! | `obj_room_bed` | Great job! You are becoming a wonderful speaker! 🌟🏆 |

#### Lesson: The Big Friendly Dog 🐶 (`t2_l14_the_big_dog`)
- **Unit**: `unit_t2_animals` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "This is a big dog."
- **Listening Target**: Child distinguishes big dog from small puppy.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen carefully: "I see the Cat." Touch it! 🐱 | I see the Cat. Touch it! | `obj_animal_cat` | Excellent! You found the Cat! 🐱 |
| Step 2 | `scenePlacement` | Put the Cat nicely with Dog! ✨ | Put the Cat with Dog | `obj_animal_cat` | Clean and tidy! Placed perfectly! ✨ |
| Step 3 | `speakToMakeSomethingHappen` | Say the full phrase: "This is my Cat!" 🗣️ | Say: This is my Cat! | `this is my cat` | Super! "This is my Cat!" Great speaking! 🌟 |
| Step 4 | `conversationRolePlay` | Pip asks: "Do you like the Cat?" Answer: "Yes, I like it!" 💬 | Do you like the Cat? Say: Yes, I like it! | `yes i like it` | "Yes, I like it!" What a nice chat! ❤️ |
| Step 5 | `listenAndTouch` | Touch the star to complete your lesson! ⭐🎉 | Touch the star to complete! | `obj_animal_cat` | Lesson complete! You are becoming a great speaker! 🌟🏆 |

### Track Young Speakers (Age 7–8) — Track 3 — Young Speakers
- **Age Band Focus**: Build real beginner spoken English. Complete sentence patterns, wh-questions, functional polite language in school, home, and play.

#### Lesson: My Name and My Age 👦🎂 (`t3_l01_my_name_and_age`)
- **Unit**: `unit_t3_me_family` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child states name and age in full sentences.
- **Listening Target**: Child comprehends age questions.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen carefully: Where is the Pip? Touch the Pip! 🦜 | Where is the Pip? Touch it! | `obj_pip_greeter` | Great listening! You found the Pip! 🦜 |
| Step 2 | `scenePlacement` | Place the Pip near the Happy. 🧩 | Place the Pip near the Happy | `obj_pip_greeter` | Great job placing it in the right spot! ✨ |
| Step 3 | `speakToMakeSomethingHappen` | Speak a complete sentence: "There is a Pip here." 🗣️ | Say: There is a Pip here. | `there is a pip` | Awesome! "There is a Pip here!" Full sentence spoken! 🌟 |
| Step 4 | `conversationRolePlay` | Pip asks: "Where is the Pip?" Answer: "It is right here!" 💬 | Answer: It is right here! | `it is right here` | "It is right here!" Great response! Very helpful! ❤️ |
| Step 5 | `listenAndTouch` | Touch Pip to celebrate finishing your lesson! ⭐🎉 | Touch Pip to finish! | `obj_pip_greeter` | Hooray! Fantastic work today! 🌟🎉 |

#### Lesson: There Is a Lamp 💡🪵 (`t3_l04_there_is_a_lamp`)
- **Unit**: `unit_t3_home` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child produces: "There is a lamp on the table."
- **Listening Target**: Child identifies singular items in rooms.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen carefully: Where is the Door? Touch the Door! 🚪 | Where is the Door? Touch it! | `obj_room_door` | Great listening! You found the Door! 🚪 |
| Step 2 | `scenePlacement` | Place the Door near the Bed. 🧩 | Place the Door near the Bed | `obj_room_door` | Great job placing it in the right spot! ✨ |
| Step 3 | `speakToMakeSomethingHappen` | Speak a complete sentence: "There is a Door here." 🗣️ | Say: There is a Door here. | `there is a door` | Awesome! "There is a Door here!" Full sentence spoken! 🌟 |
| Step 4 | `conversationRolePlay` | Pip asks: "Where is the Door?" Answer: "It is right here!" 💬 | Answer: It is right here! | `it is right here` | "It is right here!" Great response! Very helpful! ❤️ |
| Step 5 | `listenAndTouch` | Touch Pip to celebrate finishing your lesson! ⭐🎉 | Touch Pip to finish! | `obj_room_bed` | Hooray! Fantastic work today! 🌟🎉 |

#### Lesson: Can You Help Me, Please? 🤝 (`t3_l07_can_you_help_me`)
- **Unit**: `unit_t3_school` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child asks for help politely with full question structure.
- **Listening Target**: Child recognizes help requests.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen carefully: Where is the Pip? Touch it! 🦜 | Where is the Pip? Touch it! | `obj_pip_greeter` | Great listening! You found the Pip! 🦜 |
| Step 2 | `dragAndDrop` | Move the Pip over to Happy. 🤝 | Move the Pip to Happy | `obj_pip_greeter` | Nicely moved! Great job! ✨ |
| Step 3 | `speakToMakeSomethingHappen` | Say what you did: "I put the Pip here." 🗣️ | Say: I put the Pip here. | `i put the pip here` | Great speaking! Full sentence complete! 🌟 |
| Step 4 | `scenePlacement` | Place the Pip gently near Happy. 🧩 | Place the Pip near Happy | `obj_pip_greeter` | Placed in the right spot! Looks wonderful! ✨ |
| Step 5 | `conversationRolePlay` | Pip asks: "Is everything in its place?" Answer: "Yes, everything is ready!" 💬 | Answer: Yes, everything is ready! | `yes everything is ready` | Super! "Yes, everything is ready!" Polite and clear! ❤️ |
| Step 6 | `listenAndTouch` | Touch Pip to celebrate finishing your lesson! ⭐🎉 | Touch Pip to finish! | `obj_pip_greeter` | Hooray! Outstanding progress today! 🌟🏆 |

#### Lesson: Can I Have Some Water, Please? 💧 (`t3_l10_can_i_have_water_please`)
- **Unit**: `unit_t3_food` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child requests drinks politely in full complete sentence.
- **Listening Target**: Child understands dining offers.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Pip says: "Playing in the sun makes us thirsty!" Can you find the water? 💧 | Find the fresh water. | `obj_food_water` | Clean water is the best drink for our health! 💧✨ |
| Step 2 | `speakToMakeSomethingHappen` | Speak the complete polite request: "Can I have some water, please?" 🗣️ | Can you say: Can I have some water, please? | `can i have some water please` | "Can I have some water, please?" Beautiful complete sentence! 🌟 |
| Step 3 | `scenePlacement` | Good etiquette: Place the glass of water gently on the table. 🍽️💧 | Place the glass of water on the table | `obj_food_water` | Perfect placement! Drinking with good manners is wonderful! 🪵✨ |
| Step 4 | `conversationRolePlay` | Pip offers lemon with your water. Respond politely: "Yes, please! Thank you!" 💬 | Respond politely: Yes, please! Thank you! | `yes please thank you` | "Yes, please! Thank you!" Excellent polite manners! ❤️ |
| Step 5 | `listenAndTouch` | Remember to say "Alhamdulillah" after finishing your drink. Tap the table to complete! 🤲⭐ | Tap the table to finish with gratitude! | `obj_dining_table` | Alhamdulillah for clean water! Mastery earned! 🌟🏆 |

#### Lesson: Birds Can Fly High 🐦 (`t3_l14_the_bird_can_fly`)
- **Unit**: `unit_t3_animals` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child states abilities: "The bird can fly high in the sky."
- **Listening Target**: Child connects animal to its ability.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen carefully: Where is the Cat? Touch the Cat! 🐱 | Where is the Cat? Touch it! | `obj_animal_cat` | Great listening! You found the Cat! 🐱 |
| Step 2 | `scenePlacement` | Place the Cat near the Dog. 🧩 | Place the Cat near the Dog | `obj_animal_cat` | Great job placing it in the right spot! ✨ |
| Step 3 | `speakToMakeSomethingHappen` | Speak a complete sentence: "There is a Cat here." 🗣️ | Say: There is a Cat here. | `there is a cat` | Awesome! "There is a Cat here!" Full sentence spoken! 🌟 |
| Step 4 | `conversationRolePlay` | Pip asks: "Where is the Cat?" Answer: "It is right here!" 💬 | Answer: It is right here! | `it is right here` | "It is right here!" Great response! Very helpful! ❤️ |
| Step 5 | `listenAndTouch` | Touch Pip to celebrate finishing your lesson! ⭐🎉 | Touch Pip to finish! | `obj_animal_dog` | Hooray! Fantastic work today! 🌟🎉 |

### Track Growing Communicators (Age 9–10) — Track 4 — Growing Communicators
- **Age Band Focus**: Move from beginner sentences into real conversation. Multi-turn dialogues, simple reasons, describing experiences, authentic non-toddler UI.

#### Lesson: My Passions and Aspirations 🌟 (`t4_l01_my_passions_and_goals`)
- **Unit**: `unit_t4_identity` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student delivers a multi-sentence self-introduction focusing on passions.
- **Listening Target**: Student identifies key speaker details.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen to the description and find the Happy. 😊 | Find the Happy. | `obj_happy_face` | Great listening! You found the Happy! 😊 |
| Step 2 | `speakToMakeSomethingHappen` | Give a reason: "I prefer the Happy because it is useful." 🗣️ | Say: I prefer the Happy because it is useful. | `i prefer the happy because it is useful` | "I prefer the Happy..." Thoughtful choice and clear reason! 🌟 |
| Step 3 | `scenePlacement` | Place the Happy nicely with Pip. 🧩 | Place the Happy with Pip | `obj_happy_face` | Nicely placed! Looks great! ✨ |
| Step 4 | `conversationRolePlay` | Pip asks why. Answer: "Because it helps us learn and stay organized." 💬 | Answer: Because it helps us learn and stay organized. | `because it helps us learn and stay organized` | Great explanation! That makes a lot of sense! ❤️ |
| Step 5 | `listenAndTouch` | Tap Pip to celebrate completing today's lesson! 🏅 | Tap Pip to finish! | `obj_pip_greeter` | Excellent work! Another great step forward in speaking English! 🌟🎓 |

#### Lesson: My Favorite Subject Because... 🔬 (`t4_l04_favorite_subjects_with_reasons`)
- **Unit**: `unit_t4_school` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student shares favorite subjects with specific reasons.
- **Listening Target**: Student identifies words that explain reasons like because.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen to the description and find the Whiteboard. 📋 | Find the Whiteboard. | `obj_school_board` | Great listening! You found the Whiteboard! 📋 |
| Step 2 | `speakToMakeSomethingHappen` | Give a reason: "I prefer the Whiteboard because it is useful." 🗣️ | Say: I prefer the Whiteboard because it is useful. | `i prefer the whiteboard because it is useful` | "I prefer the Whiteboard..." Thoughtful choice and clear reason! 🌟 |
| Step 3 | `scenePlacement` | Place the Whiteboard nicely with Desk. 🧩 | Place the Whiteboard with Desk | `obj_school_board` | Nicely placed! Looks great! ✨ |
| Step 4 | `conversationRolePlay` | Pip asks why. Answer: "Because it helps us learn and stay organized." 💬 | Answer: Because it helps us learn and stay organized. | `because it helps us learn and stay organized` | Great explanation! That makes a lot of sense! ❤️ |
| Step 5 | `listenAndTouch` | Tap Pip to celebrate completing today's lesson! 🏅 | Tap Pip to finish! | `obj_school_desk` | Excellent work! Another great step forward in speaking English! 🌟🎓 |

#### Lesson: My Morning Schedule 🌅 (`t4_l07_my_morning_habits`)
- **Unit**: `unit_t4_routines` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student describes morning routine using "usually" and "always".
- **Listening Target**: Student sequences time milestones.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `interactiveStory` | Listen to the story: Good habits make every day bright and productive! 📖 | Listen to the story. | `obj_room_door` | Great listening! Reflecting on habits helps us build character! 🌟 |
| Step 2 | `listenAndTouch` | Find the item from the story: Touch the Door! 🔍 | Find the Door. | `obj_room_door` | Found it! Door identified! 🚪 |
| Step 3 | `speakToMakeSomethingHappen` | Say what you learned: "We practiced patience and finished the task." 🗣️ | Say: We practiced patience and finished the task. | `we practiced patience and finished the task` | Well spoken! Patience is a wonderful virtue! 🌟 |
| Step 4 | `scenePlacement` | Put the Door neatly in its proper spot. 🪵 | Place the Door in its proper spot | `obj_room_door` | Tidy and organized! Clean habits bring peace! ✨ |
| Step 5 | `conversationRolePlay` | Pip asks what you learned. Answer: "Patience and good manners make everything better." 💬 | Answer: Patience and good manners make everything better. | `patience and good manners make everything better` | Wise and thoughtful! A gentle reminder for all of us! ❤️ |
| Step 6 | `listenAndTouch` | Tap Pip to complete today's lesson! ⭐🎉 | Tap Pip to finish! | `obj_room_bed` | Great job! You spoke and shared wonderful ideas today! 🌟🏆 |

#### Lesson: I Prefer Fresh Fruit Because... 🍎 (`t4_l10_preferring_fresh_fruit`)
- **Unit**: `unit_t4_food` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student expresses comparative preferences: "I prefer apples over candy because..."
- **Listening Target**: Student evaluates nutritional reasons.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Pip describes a sweet, crisp fruit that grows on trees. Can you find the apple? 🍎 | Find the crisp red apple. | `obj_food_apple` | Correct! Fresh apples provide natural vitamins and energy! 🍎✨ |
| Step 2 | `speakToMakeSomethingHappen` | Explain your choice with a reason: "I prefer apples because they are healthy and fresh." 🗣️ | Say: I prefer apples because they are healthy and fresh. | `i prefer apples because they are healthy` | "I prefer apples because they are healthy!" Clear reasoning and great delivery! 🌟 |
| Step 3 | `scenePlacement` | Arrange a balanced lunch plate on the table with healthy food. 🍽️ | Put the apple on the lunch table | `obj_food_apple` | Balanced arrangement! Fresh fruit keeps our mind and body sharp! 🪵✨ |
| Step 4 | `conversationRolePlay` | Pip asks your view on sweet snacks. Share your opinion: "I think fruit gives us better energy." 💬 | Share your view: I think fruit gives us better energy. | `i think fruit gives us better energy` | Well reasoned! Whole foods nourish the mind and keep us sharp for study! ❤️ |
| Step 5 | `listenAndTouch` | Tap Pip to conclude today's discussion on healthy food! 🏅 | Tap Pip to complete your discussion! | `obj_dining_pip` | Excellent conversation! You shared thoughtful reasons today! 🌟🏆 |

#### Lesson: Sketching Outdoor Nature 🎨🌿 (`t4_l14_sketching_nature`)
- **Unit**: `unit_t4_hobbies` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student describes an artistic hobby and materials used.
- **Listening Target**: Student follows art instruction steps.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `interactiveStory` | Listen to the story: Good habits make every day bright and productive! 📖 | Listen to the story. | `obj_park_tree` | Great listening! Reflecting on habits helps us build character! 🌟 |
| Step 2 | `listenAndTouch` | Find the item from the story: Touch the Big Tree! 🔍 | Find the Big Tree. | `obj_park_tree` | Found it! Big Tree identified! 🌳 |
| Step 3 | `speakToMakeSomethingHappen` | Say what you learned: "We practiced patience and finished the task." 🗣️ | Say: We practiced patience and finished the task. | `we practiced patience and finished the task` | Well spoken! Patience is a wonderful virtue! 🌟 |
| Step 4 | `scenePlacement` | Put the Big Tree neatly in its proper spot. 🪵 | Place the Big Tree in its proper spot | `obj_park_tree` | Tidy and organized! Clean habits bring peace! ✨ |
| Step 5 | `conversationRolePlay` | Pip asks what you learned. Answer: "Patience and good manners make everything better." 💬 | Answer: Patience and good manners make everything better. | `patience and good manners make everything better` | Wise and thoughtful! A gentle reminder for all of us! ❤️ |
| Step 6 | `listenAndTouch` | Tap Pip to complete today's lesson! ⭐🎉 | Tap Pip to finish! | `obj_park_flower` | Great job! You spoke and shared wonderful ideas today! 🌟🏆 |

### Track Confident Communicators (Age 11–12) — Track 5 — Confident Communicators
- **Age Band Focus**: Confident practical spoken English. Nuanced opinions, past/present/future usage in context, collaborative scenarios, problem solving.

#### Lesson: Defining Personal Principles 🧭 (`t5_l01_personal_philosophy`)
- **Unit**: `unit_t5_identity` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student explains personal core values with real-life examples.
- **Listening Target**: Student listens to and compares different viewpoints on character.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen to the clues and find the Happy. 😊 | Find the Happy. | `obj_happy_face` | Great listening! You found the Happy! 😊 |
| Step 2 | `speakToMakeSomethingHappen` | Share your view: "In my opinion, the Happy is very important." 🗣️ | Say: In my opinion, the Happy is very important. | `in my opinion the happy is very important` | "In my opinion..." Thoughtful and articulate opinion! 🌟 |
| Step 3 | `scenePlacement` | Put the Happy in place with Pip. 🧩 | Place the Happy with Pip | `obj_happy_face` | Placed in the right spot! Context complete! ✨ |
| Step 4 | `conversationRolePlay` | Pip asks why. Answer: "Because it helps people and makes things better." 💬 | Answer: Because it helps people and makes things better. | `because it helps people and makes things better` | Very thoughtful reasoning! That makes a lot of sense! ❤️ |
| Step 5 | `listenAndTouch` | Tap Pip to complete today's discussion! ⭐🎓 | Tap Pip to finish! | `obj_pip_greeter` | Wonderful job today! Great speaking and thoughtful ideas! 🌟🏆 |

#### Lesson: Evaluating Scientific Data 🔬 (`t5_l04_evaluating_scientific_evidence`)
- **Unit**: `unit_t5_school` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student explains correlation vs causation in simple terms.
- **Listening Target**: Student follows technical data presentations.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen to the clues and find the Whiteboard. 📋 | Find the Whiteboard. | `obj_school_board` | Great listening! You found the Whiteboard! 📋 |
| Step 2 | `speakToMakeSomethingHappen` | Share your view: "In my opinion, the Whiteboard is very important." 🗣️ | Say: In my opinion, the Whiteboard is very important. | `in my opinion the whiteboard is very important` | "In my opinion..." Thoughtful and articulate opinion! 🌟 |
| Step 3 | `scenePlacement` | Put the Whiteboard in place with Desk. 🧩 | Place the Whiteboard with Desk | `obj_school_board` | Placed in the right spot! Context complete! ✨ |
| Step 4 | `conversationRolePlay` | Pip asks why. Answer: "Because it helps people and makes things better." 💬 | Answer: Because it helps people and makes things better. | `because it helps people and makes things better` | Very thoughtful reasoning! That makes a lot of sense! ❤️ |
| Step 5 | `listenAndTouch` | Tap Pip to complete today's discussion! ⭐🎓 | Tap Pip to finish! | `obj_school_desk` | Wonderful job today! Great speaking and thoughtful ideas! 🌟🏆 |

#### Lesson: Consultation Over Conflict 🤝 (`t5_l07_consultation_over_conflict`)
- **Unit**: `unit_t5_friendship` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student demonstrates how mutual Shura resolves deadlocks.
- **Listening Target**: Student detects conflict de-escalation strategies.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen to the situation: Find the Happy. 😊 | Listen to the situation and select the Happy. | `obj_happy_face` | Great listening! Found the Happy! 😊 |
| Step 2 | `dragAndDrop` | Work together: Move the Happy over to Pip to share. 🤝 | Move the Happy to share with Pip | `obj_happy_face` | Cooperation makes solving problems easier! ✨ |
| Step 3 | `speakToMakeSomethingHappen` | Suggest a helpful idea: "Why don't we share and work together?" 🗣️ | Suggest: Why don't we share and work together? | `why do we not share and work together` | Great suggestion! Working together is always the best solution! 🌟 |
| Step 4 | `conversationRolePlay` | Pip asks how to resolve it fairly. Answer: "We listen with respect and find common ground." 💬 | Answer: We listen with respect and find common ground. | `we listen with respect and find common ground` | Very wise! Listening with respect helps everyone feel valued! ❤️ |
| Step 5 | `scenePlacement` | Put the Happy neatly beside Pip. 🧩 | Place the Happy beside Pip | `obj_happy_face` | Everything is in order! Great teamwork! ✨ |
| Step 6 | `listenAndTouch` | Tap Pip to celebrate solving this problem together! ⭐🎉 | Tap Pip to finish! | `obj_pip_greeter` | Hooray! Outstanding communication and problem solving! 🌟🏆 |

#### Lesson: Artificial Intelligence & Ethics 🤖 (`t5_l10_ai_and_human_wisdom`)
- **Unit**: `unit_t5_technology` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student debates benefits and ethical risks of AI tools.
- **Listening Target**: Student evaluates arguments regarding digital ethics.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen to the clues and find the Whiteboard. 📋 | Find the Whiteboard. | `obj_school_board` | Great listening! You found the Whiteboard! 📋 |
| Step 2 | `speakToMakeSomethingHappen` | Share your view: "In my opinion, the Whiteboard is very important." 🗣️ | Say: In my opinion, the Whiteboard is very important. | `in my opinion the whiteboard is very important` | "In my opinion..." Thoughtful and articulate opinion! 🌟 |
| Step 3 | `scenePlacement` | Put the Whiteboard in place with Desk. 🧩 | Place the Whiteboard with Desk | `obj_school_board` | Placed in the right spot! Context complete! ✨ |
| Step 4 | `conversationRolePlay` | Pip asks why. Answer: "Because it helps people and makes things better." 💬 | Answer: Because it helps people and makes things better. | `because it helps people and makes things better` | Very thoughtful reasoning! That makes a lot of sense! ❤️ |
| Step 5 | `listenAndTouch` | Tap Pip to complete today's discussion! ⭐🎓 | Tap Pip to finish! | `obj_school_desk` | Wonderful job today! Great speaking and thoughtful ideas! 🌟🏆 |

#### Lesson: Why Drinking Water Matters 💧🧠 (`t5_l14_hydration_and_cognitive_power`)
- **Unit**: `unit_t5_health` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student explains with clear reasons: "Why is drinking water important? In my opinion..."
- **Listening Target**: Student understands health and hydration explanations.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Pip explains: "Drinking clean water helps our brain focus and keeps our body healthy!" Touch the fresh water! 💧 | Touch the fresh water that keeps our body hydrated. | `obj_food_water` | Fresh, cool water! Essential for keeping our body and mind alert! 💧✨ |
| Step 2 | `speakToMakeSomethingHappen` | Share your opinion: "Why is drinking water important? I think it helps our body stay healthy and active." 🗣️ | Say: Why is drinking water important? I think it helps our body stay healthy. | `why is drinking water important i think` | "I think it helps our body stay healthy..." Clear and thoughtful answer! 🌟 |
| Step 3 | `scenePlacement` | Put a glass of fresh water on your study desk so you remember to drink. 🪵💧 | Place the water on the study desk | `obj_food_water` | Great habit! Having water nearby helps you stay alert while studying! 🪵✨ |
| Step 4 | `conversationRolePlay` | Pip asks about taking care of ourselves. Answer: "Our body is a trust from Allah, so we must take care of it." 💬 | Answer: Our body is a trust from Allah, so we must take care of it. | `our body is a trust from allah` | Wonderful thought! Taking care of our health is a great blessing and trust! ❤️ |
| Step 5 | `listenAndTouch` | Tap Pip to complete today's discussion! 🎓 | Tap Pip to complete the activity! | `obj_dining_pip` | Fantastic discussion! You shared thoughtful and mature ideas! 🌟🏆 |

---

## Section 9: Special Cross-Age Progression Audit (5 Core Themes Across Ages 3, 5, 7, 9, 11)
Demonstrates the explicit developmental progression from concrete single-word imitation to complex discourse, reason, and social ethics across 5 recurring domains.

### Theme: 1. FOOD & DRINKS

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l13_sweet_red_apple` | Child says "Apple". | `speakToMakeSomethingHappen` | Apple! Can you say Apple? 🍎 | `apple` |
| Age 5 (Track 2) | `t2_l08_water_please` | Child says polite request: "Can I have water, please?" | `speakToMakeSomethingHappen` | When you are thirsty, say: "Water, please!" 💧 | `water please` |
| Age 7 (Track 3) | `t3_l10_can_i_have_water_please` | Child requests drinks politely in full complete sentence. | `speakToMakeSomethingHappen` | Speak the complete polite request: "Can I have some water, please?" 🗣️ | `can i have some water please` |
| Age 9 (Track 4) | `t4_l10_preferring_fresh_fruit` | Student expresses comparative preferences: "I prefer apples over candy because..." | `speakToMakeSomethingHappen` | Explain your choice with a reason: "I prefer apples because they are healthy and fresh." 🗣️ | `i prefer apples because they are healthy` |
| Age 11 (Track 5) | `t5_l14_hydration_and_cognitive_power` | Student explains with clear reasons: "Why is drinking water important? In my opinion..." | `speakToMakeSomethingHappen` | Share your opinion: "Why is drinking water important? I think it helps our body stay healthy and active." 🗣️ | `why is drinking water important i think` |

### Theme: 2. MY HOME & LIVING SPACES

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l17_book_on_table` | Child echoes "Book". | `speakToMakeSomethingHappen` | Can you say Door? 🚪 | `door` |
| Age 5 (Track 2) | `t2_l11_on_the_table` | Child says: "It is on the table." | `speakToMakeSomethingHappen` | Say the full phrase: "This is my Door!" 🗣️ | `this is my door` |
| Age 7 (Track 3) | `t3_l04_there_is_a_lamp` | Child produces: "There is a lamp on the table." | `speakToMakeSomethingHappen` | Speak a complete sentence: "There is a Door here." 🗣️ | `there is a door` |
| Age 9 (Track 4) | `t4_l07_my_morning_habits` | Student describes morning routine using "usually" and "always". | `speakToMakeSomethingHappen` | Say what you learned: "We practiced patience and finished the task." 🗣️ | `we practiced patience and finished the task` |
| Age 11 (Track 5) | `t5_l16_sleep_and_memory_consolidation` | Student explains how adequate sleep enhances learning and mood. | `speakToMakeSomethingHappen` | Share your view: "In my opinion, the Apple is very important." 🗣️ | `in my opinion the apple is very important` |

### Theme: 3. ANIMALS & NATURE STEWARDSHIP

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l10_friendly_cat` | Child imitates "Meow". | `speakToMakeSomethingHappen` | Can you say Cat? Or make the sound! 🗣️ | `cat` |
| Age 5 (Track 2) | `t2_l14_the_big_dog` | Child says: "This is a big dog." | `speakToMakeSomethingHappen` | Say the full phrase: "This is my Cat!" 🗣️ | `this is my cat` |
| Age 7 (Track 3) | `t3_l16_caring_for_our_pets` | Child says: "We should give clean water and food to the cat." | `speakToMakeSomethingHappen` | Speak a complete sentence: "There is a Cat here." 🗣️ | `there is a cat` |
| Age 9 (Track 4) | `t4_l24_planting_trees_for_future` | Student describes planting procedures and ecological value. | `speakToMakeSomethingHappen` | Give a reason: "I prefer the Big Tree because it is useful." 🗣️ | `i prefer the big tree because it is useful` |
| Age 11 (Track 5) | `t5_l21_preserving_biodiversity` | Student explains the balance of ecosystems (Mizan). | `speakToMakeSomethingHappen` | Share your view: "In my opinion, the Big Tree is very important." 🗣️ | `in my opinion the big tree is very important` |

### Theme: 4. SCHOOL & LEARNING COMMUNITY

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l21_build_blocks` | Child says "Blocks". | `speakToMakeSomethingHappen` | Can you say Ball? ⚽ | `ball` |
| Age 5 (Track 2) | `t2_l16_this_is_my_pencil` | Child says: "This is my yellow pencil." | `speakToMakeSomethingHappen` | Say the full phrase: "This is my Whiteboard!" 🗣️ | `this is my whiteboard` |
| Age 7 (Track 3) | `t3_l06_i_need_my_bag` | Child expresses necessity: "I need my school bag for class." | `speakToMakeSomethingHappen` | Speak a complete sentence: "There is a Door here." 🗣️ | `there is a door` |
| Age 9 (Track 4) | `t4_l04_favorite_subjects_with_reasons` | Student shares favorite subjects with specific reasons. | `speakToMakeSomethingHappen` | Give a reason: "I prefer the Whiteboard because it is useful." 🗣️ | `i prefer the whiteboard because it is useful` |
| Age 11 (Track 5) | `t5_l04_evaluating_scientific_evidence` | Student explains correlation vs causation in simple terms. | `speakToMakeSomethingHappen` | Share your view: "In my opinion, the Whiteboard is very important." 🗣️ | `in my opinion the whiteboard is very important` |

### Theme: 5. FEELINGS & SOCIAL EMPATHY

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l02_happy_or_sad` | Child says "Happy" with a smile. | `speakToMakeSomethingHappen` | Say Pip! Or tap to hear it! 🗣️ | `pip` |
| Age 5 (Track 2) | `t2_l01_i_am_happy` | Child says: "I am happy today!" | `speakToMakeSomethingHappen` | Say the full phrase: "This is my Pip!" 🗣️ | `this is my pip` |
| Age 7 (Track 3) | `t3_l17_play_with_us` | Child invites a peer: "Would you like to play with us?" | `speakToMakeSomethingHappen` | Speak a complete sentence: "There is a Ball here." 🗣️ | `there is a ball` |
| Age 9 (Track 4) | `t4_l26_explaining_why_i_feel` | Student explains feelings and what caused them. | `speakToMakeSomethingHappen` | Give a reason: "I prefer the Big Tree because it is useful." 🗣️ | `i prefer the big tree because it is useful` |
| Age 11 (Track 5) | `t5_l10_ai_and_human_wisdom` | Student debates benefits and ethical risks of AI tools. | `speakToMakeSomethingHappen` | Share your view: "In my opinion, the Whiteboard is very important." 🗣️ | `in my opinion the whiteboard is very important` |

