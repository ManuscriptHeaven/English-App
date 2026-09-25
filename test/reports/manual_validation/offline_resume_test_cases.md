# Offline, Interruption & Continuity Test Cases

## Kids English Adventure — Manual & Real-Device Validation Suite

This document defines specific test procedures, expected behaviors, and evaluation criteria for offline operation, airplane mode transitions, mid-session backgrounding, force-close recovery, and conversational offline fallbacks.

---

## Test Cases Summary

| ID | Title | Priority | Primary Focus |
|---|---|---|---|
| **OFF-01** | Full Offline Cold Launch (Airplane Mode) | P0 | Local asset loading, Hive DB initialization, no network spinner |
| **OFF-02** | Mid-Session Network Drop | P0 | In-memory session preservation, offline event buffering |
| **OFF-03** | Network Reconnection & Idempotency | P1 | Safe recovery, no duplicate rewards, sync queue drain |
| **OFF-04** | "Talk with Pip" Local Fallback | P0 | Pre-scripted dialogue trees, zero HTTP/socket errors shown |
| **RES-01** | App Backgrounding & Immediate Resume | P1 | State restoration, audio pause/resume, no reload jump |
| **RES-02** | Memory Pressure & Extended Background Pause | P1 | Session checkpoint restoration, state reconstruction |
| **RES-03** | Force-Kill Recovery Mid-Activity | P0 | No DB corruption, partial progress saved, clean resume flow |
| **RES-04** | Reward Idempotency on Abrupt Restart | P0 | Completed activity stars/stickers cannot be duplicated |

---

## Detailed Test Procedures

### OFF-01: Full Offline Cold Launch (Airplane Mode)
- **Objective**: Ensure the entire core learning experience functions completely without an internet connection.
- **Preconditions**: Device placed in Airplane Mode (Wi-Fi and Cellular OFF). App killed and cold-started.
- **Steps**:
  1. Turn on Airplane Mode. Verify zero network connectivity.
  2. Tap app icon to launch Kids English Adventure.
  3. Select child profile (e.g., Leo).
  4. Launch an Adventure Brain recommended session from Forest World.
  5. Complete 3 activities in the session.
- **Expected Results**:
  - App launches immediately with no indefinite loading spinners or "Network Error" banners.
  - Profile selection, avatar rendering, world map, and all local assets load smoothly.
  - Adventure Brain recommendation engine calculates recommendations locally using Hive mastery records.
  - Activities run to completion without network timeouts or stalls.

### OFF-02: Mid-Session Network Drop
- **Objective**: Verify that sudden disconnection during active gameplay causes zero stutter or disruption.
- **Preconditions**: Device connected to Wi-Fi. Child starts a multi-activity learning session.
- **Steps**:
  1. Begin Activity 2 of a 4-activity session.
  2. While child is interacting with the screen, abruptly disable Wi-Fi (e.g., toggle Wi-Fi OFF in Quick Settings).
  3. Complete Activity 2 and transition into Activity 3.
- **Expected Results**:
  - Zero UI freezing or dropped frames during network state transition.
  - Next activity loads seamlessly from local curriculum bundle.
  - Learning evidence (accuracy, latency, hints) is written to local storage without failure.

### OFF-03: Network Reconnection & Idempotency
- **Objective**: Verify that restoring connectivity after offline play synchronizes state idempotently without duplicate rewards.
- **Preconditions**: Device played offline for 1 session, earning 5 stars and 1 sticker.
- **Steps**:
  1. Re-enable Wi-Fi on the device.
  2. Observe background sync behavior (if cloud sync or analytics enabled).
  3. Check star balance, reward inventory, and vocabulary mastery levels.
- **Expected Results**:
  - Star balance and sticker collection remain strictly identical (stars earned offline are not double-counted or lost).
  - Vocabulary mastery levels remain consistent with offline recorded evidence.
  - No disruptive modal or toast ("Connected to Internet") interrupts the child's gameplay.

### OFF-04: "Talk with Pip" Local Fallback
- **Objective**: Ensure conversational activities (Talk with Pip / Free Chat) gracefully degrade to deterministic offline dialogue trees when cloud services are unreachable.
- **Preconditions**: Device in Airplane mode. Child navigates to "Talk with Pip" screen.
- **Steps**:
  1. Open "Talk with Pip".
  2. Speak or tap a prompt: *"Hello Pip! What is your favorite animal?"*
  3. Wait for Pip's response.
- **Expected Results**:
  - **Zero technical error messages** (no `SocketException`, `HttpException 500`, `Connection failed`, or blank speech bubble).
  - Pip responds using warm, pre-scripted local offline dialogue: *"I love birds like me! Let's explore more animals together in the Forest!"*
  - Dialogue options guide the child to interactive offline practice or fun pre-recorded conversational prompts.
  - Speech synthesis (TTS) continues to speak Pip's local response clearly.

---

### RES-01: App Backgrounding & Immediate Resume
- **Objective**: Verify that brief interruptions (pressing Home button, switching apps, receiving an alarm) do not restart or lose current progress.
- **Preconditions**: Child is in the middle of Question 3 of a vocabulary matching activity.
- **Steps**:
  1. Press device Home button or swipe to home screen.
  2. Wait 15 seconds.
  3. Tap app icon to resume.
- **Expected Results**:
  - App returns instantly to Question 3 exactly as left.
  - Any playing audio is cleanly resumed or Pip prompts: *"Welcome back! Let's keep going!"*
  - Touch input is immediately responsive.

### RES-02: Memory Pressure & Extended Background Pause
- **Objective**: Verify state preservation when OS reclaims memory after extended backgrounding.
- **Preconditions**: Session in progress. Device has multiple heavy apps running concurrently.
- **Steps**:
  1. Background Kids English Adventure mid-session.
  2. Launch heavy 3D games or camera app to trigger low-memory conditions.
  3. Return to Kids English Adventure after 5 minutes.
- **Expected Results**:
  - If app process was maintained: Screen restores seamlessly.
  - If app process was terminated by OS: App restores to a friendly checkpoint or World Map with Pip greeting: *"Great to see you again! Would you like to finish your Forest adventure?"*
  - No black screen, infinite loading state, or corrupt partial state.

### RES-03: Force-Kill Recovery Mid-Activity
- **Objective**: Ensure crash or force-kill during active learning preserves integrity and cleanly recovers.
- **Preconditions**: Child has completed 2 of 4 activities in a session.
- **Steps**:
  1. Swipe away the app in OS task switcher to force-kill process.
  2. Relaunch app.
  3. Select the same child profile.
- **Expected Results**:
  - Hive database loads with zero corruption.
  - Completed activities from the interrupted session retain their recorded mastery evidence and stars.
  - Adventure Brain offers either a session resume prompt or generates a freshly calibrated session reflecting the latest mastery state.

### RES-04: Reward Idempotency on Abrupt Restart
- **Objective**: Ensure stars, badges, and unlockables cannot be exploited or duplicated via repeated restarts.
- **Preconditions**: Child finishes a session and sees the celebration reward screen (3 stars awarded).
- **Steps**:
  1. As star animation finishes, immediately force-close the app before tapping "Continue".
  2. Relaunch the app and examine star balance.
  3. Complete the next activity.
- **Expected Results**:
  - The stars awarded for the completed activity are credited exactly once.
  - Relaunching does not credit a second batch of stars or wipe the earned stars.
  - Total stars match `earned_stars = initial_stars + session_stars`.
