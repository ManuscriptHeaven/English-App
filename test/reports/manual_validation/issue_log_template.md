# Manual Validation Issue Log Template

## Kids English Adventure — Defect Inventory & Tracking

This document defines the defect classification standards and standardized defect reporting structure for the Manual & Real-Device Validation Gate.

---

## 1. Severity Definitions

| Severity | Definition | SLA / Gate Impact |
|---|---|---|
| **P0 — Blocker** | App crashes, freezes, data loss, state corruption, infinite loops, child permanently trapped, unhandled exception dialogs, or complete failure of core learning loop. | **Must be fixed and verified before gate sign-off.** Zero P0 issues permitted. |
| **P1 — Major** | Key feature impaired without acceptable workaround, speech recognition broken, incorrect mastery calculation, offline mode failing, significant visual truncation, touch target $<32\text{ dp}$. | **Must be fixed and verified or formally excepted before gate sign-off.** |
| **P2 — Minor** | Suboptimal UX, audio latency, minor alignment flaw, slight animation glitch, rare edge-case error with graceful recovery, non-blocking accessibility warning. | Resolved during tuning cycle or prioritized in sprint backlog. |
| **P3 — Trivial** | Minor cosmetic imperfections, subtle color variance, minor wording/grammar enhancement in parent gate, micro-animation polish. | Logged in backlog for future maintenance. |

---

## 2. Issue Classification Categories

- **Visual & Layout**: RenderFlex overflow, text clipping, improper aspect ratio, font scaling distortion.
- **Usability & Flow**: Confusing navigation, missing back button, small touch targets, difficult gestures.
- **Audio & Speech**: TTS pronunciation error, microphone timeout, permission denial crash, volume imbalance.
- **Performance & Stability**: Frame rate drop, memory leak, excessive thermal output, slow screen transition.
- **State & Data**: Profile data loss, reward duplication, Hive DB write collision, corrupted session resume.
- **Adaptive Learning Logic**: Incorrect tier selection, missing spaced review, unfair mastery penalty, broken session recommendation.
- **Accessibility & Child Safety**: Missing semantics, harsh failure audio, excessive stimulation, non-isolated child data.

---

## 3. Standard Defect Template

```markdown
### [ISSUE-XXX] Short Descriptive Title
- **Severity**: P0 / P1 / P2 / P3
- **Category**: [Visual | Usability | Audio | Performance | State | Adaptive | A11y]
- **Status**: [Open | In Progress | Fixed | Verified | Deferred]
- **Found On**: [Device Model, OS Version, Screen Resolution, Orientation]
- **Screen / Component**: `lib/features/.../screen_name.dart`

#### Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

#### Expected Behavior
*Clear explanation of what the educational and technical standard expects.*

#### Actual Behavior
*Clear explanation of what actually occurred (include exact error message if any).*

#### Impact on Child Learner
*How this affects the child's emotional state, learning momentum, or safety.*

#### Root Cause Analysis
*Technical analysis of the underlying code, state management, or asset fault.*

#### Resolution & Verification
- **Fix Applied**: Description of code change or configuration update.
- **Files Modified**: `lib/...`
- **Regression Test**: Test case ID or automated test name added.
- **Verified By**: [Verifier Name/Agent, Timestamp, Device]
```

---

## 4. Current Defect Inventory Summary

| ID | Title | Severity | Category | Status | Verified In |
|---|---|---|---|---|---|
| *(Populated during execution)* | | | | | |

