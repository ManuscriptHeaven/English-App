import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/telemetry/learning_telemetry_service.dart';

/// Singleton provider for child learning telemetry service.
final learningTelemetryServiceProvider = Provider<LearningTelemetryService>((ref) {
  return InMemoryLearningTelemetryService();
});
