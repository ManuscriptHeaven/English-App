import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_conversation_turn.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_mode.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/verified_value_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_response_validator.dart';

void main() {
  group('AiResponseValidator Tests', () {
    late AiCurriculumContext contextToddler; // Ages 3-4 (max 15 words)
    late AiCurriculumContext contextOlder; // Ages 9-10 (max 50 words)

    setUp(() {
      contextToddler = AiCurriculumContext.forChild(
        childAge: 4,
        currentWorldId: 'world_food',
        currentLessonId: 'activity_food_vocab',
        mode: AiMode.vocabularyTalk,
        targetSkill: SkillType.vocabulary,
        targetVocabulary: const ['apple', 'banana'],
        conversationObjective: 'Learn fruit names',
      );

      contextOlder = AiCurriculumContext.forChild(
        childAge: 10,
        currentWorldId: 'world_nature',
        currentLessonId: 'activity_weather_vocab',
        mode: AiMode.dailyEnglish,
        targetSkill: SkillType.speaking,
        targetVocabulary: const ['sun', 'rain', 'tree'],
        approvedIslamicValues: const [
          VerifiedValueContext(
            valueId: 'value_creation_gratitude',
            title: 'Gratitude for Creation',
            childFriendlyExplanation: 'Allah created beautiful trees and rain for us.',
            approvedPhrases: ['Alhamdulillah for creation', 'SubhanAllah beautiful flowers'],
            sourceType: 'quran_principle',
            sourceReference: 'Surah Ibrahim 14:7',
          ),
        ],
        conversationObjective: 'Discuss outdoor weather',
      );
    });

    test('Passes clean, concise response within age word limits', () {
      final response = 'The apple is sweet and red!';
      final result = AiResponseValidator.validate(
        rawResponse: response,
        context: contextToddler,
      );

      expect(result.isValid, isTrue);
      expect(result.status, equals(AiValidationStatus.passed));
      expect(result.sanitizedResponse, equals('The apple is sweet and red!'));
    });

    test('Rejects response exceeding age-bracket word limit', () {
      final longResponse = 'This is a wonderfully delicious red sweet juicy apple that we picked together yesterday in the big park!';
      final result = AiResponseValidator.validate(
        rawResponse: longResponse,
        context: contextToddler,
      );

      expect(result.isValid, isFalse);
      expect(result.status, equals(AiValidationStatus.rejectedLength));
      expect(result.failureReason, contains('exceeds max allowed'));
    });

    test('Rejects external links and URLs', () {
      final urlResponse = 'Learn more at https://example.com/games and play!';
      final result = AiResponseValidator.validate(
        rawResponse: urlResponse,
        context: contextOlder,
      );

      expect(result.isValid, isFalse);
      expect(result.status, equals(AiValidationStatus.rejectedSafety));
    });

    test('Rejects instructions to leave app or visit external sites', () {
      final exitResponse = 'Please leave this app and open your browser to find pictures.';
      final result = AiResponseValidator.validate(
        rawResponse: exitResponse,
        context: contextOlder,
      );

      expect(result.isValid, isFalse);
      expect(result.status, equals(AiValidationStatus.rejectedSafety));
      expect(result.failureReason, contains('Direct instruction to leave app'));
    });

    test('Rejects excessive token repetition', () {
      final repeatResponse = 'Apple apple apple apple apple apple fruit is healthy for you.';
      final result = AiResponseValidator.validate(
        rawResponse: repeatResponse,
        context: contextOlder,
      );

      expect(result.isValid, isFalse);
      expect(result.status, equals(AiValidationStatus.rejectedSafety));
      expect(result.failureReason, contains('Excessive repetition'));
    });

    test('Blocks unverified religious claims / Hadith invention with friendly redirect', () {
      final unverifiedReligiousResponse = 'The Prophet said you must eat three apples every morning.';
      final result = AiResponseValidator.validate(
        rawResponse: unverifiedReligiousResponse,
        context: contextOlder,
      );

      expect(result.isValid, isFalse);
      expect(result.status, equals(AiValidationStatus.rejectedIslamicHallucination));
      expect(result.failureReason, contains('Unverified religious attribution'));
      expect(result.sanitizedResponse, contains('ask a parent or teacher'));
    });

    test('Allows approved Islamic phrases from VerifiedValueContext', () {
      final approvedResponse = 'We say Alhamdulillah for creation when it rains!';
      final result = AiResponseValidator.validate(
        rawResponse: approvedResponse,
        context: contextOlder,
      );

      expect(result.isValid, isTrue);
      expect(result.status, equals(AiValidationStatus.passed));
    });
  });
}
