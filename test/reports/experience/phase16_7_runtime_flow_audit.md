# Phase 16.7 Runtime Flow Audit: End-to-End Lesson Journey & Disconnection Analysis

**Date:** 2026-09-13  
**Status:** Audit Completed — Diagnostic Verified  
**App Corpus:** Kids English Adventure  

---

## 1. Executive Summary & Product Owner Defect Confirmation

During Phase 16.6 verification on a physical Android device, the Product Owner identified three catastrophic failures:
1. **Age Differentiation:** Age 3, 5, 7, and 9 felt substantially identical.
2. **Interactivity:** The child was still primarily tapping answers; the 7 interactive mechanics were absent.
3. **Age 3 Suitability:** Complete 3-year-old beginner was confronted with tap-quiz mechanics and inappropriate text/expectations.

Despite 405/405 automated tests passing in Phase 16.6, this audit verifies the root cause:
**`AgeExperienceProfile` and `InteractiveActivityEngine` were completely disconnected from the actual production lesson launch pipeline.**

---

## 2. Complete Trace of the Production User Journey

The actual runtime path traversed by a child playing the game was traced step-by-step:

```
Child Profile Selection
  └─ ChildSelectionScreen [lib/features/child_profile/presentation/screens/child_selection_screen.dart]
       ↓ selects active child (sets activeChildProfileProvider)
Adventure Home Screen
  └─ AdventureHomeScreen [lib/features/home/presentation/screens/adventure_home_screen.dart]
       ├─ (A) Primary CTA Button ("START ADVENTURE 🚀" / "CONTINUE ADVENTURE 🚀")
       │      └─ watches currentRecommendationProvider
       │           └─ calls AdventureRecommendationEngine.getNextRecommendation(...)
       │                └─ returns Recommendation with routePath: _mapRoutePath(nextLesson.id)
       │                     └─ Pushes legacy route (e.g. RouteNames.vocabularyDiscovery)
       │
       └─ (B) World Card Tap (e.g. "Safari & Animals")
              └─ pushes RouteNames.worldDetailPath('world_animal')
                   ↓
World Detail Screen
  └─ WorldDetailScreen [lib/features/worlds/presentation/screens/world_detail_screen.dart]
       └─ Renders AdventureTrailMap with activities from world.chapters.first.units.first.lessons
            └─ Child taps lesson node on map:
                 └─ invokes onLessonTap: (lesson) => _navigateToActivity(context, lesson.id)
                      ↓
Hardcoded Route Switch
  └─ WorldDetailScreen._navigateToActivity (Lines 162–340):
       case 'activity_animal_vocab': context.push(RouteNames.vocabularyDiscovery);
       case 'activity_animal_hunt':  context.push(RouteNames.animalHunt);
       case 'activity_listen_tap':   context.push(RouteNames.listenAndTap);
       case 'activity_word_match':   context.push(RouteNames.wordMatch);
       case 'activity_grammar_this_is': context.push(RouteNames.grammarThisIs);
       ... (all other lessons routed to legacy screens)
            ↓
Activity Renderer
  └─ VocabularyDiscoveryScreen, AnimalHuntGameScreen, WordMatchGameScreen, etc.
       └─ Legacy tap-choice screens with hardcoded multiple-choice widgets and text labels
            ↓
Feedback & Progress Save
  └─ Local state, sound effects, and ref.read(activeChildProfileProvider.notifier).completeActivity(...)
            ↓
Next Activity / Exit
  └─ Returns back to WorldDetailScreen or exits to Home.
```

---

## 3. Precise Findings: Where the Disconnection Occurred

| Component / System | Phase 16.6 Status | Normal Production Reachability | Detail / Proof |
| :--- | :--- | :--- | :--- |
| **`AgeExperienceProfile`** | Created in `lib/core/experience/age_experience_profile.dart` | **DISCONNECTED** | Only read inside unit tests and `InteractiveActivityConfig.createSample`. Neither `WorldDetailScreen` nor `AdventureRecommendationEngine` ever queried it. |
| **`InteractiveActivityEngine`** | Created in `lib/core/experience/interactive_activity_engine.dart` | **DISCONNECTED** | Never called by `WorldDetailScreen` or `AdventureHomeScreen`. Only instantiated in unit tests and one dead GoRoute. |
| **`InteractiveActivityScreen`** | Created in `lib/features/games/presentation/screens/interactive_activity_screen.dart` | **UNREACHABLE** | Mapped strictly to `RouteNames.interactiveActivity` (`/activity/interactive`) with query parameters. **Zero buttons or flows in the entire UI ever navigated to this route.** |
| **7 Core Mechanics** | Built inside `interactive_activity_screen.dart` | **0% In Production Lessons** | 100% of normal lesson taps in `WorldDetailScreen` and Home CTA routed to legacy screens (`VocabularyDiscoveryScreen`, `AnimalHuntGameScreen`, etc.). |
| **Age 3 Delivery** | Designed in theory | **FAILED ON DEVICE** | Age 3 child tapped lesson node and was served legacy `VocabularyDiscoveryScreen` or `AnimalHuntGameScreen` (3–4 choices, text cards, no drag/feed/react mechanics). |
| **Age 9 Delivery** | Designed in theory | **FAILED ON DEVICE** | Age 9 child was served identical legacy screens as younger children. |

---

## 4. Why Automated Tests Passed While Product Experience Failed

The Phase 16.6 test suite included 405 passing tests because:
1. `test/unit/interactive_activity_engine_test.dart` directly instantiated `InteractiveActivityConfig.createSample(childAge: 3)` and asserted object counts.
2. `test/unit/age_experience_profile_test.dart` tested unit properties of the profile in isolation.
3. Integration tests never simulated a child launching a lesson from `AdventureHomeScreen` or `WorldDetailScreen` through to activity presentation.
4. **Conclusion:** Unit tests validated internal logic contracts of isolated classes, not the end-to-end user navigation pipeline.

---

## 5. Architectural Mandate for Phase 16.7

To fulfill Product Owner criteria:
1. **InteractiveSessionComposer:** Create a single production session composer that consumes:
   - `ChildProfile.age` $\rightarrow$ `AgeExperienceProfile`
   - Curriculum level, target concepts, and lesson objectives
   - Variety engine constraints
2. **Unified Production Routing:**
   - Eliminate hardcoded legacy-only routing in `WorldDetailScreen._navigateToActivity` and `AdventureRecommendationEngine._mapRoutePath`.
   - Normal lesson launches must route to an active, age-adaptive interactive session runner.
3. **True Age Adaptation:**
   - **Age 3 (Pre-A):** Zero reading, $\le 2$ choices, audio-first, drag & drop + touch reaction + feed, zero mandatory microphone, short (3–4 min).
   - **Age 5 (Band A):** Spoken prompt, visual identification, drag to basket, encouraged speech.
   - **Age 7 (Band B):** Full sentences, preposition placement, role-play dialogues.
   - **Age 9 (Band C):** Contextual mature challenges, conversational discourse, restrained mascot.
4. **End-to-End Verification:**
   - Write automated tests that start at `AdventureHomeScreen` / `WorldDetailScreen` for Ages 3, 5, 7, and 9 and assert the real child experience.
