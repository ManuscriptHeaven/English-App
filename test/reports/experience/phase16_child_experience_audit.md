# Phase 16: Child Experience Audit — Journeys A through H

**Kids English Adventure — End-to-End Child User Experience Verification**
**Auditor:** QA & Learning Experience Architecture  
**Curriculum Lock State:** `FROZEN_LEVELS_1_TO_3` (Hash: `02f9e00cbd1c1c52`)

---

## Journey A: Age 5 Beginner Child (Band A — Little Explorers)

* **Child Profile:** 5-year-old child starting their very first English lesson. Non-reader, emergent speaker.
* **Flow & Scaffolding:**
  1. **Visual Prompts:** Large, vibrant illustration cards (minimum 96x96 touch targets) depicting foundational concept `red apple`.
  2. **Pip Guide Reaction:** Pip appears with a cheerful double-chirp (`pipAppear`), bouncing gently (6px vertical bob).
  3. **Instruction:** Native audio clearly models the word: *"Red apple"* with slow, child-adaptive tempo (0.35 rate). Text is minimal and secondary.
  4. **Action:** Child taps the red apple card.
  5. **Feedback Experience:**
     - Instant tactile scale down (0.94) and bounce back (1.0).
     - Sound effect: Soft 2-tone wooden chime (`correctSoft`).
     - Pip character gives a happy physical bounce without a full wall of text speech bubble (anti-fatigue protection).
* **Outcome:** Joyful, intuitive, zero cognitive reading overload. Child feels successful immediately.

---

## Journey B: Age 5 Child Answering Incorrectly (Zero-Shame Recovery)

* **Child Profile:** 5-year-old child attempting to identify `water` but accidentally tapping the `milk` card.
* **Flow & Recovery:**
  1. **Tapping Mismatched Card:** Child taps the incorrect cup card.
  2. **Acoustic Cue:** Zero harsh buzzer, zero red "X", zero alarm sounds. The app plays `gentleRetry`: a soft, neutral low marimba drop (150ms).
  3. **Visual Feedback:** The tapped card gently wobbles (subtle 3° oscillation) and settles back to its resting state. The screen does NOT flash red.
  4. **Pip Encouragement:** Pip tilts head encouragingly with prompt: *"Almost! Let's listen again! 👂"*
  5. **Auto-Scaffolding:** The native audio re-models the target word: *"Water"*, and the target card pulses with a warm golden highlight (1.05 scale).
  6. **Child Retries & Succeeds:** Child taps `water`.
  7. **Calibrated Recovery Feedback (Tier 3):**
     - **Single-Mistake Recovery:** App plays `recoverySuccess` (warm acoustic guitar strum). Pip provides immediate, warm confirmation without disproportionate effort praise: *"You got it! 🌟"*.
     - **Repeated Struggle Recovery:** If the child worked through repeated attempts before succeeding, Pip reserves effort-based resilience praise: *"You kept trying and did it! 💖"*.
* **Outcome:** Resilience-building, non-punitive, emotionally safe. The child is motivated to try again rather than exit.

---

## Journey C: Age 7 Child — Speaking Practice Interaction

* **Child Profile:** 7-year-old child (Band B — Young Adventurers) practicing the phrase *"This is my room"*.
* **Flow (8 Discrete Speaking Steps):**
  1. **Step 1 (Listen to Model):** Pip announces: *"Listen to Pip! 👂"* and plays crystal-clear native audio of the target sentence.
  2. **Step 2 (Prompt Visible):** Target phrase card displays in bold, rounded Nunito typography.
  3. **Step 3 (Mic Activates):** Big floating microphone button glows with inviting green pulse. Pip prompts: *"Your turn! Tap the mic to speak! 🎙️"*.
  4. **Step 4 (Child Speaks):** Child taps mic. State enters `listening`. Pip transforms into listening pose (ear cocked forward).
  5. **Step 5 (Reactive Audio Visualizer):** Dynamic sound-level ripples expand around the microphone button reacting in real-time to the child's voice amplitude.
  6. **Step 6 (Processing):** Child finishes speaking. App stops recording automatically after brief silence. Mic shows gentle sparkle spinner: *"Checking your awesome speech... ✨"*.
  7. **Step 7 (Lenient Evaluation):** Speech similarity engine scores acoustic match against `INITIAL_TUNING_THRESHOLD` (0.45).  
     *(Note: This threshold represents an initial engineering tuning baseline and requires real-device acoustic validation across diverse child age cohorts [5–9], regional accents, various mobile device microphones, quiet speech, and home background noise).*
  8. **Step 8 (Qualitative Celebration):** Child scored 0.78 similarity. Instead of showing discouraging percentage scores ("78%"), app displays qualitative praise: *"Great effort! Pip heard you clearly! 🦜"*. High-warmth flute sound (`speakingSuccess`) plays, celebrating spoken production higher than tap answers.
* **Outcome:** Encourages vocal articulation, builds speaking confidence without phonetic harshness.

---

## Journey D: Age 9 Beginner Learner (Band C — Growing Speakers)

* **Child Profile:** 9-year-old learner who is starting English learning later.
* **Developmental Calibration:**
  1. **Respectful Companion Tone:** Pip uses mature, encouraging prompts: *"Great focus today. You completed the challenge."* instead of toddler expressions like *"Whoopee! High five little buddy!"*.
  2. **Content Presentation:** Typography adjusts from oversized primary headings to structured sentence cards with context sentences.
  3. **Feedback Calibration:** Praise is calibrated to competent accomplishments using natural child phrases: *"Nice work."*, *"That was clear."*, *"Great speaking."*, *"You said that really well."* (avoiding evaluative or patronizing phrasing like *"Sharp work!"* or *"Clear and confident speaking."*).
* **Outcome:** The older child never feels infantalized or embarrassed by baby-talk, preserving engagement.

---

## Journey E: Routine Lesson Completion Experience

* **Event:** Child finishes the final activity in Unit 1, Lesson 2.
* **Milestone Screen:**
  1. **Clean Card Presentation:** `LessonCompletionView` displays smoothly with spring curve.
  2. **Pip Mascot Joyful Reaction (Routine Intensity):** Pip performs a cheerful bounce and sparkle pose (`PipState.happy`, celebration intensity 1). High-intensity celebration (Pip backflip, `PipState.celebrating`, intensity 2) is strictly reserved for major milestone capstones (mission completion, world unlock, level completion) to prevent celebratory fatigue across routine lessons.
  3. **No Casino Slot Machine Mechanics:** No spinning wheels, no ticking coin counters, no popup ads, no multi-stage countdown timers.
  4. **Star Allocation:** 3 golden stars illuminate sequentially with soft bell chimes (`starEarned`). Even 1 star is framed positively as progress.
  5. **Practiced Content Summary:** Card shows: *"Today you practiced: red • blue • yellow • circle"*.
  6. **Snappy Action:** A prominent green "Continue" button is immediately clickable.
  7. **Animation Cancellation:** Child taps "Continue" immediately. Audio fanfare stops instantly, Pip resets to idle, and transition to the map completes in < 300ms.
* **Outcome:** Fulfilling closure without overwhelming sensory fatigue.

---

## Journey F: Accessibility & Reduced Motion Mode

* **Condition:** Child or parent has enabled "Reduced Motion" in device settings or app settings (`disableAnimations = true`).
* **Experience:**
  1. **Duration Zero Resolution:** `AppMotion.resolveDuration` resolves transition times to `Duration.zero`.
  2. **Suppressed Animations:** Full-screen celebratory zooms, spring oscillations, and screen shakes are completely bypassed.
  3. **Immediate Content Delivery:** `LessonCompletionView` and feedback cards render immediately in their final settled state.
  4. **Parity of Information:** All educational feedback, stars, scores, and spoken audio remain 100% accessible.
* **Outcome:** Safe for children with vestibular sensitivities or visual motion fatigue.

---

## Journey G: Audio SFX Muted / Voice Only Mode

* **Condition:** Sound effects volume muted by parent in settings (`isSfxEnabled = false`), while voice narration remains active.
* **Experience:**
  1. **Muted SFX Dispatch:** All calls to `playSound()` return `false` without delay or error.
  2. **Voice Maintained:** Instructional voice, word pronunciation, and Pip's spoken encouragement play at full clarity.
  3. **Visual Compensation:** Visual spring animations, card glows, and star highlights visually convey the success state.
  4. **Full Progression:** Lessons, stars, and XP persist exactly as normal.
* **Outcome:** Quiet-room friendly, car-ride friendly, 100% playable without sound effects.

---

## Journey H: Microphone Access Denied or Timed Out

* **Condition:** Device microphone permission was denied by the parent or OS, or speech recognition timed out due to ambient silence.
* **Recovery:**
  1. **Zero Technical Jargon:** The app NEVER displays `SpeechRecognitionException`, `PermissionDenied`, or stack traces.
  2. **Child-Friendly Message:** App displays: *"Microphone is sleeping. Ask a grown-up for help!"*.
  3. **Soft Retry Flow:** If silence caused timeout, app says: *"I didn't hear that. Let's try once more! 👂"*.
  4. **Zero Crash:** The controller catches errors in `try/catch` and transitions smoothly to `SpeakingFlowState.retry` or `unavailable`.
* **Outcome:** The app remains completely stable and gentle, never frustrating the child with cryptic device errors.

---
