# CURRICULUM_CONTENT_V2 — HUMAN CONTENT AUDIT V2

> Comprehensive Quality Lock Audit verifying natural child language, sequence variation, age calibration, and Islamic governance across all 5 age groups.

## Executive Inventory Snapshot
- **Total Production Lessons**: 150
- **Total Interactive Interactions**: 750 (minimum threshold: >= 750)
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
| Step 1 | `listenAndTouch` | Hello! Pip is waving to you! Touch Pip! 👋🦜 | Hello | `obj_pip_greeter` | Hello friend! Pip is so happy to see you! 🦜👋 |
| Step 2 | `dragAndDrop` | Bring Pip to the mirror to say hello! 🦜🪞 | Move the Pip | `obj_pip_greeter` | Look at you! You are wonderful! 🪞✨ |
| Step 3 | `speakToMakeSomethingHappen` | Can you say Hello? Or tap Pip! 👋 | hello | `hello` | Wonderful! You said "hello"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip waves: "Hello friend!" Say: "Hello!" 💬 | Pip waves: "Hello friend!" | `hello` | Pip smiles: "hello! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch Pip to celebrate our first greeting! 🦜🎉 | Tap to finish! | `obj_pip_greeter` | MashaAllah! You learned Hello! 🌟⭐ |

#### Lesson: Touch Your Nose! 👃 (`t1_l04_touch_your_nose`)
- **Unit**: `unit_t1_body` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child echoes "Nose".
- **Listening Target**: Child touches nose in response to audio.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Where is the nose? Touch the nose! 👃✨ | Nose | `obj_body_nose` | Touch your nose! 👃✨ |
| Step 2 | `dragAndDrop` | Bring clean hands gently to touch the nose! 👃🙌 | Move the Hands | `obj_body_hands` | Touch your nose! 👃✨ |
| Step 3 | `speakToMakeSomethingHappen` | Can you say "Nose"? Or tap the nose! 👃🎙️ | nose | `nose` | Wonderful! You said "nose"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip touches nose: "Where is your nose?" Say: "Nose!" 💬 | Pip points: "Touch your nose!" | `nose` | Pip smiles: "nose! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch your nose to celebrate our wonderful senses! 🌟 | Tap to finish! | `obj_body_nose` | MashaAllah! You learned Nose! 🌟⭐ |

#### Lesson: Red Ball & Basket 🔴 (`t1_l07_red_apple_basket`)
- **Unit**: `unit_t1_colors` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child repeats "Red".
- **Listening Target**: Child selects and places red item.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Where is the bright red ball? Touch it! 🔴🍎 | Red Ball | `obj_color_red_ball` | Bright red! Like a sweet red apple! 🔴🍎 |
| Step 2 | `dragAndDrop` | Put the red ball inside the matching red basket! 🔴🧺 | Move the Red Ball | `obj_color_red_ball` | Red ball in the red basket! Perfect! 🧺🔴 |
| Step 3 | `speakToMakeSomethingHappen` | Can you say "Red"? Bright red! 🔴🎙️ | red | `red` | Wonderful! You said "red"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip asks: "What color is the red ball?" Say: "Red!" 💬 | Pip holds the red ball: "What color is this?" | `red` | Pip smiles: "red! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch the red basket to celebrate color sorting! 🌟 | Tap to finish! | `obj_color_red_ball` | MashaAllah! You learned Red Ball! 🌟⭐ |

#### Lesson: Gentle Cat Purrs 🐱 (`t1_l10_friendly_cat`)
- **Unit**: `unit_t1_animals` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child imitates "Meow".
- **Listening Target**: Child recognizes cat and pets softly.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen to the gentle purr! Touch the soft cat! 🐱❤️ | Cat | `obj_animal_cat` | Meow! The friendly cat purrs softly! 🐱❤️ |
| Step 2 | `dragAndDrop` | Bring the cat over to the fresh clean bowl! 🐱🥣 | Move the Cat | `obj_animal_cat` | Clean refreshing water for our animal friends! 🥣💧 |
| Step 3 | `speakToMakeSomethingHappen` | Can you make the cat sound? Say "Meow"! 🐱🎙️ | meow | `meow` | Wonderful! You said "meow"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip pets the cat: "What does the cat say?" Say: "Meow!" 💬 | Pip pets the cat: "What does the gentle cat say?" | `meow` | Pip smiles: "meow! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch the cat to celebrate being kind to animals! 🌟 | Tap to finish! | `obj_animal_cat` | MashaAllah! You learned Cat! 🌟⭐ |

#### Lesson: Cool Water, Please 💧 (`t1_l14_cool_clean_water`)
- **Unit**: `unit_t1_food` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child says "Water".
- **Listening Target**: Child offers water cup to thirsty character.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Refreshing and clean! Touch the glass of water! 💧🥤 | Water | `obj_food_water` | Refreshing clean water! Sit down to drink! 💧🥤 |
| Step 2 | `feedCharacter` | Pip is thirsty! Offer the cool clean water to Pip! 💧🦜 | Move the Water | `obj_food_water` | Pip says: "Thank you! JazakAllahu khayran!" 🦜❤️ |
| Step 3 | `speakToMakeSomethingHappen` | Can you say "Water"? Pure clean water! 💧🎙️ | water | `water` | Wonderful! You said "water"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip chirps: "Thirsty! What should I drink?" Say: "Water!" 💬 | Pip is thirsty: "What should we drink when thirsty?" | `water` | Pip smiles: "water! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch the water to celebrate staying fresh and hydrated! 🌟 | Tap to finish! | `obj_food_water` | MashaAllah! You learned Water! 🌟⭐ |

### Track Little Speakers (Age 5–6) — Track 2 — Little Speakers
- **Age Band Focus**: Vocabulary to phrases to first functional sentences. Minimal text, high visual support, polite functional expressions.

#### Lesson: I am Happy! 😊 (`t2_l01_i_am_happy`)
- **Unit**: `unit_t2_me` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "I am happy today!"
- **Listening Target**: Child identifies happy character.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Show your feelings! Touch the happy smiling face! 😊✨ | Happy Face | `obj_happy_face` | I am happy! Big smile! 😊✨ |
| Step 2 | `dragAndDrop` | Share your happiness! Bring the smile to Pip! 🦜😊 | Move the Happy | `obj_happy_face` | Hello friend! Pip is so happy to see you! 🦜👋 |
| Step 3 | `speakToMakeSomethingHappen` | Speak in a complete sentence: "I am happy today!" 🎙️ | i am happy today | `i am happy today` | Wonderful! You said "i am happy today"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip asks: "How are you feeling today?" Say: "I am happy today!" 💬 | Pip asks: "How are you feeling today?" | `i am happy today` | Pip smiles: "i am happy today! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch Pip to celebrate joyful communication! 🌟 | Tap to finish! | `obj_happy_face` | MashaAllah! You learned Happy Face! 🌟⭐ |

#### Lesson: This Is My Mother 👩 (`t2_l04_this_is_my_mother`)
- **Unit**: `unit_t2_family` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "This is my mother."
- **Listening Target**: Child selects mother icon in family photo.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Touch the loving family portrait! 👩❤️ | Mother | `obj_avatar_smile` | A big warm smile! 😄✨ |
| Step 2 | `dragAndDrop` | Introduce mother warmly to Pip! 👩🦜 | Move the Smile | `obj_avatar_smile` | Hello friend! Pip is so happy to see you! 🦜👋 |
| Step 3 | `speakToMakeSomethingHappen` | Say with respect and kindness: "This is my mother." 🎙️ | this is my mother | `this is my mother` | Wonderful! You said "this is my mother"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip asks: "Who is this?" Say: "This is my mother." 💬 | Pip asks: "Who takes care of you with love?" | `this is my mother` | Pip smiles: "this is my mother! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch the smile to celebrate honoring parents! 🌟 | Tap to finish! | `obj_avatar_smile` | MashaAllah! You learned Mother! 🌟⭐ |

#### Lesson: I Like Apples! 🍎 (`t2_l07_i_like_apples`)
- **Unit**: `unit_t2_food` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "I like red apples."
- **Listening Target**: Child identifies fruit preferences.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Sweet and crunchy! Touch the red apple! 🍎✨ | Apple | `obj_food_apple` | Crisp red apple! Say Bismillah before eating! 🍎✨ |
| Step 2 | `scenePlacement` | Place the red apple on the dining table! 🍎🪵 | Move the Apple | `obj_food_apple` | Placed neatly on the clean dining table! ✨ |
| Step 3 | `speakToMakeSomethingHappen` | Speak in a complete sentence: "I like red apples!" 🎙️ | i like red apples | `i like red apples` | Wonderful! You said "i like red apples"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip asks: "Do you like apples?" Say: "I like red apples!" 💬 | Pip asks: "What fruit do you enjoy eating?" | `i like red apples` | Pip smiles: "i like red apples! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch the apple to celebrate healthy fruit choices! 🌟 | Tap to finish! | `obj_food_apple` | MashaAllah! You learned Apple! 🌟⭐ |

#### Lesson: Where Is My Ball? ⚽🔍 (`t2_l10_where_is_my_ball`)
- **Unit**: `unit_t2_home` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child asks: "Where is the ball?"
- **Listening Target**: Child searches and points to ball in room.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look around the playroom! Touch the ball! ⚽🔍 | Ball | `obj_toy_ball` | Roll the ball! Playing together and taking turns! ⚽🤝 |
| Step 2 | `dragAndDrop` | Roll the ball safely into the toy box! ⚽📦 | Move the Ball | `obj_toy_ball` | Tidying up toys after playing! Clean and organized! 📦⭐ |
| Step 3 | `speakToMakeSomethingHappen` | Ask the question clearly: "Where is the ball?" 🎙️ | where is the ball | `where is the ball` | Wonderful! You said "where is the ball"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip searches: "Where is the ball?" Say: "Here it is!" 💬 | Pip searches: "Looking for our favorite toy!" | `here it is` | Pip smiles: "here it is! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch the ball to celebrate asking good questions! 🌟 | Tap to finish! | `obj_toy_ball` | MashaAllah! You learned Ball! 🌟⭐ |

#### Lesson: The Big Friendly Dog 🐶 (`t2_l14_the_big_dog`)
- **Unit**: `unit_t2_animals` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "This is a big dog."
- **Listening Target**: Child distinguishes big dog from small puppy.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Wagging its tail! Touch the big friendly dog! 🐶🐾 | Big Dog | `obj_animal_dog` | Woof woof! The loyal dog wags its tail! 🐶🐾 |
| Step 2 | `dragAndDrop` | Walk the dog to the fresh water bowl! 🐶🥣 | Move the Dog | `obj_animal_dog` | Clean refreshing water for our animal friends! 🥣💧 |
| Step 3 | `speakToMakeSomethingHappen` | Describe the dog in a sentence: "This is a big dog." 🎙️ | this is a big dog | `this is a big dog` | Wonderful! You said "this is a big dog"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip points: "What is this?" Say: "This is a big dog." 💬 | Pip greets the dog: "Look at the happy pet!" | `this is a big dog` | Pip smiles: "this is a big dog! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch the dog to celebrate caring for domestic animals! 🌟 | Tap to finish! | `obj_animal_dog` | MashaAllah! You learned Big Dog! 🌟⭐ |

### Track Young Speakers (Age 7–8) — Track 3 — Young Speakers
- **Age Band Focus**: Build real beginner spoken English. Complete sentence patterns, wh-questions, functional polite language in school, home, and play.

#### Lesson: My Name and My Age 👦🎂 (`t3_l01_my_name_and_age`)
- **Unit**: `unit_t3_me_family` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child states name and age in full sentences.
- **Listening Target**: Child comprehends age questions.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Identify and select the Mirror. 🌟 | Mirror | `obj_avatar_mirror` | Look at you! You are wonderful! 🪞✨ |
| Step 2 | `dragAndDrop` | Arrange the Pip with the Mirror. ✨ | Move the Pip | `obj_pip_greeter` | Look at you! You are wonderful! 🪞✨ |
| Step 3 | `speakToMakeSomethingHappen` | Clearly articulate: "my name is and i am seven years old" 🎙️ | my name is and i am seven years old | `my name is and i am seven years old` | Wonderful! You said "my name is and i am seven years old"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip greets you: "Tell me your name and your age!" Respond: "my name is and i am seven" 💬 | Pip greets you: "Tell me your name and your age!" | `my name is and i am seven` | Pip smiles: "my name is and i am seven! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Well done! Confirm your progress on Mirror! 🏅 | Tap to finish! | `obj_avatar_mirror` | MashaAllah! You learned Mirror! 🌟⭐ |

#### Lesson: There Is a Lamp 💡🪵 (`t3_l04_there_is_a_lamp`)
- **Unit**: `unit_t3_home` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child produces: "There is a lamp on the table."
- **Listening Target**: Child identifies singular items in rooms.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Identify and select the Desk Lamp. 🌟 | Desk Lamp | `obj_room_light` | The room is bright and welcoming! 💡✨ |
| Step 2 | `dragAndDrop` | Arrange the Book with the Table. ✨ | Move the Book | `obj_room_book` | Clean study table! 🪵✨ |
| Step 3 | `speakToMakeSomethingHappen` | Clearly articulate: "there is a lamp on the table" 🎙️ | there is a lamp on the table | `there is a lamp on the table` | Wonderful! You said "there is a lamp on the table"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip points: "What is on the study desk?" Respond: "there is a lamp" 💬 | Pip points: "What is on the study desk?" | `there is a lamp` | Pip smiles: "there is a lamp! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Well done! Confirm your progress on Desk Lamp! 🏅 | Tap to finish! | `obj_room_light` | MashaAllah! You learned Desk Lamp! 🌟⭐ |

#### Lesson: Can You Help Me, Please? 🤝 (`t3_l07_can_you_help_me`)
- **Unit**: `unit_t3_school` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child asks for help politely with full question structure.
- **Listening Target**: Child recognizes help requests.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Identify and select the Classroom Desk. 🌟 | Classroom Desk | `obj_school_desk` | A neat student desk ready for study! 🪑✨ |
| Step 2 | `dragAndDrop` | Arrange the Book with the Desk. ✨ | Move the Book | `obj_school_book` | A neat student desk ready for study! 🪑✨ |
| Step 3 | `speakToMakeSomethingHappen` | Clearly articulate: "can you help me please" 🎙️ | can you help me please | `can you help me please` | Wonderful! You said "can you help me please"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip needs a hand: "Ask your classmate politely for help!" Respond: "can you help me please" 💬 | Pip needs a hand: "Ask your classmate politely for help!" | `can you help me please` | Pip smiles: "can you help me please! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Well done! Confirm your progress on Classroom Desk! 🏅 | Tap to finish! | `obj_school_desk` | MashaAllah! You learned Classroom Desk! 🌟⭐ |

#### Lesson: Can I Have Some Water, Please? 💧 (`t3_l10_can_i_have_water_please`)
- **Unit**: `unit_t3_food` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child requests drinks politely in full complete sentence.
- **Listening Target**: Child understands dining offers.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Identify and select the Fresh Water. 🌟 | Fresh Water | `obj_food_water` | Refreshing clean water! Sit down to drink! 💧🥤 |
| Step 2 | `speakToMakeSomethingHappen` | Articulate clearly: "can i have some water please" 🎙️ | can i have some water please | `can i have some water please` | Pip says: "Thank you! JazakAllahu khayran!" 🦜❤️ |
| Step 3 | `feedCharacter` | Feed the Water to Pip! 🍎🦜 | can i have some water please | `obj_food_water` | Pip says: "Thank you! JazakAllahu khayran!" 🦜❤️ |
| Step 4 | `conversationRolePlay` | Pip serves dinner: "Would you like some refreshing water?" Respond: "yes please thank you" 💬 | Pip serves dinner: "Would you like some refreshing water?" | `yes please thank you` | Pip smiles: "yes please thank you! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Well done! Confirm your progress on Fresh Water! 🏅 | Tap to finish! | `obj_food_water` | MashaAllah! You learned Fresh Water! 🌟⭐ |

#### Lesson: Birds Can Fly High 🐦 (`t3_l14_the_bird_can_fly`)
- **Unit**: `unit_t3_animals` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child states abilities: "The bird can fly high in the sky."
- **Listening Target**: Child connects animal to its ability.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Identify and select the Bird. 🌟 | Bird | `obj_animal_bird` | Chirp chirp! Beautiful little bird! 🐦✨ |
| Step 2 | `dragAndDrop` | Arrange the Bird with the Clean Bowl. ✨ | Move the Bird | `obj_animal_bird` | Clean refreshing water for our animal friends! 🥣💧 |
| Step 3 | `speakToMakeSomethingHappen` | Clearly articulate: "the bird can fly high in the sky" 🎙️ | the bird can fly high in the sky | `the bird can fly high in the sky` | Wonderful! You said "the bird can fly high in the sky"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip points upward: "What can the bird do?" Respond: "the bird can fly" 💬 | Pip points upward: "What can the bird do?" | `the bird can fly` | Pip smiles: "the bird can fly! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Well done! Confirm your progress on Bird! 🏅 | Tap to finish! | `obj_animal_bird` | MashaAllah! You learned Bird! 🌟⭐ |

### Track Growing Communicators (Age 9–10) — Track 4 — Growing Communicators
- **Age Band Focus**: Move from beginner sentences into real conversation. Multi-turn dialogues, simple reasons, describing experiences, authentic non-toddler UI.

#### Lesson: My Passions and Aspirations 🌟 (`t4_l01_my_passions_and_goals`)
- **Unit**: `unit_t4_identity` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student delivers a multi-sentence self-introduction focusing on passions.
- **Listening Target**: Student identifies key speaker details.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Examine the scene and locate the Mirror. 🌟 | Mirror | `obj_avatar_mirror` | Look at you! You are wonderful! 🪞✨ |
| Step 2 | `dragAndDrop` | Position the Happy with the Mirror. ✨ | Move the Happy | `obj_happy_face` | Look at you! You are wonderful! 🪞✨ |
| Step 3 | `speakToMakeSomethingHappen` | Express this perspective: "i want to be an author because i love writing" 🎙️ | i want to be an author because i love writing | `i want to be an author because i love writing` | Wonderful! You said "i want to be an author because i love writing"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip asks: "What is your greatest passion and dream?" Propose: "i want to write books that inspire people" 💬 | Pip asks: "What is your greatest passion and dream?" | `i want to write books that inspire people` | Pip smiles: "i want to write books that inspire people! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Objective achieved! Complete module for Mirror! 🏆 | Tap to finish! | `obj_avatar_mirror` | MashaAllah! You learned Mirror! 🌟⭐ |

#### Lesson: My Favorite Subject Because... 🔬 (`t4_l04_favorite_subjects_with_reasons`)
- **Unit**: `unit_t4_school` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student shares favorite subjects with specific reasons.
- **Listening Target**: Student identifies words that explain reasons like because.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Examine the scene and locate the Microscope. 🌟 | Microscope | `obj_school_science_microscope` | Observe details carefully through the scientific lens! 🔬✨ |
| Step 2 | `dragAndDrop` | Position the Microscope with the Desk. ✨ | Move the Microscope | `obj_school_science_microscope` | A neat student desk ready for study! 🪑✨ |
| Step 3 | `speakToMakeSomethingHappen` | Express this perspective: "science is my favorite subject because we explore nature" 🎙️ | science is my favorite subject because we explore nature | `science is my favorite subject because we explore nature` | Wonderful! You said "science is my favorite subject because we explore nature"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Teacher asks: "Which school subject do you like best and why?" Propose: "science is my favorite subject because we explore nature" 💬 | Teacher asks: "Which school subject do you like best and why?" | `science is my favorite subject because we explore nature` | Pip smiles: "science is my favorite subject because we explore nature! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Objective achieved! Complete module for Microscope! 🏆 | Tap to finish! | `obj_school_science_microscope` | MashaAllah! You learned Microscope! 🌟⭐ |

#### Lesson: My Morning Schedule 🌅 (`t4_l07_my_morning_habits`)
- **Unit**: `unit_t4_routines` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student describes morning routine using "usually" and "always".
- **Listening Target**: Student sequences time milestones.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Examine the scene and locate the Toothbrush. 🌟 | Toothbrush | `obj_hygiene_brush` | Brush teeth morning and night! 🪥✨ |
| Step 2 | `dragAndDrop` | Position the Toothbrush with the Table. ✨ | Move the Toothbrush | `obj_hygiene_brush` | Clean study table! 🪵✨ |
| Step 3 | `speakToMakeSomethingHappen` | Express this perspective: "i usually wake up early and brush my teeth" 🎙️ | i usually wake up early and brush my teeth | `i usually wake up early and brush my teeth` | Wonderful! You said "i usually wake up early and brush my teeth"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip asks: "What is your morning routine before school starts?" Propose: "i usually wake up early and brush my teeth" 💬 | Pip asks: "What is your morning routine before school starts?" | `i usually wake up early and brush my teeth` | Pip smiles: "i usually wake up early and brush my teeth! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Objective achieved! Complete module for Toothbrush! 🏆 | Tap to finish! | `obj_hygiene_brush` | MashaAllah! You learned Toothbrush! 🌟⭐ |

#### Lesson: I Prefer Fresh Fruit Because... 🍎 (`t4_l10_preferring_fresh_fruit`)
- **Unit**: `unit_t4_food` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student expresses comparative preferences: "I prefer apples over candy because..."
- **Listening Target**: Student evaluates nutritional reasons.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Examine the scene and locate the Fresh Apple. 🌟 | Fresh Apple | `obj_food_apple` | Crisp red apple! Say Bismillah before eating! 🍎✨ |
| Step 2 | `speakToMakeSomethingHappen` | Express this perspective: "i prefer fresh apples because they are healthy" 🎙️ | i prefer fresh apples because they are healthy | `i prefer fresh apples because they are healthy` | Placed neatly on the clean dining plate! 🍽️✨ |
| Step 3 | `dragAndDrop` | Place the Apple by the Plate! ✨ | i prefer fresh apples because they are healthy | `obj_food_apple` | Placed neatly on the clean dining plate! 🍽️✨ |
| Step 4 | `conversationRolePlay` | Host asks: "Why do you prefer fresh fruit for a snack?" Propose: "i prefer fresh apples because they are healthy" 💬 | Host asks: "Why do you prefer fresh fruit for a snack?" | `i prefer fresh apples because they are healthy` | Pip smiles: "i prefer fresh apples because they are healthy! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Objective achieved! Complete module for Fresh Apple! 🏆 | Tap to finish! | `obj_food_apple` | MashaAllah! You learned Fresh Apple! 🌟⭐ |

#### Lesson: Sketching Outdoor Nature 🎨🌿 (`t4_l14_sketching_nature`)
- **Unit**: `unit_t4_hobbies` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student describes an artistic hobby and materials used.
- **Listening Target**: Student follows art instruction steps.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Examine the scene and locate the Purple Crayon. 🌟 | Purple Crayon | `obj_color_purple_crayon` | Purple crayon for colorful art! 🖍️🎨 |
| Step 2 | `dragAndDrop` | Position the Purple Crayon with the Blue Basket. ✨ | Move the Purple Crayon | `obj_color_purple_crayon` | Blue block in the blue basket! Super! 🧺🟦 |
| Step 3 | `speakToMakeSomethingHappen` | Express this perspective: "i enjoy sketching outdoor landscapes with colors" 🎙️ | i enjoy sketching outdoor landscapes with colors | `i enjoy sketching outdoor landscapes with colors` | Wonderful! You said "i enjoy sketching outdoor landscapes with colors"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Art teacher asks: "What artistic hobby inspires your creativity?" Propose: "i enjoy sketching outdoor landscapes with colors" 💬 | Art teacher asks: "What artistic hobby inspires your creativity?" | `i enjoy sketching outdoor landscapes with colors` | Pip smiles: "i enjoy sketching outdoor landscapes with colors! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Objective achieved! Complete module for Purple Crayon! 🏆 | Tap to finish! | `obj_color_purple_crayon` | MashaAllah! You learned Purple Crayon! 🌟⭐ |

### Track Confident Communicators (Age 11–12) — Track 5 — Confident Communicators
- **Age Band Focus**: Confident practical spoken English. Nuanced opinions, past/present/future usage in context, collaborative scenarios, problem solving.

#### Lesson: Defining Personal Principles 🧭 (`t5_l01_personal_philosophy`)
- **Unit**: `unit_t5_identity` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student explains personal core values with real-life examples.
- **Listening Target**: Student listens to and compares different viewpoints on character.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Analyze the setting and designate the Mirror. 🌟 | Mirror | `obj_avatar_mirror` | Look at you! You are wonderful! 🪞✨ |
| Step 2 | `dragAndDrop` | Align the Happy toward the Mirror. ✨ | Move the Happy | `obj_happy_face` | Look at you! You are wonderful! 🪞✨ |
| Step 3 | `speakToMakeSomethingHappen` | Articulate the core principle: "my guiding principle is to act with integrity in all situations" 🎙️ | my guiding principle is to act with integrity in all situations | `my guiding principle is to act with integrity in all situations` | Wonderful! You said "my guiding principle is to act with integrity in all situations"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip asks: "What core principle guides your daily decisions?" Discuss: "my guiding principle is to act with integrity in all situations" 💬 | Pip asks: "What core principle guides your daily decisions?" | `my guiding principle is to act with integrity in all situations` | Pip smiles: "my guiding principle is to act with integrity in all situations! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Mastery accomplished! Solidify insight on Mirror! 🎖️ | Tap to finish! | `obj_avatar_mirror` | MashaAllah! You learned Mirror! 🌟⭐ |

#### Lesson: Evaluating Scientific Data 🔬 (`t5_l04_evaluating_scientific_evidence`)
- **Unit**: `unit_t5_school` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student explains correlation vs causation in simple terms.
- **Listening Target**: Student follows technical data presentations.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Analyze the setting and designate the Microscope. 🌟 | Microscope | `obj_school_science_microscope` | Observe details carefully through the scientific lens! 🔬✨ |
| Step 2 | `dragAndDrop` | Align the Microscope toward the Desk. ✨ | Move the Microscope | `obj_school_science_microscope` | A neat student desk ready for study! 🪑✨ |
| Step 3 | `speakToMakeSomethingHappen` | Articulate the core principle: "correlation does not imply causation in scientific experiments" 🎙️ | correlation does not imply causation in scientific experiments | `correlation does not imply causation in scientific experiments` | Wonderful! You said "correlation does not imply causation in scientific experiments"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Teacher asks: "How do you evaluate scientific evidence objectively?" Discuss: "correlation does not imply causation in scientific experiments" 💬 | Teacher asks: "How do you evaluate scientific evidence objectively?" | `correlation does not imply causation in scientific experiments` | Pip smiles: "correlation does not imply causation in scientific experiments! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Mastery accomplished! Solidify insight on Microscope! 🎖️ | Tap to finish! | `obj_school_science_microscope` | MashaAllah! You learned Microscope! 🌟⭐ |

#### Lesson: Consultation Over Conflict 🤝 (`t5_l07_consultation_over_conflict`)
- **Unit**: `unit_t5_friendship` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student demonstrates how mutual Shura resolves deadlocks.
- **Listening Target**: Student detects conflict de-escalation strategies.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Analyze the setting and designate the Pip. 🌟 | Pip | `obj_pip_greeter` | Hello friend! Pip is so happy to see you! 🦜👋 |
| Step 2 | `dragAndDrop` | Align the Happy toward the Pip. ✨ | Move the Happy | `obj_happy_face` | Hello friend! Pip is so happy to see you! 🦜👋 |
| Step 3 | `speakToMakeSomethingHappen` | Articulate the core principle: "mutual consultation helps us reach the fairest decision" 🎙️ | mutual consultation helps us reach the fairest decision | `mutual consultation helps us reach the fairest decision` | Wonderful! You said "mutual consultation helps us reach the fairest decision"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip asks: "How does consultation resolve stubborn deadlocks?" Discuss: "mutual consultation helps us reach the fairest decision" 💬 | Pip asks: "How does consultation resolve stubborn deadlocks?" | `mutual consultation helps us reach the fairest decision` | Pip smiles: "mutual consultation helps us reach the fairest decision! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Mastery accomplished! Solidify insight on Pip! 🎖️ | Tap to finish! | `obj_pip_greeter` | MashaAllah! You learned Pip! 🌟⭐ |

#### Lesson: Artificial Intelligence & Ethics 🤖 (`t5_l10_ai_and_human_wisdom`)
- **Unit**: `unit_t5_technology` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student debates benefits and ethical risks of AI tools.
- **Listening Target**: Student evaluates arguments regarding digital ethics.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Analyze the setting and designate the Microscope. 🌟 | Microscope | `obj_school_science_microscope` | Observe details carefully through the scientific lens! 🔬✨ |
| Step 2 | `dragAndDrop` | Align the Microscope toward the Desk. ✨ | Move the Microscope | `obj_school_science_microscope` | A neat student desk ready for study! 🪑✨ |
| Step 3 | `speakToMakeSomethingHappen` | Articulate the core principle: "artificial intelligence is a powerful tool that requires moral oversight" 🎙️ | artificial intelligence is a powerful tool that requires moral oversight | `artificial intelligence is a powerful tool that requires moral oversight` | Wonderful! You said "artificial intelligence is a powerful tool that requires moral oversight"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Teacher asks: "What role should human ethics play in AI development?" Discuss: "artificial intelligence is a powerful tool that requires moral oversight" 💬 | Teacher asks: "What role should human ethics play in AI development?" | `artificial intelligence is a powerful tool that requires moral oversight` | Pip smiles: "artificial intelligence is a powerful tool that requires moral oversight! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Mastery accomplished! Solidify insight on Microscope! 🎖️ | Tap to finish! | `obj_school_science_microscope` | MashaAllah! You learned Microscope! 🌟⭐ |

#### Lesson: Why Drinking Water Matters 💧🧠 (`t5_l14_hydration_and_cognitive_power`)
- **Unit**: `unit_t5_health` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student explains with clear reasons: "Why is drinking water important? In my opinion..."
- **Listening Target**: Student understands health and hydration explanations.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Analyze the setting and designate the Fresh Water. 🌟 | Fresh Water | `obj_food_water` | Refreshing clean water! Sit down to drink! 💧🥤 |
| Step 2 | `speakToMakeSomethingHappen` | Articulate the principle: "why is drinking water important i think it gives health and focus" 🎙️ | why is drinking water important i think it gives health and focus | `why is drinking water important i think it gives health and focus` | Poured into the clean drinking cup! 🥛✨ |
| Step 3 | `scenePlacement` | Place the Water by the Cup! ✨ | why is drinking water important i think it gives health and focus | `obj_food_water` | Poured into the clean drinking cup! 🥛✨ |
| Step 4 | `conversationRolePlay` | Doctor asks: "Why is water intake linked to mental clarity?" Discuss: "our body is a trust from allah so we hydrate well" 💬 | Doctor asks: "Why is water intake linked to mental clarity?" | `our body is a trust from allah so we hydrate well` | Pip smiles: "our body is a trust from allah so we hydrate well! Excellent!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Mastery accomplished! Solidify insight on Fresh Water! 🎖️ | Tap to finish! | `obj_food_water` | MashaAllah! You learned Fresh Water! 🌟⭐ |

---

## Section 9: Special Cross-Age Progression Audit (5 Core Themes Across Ages 3, 5, 7, 9, 11)
Demonstrates the explicit developmental progression from concrete single-word imitation to complex discourse, reason, and social ethics across 5 recurring domains.

### Theme: 1. FOOD & DRINKS

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l13_sweet_red_apple` | Child says "Apple". | `speakToMakeSomethingHappen` | Apple! Can you say Apple? 🍎🎙️ | `apple` |
| Age 5 (Track 2) | `t2_l08_water_please` | Child says polite request: "Can I have water, please?" | `speakToMakeSomethingHappen` | Make a polite request: "Water, please!" 🎙️ | `water please` |
| Age 7 (Track 3) | `t3_l10_can_i_have_water_please` | Child requests drinks politely in full complete sentence. | `speakToMakeSomethingHappen` | Articulate clearly: "can i have some water please" 🎙️ | `can i have some water please` |
| Age 9 (Track 4) | `t4_l10_preferring_fresh_fruit` | Student expresses comparative preferences: "I prefer apples over candy because..." | `speakToMakeSomethingHappen` | Express this perspective: "i prefer fresh apples because they are healthy" 🎙️ | `i prefer fresh apples because they are healthy` |
| Age 11 (Track 5) | `t5_l14_hydration_and_cognitive_power` | Student explains with clear reasons: "Why is drinking water important? In my opinion..." | `speakToMakeSomethingHappen` | Articulate the principle: "why is drinking water important i think it gives health and focus" 🎙️ | `why is drinking water important i think it gives health and focus` |

### Theme: 2. MY HOME & LIVING SPACES

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l17_book_on_table` | Child echoes "Book". | `speakToMakeSomethingHappen` | Can you say "Book"? Good books help us learn! 📖🎙️ | `book` |
| Age 5 (Track 2) | `t2_l11_on_the_table` | Child says: "It is on the table." | `speakToMakeSomethingHappen` | Explain the position: "It is on the table!" 🎙️ | `it is on the table` |
| Age 7 (Track 3) | `t3_l04_there_is_a_lamp` | Child produces: "There is a lamp on the table." | `speakToMakeSomethingHappen` | Clearly articulate: "there is a lamp on the table" 🎙️ | `there is a lamp on the table` |
| Age 9 (Track 4) | `t4_l07_my_morning_habits` | Student describes morning routine using "usually" and "always". | `speakToMakeSomethingHappen` | Express this perspective: "i usually wake up early and brush my teeth" 🎙️ | `i usually wake up early and brush my teeth` |
| Age 11 (Track 5) | `t5_l16_sleep_and_memory_consolidation` | Student explains how adequate sleep enhances learning and mood. | `speakToMakeSomethingHappen` | Articulate the core principle: "adequate sleep consolidates memory and restores emotional resilience" 🎙️ | `adequate sleep consolidates memory and restores emotional resilience` |

### Theme: 3. ANIMALS & NATURE STEWARDSHIP

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l10_friendly_cat` | Child imitates "Meow". | `speakToMakeSomethingHappen` | Can you make the cat sound? Say "Meow"! 🐱🎙️ | `meow` |
| Age 5 (Track 2) | `t2_l14_the_big_dog` | Child says: "This is a big dog." | `speakToMakeSomethingHappen` | Describe the dog in a sentence: "This is a big dog." 🎙️ | `this is a big dog` |
| Age 7 (Track 3) | `t3_l16_caring_for_our_pets` | Child says: "We should give clean water and food to the cat." | `speakToMakeSomethingHappen` | Clearly articulate: "we should give clean water and food to the cat" 🎙️ | `we should give clean water and food to the cat` |
| Age 9 (Track 4) | `t4_l24_planting_trees_for_future` | Student describes planting procedures and ecological value. | `speakToMakeSomethingHappen` | Express this perspective: "planting trees provides cooling shade and clean air for all" 🎙️ | `planting trees provides cooling shade and clean air for all` |
| Age 11 (Track 5) | `t5_l21_preserving_biodiversity` | Student explains the balance of ecosystems (Mizan). | `speakToMakeSomethingHappen` | Articulate the core principle: "every living creature plays an essential role in nature balance" 🎙️ | `every living creature plays an essential role in nature balance` |

### Theme: 4. SCHOOL & LEARNING COMMUNITY

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l21_build_blocks` | Child says "Blocks". | `speakToMakeSomethingHappen` | Can you say "Blocks"? Tower of blocks! 🧱🎙️ | `blocks` |
| Age 5 (Track 2) | `t2_l16_this_is_my_pencil` | Child says: "This is my yellow pencil." | `speakToMakeSomethingHappen` | Say clearly: "This is my yellow pencil." 🎙️ | `this is my yellow pencil` |
| Age 7 (Track 3) | `t3_l06_i_need_my_bag` | Child expresses necessity: "I need my school bag for class." | `speakToMakeSomethingHappen` | Clearly articulate: "i need my school bag for class" 🎙️ | `i need my school bag for class` |
| Age 9 (Track 4) | `t4_l04_favorite_subjects_with_reasons` | Student shares favorite subjects with specific reasons. | `speakToMakeSomethingHappen` | Express this perspective: "science is my favorite subject because we explore nature" 🎙️ | `science is my favorite subject because we explore nature` |
| Age 11 (Track 5) | `t5_l04_evaluating_scientific_evidence` | Student explains correlation vs causation in simple terms. | `speakToMakeSomethingHappen` | Articulate the core principle: "correlation does not imply causation in scientific experiments" 🎙️ | `correlation does not imply causation in scientific experiments` |

### Theme: 5. FEELINGS & SOCIAL EMPATHY

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l02_happy_or_sad` | Child says "Happy" with a smile. | `speakToMakeSomethingHappen` | Can you say Happy with a big smile? 😊🎙️ | `happy` |
| Age 5 (Track 2) | `t2_l01_i_am_happy` | Child says: "I am happy today!" | `speakToMakeSomethingHappen` | Speak in a complete sentence: "I am happy today!" 🎙️ | `i am happy today` |
| Age 7 (Track 3) | `t3_l17_play_with_us` | Child invites a peer: "Would you like to play with us?" | `speakToMakeSomethingHappen` | Clearly articulate: "would you like to play with us" 🎙️ | `would you like to play with us` |
| Age 9 (Track 4) | `t4_l26_explaining_why_i_feel` | Student explains feelings and what caused them. | `speakToMakeSomethingHappen` | Express this perspective: "i felt excited because our team won the science fair" 🎙️ | `i felt excited because our team won the science fair` |
| Age 11 (Track 5) | `t5_l10_ai_and_human_wisdom` | Student debates benefits and ethical risks of AI tools. | `speakToMakeSomethingHappen` | Articulate the core principle: "artificial intelligence is a powerful tool that requires moral oversight" 🎙️ | `artificial intelligence is a powerful tool that requires moral oversight` |

