# Phase 16.6: Age Differentiation Audit — Same Concept Across Ages

**Kids English Adventure — Pedagogical Age Differentiation Verification**  
**Auditor:** Learning Experience & Early Childhood Architecture  
**Curriculum Lock State:** `FROZEN_LEVELS_1_TO_3` (Hash: `02f9e00cbd1c1c52`)  
**Core Finding Addressed:** Content/experience previously felt identical across age bands.

This audit documents how the exact same canonical concepts are transformed into genuinely distinct, age-appropriate developmental learning experiences for **Age 3 (Pre-A)**, **Age 5 (Band A)**, **Age 7 (Band B)**, and **Age 9 (Band C)**.

---

## 1. Concept: APPLE (`concept_apple`)

### Age 3 — Little Listeners (Pre-A)
* **Exact Spoken Prompt:** *"Apple! 🎈"* (Auto-plays on entry with clear, slow articulation).
* **Visible Text:** **Zero text labels.** (Only high-contrast, oversized 120dp icon/emoji).
* **Audio Modeling:** Native pronunciation models every time; optional tap-to-replay speaker icon.
* **Number of Choices:** **2 choices** (Oversized 120dp touch targets: Apple 🍎 vs Water 💧).
* **Child Interaction:** **Listen & Touch / Direct Tap.** Touching the apple triggers immediate 1.18x bounce scale with sparkle burst.
* **Speaking Requirement:** **Optional imitation.** Pip asks gently: *"Can you say apple?"*. Silence or no input has zero penalty and advances smoothly.
* **Pip Reaction:** Joyful bounce with cheerful sound (`PipState.happy`, `"Yay! 🌟"`).
* **Reward:** Soft 2-tone wooden chime (`correctSoft`), 1 star sparkle, no complex XP counters.
* **Hint Behavior:** Target apple card automatically pulses with warm golden glow after 4 seconds of inactivity.

---

### Age 5 — Little Explorers (Band A)
* **Exact Spoken Prompt:** *"Find the apple. 🔍"*
* **Visible Text:** Minimal (Optional small caption below card, non-blocking).
* **Audio Modeling:** Spoken directive on start; child hears word modeled on card tap.
* **Number of Choices:** **3 choices** (Apple 🍎, Cat 🐱, Bird 🐦).
* **Child Interaction:** **Guided Drag & Drop.** Child drags apple into fruit basket. Incorrect drop gently springs back to origin.
* **Speaking Requirement:** **Encouraged repetition.** Pip prompts: *"Apple! Can you repeat after Pip?"*.
* **Pip Reaction:** High-five animation (`"Look at that! High five! ✋"`).
* **Reward:** 2 stars, sparkling calibration, sound effect `correctIndependent`.
* **Hint Behavior:** Pip provides verbal clue: *"It is red and yummy! 🍎"* if child pauses.

---

### Age 7 — Young Adventurers (Band B)
* **Exact Spoken Prompt:** *"What is this? It is an apple."*
* **Visible Text:** Full structured sentence caption in rounded Nunito: *"This is an apple."*
* **Audio Modeling:** On-demand audio or first sentence model.
* **Number of Choices:** **4 choices** in illustrated scene context.
* **Child Interaction:** **Scene Assembly & Sentence Answering.** Child taps target and connects sentence tile `This is an apple`.
* **Speaking Requirement:** **Expected vocal production.** Child taps mic and articulates *"It is an apple"* with child-calibrated threshold (0.45+). Touch fallback always available.
* **Pip Reaction:** Reassuring nod (`"Great speaking! That was clear."`).
* **Reward:** 3 stars, 25 XP, 10 coins, positive mastery signal.
* **Hint Behavior:** On-demand hint lightbulb button; no automatic intrusive interrupts.

---

### Age 9 — Growing Speakers (Band C)
* **Exact Spoken Prompt:** *"What fruit do you like? Can you use apple in everyday conversation?"*
* **Visible Text:** Clean, realistic card layout (no cartoon toddler borders) with dialogue prompt.
* **Audio Modeling:** Natural adult conversational tempo (0.50 rate) on demand.
* **Number of Choices:** **4 contextual choices** or open speaking response.
* **Child Interaction:** **Contextual Role-Play & Reasoning.** Child chooses or speaks: *"I like apples because they are sweet."*
* **Speaking Requirement:** **Conversational discourse.** Full sentence expression evaluated for communicative intent.
* **Pip Reaction:** Subtle companion smile (`PipState.happy`, `"You said that really well."`).
* **Reward:** Skill mastery badge progress, XP counter update, clean transition without infantalizing fanfare.
* **Hint Behavior:** On-demand structural hints (e.g. grammar scaffold `I like [noun] because...`).

---

## 2. Concept: WATER (`concept_water`)

| Dimension | Age 3 (Pre-A) | Age 5 (Band A) | Age 7 (Band B) | Age 9 (Band C) |
| :--- | :--- | :--- | :--- | :--- |
| **Exact Prompt** | *"Water! 💧"* | *"Find the water. 🔍"* | *"What do you drink when thirsty?"* | *"What would you like at the picnic?"* |
| **Visible Text** | **Zero text** (120dp card) | Single word `water` | Sentence: `I drink water.` | Full dialogue bubble |
| **Choices Count** | **2 choices** | 3 choices | 4 choices | 4 conversational choices |
| **Interaction** | Touch water drop $\rightarrow$ water ripple reaction | Drag cup to water jug | Sentence builder: `I drink water` | Role-play: *"Water, please."* |
| **Speaking** | Optional imitation | Encouraged repeat | Spoken target: `Water` | Multi-turn role-play response |
| **Pip Reaction** | Musical chirp (`"Look! 🐥"`) | Cheerful bounce | Supportive confirmation | Peer nod (`"That was clear."`) |
| **Hint Style** | Auto-pulse glow | Pip clue: *"Cool to drink!"* | On-demand hint button | Vocabulary context hint |

---

## 3. Concept: CAT (`concept_cat`)

| Dimension | Age 3 (Pre-A) | Age 5 (Band A) | Age 7 (Band B) | Age 9 (Band C) |
| :--- | :--- | :--- | :--- | :--- |
| **Exact Prompt** | *"Cat! 🐱"* | *"Where is the cat? 🔍"* | *"What pet is this?"* | *"Describe your favorite animal."* |
| **Visible Text** | **Zero text** | Word `cat` | Caption: `This is a cat.` | Paragraph scenario |
| **Choices Count** | **2 choices** | 3 choices | 4 choices | 4 contextual choices |
| **Interaction** | Tap cat $\rightarrow$ cat meows & wiggles | Tap cat $\rightarrow$ audio meow + repeat | Connect picture to sound | Animal sorting / description |
| **Speaking** | Optional (*"Can you say cat?"*) | Repeat word *"Cat"* | Sentence: *"It is a small cat."* | Response: *"Cats are friendly pets."* |
| **Pip Reaction** | Peek-a-boo flutter (`"Yay! 🌟"`) | High-five | Encouraging smile | Quiet approval |
| **Hint Style** | Card pulses after 4s | Sound clue: *"Meow! 🐱"* | On-demand button | Contextual clue |

---

## 4. Concept: DOOR (`concept_door`)

| Dimension | Age 3 (Pre-A) | Age 5 (Band A) | Age 7 (Band B) | Age 9 (Band C) |
| :--- | :--- | :--- | :--- | :--- |
| **Exact Prompt** | *"Door! 🚪"* | *"Open the door! 🚪"* | *"How do we enter the room?"* | *"Give an instruction to enter."* |
| **Visible Text** | **Zero text** | Caption `door` | Text: `Open the door.` | Instruction card |
| **Choices Count** | **2 choices** | 2–3 choices | 4 choices | Contextual scenario |
| **Interaction** | Tap door $\rightarrow$ opens with chime | Drag key to door / Tap | Speak: *"Open the door"* $\rightarrow$ door opens | Command building: *"Please open the door."* |
| **Speaking** | Optional (or tap bypass) | Repeat: *"Door"* | Speak: *"Open the door"* (Touch fallback) | Spoken communicative request |
| **Pip Reaction** | Bounces through open door | Claps hands | Warm verbal praise | Confirms action smoothly |
| **Hint Style** | Door sparkles | Glowing handle | Step-by-step cue | Prompt reminder |

---

## 5. Concept: HELP (`concept_help`)

| Dimension | Age 3 (Pre-A) | Age 5 (Band A) | Age 7 (Band B) | Age 9 (Band C) |
| :--- | :--- | :--- | :--- | :--- |
| **Exact Prompt** | *"Help! 🤝"* | *"Can you help Pip?"* | *"Pip cannot reach. What can you say?"* | *"A friend needs assistance. What do you say?"* |
| **Visible Text** | **Zero text** | Short phrase | Phrase: `Can I help you?` | Full communicative dilemma |
| **Choices Count** | **2 choices** | 2–3 choices | 3–4 choices | 4 social choices |
| **Interaction** | Tap helping hands $\rightarrow$ Pip hugs | Drag stool to help Pip reach | Select / speak: *"I can help."* | Role-play helping scenario |
| **Speaking** | Optional | Repeat: *"Help"* | Speak: *"Can I help you?"* | Spoken empathy & helpfulness |
| **Pip Reaction** | Warm chirp (`"Together! 💖"`) | Pip says: *"Thank you! 😊"* | *"Wonderful kindness!"* | *"That is very thoughtful."* |
| **Value Integration**| Helping family / kindness | Helping friends | Sunnah of helping others | Community responsibility |

---

## Summary of Verification

1. **Zero Text for Age 3**: Confirmed across all 5 concepts.
2. **Distinct Interaction Types**: Age 3 relies on direct touch & sound reaction; Age 5 uses guided drag; Age 7 uses structured sentence building & speaking; Age 9 uses contextual conversation and reasoning.
3. **Pacing and Cognitive Load**: Age 3 has 2 choices and $\le 2$ word prompts; Age 9 has mature layout without toddler animations.
4. **Frozen Curriculum Intact**: All 5 concepts utilize canonical IDs (`concept_apple`, `concept_water`, `concept_cat`, `concept_door`, `concept_help`) without modifying frozen data.
