import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';

/// Evaluation summary of a child's spoken or tapped response.
class ChildResponseAnalysis {
  final bool isAccurate;
  final double score; // 0.0 to 1.0
  final String encouragingFeedback;
  final String? suggestedCorrection;
  final String? nextQuestion;

  const ChildResponseAnalysis({
    required this.isAccurate,
    required this.score,
    required this.encouragingFeedback,
    this.suggestedCorrection,
    this.nextQuestion,
  });
}

/// Abstract AI Provider interface.
/// Encapsulates all LLM generation logic behind curriculum-controlled contracts.
abstract class IAiProvider {
  /// Generates a child-safe pedagogical response or follow-up question.
  Future<String> generateResponse({
    required String childInput,
    required AiCurriculumContext context,
    required List<String> recentTurnHistory,
  });

  /// Evaluates and corrects child pronunciation or grammar constructively.
  Future<ChildResponseAnalysis> analyzeChildResponse({
    required String childResponse,
    required String targetPhrase,
    required AiCurriculumContext context,
  });

  /// Generates a small practice variation of approved curriculum items.
  Future<String> generatePracticeVariation({
    required String baseSentence,
    required AiCurriculumContext context,
  });
}
