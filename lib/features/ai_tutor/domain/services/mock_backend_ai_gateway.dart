import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'i_ai_provider.dart';
import 'i_backend_ai_gateway.dart';
import 'mock_ai_provider.dart';

/// Concrete mock backend AI gateway demonstrating client-to-gateway architecture.
class MockBackendAiGateway implements IBackendAiGateway {
  final IAiProvider _provider;

  MockBackendAiGateway({IAiProvider? provider}) : _provider = provider ?? const MockAiProvider();

  @override
  Future<String> requestCompletion({
    required String prompt,
    required AiCurriculumContext context,
    int timeoutSeconds = 5,
  }) async {
    return _provider.generateResponse(
      childInput: prompt,
      context: context,
      recentTurnHistory: const [],
    );
  }

  @override
  Future<ChildResponseAnalysis> requestAnalysis({
    required String childResponse,
    required String targetPhrase,
    required AiCurriculumContext context,
  }) async {
    return _provider.analyzeChildResponse(
      childResponse: childResponse,
      targetPhrase: targetPhrase,
      context: context,
    );
  }
}
