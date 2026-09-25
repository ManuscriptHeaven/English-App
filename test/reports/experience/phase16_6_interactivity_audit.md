# Phase 16.6: Interactivity Audit — Seven Core Vertical Slice Mechanics

**Kids English Adventure — Physical Interactivity Verification**  
**Auditor:** Quality Assurance & Child Interaction Engineering  
**Curriculum Lock Status:** `FROZEN_LEVELS_1_TO_3` (Hash: `02f9e00cbd1c1c52`)  
**Objective:** Prove that the app transforms from passive `prompt → tap → next` into meaningful physical interaction where children actively manipulate objects and cause things to happen in English.

---

## Mechanic 1: Listen & Touch

* **Concept Used:** `concept_apple` (Apple)
* **Target Age:** Age 3–4 (Pre-A Little Listeners)
* **Learning Goal:** Auditory recognition and receptive association between spoken word and visual object.
* **Exact Child Action:**
  1. Native audio models word: *"Apple! 🎈"*.
  2. Child touches the large 120dp apple tile.
* **Exact App Reaction:**
  1. Instant tactile spring scale (1.0 $\rightarrow$ 1.18 $\rightarrow$ 0.94 $\rightarrow$ 1.0) with sparkling border.
  2. Sound effect: soft wooden chime (`correctSoft`).
  3. Pip gives a cheerful bounce (`PipState.happy`) with short vocal burst: *"Yay! 🌟"*.
  4. Audio reinforces: *"Apple!"*.
* **Failure / Retry Path:**
  - If child taps the wrong card (e.g. water), no buzzer sounds; the card wobbles gently (3° oscillation) and Pip tilts head: *"Listen! 👂"*, while the target apple card gently pulses with a warm golden highlight.
* **Accessibility Fallback:**
  - Semantics label provided; auto-hint pulses after 4 seconds of inactivity.

---

## Mechanic 2: Drag & Drop

* **Concept Used:** `concept_apple` (Apple) $\rightarrow$ `concept_table` (Fruit Basket on Table)
* **Target Age:** Age 4–5 (Band A Little Explorers)
* **Learning Goal:** Kinesthetic manipulation connecting concrete nouns to their natural purposeful destination.
* **Exact Child Action:**
  1. Prompt announces: *"Put the apple in the basket! 🧺"*.
  2. Child presses and drags the apple tile across the screen onto the fruit basket drop target.
* **Exact App Reaction:**
  1. While dragging: semi-transparent feedback thumbnail follows finger smoothly at 60 FPS; drop target highlights in soft green with 4px border.
  2. On successful release: apple snaps into basket with a warm acoustic guitar strum (`recoverySuccess`).
  3. Pip claps hands: *"You did it! 🎈"*.
* **Failure / Retry Path:**
  - If dropped outside the basket, the apple animates smoothly back to its starting coordinate with zero penalty.
* **Accessibility Fallback:**
  - Dragging can also be triggered via single tap on apple followed by tap on basket for children with motor difficulties.

---

## Mechanic 3: Feed the Character

* **Concept Used:** `concept_apple` $\rightarrow$ `concept_rabbit` (Hungry Rabbit)
* **Target Age:** Age 3–5 (Pre-A & Band A)
* **Learning Goal:** Associating food nouns with active life concepts and empathy/caring for animals.
* **Exact Child Action:**
  1. Pip announces: *"The rabbit is hungry! Give it an apple. 🐰🍎"*.
  2. Child drags the red apple to the rabbit's mouth.
* **Exact App Reaction:**
  1. Rabbit's eyes widen joyfully; mouth animates in a 3-frame chewing motion with cute chomping sound.
  2. Stars and hearts float above rabbit.
  3. Pip announces: *"Nom nom! The rabbit is eating an apple! 🐰🍎"*.
* **Failure / Retry Path:**
  - If child drags an inedible object or misses, rabbit gives a friendly nose-twitch and Pip prompts: *"The rabbit wants the apple! 🍎"*.
* **Accessibility Fallback:**
  - Direct touch on apple automatically animates it toward the rabbit if motor drag is difficult.

---

## Mechanic 4: Scene Placement (Spatial Prepositions: In / On / Under)

* **Concept Used:** `concept_book` (Book) on `concept_table` (Table)
* **Target Age:** Age 6–7 (Band B Young Adventurers)
* **Learning Goal:** Mastering spatial prepositions (*on*, *under*, *in*) through physical placement rather than abstract multiple-choice quizzes.
* **Exact Child Action:**
  1. Instruction models: *"Put the book on the table. 📖"*.
  2. Child drags the book onto the top surface of the table.
* **Exact App Reaction:**
  1. The book settles onto the tabletop with a satisfying solid tap sound (`tap_wood`).
  2. Warm sparkle outline illuminates the table and book together.
  3. Text caption displays: *"The book is on the table."*.
  4. Pip confirms: *"The book is on the table! 🌟"*.
* **Failure / Retry Path:**
  - If child places the book *under* the table instead of *on*, Pip says: *"That is under the table! Put it on the table. 😊"*, guiding learning naturally without shame.
* **Accessibility Fallback:**
  - Tap-to-select object then tap-to-select destination zone.

---

## Mechanic 5: Speak to Make Something Happen (Signature Feature)

* **Concept Used:** `concept_door` (Open the Door) / `concept_room`
* **Target Age:** Age 4–9 (All bands, with calibrated scaffolding)
* **Learning Goal:** Experiencing that English speech possesses communicative efficacy—words cause real-world changes.
* **Exact Child Action:**
  1. Screen displays closed wooden door with lock icon: `🚪🔒`.
  2. Pip instructs: *"Say: Open the door! 🎙️"*.
  3. Child taps microphone button and says: *"Open the door"*.
* **Exact App Reaction:**
  1. Sound-level visualizer ripples react in real-time to the child's voice.
  2. Speech recognition evaluates utterance against initial tuning threshold (0.45+).
  3. On success: clicking latch sound plays, door swings wide open to reveal a sunny meadow (`🚪🔓✨`), and Pip walks through into the room!
* **Failure / 5-Step Progressive Fallback Path (Section 21):**
  1. *Step 1 (Model):* Pip replays model audio clearly: *"Listen: Open the door"*.
  2. *Step 2 (Retry):* Microphone glows green: *"Try once more! 🎙️"*.
  3. *Step 3 (Simplified Target):* Target simplifies to single word: *"Can you say: Open?"*.
  4. *Step 4 (Parent Assist):* Parent can tap "Assist" to verify child's speech.
  5. *Step 5 (Direct Touch Fallback):* Screen displays prominent button: *"Or tap here to open the door! 👆"*. Tapping opens the door with full celebration, guaranteeing zero progression blockers.
* **Accessibility Fallback:**
  - Direct touch bypass button active immediately for non-verbal children or devices with disabled microphones.

---

## Mechanic 6: Interactive Story Moment

* **Concept Used:** `concept_water` inside canonical story `story_thirsty_bird`
* **Target Age:** Age 4–7 (Band A & B)
* **Learning Goal:** Active story listening where comprehension is demonstrated through narrative intervention rather than passive reading.
* **Exact Child Action:**
  1. Narration plays: *"The little bird is thirsty in the warm sun."*.
  2. Scene pauses; child drags the water cup to the thirsty bird perched on the branch.
* **Exact App Reaction:**
  1. Bird chirps delightedly, dips beak into water, and water level lowers with drinking audio.
  2. Narration automatically resumes: *"The bird drinks the cool water! Alhamdulillah!"*.
  3. Frozen story canonical text remains 100% untouched.
* **Failure / Retry Path:**
  - If child pauses, the water bowl pulses with a soft blue shimmer to guide attention.
* **Accessibility Fallback:**
  - Auto-advance after 8 seconds if child prefers passive story-listening mode.

---

## Mechanic 7: Conversation Role-Play

* **Concept Used:** `concept_water` & `func_request_food`
* **Target Age:** Age 6–9 (Band B & C)
* **Learning Goal:** Conversational turn-taking and polite requests in authentic social scenarios.
* **Exact Child Action:**
  1. Picnic scenario: Pip sits opposite child and asks: *"What would you like at the picnic?"*.
  2. Child selects or speaks: *"Water, please."*.
* **Exact App Reaction:**
  1. Pip nods happily and physically slides a glass of fresh water across the picnic blanket to the child's side of the table.
  2. Pip replies: *"Here is your fresh water! 💧 Enjoy!"*.
  3. Reward: Conversation mastery star.
* **Failure / Retry Path:**
  - If child says only *"Water"*, Pip models polite phrasing gently: *"Can you say: Water, please? 😊"*.
* **Accessibility Fallback:**
  - Both visual choice buttons and spoken speech input are supported side-by-side.

---

## Conclusion
The 7 vertical slice mechanics prove that English learning is achieved through physical cause-and-effect, active manipulation, and meaningful communication, completely eliminating monotonous next-button tap sequences.
