# Phase 16.8 Live Session Audit: Production Age-Adaptive Learning Sessions

**Date:** 2026-09-13  
**Status:** Verified via Live Production Session Composer Output & Semantic Integrity Validator  
**App Corpus:** Kids English Adventure  
**Scene Slice:** Persistent "Pip's Picnic" (`picnic_scene`)  

---

## 1. Executive Summary & Root-Cause Elimination

Phase 16.8 permanently eliminates the semantic and binding defects identified during physical device testing:
1. **Eliminated `Water → Apple` Defect:** Draggable and drop target bindings are explicitly resolved from `draggableObject` and `dropTarget`. In `dragAndDrop`, Apple (`picnic_apple_01`) directly drops into Basket (`picnic_basket_01`).
2. **Eliminated `Rabbit → Rabbit` Defect:** The food object (`picnic_apple_01`) is strictly separated from the scene receiver (`picnic_rabbit_01`). Dragging rabbit onto rabbit is contractually impossible.
3. **Eliminated Hardcoded 4-Question Prototype:** Sessions are composed as persistent, age-bounded multi-interaction narratives: Age 3 (6 interactions, 3–4 mins), Age 5 (6 interactions, 5–6 mins), Age 7 (7 interactions, 8–10 mins), Age 9 (7 interactions, 10–12 mins).
4. **Eliminated Pre-A Quiz Framing:** Replaced `Step X of 4` with soft visual journey dots (`● ○ ○ ○ ○ ○`). Text labels on cards are suppressed (`TextDensity.zero`).
5. **Eliminated Downward Arrow:** Replaced with an upward directional indicator pulsing toward the destination.
6. **Eliminated Wooden Plank Table Representation:** Replaced raw wood log with `ChildTableVisual` featuring a distinct tabletop, 4 visible legs, support crossbeam, and direct tabletop resting for objects.

---

## 2. Interaction Distribution Tables (From Actual Composer Output)

### AGE 3 SESSION DISTRIBUTION (Little Listeners (Ages 3–4))

| Mechanic | Count | Role in Pip's Picnic Session |
| :--- | :---: | :--- |
| `listenAndTouch` | 2 | Direct touch on target upon hearing audio prompt with immediate bounce |
| `dragAndDrop` | 1 | Physical movement of target object into container (e.g. apple into basket) |
| `feedCharacter` | 2 | Giving food/drink to hungry character (rabbit eats with animation) |
| `speakToMakeSomethingHappen` | 1 | Optional imitation with direct touch fallback; door visibly opens |
| **Tap Selection (Multiple Choice Quiz)** | **0** | **0% Tap Quiz Dominance** |
| **Total Interactions** | **6** | **Session Duration: 4 mins** |

### AGE 5 SESSION DISTRIBUTION (Little Explorers (Ages 4–5))

| Mechanic | Count | Role in Pip's Picnic Session |
| :--- | :---: | :--- |
| `listenAndTouch` | 1 | Identification of auditory concept |
| `dragAndDrop` | 1 | Physical movement of target object into container (e.g. apple into basket) |
| `feedCharacter` | 2 | Giving food/drink to hungry character (rabbit eats with animation) |
| `speakToMakeSomethingHappen` | 1 | Spoken command triggering real scene state change |
| `scenePlacement` | 1 | Spatial preposition arrangement on scene (e.g. book on table) |
| **Tap Selection (Multiple Choice Quiz)** | **0** | **0% Tap Quiz Dominance** |
| **Total Interactions** | **6** | **Session Duration: 6 mins** |

### AGE 7 SESSION DISTRIBUTION (Young Adventurers (Ages 6–7))

| Mechanic | Count | Role in Pip's Picnic Session |
| :--- | :---: | :--- |
| `listenAndTouch` | 1 | Identification of auditory concept |
| `scenePlacement` | 1 | Spatial preposition arrangement on scene (e.g. book on table) |
| `dragAndDrop` | 1 | Physical movement of target object into container (e.g. apple into basket) |
| `feedCharacter` | 1 | Giving food/drink to hungry character (rabbit eats with animation) |
| `speakToMakeSomethingHappen` | 2 | Spoken command triggering real scene state change |
| `conversationRolePlay` | 1 | Authentic dialogic exchange with Pip at picnic table |
| **Tap Selection (Multiple Choice Quiz)** | **0** | **0% Tap Quiz Dominance** |
| **Total Interactions** | **7** | **Session Duration: 10 mins** |

### AGE 9 SESSION DISTRIBUTION (Growing Speakers (Ages 8–10))

| Mechanic | Count | Role in Pip's Picnic Session |
| :--- | :---: | :--- |
| `listenAndTouch` | 1 | Identification of auditory concept |
| `dragAndDrop` | 1 | Physical movement of target object into container (e.g. apple into basket) |
| `scenePlacement` | 1 | Spatial preposition arrangement on scene (e.g. book on table) |
| `feedCharacter` | 1 | Giving food/drink to hungry character (rabbit eats with animation) |
| `speakToMakeSomethingHappen` | 2 | Spoken command triggering real scene state change |
| `conversationRolePlay` | 1 | Authentic dialogic exchange with Pip at picnic table |
| **Tap Selection (Multiple Choice Quiz)** | **0** | **0% Tap Quiz Dominance** |
| **Total Interactions** | **7** | **Session Duration: 12 mins** |

---

## 3. Comprehensive Step-by-Step Production Activity Audit

### ========================================================
### LIVE SESSION AUDIT: AGE 3 (Little Listeners (Ages 3–4))
### ========================================================

- **Session ID:** `session_activity_animal_vocab_3`
- **Target Lesson:** `activity_animal_vocab`
- **Reading Requirement:** `none` (zero required reading: true)
- **Text Density:** `zero`
- **Speaking Requirement:** `optionalImitation` (mandatory mic: false)
- **Initial Number of Choices:** `2`
- **Visual Target Size:** `120.0px` (Age 3: 120px huge target; Age 9: 58px refined target)
- **Pip Guidance Style:** `occasionalMusical`, Animation: `highPlayful`
- **Total Interactions:** `6` (Duration: 4 minutes)

#### Interaction 1: `activity_animal_vocab_step1_find_apple`
- **Exact Instruction:** "Apple! 🍎"
- **Learning Concept:** `concept_apple`
- **Mechanic Type:** `listenAndTouch`
- **Source / Draggable Object:** ID `picnic_apple_01` (Concept: `concept_apple`, Visual: `🍎`)
- **Target / Receiver Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Scene State Before:** Picnic blanket with target object and distractors in idle state.
- **Scene State After (Success):** Object scales up (1.18x) with sparkles and cheerful confirmation chime.
- **Success Condition:** Child touches target object (picnic_apple_01).
- **Fallback Mechanism:** Subtle pulsing glow affordance on draggable; gentle audio replay.
- **Visible Text on Screen:** Zero text labels (Pure emojis/visuals; progress via soft dots ●)
- **Spoken Audio:** "Apple"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 2: `activity_animal_vocab_step2_move_apple_basket`
- **Exact Instruction:** "Put the apple in the basket! 🍎"
- **Learning Concept:** `concept_apple`
- **Mechanic Type:** `dragAndDrop`
- **Source / Draggable Object:** ID `picnic_apple_01` (Concept: `concept_apple`, Visual: `🍎`)
- **Target / Receiver Object:** ID `picnic_basket_01` (Concept: `concept_basket`, Visual: `🧺`)
- **Scene State Before:** Apple on picnic blanket (pulsing affordance) and empty open picnic basket at destination.
- **Scene State After (Success):** Apple securely settles inside basket with bounce physics (🧺🍎).
- **Success Condition:** Draggable object (picnic_apple_01) dropped onto dropTarget (picnic_basket_01).
- **Fallback Mechanism:** Subtle pulsing glow affordance on draggable; gentle audio replay.
- **Visible Text on Screen:** Zero text labels (Pure emojis/visuals; progress via soft dots ●)
- **Spoken Audio:** "Put the apple in the basket"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 3: `activity_animal_vocab_step3_feed_rabbit`
- **Exact Instruction:** "The rabbit is hungry! Give it the apple. 🐰🍎"
- **Learning Concept:** `concept_apple`
- **Mechanic Type:** `feedCharacter`
- **Source / Draggable Object:** ID `picnic_apple_01` (Concept: `concept_apple`, Visual: `🍎`)
- **Target / Receiver Object:** ID `picnic_rabbit_01` (Concept: `concept_rabbit`, Visual: `🐰`)
- **Scene State Before:** Hungry rabbit waiting near picnic blanket; crisp apple ready to feed.
- **Scene State After (Success):** Rabbit happily munches apple with animated eating expression (🐰😋 "Nom nom!").
- **Success Condition:** Food/drink object dropped onto receiver (picnic_rabbit_01). NEVER receiver onto receiver.
- **Fallback Mechanism:** Subtle pulsing glow affordance on draggable; gentle audio replay.
- **Visible Text on Screen:** Zero text labels (Pure emojis/visuals; progress via soft dots ●)
- **Spoken Audio:** "Feed the rabbit the apple"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 4: `activity_animal_vocab_step4_give_water_pip`
- **Exact Instruction:** "Pip is thirsty! Give Pip water. 🐥💧"
- **Learning Concept:** `concept_water`
- **Mechanic Type:** `feedCharacter`
- **Source / Draggable Object:** ID `picnic_water_01` (Concept: `concept_water`, Visual: `💧`)
- **Target / Receiver Object:** ID `picnic_pip_01` (Concept: `concept_pip`, Visual: `🐥`)
- **Scene State Before:** Thirsty Pip near picnic blanket; fresh water bottle ready to offer.
- **Scene State After (Success):** Pip sips refreshing water and chirps joyfully (🐥✨ "Ah, refreshing!").
- **Success Condition:** Food/drink object dropped onto receiver (picnic_pip_01). NEVER receiver onto receiver.
- **Fallback Mechanism:** Subtle pulsing glow affordance on draggable; gentle audio replay.
- **Visible Text on Screen:** Zero text labels (Pure emojis/visuals; progress via soft dots ●)
- **Spoken Audio:** "Give Pip water"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 5: `activity_animal_vocab_step5_speak_water`
- **Exact Instruction:** "Water. Can you say water? 💧"
- **Learning Concept:** `concept_water`
- **Mechanic Type:** `speakToMakeSomethingHappen`
- **Source / Draggable Object:** ID `picnic_water_01` (Concept: `concept_water`, Visual: `💧`)
- **Target / Receiver Object:** ID `picnic_pip_01` (Concept: `concept_pip`, Visual: `🐥`)
- **Scene State Before:** Fresh water on blanket awaiting spoken request.
- **Scene State After (Success):** Water sparkles with ripple animation (💧✨).
- **Success Condition:** Child speaks phrase "water" OR taps fallback button.
- **Fallback Mechanism:** Immediate touch fallback button ("Or tap here 👆") always visible.
- **Visible Text on Screen:** Zero text labels (Pure emojis/visuals; progress via soft dots ●)
- **Spoken Audio:** "Water. Can you say water?"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 6: `activity_animal_vocab_step6_celebrate_picnic`
- **Exact Instruction:** "Picnic time! Touch the basket to celebrate! 🧺🎉"
- **Learning Concept:** `concept_basket`
- **Mechanic Type:** `listenAndTouch`
- **Source / Draggable Object:** ID `picnic_basket_01` (Concept: `concept_basket`, Visual: `🧺`)
- **Target / Receiver Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Scene State Before:** Picnic blanket with target object and distractors in idle state.
- **Scene State After (Success):** Object scales up (1.18x) with sparkles and cheerful confirmation chime.
- **Success Condition:** Child touches target object (picnic_basket_01).
- **Fallback Mechanism:** Subtle pulsing glow affordance on draggable; gentle audio replay.
- **Visible Text on Screen:** Zero text labels (Pure emojis/visuals; progress via soft dots ●)
- **Spoken Audio:** "Picnic time!"
- **Reward / Feedback:** Gentle star burst (Yay! ⭐), silent progress save (20 XP, 10 coins, 3 stars), no score screens or tests.

### ========================================================
### LIVE SESSION AUDIT: AGE 5 (Little Explorers (Ages 4–5))
### ========================================================

- **Session ID:** `session_activity_animal_vocab_5`
- **Target Lesson:** `activity_animal_vocab`
- **Reading Requirement:** `emergent` (zero required reading: false)
- **Text Density:** `minimal`
- **Speaking Requirement:** `encouragedRepetition` (mandatory mic: false)
- **Initial Number of Choices:** `3`
- **Visual Target Size:** `96.0px` (Age 3: 120px huge target; Age 9: 58px refined target)
- **Pip Guidance Style:** `friendlyRegular`, Animation: `highPlayful`
- **Total Interactions:** `6` (Duration: 6 minutes)

#### Interaction 1: `activity_animal_vocab_step1_find_red_apple`
- **Exact Instruction:** "Find the red apple. 🍎"
- **Learning Concept:** `concept_apple`
- **Mechanic Type:** `listenAndTouch`
- **Source / Draggable Object:** ID `picnic_apple_01` (Concept: `concept_apple`, Visual: `🍎`)
- **Target / Receiver Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Scene State Before:** Picnic blanket with target object and distractors in idle state.
- **Scene State After (Success):** Object scales up (1.18x) with sparkles and cheerful confirmation chime.
- **Success Condition:** Child touches target object (picnic_apple_01).
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "Find the red apple. 🍎" + choice labels
- **Spoken Audio:** "Find the red apple"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 2: `activity_animal_vocab_step2_apple_into_basket`
- **Exact Instruction:** "Put the apple in the basket. 🧺"
- **Learning Concept:** `concept_apple`
- **Mechanic Type:** `dragAndDrop`
- **Source / Draggable Object:** ID `picnic_apple_01` (Concept: `concept_apple`, Visual: `🍎`)
- **Target / Receiver Object:** ID `picnic_basket_01` (Concept: `concept_basket`, Visual: `🧺`)
- **Scene State Before:** Apple on picnic blanket (pulsing affordance) and empty open picnic basket at destination.
- **Scene State After (Success):** Apple securely settles inside basket with bounce physics (🧺🍎).
- **Success Condition:** Draggable object (picnic_apple_01) dropped onto dropTarget (picnic_basket_01).
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "Put the apple in the basket. 🧺" + choice labels
- **Spoken Audio:** "Put the apple in the basket"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 3: `activity_animal_vocab_step3_feed_hungry_rabbit`
- **Exact Instruction:** "The rabbit is hungry! Give it an apple. 🐰🍎"
- **Learning Concept:** `concept_apple`
- **Mechanic Type:** `feedCharacter`
- **Source / Draggable Object:** ID `picnic_apple_01` (Concept: `concept_apple`, Visual: `🍎`)
- **Target / Receiver Object:** ID `picnic_rabbit_01` (Concept: `concept_rabbit`, Visual: `🐰`)
- **Scene State Before:** Hungry rabbit waiting near picnic blanket; crisp apple ready to feed.
- **Scene State After (Success):** Rabbit happily munches apple with animated eating expression (🐰😋 "Nom nom!").
- **Success Condition:** Food/drink object dropped onto receiver (picnic_rabbit_01). NEVER receiver onto receiver.
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "The rabbit is hungry! Give it an apple. 🐰🍎" + choice labels
- **Spoken Audio:** "Give the rabbit an apple"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 4: `activity_animal_vocab_step4_give_pip_water`
- **Exact Instruction:** "Pip is thirsty! Give Pip water. 🐥💧"
- **Learning Concept:** `concept_water`
- **Mechanic Type:** `feedCharacter`
- **Source / Draggable Object:** ID `picnic_water_01` (Concept: `concept_water`, Visual: `💧`)
- **Target / Receiver Object:** ID `picnic_pip_01` (Concept: `concept_pip`, Visual: `🐥`)
- **Scene State Before:** Thirsty Pip near picnic blanket; fresh water bottle ready to offer.
- **Scene State After (Success):** Pip sips refreshing water and chirps joyfully (🐥✨ "Ah, refreshing!").
- **Success Condition:** Food/drink object dropped onto receiver (picnic_pip_01). NEVER receiver onto receiver.
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "Pip is thirsty! Give Pip water. 🐥💧" + choice labels
- **Spoken Audio:** "Give Pip water"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 5: `activity_animal_vocab_step5_speak_water_please`
- **Exact Instruction:** "Say: Water, please! 💧✨"
- **Learning Concept:** `concept_water`
- **Mechanic Type:** `speakToMakeSomethingHappen`
- **Source / Draggable Object:** ID `picnic_water_01` (Concept: `concept_water`, Visual: `💧`)
- **Target / Receiver Object:** ID `picnic_pip_01` (Concept: `concept_pip`, Visual: `🐥`)
- **Scene State Before:** Fresh water on blanket awaiting spoken request.
- **Scene State After (Success):** Water sparkles with ripple animation (💧✨).
- **Success Condition:** Child speaks phrase "water please" OR taps fallback button.
- **Fallback Mechanism:** Immediate touch fallback button ("Or tap here 👆") always visible.
- **Visible Text on Screen:** "Say: Water, please! 💧✨" + choice labels
- **Spoken Audio:** "Say: Water, please"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 6: `activity_animal_vocab_step6_place_book_table`
- **Exact Instruction:** "Put the book on the table. 📖"
- **Learning Concept:** `concept_book`
- **Mechanic Type:** `scenePlacement`
- **Source / Draggable Object:** ID `picnic_book_01` (Concept: `concept_book`, Visual: `📖`)
- **Target / Receiver Object:** ID `picnic_table_01` (Concept: `concept_table`, Visual: `ChildTableVisual (Canvas Table)`)
- **Scene State Before:** Guidebook on blanket; picnic table waiting for placement.
- **Scene State After (Success):** Book rests neatly on top of the picnic table with gold boundary glow.
- **Success Condition:** Draggable placed within table target area (on).
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "Put the book on the table. 📖" + choice labels
- **Spoken Audio:** "Put the book on the table"
- **Reward / Feedback:** Adventure Complete celebration burst 🎉, progress saved to ChildProfile.

### ========================================================
### LIVE SESSION AUDIT: AGE 7 (Young Adventurers (Ages 6–7))
### ========================================================

- **Session ID:** `session_activity_animal_vocab_7`
- **Target Lesson:** `activity_animal_vocab`
- **Reading Requirement:** `supported` (zero required reading: false)
- **Text Density:** `moderate`
- **Speaking Requirement:** `expectedProduction` (mandatory mic: true)
- **Initial Number of Choices:** `4`
- **Visual Target Size:** `76.0px` (Age 3: 120px huge target; Age 9: 58px refined target)
- **Pip Guidance Style:** `friendlyRegular`, Animation: `gentleBounce`
- **Total Interactions:** `7` (Duration: 10 minutes)

#### Interaction 1: `activity_animal_vocab_step1_sentence_touch`
- **Exact Instruction:** "What is this? It is an apple. 🍎"
- **Learning Concept:** `concept_apple`
- **Mechanic Type:** `listenAndTouch`
- **Source / Draggable Object:** ID `picnic_apple_01` (Concept: `concept_apple`, Visual: `🍎`)
- **Target / Receiver Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Scene State Before:** Picnic blanket with target object and distractors in idle state.
- **Scene State After (Success):** Object scales up (1.18x) with sparkles and cheerful confirmation chime.
- **Success Condition:** Child touches target object (picnic_apple_01).
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "What is this? It is an apple. 🍎" + choice labels
- **Spoken Audio:** "What is this? It is an apple."
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 2: `activity_animal_vocab_step2_book_on_table`
- **Exact Instruction:** "Put the book on the table. 📖"
- **Learning Concept:** `concept_book`
- **Mechanic Type:** `scenePlacement`
- **Source / Draggable Object:** ID `picnic_book_01` (Concept: `concept_book`, Visual: `📖`)
- **Target / Receiver Object:** ID `picnic_table_01` (Concept: `concept_table`, Visual: `ChildTableVisual (Canvas Table)`)
- **Scene State Before:** Guidebook on blanket; picnic table waiting for placement.
- **Scene State After (Success):** Book rests neatly on top of the picnic table with gold boundary glow.
- **Success Condition:** Draggable placed within table target area (on).
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "Put the book on the table. 📖" + choice labels
- **Spoken Audio:** "Put the book on the table"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 3: `activity_animal_vocab_step3_drag_apple_basket`
- **Exact Instruction:** "Drag the apple into the picnic basket. 🧺"
- **Learning Concept:** `concept_apple`
- **Mechanic Type:** `dragAndDrop`
- **Source / Draggable Object:** ID `picnic_apple_01` (Concept: `concept_apple`, Visual: `🍎`)
- **Target / Receiver Object:** ID `picnic_basket_01` (Concept: `concept_basket`, Visual: `🧺`)
- **Scene State Before:** Apple on picnic blanket (pulsing affordance) and empty open picnic basket at destination.
- **Scene State After (Success):** Apple securely settles inside basket with bounce physics (🧺🍎).
- **Success Condition:** Draggable object (picnic_apple_01) dropped onto dropTarget (picnic_basket_01).
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "Drag the apple into the picnic basket. 🧺" + choice labels
- **Spoken Audio:** "Drag the apple into the picnic basket"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 4: `activity_animal_vocab_step4_feed_rabbit_apple`
- **Exact Instruction:** "The hungry rabbit wants fruit. Feed the rabbit an apple. 🐰🍎"
- **Learning Concept:** `concept_apple`
- **Mechanic Type:** `feedCharacter`
- **Source / Draggable Object:** ID `picnic_apple_01` (Concept: `concept_apple`, Visual: `🍎`)
- **Target / Receiver Object:** ID `picnic_rabbit_01` (Concept: `concept_rabbit`, Visual: `🐰`)
- **Scene State Before:** Hungry rabbit waiting near picnic blanket; crisp apple ready to feed.
- **Scene State After (Success):** Rabbit happily munches apple with animated eating expression (🐰😋 "Nom nom!").
- **Success Condition:** Food/drink object dropped onto receiver (picnic_rabbit_01). NEVER receiver onto receiver.
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "The hungry rabbit wants fruit. Feed the rabbit an apple. 🐰🍎" + choice labels
- **Spoken Audio:** "Feed the rabbit an apple"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 5: `activity_animal_vocab_step5_speak_water_polite`
- **Exact Instruction:** "Say: Can I have some water, please? 🎙️💧"
- **Learning Concept:** `concept_water`
- **Mechanic Type:** `speakToMakeSomethingHappen`
- **Source / Draggable Object:** ID `picnic_water_01` (Concept: `concept_water`, Visual: `💧`)
- **Target / Receiver Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Scene State Before:** Fresh water on blanket awaiting spoken request.
- **Scene State After (Success):** Water sparkles with ripple animation (💧✨).
- **Success Condition:** Child speaks phrase "can i have some water please" OR taps fallback button.
- **Fallback Mechanism:** Immediate touch fallback button ("Or tap here 👆") always visible.
- **Visible Text on Screen:** "Say: Can I have some water, please? 🎙️💧" + choice labels
- **Spoken Audio:** "Can I have some water, please?"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 6: `activity_animal_vocab_step6_roleplay_picnic_pip`
- **Exact Instruction:** "Talk with Pip at the picnic! 🐥"
- **Learning Concept:** `concept_water`
- **Mechanic Type:** `conversationRolePlay`
- **Source / Draggable Object:** ID `picnic_water_01` (Concept: `concept_water`, Visual: `💧`)
- **Target / Receiver Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Scene State Before:** Pip seated at picnic table asking what the learner would like.
- **Scene State After (Success):** Pip thanks learner, hands over beverage, and displays joy animation.
- **Success Condition:** Child selects or speaks expected response "Water, please.".
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "Talk with Pip at the picnic! 🐥" + choice labels
- **Spoken Audio:** "What would you like at the picnic?"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 7: `activity_animal_vocab_step7_speak_open_door`
- **Exact Instruction:** "Say: Open the door to get the picnic blanket! 🚪✨"
- **Learning Concept:** `concept_door`
- **Mechanic Type:** `speakToMakeSomethingHappen`
- **Source / Draggable Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Target / Receiver Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Scene State Before:** Cabin door firmly closed (🚪🔒 CLOSED).
- **Scene State After (Success):** Door swings wide open (🚪🔓 OPEN!) with sparkles.
- **Success Condition:** Child speaks phrase "open the door" OR taps fallback button.
- **Fallback Mechanism:** Immediate touch fallback button ("Or tap here 👆") always visible.
- **Visible Text on Screen:** "Say: Open the door to get the picnic blanket! 🚪✨" + choice labels
- **Spoken Audio:** "Say: Open the door"
- **Reward / Feedback:** Adventure Complete celebration burst 🎉, progress saved to ChildProfile.

### ========================================================
### LIVE SESSION AUDIT: AGE 9 (Growing Speakers (Ages 8–10))
### ========================================================

- **Session ID:** `session_activity_animal_vocab_9`
- **Target Lesson:** `activity_animal_vocab`
- **Reading Requirement:** `independent` (zero required reading: false)
- **Text Density:** `rich`
- **Speaking Requirement:** `conversationalDiscourse` (mandatory mic: true)
- **Initial Number of Choices:** `4`
- **Visual Target Size:** `58.0px` (Age 3: 120px huge target; Age 9: 58px refined target)
- **Pip Guidance Style:** `supportiveTargeted`, Animation: `subtleRefined`
- **Total Interactions:** `7` (Duration: 12 minutes)

#### Interaction 1: `activity_animal_vocab_step1_contextual_drink_problem`
- **Exact Instruction:** "Pip says: "We forgot to pack a drink for the picnic. What should we take?" 🧺"
- **Learning Concept:** `concept_water`
- **Mechanic Type:** `listenAndTouch`
- **Source / Draggable Object:** ID `picnic_water_01` (Concept: `concept_water`, Visual: `💧`)
- **Target / Receiver Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Scene State Before:** Picnic blanket with target object and distractors in idle state.
- **Scene State After (Success):** Object scales up (1.18x) with sparkles and cheerful confirmation chime.
- **Success Condition:** Child touches target object (picnic_water_01).
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "Pip says: "We forgot to pack a drink for the picnic. What should we take?" 🧺" + choice labels
- **Spoken Audio:** "What drink should we take to the picnic?"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 2: `activity_animal_vocab_step2_pack_water_basket`
- **Exact Instruction:** "Place the water bottle inside the picnic basket. 🧺"
- **Learning Concept:** `concept_water`
- **Mechanic Type:** `dragAndDrop`
- **Source / Draggable Object:** ID `picnic_water_01` (Concept: `concept_water`, Visual: `💧`)
- **Target / Receiver Object:** ID `picnic_basket_01` (Concept: `concept_basket`, Visual: `🧺`)
- **Scene State Before:** Apple on picnic blanket (pulsing affordance) and empty open picnic basket at destination.
- **Scene State After (Success):** Apple securely settles inside basket with bounce physics (🧺🍎).
- **Success Condition:** Draggable object (picnic_water_01) dropped onto dropTarget (picnic_basket_01).
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "Place the water bottle inside the picnic basket. 🧺" + choice labels
- **Spoken Audio:** "Place the water bottle inside the picnic basket"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 3: `activity_animal_vocab_step3_guidebook_table`
- **Exact Instruction:** "Arrange the picnic area. Put the guidebook on the table. 📖"
- **Learning Concept:** `concept_book`
- **Mechanic Type:** `scenePlacement`
- **Source / Draggable Object:** ID `picnic_book_01` (Concept: `concept_book`, Visual: `📖`)
- **Target / Receiver Object:** ID `picnic_table_01` (Concept: `concept_table`, Visual: `ChildTableVisual (Canvas Table)`)
- **Scene State Before:** Guidebook on blanket; picnic table waiting for placement.
- **Scene State After (Success):** Book rests neatly on top of the picnic table with gold boundary glow.
- **Success Condition:** Draggable placed within table target area (on).
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "Arrange the picnic area. Put the guidebook on the table. 📖" + choice labels
- **Spoken Audio:** "Put the guidebook on the table"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 4: `activity_animal_vocab_step4_offer_apple_rabbit`
- **Exact Instruction:** "A friendly rabbit visits our picnic. Offer the apple to the rabbit. 🐰🍎"
- **Learning Concept:** `concept_apple`
- **Mechanic Type:** `feedCharacter`
- **Source / Draggable Object:** ID `picnic_apple_01` (Concept: `concept_apple`, Visual: `🍎`)
- **Target / Receiver Object:** ID `picnic_rabbit_01` (Concept: `concept_rabbit`, Visual: `🐰`)
- **Scene State Before:** Hungry rabbit waiting near picnic blanket; crisp apple ready to feed.
- **Scene State After (Success):** Rabbit happily munches apple with animated eating expression (🐰😋 "Nom nom!").
- **Success Condition:** Food/drink object dropped onto receiver (picnic_rabbit_01). NEVER receiver onto receiver.
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "A friendly rabbit visits our picnic. Offer the apple to the rabbit. 🐰🍎" + choice labels
- **Spoken Audio:** "Offer the apple to the rabbit"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 5: `activity_animal_vocab_step5_speak_reasoning`
- **Exact Instruction:** "Say: Pip, would you like an apple or water? 🎙️✨"
- **Learning Concept:** `concept_apple`
- **Mechanic Type:** `speakToMakeSomethingHappen`
- **Source / Draggable Object:** ID `picnic_apple_01` (Concept: `concept_apple`, Visual: `🍎`)
- **Target / Receiver Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Scene State Before:** Fresh water on blanket awaiting spoken request.
- **Scene State After (Success):** Water sparkles with ripple animation (💧✨).
- **Success Condition:** Child speaks phrase "pip would you like an apple or water" OR taps fallback button.
- **Fallback Mechanism:** Immediate touch fallback button ("Or tap here 👆") always visible.
- **Visible Text on Screen:** "Say: Pip, would you like an apple or water? 🎙️✨" + choice labels
- **Spoken Audio:** "Say: Pip, would you like an apple or water?"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 6: `activity_animal_vocab_step6_authentic_dialogue`
- **Exact Instruction:** "Have a picnic conversation with Pip. 🐥"
- **Learning Concept:** `concept_water`
- **Mechanic Type:** `conversationRolePlay`
- **Source / Draggable Object:** ID `picnic_water_01` (Concept: `concept_water`, Visual: `💧`)
- **Target / Receiver Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Scene State Before:** Pip seated at picnic table asking what the learner would like.
- **Scene State After (Success):** Pip thanks learner, hands over beverage, and displays joy animation.
- **Success Condition:** Child selects or speaks expected response "Here is your water, Pip!".
- **Fallback Mechanism:** Pip audio clue on pause; optional lightbulb hint; 5-step fallback.
- **Visible Text on Screen:** "Have a picnic conversation with Pip. 🐥" + choice labels
- **Spoken Audio:** "I would love some fresh water after our long walk!"
- **Reward / Feedback:** Pip smile, immediate object reaction, seamless auto-advance.

#### Interaction 7: `activity_animal_vocab_step7_open_cabin_door`
- **Exact Instruction:** "We need supplies from the cabin. Say: Open the door. 🚪✨"
- **Learning Concept:** `concept_door`
- **Mechanic Type:** `speakToMakeSomethingHappen`
- **Source / Draggable Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Target / Receiver Object:** ID `picnic_door_01` (Concept: `concept_door`, Visual: `🚪`)
- **Scene State Before:** Cabin door firmly closed (🚪🔒 CLOSED).
- **Scene State After (Success):** Door swings wide open (🚪🔓 OPEN!) with sparkles.
- **Success Condition:** Child speaks phrase "open the door" OR taps fallback button.
- **Fallback Mechanism:** Immediate touch fallback button ("Or tap here 👆") always visible.
- **Visible Text on Screen:** "We need supplies from the cabin. Say: Open the door. 🚪✨" + choice labels
- **Spoken Audio:** "Say: Open the door"
- **Reward / Feedback:** Adventure Complete celebration burst 🎉, progress saved to ChildProfile.

