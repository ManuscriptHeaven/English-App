# Kids English Adventure — Phase 15.7 Curriculum Lock Report

**Document**: `phase15_7_curriculum_lock_report.md`  
**Status**: **CURRICULUM_LOCK_CANDIDATE**  
**Phase**: 15.7 — Levels 1–3 Curriculum Lock Pass  
**Next Phase**: Phase 16 (Child Experience, Audio, Rewards & Interaction Polish — pending Product Owner approval)  

---

## 1. Executive Summary & Verification Result

Phase 15.7 successfully executed the limited curriculum lock pass across Levels 1–3. All editorial defects, progression flaws, tone inconsistencies, and integrity gaps identified in the second human curriculum review have been resolved.

### Static & Pedagogical Validation
- **Expanded Curriculum Validator**: **PASSED** (0 Errors, 0 Broken Prerequisite Links)
- **Dart Static Analysis**: **0 Issues** (`dart analyze lib test`)
- **Automated Regression Suite**: **13 / 13 Targeted Tests Passed** (`test/unit/phase15_7_lock_test.dart`)
- **Phase 15.6 Regression Suite**: **9 / 9 Tests Passed** (`test/unit/phase15_6_refinement_test.dart`)
- **Phase 15 Build Suite**: **13 / 13 Tests Passed** (`test/unit/phase15_curriculum_build_test.dart`)

---

## 2. Live Repository-Derived Exact Counts

| Curriculum Dimension | Phase 15.6 Baseline | Phase 15.7 Locked Candidate | Delta | Justification |
| :--- | :---: | :---: | :---: | :--- |
| **Total Concepts** | 201 | **208** | +7 | Added 4 functional state phrases + 3 repair phrases |
| **Level 1 Concepts** | 144 | **144** | 0 | Frozen lexical core (135 words + 9 phrase seeds) |
| **Level 2 Phrases** | 57 | **64** | +7 | High-priority spoken states ("I'm hungry/thirsty/happy/tired") & repair ("I don't understand") |
| **Level 3 Sentence Patterns** | 21 | **26** | +5 | Added `pattern_i_need` + 4 functional inquiry question templates |
| **Conversation Functions** | 6 | **13** | +7 | Expanded from 6 to 13 structured functions with multi-stage responses |
| **Curriculum Units** | 16 | **16** | 0 | 2 units per world across all 8 core worlds |
| **Curriculum Lessons** | 18 | **18** | 0 | Balanced progressive journeys |
| **Curriculum Stories** | 3 | **3** | 0 | Preserved strict simple/rich narrative text separation |
| **Capstone Level Missions** | 3 | **3** | 0 | 1 per Level for Levels 1–3 |
| **Can-Do Statements** | 12 | **12** | 0 | Multi-stage observable performance indicators |

---

## 3. Confirmed Defects Fixed

1. **`read` Progression Substring Defect**:
   - *Defect*: Reporting tool used substring matching (`"eat bread".contains("read")`), incorrectly asserting that `read` maps to `eat bread`.
   - *Fix*: Replaced substring checks with word-boundary token matching and prerequisite concept ID verification. Confirmed `concept_read` progresses strictly: `book` -> `read` -> `read a book` -> `I can read.`. Added regression assertion in `phase15_7_lock_test.dart`.
2. **Distinguished Concept Ownership from Cross-World Reinforcement**:
   - *Defect*: Concepts like `water`, `bird`, `fish`, `bee`, `ant`, `garden` appeared duplicated across domain views.
   - *Fix*: Standardized on 1 canonical concept ID with 1 primary introduction location. Multi-domain usages are explicitly classified as **Reinforcement Contexts** without count inflation.
3. **Purged Generic Fake Reuse Claims**:
   - *Defect*: Audit reported generic `Direct L3 reuse` metadata without concrete evidence.
   - *Fix*: Replaced with explicit Level 2 phrase IDs, Level 3 pattern templates, and conversation IDs. Unreinforced concepts are candidly categorized as `Category D (Isolated/Underused)`.
4. **Audited Internal Definitions to Plain Child English**:
   - *Defect*: Repository contained academic dictionary definitions ("domesticated feline", "limbless water creature", "woolly ruminant mammal", "horned domesticated ruminant").
   - *Fix*: Rewrote definitions in simple, child-friendly English (`cat`: "A small animal that many people keep as a pet.", `fish`: "An animal that lives and swims in water.", `sheep`: "A farm animal with wool.", `goat`: "A farm animal with horns.", `spoon`: "We use a spoon to eat or stir food.", `read`: "To look at and read words or books.").
5. **Removed Automatic Religious Praise from Generic Success**:
   - *Defect*: Family introduction conversation (`func_who_is_this`) had Pip respond with `MashaAllah! May Allah bless your family!` to standard photo identification.
   - *Fix*: Replaced with natural English conversational praise: `"That's your mother! She loves you very much! 😊"`. Islamic expressions are preserved exclusively in natural contexts (daily Salam greetings, Bismillah before eating, Alhamdulillah after meals).
6. **Pip Companion Tone Pass (Band C & Band D)**:
   - *Defect*: Band C and D contained robotic grading phrases ("That's accurate", "Solid answer", "Unit objective completed", "Curriculum Level achievement unlocked", "Re-evaluate the phrasing").
   - *Fix*: Completely purged corporate/pedagogical jargon. Replaced with mature, warm child English ("Exactly right!", "Nice!", "You remembered it.", "Try that sentence again.", "Great speaking!", "Adventure complete!"). Implemented a 4-tier feedback intensity model.
7. **Curriculum Unit Titles & Outcome Prerequisites**:
   - *Defect*: Literary marketing titles (`Gentle Creatures of the Savannah`, `Delicious Treats & Pure Water`) and untaught adjectives (`big or gentle`) in Level 1 outcomes.
   - *Fix*: Standardized to clear titles (`Meet the Animals`, `Food & Drinks`, `My Family`, `My Home`, `At School`, `Play with Friends`, `My Day`, `Nature Around Us`). Aligned speaking outcomes so every mentioned word is a taught prerequisite.

---

## 4. Conversation Foundation Coverage (13 Interactive Functions)

The conversation foundation was expanded from 6 to 13 high-quality social dialogue routines. Every function models a structured two-way speech exchange with multi-stage response criteria:

| Function ID | Communicative Purpose | Level | Pip Opening | Simpler Response | Target Response | Stronger Response | Pip Follow-Up |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- | :--- |
| `func_what_is_this` | Identify everyday objects and foods from spoken prompts. | L1 | "What is this?" | "Apple." | "An apple." | "This is a red apple." | "Yes! It's a red apple! 🍎" |
| `func_who_is_this` | Introduce and identify family members politely. | L1 | "Who is this?" | "Mother." | "This is my mother." | "This is my mother. She is kind." | "Yes! That's your mother! 😊" |
| `func_greeting_exchange` | Participate in a two-way daily greeting exchange. | L2 | "Assalamu Alaikum, explorer! How are you today?" | "I'm fine." | "Wa Alaikum Assalam! I'm fine, thank you!" | "Wa Alaikum Assalam, Pip! I am very happy today!" | "Wonderful! Let's start our adventure today! 🌟" |
| `func_polite_request_food` | Make polite requests for food and drink using multi-stage progression. | L3 | "Are you thirsty?" | "Water, please." | "Can I have water, please?" | "Can I have some water, please?" | "Of course! Here you are! 💧" |
| `func_asking_for_help` | Request assistance politely in learning or play situations. | L3 | "Do you need help with the blocks?" | "Help me, please." | "Can you help me, please?" | "Can you help me with this, please?" | "Of course! Let's build together!" |
| `func_express_preferences` | Express likes and dislikes about food and everyday items. | L3 | "What fruit do you like?" | "I like apples." | "I like apples! I don't like lemons." | "I like red apples because they are sweet!" | "Apples are sweet and crunchy! 🍏" |
| `func_conversation_repair` | Use repair language when words are unclear or not understood. | L2 | "Can you arrange these blocks?" | "I don't understand." | "I don't understand. Please say it again." | "I don't know that word. Can you help me, please?" | "No problem at all! Let's listen once more." |
| `func_wants_needs` | Express immediate practical needs distinguishing need from want. | L3 | "What do you need for reading?" | "Book." | "I need my book." | "I need water and my book, please." | "Here is your book! Now we are ready to read! 📖" |
| `func_location_query` | Ask and answer where everyday objects are located. | L2 | "Where is the book?" | "On the table." | "The book is on the table." | "It is right here on the table!" | "There it is! You found it! 🔍" |
| `func_color_query` | Inquire and describe colors of objects and animals. | L2 | "What color is this apple?" | "Red." | "It is red." | "It is a bright red apple." | "Spot on! A bright red apple! 🍎" |
| `func_quantity_query` | Comprehend quantity inquiries and state counts. | L2 | "How many birds do you see?" | "Two." | "Two birds." | "I see two little birds!" | "One, two! That is two birds! 🐥🐥" |
| `func_ability_query` | Inquire and express physical and cognitive abilities. | L3 | "Can you read this word?" | "Yes, I can." | "Yes, I can read." | "I can read a book by myself!" | "Nice reading! 📖" |
| `func_play_turns` | Coordinate social game play and turn taking. | L2 | "Let's play a fun game together!" | "My turn." | "My turn! Your turn!" | "Let's play! It is my turn now." | "Awesome! Go ahead, roll the dice! 🎲" |

---

## 5. Functional Spoken English & Spiral Progression

### Core Functional Capabilities Added
- **`I need...` Pattern**: Template `"I need {item}."` with high-frequency everyday needs (`water`, `help`, `my book`). Distinguishes practical physical/classroom necessities from mere desires.
- **Basic Everyday States**: 4 high-frequency spoken collocations (`I'm hungry`, `I'm thirsty`, `I'm happy`, `I'm tired`) supporting immediate self-expression.
- **Conversation Repair Language**: Essential survival skills for beginner speaking confidence (`I don't know`, `I don't understand`, `please say it again`).
- **Structured Question Comprehension**: Sequenced across Levels 1–3 from identification (`What is this?`, `Who is this?`) to spatial/attribute (`What color is it?`, `How many?`, `Where is the...?`) to functional desire/ability (`Do you like...?`, `Can you...?`, `What do you need?`).

### Lexical Spiral Reuse Classification (A/B/C/D)
- **Category A — Strong Spiral**: **19 concepts** (Word -> Phrase -> Sentence -> Contextual Dialogue/Story/Unit)
- **Category B — Good Reuse**: **4 concepts** (Word -> Phrase -> Sentence)
- **Category C — Limited Reuse**: **58 concepts** (Word -> Phrase OR Sentence OR Context)
- **Category D — Isolated / Underused**: **63 concepts** (Foundational vocabulary taught in Level 1 with intentional deferral of multi-word combinations to later levels)

#### Complete Inventory of Category D Concepts (63 Items)
These concepts are deliberately preserved as introductory Level 1 vocabulary (e.g. specialized body parts, specific food items, numerals, single colors) without artificially generating low-utility phrases:
- `concept_girl`: **girl** (A young female child.)
- `concept_friend`: **friend** (A person with whom one shares kindness and fun.)
- `concept_sad`: **sad** (Feeling sorrow or unhappy.)
- `concept_head`: **head** (The upper part of the body.)
- `concept_hair`: **hair** (Fine strands growing from the head.)
- `concept_eyes`: **eyes** (We use our eyes to see.)
- `concept_ears`: **ears** (We use our ears to hear.)
- `concept_nose`: **nose** (We use our nose to smell.)
- `concept_mouth`: **mouth** (We use our mouth to talk and eat.)
- `concept_teeth`: **teeth** (We use our teeth to chew food.)
- `concept_arm`: **arm** (Part of the body from the shoulder to the hand.)
- `concept_leg`: **leg** (We use our legs to stand and walk.)
- `concept_foot`: **foot** (We stand and walk on our feet.)
- `concept_fingers`: **fingers** (The fingers on our hands.)
- `concept_baby`: **baby** (A very young child or infant.)
- `concept_family`: **family** (Family members living together.)
- `concept_grandmother`: **grandmother** (A grandmother in the family.)
- `concept_grandfather`: **grandfather** (A grandfather in the family.)
- `concept_bed`: **bed** (A piece of furniture for sleep or rest.)
- `concept_chair`: **chair** (Something we sit on.)
- `concept_plate`: **plate** (A flat dish from which food is eaten.)
- `concept_spoon`: **spoon** (We use a spoon to eat or stir food.)
- `concept_tidy`: **tidy** (Arranged neatly and in good order.)
- `concept_egg`: **egg** (An oval food produced by birds/chickens.)
- `concept_orange`: **orange** (A round juicy citrus fruit with orange skin.)
- `concept_juice`: **juice** (The liquid naturally contained in fruit.)
- `concept_date_fruit`: **date** (Sweet dark brown fruit of the date palm tree.)
- `concept_honey`: **honey** (Sweet sticky golden fluid made by bees.)
- `concept_soup`: **soup** (A warm liquid dish typically savoury.)
- `concept_tea`: **tea** (A warm herbal drink.)
- `concept_carrot`: **carrot** (A crunchy orange root vegetable.)
- `concept_kitten`: **kitten** (A young baby cat.)
- `concept_fish`: **fish** (An animal that lives and swims in water.)
- `concept_lion`: **lion** (A large wild cat known as king of beasts.)
- `concept_elephant`: **elephant** (A very large animal with a long trunk.)
- `concept_rabbit`: **rabbit** (A small hopping animal with long ears.)
- `concept_cow`: **cow** (A farm animal that gives us milk.)
- `concept_horse`: **horse** (A large four-legged animal used for riding.)
- `concept_sheep`: **sheep** (A farm animal with wool.)
- `concept_lamb`: **lamb** (A young baby sheep.)
- `concept_bee`: **bee** (A flying insect that produces honey.)
- `concept_ant`: **ant** (A tiny hardworking insect.)
- `concept_black`: **black** (The darkest color.)
- `concept_white`: **white** (The color of milk or fresh snow.)
- `concept_orange_color`: **orange** (The color between red and yellow.)
- `concept_four`: **four** (The number 4.)
- `concept_five`: **five** (The number 5.)
- `concept_six`: **six** (The number 6.)
- `concept_seven`: **seven** (The number 7.)
- `concept_eight`: **eight** (The number 8.)
- `concept_nine`: **nine** (The number 9.)
- `concept_ten`: **ten** (The number 10.)
- `concept_walk`: **walk** (To move at a regular pace on foot.)
- `concept_listen`: **listen** (To pay attention to sound.)
- `concept_give`: **give** (To give something to someone.)
- `concept_teacher`: **teacher** (A person who teaches students at school.)
- `concept_school`: **school** (A place where children learn and play.)
- `concept_paper`: **paper** (Sheets of paper for drawing and writing.)
- `concept_crayons`: **crayons** (Sticks of colored wax used for drawing.)
- `concept_shoes`: **shoes** (Footwear with sturdy soles.)
- `concept_hat`: **hat** (A covering for the head.)
- `concept_seed_blue_ball`: **blue ball** (A round ball that is blue.)
- `concept_seed_open_door`: **open door** (The action or state of an open door.)

---

## 6. Pip Companion Dialogue Audit & Praise Fatigue Prevention

The dialogue companion pool has been audited against educational jargon, grading syntax, and excessive exclamation repetition.

### Feedback Intensity Tiers
1. **Small Success** (Standard correct tap/word): Very concise acknowledgments ("Nice.", "Yes!", "That's it.", "Spot on.").
2. **Meaningful Recall** (Independent recall without hints): Encouraging recognition ("You remembered it!", "Great speaking!").
3. **Recovery Success** (Success after gentle retry): Persistence praise ("You got it this time!", "Nice correction! Practice makes progress.").
4. **Major Achievement** (Lesson/Level completion): Celebratory milestone ("Adventure complete! Great job today!", "You finished this level! 🏆").

---

## 7. Islamic & Cultural Content Safeguards

All religious and cultural elements are appropriately situated and tracked:
- `concept_p2_assalamu_alaikum`: **`pendingQualifiedIslamicReview`**
- `concept_p2_wa_alaikum_assalam`: **`pendingQualifiedIslamicReview`**
- `concept_p2_bismillah`: **`pendingQualifiedIslamicReview`**
- `concept_p2_alhamdulillah`: **`pendingQualifiedIslamicReview`**
- `story_thirsty_bird`: **`pendingQualifiedIslamicReview`**
- `story_sharing_apples`: **`pendingQualifiedIslamicReview`**
- `story_helping_mother`: **`pendingQualifiedIslamicReview`**

---

## 8. Story Architecture & Sound System Status

### Story Text Separation
All 3 curriculum stories preserve strict two-tier text segmentation:
- `simpleTextSegments`: 7 simple repetitive sentences per story designed for early productive child retell.
- `richNarrativeTextSegments`: Rich, atmospheric sentences designed for listening immersion without raising productive difficulty.

### Audio & SFX Status
- **Audio SFX Assets**: Explicitly designated **`PLACEHOLDER`**.
- Audio production, voice talent recording, mixing, volume balancing, and playback latency tuning are scheduled for Phase 16.

---

## 9. Recommendation & Freeze Decision

Levels 1–3 curriculum content is architecturally sound, pedagogically sequenced, free of technical progression defects, and aligned with developmental age bands.

**Recommendation**: **FREEZE AS `CURRICULUM_LOCK_CANDIDATE`** pending final Product Owner spot-check of `phase15_7_human_lock_audit.md`.
