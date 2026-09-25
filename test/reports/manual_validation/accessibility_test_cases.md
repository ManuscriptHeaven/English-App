# Accessibility & Child-Friendliness Test Cases

## Kids English Adventure — Manual & Real-Device Validation Suite

This document defines specific test procedures, expected behaviors, and evaluation criteria for font scaling, touch targets, screen reader compatibility, color contrast, motion sensitivity, and frustration protection.

---

## Test Cases Summary

| ID | Title | Priority | Primary Focus |
|---|---|---|---|
| **A11Y-01** | Dynamic Font Scaling (100%, 150%, 200%) | P1 | Text overflow, button wrapping, label truncation |
| **A11Y-02** | Minimum Touch Targets ($48\times 48\text{ dp}$) | P0 | Small-hand tap ergonomics, hit-testing accuracy |
| **A11Y-03** | WCAG AA Color Contrast & Readability | P2 | Text-on-background contrast, bright/dim lighting |
| **A11Y-04** | TalkBack / Screen Reader Semantics Smoke Test | P2 | Semantic labels, audio hints, accessibility tree |
| **A11Y-05** | Visual Affordance & Non-Reader Usability | P1 | Iconography, visual cues for pre-literate children |
| **A11Y-06** | Reduce Motion & Cognitive Sensitivity | P2 | Respect OS animation preferences, no overstimulation |
| **A11Y-07** | Frustration Detection & Gentle Intervention | P1 | Rapid repeated taps, idle detection, Pip support |

---

## Detailed Test Procedures

### A11Y-01: Dynamic Font Scaling (100%, 150%, 200%)
- **Objective**: Ensure that large system text preferences do not cause `RenderFlex` overflow errors or render text unreadable.
- **Preconditions**: Device OS Settings > Display > Font Size / Display Size.
- **Steps**:
  1. Set system font scale to **100%** (default). Navigate through Home, Session Intro, Activity Screen, Celebration Screen, and Parent Gate.
  2. Increase system font scale to **150%** (large). Retest all 5 key screens.
  3. Increase system font scale to **200%** (maximum accessibility size). Retest all 5 key screens.
- **Expected Results**:
  - **Zero `RenderFlex overflowed by N pixels` errors** across all screen sizes.
  - Long labels wrap cleanly into multi-line containers or scroll within `SingleChildScrollView`.
  - Action buttons (e.g., "Start Adventure", "Continue", "Check") remain visible and clickable without being pushed offscreen.
  - Vocabulary card words scale gracefully without overlapping card borders or image icons.

### A11Y-02: Minimum Touch Targets ($48\times 48\text{ dp}$)
- **Objective**: Ensure every interactive button, icon, and card has an effective touch target area of at least $48\times 48\text{ dp}$ with comfortable separation ($>8\text{ dp}$).
- **Preconditions**: Debug layout bounds enabled or physical tap testing with young children.
- **Steps**:
  1. Measure or tap audio replay buttons, close/back buttons, flashcard choice tiles, and navigation items.
  2. Tap adjacent buttons intentionally with off-center finger placements (mimicking child motor control).
  3. Verify whether accidental adjacent clicks occur.
- **Expected Results**:
  - All interactive elements meet or exceed the $48\times 48\text{ dp}$ bounding box for touch hit-testing.
  - Interactive choices on multiple-choice screens have at least $12\text{ dp}$ margin separating options to prevent false taps.
  - The "Back / Home" button is prominent and easily reachable without tapping nearby status icons.

### A11Y-03: WCAG AA Color Contrast & Readability
- **Objective**: Verify that text against colorful whimsical backgrounds meets WCAG AA standards (4.5:1 for normal text, 3:1 for large text).
- **Preconditions**: Device screen brightness tested at 30% and 100%.
- **Steps**:
  1. Inspect primary button text (e.g. white text on primary purple `#6C5CE7` or teal buttons).
  2. Inspect instructional text on pastel card backgrounds (e.g., dark slate text `#2D3436` on cream/soft yellow).
  3. Verify color-blind differentiation (e.g., correct vs incorrect feedback does not rely solely on green vs red hues, but uses distinct icons like checkmark/star vs soft retry bubble).
- **Expected Results**:
  - Text contrast exceeds 4.5:1 for instructional body copy and 3.0:1 for large headlines.
  - Feedback states use both color and shape/icon cues simultaneously.
  - Screens remain readable outdoors under direct sunlight and in dimly lit rooms.

### A11Y-04: TalkBack / Screen Reader Semantics Smoke Test
- **Objective**: Ensure children with low vision or parents using assistive technology can navigate key flows using TalkBack (Android) or VoiceOver (iOS).
- **Preconditions**: Enable TalkBack in Android Accessibility Settings.
- **Steps**:
  1. Launch Kids English Adventure with TalkBack active.
  2. Swipe to traverse through Home screen elements: Child Avatar, Star Counter, Pip Greeting, Start Session Button.
  3. Enter an activity and focus the vocabulary card and choices.
- **Expected Results**:
  - Elements have concise, descriptive `Semantics` labels (e.g., *"Pip says: Let's learn animal words!", "Vocabulary word: Apple", "Play sound button", "Choice 1: Dog"*).
  - Decorative background illustrations and particle emitters have `excludeFromSemantics: true` so they do not clutter screen reader output.
  - Double-tap activates buttons reliably.

### A11Y-05: Visual Affordance & Non-Reader Usability
- **Objective**: Verify that pre-literate children (ages 3–5) who cannot yet read English text can understand what to do solely through visual and auditory cues.
- **Preconditions**: Test with non-reading child persona or mute text labels mentally.
- **Steps**:
  1. Present the activity screen without reading the textual instructions.
  2. Observe visual cues: Pip pointing or nodding, pulsing glowing ring on target card, animated finger tap hint if idle.
  3. Tap the speaker icon to hear Pip read the instructions aloud.
- **Expected Results**:
  - The primary interactive target has clear visual weight (bright contrasting color, gentle pulse, or bounce).
  - Pip auto-speaks the initial prompt on screen entry.
  - An idle timer (5–7 seconds of inactivity) displays an intuitive visual guidance cue (e.g., bouncing hint or shimmering highlight).

### A11Y-06: Reduce Motion & Cognitive Sensitivity
- **Objective**: Verify that children sensitive to rapid movement or vestibular triggers can enjoy calm visual presentations.
- **Preconditions**: Enable "Remove animations" / "Reduce motion" in device Accessibility Settings.
- **Steps**:
  1. Launch app and navigate between screens.
  2. Trigger celebration reward screen (stars, confetti).
- **Expected Results**:
  - `MediaQuery.maybeOf(context)?.disableAnimations` is respected.
  - Rapid screen slide transitions are replaced with gentle, instantaneous or soft fade transitions.
  - Confetti particle velocity and spinning animations are moderated or replaced with static star badges.
  - Zero flashing or strobing effects (>3 flashes/second) anywhere in the application.

### A11Y-07: Frustration Detection & Gentle Intervention
- **Objective**: Verify that erratic, frantic tapping or persistent confusion triggers gentle educational support rather than error dialogs.
- **Preconditions**: Child starts a multiple-choice activity.
- **Steps**:
  1. Rapidly and repeatedly tap wrong answers or tap repeatedly outside clickable targets (5+ taps in 2 seconds).
  2. Allow the screen to remain idle for 10 seconds.
- **Expected Results**:
  - Rapid mis-taps do not trigger loud jarring error buzzers.
  - Pip appears with a comforting animation: *"Take your time! Let's listen together."*
  - Incorrect choices are softly greyed out or reduced to 2 options (50/50 hint).
  - Master difficulty tier automatically adjusts down if repeated difficulty is detected.
