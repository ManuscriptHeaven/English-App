# Kids English Adventure — Manual Validation Master Checklist

## Purpose
This master operational checklist guides the end-to-end verification of the Kids English Adventure app on physical devices and representative hardware targets. Every item must be physically verified before certification for small real-child pilot testing.

---

## 1. Pre-Flight & Build Verification
- [ ] **Release APK Build**: `flutter build apk --release` completes successfully with 0 errors.
- [ ] **Asset Packaging**: All SVG illustrations, PNG badges, audio files, and Google Fonts load correctly offline.
- [ ] **Installation**: App installs cleanly on target devices without security or signature warnings.
- [ ] **Clean Boot**: First launch displays splash/welcome smoothly without blank screen delay ($<2.5\text{s}$).

---

## 2. Core Child Learning Journeys
- [ ] **Fresh Learner Journey**:
  - [ ] Profile creation (name entry, avatar selection).
  - [ ] Welcome by Pip with contextual dialogue bubble.
  - [ ] Adventure Home mission card displays initial state.
  - [ ] First session assembly (Warm-Up $\to$ Vocab Discovery $\to$ Game $\to$ Story $\to$ Rewards).
  - [ ] Session progress bar advances step by step.
  - [ ] Reward screen grants stars/coins idempotently.
  - [ ] Return to Home updates mission card with next step.
- [ ] **Struggling Child Journey**:
  - [ ] Consecutive mistakes ($\ge 2$) trigger supportive difficulty reduction.
  - [ ] Frequent hint requests ($\ge 3$) trigger Pip visual demonstration.
  - [ ] Three consecutive errors trigger `ConfidenceGuardian` "easy-win" injection.
  - [ ] Micro-session (2 activities) limits cognitive fatigue.
  - [ ] Tone remains warm and encouraging with zero punitive framing.
  - [ ] Gradual recovery allows learner to rebuild confidence.
- [ ] **Fast Learner Journey**:
  - [ ] High accuracy ($\ge 90\%$) with independent recall.
  - [ ] Evaluates `EvidenceComposite` criteria ($\ge 12$ attempts, $\ge 10$ indep, $\le 15\%$ hints).
  - [ ] Challenge difficulty (Level 3/4) unlocks appropriately on Day 1/2.
  - [ ] Distractor count expands to 4; auto-hint delay increases to 20s.
- [ ] **Returning Learner Journey**:
  - [ ] Simulates 7d, 14d, 30d absence.
  - [ ] Natural time decay reflects forgetting curve without cliff-drop.
  - [ ] Returnee grace dampens initial mistake penalties (halved to $0.06$).
  - [ ] Remembered words recover to familiar/mastered on first independent success.
- [ ] **Multi-Child Profile Switching**:
  - [ ] Create $\ge 3$ profiles (Ayaan, Maryam, Zayd).
  - [ ] Switch between profiles repeatedly.
  - [ ] Verify 100% isolation of mastery scores, active sessions, and rewards.
  - [ ] Force-close during profile switch restores active profile cleanly.

---

## 3. Hardware & Platform Resilience
- [ ] **Audio Subsystem**:
  - [ ] High volume, low volume, muted state.
  - [ ] Audio routes cleanly to device speaker and Bluetooth headphones.
  - [ ] Rapid button taps on audio icon do not overlap or glitch.
  - [ ] Audio stops immediately when navigating away or backgrounding.
- [ ] **Microphone & Speech Recognition**:
  - [ ] Permission granted: audio waveform / mic indicator functions.
  - [ ] Permission denied / permanently denied: graceful fallback to listening/tapping.
  - [ ] Low-end mic failure / silence: gentle Pip prompt to retry or tap.
  - [ ] Repeated mic errors ($\ge 2$) auto-switch activity away from speaking.
- [ ] **Network & Offline Behavior**:
  - [ ] App launches and functions 100% offline for core learning.
  - [ ] Network dropped mid-session does not crash or lose progress.
  - [ ] Network restored syncs telemetry seamlessly.
  - [ ] Talk-with-Pip handles offline state with child-friendly message.
- [ ] **Interruption & Process Death**:
  - [ ] Home button press, app switcher, lock screen.
  - [ ] Process force-stop mid-activity resumes at exact activity.
  - [ ] Interruption during reward dialog does not duplicate coins or XP.
- [ ] **Navigation & Back Button**:
  - [ ] Android system back button from Home, World, Game, Story, and Reward.
  - [ ] Confirmation dialog on attempting to abandon an active session.
  - [ ] Zero stack corruption or black screens on back navigation.

---

## 4. UI Ergonomics & Accessibility
- [ ] **Small Screen Hardening** ($<360\text{ dp}$ width):
  - [ ] Zero RenderFlex overflows.
  - [ ] No clipped text, dialogs, or action buttons.
  - [ ] Safe areas respected on notched and pinhole screens.
- [ ] **Display & Font Scaling** (100%, 150%, 200% accessibility scale):
  - [ ] Buttons and labels wrap cleanly without overlapping.
  - [ ] Child can still navigate and complete activities at large text scales.
- [ ] **Touch Targets**:
  - [ ] All interactive buttons satisfy minimum $48\times 48\text{ dp}$ child touch target.
  - [ ] Distractor choices have generous tap padding.
- [ ] **Child Safety Audit**:
  - [ ] Zero external web links accessible without parental gate.
  - [ ] No unprotected settings or developer debug overlays.
  - [ ] No free-form text input or unmoderated AI prompt fields.
