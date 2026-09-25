# Changelog — Phase 16.8 Release Candidate Freeze

All major completed milestones up to the current product baseline:

---

## [Phase 16.8 RC] - 2026-09-13

### 1. Table Visual & Physical Representation
- Replaced ambiguous wood log fallback (`🪵`) with custom vector-drawn `ChildTableVisual` widget (`lib/core/widgets/child_table_visual.dart`).
- Displays a warm honey-oak beveled tabletop, four perspective-angled legs with ground shadows, and an under-table support crossbeam.
- When `hasBookOnTop` is true in scene placement activities ("Put the book on the table"), an open illustrated book rests flush and directly **ON** top of the tabletop surface (zero gap, not inside, not floating).
- Purged all occurrences of `🪵` across scenes, session composer, games, vocabulary, challenge, and review screens.
- Preserved `concept_table` and `concept_desk` semantic IDs strictly without modifying curriculum definitions.

### 2. Semantic Integrity & Activity Composition (Phase 16.8)
- Introduced `InteractiveActivityIntegrityValidator` to statically and dynamically reject corrupted session payloads.
- Eliminated `Water → Apple` defect in Drag-and-Drop: explicitly bound `picnic_apple_01` (draggable) to `picnic_basket_01` (dropTarget).
- Eliminated `Rabbit → Rabbit` defect in Feed-Character: explicitly separated `picnic_apple_01` (requested food) from `picnic_rabbit_01` (character receiver). Enforced rule that draggable and receiver cannot be identical.
- Eliminated hardcoded 4-step prototype framing: dynamically composed bounded, developmentally calibrated session lengths (Age 3: 6 steps, 3–4 mins; Age 5: 6 steps, 5–6 mins; Age 7: 7 steps, 8–10 mins; Age 9: 7 steps, 10–12 mins).

### 3. Age-Adaptive Learning Experience (Phases 16.6 – 16.7)
- Created `AgeExperienceProfile` for 4 distinct age bands (Pre-A, Band A, Band B, Band C).
- **Ages 3–4 (Little Listeners):** Pure visual/emoji interface (`TextDensity.zero`), no required reading, optional speaking with touch fallback, large 120px targets, soft progress dots (`● ○ ○ ○ ○ ○`), zero test framing.
- **Ages 4–5 (Little Explorers):** Emergent reading labels, 3 choices, 96px targets, speech repetition.
- **Ages 6–7 (Young Adventurers):** Sentence patterns, spatial preposition placement, role-play dialogues with Pip, 4 choices, 76px targets.
- **Ages 8–10 (Growing Speakers):** Independent reading, contextual real-world dilemmas, mature 58px layouts, restrained mascot guidance.

### 4. End-to-End Navigation Integration
- Bound physical user navigation directly from Adventure Home, World, and Lesson Detail into `InteractiveSessionScreen`.
- Ensured progress tracking, signal emission, and ChildProfile reward recording seamlessly commit on activity completion.
- Ensured rapid double-tapping cannot trigger duplicate progress saves.

### 5. Curriculum Freeze & Baseline Integrity (Phases 16.1 – 16.5)
- Fully frozen Levels 1–3 curriculum data: 208 total concepts (144 Level 1, 64 Level 2), 26 sentence patterns, 13 conversation functions, 16 units, 18 lessons, 3 stories, 3 missions, 12 Can-Do statements.
- Deterministic SHA-256 canonical hash locked at: `02f9e00cbd1c1c52`.
- Zero curriculum mutations permitted or detected.

### 6. Release Verification
- Static Analysis: 0 issues (`dart analyze lib test`).
- Project Test Suite: 430 / 430 tests passing (100%).
- Golden Baselines: 8 / 8 golden tests passing, including verified table visuals.
- Production Release APK: Built in release mode (54.4 MB, SHA-256: `07D87518F7FA1E5ADE7DAAD8C5B9AD58CFA51E8589338F098CFE930C9D825C8A`).
