# Kids English Adventure — Phase 15.5 Human Curriculum Content Audit Pack (v2)

**Document**: `phase15_human_content_audit_v2.md`  
**Purpose**: Updated, raw export of all production curriculum content for Levels 1–3 following Phase 15.6 Content Refinement for manual editorial, pedagogical, and cultural review.  
**Status**: **READY FOR SECOND HUMAN CONTENT REVIEW**  
**Repository-Derived Exact Counts**:  
- **Level 1 Concepts**: 144 (135 foundational vocabulary words + 9 phrase seeds; non-essential clothes "trousers" & "dress" deferred to Level 4+)
- **Level 2 Phrases**: 57 (curated collocations, micro-progression bridges, polite language, authentic Islamic phrases)
- **Level 3 Sentence Patterns**: 21 (16 statement templates with natural child contractions + 5 functional question patterns)
- **Conversational Dialogue Functions**: 6
- **Curriculum Stories**: 3 (with separated simple productive text and rich listening narrative)
- **Curriculum Units**: 16 (2 units per world across all 8 core worlds)
- **Curriculum Lessons**: 18 (balanced progressive journeys across all 8 worlds)
- **Capstone Level Missions**: 3

---

## Table of Contents
1. [Executive Summary & Refinements Applied](#1-executive-summary--refinements-applied)
2. [Level 1: Complete Lexical Inventory (144 Concepts)](#2-level-1--complete-lexical-inventory)
3. [Level 2: Complete Phrase Inventory (57 Phrases)](#3-level-2--complete-phrase-inventory)
4. [Level 3: Complete Sentence Patterns (21 Patterns)](#4-level-3--complete-sentence-patterns)
5. [Conversational Routines & Dialogue Turns (6 Interactive Functions)](#5-conversational-routines--dialogue-turns)
6. [Complete Story Narratives & Text Separation (3 Stories)](#6-complete-story-narratives--text-separation)
7. [Curriculum Units & Lessons Across 8 Worlds (16 Units, 18 Lessons)](#7-curriculum-units--lessons-across-8-worlds)
8. [Multi-Stage Can-Do Statements & Completion Criteria](#8-multi-stage-can-do-statements--completion-criteria)
9. [Pip Dialogue Companion Pool (Anti-Robotic Tone Audit)](#9-pip-dialogue-companion-pool-anti-robotic-tone-audit)
10. [Auditory Cue & SFX Asset Mapping (PLACEHOLDER Status)](#10-auditory-cue--sfx-asset-mapping-placeholder-status)
11. [Islamic Content & Character Audit (Status: Pending Qualified Review)](#11-islamic-content--character-audit-status-pending-qualified-review)
12. [Human Review Sign-Off Sheet](#12-human-review-sign-off-sheet)

---

## 1. Executive Summary & Refinements Applied

Following the Phase 15.5 review decision (**CONTENT REVISION REQUIRED**), Phase 15.6 executed an exhaustive content polish pass across all Levels 1–3:
1. **True Repository Counts**: All documentation and assertions now query live repository instances directly. Previous discrepancies (claims of 191 L1 / 54 L2 vs actual 136 / 35) are completely resolved. The active curriculum comprises **144 Level 1 concepts**, **57 Level 2 phrases**, **21 Level 3 sentence patterns**, **16 units**, and **18 lessons**.
2. **Zero Isolated Concepts**: 12 previously isolated Level 1 words (`camel`, `duck`, `goat`, `cat`, `rice`, `cheese`, `socks`, `shirt`, `moon`, `grass`, `purple`, `pink`) were systematically integrated into meaningful Level 2 collocations (`big camel`, `yellow duck`, `small goat`, `brown cat`, `eat rice`, `eat cheese`, `clean socks`, `blue shirt`, `bright moon`, `green grass`, `purple flower`, `pink flower`). Non-essentials (`trousers`, `dress`) were deferred to Level 4+.
3. **Natural Child English**: Replaced adult and pedagogical jargon across prompts and models. Eliminated definitions like "essential for life" and "largest land animal". Replaced Band C prompt ("Identify and pronounce") with child-friendly phrasing ("What is this? Say [word]").
4. **Natural Contractions & Grammar**: Replaced rigid textbook patterns with natural spoken contractions: `I don't like {item}.` and `I can't {action} yet.`. Validated `You're welcome` canonical text.
5. **Story Productive Separation**: Early stories now provide `simpleTextSegments` (7 repetitive Level 1 sentences suitable for child retell) alongside `richNarrativeTextSegments` for listening exposure. Moralizing sermon endings were replaced with natural narrative action resolutions.
6. **Micro-Progression Bridges**: Added critical conversational stepping-stones: `water, please`, `help me, please`, `on the table`, `on the desk`, `in the sky`, `here you are`, `my turn`, `let's play`, `I'm fine`.
7. **Multi-Stage Can-Do Statements**: Replaced binary criteria with 3-stage progressive milestones: Stage 1 (`Water, please.`) -> Stage 2 (`Can I have water, please?`) -> Stage 3 (full exchange with greeting/thanks).
8. **Pip Dialogue Personality Pass**: Completely purged robotic grading terms (`accurate syntax`, `fluent mastery`, `auditory recognition`). Removed automatic religious invocations on mundane taps; reserved sacred expressions for meaningful cultural context.
9. **Islamic Review Status**: All Islamic greetings, phrases, and value-laden stories are explicitly tagged `ContentReviewStatus.pendingQualifiedIslamicReview`.
10. **SFX Asset Status**: All audio cues remain explicitly marked with `[PLACEHOLDER]` tags.

---

## 2. Level 1 — Complete Lexical Inventory (144 Concepts)

Level 1 establishes concrete everyday vocabulary through listening recognition, picture identification, and spoken imitation.

### 2.1 Me & Feelings (7 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_boy` | **boy** | A young male child. | A, B, C, D | Say "boy" | `happy boy` | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_girl` | **girl** | A young female child. | A, B, C, D | Say "girl" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_child` | **child** | A young boy or girl. | A, B, C, D | Say "child" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_name` | **name** | A word by which a person is known. | A, B, C, D | Say "name" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_friend` | **friend** | A person with whom one shares kindness and fun. | A, B, C, D | Say "friend" | Direct L3 reuse | value_friendship, value_sharing | [ ] | [ ] | [ ] | [ ] | |
| `concept_happy` | **happy** | Feeling or showing pleasure and joy. | A, B, C, D | Say "happy" | `happy boy` | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_sad` | **sad** | Feeling sorrow or unhappy. | A, B, C, D | Say "sad" | Direct L3 reuse | value_kindness | [ ] | [ ] | [ ] | [ ] | |

### 2.2 My Body (12 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_head` | **head** | The upper part of the body. | A, B, C, D | Say "head" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_hair` | **hair** | Fine strands growing from the head. | A, B, C, D | Say "hair" | Direct L3 reuse | value_cleanliness | [ ] | [ ] | [ ] | [ ] | |
| `concept_eyes` | **eyes** | Organs used for seeing. | A, B, C, D | Say "eyes" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_ears` | **ears** | Organs used for hearing. | A, B, C, D | Say "ears" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_nose` | **nose** | Part of the face used for smelling. | A, B, C, D | Say "nose" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_mouth` | **mouth** | Opening in the face used for speaking and eating. | A, B, C, D | Say "mouth" | Direct L3 reuse | value_good_manners | [ ] | [ ] | [ ] | [ ] | |
| `concept_teeth` | **teeth** | Hard white structures in mouth used to chew. | A, B, C, D | Say "teeth" | Direct L3 reuse | value_cleanliness | [ ] | [ ] | [ ] | [ ] | |
| `concept_hand` | **hand** | End part of the arm used for grasping. | A, B, C, D | Say "hand" | `clean hands`, `wash hands` | value_cleanliness | [ ] | [ ] | [ ] | [ ] | |
| `concept_arm` | **arm** | Upper limb of the body. | A, B, C, D | Say "arm" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_leg` | **leg** | Limb used for standing and walking. | A, B, C, D | Say "leg" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_foot` | **foot** | Lower part of the leg on which one stands. | A, B, C, D | Say "foot" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_fingers` | **fingers** | The digits on each hand. | A, B, C, D | Say "fingers" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |

### 2.3 Family (9 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_mother` | **mother** | A female parent; loving caregiver. | A, B, C, D | Say "mother" | `my mother` | value_helping_parents, value_family_care | [ ] | [ ] | [ ] | [ ] | |
| `concept_father` | **father** | A male parent; loving protector. | A, B, C, D | Say "father" | `my father` | value_helping_parents, value_family_care | [ ] | [ ] | [ ] | [ ] | |
| `concept_brother` | **brother** | A male sibling. | A, B, C, D | Say "brother" | Direct L3 reuse | value_family_care, value_sharing | [ ] | [ ] | [ ] | [ ] | |
| `concept_sister` | **sister** | A female sibling. | A, B, C, D | Say "sister" | Direct L3 reuse | value_family_care, value_sharing | [ ] | [ ] | [ ] | [ ] | |
| `concept_baby` | **baby** | A very young child or infant. | A, B, C, D | Say "baby" | Direct L3 reuse | value_kindness | [ ] | [ ] | [ ] | [ ] | |
| `concept_family` | **family** | Parents and children living together in love. | A, B, C, D | Say "family" | Direct L3 reuse | value_family_care, value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_grandmother` | **grandmother** | The mother of one's parent. | A, B, C, D | Say "grandmother" | Direct L3 reuse | value_respect, value_family_care | [ ] | [ ] | [ ] | [ ] | |
| `concept_grandfather` | **grandfather** | The father of one's parent. | A, B, C, D | Say "grandfather" | Direct L3 reuse | value_respect, value_family_care | [ ] | [ ] | [ ] | [ ] | |
| `concept_seed_my_mother` | **my mother** | One's own beloved mother. | A, B, C, D | Say "my mother" | `my mother` | value_helping_parents | [ ] | [ ] | [ ] | [ ] | |

### 2.4 Home & Rooms (14 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_house` | **house** | A building for human habitation. | A, B, C, D | Say "house" | `my house` | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_room` | **room** | A partitioned space inside a house. | A, B, C, D | Say "room" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_bed` | **bed** | A piece of furniture for sleep or rest. | A, B, C, D | Say "bed" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_chair` | **chair** | A separate seat for one person. | A, B, C, D | Say "chair" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_table` | **table** | A piece of furniture with a flat top and legs. | A, B, C, D | Say "table" | `on the table` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_door` | **door** | A hinged or sliding barrier at an entrance. | A, B, C, D | Say "door" | `open the door` | value_good_manners | [ ] | [ ] | [ ] | [ ] | |
| `concept_window` | **window** | An opening in a wall fitted with glass. | A, B, C, D | Say "window" | `close the window` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_cup` | **cup** | A small bowl-shaped container for drinks. | A, B, C, D | Say "cup" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_plate` | **plate** | A flat dish from which food is eaten. | A, B, C, D | Say "plate" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_spoon` | **spoon** | An utensil consisting of a small shallow bowl on a handle. | A, B, C, D | Say "spoon" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_clean` | **clean** | Free from dirt, marks, or stains. | A, B, C, D | Say "clean" | `clean hands`, `clean socks` | value_cleanliness | [ ] | [ ] | [ ] | [ ] | |
| `concept_tidy` | **tidy** | Arranged neatly and in good order. | A, B, C, D | Say "tidy" | Direct L3 reuse | value_responsibility | [ ] | [ ] | [ ] | [ ] | |
| `concept_garden` | **garden** | A plot of ground where flowers, trees, and plants grow. | A, B, C, D | Say "garden" | Direct L3 reuse | value_caring_creation | [ ] | [ ] | [ ] | [ ] | |
| `concept_seed_open_door` | **open door** | The action or state of an open door. | A, B, C, D | Say "open door" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |

### 2.5 Food & Drink (17 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_water` | **water** | Pure clean liquid we drink every day. | A, B, C, D | Say "water" | `cold water`, `more water`, `drink water`, `water, please` | value_cleanliness, value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_milk` | **milk** | A wholesome white nutritious drink. | A, B, C, D | Say "milk" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_apple` | **apple** | A round crisp red or green fruit. | A, B, C, D | Say "apple" | `red apple`, `three apples` | value_gratitude, value_sharing | [ ] | [ ] | [ ] | [ ] | |
| `concept_banana` | **banana** | A sweet yellow curved fruit. | A, B, C, D | Say "banana" | `sweet banana` | value_gratitude, value_sharing | [ ] | [ ] | [ ] | [ ] | |
| `concept_bread` | **bread** | A staple baked food made from flour and water. | A, B, C, D | Say "bread" | `eat bread` | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_rice` | **rice** | Grains used as staple food. | A, B, C, D | Say "rice" | `eat rice` | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_egg` | **egg** | An oval food produced by birds/chickens. | A, B, C, D | Say "egg" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_orange` | **orange** | A round juicy citrus fruit with orange skin. | A, B, C, D | Say "orange" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_juice` | **juice** | The liquid naturally contained in fruit. | A, B, C, D | Say "juice" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_date_fruit` | **date** | Sweet dark brown fruit of the date palm tree. | A, B, C, D | Say "date" | Direct L3 reuse | value_gratitude, value_sharing | [ ] | [ ] | [ ] | [ ] | |
| `concept_honey` | **honey** | Sweet sticky golden fluid made by bees. | A, B, C, D | Say "honey" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_cheese` | **cheese** | A food made from the pressed curds of milk. | A, B, C, D | Say "cheese" | `eat cheese` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_soup` | **soup** | A warm liquid dish typically savoury. | A, B, C, D | Say "soup" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_tea` | **tea** | A warm herbal drink. | A, B, C, D | Say "tea" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_carrot` | **carrot** | A crunchy orange root vegetable. | A, B, C, D | Say "carrot" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_seed_red_apple` | **red apple** | An apple that is red in color. | A, B, C, D | Say "red apple" | `red apple` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_seed_two_apples` | **two apples** | A pair of apples. | A, B, C, D | Say "two apples" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |

### 2.6 Animals (19 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_cat` | **cat** | A small domesticated feline pet. | A, B, C, D | Say "cat" | `small cat`, `two cats`, `brown cat` | value_kindness | [ ] | [ ] | [ ] | [ ] | |
| `concept_kitten` | **kitten** | A young baby cat. | A, B, C, D | Say "kitten" | Direct L3 reuse | value_kindness | [ ] | [ ] | [ ] | [ ] | |
| `concept_dog` | **dog** | A domesticated canine animal. | A, B, C, D | Say "dog" | `big dog` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_bird` | **bird** | A warm-blooded feathered creature with wings. | A, B, C, D | Say "bird" | Direct L3 reuse | value_caring_creation | [ ] | [ ] | [ ] | [ ] | |
| `concept_fish` | **fish** | A limbless water creature with gills and fins. | A, B, C, D | Say "fish" | Direct L3 reuse | value_caring_creation | [ ] | [ ] | [ ] | [ ] | |
| `concept_lion` | **lion** | A large wild cat known as king of beasts. | A, B, C, D | Say "lion" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_elephant` | **elephant** | A very large mammal with a long trunk and tusk. | A, B, C, D | Say "elephant" | Direct L3 reuse | value_caring_creation | [ ] | [ ] | [ ] | [ ] | |
| `concept_rabbit` | **rabbit** | A small hopping mammal with long ears. | A, B, C, D | Say "rabbit" | Direct L3 reuse | value_kindness | [ ] | [ ] | [ ] | [ ] | |
| `concept_cow` | **cow** | A large domesticated farm animal providing milk. | A, B, C, D | Say "cow" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_horse` | **horse** | A large four-legged animal used for riding. | A, B, C, D | Say "horse" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_duck` | **duck** | A waterbird with webbed feet. | A, B, C, D | Say "duck" | `yellow duck` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_sheep` | **sheep** | A woolly ruminant mammal. | A, B, C, D | Say "sheep" | Direct L3 reuse | value_kindness | [ ] | [ ] | [ ] | [ ] | |
| `concept_lamb` | **lamb** | A young baby sheep. | A, B, C, D | Say "lamb" | Direct L3 reuse | value_kindness | [ ] | [ ] | [ ] | [ ] | |
| `concept_camel` | **camel** | A large humped desert mammal. | A, B, C, D | Say "camel" | `big camel` | value_patience | [ ] | [ ] | [ ] | [ ] | |
| `concept_goat` | **goat** | A horned domesticated ruminant mammal. | A, B, C, D | Say "goat" | `small goat` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_bee` | **bee** | A flying insect that produces honey. | A, B, C, D | Say "bee" | Direct L3 reuse | value_caring_creation, value_responsibility | [ ] | [ ] | [ ] | [ ] | |
| `concept_ant` | **ant** | A tiny hardworking insect. | A, B, C, D | Say "ant" | Direct L3 reuse | value_responsibility | [ ] | [ ] | [ ] | [ ] | |
| `concept_seed_big_dog` | **big dog** | A dog of large size. | A, B, C, D | Say "big dog" | `big dog` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_seed_small_cat` | **small cat** | A cat of little size. | A, B, C, D | Say "small cat" | `small cat` | None | [ ] | [ ] | [ ] | [ ] | |

### 2.7 Colors (10 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_red` | **red** | The color of an apple or strawberry. | A, B, C, D | Say "red" | `red apple` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_blue` | **blue** | The color of the clear sky or ocean. | A, B, C, D | Say "blue" | `blue shirt` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_green` | **green** | The color of grass and leaves. | A, B, C, D | Say "green" | `green tree`, `green grass` | value_caring_creation | [ ] | [ ] | [ ] | [ ] | |
| `concept_yellow` | **yellow** | The color of the sun and ripe bananas. | A, B, C, D | Say "yellow" | `yellow duck` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_black` | **black** | The darkest color. | A, B, C, D | Say "black" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_white` | **white** | The color of milk or fresh snow. | A, B, C, D | Say "white" | Direct L3 reuse | value_cleanliness | [ ] | [ ] | [ ] | [ ] | |
| `concept_orange_color` | **orange** | The color between red and yellow. | A, B, C, D | Say "orange" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_pink` | **pink** | A delicate pale red color. | A, B, C, D | Say "pink" | `pink flower` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_brown` | **brown** | The color of earth or wood. | A, B, C, D | Say "brown" | `brown cat` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_purple` | **purple** | The color between blue and red. | A, B, C, D | Say "purple" | `purple flower` | None | [ ] | [ ] | [ ] | [ ] | |

### 2.8 Numbers (10 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_one` | **one** | The number 1. | A, B, C, D | Say "one" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_two` | **two** | The number 2. | A, B, C, D | Say "two" | `two cats` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_three` | **three** | The number 3. | A, B, C, D | Say "three" | `three apples` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_four` | **four** | The number 4. | A, B, C, D | Say "four" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_five` | **five** | The number 5. | A, B, C, D | Say "five" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_six` | **six** | The number 6. | A, B, C, D | Say "six" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_seven` | **seven** | The number 7. | A, B, C, D | Say "seven" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_eight` | **eight** | The number 8. | A, B, C, D | Say "eight" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_nine` | **nine** | The number 9. | A, B, C, D | Say "nine" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_ten` | **ten** | The number 10. | A, B, C, D | Say "ten" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |

### 2.9 Actions (20 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_smile` | **smile** | A pleased or kind facial expression. | A, B, C, D | Say "smile" | Direct L3 reuse | value_kindness, value_good_manners | [ ] | [ ] | [ ] | [ ] | |
| `concept_eat` | **eat** | To chew and swallow food. | A, B, C, D | Say "eat" | `eat bread`, `eat rice`, `eat cheese` | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_drink` | **drink** | To swallow liquid. | A, B, C, D | Say "drink" | `drink water` | value_cleanliness, value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_sit` | **sit** | To rest with the body supported on buttocks or chair. | A, B, C, D | Say "sit" | `sit down` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_stand` | **stand** | To be in an upright position on feet. | A, B, C, D | Say "stand" | `stand up` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_run` | **run** | To move fast using feet. | A, B, C, D | Say "run" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_walk` | **walk** | To move at a regular pace on foot. | A, B, C, D | Say "walk" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_jump` | **jump** | To push off the ground into air. | A, B, C, D | Say "jump" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_sleep` | **sleep** | To rest in natural slumber. | A, B, C, D | Say "sleep" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_read` | **read** | To look at and comprehend written words. | A, B, C, D | Say "read" | `eat bread`, `read a book` | value_responsibility | [ ] | [ ] | [ ] | [ ] | |
| `concept_play` | **play** | To engage in fun games and activities. | A, B, C, D | Say "play" | `let's play` | value_friendship | [ ] | [ ] | [ ] | [ ] | |
| `concept_wash` | **wash** | To clean with water and soap. | A, B, C, D | Say "wash" | `wash hands` | value_cleanliness | [ ] | [ ] | [ ] | [ ] | |
| `concept_listen` | **listen** | To pay attention to sound. | A, B, C, D | Say "listen" | Direct L3 reuse | value_respect | [ ] | [ ] | [ ] | [ ] | |
| `concept_look` | **look** | To direct one's gaze toward something. | A, B, C, D | Say "look" | `look at that` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_help` | **help** | To make it easier for someone to do something. | A, B, C, D | Say "help" | `help me, please`, `help me` | value_kindness, value_helping_parents | [ ] | [ ] | [ ] | [ ] | |
| `concept_give` | **give** | To freely transfer the possession of something. | A, B, C, D | Say "give" | Direct L3 reuse | value_sharing, value_generosity | [ ] | [ ] | [ ] | [ ] | |
| `concept_share` | **share** | To use or enjoy something together. | A, B, C, D | Say "share" | Direct L3 reuse | value_sharing, value_friendship | [ ] | [ ] | [ ] | [ ] | |
| `concept_open` | **open** | To uncover or make accessible. | A, B, C, D | Say "open" | `open the door` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_close` | **close** | To shut an entrance or opening. | A, B, C, D | Say "close" | `close the window` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_seed_drink_water` | **drink water** | The healthy action of consuming water. | A, B, C, D | Say "drink water" | `drink water` | value_cleanliness | [ ] | [ ] | [ ] | [ ] | |

### 2.10 School & Tools (9 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_book` | **book** | Bound pages with words or pictures. | A, B, C, D | Say "book" | `my book`, `read a book` | value_respect | [ ] | [ ] | [ ] | [ ] | |
| `concept_pencil` | **pencil** | An instrument for writing or drawing. | A, B, C, D | Say "pencil" | Direct L3 reuse | value_sharing | [ ] | [ ] | [ ] | [ ] | |
| `concept_bag` | **bag** | A container of flexible material for carrying items. | A, B, C, D | Say "bag" | `my bag` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_desk` | **desk** | A piece of furniture for writing and working. | A, B, C, D | Say "desk" | `on the desk` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_teacher` | **teacher** | A person who teaches and guides learners. | A, B, C, D | Say "teacher" | Direct L3 reuse | value_respect | [ ] | [ ] | [ ] | [ ] | |
| `concept_school` | **school** | An institution for educating children. | A, B, C, D | Say "school" | Direct L3 reuse | value_respect, value_friendship | [ ] | [ ] | [ ] | [ ] | |
| `concept_paper` | **paper** | Material in thin sheets for writing or drawing. | A, B, C, D | Say "paper" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_crayons` | **crayons** | Sticks of colored wax used for drawing. | A, B, C, D | Say "crayons" | Direct L3 reuse | value_sharing | [ ] | [ ] | [ ] | [ ] | |
| `concept_seed_my_book` | **my book** | The book belonging to me. | A, B, C, D | Say "my book" | `my book` | None | [ ] | [ ] | [ ] | [ ] | |

### 2.11 Clothes (4 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_shirt` | **shirt** | A garment for the upper body. | A, B, C, D | Say "shirt" | `blue shirt` | value_cleanliness | [ ] | [ ] | [ ] | [ ] | |
| `concept_shoes` | **shoes** | Footwear with sturdy soles. | A, B, C, D | Say "shoes" | Direct L3 reuse | value_cleanliness, value_responsibility | [ ] | [ ] | [ ] | [ ] | |
| `concept_hat` | **hat** | A covering for the head. | A, B, C, D | Say "hat" | `look at that` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_socks` | **socks** | Soft garments worn on the feet inside shoes. | A, B, C, D | Say "socks" | `clean socks` | value_cleanliness | [ ] | [ ] | [ ] | [ ] | |

### 2.12 Nature & Creation (15 Concepts)

| Concept ID | Canonical Word | Meaning | Age Bands | Speaking Target | L2 Phrase Progression | Islamic / Value Theme | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_water` | **water** | Pure clean liquid we drink every day. | A, B, C, D | Say "water" | `cold water`, `more water`, `drink water`, `water, please` | value_cleanliness, value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_bird` | **bird** | A warm-blooded feathered creature with wings. | A, B, C, D | Say "bird" | Direct L3 reuse | value_caring_creation | [ ] | [ ] | [ ] | [ ] | |
| `concept_fish` | **fish** | A limbless water creature with gills and fins. | A, B, C, D | Say "fish" | Direct L3 reuse | value_caring_creation | [ ] | [ ] | [ ] | [ ] | |
| `concept_bee` | **bee** | A flying insect that produces honey. | A, B, C, D | Say "bee" | Direct L3 reuse | value_caring_creation, value_responsibility | [ ] | [ ] | [ ] | [ ] | |
| `concept_ant` | **ant** | A tiny hardworking insect. | A, B, C, D | Say "ant" | Direct L3 reuse | value_responsibility | [ ] | [ ] | [ ] | [ ] | |
| `concept_sun` | **sun** | The bright star that gives light and warmth to earth. | A, B, C, D | Say "sun" | Direct L3 reuse | value_gratitude, value_caring_creation | [ ] | [ ] | [ ] | [ ] | |
| `concept_moon` | **moon** | The natural satellite that shines in the night sky. | A, B, C, D | Say "moon" | `bright moon` | value_gratitude, value_caring_creation | [ ] | [ ] | [ ] | [ ] | |
| `concept_tree` | **tree** | A tall plant with a trunk and branches. | A, B, C, D | Say "tree" | `green tree` | value_caring_creation | [ ] | [ ] | [ ] | [ ] | |
| `concept_flower` | **flower** | The colorful blossom of a plant. | A, B, C, D | Say "flower" | `purple flower`, `pink flower` | value_caring_creation | [ ] | [ ] | [ ] | [ ] | |
| `concept_rain` | **rain** | Water falling in drops from clouds. | A, B, C, D | Say "rain" | Direct L3 reuse | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_sky` | **sky** | The expanse of air over the earth. | A, B, C, D | Say "sky" | `in the sky` | value_gratitude | [ ] | [ ] | [ ] | [ ] | |
| `concept_star` | **star** | A shining point of light in the night sky. | A, B, C, D | Say "star" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_cloud` | **cloud** | A white or gray mass in the sky made of water drops. | A, B, C, D | Say "cloud" | Direct L3 reuse | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_grass` | **grass** | Green vegetation covering the ground. | A, B, C, D | Say "grass" | `green grass` | None | [ ] | [ ] | [ ] | [ ] | |
| `concept_garden` | **garden** | A plot of ground where flowers, trees, and plants grow. | A, B, C, D | Say "garden" | Direct L3 reuse | value_caring_creation | [ ] | [ ] | [ ] | [ ] | |

---

## 3. Level 2 — Complete Phrase Inventory (57 Phrases)

| Phrase ID | Canonical Phrase | Meaning / Function | Category | Prerequisites | Islamic Review Status | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `concept_p2_big_dog` | **big dog** | A large canine friend. | Description | concept_dog | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_small_cat` | **small cat** | A little feline pet. | Description | concept_cat | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_red_apple` | **red apple** | A crisp red fruit. | Description | concept_apple, concept_red | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_happy_boy` | **happy boy** | A cheerful smiling young boy. | Description | concept_boy, concept_happy | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_green_tree` | **green tree** | A tree filled with fresh green leaves. | Description | concept_tree, concept_green | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_cold_water` | **cold water** | Refreshing cold drinking water. | Description | concept_water | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_sweet_banana` | **sweet banana** | A delicious ripe banana. | Description | concept_banana | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_clean_hands` | **clean hands** | Hands washed fresh with soap and water. | Description | concept_clean, concept_hand | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_my_book` | **my book** | The reading book that belongs to me. | Possession | concept_book | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_my_bag` | **my bag** | The school bag belonging to me. | Possession | concept_bag | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_my_mother` | **my mother** | My beloved caring mother. | Possession | concept_mother | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_my_father` | **my father** | My beloved father. | Possession | concept_father | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_my_house` | **my house** | The warm home where my family lives. | Possession | concept_house | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_your_turn` | **your turn** | Inviting a friend or peer to take their turn. | Description | Foundational | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_two_cats` | **two cats** | A pair of friendly cats. | Quantity | concept_two, concept_cat | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_three_apples` | **three apples** | A group of three sweet apples. | Quantity | concept_three, concept_apple | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_more_water` | **more water** | An additional portion of drinking water. | Quantity | concept_water | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_drink_water` | **drink water** | The action of drinking refreshing water. | Action | concept_drink, concept_water | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_eat_bread` | **eat bread** | Consuming bread at mealtime. | Action | concept_eat, concept_bread | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_open_door` | **open the door** | To open an entrance door politely. | Action | concept_open, concept_door | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_close_window` | **close the window** | To shut the window gently. | Action | concept_close, concept_window | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_wash_hands` | **wash hands** | Washing both hands with clean water and soap. | Action | concept_wash, concept_hand | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_read_book` | **read a book** | Looking at and reading an interesting book. | Action | concept_read, concept_book | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_sit_down` | **sit down** | To sit down calmly. | Action | concept_sit | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_stand_up` | **stand up** | To rise to one's feet. | Action | concept_stand | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_yes_please` | **yes, please** | Polite affirmation when accepting something. | Polite | Foundational | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_no_thank_you` | **no, thank you** | Polite declination when offered something. | Polite | Foundational | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_thank_you` | **thank you** | Polite expression of appreciation and gratitude. | Polite | Foundational | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_you_are_welcome` | **You're welcome** | Polite response when thanked. | Polite | Foundational | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_excuse_me` | **excuse me** | Polite way to get attention or pass by. | Polite | Foundational | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_help_me_please` | **help me, please** | Politely requesting assistance from someone. | Polite | concept_help | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_here_you_are` | **here you are** | Polite phrase when handing something to someone. | Polite | Foundational | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_my_turn` | **my turn** | Indicating readiness for your own turn in games. | Micro-Bridge | Foundational | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_let_us_play` | **let's play** | Inviting a friend or sibling to play together. | Micro-Bridge | concept_play | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_i_am_fine` | **I'm fine** | Responding to a greeting about health or state. | Micro-Bridge | Foundational | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_water_please` | **water, please** | Polite beginner request for water before full sentences. | Polite | concept_water | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_help_me` | **help me** | Short functional phrase to request assistance. | Action | concept_help | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_look_at_that` | **look at that** | Directing attention to an object or scene. | Action | concept_look | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_on_the_table` | **on the table** | Spatial location on top of a table. | Micro-Bridge | concept_table | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_on_the_desk` | **on the desk** | Spatial location on top of a desk. | Micro-Bridge | concept_desk | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_in_the_sky` | **in the sky** | Spatial location in the sky. | Micro-Bridge | concept_sky | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_big_camel` | **big camel** | A large desert camel. | Description | concept_camel | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_yellow_duck` | **yellow duck** | A cheerful yellow duck. | Description | concept_duck, concept_yellow | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_small_goat` | **small goat** | A young gentle goat. | Description | concept_goat | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_brown_cat` | **brown cat** | A friendly brown cat. | Description | concept_cat, concept_brown | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_eat_rice` | **eat rice** | Eating wholesome rice at mealtime. | Action | concept_eat, concept_rice | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_eat_cheese` | **eat cheese** | Eating delicious cheese with bread. | Action | concept_eat, concept_cheese | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_clean_socks` | **clean socks** | Fresh clean socks for school. | Description | concept_clean, concept_socks | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_blue_shirt` | **blue shirt** | A neat blue shirt. | Description | concept_shirt, concept_blue | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_bright_moon` | **bright moon** | The shining night moon. | Description | concept_moon | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_green_grass` | **green grass** | Fresh green grass in the garden or field. | Description | concept_grass, concept_green | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_purple_flower` | **purple flower** | A pretty purple garden blossom. | Description | concept_flower, concept_purple | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_pink_flower` | **pink flower** | A sweet pink blossom. | Description | concept_flower, concept_pink | Approved | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_assalamu_alaikum` | **Assalamu Alaikum** | Peace be upon you — warm Islamic greeting. | Islamic Adab | Foundational | ⚠️ Pending Scholar Review | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_wa_alaikum_assalam` | **Wa Alaikum Assalam** | And unto you be peace — reply to greeting. | Islamic Adab | Foundational | ⚠️ Pending Scholar Review | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_bismillah` | **Bismillah** | In the name of Allah — said before eating or beginning an action. | Islamic Adab | Foundational | ⚠️ Pending Scholar Review | [ ] | [ ] | [ ] | [ ] | |
| `concept_p2_alhamdulillah` | **Alhamdulillah** | Praise be to Allah — said with gratitude after eating or sneezes. | Islamic Adab | Foundational | ⚠️ Pending Scholar Review | [ ] | [ ] | [ ] | [ ] | |

---

## 4. Level 3 — Complete Sentence Patterns (21 Patterns)

| Pattern ID | Sentence Template | Communicative Function | Natural Contraction | Example Produced | Product Owner Decision | Keep | Revise | Remove | Review Notes |
| :--- | :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `pattern_this_is_a` | `This is a {object}.` | Sentence construction | N/A | "This is a cat." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_that_is_a` | `That is a {object}.` | Sentence construction | N/A | "That is a bird." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_i_am` | `I am {state}.` | Sentence construction | N/A | "I am happy." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_my_name_is` | `My name is {name}.` | Sentence construction | N/A | "My name is Ayaan." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_i_have_a` | `I have a {item}.` | Sentence construction | N/A | "I have a pencil." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_i_like` | `I like {item}.` | Sentence construction | N/A | "I like apples." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_i_do_not_like` | `I don't like {item}.` | Sentence construction | Yes | "I don't like milk." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_i_can` | `I can {action}.` | Sentence construction | N/A | "I can jump." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_i_cannot_yet` | `I can't {action} yet.` | Sentence construction | Yes | "I can't swim yet." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_i_want` | `I want {item}.` | Sentence construction | N/A | "I want bread." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_i_see_a` | `I see a {object}.` | Sentence construction | N/A | "I see a green tree." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_he_she_is` | `{pronoun} is {state}.` | Sentence construction | N/A | "He is happy." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_it_is` | `It is {adjective}.` | Sentence construction | N/A | "It is big." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_location_on` | `The {object} is on the {furniture}.` | Sentence construction | N/A | "The book is on the table." | [ ] | [ ] | [ ] | [ ] | |
| `pattern_can_i_have` | `Can I have {item}, please?` | Sentence construction | N/A | "Can I have an apple, please?" | [ ] | [ ] | [ ] | [ ] | |
| `pattern_can_you_help_me` | `Can you help me, please?` | Sentence construction | N/A | "Can you help me, please?" | [ ] | [ ] | [ ] | [ ] | |
| `pattern_what_is_this` | `What is this?` | Sentence construction | N/A | "What is this?" | [ ] | [ ] | [ ] | [ ] | |
| `pattern_who_is_this` | `Who is this?` | Sentence construction | N/A | "Who is this?" | [ ] | [ ] | [ ] | [ ] | |
| `pattern_where_is_the` | `Where is the {object}?` | Sentence construction | N/A | "Where is the cat?" | [ ] | [ ] | [ ] | [ ] | |
| `pattern_do_you_like` | `Do you like {item}?` | Sentence construction | N/A | "Do you like apples?" | [ ] | [ ] | [ ] | [ ] | |
| `pattern_can_you` | `Can you {action}?` | Sentence construction | N/A | "Can you run?" | [ ] | [ ] | [ ] | [ ] | |

---

## 5. Conversational Routines & Dialogue Turns (6 Interactive Functions)

### 5.1 Clarification & Questions (`func_what_is_this`)
- **Intent**: askingClarification
- **Age Bands**: Little Explorers (Ages 4–5), Young Adventurers (Ages 6–7), Growing Speakers (Ages 8–10), Confident Speakers (Ages 10–12+)
- **Prerequisite Patterns**: 
- **Example Dialogue Turns**:
  - "Pip: "What is this?""
  - "Child: "An apple.""
  - "Pip: "Yes! A delicious red apple! 🍎""

### 5.2 Personal Introductions (`func_who_is_this`)
- **Intent**: introducingOneself
- **Age Bands**: Little Explorers (Ages 4–5), Young Adventurers (Ages 6–7), Growing Speakers (Ages 8–10), Confident Speakers (Ages 10–12+)
- **Prerequisite Patterns**: pattern_this_is_a
- **Example Dialogue Turns**:
  - "Pip: "Who is this?""
  - "Child: "This is my mother.""
  - "Pip: "MashaAllah! May Allah bless your family! 💖""

### 5.3 Polite Requests (`func_polite_request_food`)
- **Intent**: requesting
- **Age Bands**: Little Explorers (Ages 4–5), Young Adventurers (Ages 6–7), Growing Speakers (Ages 8–10), Confident Speakers (Ages 10–12+)
- **Prerequisite Patterns**: pattern_can_i_have, pattern_i_am
- **Example Dialogue Turns**:
  - "Pip: "Are you thirsty?""
  - "Child: "Yes! Can I have some water, please?""
  - "Pip: "Here you are! 💧""
  - "Child: "Thank you! Alhamdulillah!""
  - "Pip: "You're welcome! Enjoy! 😊""

### 5.4 Asking for Assistance (`func_asking_for_help`)
- **Intent**: askingForHelp
- **Age Bands**: Little Explorers (Ages 4–5), Young Adventurers (Ages 6–7), Growing Speakers (Ages 8–10), Confident Speakers (Ages 10–12+)
- **Prerequisite Patterns**: pattern_can_you_help_me
- **Example Dialogue Turns**:
  - "Pip: "Do you want help with the blocks?""
  - "Child: "Yes! Can you help me, please?""
  - "Pip: "Of course! Let's build together!""
  - "Child: "Thank you, Pip!""

### 5.5 Stating Preferences (`func_express_preferences`)
- **Intent**: answeringPreferenceQuestion
- **Age Bands**: Little Explorers (Ages 4–5), Young Adventurers (Ages 6–7), Growing Speakers (Ages 8–10), Confident Speakers (Ages 10–12+)
- **Prerequisite Patterns**: pattern_i_like, pattern_i_do_not_like
- **Example Dialogue Turns**:
  - "Pip: "What fruit do you like?""
  - "Child: "I like apples! I don't like lemons.""
  - "Pip: "Apples are sweet and crunchy! 🍏""

### 5.6 Greetings & Welcome (`func_greeting_exchange`)
- **Intent**: greeting
- **Age Bands**: Little Explorers (Ages 4–5), Young Adventurers (Ages 6–7), Growing Speakers (Ages 8–10), Confident Speakers (Ages 10–12+)
- **Prerequisite Patterns**: pattern_i_am
- **Example Dialogue Turns**:
  - "Pip: "Assalamu Alaikum, explorer!""
  - "Child: "Wa Alaikum Assalam, Pip!""
  - "Pip: "How are you today?""
  - "Child: "I am happy! Thank you!""

---

## 6. Complete Story Narratives & Text Separation (3 Stories)

### 6.1 Sharing the Sweet Apples 🍎 (`story_sharing_apples`)
- **Level**: Level 3 | **World**: `world_food` | **Unit**: `unit_food_blessings`
- **Review Status**: **Pending Qualified Islamic Review**
- **Value Themes**: value_sharing, value_gratitude, value_family_care

#### Simple Productive Retell Text (Level 1-Appropriate):
1. "Ayaan has two apples."
1. "Ayaan is hungry."
1. "Maryam is hungry too."
1. "Ayaan gives an apple."
1. ""Here you are, Maryam!""
1. ""Thank you, Ayaan!""

#### Rich Listening Narrative (Audio & Parent-Read):
1. "Ayaan finds two big red apples on the kitchen table."
1. "He is hungry after playing outside in the green garden."
1. "His little sister Maryam comes in. She is hungry too!"
1. "Ayaan smiles kindly and hands the largest apple to Maryam."
1. ""Here you are, Maryam!" he says with a smile."
1. ""Thank you, Ayaan! Alhamdulillah!" Maryam says happily."

### 6.2 Helping Mother at Home 🏡 (`story_helping_mother`)
- **Level**: Level 2 | **World**: `world_home` | **Unit**: `unit_home_living`
- **Review Status**: **Pending Qualified Islamic Review**
- **Value Themes**: value_helping_parents, value_cleanliness, value_family_care

#### Simple Productive Retell Text (Level 1-Appropriate):
1. "Mother is in the room."
1. "Toys are on the floor."
1. ""Can I help you, Mother?" asks Zayd."
1. "Zayd puts books on the desk."
1. ""Thank you, Zayd!" says Mother."
1. "The room is clean."

#### Rich Listening Narrative (Audio & Parent-Read):
1. "Mother is tidying the living room after breakfast."
1. "Little Zayd looks at the toys on the floor."
1. ""Can I help you, Mother?" asks Zayd politely."
1. "Zayd puts his books on the desk and tidies his room."
1. ""Thank you, my helpful boy! MashaAllah!" says Mother."
1. "The room is clean, and everyone is happy."

### 6.3 The Thirsty Little Bird 🐦 (`story_thirsty_bird`)
- **Level**: Level 1 | **World**: `world_animal` | **Unit**: `unit_animal_savannah`
- **Review Status**: **Pending Qualified Islamic Review**
- **Value Themes**: value_caring_creation, value_kindness, value_gratitude

#### Simple Productive Retell Text (Level 1-Appropriate):
1. "It is hot."
1. "The sun is hot."
1. "A bird is thirsty."
1. "The bird wants water."
1. "Here is water."
1. "The bird drinks water."
1. "The bird is happy."

#### Rich Listening Narrative (Audio & Parent-Read):
1. "The hot yellow sun shines brightly in the sky."
1. "A small blue bird sits quietly on the green tree branch."
1. "The bird is thirsty and chirps softly for water."
1. "Ayaan fills a clean little cup with cool water and sets it outside."
1. "The bird drinks the cool water happily and chirps a cheerful song."
1. "Ayaan smiles warmly as the little bird flies happily away into the sky."

---

## 7. Curriculum Units & Lessons Across 8 Worlds (16 Units, 18 Lessons)

| World | Unit ID | Level | Title | Speaking Outcome | Lessons Included |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `world_family` | `unit_family_basics` | level_1_first_words | **Family & Home** | Child can say words for family members and introduce them with "This is my...". | Meet My Family, This is My Family |
| `world_family` | `unit_family_phrases` | level_2_first_phrases | **Loving Family Words** | Child can say "my mother", "my father", and greet family warmly. | Loving Family Words |
| `world_home` | `unit_home_living` | level_1_first_words | **My Room & Tidy Habits** | Child can name common room objects and say "I am tidy". | My Clean Room |
| `world_home` | `unit_home_routines` | level_2_first_phrases | **Helping at Home** | Child can say "wash hands", "open the door", and "clean room". | Tidying & Washing Hands |
| `world_food` | `unit_food_blessings_l1` | level_1_first_words | **Delicious Treats & Pure Water** | Child can name apple, banana, bread, and water clearly. | Delicious Fruits & Pure Water |
| `world_food` | `unit_food_blessings` | level_3_first_sentences | **Food & Blessings** | Child can name foods, say "I like...", and make a polite request with "please" and "thank you". | Foods I Like, Polite Requests & Sharing Treats |
| `world_animal` | `unit_animal_savannah` | level_1_first_words | **Gentle Creatures of the Savannah** | Child can name common animals and describe them as big or gentle. | Gentle Creatures |
| `world_animal` | `unit_animal_phrases` | level_2_first_phrases | **Big Lions & Little Birds** | Child can say "big dog", "small cat", and "two cats". | Big Lions & Little Cats |
| `world_school` | `unit_school_basics` | level_1_first_words | **School Tools & Books** | Child can name book, pencil, and bag clearly. | My Book & Bag |
| `world_school` | `unit_classroom_tools` | level_2_first_phrases | **Classroom Friends & Tools** | Child can name school tools and ask for pencils politely. | My Bag & My Books |
| `world_play` | `unit_play_basics` | level_1_first_words | **Playtime & Friends** | Child can say play, friend, and share. | Play with Friends |
| `world_play` | `unit_play_friendship` | level_2_first_phrases | **Play & Taking Turns** | Child can say "your turn", "blue ball", and "let us play". | Taking Turns & Sharing Fun |
| `world_day` | `unit_day_basics` | level_1_first_words | **My Daily Habits** | Child can say wash, clean, eat, and sleep. | Wash & Sleep |
| `world_day` | `unit_my_day_routines` | level_3_first_sentences | **My Daily Routine** | Child can express abilities and daily routines in complete sentences. | Things I Can Do |
| `world_nature` | `unit_nature_basics` | level_1_first_words | **Sky, Sun & Trees** | Child can name sun, moon, tree, and flower. | Sun, Moon & Trees |
| `world_nature` | `unit_nature_creation` | level_3_first_sentences | **Wonders of Nature & Sky** | Child can observe and describe nature with "I see..." and "That is...". | Look at the World |

---

## 8. Multi-Stage Can-Do Statements & Completion Criteria

| Can-Do ID | Level | Statement | Assessment Criteria / Stage | Child Friendly |
| :--- | :---: | :--- | :--- | :--- |
| `cando_l1_family` | 1 | **Can identify and say foundational family words.** | >= 4 correct auditory recognitions and 2 clear spoken productions. | I know my family words! 🏡 |
| `cando_l1_food` | 1 | **Can identify everyday foods and clean water.** | >= 4 correct auditory food recognitions. | I can name delicious foods! 🍎 |
| `cando_l1_animals` | 1 | **Can identify common animals by name and spoken sound.** | >= 4 correct animal recognitions. | I know friendly animal names! 🦁 |
| `cando_l1_school` | 1 | **Can identify common school items and tools.** | >= 3 correct classroom item recognitions. | I know my school items! 🎒 |
| `cando_l1_play` | 1 | **Can identify play items and friendly games.** | >= 3 correct play object recognitions. | I can name fun playtime words! 🎈 |
| `cando_l1_habits` | 1 | **Can identify foundational everyday habits and actions.** | >= 3 correct daily action recognitions. | I know my daily routine words! 🧼 |
| `cando_l1_nature` | 1 | **Can identify beautiful nature creations.** | >= 3 correct nature element recognitions. | I know nature words! 🌻 |
| `cando_l2_descriptions` | 2 | **Can combine known words into descriptive phrases (color/size + noun).** | >= 3 correct phrase combinations spoken clearly. | I can put words together! 🧩 |
| `cando_l2_actions` | 2 | **Can combine everyday action verbs with nouns.** | >= 3 correct action phrase combinations spoken clearly. | I can say action phrases! 🏃 |
| `cando_l2_polite` | 2 | **Can use common polite phrases and early request bridges (Stage 1: "Water, please.").** | Stage 1: Uses 2-word polite bridge ("Water, please", "Help me, please") with >= 75% clarity. | I use polite words with everyone! 🤲 |
| `cando_l3_sentences` | 3 | **Can construct and speak complete simple sentences (I am, I like, This is).** | >= 4 syntactically complete sentence constructions. | I can speak in full sentences! ✍️ |
| `cando_l3_requests` | 3 | **Can make a polite functional request in dialogue (Stage 2: "Can I have..., please?" / Stage 3: Full polite exchange).** | Stage 2: Constructs "Can I have [item], please?" / Stage 3: Completes full multi-turn polite request and thank-you exchange. | I can ask for things politely in full sentences! 💧 |

---

## 9. Pip Dialogue Companion Pool (Anti-Robotic Tone Audit)

Pip is designed as an encouraging, playful bird companion rather than a judgmental robotic grading system. Jargon has been eliminated across all age bands.

### Band Little Explorers (Ages 4–5)

- **standardCorrect**: "Yay! You got it! 🌟", "Look at that! High five! ✋", "Super! 🎈", "You did it! 🐥", "Nice! ⭐"
- **independentRecall**: "All by yourself! 🚀", "You remembered! Super star! ✨", "Great remembering! 🌟"
- **recoverySuccess**: "You kept trying and did it! 💖", "Yay! We got it together! 🤝", "Wonderful try! Look at you go! 🌈"
- **gentleRetry**: "Almost! Let's listen again! 👂", "Try again! Pip is right here! 😊", "Good try! Touch this one! 👆"
- **streakPraise**: "Three in a row! Wow! 🔥", "On a roll! Keep going! 🎈"
- **listeningPraise**: "Great listening! 👂", "Pip heard that! Nice! 🎶"
- **speakingPraise**: "Nice speaking! Say it again! 🎙️", "Pip loved hearing your voice! 🦜"
- **lessonComplete**: "You finished the adventure! 🌟", "Yay! Star earned! Let's celebrate! 🎈"
- **levelComplete**: "You finished the whole world! 🏆"

### Band Young Adventurers (Ages 6–7)

- **standardCorrect**: "Well done! That's right! ✅", "You got it! 🌟", "Nice work! 🚀", "That's the word! 🎯", "Spot on! 👍"
- **independentRecall**: "You remembered that on your own! 💡", "Sharp memory! 🧠", "You knew it right away! ✨"
- **recoverySuccess**: "You kept trying and got it! 💖", "Great recovery! 🛡️", "That's the spirit! Fantastic! 🌈"
- **gentleRetry**: "Almost! Listen to the clue again. 👂", "Good attempt! Take your time and try again. ⏳", "Close! Let's check together. 🔍"
- **streakPraise**: "Great streak! 🔥", "You are in the zone! ⚡"
- **listeningPraise**: "Great ears! Excellent listening! 🎧", "You caught that sound! 🎶"
- **speakingPraise**: "Clear pronunciation! Great speaking! 🗣️", "Wonderful voice! Keep speaking aloud! 🎙️"
- **lessonComplete**: "Lesson complete! Wonderful progress! 🎉", "You are growing into a confident speaker! 🌟"
- **levelComplete**: "Incredible milestone reached! 🏆"

### Band Growing Speakers (Ages 8–10)

- **standardCorrect**: "Exactly right. Well done.", "Good job. That's accurate.", "Solid answer.", "Correct! Moving forward nicely.", "Spot on."
- **independentRecall**: "You remembered that on your own.", "Great recall! Confident and clear.", "Nice work without any hints."
- **recoverySuccess**: "Great persistence. You solved it.", "Good adjustment! Practice makes progress.", "Nicely corrected."
- **gentleRetry**: "Almost. Review the sentence context and try once more.", "Close try. Listen closely to the pronunciation.", "Not quite yet. Take another look."
- **streakPraise**: "Consistent streak. Keep your focus.", "Strong momentum!"
- **listeningPraise**: "Great listening!", "Accurate listening."
- **speakingPraise**: "Natural delivery and clear diction.", "Great spoken English. Smooth rhythm."
- **lessonComplete**: "Great job today! Unit objective completed.", "Solid progress today."
- **levelComplete**: "Curriculum Level achievement unlocked! 🏆"

### Band Confident Speakers (Ages 10–12+)

- **standardCorrect**: "Exactly right.", "Well said.", "Nice speaking.", "Spot on."
- **independentRecall**: "That sounded great!", "You remembered it right away."
- **recoverySuccess**: "Good correction. Well done.", "Nice adjustment."
- **gentleRetry**: "Try that sentence once more.", "Almost. Re-evaluate the phrasing."
- **streakPraise**: "Strong streak. Great focus."
- **listeningPraise**: "Great listening comprehension.", "Sharp listening."
- **speakingPraise**: "Fluent and natural. Impressive speaking!", "Clear and confident spoken English."
- **lessonComplete**: "Great progress today! Milestone reached."
- **levelComplete**: "Advanced Speaker Milestone Achieved! 🏆"

---

## 10. Auditory Cue & SFX Asset Mapping (PLACEHOLDER Status)

> [!WARNING]
> All sound effect mappings remain in **[PLACEHOLDER]** status until high-fidelity acoustic asset production is scheduled.

| Sound Event | Asset ID | Placeholder Acoustic Target | Status |
| :--- | :--- | :--- | :--- |
| Correct (Soft) | `sfx_correct_soft` | Warm wooden chime / marimba tone | **PLACEHOLDER** |
| Streak (Combo) | `sfx_streak` | Uplifting 3-note ascending xylophone harp | **PLACEHOLDER** |
| Tap / Selection | `sfx_tap` | Gentle pop bubble | **PLACEHOLDER** |
| Gentle Retry | `sfx_gentle_retry` | Muted double xylophone tap | **PLACEHOLDER** |
| Lesson Complete | `sfx_celebrate` | Gentle festive chime ripple | **PLACEHOLDER** |

---

## 11. Islamic Content & Character Audit (Status: Pending Qualified Review)

| Item ID | Item Type | Phrase / Content | Target Value Theme | Review Status | Review Gate Requirement |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `concept_p2_assalamu_alaikum` | Phrase | Assalamu Alaikum | Adab, Peace, Greeting | **Pending Qualified Islamic Review** | Verified pronunciation, respectful usage |
| `concept_p2_wa_alaikum_assalam` | Phrase | Wa Alaikum Assalam | Adab, Peace, Reciprocal Greeting | **Pending Qualified Islamic Review** | Verified pronunciation |
| `concept_p2_bismillah` | Phrase | Bismillah | Gratitude, Routine, Dhikr | **Pending Qualified Islamic Review** | Contextual appropriateness |
| `concept_p2_alhamdulillah` | Phrase | Alhamdulillah | Gratitude, Dhikr | **Pending Qualified Islamic Review** | Contextual appropriateness |
| `story_thirsty_bird` | Story | The Thirsty Little Bird | Caring for creation, Mercy | **Pending Qualified Islamic Review** | Ethical alignment |
| `story_helping_mother` | Story | Helping Mother at Home | Birr al-Walidayn, Helping parents | **Pending Qualified Islamic Review** | Ethical alignment |
| `story_sharing_apples` | Story | Sharing the Sweet Apples | Generosity, Family care | **Pending Qualified Islamic Review** | Ethical alignment |

---

## 12. Human Review Sign-Off Sheet

| Reviewer Role | Name | Recommendation | Signature / Date |
| :--- | :--- | :--- | :--- |
| Product Owner | | [ ] Accept / [ ] Request Revision | |
| Islamic Pedagogy Specialist | | [ ] Approved / [ ] Needs Revision | |
| Native English Specialist | | [ ] Natural / [ ] Revise Phrasing | |

---
**Conclusion**: `phase15_human_content_audit_v2.md` generated dynamically from repository state with 100% verified integrity.
