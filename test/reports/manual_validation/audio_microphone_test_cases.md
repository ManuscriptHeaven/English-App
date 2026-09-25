# Audio & Microphone Test Cases

## Kids English Adventure — Manual & Real-Device Validation Suite

This document defines specific test procedures, expected behaviors, and evaluation criteria for audio output, speech recognition input, permission flows, audio routing, and graceful educational fallbacks.

---

## Test Cases Summary

| ID | Title | Priority | Primary Focus |
|---|---|---|---|
| **AUDIO-01** | TTS Audio Output & Volume Balance | P1 | Pronunciation clarity, TTS speed, volume mixing |
| **AUDIO-02** | Phonics Sound Effects & Encouragement Chimes | P2 | Audio clipping, latency, concurrency with TTS |
| **AUDIO-03** | Audio Interruption & Backgrounding | P2 | OS notification, incoming call, app pause/resume |
| **MIC-01** | First-Time Microphone Permission Grant | P1 | Permission prompt UX, immediate STT activation |
| **MIC-02** | Microphone Permission Denial & Graceful Fallback | P0 | Soft fallback, no blocker, tap/choice alternative |
| **MIC-03** | Permanent Permission Denial & Settings Prompt | P1 | Child-friendly guidance, alternative input mode |
| **MIC-04** | Speech Recognition Timeout & Silence Handling | P1 | 5s/8s timeout, encouragement prompt, no freeze |
| **MIC-05** | Child Speech Pitch & Pacing Tolerance | P1 | High pitch, elongated syllables, soft voice |
| **MIC-06** | Ambient Noise Resilience | P2 | TV/household chatter in background, SNR handling |
| **MIC-07** | Repeated STT Failure & ConfidenceGuardian Integration | P1 | Consecutive failed attempts trigger assistance/fallback |

---

## Detailed Test Procedures

### AUDIO-01: TTS Audio Output & Volume Balance
- **Objective**: Verify that Pip's voice and vocabulary pronunciation are crystal-clear, pleasantly paced for 4–8 year olds, and audible above UI sounds.
- **Preconditions**: Device volume set to 50%. App launched in Forest World.
- **Steps**:
  1. Launch app and listen to Pip's onboarding greeting on the Home/World screen.
  2. Tap the "Repeat / Listen" audio button on a vocabulary card (e.g., "Apple" or "Sun").
  3. Listen to the word pronunciation, example sentence, and phonics breakdown.
  4. Adjust device volume from 10% to 100% and test mute switch toggle.
- **Expected Results**:
  - TTS speech rate is appropriate for young children (approximately 0.8–0.85x normal adult speed).
  - No distortion, crackling, or harsh frequency peaks at high volume.
  - Toggling mute switch respects platform conventions (mutes media on iOS/Android unless explicitly overridden).
  - Sound effects (chimes, button clicks) do not drown out Pip's voice.

### AUDIO-02: Phonics Sound Effects & Encouragement Chimes
- **Objective**: Ensure that SFX triggers do not clip, distort, or cause stutter during interactive activities.
- **Preconditions**: Sound effects enabled in settings.
- **Steps**:
  1. Complete a flashcard or phonics match activity.
  2. Rapidly tap correct and incorrect options to trigger multiple audio chimes.
  3. Complete an activity session and verify the celebration chime and star reward sound.
- **Expected Results**:
  - SFX audio does not cut off mid-playback abruptly unless intentionally superseded.
  - No noticeable audio lag/latency (>150ms between tap and sound).
  - Frame rate remains smooth during concurrent SFX and particle animation playback.

### AUDIO-03: Audio Interruption & Backgrounding
- **Objective**: Verify audio behavior when external system audio interrupts the app.
- **Preconditions**: App is actively playing a vocabulary pronunciation or session instruction.
- **Steps**:
  1. Simulate an incoming phone call, alarm, or trigger Google Assistant / Siri.
  2. Background the app while audio is playing.
  3. Reopen the app.
- **Expected Results**:
  - App immediately pauses or ducks audio upon interruption.
  - Backgrounded app does not continue looping audio unexpectedly.
  - Resuming the app restores audio session without crashes, audio buffer underflow, or permanent silence.

---

### MIC-01: First-Time Microphone Permission Grant
- **Objective**: Validate the UX when the microphone is requested for the first time during a speech activity.
- **Preconditions**: Fresh app install or app permissions reset in OS Settings.
- **Steps**:
  1. Navigate to a Speaking / Pronunciation activity in an active session.
  2. Pip prompts: *"Can you say 'Apple'?"*
  3. Observe pre-permission explanatory dialog (if shown) and OS permission dialog.
  4. Tap "While using the app" / "Allow".
  5. Speak the target word clearly into the microphone.
- **Expected Results**:
  - System permission prompt appears cleanly with clear context.
  - Immediately after granting, the mic listening indicator (pulsing mic or audio wave) animates.
  - Child's speech is recognized and processed without requiring a restart or navigating away.

### MIC-02: Microphone Permission Denial & Graceful Fallback
- **Objective**: Ensure child is never blocked or trapped when microphone access is denied.
- **Preconditions**: Microphone permission revoked or fresh install.
- **Steps**:
  1. Enter a Speaking activity.
  2. On the OS permission prompt, tap "Don't allow" / "Deny".
  3. Observe app reaction and screen state.
- **Expected Results**:
  - **No raw technical error, crash, or blank screen.**
  - Pip provides warm fallback message: *"That's okay! We can play another way!"*
  - Activity immediately provides an alternative input mode: Tap-to-match, Multiple Choice, or Listen-and-Pick.
  - The child can complete the session and earn progress without a functioning mic.

### MIC-03: Permanent Permission Denial & Settings Prompt
- **Objective**: Verify respectful behavior when permission is permanently denied ("Don't ask again").
- **Preconditions**: Permission set to "Deny & don't ask again" in OS settings.
- **Steps**:
  1. Enter a Speaking activity or tap the microphone button.
  2. Observe screen behavior.
- **Expected Results**:
  - App does NOT enter an infinite permission-request loop.
  - Clean parent-facing option provided (e.g. "Open Settings to enable microphone" behind a parent gate, or automatic switch to touch-only mode for the child).
  - Session continues seamlessly using touch modalities.

### MIC-04: Speech Recognition Timeout & Silence Handling
- **Objective**: Verify proper handling when child remains silent or pauses before speaking.
- **Preconditions**: Mic enabled, enter speaking activity.
- **Steps**:
  1. Mic begins listening for target word.
  2. Remain completely silent for 6–8 seconds.
- **Expected Results**:
  - Listening indicator pulses gently without flashing aggressively.
  - At timeout (typically 5–7s), app does not treat silence as a harsh failure or penalize mastery heavily.
  - Pip gives an encouraging prompt: *"I didn't hear you. Want to try again, or tap the picture?"*
  - Alternative option to tap or retry is presented clearly.

### MIC-05: Child Speech Pitch & Pacing Tolerance
- **Objective**: Verify speech recognition tolerance for natural young-child vocal characteristics.
- **Preconditions**: Testing on physical device with real human voice.
- **Steps**:
  1. Speak target words using typical child speech patterns:
     - High-pitched vocalization (300–450 Hz range).
     - Elongated vowels (e.g., *"Aaaapple"*).
     - Soft, quiet voice (~40–50 dB).
     - Variable pacing with pauses between phonemes.
- **Expected Results**:
  - Basic phonetic approximations are accepted where educational criteria permit.
  - Soft voices are picked up by the audio buffer without premature cutoff.
  - Recognition confidence scoring is calibrated for children, avoiding unfair rejects.

### MIC-06: Ambient Noise Resilience
- **Objective**: Test performance in realistic domestic or classroom environments.
- **Preconditions**: Background noise present (talking in room, TV playing at moderate volume 2 meters away).
- **Steps**:
  1. Speak the target word into the device at arm's length (30–40 cm).
  2. Observe STT accuracy and false positive rate when background noise is present.
- **Expected Results**:
  - Background talking does not falsely trigger unintended word matches.
  - If background noise drowns out the voice, app gently offers retry or tap fallback rather than registering a series of errors.

### MIC-07: Repeated STT Failure & ConfidenceGuardian Integration
- **Objective**: Ensure ConfidenceGuardian intervenes if speech recognition fails 2+ times in succession.
- **Preconditions**: Active session with ConfidenceGuardian tracking real-time session events.
- **Steps**:
  1. Intentionally fail or remain silent for 2 consecutive speaking attempts on the same vocabulary word.
  2. Observe Pip's reaction and the activity presentation.
- **Expected Results**:
  - `ConfidenceGuardian` registers hesitation/frustration signal.
  - Pip displays a comforting animation and offers a supportive hint or audio demonstration: *"Listen closely with Pip!"*
  - App reduces difficulty tier or seamlessly pivots to a recognition/matching activity to preserve the child's emotional momentum.
  - Child profile records evidence accurately without demoralizing penalties.
