import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../domain/models/achievement.dart';
import '../../domain/models/child_progress.dart';
import '../../domain/models/daily_mission.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../data/mock_progress_repository.dart';

final progressRepositoryProvider = Provider<IProgressRepository>((ref) {
  return MockProgressRepository();
});

final activeChildProgressProvider = FutureProvider<ChildProgress?>((ref) async {
  final activeChild = ref.watch(activeChildProfileProvider);
  if (activeChild == null) return null;
  final repo = ref.watch(progressRepositoryProvider);
  return repo.getProgressForChild(activeChild.id);
});

final activeChildAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final activeChild = ref.watch(activeChildProfileProvider);
  if (activeChild == null) return [];
  final repo = ref.watch(progressRepositoryProvider);
  return repo.getAchievementsForChild(activeChild.id);
});

final activeChildMissionsProvider = FutureProvider<List<DailyMission>>((ref) async {
  final activeChild = ref.watch(activeChildProfileProvider);
  if (activeChild == null) return [];
  final repo = ref.watch(progressRepositoryProvider);
  return repo.getDailyMissionsForChild(activeChild.id);
});
