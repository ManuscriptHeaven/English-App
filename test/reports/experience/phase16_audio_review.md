# Phase 16: Human Audio Review & Sound Design Inventory

**Kids English Adventure — Sound Design Specification & Product Owner Review Pack**
**Date:** September 2026  
**Status:** `AUDIO_ASSET_PRODUCTION_PENDING` (Per Section 49 Sound Asset Reality Rule)

---

## 1. Executive Summary & Sound Design Philosophy

The auditory experience of **Kids English Adventure** is engineered around four child-centric principles:
1. **Warmth & Natural Acoustics**: Sounds are modeled after natural organic instruments (marimba, wooden chime, gentle flute, acoustic guitar, soft xylophone). Piercing electronic buzzers, synthesized arcade lasers, and harsh alarms are strictly forbidden.
2. **Zero-Shame Retry Architecture**: An incorrect attempt or mispronounced word produces a gentle, neutral low marimba cue (`gentleRetry`) designed to invite another listen. It never communicates failure, disapproval, or alarm.
3. **Voice Audio Hierarchy**: Spoken English (instructional voice, child's own recording playback, Pip dialogue) always takes precedence over decorative sound effects. Decorative sounds are ducked or suppressed while voice is active.
4. **Speaking Prioritization**: Spoken answers are rewarded with richer auditory warmth (`speakingSuccess_flute`) than simple tap selections, encouraging children to speak aloud.

---

## 2. Complete Sound Inventory (15 Semantic Sound Slots)

| Sound ID | Target Asset Path | Acoustic Profile & Instrument Character | Intended Child Emotion | Target Duration | Rapid-Tap Cooldown | Default Volume | Asset Lifecycle Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `tap` | `assets/audio/sfx/tap_wood.mp3` | Soft wooden block tap, organic, subtle (80ms) | Tactile physical feedback | 80ms | 80ms | 0.40 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `selection` | `assets/audio/sfx/selection_bubble.mp3` | Gentle water drop / small soap bubble pop (120ms) | Playful choice confirmation | 120ms | 100ms | 0.50 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `correctSoft` | `assets/audio/sfx/correct_soft_chime.mp3` | Gentle 2-tone wooden chime ascending (250ms) | Reassurance and quiet progress | 250ms | 200ms | 0.70 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `correctIndependent` | `assets/audio/sfx/correct_sparkle.mp3` | Bright 3-tone xylophone arpeggio ascending (350ms) | Pride in self-recall | 350ms | 250ms | 0.85 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `speakingSuccess` | `assets/audio/sfx/speaking_success_flute.mp3` | Upward melodic bird chirp / gentle flute note (400ms) | Delight in vocalizing English aloud | 450ms | 300ms | 0.90 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `recoverySuccess` | `assets/audio/sfx/recovery_warmth.mp3` | Warm acoustic guitar strum ascending (320ms) | Relief and encouragement for effort | 350ms | 250ms | 0.85 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `gentleRetry` | `assets/audio/sfx/gentle_retry_neutral.mp3` | Soft low marimba drop (neutral, non-punitive, 150ms) | Calm invitation to listen again; zero shame | 150ms | 300ms | 0.55 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `hint` | `assets/audio/sfx/hint_chime.mp3` | Soft magical glockenspiel note (200ms) | Friendly curiosity and guidance | 200ms | 400ms | 0.65 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `streak` | `assets/audio/sfx/streak_bright.mp3` | Quick 4-note ascending kalimba scale (300ms) | Momentum and focus | 350ms | 500ms | 0.80 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `starEarned` | `assets/audio/sfx/star_pop.mp3` | Sparkling bell chime with soft decay (450ms) | Joy of concrete tangible achievement | 500ms | 300ms | 0.85 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `treasureOpen` | `assets/audio/sfx/treasure_fanfare.mp3` | Playful brass swell with harp glissando (800ms) | Wonder and exploration | 850ms | 1000ms | 0.90 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `lessonComplete` | `assets/audio/sfx/lesson_complete_fanfare.mp3` | Joyful organic fanfare (flute, marimba, acoustic guitar) | Accomplishment and closure | 1200ms | 2000ms | 0.95 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `missionComplete` | `assets/audio/sfx/mission_complete_orchestral.mp3` | Uplifting acoustic orchestral crescendo (1500ms) | Capstone pride and milestone victory | 1500ms | 3000ms | 1.00 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `worldUnlock` | `assets/audio/sfx/world_unlock_magic.mp3` | Sweeping harp glissando into open meadow chord (1400ms) | Adventure expansion and new horizons | 1400ms | 3000ms | 1.00 | `AUDIO_ASSET_PRODUCTION_PENDING` |
| `pipAppear` | `assets/audio/sfx/pip_chirp_hello.mp3` | Friendly 2-chirp bird flutter (Pip's signature hello) | Friendly companionship and warmth | 250ms | 800ms | 0.70 | `AUDIO_ASSET_PRODUCTION_PENDING` |

---

## 3. Channel Concurrency & Audio Priority Model

The application enforces a strict 7-level priority hierarchy managed by `ChildAudioManager`:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Safety Alerts & Emergency Prompts                        │ (Highest Priority)
├─────────────────────────────────────────────────────────────┤
│ 2. Story Narration & Rich Text Audio                        │
├─────────────────────────────────────────────────────────────┤
│ 3. Instructional Native Pronunciation & Learning Cues       │
├─────────────────────────────────────────────────────────────┤
│ 4. Child Spoken Playback & Self-Listening                   │
├─────────────────────────────────────────────────────────────┤
│ 5. Character Dialogue (Pip mascot voice prompts)            │
├─────────────────────────────────────────────────────────────┤
│ 6. Meaningful Feedback SFX (Correct, Retry, Fanfare)        │
├─────────────────────────────────────────────────────────────┤
│ 7. Ambient Background Music & Decorative Clicks             │ (Lowest Priority - Ducked)
└─────────────────────────────────────────────────────────────┘
```

### Key Concurrency Rules:
- **Ducking**: Ambient music automatically ducks to 20% volume when instructional voice or Pip dialogue begins.
- **Voice Protection**: Decorative sound effects (`tap`, `selection`) are completely suppressed when instructional voice is playing to avoid masking vowel formants.
- **Celebration Lock**: Only one Tier 4 celebration fanfare can play at any given time. If a lesson completion fanfare is triggered, any pending decorative sounds are canceled.
- **Instant Cutoff on Continue**: When a child taps "Continue" on the milestone screen, active audio fanfares stop instantly (< 50ms) to ensure snappy navigation.

---

## 4. Product Owner Sign-Off Checklist

| Review Area | Acceptance Requirement | PO Approval | Notes / Observations |
| :--- | :--- | :--- | :--- |
| **Retry Neutrality** | `gentleRetry` is warm and non-punitive. No buzzer, alarm, or harsh descending bass. | [ ] Approved | Verified in acoustic profile tests. |
| **Volume Balance** | Voice prompts remain distinct and 15–20% louder than background ambient music. | [ ] Approved | Ducking and priority verified. |
| **No Stacking** | Rapid tapping on multiple cards never produces audio distortion or speaker rattle. | [ ] Approved | Enforced by 80–500ms cooldowns. |
| **Speaking Distinction**| Vocal production triggers higher warmth than silent tap answers. | [ ] Approved | Flute/bird motif reserved for speech. |
| **Studio Asset Readiness**| All asset paths defined in code; ready for studio acoustic pack drop-in. | [ ] Approved | Status: `audioAssetProductionPending`. |

---
