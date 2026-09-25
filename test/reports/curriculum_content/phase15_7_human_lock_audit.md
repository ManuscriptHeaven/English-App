# Kids English Adventure — Phase 15.7 Human Curriculum Lock Audit

**Document**: `phase15_7_human_lock_audit.md`  
**Purpose**: Focused inspection document exposing final production strings, corrected mappings, newly added conversational routines, and manual spot-check scenarios for Product Owner curriculum freeze sign-off.  
**Status**: **CURRICULUM_LOCK_CANDIDATE — READY FOR FINAL REVIEW**  

---

## 1. Summary of Changes in Phase 15.7

| Dimension | Baseline | Phase 15.7 | Key Changes |
| :--- | :---: | :---: | :--- |
| **Level 1 Vocabulary** | 144 | 144 | Audited 16 definitions to simple child English; fixed `read` progression mapping |
| **Level 2 Phrases** | 57 | 64 | Added 4 everyday states ("I'm hungry/thirsty/happy/tired") + 3 repair phrases ("I don't understand") |
| **Level 3 Patterns** | 21 | 26 | Added `pattern_i_need` + 4 question templates (`What color is it?`, `How many?`, `What do you need/want?`) |
| **Conversation Functions** | 6 | 13 | Added 7 new social exchanges; purged automatic religious praise from family identification |
| **Pip Dialogue Pools** | Jargon present | Cleaned | Purged all robotic grading terms from Bands C & D; instituted 4-tier feedback intensity |
| **Unit Titles** | Literary | Simplified | Renamed to simple child English (`Meet the Animals`, `Food & Drinks`, etc.) |

---

## 2. Manual Spot-Check Scenarios

### Scenario A — Age 5 Beginner
**Goal**: Child learns `"water"` and progresses to polite request `"Water, please."`
- **Word**: `water` (`concept_water`)
  - Pip audio prompt: *"water"*
  - Child prompt (Band A): *"What is this? Say water."*
  - Target response: `"water"`
  - Pip small success praise: *"Nice."* / *"Yay! You got it!"*
- **Phrase Bridge**: `water, please` (`concept_p2_water_please`)
  - Context: Beginner mealtime request
  - Pip opening: *"Are you thirsty?"*
  - Child response: `"Water, please."`
  - Pip follow-up: *"Here you are! 💧"*
  - Child response: `"Thank you!"*
  - Pip feedback: *"You're welcome! Enjoy!"*

### Scenario B — Age 7
**Goal**: Child encounters a difficult challenge and asks for help.
- **Dialogue Routine**: `func_asking_for_help`
  - Pip opening: *"Do you want help with the blocks?"*
  - Early acceptable response: `"Help me, please."` (`concept_p2_help_me_please`)
  - Target response: `"Can you help me, please?"` (`pattern_can_you_help_me`)
  - Stronger response: `"Can you help me with this, please?"`
  - Pip follow-up: *"Of course! Let's build together!"*
  - Child: `"Thank you, Pip!"*
  - Recovery prompt if child hesitates: *"Say: Can you help me, please?"*

### Scenario C — Age 9 Beginner
**Goal**: Older beginner learning `"cat"` without feeling patronized by babyish UI or confused by academic definitions.
- **Concept**: `concept_cat`
  - Internal definition: *"A small animal that many people keep as a pet."* (Purged: `"domesticated feline pet"`)
  - UI Prompt (Band C): *"What is this? Say cat."* (Purged: `"Identify and pronounce the target concept"`)
  - Example context: *"The cat sleeps on the soft chair."*
  - Correct answer Pip response: *"Exactly right!"* / *"Nice."* (Purged: `"That's accurate"`, `"Solid answer"`)
  - Retry Pip response: *"Try that one again."* / *"Listen once more."* (Purged: `"Review the sentence context and try once more"`)

### Scenario D — Age 9 Conversation Repair
**Goal**: Child does not understand what Pip said and uses active repair language.
- **Dialogue Routine**: `func_conversation_repair`
  - Pip prompt: *"Can you arrange these quickly?"*
  - Step 1 (Early admission): `"I don't know."` (`concept_p2_i_dont_know`)
  - Step 2 (Target clarification): `"I don't understand."` (`concept_p2_i_dont_understand`)
  - Step 3 (Repair request): `"Please say it again."` (`concept_p2_say_it_again`)
  - Combined target: *"I don't understand. Please say it again."*
  - Pip gentle reply: *"No problem at all! Let's do it slowly together."*
  - Recovery hint if silent: *"If you didn't hear, say: Please say it again."*

### Scenario E — Food Request Progression
**Goal**: Complete multi-stage progression from single word to polite social exchange.
- **Stage 1 (Level 1)**: `"water"` (`concept_water`) -> Single word imitation.
- **Stage 2 (Level 2)**: `"water, please"` (`concept_p2_water_please`) -> Beginner courtesy collocation.
- **Stage 3 (Level 3)**: `"Can I have water, please?"` (`pattern_can_i_have`) -> Full modal request.
- **Stage 4 (Advanced)**: `"Can I have some water, please?"` -> Quantified polite request.
- **Full Interactive Exchange** (`func_polite_request_food`):
  - Pip: *"Are you thirsty?"*
  - Child: *"Yes! Can I have some water, please?"*
  - Pip: *"Here you are! 💧"*
  - Child: *"Thank you!"*
  - Pip: *"You're welcome! Enjoy! 😊"*

### Scenario F — Contextual Islamic Greeting
**Goal**: Meaningful cultural and faith-based greeting practiced naturally without arbitrary praise triggers.
- **Exchange** (`func_greeting_exchange`):
  - Pip opening: *"Assalamu Alaikum, explorer! How are you today?"*
  - Child response: *"Wa Alaikum Assalam, Pip! I'm fine, thank you!"*
  - Pip warm welcome: *"Wonderful! Let's start our adventure today! 🌟"*
- **Review Safeguards**: All Islamic greetings and expressions (`concept_p2_assalamu_alaikum`, `concept_p2_wa_alaikum_assalam`, `concept_p2_bismillah`, `concept_p2_alhamdulillah`) carry status **`pendingQualifiedIslamicReview`**.
- **Eliminated**: Automatic `MashaAllah` / `Alhamdulillah` triggers on standard correct multiple-choice taps.

---

## 3. High-Risk / Changed Content Inventory

### 3.1 Corrected `read` Progression
- `concept_read`: **`read`** (Level 1 Action)
  - Definition: *"To look at and read words or books."*
  - Phrase bridge: `concept_p2_read_book` (`"read a book"`)
  - Sentence pattern: `pattern_i_can` (`"I can read."`)
  - Conversation turn: `func_ability_query` (*"Can you read this word?"* -> *"Yes, I can read!"*)
  - Disconnected: Confirmed zero prerequisite link to `concept_p2_eat_bread`.

### 3.2 New Everyday State Phrases
| Phrase ID | Canonical Text | Prerequisites | Meaning |
| :--- | :--- | :--- | :--- |
| `concept_p2_im_hungry` | `I'm hungry` | `concept_hungry` | Expressing the need for food |
| `concept_p2_im_thirsty` | `I'm thirsty` | `concept_thirsty` | Expressing the need for a drink |
| `concept_p2_im_happy` | `I'm happy` | `concept_happy` | Expressing cheerful feeling and joy |
| `concept_p2_im_tired` | `I'm tired` | `concept_tired` | Expressing need for rest or sleep |

### 3.3 New Conversation Repair Phrases
| Phrase ID | Canonical Text | Function | Meaning |
| :--- | :--- | :--- | :--- |
| `concept_p2_i_dont_know` | `I don't know` | Honest clarification | Polite statement when not knowing an answer |
| `concept_p2_i_dont_understand` | `I don't understand` | Comprehension repair | Polite repair phrase when speech is unclear |
| `concept_p2_say_it_again` | `please say it again` | Request repetition | Polite request for spoken repetition |

### 3.4 All 13 Conversation Functions (Complete Production Inventory)
| ID | Level | Intent | Pip Opening | Target Response | Follow-Up |
| :--- | :---: | :--- | :--- | :--- | :--- |
| `func_what_is_this` | L1 | askingClarification | "What is this?" | "An apple." | "Yes! It's a red apple! 🍎" |
| `func_who_is_this` | L1 | introducingOneself | "Who is this?" | "This is my mother." | "Yes! That's your mother! 😊" |
| `func_greeting_exchange` | L2 | greeting | "Assalamu Alaikum, explorer! How are you today?" | "Wa Alaikum Assalam! I'm fine, thank you!" | "Wonderful! Let's start our adventure today! 🌟" |
| `func_polite_request_food` | L3 | requesting | "Are you thirsty?" | "Can I have water, please?" | "Of course! Here you are! 💧" |
| `func_asking_for_help` | L3 | askingForHelp | "Do you need help with the blocks?" | "Can you help me, please?" | "Of course! Let's build together!" |
| `func_express_preferences` | L3 | answeringPreferenceQuestion | "What fruit do you like?" | "I like apples! I don't like lemons." | "Apples are sweet and crunchy! 🍏" |
| `func_conversation_repair` | L2 | askingClarification | "Can you arrange these blocks?" | "I don't understand. Please say it again." | "No problem at all! Let's listen once more." |
| `func_wants_needs` | L3 | requesting | "What do you need for reading?" | "I need my book." | "Here is your book! Now we are ready to read! 📖" |
| `func_location_query` | L2 | describing | "Where is the book?" | "The book is on the table." | "There it is! You found it! 🔍" |
| `func_color_query` | L2 | describing | "What color is this apple?" | "It is red." | "Spot on! A bright red apple! 🍎" |
| `func_quantity_query` | L2 | describing | "How many birds do you see?" | "Two birds." | "One, two! That is two birds! 🐥🐥" |
| `func_ability_query` | L3 | describing | "Can you read this word?" | "Yes, I can read." | "Nice reading! 📖" |
| `func_play_turns` | L2 | agreeing | "Let's play a fun game together!" | "My turn! Your turn!" | "Awesome! Go ahead, roll the dice! 🎲" |

### 3.5 Renamed Curriculum Unit Titles (8 Worlds)
| World | Unit ID | Level | Updated Title | Previous Literary Title |
| :--- | :--- | :---: | :--- | :--- |
| Family | `unit_family_basics` | L1 | **My Family** | Family & Home |
| Family | `unit_family_phrases` | L2 | **Family Words** | Loving Family Words |
| Home | `unit_home_living` | L1 | **My Home** | My Room & Tidy Habits |
| Home | `unit_home_routines` | L2 | **Helping at Home** | Helping at Home |
| Food | `unit_food_blessings_l1` | L1 | **Food & Drinks** | Delicious Treats & Pure Water |
| Food | `unit_food_blessings` | L3 | **Food & Drinks Practice** | Food & Blessings |
| Animals | `unit_animal_savannah` | L1 | **Meet the Animals** | Gentle Creatures of the Savannah |
| Animals | `unit_animal_phrases` | L2 | **Animals Around Us** | Big Lions & Little Birds |
| School | `unit_school_basics` | L1 | **At School** | School Tools & Books |
| School | `unit_classroom_tools` | L2 | **Classroom Tools** | Classroom Friends & Tools |
| Play | `unit_play_basics` | L1 | **Play with Friends** | Playtime & Friends |
| Play | `unit_play_friendship` | L2 | **Play & Taking Turns** | Play & Taking Turns |
| My Day | `unit_day_basics` | L1 | **My Day** | My Daily Habits |
| My Day | `unit_my_day_routines` | L3 | **Daily Routines** | My Daily Routine |
| Nature | `unit_nature_basics` | L1 | **Nature Around Us** | Sky, Sun & Trees |
| Nature | `unit_nature_creation` | L3 | **Wonders of Nature** | Wonders of Nature & Sky |

---

## 4. Product Owner Sign-Off Gate

Please review the content above and confirm final curriculum lock:

- [ ] **Scenario A (Water Request)**: Approved
- [ ] **Scenario B (Help Request)**: Approved
- [ ] **Scenario C (Age 9 Cat Definition & Tone)**: Approved
- [ ] **Scenario D (Conversation Repair)**: Approved
- [ ] **Scenario E (Food Request Progression)**: Approved
- [ ] **Scenario F (Authentic Islamic Greeting)**: Approved
- [ ] **13 Conversation Functions**: Approved
- [ ] **Unit Titles & Outcome Prerequisites**: Approved

**Current Status**: `CURRICULUM_LOCK_CANDIDATE`
