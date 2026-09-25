# Phase 16.8 Release Candidate Checklist

**Product:** Kids English Adventure  
**Phase:** Phase 16.8 Finalization & Release Candidate Freeze  
**Date:** 2026-09-13  
**Evaluator:** Antigravity AI Pair Programmer & Quality Engineering Engine  

---

## 1. Integrity & Curriculum Verification

- [x] **Curriculum hash verified**  
  Canonical Hash: `02f9e00cbd1c1c52` (Matches `CurriculumFreezeGuard.frozenBaselineHash`). 0 mutations detected across 208 concepts, 26 patterns, 13 functions, 16 units, 18 lessons, 3 stories, 3 missions, and 12 Can-Do statements.

- [x] **Static analysis clean**  
  `dart analyze lib test` exited with code 0 (0 warnings, 0 errors, 0 lints).

- [x] **Full tests passing**  
  `flutter test` executed all 430 registered tests: 430 passed, 0 failed, 0 skipped (100% pass rate).

- [x] **Goldens passing**  
  All 8 visual golden tests passed cleanly:
  - `phase16_8_age3_apple_to_basket.png`
  - `phase16_8_age3_apple_to_rabbit.png`
  - `phase16_8_age3_water_to_pip.png`
  - `phase16_8_age7_roleplay.png`
  - `phase16_8_age9_contextual_scene.png`
  - `phase16_8_age7_book_on_table.png`
  - `child_table_visual_preview.png`
  - Font pre-warm baseline

---

## 2. User Journey & Navigation Verification

- [x] **Production navigation verified**  
  E2E user flow: Child Profile → Adventure Home → World → Unit → Lesson → Interactive Session → Learning Evidence → Progress Save → Return to Map confirmed. No regression to obsolete demo/test-only screens.

---

## 3. Core Interactive Flows Deterministic Verification

- [x] **Apple -> Basket verified**  
  `picnic_apple_01` (🍎) dropped into `picnic_basket_01` (🧺). Instruction matches object, drop physics settle inside basket.

- [x] **Apple -> Rabbit verified**  
  `picnic_apple_01` (🍎) fed to `picnic_rabbit_01` (🐰). Receiver munches with animated chewing and sound prompt. Cannot drag rabbit to rabbit.

- [x] **Water -> Pip verified**  
  `picnic_water_01` (💧) offered to `picnic_pip_01` (🐥). Pip sips and chirps.

- [x] **Book -> Table verified**  
  `picnic_book_01` (📖) placed on `picnic_table_01` rendered with `ChildTableVisual`. Book visually and flushly rests directly ON the tabletop (zero gap, not inside, not floating).

- [x] **Door action verified**  
  "open the door" trigger swings door wide open (`doorOpen` reaction). Immediate touch fallback available.

- [x] **Age 3 flow verified**  
  Zero text labels (`TextDensity.zero`), visual journey dots (`● ○ ○ ○ ○ ○`), large 120px targets, speaking optional, short 6-step flow.

- [x] **Age 5 flow verified**  
  Visual + word support, 96px targets, 3 choices, gentle speech repetition.

- [x] **Age 7 flow verified**  
  Phrase / sentence structures, spatial preposition placement ("book on table"), dialogue role-play with Pip.

- [x] **Age 9 flow verified**  
  Contextual dilemma problem solving, mature 58px card layout, restrained mascot guidance.

---

## 4. Release Build Artifacts & Documentation

- [x] **Release APK built**  
  Built via `flutter build apk --release` (R8 tree-shaking active).  
  Path: `build\app\outputs\flutter-apk\kids_english_adventure_phase16_8_rc.apk`

- [x] **SHA256 recorded**  
  SHA-256: `07D87518F7FA1E5ADE7DAAD8C5B9AD58CFA51E8589338F098CFE930C9D825C8A`  
  File Size: 57,084,658 bytes (54.4 MB)

- [x] **Known limitations documented**  
  - Audio status: `AUDIO_ASSET_PRODUCTION_PENDING` (Uses programmatic TTS / system SFX; studio human audio pending).
  - Formal Islamic pedagogical review pending for final commercial distribution.
  - Large-scale multi-child cohort usability study pending.
