import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_conversation_turn.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';

/// Structured validation result produced after evaluating raw AI output.
class ValidationResult {
  final bool isValid;
  final String sanitizedResponse;
  final String safeFallback;
  final AiValidationStatus status;
  final String? failureReason;
  final String? reason;

  const ValidationResult({
    required this.isValid,
    required this.sanitizedResponse,
    required this.safeFallback,
    required this.status,
    this.failureReason,
    this.reason,
  });

  factory ValidationResult.pass(String response) => ValidationResult(
        isValid: true,
        sanitizedResponse: response,
        safeFallback: response,
        status: AiValidationStatus.passed,
        reason: 'Response passed all safety and curriculum validation rules.',
      );

  factory ValidationResult.fail({
    required AiValidationStatus status,
    required String reason,
    required String fallbackText,
  }) =>
      ValidationResult(
        isValid: false,
        sanitizedResponse: fallbackText,
        safeFallback: fallbackText,
        status: status,
        failureReason: reason,
        reason: reason,
      );
}

/// Deterministic post-processing validator inspecting every raw LLM response.
/// Ensures child safety, age-adapted response length, curriculum adherence, and Islamic authenticity.
class AiResponseValidator {
  // Disallowed phrases for unverified religious generation
  static final _unverifiedReligiousPatterns = [
    'the prophet said',
    'the prophet commanded',
    'according to hadith',
    'surah chapter',
    'fatwa',
    'it is haram to',
    'it is fard to',
    'scholars have ruled',
    'in the quran it says',
  ];

  static final _urlRegex = RegExp(r'https?://[^\s]+|www\.[^\s]+|\[.*?\]\(.*?\)');

  static final _unsafeOutputWords = [
    'suicide',
    'kill yourself',
    'gun',
    'weapon',
    'bomb',
    'naked',
    'sex',
    'porn',
    'drugs',
    'alcohol',
    'stupid',
    'ugly',
    'hate you',
  ];

  static final _externalAppInstructions = [
    'leave this app',
    'open your browser',
    'go to google',
    'search on youtube',
    'click this link',
    'visit website',
  ];

  /// Validates raw generated response against curriculum context and safety invariants.
  static ValidationResult validate({
    required String rawResponse,
    required AiCurriculumContext context,
    String defaultFallback = "That's wonderful! Let's practice our fun English words together! 🌟",
  }) {
    final trimmed = rawResponse.trim();
    if (trimmed.isEmpty) {
      return ValidationResult.fail(
        status: AiValidationStatus.fallbackApplied,
        reason: 'Empty response from AI',
        fallbackText: defaultFallback,
      );
    }

    final lower = trimmed.toLowerCase();

    // 1. External URLs and markdown links check
    if (_urlRegex.hasMatch(trimmed)) {
      return ValidationResult.fail(
        status: AiValidationStatus.rejectedSafety,
        reason: 'External link or URL detected in AI response',
        fallbackText: defaultFallback,
      );
    }

    // 2. Instructions to leave app
    for (final exitPhrase in _externalAppInstructions) {
      if (lower.contains(exitPhrase)) {
        return ValidationResult.fail(
          status: AiValidationStatus.rejectedSafety,
          reason: 'Direct instruction to leave app or visit external site detected',
          fallbackText: defaultFallback,
        );
      }
    }

    // 3. Unsafe / Inappropriate Content Check
    for (final unsafeWord in _unsafeOutputWords) {
      final pattern = RegExp('\\b${RegExp.escape(unsafeWord)}\\b', caseSensitive: false);
      if (pattern.hasMatch(lower)) {
        return ValidationResult.fail(
          status: AiValidationStatus.rejectedSafety,
          reason: 'Unsafe or inappropriate vocabulary detected: "$unsafeWord"',
          fallbackText: defaultFallback,
        );
      }
    }

    // 4. Excessive Repetition Check (e.g. repeated identical tokens 4+ times)
    final words = trimmed.split(RegExp(r'\s+'));
    if (words.length > 6) {
      final wordFreq = <String, int>{};
      for (final w in words) {
        final cleanW = w.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
        if (cleanW.length > 2) {
          wordFreq[cleanW] = (wordFreq[cleanW] ?? 0) + 1;
          if (wordFreq[cleanW]! >= 5) {
            return ValidationResult.fail(
              status: AiValidationStatus.rejectedSafety,
              reason: 'Excessive repetition detected in generated output',
              fallbackText: defaultFallback,
            );
          }
        }
      }
    }

    // 5. Length Validation by Age Bracket
    if (words.length > context.maxResponseWords) {
      return ValidationResult.fail(
        status: AiValidationStatus.rejectedLength,
        reason: 'Response length (${words.length} words) exceeds max allowed (${context.maxResponseWords}) for age ${context.childAgeGroup}',
        fallbackText: defaultFallback,
      );
    }

    // 6. Islamic Source Hallucination Check
    for (final pattern in _unverifiedReligiousPatterns) {
      if (lower.contains(pattern)) {
        bool isApproved = false;
        for (final val in context.approvedIslamicValues) {
          for (final phrase in val.approvedPhrases) {
            if (phrase.toLowerCase().contains(pattern)) {
              isApproved = true;
              break;
            }
          }
          if (isApproved) break;
        }

        if (!isApproved) {
          return ValidationResult.fail(
            status: AiValidationStatus.rejectedIslamicHallucination,
            reason: 'Unverified religious attribution or ruling detected: "$pattern"',
            fallbackText: "That's an important question! Let's ask a parent or teacher, and continue our English game! 🌟",
          );
        }
      }
    }

    // Clean formatting tags
    final cleanText = trimmed.replaceAll('*', '').replaceAll('"', '').trim();

    return ValidationResult.pass(cleanText);
  }
}
