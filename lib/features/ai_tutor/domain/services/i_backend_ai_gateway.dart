import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'i_ai_provider.dart';

/// Secure backend gateway contract shielding LLM vendor API keys from the client app.
abstract class IBackendAiGateway {
  Future<String> requestCompletion({
    required String prompt,
    required AiCurriculumContext context,
    int timeoutSeconds = 5,
  });

  Future<ChildResponseAnalysis> requestAnalysis({
    required String childResponse,
    required String targetPhrase,
    required AiCurriculumContext context,
  });
}
