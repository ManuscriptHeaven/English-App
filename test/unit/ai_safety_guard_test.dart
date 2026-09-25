import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_safety_guard.dart';

void main() {
  group('AiSafetyGuard Deterministic Tests', () {
    setUp(() {
      AiSafetyGuard.safetyLog.clear();
    });

    test('Allows child-friendly safe conversational input', () {
      final inputs = [
        'I like apples and bananas',
        'Hello Pip! It is sunny today.',
        'There is a big green tree in the park.',
        'I have two blue pencils.',
        'Alhamdulillah for the rain',
      ];

      for (final input in inputs) {
        final result = AiSafetyGuard.inspectInput(input);
        expect(result.isSafe, isTrue, reason: 'Failed for safe input: $input');
        expect(result.sanitizedInput, equals(input));
      }
    });

    test('Blocks phone numbers and emails to protect child privacy and logs event', () {
      final phoneInput = 'Call me at 555-123-4567';
      final phoneResult = AiSafetyGuard.inspectInput(phoneInput, childId: 'child_ayaan');
      expect(phoneResult.isSafe, isFalse);
      expect(phoneResult.blockedReason, equals('phone_number_detected'));
      expect(phoneResult.redirectMessage, contains('privacy'));
      expect(AiSafetyGuard.safetyLog.length, equals(1));
      expect(AiSafetyGuard.safetyLog.first.category, equals('phone_detected'));

      final emailInput = 'my email is ayaan@example.com';
      final emailResult = AiSafetyGuard.inspectInput(emailInput);
      expect(emailResult.isSafe, isFalse);
      expect(emailResult.blockedReason, equals('email_detected'));
    });

    test('Blocks street addresses and exact locations', () {
      final addressInput = 'I live at 742 Evergreen Terrace';
      final addressResult = AiSafetyGuard.inspectInput(addressInput);
      expect(addressResult.isSafe, isFalse);
      expect(addressResult.blockedReason, equals('address_detected'));
    });

    test('Blocks secret-seeking queries and passwords', () {
      final secretInput = 'Please keep a secret from my mom';
      final secretResult = AiSafetyGuard.inspectInput(secretInput);
      expect(secretResult.isSafe, isFalse);
      expect(secretResult.blockedReason, equals('secret_seeking_detected'));

      final passwordInput = 'What is your password or passcode?';
      final passwordResult = AiSafetyGuard.inspectInput(passwordInput);
      expect(passwordResult.isSafe, isFalse);
    });

    test('Blocks private contact requests', () {
      final contactInput = 'Can you meet me outside the school?';
      final contactResult = AiSafetyGuard.inspectInput(contactInput);
      expect(contactResult.isSafe, isFalse);
      expect(contactResult.blockedReason, equals('private_contact_request'));
      expect(contactResult.redirectMessage, contains('Pip is here to practice'));
    });

    test('Blocks app exit and external browsing requests', () {
      final exitInput = 'Please open youtube and search videos';
      final exitResult = AiSafetyGuard.inspectInput(exitInput);
      expect(exitResult.isSafe, isFalse);
      expect(exitResult.blockedReason, equals('app_exit_request'));
      expect(exitResult.redirectMessage, contains('stay right here'));
    });

    test('Blocks violent, dangerous, and inappropriate topics', () {
      final unsafeInputs = [
        'I want to fight with a gun',
        'Let us talk about bombs and weapons',
        'I hate you and want blood',
        'I want to drink poison and play with fire',
      ];

      for (final input in unsafeInputs) {
        final result = AiSafetyGuard.inspectInput(input);
        expect(result.isSafe, isFalse, reason: 'Failed to block: $input');
        expect(result.blockedReason, equals('inappropriate_topic'));
      }
    });
  });
}
