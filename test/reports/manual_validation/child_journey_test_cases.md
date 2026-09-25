# Kids English Adventure — Child Learning Journey Test Cases

## Purpose
Detailed step-by-step test scripts to evaluate real-device usability, emotional safety, adaptive response, and visual clarity across authentic child usage scenarios.

---

## Journey 1: Fresh Child Journey (First-Time User Onboarding)

### Preconditions
- Clean app install (no existing profiles or cached sessions).
- System volume at 70%.

### Test Steps & Expected Results
1. **Launch App**:
   - *Action*: Tap app icon on home screen.
   - *Expected*: Splash screen loads smoothly ($<2\text{s}$), leading into `WelcomeScreen` with cheerful child illustration, app title, and prominent "Start Adventure" button ($>56\text{ dp}$ height).
2. **Profile Setup**:
   - *Action*: Enter child name "Ayaan", select child avatar (e.g. Explorer Pip avatar), tap "Let's Go!".
   - *Expected*: Sound chime plays. Profile is created in local repository and `AdventureHomeScreen` displays with Ayaan's name and avatar.
3. **Adventure Home Inspection**:
   - *Action*: Observe Today's Mission card and World 1 (Animal Adventure).
   - *Expected*: "Today's Mission" highlights Step 1 of 4 with playful paw-print indicator (🐾). Pip bubble says: *"Welcome Ayaan! Let's explore the Animal World today! 🦁✨"*.
4. **Start Learning Session**:
   - *Action*: Tap "Start Mission" on the mission card.
   - *Expected*: Navigates to Step 1: Warm-Up activity with gentle introductory animal card ("Elephant").
5. **Vocabulary Discovery (Step 2)**:
   - *Action*: Tap audio button to hear "Elephant". Tap picture to reveal word.
   - *Expected*: Authentic audio pronunciation plays cleanly. Word appears in bold, child-friendly typography. Pip offers short encouragement: *"Can you say Elephant? 🐘"*.
6. **Interactive Game (Step 3 - Animal Hunt)**:
   - *Action*: Question asks: "Which animal is the Elephant?". Tap the correct image choice among 3 choices.
   - *Expected*: Green star sparkle animation, cheerful positive chime, Pip celebration bubble. Progress bar fills to Step 3.
7. **Story Reader (Step 4)**:
   - *Action*: Story screen opens ("The Kind Little Cat"). Swipe through 3 illustrated pages.
   - *Expected*: Page turns are fluid ($>55\text{ fps}$). Text is large, centered, and high contrast.
8. **Session Completion & Rewards**:
   - *Action*: Tap "Finish" after story.
   - *Expected*: Reward screen triggers with confetti animation. Ayaan earns 15 XP, 1 Star ⭐, and Pip gives a high-five animation.
9. **Return to Home**:
   - *Action*: Tap "Continue to Home".
   - *Expected*: Home mission card reflects completion (*"All done for today! Great job, Explorer!"*). Stars and XP in top app bar updated immediately.

---

## Journey 2: Struggling Child Journey (Anti-Frustration & Gentle Recovery)

### Preconditions
- Child profile selected: "Maryam" (age 4).
- Headless simulation or manual start with initial session.

### Test Steps & Expected Results
1. **Intentionally Miss Answers**:
   - *Action*: On interactive quiz question 1, deliberately select incorrect distractor.
   - *Expected*: Gentle wobble animation on chosen card (no harsh red crosses or buzzing "buzzer" sounds). Pip bubble: *"That was a good try! Let's look again together! ✨"*.
2. **Consecutive Error Handling**:
   - *Action*: Select incorrect answer a second time.
   - *Expected*: Distractor choice count reduces from 3 to 2. Subtle glowing hint outline surrounds the correct choice.
3. **Trigger Confidence Guardian Easy-Win**:
   - *Action*: On third consecutive error, observe activity transition.
   - *Expected*: Session drops to Support Tier (Difficulty Level 1). Next activity immediately presents a previously familiar/mastered concept ("Cat") to guarantee an easy win.
4. **Micro-Session Termination**:
   - *Action*: Complete the easy-win question correctly.
   - *Expected*: Session concludes as a micro-session (2 activities) to avoid child fatigue. Reward screen celebrates Maryam's effort with cheerful Pip dialogue (*"You worked so hard today, Maryam! Proud of you! 💖"*).
5. **Session Resume After Struggle**:
   - *Action*: Launch next session.
   - *Expected*: Session starts with Maximum Support Level and gentle visual scaffolding. No clinical "remedial" labels shown to child.

---

## Journey 3: Fast Learner Journey (Challenge Tier Elevation)

### Preconditions
- Child profile selected: "AyaanFast" (age 7).
- Clean learning profile.

### Test Steps & Expected Results
1. **Rapid Independent Recall**:
   - *Action*: Answer 12 consecutive questions correctly without requesting hints ($<3\text{s}$ latency per answer).
   - *Expected*: Streak bonuses activate ($+0.03$). Words rapidly advance from `learning` to `practicing` and `familiar`.
2. **Challenge Tier Activation**:
   - *Action*: Complete session 1 and start session 2 on Day 1.
   - *Expected*: `LearningSessionOrchestrator` evaluates `EvidenceComposite` ($\ge 12$ attempts, $\ge 10$ independent, $\le 15\%$ hints, avg mastery $\ge 0.75$). Difficulty elevates to Level 4 ("Super Challenge").
3. **Challenge Mechanics Verification**:
   - *Action*: Play interactive game in challenge tier.
   - *Expected*: Distractor count expands to 4 choices. Visual auto-hint delay increases to 20 seconds. Pip bubble says: *"Wow, look at you! You're a super star explorer! 🏆🚀"*.
4. **Curriculum Pacing**:
   - *Action*: Verify subsequent session composition.
   - *Expected*: Advanced prerequisite concepts unlock sequentially (e.g. `elephant` unlocks `heavy`/`big`).

---

## Journey 4: Returning Learner Journey (Hiatus & Grace Period)

### Preconditions
- Child profile with several mastered words.
- Simulated absence of 14 days (set via test clock or database timestamp).

### Test Steps & Expected Results
1. **Reopen App After Hiatus**:
   - *Action*: Launch app after 14 days of inactivity.
   - *Expected*: Welcome back message from Pip: *"Welcome back, explorer! I missed you! Ready to play? 🌟"*. No alarming "streak lost" or guilt-inducing warnings.
2. **Review Queue Prioritization**:
   - *Action*: Inspect Today's Mission card and start session.
   - *Expected*: Session seamlessly blends 2 review items alongside current learning content.
3. **Returnee Grace on Mistake**:
   - *Action*: On first decayed review item, answer incorrectly.
   - *Expected*: Score decreases by only $0.06$ (grace penalty halved from $0.12$), and consecutive error multiplier is suppressed (1.0). Child does not experience penalty shock.
4. **Immediate Recovery on Success**:
   - *Action*: On second review item, answer correctly with independent recall.
   - *Expected*: Score immediately recovers from decayed $0.61$ to $0.78$ (`familiar`), demonstrating that retained memory is promptly recognized.

---

## Journey 5: Multi-Child Profile Switching & Strict Isolation

### Preconditions
- 3 child profiles created on device: Ayaan (7), Maryam (4), Zayd (6).

### Test Steps & Expected Results
1. **Profile A Progress**:
   - *Action*: Switch to Ayaan. Complete 2 activities in session. Earn 30 XP.
   - *Expected*: Ayaan's total XP: 30. Mission card: Step 3 of 4.
2. **Rapid Switch to Profile B**:
   - *Action*: Open child profile selector, tap Maryam.
   - *Expected*: Maryam's dashboard loads instantly. XP shows Maryam's own XP (0). Mission card shows Maryam's own session (Step 1 of 2, Support Level). Zero bleed from Ayaan's session or vocabulary.
3. **Interleaved Force Kill**:
   - *Action*: Force close app while in Maryam's session. Relaunch app.
   - *Expected*: App launches directly into Maryam's active profile. Maryam's session resumes at Step 1.
4. **Switch to Profile C**:
   - *Action*: Switch to Zayd.
   - *Expected*: Zayd's independent avatar, unlocked worlds, and review queue load accurately.
