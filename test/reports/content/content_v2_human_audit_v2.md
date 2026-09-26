# CURRICULUM_CONTENT_V2 — HUMAN CONTENT AUDIT V2

> Comprehensive Quality Lock Audit verifying natural child language, sequence variation, age calibration, and Islamic governance across all 5 age groups.

## Executive Inventory Snapshot
- **Total Production Lessons**: 150
- **Total Interactive Interactions**: 933 (minimum threshold: >= 750)
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
| Step 1 | `listenAndTouch` | Pip is waving to you! Touch Pip! 👋🦜 | Touch Pip | `obj_pip_greeter` | Hello friend! Pip is so happy to see you! 🦜👋 |
| Step 2 | `dragAndDrop` | Bring Pip to the mirror to say hello! 🦜🪞 | Move Pip to the mirror | `obj_pip_greeter` | Pip sees his reflection! Hello Pip! 🪞✨ |
| Step 3 | `speakToMakeSomethingHappen` | Say "Hello" into your microphone, or tap Pip! 👋🎙️ | Say Hello | `hello` | Wonderful! You said "Hello"! 🌟🎉 |
| Step 4 | `conversationRolePlay` | Pip waves: "Hello friend!" Say: "Hello!" 💬 | Hello friend! | `hello` | Pip chirps happily: "Hello!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch the big bright smile to celebrate! 😄✨ | Touch the smile | `obj_avatar_smile` | MashaAllah! You learned Hello! 🌟⭐ |

#### Lesson: Touch Your Nose! 👃 (`t1_l04_touch_your_nose`)
- **Unit**: `unit_t1_body` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child echoes "Nose".
- **Listening Target**: Child touches nose in response to audio.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Where is the nose? Touch the nose! 👃✨ | Touch your nose | `obj_body_nose` | You found the nose! Great job! 👃⭐ |
| Step 2 | `dragAndDrop` | Bring clean hands gently to touch the nose! 👃🙌 | Touch nose with hands | `obj_body_nose` | Clean hands on the nose! Beep beep! 👃✨ |
| Step 3 | `speakToMakeSomethingHappen` | Say "Nose" out loud, or tap the nose! 👃🎙️ | Say Nose | `nose` | Terrific speaking! "Nose"! 👃🎉 |
| Step 4 | `conversationRolePlay` | Pip touches his beak: "Where is your nose?" Say: "Nose!" 💬 | Where is your nose? | `nose` | Pip smiles: "Yes, that is your nose!" 🦜👃 |
| Step 5 | `listenAndTouch` | Touch the smiling mouth right under the nose! 👄✨ | Touch the mouth | `obj_body_mouth` | MashaAllah! You know all about your nose! 🌟⭐ |

#### Lesson: Red Ball & Basket 🔴 (`t1_l07_red_apple_basket`)
- **Unit**: `unit_t1_colors` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child repeats "Red".
- **Listening Target**: Child selects and places red item.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Where is the bright red ball? Touch it! 🔴🍎 | Touch the red ball | `obj_color_red_ball` | Bright red! Like a sweet red apple! 🔴🍎 |
| Step 2 | `dragAndDrop` | Put the red ball inside the matching red basket! 🔴🧺 | Put the red ball in the red basket | `obj_color_red_ball` | Red ball in the red basket! Perfect match! 🧺🔴 |
| Step 3 | `speakToMakeSomethingHappen` | Can you say "Red"? Bright red! 🔴🎙️ | Say Red | `red` | Awesome speaking! "Red"! 🔴🎉 |
| Step 4 | `conversationRolePlay` | Pip asks: "What color is the red ball?" Say: "Red!" 💬 | What color is the red ball? | `red` | Pip chirps: "Yes! Red like a berry!" 🦜🔴 |
| Step 5 | `listenAndTouch` | Touch the red basket to celebrate color sorting! 🧺🌟 | Touch the red basket | `obj_color_red_basket` | MashaAllah! You know the color red! 🌟⭐ |

#### Lesson: Gentle Cat Purrs 🐱 (`t1_l10_friendly_cat`)
- **Unit**: `unit_t1_animals` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child imitates "Meow".
- **Listening Target**: Child recognizes cat and pets softly.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Listen to the gentle purr! Touch the soft cat! 🐱❤️ | Touch the cat | `obj_animal_cat` | Meow! The friendly cat purrs softly! 🐱❤️ |
| Step 2 | `dragAndDrop` | Bring the cat over to the fresh clean bowl! 🐱🥣 | Bring the cat to the bowl | `obj_animal_cat` | The cat laps clean fresh water! 🐱🥣 |
| Step 3 | `speakToMakeSomethingHappen` | Can you make the cat sound? Say "Meow"! 🐱🎙️ | Say Meow | `meow` | Meow! You sound just like a sweet cat! 🐱🎉 |
| Step 4 | `conversationRolePlay` | Pip pets the cat: "What does the cat say?" Say: "Meow!" 💬 | What does the cat say? | `meow` | Pip smiles: "Gentle words for gentle animals!" 🦜❤️ |
| Step 5 | `listenAndTouch` | Touch the clean water bowl to celebrate being kind! 🥣🌟 | Touch the bowl | `obj_animal_bowl` | MashaAllah! Kindness to all creatures! 🌟⭐ |

#### Lesson: Cool Water, Please 💧 (`t1_l14_cool_clean_water`)
- **Unit**: `unit_t1_food` | **Estimated Duration**: ~3 mins
- **Speaking Target**: Child says "Water".
- **Listening Target**: Child offers water cup to thirsty character.
- **Interaction Count**: 4 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Pure and refreshing! Touch the clean water! 💧🥤 | Touch the water | `obj_food_water` | Refreshing clean water! Sit down to drink! 💧🥤 |
| Step 2 | `dragAndDrop` | Pour the water into the clean drinking cup! 💧🥛 | Pour water into cup | `obj_food_water` | Poured into the clean drinking cup! 🥛💧 |
| Step 3 | `speakToMakeSomethingHappen` | Say "Water" clearly into the microphone! 💧🎙️ | Say Water | `water` | Splendid speaking! "Water"! 💧🎉 |
| Step 4 | `conversationRolePlay` | Pip holds a cup: "What should we drink?" Say: "Water!" 💬 | What should we drink? | `water` | Pip sips: "Water keeps us healthy and active!" 🦜💧 |

### Track Little Speakers (Age 5–6) — Track 2 — Little Speakers
- **Age Band Focus**: Vocabulary to phrases to first functional sentences. Minimal text, high visual support, polite functional expressions.

#### Lesson: I am Happy! 😊 (`t2_l01_i_am_happy`)
- **Unit**: `unit_t2_me` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "I am happy today!"
- **Listening Target**: Child identifies happy character.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Show your feelings! Touch the happy smiling face! 😊✨ | Touch happy | `obj_happy_face` | I am happy! Big smile! 😊✨ |
| Step 2 | `dragAndDrop` | Share your happiness! Bring the smile to Pip! 🦜😊 | Bring the smile to Pip | `obj_happy_face` | Pip loves your happy smile! 🦜❤️ |
| Step 3 | `speakToMakeSomethingHappen` | Speak in a complete sentence: "I am happy today!" 🎙️ | Say I am happy today | `i am happy today` | Wonderful! You expressed your feelings clearly! 😊🎉 |
| Step 4 | `conversationRolePlay` | Pip asks: "How are you feeling today?" Say: "I am happy today!" 💬 | How are you feeling today? | `i am happy today` | Pip smiles: "A positive attitude brings sunshine!" 🦜☀️ |
| Step 5 | `listenAndTouch` | Look at your joyful reflection in the mirror! 🪞✨ | Touch the mirror | `obj_avatar_mirror` | MashaAllah! Joyful and confident! 🌟⭐ |

#### Lesson: This Is My Mother 👩 (`t2_l04_this_is_my_mother`)
- **Unit**: `unit_t2_family` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "This is my mother."
- **Listening Target**: Child selects mother icon in family photo.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Touch the loving family portrait! 👩❤️ | Touch the family smile | `obj_avatar_smile` | Kindness and respect to mothers! 👩❤️ |
| Step 2 | `dragAndDrop` | Introduce mother warmly to Pip! 👩🦜 | Introduce mother to Pip | `obj_avatar_smile` | Pip bows with great respect! 🦜✨ |
| Step 3 | `listenAndTouch` | Pip is listening attentively! Touch Pip! 🦜 | Touch Pip | `obj_pip_greeter` | Pip is ready to hear your sentence! 🦜⭐ |
| Step 4 | `speakToMakeSomethingHappen` | Say with respect and kindness: "This is my mother." 🎙️ | Say This is my mother | `this is my mother` | Beautiful! "This is my mother!" 👩🎉 |
| Step 5 | `conversationRolePlay` | Pip asks: "Who takes care of you with love?" Say: "This is my mother." 💬 | Who takes care of you? | `this is my mother` | Pip honors: "Paradise lies under the feet of mothers!" 🦜💐 |
| Step 6 | `listenAndTouch` | Touch the smile to celebrate honoring parents! 🌟❤️ | Touch the smile | `obj_avatar_smile` | MashaAllah! Loving and dutiful child! 🌟⭐ |

#### Lesson: I Like Apples! 🍎 (`t2_l07_i_like_apples`)
- **Unit**: `unit_t2_food` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "I like red apples."
- **Listening Target**: Child identifies fruit preferences.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Crisp and juicy! Touch the red apple! 🍎✨ | Touch the apple | `obj_food_apple` | Crisp red apple! Say Bismillah before eating! 🍎✨ |
| Step 2 | `dragAndDrop` | Serve the apple on the clean dining table! 🍎🪵 | Place apple on table | `obj_food_apple` | Placed neatly on the clean dining table! 🪵🍎 |
| Step 3 | `listenAndTouch` | Touch the clean plate ready for food! 🍽️ | Touch the plate | `obj_food_plate` | Clean plates make meals pleasant! 🍽️✨ |
| Step 4 | `speakToMakeSomethingHappen` | Express your preference: "I like apples!" 🎙️🍎 | Say I like apples | `i like apples` | Great sentence! "I like apples!" 🍎🎉 |
| Step 5 | `conversationRolePlay` | Pip asks: "What fruit do you enjoy?" Say: "I like apples!" 💬 | What fruit do you enjoy? | `i like apples` | Pip nods: "Apples are delicious and nutritious!" 🦜🍎 |
| Step 6 | `listenAndTouch` | Touch the red apple once more! 🍎🌟 | Touch the apple | `obj_food_apple` | MashaAllah! Healthy food choices! 🌟⭐ |

#### Lesson: Where Is My Ball? ⚽🔍 (`t2_l10_where_is_my_ball`)
- **Unit**: `unit_t2_home` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child asks: "Where is the ball?"
- **Listening Target**: Child searches and points to ball in room.
- **Interaction Count**: 5 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look around the room! Touch the book! 📖✨ | Touch the book | `obj_room_book` | Found the book! Searching carefully! 📖✨ |
| Step 2 | `dragAndDrop` | Place the book on the study table! 📖🪵 | Put book on table | `obj_room_book` | Tidied up on the table! Neat room! 🪵📖 |
| Step 3 | `speakToMakeSomethingHappen` | Ask the question clearly: "Where is my book?" 🎙️🔍 | Say Where is my book | `where is my book` | Great question! "Where is my book?" 📖🎉 |
| Step 4 | `conversationRolePlay` | Pip points: "Where is your book?" Say: "On the table!" 💬 | Where is your book? | `on the table` | Pip nods: "Right there on the tidy table!" 🦜🪵 |
| Step 5 | `listenAndTouch` | Touch the desk chair where we read books! 🪑🌟 | Touch the chair | `obj_room_chair` | MashaAllah! Good observing skills! 🌟⭐ |

#### Lesson: The Big Friendly Dog 🐶 (`t2_l14_the_big_dog`)
- **Unit**: `unit_t2_animals` | **Estimated Duration**: ~5 mins
- **Speaking Target**: Child says: "This is a big dog."
- **Listening Target**: Child distinguishes big dog from small puppy.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look at the friendly pet! Touch the big dog! 🐶🐾 | Touch the big dog | `obj_animal_dog` | Woof woof! The loyal dog wags its tail! 🐶🐾 |
| Step 2 | `dragAndDrop` | Bring the playful dog to the clean water bowl! 🐶🥣 | Bring dog to bowl | `obj_animal_dog` | Happy dog drinking clean water! 🐶🥣 |
| Step 3 | `listenAndTouch` | Touch the singing bird perched above! 🐦 | Touch the bird | `obj_animal_bird` | Chirp chirp! Beautiful bird! 🐦✨ |
| Step 4 | `speakToMakeSomethingHappen` | Use an adjective: "The big dog!" 🎙️🐶 | Say The big dog | `the big dog` | Strong description! "The big dog!" 🐶🎉 |
| Step 5 | `conversationRolePlay` | Pip asks: "Which animal is guarding the farm?" Say: "The big dog!" 💬 | Which animal is guarding? | `the big dog` | Pip nods: "Loyal and watchful guardian!" 🦜🐶 |
| Step 6 | `listenAndTouch` | Touch the happy dog once more! 🐶🌟 | Touch the dog | `obj_animal_dog` | MashaAllah! Great descriptive speech! 🌟⭐ |

### Track Young Speakers (Age 7–8) — Track 3 — Young Speakers
- **Age Band Focus**: Build real beginner spoken English. Complete sentence patterns, wh-questions, functional polite language in school, home, and play.

#### Lesson: My Name and My Age 👦🎂 (`t3_l01_my_name_and_age`)
- **Unit**: `unit_t3_me_family` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child states name and age in full sentences.
- **Listening Target**: Child comprehends age questions.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look at the picture. What do you see? Touch the mirror! 🪞✨ | Touch the mirror | `obj_avatar_mirror` | Look at you! Ready for a new adventure! 🪞✨ |
| Step 2 | `dragAndDrop` | Bring Pip over to stand with you by the mirror! 🦜🪞 | Bring Pip to mirror | `obj_pip_greeter` | Pip says: "Pleased to meet you!" 🦜✨ |
| Step 3 | `listenAndTouch` | Show your friendly smile! Touch the smiling face! 😄 | Touch the smile | `obj_avatar_smile` | A warm and polite smile! 😄❤️ |
| Step 4 | `speakToMakeSomethingHappen` | Tell Pip your name and age: "My name is and I am seven years old." 🎙️ | Say your name and age | `my name is and i am seven years old` | Terrific! Clear and confident speaking! 🌟🎉 |
| Step 5 | `conversationRolePlay` | Pip greets you: "Tell me your name and age!" Answer clearly. 💬 | Tell me your name and your age! | `my name is and i am seven` | Pip bows politely: "Welcome to our learning world!" 🦜⭐ |
| Step 6 | `listenAndTouch` | Tap the mirror once more to confirm your progress! 🪞🌟 | Touch the mirror | `obj_avatar_mirror` | MashaAllah! Excellent first step! 🌟⭐ |

#### Lesson: There Is a Lamp 💡🪵 (`t3_l04_there_is_a_lamp`)
- **Unit**: `unit_t3_home` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child produces: "There is a lamp on the table."
- **Listening Target**: Child identifies singular items in rooms.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look around the study room. Can you find the lamp? Touch it! 💡✨ | Touch the lamp | `obj_room_light` | The desk lamp shines bright! 💡✨ |
| Step 2 | `scenePlacement` | Place the book on the table under the lamp! 📖🪵 | Place book under lamp | `obj_room_book` | Book arranged neatly under the study light! 🪵📖 |
| Step 3 | `listenAndTouch` | Touch the clean study table! 🪵 | Touch the table | `obj_room_table` | A tidy table helps you focus! 🪵✨ |
| Step 4 | `speakToMakeSomethingHappen` | Say with good grammar: "There is a lamp on the table." 🎙️💡 | Say There is a lamp | `there is a lamp on the table` | Excellent sentence structure! 💡🎉 |
| Step 5 | `conversationRolePlay` | Pip asks: "What is on the study desk?" Tell Pip! 💬 | What is on the desk? | `there is a lamp` | Pip nods: "A bright lamp for evening study!" 🦜💡 |
| Step 6 | `listenAndTouch` | Touch the chair to finish! 🪑🌟 | Touch the chair | `obj_room_chair` | MashaAllah! Great grammar practice! 🌟⭐ |

#### Lesson: Can You Help Me, Please? 🤝 (`t3_l07_can_you_help_me`)
- **Unit**: `unit_t3_school` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child asks for help politely with full question structure.
- **Listening Target**: Child recognizes help requests.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look at the classroom picture. Touch the desk! 🪑✨ | Touch the desk | `obj_school_desk` | Student desk ready for learning together! 🪑✨ |
| Step 2 | `dragAndDrop` | Share the lesson book by placing it on the desk! 📚🪑 | Put book on desk | `obj_school_book` | Shared on the desk! Great cooperation! 🪑📚 |
| Step 3 | `listenAndTouch` | Touch the writing pencil on the desk! ✏️ | Touch the pencil | `obj_school_pencil` | Pencil ready for neat writing! ✏️✨ |
| Step 4 | `speakToMakeSomethingHappen` | Practice polite asking: "Can you help me, please?" 🎙️🤝 | Say Can you help me please | `can you help me please` | Polite requests make friends! 🤝🎉 |
| Step 5 | `conversationRolePlay` | Pip asks: "How do you ask for assistance?" Say: "Can you help me, please?" 💬 | How do you ask? | `can you help me please` | Pip smiles: "I would be glad to help you!" 🦜🤝 |
| Step 6 | `listenAndTouch` | Touch the board to confirm your polite speaking! 📋🌟 | Touch the board | `obj_school_board` | MashaAllah! Polite and courteous! 🌟⭐ |

#### Lesson: Can I Have Some Water, Please? 💧 (`t3_l10_can_i_have_water_please`)
- **Unit**: `unit_t3_food` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child requests drinks politely in full complete sentence.
- **Listening Target**: Child understands dining offers.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Cool and refreshing! Touch the water pitcher! 💧🥤 | Touch the water | `obj_food_water` | Clear refreshing water! 💧✨ |
| Step 2 | `dragAndDrop` | Fill the clean drinking cup with fresh water! 💧🥛 | Pour water into cup | `obj_food_water` | Poured neatly into the cup! 🥛💧 |
| Step 3 | `listenAndTouch` | Pip is sitting at the dining table! Touch Pip! 🦜 | Touch Pip | `obj_dining_pip` | Pip is ready for dinner! 🦜✨ |
| Step 4 | `speakToMakeSomethingHappen` | Ask at the table: "Can I have some water, please?" 🎙️💧 | Say Can I have some water please | `can i have some water please` | Polite table manners! "Can I have some water, please?" 💧🎉 |
| Step 5 | `conversationRolePlay` | Pip serves dinner: "Would you like some refreshing water?" Answer politely! 💬 | Answer Pip | `yes please thank you` | Pip pours: "Bismillah! Drink with your right hand!" 🦜🥛 |
| Step 6 | `listenAndTouch` | Touch the dining table to finish this mealtime lesson! 🪵🌟 | Touch the table | `obj_dining_table` | MashaAllah! Good table etiquette! 🌟⭐ |

#### Lesson: Birds Can Fly High 🐦 (`t3_l14_the_bird_can_fly`)
- **Unit**: `unit_t3_animals` | **Estimated Duration**: ~6 mins
- **Speaking Target**: Child states abilities: "The bird can fly high in the sky."
- **Listening Target**: Child connects animal to its ability.
- **Interaction Count**: 6 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look up near the trees! Touch the little bird! 🐦✨ | Touch the bird | `obj_animal_bird` | Chirp chirp! Beautiful feathers! 🐦✨ |
| Step 2 | `listenAndTouch` | Look down on the grass! Touch the gentle cat! 🐱 | Touch the cat | `obj_animal_cat` | Meow! The cat watches the birds safely! 🐱🌾 |
| Step 3 | `listenAndTouch` | Look at the friendly horse in the field! Touch the horse! 🐴 | Touch the horse | `obj_animal_horse` | Neigh! A strong and swift horse! 🐴✨ |
| Step 4 | `speakToMakeSomethingHappen` | Say what the bird can do: "The bird can fly high in the sky." 🎙️🐦 | Say The bird can fly | `the bird can fly high in the sky` | Great sentence! "The bird can fly high!" 🐦🎉 |
| Step 5 | `conversationRolePlay` | Pip points upward: "What can the bird do?" Tell Pip! 💬 | What can the bird do? | `the bird can fly` | Pip flaps wings: "Birds can fly high in the sky!" 🦜☁️ |
| Step 6 | `listenAndTouch` | Touch the water bowl for the animals! 🥣🌟 | Touch the bowl | `obj_animal_bowl` | MashaAllah! Great job learning about animals! 🌟⭐ |

### Track Growing Communicators (Age 9–10) — Track 4 — Growing Communicators
- **Age Band Focus**: Move from beginner sentences into real conversation. Multi-turn dialogues, simple reasons, describing experiences, authentic non-toddler UI.

#### Lesson: My Passions and Aspirations 🌟 (`t4_l01_my_passions_and_goals`)
- **Unit**: `unit_t4_identity` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student delivers a multi-sentence self-introduction focusing on passions.
- **Listening Target**: Student identifies key speaker details.
- **Interaction Count**: 7 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look in the mirror and think about what you love doing! Touch the mirror! 🪞✨ | Touch the mirror | `obj_avatar_mirror` | Every person has special talents and interests! 🪞✨ |
| Step 2 | `dragAndDrop` | Bring your happy face to the mirror! Sharing happiness is wonderful! 😊🪞 | Bring happy face to mirror | `obj_happy_face` | A bright smile for your future goals! 😊✨ |
| Step 3 | `listenAndTouch` | Touch Pip! Pip wants to hear all about your dreams! 🦜 | Touch Pip | `obj_pip_greeter` | Pip says: "Tell me what you love to learn!" 🦜✨ |
| Step 4 | `speakToMakeSomethingHappen` | Say your goal clearly: "I want to be an author because I love writing." 🎙️📖 | Say I want to be an author | `i want to be an author because i love writing` | Wonderful goal! "I love writing!" 📖🎉 |
| Step 5 | `conversationRolePlay` | Pip asks: "What is your dream goal?" Tell Pip your goal with a reason! 💬 | What is your goal? | `i want to write books` | Pip cheers: "That sounds inspiring! Keep reading and writing!" 🦜⭐ |
| Step 6 | `listenAndTouch` | Touch your smile! Believing in yourself is the first step! 😄 | Touch the smile | `obj_avatar_smile` | Confidence and hard work make dreams come true! 😄❤️ |
| Step 7 | `listenAndTouch` | Touch the mirror to seal your goals! 🪞🏆 | Touch the mirror | `obj_avatar_mirror` | MashaAllah! Ready to pursue your goals! 🌟🏆🎉 |

#### Lesson: My Favorite Subject Because... 🔬 (`t4_l04_favorite_subjects_with_reasons`)
- **Unit**: `unit_t4_school` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student shares favorite subjects with specific reasons.
- **Listening Target**: Student identifies words that explain reasons like because.
- **Interaction Count**: 7 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look at the science desk! Touch the microscope! 🔬✨ | Touch the microscope | `obj_school_science_microscope` | Science lets us discover how things work! 🔬✨ |
| Step 2 | `scenePlacement` | Set the microscope securely on your study desk! 🔬🪵 | Place microscope on desk | `obj_school_science_microscope` | Ready for careful scientific observation! 🪵🔬 |
| Step 3 | `listenAndTouch` | Touch the textbook! Every subject gives us knowledge! 📚 | Touch the book | `obj_school_book` | Reading opens doors to understanding! 📚✨ |
| Step 4 | `listenAndTouch` | Touch the whiteboard! Teachers write exciting ideas here! 📋 | Touch the board | `obj_school_board` | Equations, diagrams, and discoveries! 📋💡 |
| Step 5 | `speakToMakeSomethingHappen` | Give your reason: "Science is my favorite subject because we explore nature." 🎙️🌿 | Say Science is my favorite subject | `science is my favorite subject because we explore nature` | Great reasoning! "Because we explore nature!" 🌿🎉 |
| Step 6 | `conversationRolePlay` | Pip asks: "Which subject do you enjoy most and why?" Tell Pip! 💬 | Which subject do you enjoy? | `science because we explore nature` | Pip agrees: "Exploring nature shows the beauty of creation!" 🦜🔬 |
| Step 7 | `listenAndTouch` | Touch the desk to finish your reflection! 🪵🌟 | Touch the desk | `obj_school_desk` | MashaAllah! Clear reasons and great speaking! 🌟⭐ |

#### Lesson: My Morning Schedule 🌅 (`t4_l07_my_morning_habits`)
- **Unit**: `unit_t4_routines` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student describes morning routine using "usually" and "always".
- **Listening Target**: Student sequences time milestones.
- **Interaction Count**: 7 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Start the day early! Touch the morning clock! ⏰🌅 | Touch the clock | `obj_room_clock` | Waking up early gives your day barakah! ⏰🌅 |
| Step 2 | `dragAndDrop` | Set your morning study book neatly on the table! 📖🪵 | Put book on table | `obj_room_book` | Morning study materials organized! 🪵📖 |
| Step 3 | `listenAndTouch` | Make your bed neatly right after waking up! Touch the bed! 🛏️✨ | Touch the bed | `obj_room_bed` | Tidy bed and a fresh start to the day! 🛏️✨ |
| Step 4 | `listenAndTouch` | Touch the soap! Wash your face and hands with fresh water! 🧼💧 | Touch the soap | `obj_hygiene_soap` | Clean face and energetic start! 🧼✨ |
| Step 5 | `speakToMakeSomethingHappen` | Explain your schedule: "I usually wake up early, pray, and review my morning lessons." 🎙️🌅 | Say I usually wake up early | `i usually wake up early pray and review my morning lessons` | Excellent morning discipline! 🌅🎉 |
| Step 6 | `conversationRolePlay` | Pip asks about your routine: "What do you do first each morning?" 💬 | What do you do first? | `wake up early and pray` | Pip chirps: "A productive morning routine sets you up for success!" 🦜🌅 |
| Step 7 | `listenAndTouch` | Touch the room door! Ready to greet the day! 🚪🌟 | Touch the door | `obj_room_door` | MashaAllah! Productive morning routine mastered! 🌟⭐ |

#### Lesson: I Prefer Fresh Fruit Because... 🍎 (`t4_l10_preferring_fresh_fruit`)
- **Unit**: `unit_t4_food` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student expresses comparative preferences: "I prefer apples over candy because..."
- **Listening Target**: Student evaluates nutritional reasons.
- **Interaction Count**: 7 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Fresh fruit provides natural vitamins and energy! Touch the crisp apple! 🍎✨ | Touch the apple | `obj_food_apple` | Crisp and vitamin-rich red apple! 🍎✨ |
| Step 2 | `dragAndDrop` | Place the fresh apple slices neatly on the plate! 🍎🍽️ | Place apple on plate | `obj_food_apple` | Apples served cleanly and beautifully! 🍽️🍎 |
| Step 3 | `listenAndTouch` | Touch the ripe banana! Natural sweetness that fuels our thinking! 🍌 | Touch the banana | `obj_food_banana` | Rich in potassium and long-lasting energy! 🍌💪 |
| Step 4 | `listenAndTouch` | Touch the nutritious dates! A wholesome sunnah snack full of fiber! 🌴 | Touch the dates | `obj_food_dates` | Dates nourish both body and spirit! 🌴✨ |
| Step 5 | `speakToMakeSomethingHappen` | Express your preference: "I prefer fresh fruit over candy because fruit gives lasting energy." 🎙️🍎 | Say I prefer fresh fruit | `i prefer fresh fruit over candy because fruit gives lasting energy` | Wise nutritional discernment! 🍎🎉 |
| Step 6 | `conversationRolePlay` | Pip asks: "Why do you choose fresh fruit?" Explain clearly! 💬 | Why do you choose fruit? | `it gives lasting energy` | Pip agrees: "Wholesome food keeps our minds and bodies strong!" 🦜🍎 |
| Step 7 | `listenAndTouch` | Touch the clean water! Fresh fruit and pure water are the best combo! 💧🌟 | Touch the water | `obj_food_water` | MashaAllah! Wholesome nutrition choices! 🌟⭐ |

#### Lesson: Sketching Outdoor Nature 🎨🌿 (`t4_l14_sketching_nature`)
- **Unit**: `unit_t4_hobbies` | **Estimated Duration**: ~8 mins
- **Speaking Target**: Student describes an artistic hobby and materials used.
- **Listening Target**: Student follows art instruction steps.
- **Interaction Count**: 7 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look at the colors of trees and grass! Touch the green leaf! 🍃✨ | Touch the green leaf | `obj_color_green_leaf` | Green brings the landscape to life! 🍃✨ |
| Step 2 | `dragAndDrop` | Place the green leaf into the nature art basket! 🍃🧺 | Put leaf into basket | `obj_color_green_leaf` | Nature colors collected in the basket! 🧺🍃 |
| Step 3 | `listenAndTouch` | Add sky blue! Touch the blue block! 🟦 | Touch the blue block | `obj_color_blue_block` | Clear blue skies above green hills! 🟦☁️ |
| Step 4 | `listenAndTouch` | Paint delicate wildflowers! Touch the orange flower! 🌸 | Touch the flower | `obj_color_orange_flower` | Bright flowers in the green grass! 🌸🌿 |
| Step 5 | `speakToMakeSomethingHappen` | Describe your art: "I am sketching green trees and colorful wildflowers." 🎙️🎨 | Say I am sketching green trees | `i am sketching green trees and colorful wildflowers` | Vivid and expressive! "Green trees and colorful flowers!" 🎨🎉 |
| Step 6 | `conversationRolePlay` | Pip admires your artwork: "What is your sketch about?" Tell Pip! 💬 | What is your sketch about? | `green trees and flowers` | Pip marvels: "SubhanAllah, the colors of nature are so vibrant!" 🦜🎨 |
| Step 7 | `listenAndTouch` | Touch the purple crayon to sign your artwork! 🖍️🏆 | Touch purple crayon | `obj_color_purple_crayon` | MashaAllah! A budding artist! 🌟⭐ |

### Track Confident Communicators (Age 11–12) — Track 5 — Confident Communicators
- **Age Band Focus**: Confident practical spoken English. Nuanced opinions, past/present/future usage in context, collaborative scenarios, problem solving.

#### Lesson: Defining Personal Principles 🧭 (`t5_l01_personal_philosophy`)
- **Unit**: `unit_t5_identity` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student explains personal core values with real-life examples.
- **Listening Target**: Student listens to and compares different viewpoints on character.
- **Interaction Count**: 7 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look in the mirror and think about what kind of person you want to become! Touch the mirror! 🪞✨ | Touch the mirror | `obj_avatar_mirror` | Character is what you do when nobody is watching! 🪞✨ |
| Step 2 | `dragAndDrop` | Bring your positive outlook to the mirror! A good heart shows in your deeds! 😊🪞 | Bring happy face to mirror | `obj_happy_face` | Optimism and sincere intent! 😊✨ |
| Step 3 | `listenAndTouch` | Touch Pip! Pip is ready for thoughtful discussions! 🦜 | Touch Pip | `obj_pip_greeter` | Pip says: "Let us talk about what matters most in life!" 🦜✨ |
| Step 4 | `listenAndTouch` | Touch the genuine smile! Kind manners soften hearts! 😄 | Touch the smile | `obj_avatar_smile` | True strength is in gentle character! 😄❤️ |
| Step 5 | `speakToMakeSomethingHappen` | State your guiding value: "I want to always be honest and treat others with respect." 🎙️🌟 | Say I want to always be honest | `i want to always be honest and treat others with respect` | Noble guiding value! "Always honest and respectful!" 🌟🎉 |
| Step 6 | `conversationRolePlay` | Pip asks: "What principle helps you make good choices every day?" Share your thought! 💬 | Share your principle | `honesty and treating others with respect` | Pip smiles: "Living by good values makes you a true leader!" 🦜⭐ |
| Step 7 | `listenAndTouch` | Touch the mirror to seal your commitment! 🪞🏆 | Touch the mirror | `obj_avatar_mirror` | MashaAllah! Ready for meaningful growth! 🌟🏆🎉 |

#### Lesson: Evaluating Scientific Data 🔬 (`t5_l04_evaluating_scientific_evidence`)
- **Unit**: `unit_t5_school` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student explains correlation vs causation in simple terms.
- **Listening Target**: Student follows technical data presentations.
- **Interaction Count**: 7 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Look closely at scientific experiments! Touch the microscope! 🔬✨ | Touch the microscope | `obj_school_science_microscope` | Good scientists test their ideas with careful evidence! 🔬✨ |
| Step 2 | `scenePlacement` | Place the microscope on the lab desk for testing! 🔬🪵 | Place microscope on desk | `obj_school_science_microscope` | Ready to test hypotheses carefully! 🪵🔬 |
| Step 3 | `listenAndTouch` | Check the lab results in the science manual! Touch the book! 📖 | Touch the book | `obj_school_book` | Recording data accurately prevents mistakes! 📖🔍 |
| Step 4 | `listenAndTouch` | Touch the pencil to write down your observations! ✏️ | Touch the pencil | `obj_school_pencil` | Observations recorded clearly! ✏️📋 |
| Step 5 | `speakToMakeSomethingHappen` | State the scientific rule: "Just because two things happen together does not mean one caused the other." 🎙️🔍 | Say Just because two things happen together | `just because two things happen together does not mean one caused the other` | Clear, mature scientific thinking! 🔍🎉 |
| Step 6 | `conversationRolePlay` | Teacher asks: "Why should we be careful before drawing conclusions in experiments?" Answer! 💬 | Why be careful with conclusions? | `we must check the evidence carefully` | Teacher nods: "Excellent critical thinking! Evidence comes first!" 👏🔬 |
| Step 7 | `listenAndTouch` | Touch the board! 📋🌟 | Touch the board | `obj_school_board` | MashaAllah! Sharp scientific mind! 🌟⭐ |

#### Lesson: Consultation Over Conflict 🤝 (`t5_l07_consultation_over_conflict`)
- **Unit**: `unit_t5_friendship` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student demonstrates how mutual Shura resolves deadlocks.
- **Listening Target**: Student detects conflict de-escalation strategies.
- **Interaction Count**: 7 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Talking things through solves disagreements! Touch Pip! 🦜✨ | Touch Pip | `obj_pip_greeter` | Consultation brings good ideas from everyone! 🦜✨ |
| Step 2 | `dragAndDrop` | Bring the happy face to Pip to show that discussion brings peace! 😊🦜 | Bring happy face to Pip | `obj_happy_face` | Listening to different opinions creates harmony! 🦜😊 |
| Step 3 | `listenAndTouch` | Touch the mirror to reflect on listening without interrupting! 🪞 | Touch the mirror | `obj_avatar_mirror` | A patient listener understands other perspectives! 🪞👂 |
| Step 4 | `listenAndTouch` | Touch the friendly smile! Cooperation is better than arguing! 😄 | Touch the smile | `obj_avatar_smile` | Working together finds the fairest answer! 😄🤝 |
| Step 5 | `speakToMakeSomethingHappen` | State your approach: "When we disagree, we should sit down and talk things through calmly." 🎙️🕊️ | Say When we disagree we talk calmly | `when we disagree we should sit down and talk things through calmly` | Mature resolution! "Talk things through calmly!" 🕊️🎉 |
| Step 6 | `conversationRolePlay` | Pip asks: "How can our team decide when two friends want different things?" 💬 | How should the team decide? | `we should vote and listen to each other` | Pip agrees: "Mutual consultation leads to the best outcome!" 🦜👏 |
| Step 7 | `listenAndTouch` | Touch Pip! 🦜🌟 | Touch Pip | `obj_pip_greeter` | MashaAllah! Natural peacemaker! 🌟⭐ |

#### Lesson: Artificial Intelligence & Ethics 🤖 (`t5_l10_ai_and_human_wisdom`)
- **Unit**: `unit_t5_technology` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student debates benefits and ethical risks of AI tools.
- **Listening Target**: Student evaluates arguments regarding digital ethics.
- **Interaction Count**: 7 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Computers and AI are powerful tools! Touch the science microscope! 🔬✨ | Touch the microscope | `obj_school_science_microscope` | Technology should always serve people and protect human dignity! 🔬✨ |
| Step 2 | `scenePlacement` | Set up the technology tools on your desk! 🔬🪵 | Place tool on desk | `obj_school_science_microscope` | Tools arranged ready for thoughtful use! 🪵🔬 |
| Step 3 | `listenAndTouch` | Look at the guidelines on the board! Touch the board! 📋 | Touch the board | `obj_school_board` | Rules for using computers safely and fairly! 📋💡 |
| Step 4 | `listenAndTouch` | Touch the book of human values! 📖 | Touch the book | `obj_school_book` | Human empathy and kindness are things no machine can replace! 📖❤️ |
| Step 5 | `speakToMakeSomethingHappen` | State your view in clear English: "Technology is powerful, so we must make sure people use it fairly and safely." 🎙️🤖 | Say Technology is powerful so we must use it fairly | `technology is powerful so we must make sure people use it fairly and safely` | Clear, mature English! "Fairly and safely!" 🤖🎉 |
| Step 6 | `conversationRolePlay` | Teacher asks: "How should young people use smart technology and AI?" Answer! 💬 | How should we use AI? | `we should use it to learn and help others` | Teacher smiles: "Smart technology guided by good hearts!" 👏💡 |
| Step 7 | `listenAndTouch` | Touch the board! 📋🌟 | Touch the board | `obj_school_board` | MashaAllah! Thoughtful digital citizen! 🌟⭐ |

#### Lesson: Why Drinking Water Matters 💧🧠 (`t5_l14_hydration_and_cognitive_power`)
- **Unit**: `unit_t5_health` | **Estimated Duration**: ~10 mins
- **Speaking Target**: Student explains with clear reasons: "Why is drinking water important? In my opinion..."
- **Listening Target**: Student understands health and hydration explanations.
- **Interaction Count**: 7 steps

| Step | Mechanic | Child-Facing Instruction | Audio Cue | Target / Speak Trigger | Success Reaction |
|---|---|---|---|---|---|
| Step 1 | `listenAndTouch` | Water keeps your brain sharp! Touch the fresh water! 💧✨ | Touch the water | `obj_food_water` | Drinking plenty of water boosts memory and focus! 💧✨ |
| Step 2 | `dragAndDrop` | Fill your cup with fresh water! 💧🥤 | Pour water in cup | `obj_food_water` | Clean water ready to drink! 🥤💧 |
| Step 3 | `listenAndTouch` | Fresh fruits also provide hydration! Touch the apple! 🍎 | Touch the apple | `obj_food_apple` | Juicy fruits help hydrate the body! 🍎💦 |
| Step 4 | `listenAndTouch` | Touch the sweet dates! Pairing water with dates gives natural energy! 🌴 | Touch the dates | `obj_food_dates` | A blessed, refreshing combination! 🌴💧 |
| Step 5 | `speakToMakeSomethingHappen` | Explain the benefit of water: "Drinking water helps our brain stay focused and keeps our body healthy." 🎙️💧 | Say Drinking water helps our brain stay focused | `drinking water helps our brain stay focused and keeps our body healthy` | Clear health knowledge! "Brain stays focused!" 💧🎉 |
| Step 6 | `conversationRolePlay` | A classmate feels tired while studying. What helpful tip do you give? 💬 | Suggest drinking water | `drink a glass of water and take a rest` | Classmate drinks water: "That feels so refreshing, thank you!" 🥤😊 |
| Step 7 | `listenAndTouch` | Touch the fresh water! 💧🌟 | Touch the water | `obj_food_water` | MashaAllah! Health champion! 🌟⭐ |

---

## Section 9: Special Cross-Age Progression Audit (5 Core Themes Across Ages 3, 5, 7, 9, 11)
Demonstrates the explicit developmental progression from concrete single-word imitation to complex discourse, reason, and social ethics across 5 recurring domains.

### Theme: 1. FOOD & DRINKS

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l13_sweet_red_apple` | Child says "Apple". | `speakToMakeSomethingHappen` | Can you say "Apple"? Yummy fruit! 🍎🎙️ | `apple` |
| Age 5 (Track 2) | `t2_l08_water_please` | Child says polite request: "Can I have water, please?" | `speakToMakeSomethingHappen` | Ask politely with good manners: "Water, please!" 🎙️💧 | `water please` |
| Age 7 (Track 3) | `t3_l10_can_i_have_water_please` | Child requests drinks politely in full complete sentence. | `speakToMakeSomethingHappen` | Ask at the table: "Can I have some water, please?" 🎙️💧 | `can i have some water please` |
| Age 9 (Track 4) | `t4_l10_preferring_fresh_fruit` | Student expresses comparative preferences: "I prefer apples over candy because..." | `speakToMakeSomethingHappen` | Express your preference: "I prefer fresh fruit over candy because fruit gives lasting energy." 🎙️🍎 | `i prefer fresh fruit over candy because fruit gives lasting energy` |
| Age 11 (Track 5) | `t5_l14_hydration_and_cognitive_power` | Student explains with clear reasons: "Why is drinking water important? In my opinion..." | `speakToMakeSomethingHappen` | Explain the benefit of water: "Drinking water helps our brain stay focused and keeps our body healthy." 🎙️💧 | `drinking water helps our brain stay focused and keeps our body healthy` |

### Theme: 2. MY HOME & LIVING SPACES

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l17_book_on_table` | Child echoes "Book". | `speakToMakeSomethingHappen` | Say "Book" to open up a new adventure! 📖🎙️ | `book` |
| Age 5 (Track 2) | `t2_l11_on_the_table` | Child says: "It is on the table." | `speakToMakeSomethingHappen` | Use the spatial preposition: "On the table!" 🎙️🪵 | `on the table` |
| Age 7 (Track 3) | `t3_l04_there_is_a_lamp` | Child produces: "There is a lamp on the table." | `speakToMakeSomethingHappen` | Say with good grammar: "There is a lamp on the table." 🎙️💡 | `there is a lamp on the table` |
| Age 9 (Track 4) | `t4_l07_my_morning_habits` | Student describes morning routine using "usually" and "always". | `speakToMakeSomethingHappen` | Explain your schedule: "I usually wake up early, pray, and review my morning lessons." 🎙️🌅 | `i usually wake up early pray and review my morning lessons` |
| Age 11 (Track 5) | `t5_l16_sleep_and_memory_consolidation` | Student explains how adequate sleep enhances learning and mood. | `speakToMakeSomethingHappen` | State why sleep matters: "Getting enough sleep helps our brain remember things and keeps us feeling happy and energetic." 🎙️😴 | `getting enough sleep helps our brain remember things and keeps us feeling happy and energetic` |

### Theme: 3. ANIMALS & NATURE STEWARDSHIP

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l10_friendly_cat` | Child imitates "Meow". | `speakToMakeSomethingHappen` | Can you make the cat sound? Say "Meow"! 🐱🎙️ | `meow` |
| Age 5 (Track 2) | `t2_l14_the_big_dog` | Child says: "This is a big dog." | `speakToMakeSomethingHappen` | Use an adjective: "The big dog!" 🎙️🐶 | `the big dog` |
| Age 7 (Track 3) | `t3_l16_caring_for_our_pets` | Child says: "We should give clean water and food to the cat." | `speakToMakeSomethingHappen` | Say how we care for pets: "We should give clean water and food to the cat." 🎙️🐱 | `we should give clean water and food to the cat` |
| Age 9 (Track 4) | `t4_l24_planting_trees_for_future` | Student describes planting procedures and ecological value. | `speakToMakeSomethingHappen` | Recite the prophetic tradition: "If you plant a tree, you earn reward whenever anyone enjoys its shade." 🎙️🌳 | `if you plant a tree you earn reward whenever anyone enjoys its shade` |
| Age 11 (Track 5) | `t5_l21_preserving_biodiversity` | Student explains the balance of ecosystems (Mizan). | `speakToMakeSomethingHappen` | Express the balance: "Every living creature plays an important role in nature." 🎙️🌍 | `every living creature plays an important role in nature` |

### Theme: 4. SCHOOL & LEARNING COMMUNITY

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l21_build_blocks` | Child says "Blocks". | `speakToMakeSomethingHappen` | Say "Blocks" out loud to build tall towers! 🧱🎙️ | `blocks` |
| Age 5 (Track 2) | `t2_l16_this_is_my_pencil` | Child says: "This is my yellow pencil." | `speakToMakeSomethingHappen` | Introduce your learning tool: "This is my pencil!" 🎙️✏️ | `this is my pencil` |
| Age 7 (Track 3) | `t3_l06_i_need_my_bag` | Child expresses necessity: "I need my school bag for class." | `speakToMakeSomethingHappen` | Say clearly: "I need my school bag for class." 🎙️🎒 | `i need my school bag for class` |
| Age 9 (Track 4) | `t4_l04_favorite_subjects_with_reasons` | Student shares favorite subjects with specific reasons. | `speakToMakeSomethingHappen` | Give your reason: "Science is my favorite subject because we explore nature." 🎙️🌿 | `science is my favorite subject because we explore nature` |
| Age 11 (Track 5) | `t5_l04_evaluating_scientific_evidence` | Student explains correlation vs causation in simple terms. | `speakToMakeSomethingHappen` | State the scientific rule: "Just because two things happen together does not mean one caused the other." 🎙️🔍 | `just because two things happen together does not mean one caused the other` |

### Theme: 5. FEELINGS & SOCIAL EMPATHY

| Age Group | Lesson ID | Key Speaking Outcome | Core Mechanic | Child-Facing Prompt Sample | Target Utterance / Trigger |
|---|---|---|---|---|---|
| Age 3 (Track 1) | `t1_l02_happy_or_sad` | Child says "Happy" with a smile. | `speakToMakeSomethingHappen` | Can you say "Happy" with a big smile? 😊🎙️ | `happy` |
| Age 5 (Track 2) | `t2_l01_i_am_happy` | Child says: "I am happy today!" | `speakToMakeSomethingHappen` | Speak in a complete sentence: "I am happy today!" 🎙️ | `i am happy today` |
| Age 7 (Track 3) | `t3_l17_play_with_us` | Child invites a peer: "Would you like to play with us?" | `speakToMakeSomethingHappen` | Invite someone to join: "Would you like to play with us?" 🎙️🤝 | `would you like to play with us` |
| Age 9 (Track 4) | `t4_l26_explaining_why_i_feel` | Student explains feelings and what caused them. | `speakToMakeSomethingHappen` | Express your feelings with reasons: "I feel upset because we cancelled our trip, but I know we can go another day." 🎙️💬 | `i feel upset because we cancelled our trip but i know we can go another day` |
| Age 11 (Track 5) | `t5_l10_ai_and_human_wisdom` | Student debates benefits and ethical risks of AI tools. | `speakToMakeSomethingHappen` | State your view in clear English: "Technology is powerful, so we must make sure people use it fairly and safely." 🎙️🤖 | `technology is powerful so we must make sure people use it fairly and safely` |

