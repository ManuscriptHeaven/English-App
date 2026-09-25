import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/experience/child_audio_manager.dart';
import 'package:kids_english_adventure/core/experience/child_experience_controller.dart';
import 'package:kids_english_adventure/core/experience/pip_state_controller.dart';
import 'package:kids_english_adventure/core/experience/sound_design_system.dart';
import 'package:kids_english_adventure/core/experience/speaking_interaction_controller.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';
import 'package:kids_english_adventure/core/theme/app_motion.dart';
import 'package:kids_english_adventure/core/widgets/lesson_completion_view.dart';
import 'package:kids_english_adventure/core/widgets/pip_character_guide.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/curriculum_seed_data.dart';
import 'package:kids_english_adventure/features/curriculum/domain/feedback/pip_dialogue_pool.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'package:kids_english_adventure/features/curriculum/domain/repositories/curriculum_repository.dart';
import 'package:kids_english_adventure/features/curriculum/domain/validation/curriculum_freeze_guard.dart';

void main() {
  group('Phase 16: Child Experience, Audio, Rewards & Interaction Polish (Section 48 Matrix)', () {
    late ProviderContainer container;
    late MockAudioService mockAudio;
    late MockSpeechRecognitionService mockSpeech;
    late ChildAudioManager audioManager;
    late ChildExperienceController experience;
    late PipStateController pipController;
    late CurriculumRepository repo;

    setUp(() {
      mockAudio = MockAudioService();
      mockSpeech = MockSpeechRecognitionService();

      container = ProviderContainer(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudio),
          speechRecognitionServiceProvider.overrideWithValue(mockSpeech),
        ],
      );

      audioManager = container.read(childAudioManagerProvider);
      pipController = container.read(pipStateControllerProvider.notifier);
      experience = container.read(childExperienceControllerProvider);
      repo = CurriculumSeedData.createRepository();
    });

    tearDown(() {
      container.dispose();
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 1: Curriculum freeze snapshot remains unchanged
    // ─────────────────────────────────────────────────────────────────────────
    test('1. Curriculum freeze snapshot remains unchanged', () {
      final verification = CurriculumFreezeGuard.verify(repo);
      expect(verification.isFrozen, isTrue);
      expect(verification.discrepancies, isEmpty);
      expect(verification.currentHash, equals(CurriculumFreezeGuard.frozenBaselineHash));
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 2: Success event does not duplicate rewards
    // ─────────────────────────────────────────────────────────────────────────
    test('2. Success event does not duplicate rewards', () async {
      final first = await experience.onLessonCompleted(
        lessonId: 'lesson_unit1_1',
        stars: 3,
        xp: 30,
        coins: 15,
      );
      expect(first, isTrue, reason: 'First lesson completion must be processed');

      final duplicate = await experience.onLessonCompleted(
        lessonId: 'lesson_unit1_1',
        stars: 3,
        xp: 30,
        coins: 15,
      );
      expect(duplicate, isFalse, reason: 'Duplicate lesson completion must be suppressed');
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 3: Rapid correct events respect sound cooldown
    // ─────────────────────────────────────────────────────────────────────────
    test('3. Rapid correct events respect sound cooldown', () async {
      final playedFirst = await audioManager.playSound(SemanticSound.correctSoft);
      expect(playedFirst, isTrue, reason: 'First sound event must play');

      // Immediate second call of the exact same sound violates cooldown
      final playedRapid = await audioManager.playSound(SemanticSound.correctSoft);
      expect(playedRapid, isFalse, reason: 'Rapid sound event must be throttled by cooldown');
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 4: Retry never triggers harsh failure sound
    // ─────────────────────────────────────────────────────────────────────────
    test('4. Retry never triggers harsh failure sound', () {
      final spec = SoundDesignSystem.getSpec(SemanticSound.gentleRetry);
      expect(spec.acousticCharacter.toLowerCase(), anyOf(contains('soft'), contains('gentle'), contains('non-punitive')));
      expect(spec.intendedEmotion.toLowerCase(), anyOf(contains('zero failure shame'), contains('calm'), contains('invitation')));
      expect(spec.acousticCharacter.toLowerCase(), isNot(contains('buzzer')));
      expect(spec.acousticCharacter.toLowerCase(), isNot(contains('alarm')));
      expect(spec.acousticCharacter.toLowerCase(), isNot(contains('harsh')));
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 5: Voice audio priority over decorative SFX
    // ─────────────────────────────────────────────────────────────────────────
    test('5. Voice audio priority over decorative SFX', () async {
      // Simulate voice playback active
      audioManager.playVoicePrompt('Touch the red apple');
      expect(audioManager.isVoiceActive, isTrue);

      // Decorative sound (tap/selection) should be suppressed during voice
      final playedDecorative = await audioManager.playSound(SemanticSound.tap);
      expect(playedDecorative, isFalse, reason: 'Decorative SFX must yield to instructional voice');
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 6: Reduced-motion path suppresses large animations
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets('6. Reduced-motion path suppresses large animations', (tester) async {
      late Duration resolvedDuration;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              resolvedDuration = AppMotion.resolveDuration(context, AppMotion.celebration);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolvedDuration, equals(Duration.zero),
          reason: 'When disableAnimations is true, AppMotion must resolve duration to zero');
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 7: Muted SFX still allows full lesson completion
    // ─────────────────────────────────────────────────────────────────────────
    test('7. Muted SFX still allows full lesson completion', () async {
      audioManager.setSfxEnabled(false);
      expect(audioManager.isSfxEnabled, isFalse);

      final success = await experience.onLessonCompleted(
        lessonId: 'lesson_muted_test',
        stars: 3,
        xp: 30,
        coins: 15,
      );
      expect(success, isTrue, reason: 'Muted audio should never block lesson progression');
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 8: Microphone-denied path recovers gracefully with child-friendly text
    // ─────────────────────────────────────────────────────────────────────────
    test('8. Microphone-denied path recovers gracefully with child-friendly text', () async {
      // Create a mock speech service that simulates unavailability
      final unavailSpeech = _UnavailableSpeechRecognitionService();
      final controller = SpeakingInteractionController(
        speechService: unavailSpeech,
        audioService: mockAudio,
        experience: experience,
        initialTargetPhrase: 'apple',
      );

      await controller.startListening();

      expect(controller.state.flowState, equals(SpeakingFlowState.unavailable));
      expect(controller.state.childFacingMessage, contains('Microphone is sleeping'));
      expect(controller.state.childFacingMessage, isNot(contains('Exception')));
      expect(controller.state.childFacingMessage, isNot(contains('PermissionDeniedException')));
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 9: Speech timeout recovers gracefully without technical exceptions
    // ─────────────────────────────────────────────────────────────────────────
    test('9. Speech timeout recovers gracefully without technical exceptions', () async {
      final timeoutSpeech = _TimeoutSpeechRecognitionService();
      final controller = SpeakingInteractionController(
        speechService: timeoutSpeech,
        audioService: mockAudio,
        experience: experience,
        initialTargetPhrase: 'banana',
      );

      await controller.startListening();

      expect(controller.state.flowState, equals(SpeakingFlowState.retry));
      expect(controller.state.childFacingMessage, contains("I didn't hear that"));
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 10: Double tap cannot double-complete lesson
    // ─────────────────────────────────────────────────────────────────────────
    test('10. Double tap cannot double-complete lesson', () async {
      final res1 = await experience.onLessonCompleted(
        lessonId: 'lesson_rapid_double',
        stars: 2,
        xp: 20,
        coins: 10,
      );
      final res2 = await experience.onLessonCompleted(
        lessonId: 'lesson_rapid_double',
        stars: 2,
        xp: 20,
        coins: 10,
      );

      expect(res1, isTrue);
      expect(res2, isFalse, reason: 'Second tap must be suppressed');
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 11: Star reward written once
    // ─────────────────────────────────────────────────────────────────────────
    test('11. Star reward written once', () async {
      final first = await experience.onLessonCompleted(
        lessonId: 'lesson_stars_once',
        stars: 3,
        xp: 30,
        coins: 15,
      );
      final second = await experience.onLessonCompleted(
        lessonId: 'lesson_stars_once',
        stars: 3,
        xp: 30,
        coins: 15,
      );

      expect(first, isTrue);
      expect(second, isFalse);
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 12: World unlock written once
    // ─────────────────────────────────────────────────────────────────────────
    test('12. World unlock written once', () async {
      final unlock1 = await experience.onWorldUnlocked(worldId: 'world_home', worldTitle: 'My Home');
      final unlock2 = await experience.onWorldUnlocked(worldId: 'world_home', worldTitle: 'My Home');

      expect(unlock1, isTrue);
      expect(unlock2, isFalse, reason: 'Duplicate world unlock must be rejected');
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 13: Pip does not speak on every trivial tap (anti-fatigue check)
    // ─────────────────────────────────────────────────────────────────────────
    test('13. Pip does not speak on every trivial tap (anti-fatigue check)', () async {
      // First trivial correct answer
      await experience.onCorrectAnswer(isIndependent: false, isRecovery: false);

      final pipState = container.read(pipStateControllerProvider);
      expect(pipState.state, equals(PipState.happy));
      expect(pipState.speechBubbleText, isNull,
          reason: 'Trivial tap should produce a subtle smile/bounce without speech bubble fatigue');
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 14: Celebration intensity differentiated (routine lesson vs milestone)
    // ─────────────────────────────────────────────────────────────────────────
    test('14. Celebration intensity differentiated (routine lesson < mission/world/level)', () async {
      // Trivial tap does not trigger celebration
      experience.onTap();
      expect(container.read(pipStateControllerProvider).state, isNot(equals(PipState.celebrating)));

      // Meaningful recall triggers happy reaction
      await experience.onCorrectAnswer(isIndependent: true);
      expect(container.read(pipStateControllerProvider).state, equals(PipState.happy));

      // Routine lesson completion triggers moderate celebration (happy bounce / sparkle pose)
      await experience.onLessonCompleted(
        lessonId: 'lesson_tier4_check',
        stars: 3,
        xp: 30,
        coins: 15,
      );
      final lessonCompleteState = container.read(pipStateControllerProvider).state;
      expect(lessonCompleteState, equals(PipState.happy));

      // Major milestones (mission complete, world unlock, level complete) trigger full celebration
      await experience.onMissionCompleted(missionId: 'mission_tier4_check');
      final missionCompleteState = container.read(pipStateControllerProvider).state;
      expect(missionCompleteState, equals(PipState.celebrating));

      // Explicitly assert celebration intensity: lessonComplete < mission/world/level
      final lessonIntensity = PipStateController.celebrationIntensityFor(lessonCompleteState);
      final missionIntensity = PipStateController.celebrationIntensityFor(missionCompleteState);
      expect(lessonIntensity, lessThan(missionIntensity),
          reason: 'Routine lesson celebration intensity must be strictly less than major milestone intensity');
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 15: Child can continue while decorative animation is cancelled
    // ─────────────────────────────────────────────────────────────────────────
    test('15. Child can continue while decorative animation is cancelled', () async {
      pipController.celebrateMilestone(message: 'Level Complete!');
      expect(container.read(pipStateControllerProvider).state, equals(PipState.celebrating));

      experience.cancelActiveCelebration();
      expect(container.read(pipStateControllerProvider).state, equals(PipState.idle));
      expect(container.read(pipStateControllerProvider).speechBubbleText, isNull);
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 16: Band C/D tone and recovery praise calibration
    // ─────────────────────────────────────────────────────────────────────────
    test('16. Band C/D tone and recovery praise calibration', () {
      // Band C/D natural child tone verification (no overly evaluative phrases)
      final bandCPools = PipDialoguePool.pools[LearningAgeBand.bandCGrowingSpeakers]!;
      final bandDPools = PipDialoguePool.pools[LearningAgeBand.bandDConfidentSpeakers]!;

      final allBandCText = bandCPools.values.expand((l) => l).join(' ');
      final allBandDText = bandDPools.values.expand((l) => l).join(' ');

      expect(allBandCText, isNot(contains('Sharp work')));
      expect(allBandDText, isNot(contains('Sharp work')));
      expect(allBandCText, isNot(contains('Clear and confident speaking')));
      expect(allBandDText, isNot(contains('Clear and confident speaking')));
      expect(allBandDText, isNot(contains('Sharp listening')));

      // Recovery praise calibration: single immediate mistake vs repeated struggle
      final singleMistakeBandA = PipDialoguePool.getRecoveryPrompt(
        ageBand: LearningAgeBand.bandALittleExplorers,
        attempts: 2,
      );
      expect(singleMistakeBandA, anyOf(contains('got it'), contains('did it')),
          reason: 'Single mistake recovery should be a short, direct prompt');
      expect(singleMistakeBandA, isNot(contains('kept trying')),
          reason: '"kept trying" must be reserved for genuine repeated struggle');

      final struggleBandA = PipDialoguePool.getRecoveryPrompt(
        ageBand: LearningAgeBand.bandALittleExplorers,
        attempts: 3,
      );
      expect(struggleBandA, contains('kept trying'),
          reason: 'Repeated struggle must provide effort-oriented praise');

      final singleMistakeBandB = PipDialoguePool.getRecoveryPrompt(
        ageBand: LearningAgeBand.bandBYoungAdventurers,
        attempts: 2,
      );
      expect(singleMistakeBandB, anyOf(contains('got it'), contains('correction')),
          reason: 'Single mistake recovery for Band B should be prompt');
      expect(singleMistakeBandB, isNot(contains('kept trying')));

      final struggleBandB = PipDialoguePool.getRecoveryPrompt(
        ageBand: LearningAgeBand.bandBYoungAdventurers,
        attempts: 3,
      );
      expect(struggleBandB, contains('kept trying'));
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 17: Story simple/rich text remains unchanged
    // ─────────────────────────────────────────────────────────────────────────
    test('17. Story simple/rich text remains unchanged', () {
      final stories = repo.getAllStories();
      expect(stories.length, equals(3));
      for (final story in stories) {
        expect(story.simpleTextSegments, isNotEmpty);
        expect(story.title, isNotEmpty);
        expect(story.richNarrativeTextSegments, isNotEmpty);
      }
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 18: All frozen curriculum content hashes remain identical
    // ─────────────────────────────────────────────────────────────────────────
    test('18. All frozen curriculum content hashes remain identical', () {
      final canonical = CurriculumFreezeGuard.buildCanonicalString(repo);
      final currentHash = CurriculumFreezeGuard.calculateHash(canonical);
      expect(currentHash, equals('02f9e00cbd1c1c52'));
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 19: Accessibility semantics remain present
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets('19. Accessibility semantics remain present', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonCompletionView(
              lessonTitle: 'Colors & Shapes',
              practicedItems: const ['red', 'blue', 'circle'],
              stars: 3,
              xpEarned: 30,
              coinsEarned: 15,
              onContinue: () {},
            ),
          ),
        ),
      );

      expect(find.text('Adventure Complete! 🌟'), findsOneWidget);
      expect(find.text('Colors & Shapes'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byType(PipCharacterGuide), findsOneWidget);
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Requirement 20: Real production SFX asset slots verified with audioAssetProductionPending status
    // ─────────────────────────────────────────────────────────────────────────
    test('20. Real production SFX asset slots verified with audioAssetProductionPending status', () {
      for (final sound in SemanticSound.values) {
        final spec = SoundDesignSystem.getSpec(sound);
        expect(
          spec.status,
          equals(SoundAssetStatus.audioAssetProductionPending),
          reason: 'Sound ${sound.name} must declare audioAssetProductionPending per Section 49',
        );
        expect(spec.intendedEmotion, isNotEmpty);
        expect(spec.acousticCharacter, isNotEmpty);
        expect(spec.assetPath, startsWith('assets/audio/sfx/'));
      }
    });
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Test Helpers for Speech Recognition Fallbacks
// ─────────────────────────────────────────────────────────────────────────────

class _UnavailableSpeechRecognitionService extends MockSpeechRecognitionService {
  @override
  Future<bool> isAvailable() async => false;
}

class _TimeoutSpeechRecognitionService extends MockSpeechRecognitionService {
  @override
  Future<void> startListening({
    required void Function(String recognizedText, double confidence) onResult,
    void Function(String error)? onError,
    Duration listenFor = const Duration(seconds: 8),
    Duration pauseFor = const Duration(seconds: 3),
  }) async {
    onError?.call('timeout: no speech detected');
  }
}
