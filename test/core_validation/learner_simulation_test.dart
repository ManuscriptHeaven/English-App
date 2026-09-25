import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'simulation/deterministic_clock.dart';
import 'simulation/learning_simulation_harness.dart';
import 'simulation/simulated_learner.dart';

void main() {
  group('Long-Running Longitudinal Learner Simulations (Profiles A-E)', () {
    late Directory reportsDir;

    setUpAll(() {
      reportsDir = Directory('test/reports/core_validation');
      if (!reportsDir.existsSync()) {
        reportsDir.createSync(recursive: true);
      }
    });

    test('1. Profile A: Brand-New Learner simulation (100 interactions)', () async {
      final clock = DeterministicClock(DateTime(2026, 9, 10, 8, 0, 0));
      final harness = LearningSimulationHarness(clock: clock);
      final learner = SimulatedLearner.brandNew(
        id: 'child_ayaan_new',
        name: 'AyaanNew',
        age: 5,
        seed: 101,
      );

      final metrics = await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 100,
        hoursBetweenSessions: 12,
      );

      expect(metrics.totalAttempts, greaterThanOrEqualTo(100));
      expect(metrics.newWordCount, greaterThan(0));

      final reportJson = jsonEncode(metrics.toJsonSummary());
      File('${reportsDir.path}/new_learner.json').writeAsStringSync(reportJson);
    });

    test('2. Profile B: Struggling Learner simulation (200 interactions)', () async {
      final clock = DeterministicClock(DateTime(2026, 9, 10, 8, 0, 0));
      final harness = LearningSimulationHarness(clock: clock);
      final learner = SimulatedLearner.struggling(
        id: 'child_maryam_struggling',
        name: 'MaryamStruggling',
        age: 4,
        seed: 202,
      );

      final metrics = await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 200,
        hoursBetweenSessions: 8,
      );

      expect(metrics.totalAttempts, greaterThanOrEqualTo(200));
      // Struggling learner should trigger confidence guardian interventions
      expect(metrics.confidenceEvents.length, greaterThan(0));
      // Difficulty should predominantly be support or easy
      final supportCount = metrics.difficultyTiers['support'] ?? 0;
      final easyCount = metrics.difficultyTiers['easy'] ?? 0;
      expect(supportCount + easyCount, greaterThan(0));

      final reportJson = jsonEncode(metrics.toJsonSummary());
      File('${reportsDir.path}/struggling_learner.json').writeAsStringSync(reportJson);
    });

    test('3. Profile C: Average Learner simulation (300 interactions)', () async {
      final clock = DeterministicClock(DateTime(2026, 9, 10, 8, 0, 0));
      final harness = LearningSimulationHarness(clock: clock);
      final learner = SimulatedLearner.average(
        id: 'child_zayd_avg',
        name: 'ZaydAverage',
        age: 6,
        seed: 303,
      );

      final metrics = await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 300,
        hoursBetweenSessions: 12,
      );

      expect(metrics.totalAttempts, greaterThanOrEqualTo(300));
      expect(metrics.accuracy, inInclusiveRange(0.60, 0.85));
      expect(metrics.conceptsFamiliarCount, greaterThan(0));

      final reportJson = jsonEncode(metrics.toJsonSummary());
      File('${reportsDir.path}/average_learner.json').writeAsStringSync(reportJson);
    });

    test('4. Profile D: Fast Learner simulation (500 interactions)', () async {
      final clock = DeterministicClock(DateTime(2026, 9, 10, 8, 0, 0));
      final harness = LearningSimulationHarness(clock: clock);
      final learner = SimulatedLearner.fast(
        id: 'child_ayaan_fast',
        name: 'AyaanFast',
        age: 7,
        seed: 404,
      );

      final metrics = await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 500,
        hoursBetweenSessions: 12,
      );

      expect(metrics.totalAttempts, greaterThanOrEqualTo(500));
      expect(metrics.accuracy, greaterThanOrEqualTo(0.90));
      expect(metrics.conceptsMasteredCount, greaterThan(0));
      // Should reach challenge tier
      expect(metrics.difficultyTiers['challenge'] ?? 0, greaterThan(0));

      final reportJson = jsonEncode(metrics.toJsonSummary());
      File('${reportsDir.path}/fast_learner.json').writeAsStringSync(reportJson);

      // Export representative trajectories CSV
      File('${reportsDir.path}/mastery_trajectories.csv').writeAsStringSync(metrics.toTrajectoriesCsv());
    });

    test('5. Profile E: Returning Learner simulation with time jumps (100 interactions)', () async {
      final clock = DeterministicClock(DateTime(2026, 9, 10, 8, 0, 0));
      final harness = LearningSimulationHarness(clock: clock);
      final learner = SimulatedLearner.returning(
        id: 'child_zayd_returning',
        name: 'ZaydReturning',
        age: 6,
        seed: 505,
      );

      // 1. Initial 20 interactions
      await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 20,
        hoursBetweenSessions: 12,
      );

      // 2. Big time jump: child takes a 2-week break!
      clock.advanceWeeks(2);

      // 3. Resumes learning: overdue items should be scheduled and reinforced
      final metrics = await harness.simulateInteractions(
        learner: learner,
        targetInteractions: 100,
        hoursBetweenSessions: 12,
      );

      expect(metrics.totalAttempts, greaterThanOrEqualTo(100));
      expect(metrics.reviewWordCount, greaterThan(0));

      final reportJson = jsonEncode(metrics.toJsonSummary());
      File('${reportsDir.path}/returning_learner.json').writeAsStringSync(reportJson);
    });
  });
}
